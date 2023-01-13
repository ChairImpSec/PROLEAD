#include "Software/mulator/arm_functions.h"
#include "Software/mulator/emulator.h"
#include "Software/mulator/mnemonics.h"

#include "Software/Operators.hpp"

#include <cstdlib>
#include <iostream>
#include <omp.h>


using namespace mulator;

#define cpu m_cpu_state
#define ADVANCE_PC                                       \
    if (increment_pc && m_return_code == ReturnCode::OK) \
        write_register_internal(Register::PC, cpu.registers[PC] + instr.size);

#define UPDATE_PSR m_psr_updated = true;

#define CHECK_SHIFT(X)                                      \
    if (!X)                                                 \
    {                                                       \
        m_return_code = ReturnCode::INVALID_SHIFT_ARGUMENT; \
        return false;                                       \
    }
#define CHECK_IMM(X)                                   \
    if (!X)                                            \
    {                                                  \
        m_return_code = ReturnCode::INVALID_IMMEDIATE; \
        return false;                                  \
    }

bool mixed_sign_equals(const int64_t a, const uint64_t b) { 
  // They can't be equal if 'a' is negative. 
  return a >= 0 && uint64_t(a) == b; 
} 

using OperandType = Instruction::OperandType;

bool Emulator::in_IT_block() const
{
    if (m_decoder.get_architecture() == Architecture::ARMv6M)
    {
        return false;
    }

    return _4BIT(cpu.psr.it_state) != 0;
}

bool Emulator::last_in_IT_block() const
{
    if (m_decoder.get_architecture() == Architecture::ARMv6M)
    {
        return false;
    }
    return _4BIT(cpu.psr.it_state) == 0b1000;
}

Condition Emulator::pop_IT_condition()
{
    Condition c = (Condition)(cpu.psr.it_state >> 4);
    if (_3BIT(cpu.psr.it_state) == 0)
    {
        cpu.psr.it_state = 0;
    }
    else
    {
        cpu.psr.it_state = (cpu.psr.it_state & 0xE0) | ((cpu.psr.it_state << 1) & 0x1F);
    }
    UPDATE_PSR
    return c;
}

bool Emulator::evaluate_condition(const Instruction& instr)
{
    bool result = false;

    Condition condition = instr.condition;

    if (in_IT_block())
    {
        condition = pop_IT_condition();
    }

    // Evaluate base condition.
    switch (condition >> 1)
    {
        case 0b000:
            result = cpu.psr.Z;
            break;    // EQ or NE
        case 0b001:
            result = cpu.psr.C;
            break;    // CS or CC
        case 0b010:
            result = cpu.psr.N;
            break;    // MI or PL
        case 0b011:
            result = cpu.psr.V;
            break;    // VS or VC
        case 0b100:
            result = cpu.psr.C && !cpu.psr.Z;
            break;    // HI or LS
        case 0b101:
            result = cpu.psr.N == cpu.psr.V;
            break;    // GE or LT
        case 0b110:
            result = cpu.psr.N == cpu.psr.V && !cpu.psr.Z;
            break;    // GT or LE
        case 0b111:
            result = true;
            break;    // AL, condition flag values in the set '111x' indicate the instruction is always executed.
    }

    // Otherwise, invert condition if necessary.
    if ((condition & 1) == 1)
    {
        result = !result;
    }

    if (condition == 0b1111)
    {
        m_return_code = ReturnCode::UNSUPPORTED;
        return false;
    }

    return result;
}

void Emulator::branch_write_PC(u32 address)
{
    write_register_internal(Register::PC, address & 0xFFFFFFFE);
}

void Emulator::bx_write_PC(u32 address)
{
    if ((address & 1) == 0)
    {
        m_return_code = ReturnCode::HARD_FAULT;
        return;
    }
    write_register_internal(Register::PC, address & 0xFFFFFFFE);
}

void Emulator::blx_write_PC(u32 address)
{
    bx_write_PC(address);
}

bool Emulator::exclusive_monitors_pass(u32 address, u32 align) const
{
    UNUSED(align);
    return address == m_cpu_state.exclusive_address;
}

void Emulator::set_exclusive_monitors(u32 address, u32 align)
{
    if (arm_functions::align(address, align) != address)
    {
        m_return_code = ReturnCode::INVALID_ALIGNMENT;
        return;
    }
    m_cpu_state.exclusive_address = address;
}

bool Emulator::in_priviledged_mode() const
{
    return true;
}

i32 Emulator::get_execution_priority() const
{
    return 0;
}

void Emulator::check_shadow_register_constraints(uint32_t& next_shadow_register_value, Software::ThreadSimulationStruct& ThreadSimulation, uint32_t address, uint8_t bytes)
{
    uint32_t memory_values_not_consider = 0;

    //check if read memory address contains global input range -> if yes do not consider the specific bytes
    for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
        if(((address-(4-bytes)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-bytes)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
            memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-bytes));
            break;
        }
    }
    uint32_t shadow_address = (address-(4-bytes));
                    
    //shadow address it not out of bounds
    if(((shadow_address > m_ram.offset) && (shadow_address < (m_ram.offset + m_ram.size))) || ((shadow_address > m_flash.offset) && (shadow_address < (m_flash.offset + m_flash.size)))){
        next_shadow_register_value = (((read_memory_internal(shadow_address, 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
    }
    else{ //shadow address is out of bounds
        if(shadow_address < m_ram.offset){
            next_shadow_register_value = read_memory_internal(m_ram.offset, 4) << (8*(4-bytes));
        }
        else if(shadow_address < m_flash.offset){
            next_shadow_register_value = read_memory_internal(m_flash.offset, 4) << (8*(4-bytes));
        }
    }
    SwapEndian(next_shadow_register_value);
}

bool Emulator::execute_PROLEAD(const Instruction& instr, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, bool InTestClockCycles, bool& MemoryOperation, const int InstrNr, const uint64_t SimulationIdx, const uint32_t randomness_start_addr, const uint32_t randomness_end_addr)
{
    m_psr_updated             = false;
    bool instruction_executed = false;
    bool increment_pc         = true;
    if (instr.name == Mnemonic::ADC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADD || instr.name == Mnemonic::ADDW)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, 0);
            if (instr.Rd == Register::PC)
            {
                cpu.registers[PC] = result & ~((u32)1);
                increment_pc      = false;
            }
            else
            {
                write_register_internal(instr.Rd, result);
                if (instr.flags.S)
                {
                    cpu.psr.N = result >> 31;
                    cpu.psr.Z = (result == 0);
                    cpu.psr.C = carry;
                    cpu.psr.V = overflow;
                    UPDATE_PSR
                }
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::AND || instr.name == Mnemonic::BIC || instr.name == Mnemonic::EOR || instr.name == Mnemonic::ORR || instr.name == Mnemonic::ORN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg = read_register_internal(instr.Rn);

            u32 result;
            if (instr.name == Mnemonic::AND)
            {
                result = reg & value;
            }
            else if (instr.name == Mnemonic::BIC)
            {
                result = reg & ~value;
            }
            else if (instr.name == Mnemonic::EOR)
            {
                result = reg ^ value;
            }
            else if (instr.name == Mnemonic::ORR)
            {
                result = reg | value;
            }
            else    // if (instr.name == Mnemonic::ORN)
            {
                result = reg | ~value;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ASR || instr.name == Mnemonic::LSL || instr.name == Mnemonic::LSR || instr.name == Mnemonic::ROR)
    {
        if (evaluate_condition(instr))
        {
            u32 amount = 0;
            u32 base;
            if (instr.uses_only_registers())
            {
                {
                    u32 reg = read_register_internal(instr.Rm);

                    amount = reg & 0xFF;
                }
                {
                    u32 reg = read_register_internal(instr.Rn);

                    base = reg;
                }
            }
            else
            {
                amount = instr.shift_amount;

                u32 reg = read_register_internal(instr.Rm);

                base = reg;
            }
            auto [shift_ok, result, carry] = arm_functions::shift_c(base, instr.shift_type, amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RRX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);

            auto [shift_ok, result, carry] = arm_functions::shift_c(reg, ShiftType::RRX, 1, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDR || instr.name == Mnemonic::LDRT || instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRB
             || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
    {
        if (evaluate_condition(instr))
        {
            u8 bytes = 4;
            if (instr.name == Mnemonic::LDRB || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
            {
                bytes = 2;
            }

            if (instr.operand_type == OperandType::RI)
            {
                u32 reg = read_register_internal(Register::PC);

                u32 address = arm_functions::align(reg, 4);
                address += ((instr.flags.add) ? instr.imm : -instr.imm);
                u32 result = read_memory_internal(address, bytes);

                

                /**
                 * @brief overwrite shadow register with new value
                 * 
                 */

                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);                    

                    //generate probe from shadow register
                    if(InTestClockCycles){
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);

                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() +  (uint8_t)(!Helper.HorizontalProbesExcluded.at(17)));

                        Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);
                        
                        if(!Helper.HorizontalProbesExcluded.at(17)){
                            Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                        }

                    }

                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = InstrNr;
                }

                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSH)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }
                write_register_internal(instr.Rd, result);


                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                    write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                }

                

            }
            else
            {
                u32 offset_address = 0;

                u32 address = read_register_internal(instr.Rn);

                if (instr.uses_only_registers())
                {
                    auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                    CHECK_SHIFT(shift_ok);
                    address += shifted;
                }
                else
                {
                    offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                    if (instr.flags.index)
                    {
                        address = offset_address;
                    }
                }

                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

                if (!ignore_alignment && arm_functions::align(address, bytes) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }

                u32 result = read_memory_internal(address, bytes);
                /**
                 * @brief generate probe from shadow register
                 * 
                 */
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);
                    
        
                    if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + (uint8_t)(!Helper.HorizontalProbesExcluded.at(17)));
                        Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                        if(!Helper.HorizontalProbesExcluded.at(17)){
                            Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                        }

                    }

                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = InstrNr;
                }


                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }

                write_register_internal(instr.Rd, result);


                if (instr.flags.wback)
                {
                    write_register_internal(instr.Rn, offset_address);

                }


                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){                          
                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                }

                

            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MUL)
    {
        if (evaluate_condition(instr))
        {
            u32 result = read_register_internal(instr.Rn) * read_register_internal(instr.Rm);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STR || instr.name == Mnemonic::STRT || instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT || instr.name == Mnemonic::STRB
             || instr.name == Mnemonic::STRBT)
    {
        if (evaluate_condition(instr))
        {
            u32 offset_addr = 0;

            u32 address = read_register_internal(instr.Rn);

            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                address += shifted;
            }
            else
            {
                offset_addr = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                if (instr.flags.index)
                {
                    address = offset_addr;
                }
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::STRB || instr.name == Mnemonic::STRBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT)
            {
                bytes = 2;
            }

            bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

            if (!ignore_alignment && arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            /**
             * @brief memory probing
             * 
             */
            uint32_t old_mem_value = read_memory_internal(address, bytes);

            
            //has nothing to do with memory probing
            write_memory_internal(address, read_register_internal(instr.Rd), bytes);


            /**
             * @brief memory probing
             * 
             */

            uint32_t new_mem_value = read_memory_internal(address, bytes);

            if(InTestClockCycles && Helper.ProbeMemory){
                // Normal Probes on a single bit of a register

                uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ThreadSimulation.TestTransitional);
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);
                    ProbeIndex++;
                }
                

            }


            /**
             * @brief generate probe from shadow register
             * 
             */

            if(Helper.ProbeMemoryShadowRegister){
                if(InTestClockCycles){
                    uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + (uint8_t)(!Helper.HorizontalProbesExcluded.at(17)));
                    Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal(instr.Rd), ProbeTracker.MemoryLatestClockCycle);

                    if(!Helper.HorizontalProbesExcluded.at(17)){
                        Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex,0, m_memory_shadow_register, read_register_internal(instr.Rd), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                    }
                }

                //overwrite shadow register with new value
                m_memory_shadow_register = read_register_internal(instr.Rd);
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
            }


            
            
            MemoryOperation = true;

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_addr);
            }
            instruction_executed = true;


        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SUB || instr.name == Mnemonic::SUBW)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RSB)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(~reg, value, 1);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, value, 0);
            cpu.psr.N                      = result >> 31;
            cpu.psr.Z                      = (result == 0);
            cpu.psr.C                      = carry;
            cpu.psr.V                      = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMP)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            cpu.psr.V = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MOV || instr.name == Mnemonic::MOVW || instr.name == Mnemonic::MOVT)
    {
        if (evaluate_condition(instr))
        {
            if (instr.Rd == Register::PC)
            {
                u32 reg = read_register_internal(instr.Rm);
                branch_write_PC(reg);
            }
            else
            {
                
                u32 value = 0;
                u8 carry  = cpu.psr.C;

                if (instr.name == Mnemonic::MOVW)
                {
                    value = instr.imm;
                }
                else if (instr.name == Mnemonic::MOVT)
                {
                    u32 reg = read_register_internal(instr.Rd);
                    value   = (reg & 0xFFFF) | (instr.imm << 16);
                }
                else if (instr.uses_only_registers())
                {
                    u32 reg = read_register_internal(instr.Rm);
                    value   = reg;
                }
                else
                {
                    auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, carry);
                    CHECK_IMM(imm_ok);
                    value = v;
                    carry = c;
                }
                write_register_internal(instr.Rd, value);
                if (instr.flags.S)
                {
                    cpu.psr.N = value >> 31;
                    cpu.psr.Z = (value == 0);
                    cpu.psr.C = carry;
                    UPDATE_PSR
                }

            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MVN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, v, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = v;
                carry = c;
            }
            else
            {
                auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = v;
                carry = c;
            }

            u32 result = ~value;
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RBIT)
    {
        if (evaluate_condition(instr))
        {
            u32 n = read_register_internal(instr.Rm);

            // reverse bits in 32-bit integer
            n = ((n >> 1) & 0x55555555) | ((n << 1) & 0xaaaaaaaa);
            n = ((n >> 2) & 0x33333333) | ((n << 2) & 0xcccccccc);
            n = ((n >> 4) & 0x0f0f0f0f) | ((n << 4) & 0xf0f0f0f0);
            n = ((n >> 8) & 0x00ff00ff) | ((n << 8) & 0xff00ff00);
            n = ((n >> 16) & 0x0000ffff) | ((n << 16) & 0xffff0000);

            write_register_internal(instr.Rd, n);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 24) | ((val & 0xFF00) << 8) | ((val & 0xFF0000) >> 8) | ((val >> 24) & 0xFF);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV16)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 8) | ((val & 0xFF00) >> 8) | ((val & 0xFF0000) << 8) | ((val & 0xFF000000) >> 8);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REVSH)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = arm_functions::sign_extend(((val & 0xFF) << 8) | ((val & 0xFF00) >> 8), 16);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SXTB || instr.name == Mnemonic::SXTH || instr.name == Mnemonic::UXTB || instr.name == Mnemonic::UXTH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                  = read_register_internal(instr.Rm);
            auto [shift_ok, rotated] = arm_functions::ROR(reg, instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            if (instr.name == Mnemonic::SXTB)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFF, 8));
            }
            else if (instr.name == Mnemonic::SXTH)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFFFF, 16));
            }
            else if (instr.name == Mnemonic::UXTB)
            {
                write_register_internal(instr.Rd, rotated & 0xFF);
            }
            else    // UXTH
            {
                write_register_internal(instr.Rd, rotated & 0xFFFF);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TST)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }
            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg & value;
            cpu.psr.N  = result >> 31;
            cpu.psr.Z  = (result == 0);
            cpu.psr.C  = carry;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADR)
    {
        if (evaluate_condition(instr))
        {
            u32 reg   = read_register_internal(PC);
            u32 value = arm_functions::align(reg, 4);
            value += (instr.flags.add) ? instr.imm : -instr.imm;
            write_register_internal(instr.Rd, value);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }
            u32 cnt = 0;
            uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
            uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
            if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                uint8_t hw = 0;
                for(u32 i = 0; i < 15; ++i){
                    hw += ((instr.imm >> i) & 1);
                }
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + hw * Helper.MemoryShadowRegisterProbesIncluded.size() + hw * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))) );
                OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + hw * Helper.MemoryShadowRegisterProbesIncluded.size();
            }


            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    /**
                     * @brief shadow register probing
                     * 
                     */
                    
                    if(Helper.ProbeMemoryShadowRegister){
                        uint32_t memory_values_not_consider = 0;

                        //check if read memory address contains global input range -> if yes do not consider the specific bytes
                        for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                            if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                                memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                                break;
                            }
                        }
                        uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                        SwapEndian(next_shadow_register_value);

                        if(InTestClockCycles){
                            
                            uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                            Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                            if(!Helper.HorizontalProbesExcluded.at(17)){
                                Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                            }

                        }

                        //overwrite shadow register with new value
                        m_memory_shadow_register = next_shadow_register_value;
                        
                    }

                    //if randomness memory segment was accessed update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    }

                    
                    address += 4;
                    cnt++;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = InstrNr;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;

            }
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 cnt = 0;

            //MemoryProbing
            uint8_t OldMemoryProbeCounter = 17;
            uint8_t NewMemoryProbeCounter = 18;
            uint8_t consecutive_stores = 0;

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    uint32_t old_mem_value = read_memory_internal(address, 4);

                    write_memory_internal(address, read_register_internal((Register)i), 4);
                   
                    //MemoryProbing

                    uint32_t new_mem_value = read_memory_internal(address, 4);

                    if(InTestClockCycles && Helper.ProbeMemory){
                        // Normal Probes on a single bit of a register
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                        for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));

                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);

                            ProbeIndex++;
                        }

                    }

                    

                    OldMemoryProbeCounter += 2;
                    NewMemoryProbeCounter += 2;
                    consecutive_stores++;


                    address += 4;
                    cnt++;
                }
            }


            /**
             * @brief shadow register probing
             * 
             */
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t ProbeIndex = 0;
                uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
                if(InTestClockCycles ){
                    ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() * consecutive_stores +  consecutive_stores * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + consecutive_stores * Helper.MemoryShadowRegisterProbesIncluded.size();
                }
                for(u32 i = 0; i < 15; ++i){
                    if(((instr.imm >> i) & 1)){
                        if(InTestClockCycles){
                            uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                            Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle);

                            if(!Helper.HorizontalProbesExcluded.at(17)){
                                Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                            }
                        }
                        //overwrite shadow register with new value
                        m_memory_shadow_register = read_register_internal((Register)i);
                    }
                }
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
            }



            MemoryOperation = true;
            
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CBZ || instr.name == Mnemonic::CBNZ)
    {
        u32 value = read_register_internal(instr.Rn);
        if ((instr.name == Mnemonic::CBZ && value == 0) || (instr.name == Mnemonic::CBNZ && value != 0))
        {
            branch_write_PC(read_register_internal(PC) + instr.imm);
            increment_pc = false;
        }
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BLX)
    {
        if (evaluate_condition(instr))
        {
            write_register_internal(LR, (read_register_internal(PC) - 2) | 1);
            blx_write_PC(read_register_internal(instr.Rm));
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);
            bx_write_PC(reg);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::B)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            branch_write_PC(reg + instr.imm);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            write_register_internal(LR, reg | 1);
            branch_write_PC(reg + instr.imm);

            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::POP)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);
            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 end_val = address + arm_functions::bit_count(instr.imm) * 4;

            uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
            uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
            if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                uint8_t hw = 0;
                for(u32 i = 0; i < 15; ++i){
                    hw += ((instr.imm >> i) & 1);
                }
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + hw * Helper.MemoryShadowRegisterProbesIncluded.size() + hw * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + hw * Helper.MemoryShadowRegisterProbesIncluded.size();
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    /**
                     * @brief shadow register probing
                     * 
                     */
                    if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle);

                        if(!Helper.HorizontalProbesExcluded.at(17)){
                            Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, (read_register_internal((Register)i)), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                        }
                    }  
                    //overwrite shadow register with new value
                    m_memory_shadow_register = (read_register_internal((Register)i));

                    address += 4;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = InstrNr;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }

            write_register_internal(SP, end_val);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::PUSH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);

            address -= arm_functions::bit_count(instr.imm) * 4;

            u32 end_val = address;

            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            
            //used for memory Probing
            uint8_t OldMemoryProbeCounter = 17;
            uint8_t NewMemoryProbeCounter = 18;
            uint8_t consecutive_stores = 0;

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg1 = read_register_internal((Register)i);

                    //used for memory probing
                    uint32_t old_mem_value = read_memory_internal(address, 4);

                    write_memory_internal(address, reg1, 4);

                    //memory probing  
                    uint32_t new_mem_value = read_memory_internal(address, 4);

                    if(InTestClockCycles && Helper.ProbeMemory){
                        // Normal Probes on a single bit of a register
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                        for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);
                            ProbeIndex++;
                        }

                    }
                    

                    OldMemoryProbeCounter += 2;
                    NewMemoryProbeCounter += 2;
                    consecutive_stores++;

                    address += 4;
                }
            }

            /**
             * @brief shadow register probing
             * 
             */
            if( Helper.ProbeMemoryShadowRegister){
                uint32_t ProbeIndex = 0;
                uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
                if(InTestClockCycles){
                    ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() * consecutive_stores + consecutive_stores * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + consecutive_stores * Helper.MemoryShadowRegisterProbesIncluded.size();
                }

                for(u32 i = 0; i < 15; ++i){
                    if(((instr.imm >> i) & 1)){
                        if(InTestClockCycles){
                            uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (i << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                            Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle);

                            if(!Helper.HorizontalProbesExcluded.at(17)){
                                Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                            }
                        }
                        //overwrite shadow register with new value
                        m_memory_shadow_register = read_register_internal((Register)i);
                    }
                }
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
            }

            MemoryOperation = true;
            
            write_register_internal(SP, end_val);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::IT && m_decoder.get_architecture() >= Architecture::ARMv7M)
    {
        cpu.psr.it_state = instr.imm;
        UPDATE_PSR
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::NOP || instr.name == Mnemonic::SEV || instr.name == Mnemonic::DSB || instr.name == Mnemonic::ISB || instr.name == Mnemonic::DMB || instr.name == Mnemonic::CSDB
             || instr.name == Mnemonic::DBG || instr.name == Mnemonic::CLREX || instr.name == Mnemonic::SSBB || instr.name == Mnemonic::PSSBB || instr.name == Mnemonic::PLD
             || instr.name == Mnemonic::PLI)
    {
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDF)
    {
        m_return_code = ReturnCode::UNDEFINED;
        return false;
    }
    else if (instr.name == Mnemonic::STMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            //used for memory probing
            uint8_t OldMemoryProbeCounter = 17;
            uint8_t NewMemoryProbeCounter = 18;
            uint8_t consecutive_stores = 0;

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg = read_register_internal((Register)i);

                    //used for memory probing
                    uint32_t old_mem_value = read_memory_internal(address, 4);
                
                    write_memory_internal(address, reg, 4);

                    //MemoryProbing
                    uint32_t new_mem_value = reg;

                    if(InTestClockCycles && Helper.ProbeMemory){
                        // Normal Probes on a single bit of a register
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((i) << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                        for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));

                            ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);

                            ProbeIndex++;
                        }
                    }
                    
                    OldMemoryProbeCounter += 2;
                    NewMemoryProbeCounter += 2;
                    consecutive_stores++;

                    address += 4;
                }
            }

            /**
             * @brief shadow register probing
             * 
             */
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t ProbeIndex = 0;
                uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
                if(InTestClockCycles){
                    ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() * consecutive_stores + consecutive_stores * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + consecutive_stores * Helper.MemoryShadowRegisterProbesIncluded.size();
                }
                for(u32 i = 0; i < 15; ++i){
                    if(((instr.imm >> i) & 1)){
                        
                        if(InTestClockCycles){
                            uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (i << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                            Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle);

                            if(!Helper.HorizontalProbesExcluded.at(17)){
                                Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, read_register_internal((Register)i), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                            }
                        }
                        //overwrite shadow register with new value
                        m_memory_shadow_register = read_register_internal((Register)i);
                    }
                }
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
            }


            MemoryOperation = true;
            
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, end_val);
            }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
            uint32_t OffsetShadowProbeToHorizontalShadowProbe = 0;
            if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                uint8_t hw = 0;
                for(u32 i = 0; i < 15; ++i){
                    hw += ((instr.imm >> i) & 1);
                }
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + hw * Helper.MemoryShadowRegisterProbesIncluded.size() + hw * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + hw * Helper.MemoryShadowRegisterProbesIncluded.size();
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    //if randomness was used update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    }

                    /**
                     * @brief shadow register probing
                     * 
                     */
                    if(Helper.ProbeMemoryShadowRegister){
                        uint32_t memory_values_not_consider = 0;

                        //check if read memory address contains global input range -> if yes do not consider the specific bytes
                        for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                            if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                                memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                                break;
                            }
                        }
                        uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                        SwapEndian(next_shadow_register_value);

                        if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                            uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (i << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                            Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                            if(!Helper.HorizontalProbesExcluded.at(17)){
                                Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, i, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                            }

                        }

                        //overwrite shadow register with new value
                        m_memory_shadow_register = next_shadow_register_value;
                        
                    }


                    address += 4;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = InstrNr;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));

                increment_pc = false;
            }

            if (instr.flags.wback && _1BIT(instr.imm > instr.Rn) != 0)
            {
                write_register_internal(instr.Rn, end_val);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address        = read_register_internal(instr.Rn);
            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            //used for memory probing
            uint32_t old_mem_value = read_memory_internal(address, 4);

            write_memory_internal(address, read_register_internal(instr.Rd), 4);

            // memory probing  
            uint32_t new_mem_value = read_memory_internal(address, 4);

            if(InTestClockCycles && Helper.ProbeMemory){
                // Normal Probes on a single bit of a register
                uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ThreadSimulation.TestTransitional);
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);

                    ProbeIndex++;
                }

            }

            //used for memory probing
            old_mem_value = read_memory_internal(address + 4, 4);

            write_memory_internal(address + 4, read_register_internal(instr.Rm), 4);

            //memory probing  

            new_mem_value = read_memory_internal(address + 4, 4);

            if(InTestClockCycles && Helper.ProbeMemory){
                uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size());
                for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));

                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);

                    ProbeIndex++;
                }

            }

            /**
             * @brief shadow register probing
             * 
             */
            uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
            uint32_t OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + 2 * Helper.MemoryShadowRegisterProbesIncluded.size();
 	        if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                
                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + 2 * Helper.MemoryShadowRegisterProbesIncluded.size() + 2 * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal(instr.Rd), ProbeTracker.MemoryLatestClockCycle);

                if(!Helper.HorizontalProbesExcluded.at(17)){
                    Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, 0, m_memory_shadow_register, read_register_internal(instr.Rd), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                }
            }

            //overwrite shadow register with new value
            m_memory_shadow_register = read_register_internal(instr.Rd);



            //second shadow register probing

 	        if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){

                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal(instr.Rm), ProbeTracker.MemoryLatestClockCycle);

                if(!Helper.HorizontalProbesExcluded.at(17)){
                    Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, 1, m_memory_shadow_register, read_register_internal(instr.Rm), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                }
            }

            //overwrite shadow register with new value
            m_memory_shadow_register = read_register_internal(instr.Rm);
            ProbeTracker.MemoryLatestClockCycle = InstrNr;

            MemoryOperation = true;

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            if (instr.operand_type == OperandType::RRI)    // LDRD (literal)
            {
                address = arm_functions::align(address, 4);
            }

            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);

            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_register_internal(instr.RdHi, read_memory_internal(address, 4));

            /**
             * @brief shadow register probing
             * 
             */
            
            uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
            uint32_t OffsetShadowProbeToHorizontalShadowProbe = ProbeIndex + 2 * Helper.MemoryShadowRegisterProbesIncluded.size();
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t memory_values_not_consider = 0;

                //check if read memory address contains global input range -> if yes do not consider the specific bytes
                for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                    if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                        memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                        break;
                    }
                }
                uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                SwapEndian(next_shadow_register_value);

                if(InTestClockCycles){
                    
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + 2 * Helper.MemoryShadowRegisterProbesIncluded.size() + 2 * ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                    if(!Helper.HorizontalProbesExcluded.at(17)){
                        Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                    }
                }

                //overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
            }

            //if randomness was used update it
            if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
            }
        
            write_register_internal(instr.RdLo, read_memory_internal(address + 4, 4));


            /**
             * @brief second shadow register probing
             * 
             */
            
            if(Helper.ProbeMemory){
                uint32_t memory_values_not_consider = 0;

                //check if read memory address contains global input range -> if yes do not consider the specific bytes
                for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                    if(((address + 4-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address + 4-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                        memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address + 4-(4-4));
                        break;
                    }
                }
                uint32_t next_shadow_register_value = (((read_memory_internal(address + 4 -(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                SwapEndian(next_shadow_register_value);
                if(InTestClockCycles){
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << REG1_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                    Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                    if(!Helper.HorizontalProbesExcluded.at(17)){
                        Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, OffsetShadowProbeToHorizontalShadowProbe, 1, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                    }
                }

                //overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
            }


            ProbeTracker.MemoryLatestClockCycle = InstrNr;
            //if randomness was used update it
            if((randomness_start_addr <= (address+4)) && ((address+4) < randomness_end_addr)){
                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
            }

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STREX || instr.name == Mnemonic::STREXB || instr.name == Mnemonic::STREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::STREX)
            {
                address += instr.imm;
            }

            u32 bytes = 4;
            if (instr.name == Mnemonic::STREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            if (exclusive_monitors_pass(address, bytes))
            {
                //used for memory probing
                uint32_t old_mem_value = read_memory_internal(address, bytes);

                write_memory_internal(address, read_register_internal(instr.Rm), bytes);

                //memory probing  
                
                uint32_t new_mem_value = read_memory_internal(address, bytes);

                if(InTestClockCycles && Helper.ProbeMemory){
                    // Normal Probes on a single bit of a register
                    uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ThreadSimulation.TestTransitional);
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryProbesIncluded.size() + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    for(const auto& BitIdx: Helper.MemoryProbesIncluded){
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).ProbeInfo = (ProbeInfo | (BitIdx << BIT_OFFSET));
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).at(ProbeIndex).TransitionCycles = (static_cast<uint64_t>((old_mem_value >> BitIdx) & 1)) | (((new_mem_value >> BitIdx) & 1) << 1);

                        ProbeIndex++;
                    }

                }
                /**
                 * @brief shadow register probing
                 * 
                 */
                if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                    uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, read_register_internal(instr.Rm), ProbeTracker.MemoryLatestClockCycle);

                    if(!Helper.HorizontalProbesExcluded.at(17)){
                        Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, read_register_internal(instr.Rm), ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                    }

                    //overwrite shadow register with new value
                    m_memory_shadow_register = read_register_internal(instr.Rm);
                }




                MemoryOperation = true;
                
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
                
                write_register_internal(instr.Rd, 0);
            }
            else
            {
                write_register_internal(instr.Rd, 1);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDREX || instr.name == Mnemonic::LDREXB || instr.name == Mnemonic::LDREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::LDREX)
            {
                address += instr.imm;
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::LDREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            set_exclusive_monitors(address, bytes);
            write_register_internal(instr.Rd, read_memory_internal(address, bytes));

            /**
             * @brief shadow register probing
             * 
             */
            
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t next_shadow_register_value = 0;

                check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);

                if(InTestClockCycles){
                    uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                    uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                    ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                    Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                    if(!Helper.HorizontalProbesExcluded.at(17)){
                        Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                    }
                }

                // overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
                ProbeTracker.MemoryLatestClockCycle = InstrNr;
            }



            
            //if randomness was used update it
            if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                    write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
            }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TBB || instr.name == Mnemonic::TBH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1 = read_register_internal(instr.Rn);
            u32 reg2 = read_register_internal(instr.Rm);

            u32 data;
            if (instr.name == Mnemonic::TBH)
            {
                auto [shift_ok, shifted] = arm_functions::LSL(reg2, 1);
                CHECK_SHIFT(shift_ok);
                u32 address           = reg1 + shifted;
                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;
                if (!ignore_alignment && arm_functions::align(address, 2) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
                uint8_t bytes = 2;
                data = read_memory_internal(address, bytes);

                /**
                 * @brief shadow register probing
                 * 
                 */
                
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);

                    if(InTestClockCycles){
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                        Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);

                        if(!Helper.HorizontalProbesExcluded.at(17)){
                            Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                        }

                    }
                    // overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = InstrNr;
                }



                
            }
            else
            {
                uint8_t bytes = 1;
                uint32_t address = reg1 + reg2;
                data = read_memory_internal(address, bytes);

                /**
                 * @brief shadow register probing
                 * 
                 */
                
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;

                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);
                    if(InTestClockCycles && Helper.ProbeMemoryShadowRegister){
                        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (1 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);
                        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + Helper.MemoryShadowRegisterProbesIncluded.size() + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(17))));
                        Software::Probing::CreateMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.MemoryShadowRegisterProbesIncluded, ProbeInfo, ProbeIndex, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle);
                        
                        if(!Helper.HorizontalProbesExcluded.at(17)){
                            Software::Probing::CreateHorizontalMemShadowProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), InstrNr, ProbeIndex, 0, m_memory_shadow_register, next_shadow_register_value, ProbeTracker.MemoryLatestClockCycle, (Helper.MemoryShadowRegisterProbesIncluded.size() << ThreadSimulation.TestTransitional));
                        }

                    }
                    ProbeTracker.MemoryLatestClockCycle = InstrNr;
                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                }

                
            }

            branch_write_PC(read_register_internal(PC) + 2 * data);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TEQ)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg ^ value;

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            UPDATE_PSR

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SSAT || instr.name == Mnemonic::USAT)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                = read_register_internal(instr.Rn);
            auto [shift_ok, value] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            u32 result;
            bool sat;
            if (instr.name == Mnemonic::SSAT)
            {
                auto [r, s] = arm_functions::signed_sat_Q(value, instr.imm);
                sat         = s;
                result      = arm_functions::sign_extend(r, 5);
            }
            else
            {
                auto [r, s] = arm_functions::unsigned_sat_Q(value, instr.imm);
                sat         = s;
                result      = r;
            }
            write_register_internal(instr.Rd, result);
            if (sat)
            {
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBFX || instr.name == Mnemonic::UBFX)
    {
        if (evaluate_condition(instr))
        {
            u32 lsbit = instr.imm;
            u32 width = instr.imm2;

            u32 reg = read_register_internal(instr.Rn);

            u32 result = (reg >> lsbit) & (0xFFFFFFFF >> (32 - width));

            if (width + lsbit <= 32)
            {
                if (instr.name == Mnemonic::SBFX)
                {
                    result = arm_functions::sign_extend(result, width);
                }
                write_register_internal(instr.Rd, result);
            }
            else
            {
                m_return_code = ReturnCode::UNPREDICTABLE;
                return false;
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BFI || instr.name == Mnemonic::BFC)
    {
        if (evaluate_condition(instr))
        {
            u32 lsb   = instr.imm;
            u32 width = instr.imm2;
            u32 msb   = lsb + width;

            u32 old = read_register_internal(instr.Rd);

            u32 low  = 0;
            u32 high = 0;
            if (lsb > 0)
                low = old & (0xFFFFFFFF >> (32 - lsb));
            if (msb < 32)
                high = old & ((u32)0xFFFFFFFF << msb);
            u32 result = low | high;

            if (instr.name == Mnemonic::BFI)
            {
                u32 value = read_register_internal(instr.Rn) & (0xFFFFFFFF >> (32 - width));
                result |= value << lsb;
            }

            write_register_internal(instr.Rd, result);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CLZ)
    {
        if (evaluate_condition(instr))
        {
            u32 result = 0;
            u32 val    = read_register_internal(instr.Rm);
            // count leading zeros
            for (u32 i = 0; i < 32; ++i)
            {
                if (val & 0x80000000)
                {
                    break;
                }
                result++;
                val <<= 1;
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MLA || instr.name == Mnemonic::MLS)
    {
        if (evaluate_condition(instr))
        {
            u32 op1    = read_register_internal(instr.Rn);
            u32 op2    = read_register_internal(instr.Rm);
            u32 addend = read_register_internal(instr.Ra);
            u32 result = op1 * op2;
            if (instr.name == Mnemonic::MLA)
            {
                result += addend;
            }
            else
            {
                result = addend - result;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1              = read_register_internal(instr.Rn);
            u32 reg2              = read_register_internal(instr.Rm);
            i32 op1               = reg1;
            i32 op2               = reg2;
            i32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 op1               = read_register_internal(instr.Rn);
            u32 op2               = read_register_internal(instr.Rm);
            u32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 add    = ((i64)reg3 << 32) | reg4;
            i64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 add    = ((u64)reg3 << 32) | reg4;
            u64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CPS)
    {
        if (in_priviledged_mode())
        {
            bool enable      = _1BIT(instr.imm >> 4) == 0;
            bool affectPRI   = _1BIT(instr.imm >> 1) == 1;
            bool affectFAULT = _1BIT(instr.imm) == 1;
            if (enable)
            {
                if (affectPRI)
                    cpu.PRIMASK = 0;
                if (affectFAULT)
                    cpu.FAULTMASK = 0;
            }
            else
            {
                if (affectPRI)
                    cpu.PRIMASK = 1;
                if (affectFAULT && get_execution_priority() > -1)
                    cpu.FAULTMASK = 1;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MRS)
    {
        if (evaluate_condition(instr))
        {
            auto psr  = read_register_internal(Register::PSR);
            u32 value = 0;
            u8 tmp    = _5BIT(instr.imm >> 3);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm) == 1)
                {
                    // IPSR
                }
                if (_1BIT(instr.imm >> 1) == 1)
                {
                    // EPSR reads as zero
                }
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    value |= psr & 0xF8000000;
                    if (get_architecture() == Architecture::ARMv7EM)
                    {
                        // DSP Extension
                        value |= psr & 0x000F0000;
                    }
                }
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        value = read_register_internal(Register::SP);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        value = read_register_internal(Register::SP);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.PRIMASK);
                }
                else if ((tmp == 0b001 || tmp == 0b010) && in_priviledged_mode())
                {
                    value = cpu.BASEPRI;
                }
                else if (tmp == 0b011 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.FAULTMASK);
                }
                else if (tmp == 0b100)
                {
                    // FP Extension not supported
                    value = _2BIT(cpu.CONTROL);
                }
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MSR)
    {
        if (evaluate_condition(instr))
        {
            auto value = read_register_internal(instr.Rn);
            auto psr   = read_register_internal(Register::PSR);
            u8 tmp     = _5BIT(instr.imm >> 3);
            u8 mask    = _2BIT(instr.imm >> 8);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    if (_1BIT(mask) == 1)
                    {
                        if (get_architecture() != Architecture::ARMv7EM)
                        {
                            m_return_code = ReturnCode::UNPREDICTABLE;
                            return false;
                        }
                        else
                        {
                            psr = (psr & ~0x000F0000) | (value & 0x000F0000);
                        }
                    }

                    if (_1BIT(mask >> 1) == 1)
                    {
                        psr = (psr & ~0xF8000000) | (value & 0xF8000000);
                    }
                }
                write_register_internal(Register::PSR, psr);
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        write_register_internal(Register::SP, value);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        write_register_internal(Register::SP, value);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    cpu.PRIMASK = _1BIT(value);
                }
                else if (tmp == 0b001 && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b010 && _8BIT(value) != 0 && (_8BIT(value) < cpu.BASEPRI || cpu.BASEPRI == 0) && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b011 && in_priviledged_mode() && get_execution_priority() > -1)
                {
                    cpu.FAULTMASK = _1BIT(value);
                }
                else if (tmp == 0b100 && in_priviledged_mode())
                {
                    cpu.CONTROL = _2BIT(value);
                    // FP Extension not supported
                }
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD8){
        if (evaluate_condition(instr))
        {
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                uint16_t tmp = ((Rn >> (i*8)) & 0xff) + ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(1 << i))) | (((tmp & 0x100) >> 8) << i);
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SEL){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t tmp = read_register_internal((mulator::Register)PSR);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                if(tmp & (1 << (16+i))){ //GE bit set
                    res |= (Rn & (0xff << (i*8)));
                }
                else{
                    res |= (Rm & (0xff << (i*8)));
                }
            }
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::USUB16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                int32_t tmp = ((Rn >> (i*16)) & 0xffff) - ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x30000) >> 16) ^ 0b11) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                uint32_t tmp = ((Rn >> (i*16)) & 0xffff) + ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x10000) >> 16) | (((tmp & 0x10000) >> 16) << 1)) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHBT){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (value & 0xffff0000) | (Rn & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHTB){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (Rn & 0xffff0000) | (value & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBB){
        if(evaluate_condition(instr)){
            int16_t Rn = read_register_internal(instr.Rn) & 0xffff;
            int16_t Rm = read_register_internal(instr.Rm) & 0xffff;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff);
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTB){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::SMLABB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLABT){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff));
            int32_t operand2 = static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn)) >> 16);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATT){
        if(evaluate_condition(instr)){
            uint32_t operand1 = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            uint32_t operand2 = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QADD){
        if(evaluate_condition(instr)){
            int64_t i = static_cast<int64_t>(instr.Rm) + static_cast<int32_t>(instr.Rn);
            auto [res, sat] = arm_functions::signed_sat_Q(i, 32);
            write_register_internal(instr.Rd, res);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::QADD16){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            res |= arm_functions::signed_sat(sum1, 16) & 0xffff;
            res |= arm_functions::signed_sat(sum2, 16) << 16;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QADD8){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int32_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int32_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff00) >> 8) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff00) >> 8);
            int32_t sum3 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff0000) >> 16) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff0000) >> 16);
            int32_t sum4 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff000000) >> 24) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff000000) >> 24);
            res |= (arm_functions::signed_sat(sum1, 8) & 0xff);
            res |= ((arm_functions::signed_sat(sum2, 8) & 0xff) << 8);
            res |= ((arm_functions::signed_sat(sum3, 8) & 0xff) << 16);
            res |= ((arm_functions::signed_sat(sum4, 8) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QASX){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff0000) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            res |= (arm_functions::signed_sat(diff, 16) & 0xffff);
            res |= ((arm_functions::signed_sat(sum, 16) & 0xffff) << 16);

            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDADD){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) + static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDSUB){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + ((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t diff = ((read_register_internal(instr.Rn) & 0xffff0000) >> 16) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (diff << 16) | (sum & 0xffff);
            if(sum & 0x10000){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USUB8){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int16_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + (rotated & 0xff)) & 0xffff;
            res |= (((read_register_internal(instr.Rn) & 0xffff0000) + (rotated & 0xff0000)) & 0xffff0000);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;     
    }
    else if(instr.name == Mnemonic::UXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::UXTB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = rotated & 0x00ff00ff;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            if(diff1 >= 0){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff2 >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            uint32_t res = (diff2 << 16) | (diff1 & 0xffff);
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB8){
        if(evaluate_condition(instr)){
            int32_t Rn = read_register_internal(instr.Rn);
            int32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int32_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;      
    }
    else if(instr.name == Mnemonic::SXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xff, 32);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;         
    }
    else if(instr.name == Mnemonic::SXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(arm_functions::sign_extend(rotated & 0xff,16))) & 0xffff;
            res |= (((read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(arm_functions::sign_extend((rotated & 0xff0000) >> 16, 16))) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = (read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xffff, 16));
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UASX){
        if(evaluate_condition(instr)){
            int32_t diff = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) >> 16);
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = ((sum & 0xffff) << 16) | (diff & 0xffff);
            write_register_internal(instr.Rd, res);
            if(diff >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0x10000){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSAX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int16_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);;
            uint32_t res = (arm_functions::signed_sat(sum, 16) & 0xffff) | (arm_functions::signed_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB){
        if(evaluate_condition(instr)){
            auto [res, sat] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(read_register_internal(instr.Rn)), 32);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, res);
        }
        
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB16){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::signed_sat(diff1, 16) | (arm_functions::signed_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QSUB8){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff));
            int64_t diff3 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff));
            int64_t diff4 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff));
            uint32_t res = arm_functions::signed_sat(diff1, 8) | (arm_functions::signed_sat(diff2, 8) << 8) | (arm_functions::signed_sat(diff3, 8) << 16) | (arm_functions::signed_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm) >> 16));
            uint32_t res = (sum1 & 0xffff) | (sum2 << 16);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD8){
        if(evaluate_condition(instr)){
            int16_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int16_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int16_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int16_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = (sum1 & 0xff) | ((sum2 & 0xff) << 8) | ((sum3 & 0xff) << 16) | ((sum4 & 0xff) << 24);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b1; 
            }
            else{
                cpu.psr.GE &= 0b11111110;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b10;
            }
            else{
                cpu.psr.GE &= 0b11111101;
            }
            if(sum3 >= 0){
                cpu.psr.GE |= 0b100; 
            }
            else{
                cpu.psr.GE &= 0b11111011;
            }
            if(sum4 >= 0){
                cpu.psr.GE |= 0b1000;
            }
            else{
                cpu.psr.GE &= 0b11110111;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SASX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int16_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = (sum << 16) | (diff);
            if(diff >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum1 & 0b11111111111111110) >> 1) | ((sum2 & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }

        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD8){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((sum1 & 0b111111110) >> 1) | ((sum2 & 0b111111110) << 7) | ((sum3 & 0b111111110) << 15) | ((sum4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHASX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = ((diff & 0b11111111111111110) >> 1) | ((sum & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSAX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff)) + static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff & 0b11111111111111110) << 15) | ((sum & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) - static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff2 & 0b11111111111111110) << 15) | ((diff1 & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB8){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t diff2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t diff3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t diff4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 & 0b111111110) >> 1) | ((diff2 & 0b111111110) << 7) | ((diff3 & 0b111111110) << 15) | ((diff4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWB){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWT){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLADX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLDX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMMLA){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }  
    else if(instr.name == Mnemonic::SMMLAR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLS){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLSR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMUL){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMULR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMUAD){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(read_register_internal(instr.Rm));
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUADX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWB){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWT){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount );
            auto [res2, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount );
            uint32_t res = 0;
            res = arm_functions::sign_extend(res1,16) & 0xffff;
            res |= (arm_functions::sign_extend(res2,16) << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount);
            auto [res2, sat2] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount);
            uint32_t res = 0;
            res = res1 & 0xffff;
            res |= (res2 << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAX){
        if(evaluate_condition(instr)){
            int32_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (sum & 0xffff) | ((diff & 0xffff) << 16);
            if(sum >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(diff >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum2 >> 1) << 16) | ((sum1 >> 1) & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 >> 1) & 0xff) | (((diff2 >> 1) & 0xff) << 8) | (((diff3 >> 1) & 0xff) << 16) | (((diff4 >> 1) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UMAAL){
        if(evaluate_condition(instr)){
            uint64_t res = static_cast<uint64_t>(read_register_internal(instr.Rn)) * read_register_internal(instr.Rm) + read_register_internal(instr.RdHi) + read_register_internal(instr.RdLo);
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = arm_functions::unsigned_sat(sum1, 16) | (arm_functions::unsigned_sat(sum2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD8){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xff) + (read_register_internal(instr.Rm) & 0xff);
            uint32_t sum2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) + ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t sum3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) + ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t sum4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) + ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(sum1, 8) | (arm_functions::unsigned_sat(sum2, 8) << 8) | (arm_functions::unsigned_sat(sum3, 8) << 16) | (arm_functions::unsigned_sat(sum4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(diff1, 8) | (arm_functions::unsigned_sat(diff2, 8) << 8) | (arm_functions::unsigned_sat(diff3, 8) << 16) | (arm_functions::unsigned_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB16){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff1, 16) | (arm_functions::unsigned_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) >> 16);
            uint32_t diff = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) & 0xffff));
            uint32_t res = arm_functions::unsigned_sat(sum, 16) | (arm_functions::unsigned_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQASX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff = ((read_register_internal(instr.Rn) & 0xffff)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff, 16) | (arm_functions::unsigned_sat(sum, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USAD8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USADA8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4 + read_register_internal(instr.Ra);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }

    m_return_code = ReturnCode::UNSUPPORTED;
    return false;
}

bool Emulator::execute_instantiation(const Instruction& instr, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, uint32_t randomness_start_addr, uint32_t randomness_end_addr)
{
    m_psr_updated             = false;
    bool instruction_executed = false;
    bool increment_pc         = true;
    if (instr.name == Mnemonic::ADC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADD || instr.name == Mnemonic::ADDW)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, 0);
            if (instr.Rd == Register::PC)
            {
                cpu.registers[PC] = result & ~((u32)1);
                increment_pc      = false;
            }
            else
            {
                write_register_internal(instr.Rd, result);
                if (instr.flags.S)
                {
                    cpu.psr.N = result >> 31;
                    cpu.psr.Z = (result == 0);
                    cpu.psr.C = carry;
                    cpu.psr.V = overflow;
                    UPDATE_PSR
                }
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::AND || instr.name == Mnemonic::BIC || instr.name == Mnemonic::EOR || instr.name == Mnemonic::ORR || instr.name == Mnemonic::ORN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg = read_register_internal(instr.Rn);

            u32 result;
            if (instr.name == Mnemonic::AND)
            {
                result = reg & value;
            }
            else if (instr.name == Mnemonic::BIC)
            {
                result = reg & ~value;
            }
            else if (instr.name == Mnemonic::EOR)
            {
                result = reg ^ value;
            }
            else if (instr.name == Mnemonic::ORR)
            {
                result = reg | value;
            }
            else    // if (instr.name == Mnemonic::ORN)
            {
                result = reg | ~value;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ASR || instr.name == Mnemonic::LSL || instr.name == Mnemonic::LSR || instr.name == Mnemonic::ROR)
    {
        if (evaluate_condition(instr))
        {
            u32 amount = 0;
            u32 base;
            if (instr.uses_only_registers())
            {
                {
                    u32 reg = read_register_internal(instr.Rm);

                    amount = reg & 0xFF;
                }
                {
                    u32 reg = read_register_internal(instr.Rn);

                    base = reg;
                }
            }
            else
            {
                amount = instr.shift_amount;

                u32 reg = read_register_internal(instr.Rm);

                base = reg;
            }
            auto [shift_ok, result, carry] = arm_functions::shift_c(base, instr.shift_type, amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RRX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);

            auto [shift_ok, result, carry] = arm_functions::shift_c(reg, ShiftType::RRX, 1, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDR || instr.name == Mnemonic::LDRT || instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRB
             || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
    {
        if (evaluate_condition(instr))
        {
            u8 bytes = 4;
            if (instr.name == Mnemonic::LDRB || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
            {
                bytes = 2;
            }

            if (instr.operand_type == OperandType::RI)
            {
                u32 reg = read_register_internal(Register::PC);

                u32 address = arm_functions::align(reg, 4);
                address += ((instr.flags.add) ? instr.imm : -instr.imm);
                u32 result = read_memory_internal(address, bytes);


                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSH)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }


                /**
                 * @brief shadow register update
                 * 
                 */
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);

                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;

                    ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
                }

                
                write_register_internal(instr.Rd, result);

                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                    write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    
                }
                
            }
            else
            {
                u32 offset_address = 0;

                u32 address = read_register_internal(instr.Rn);

                if (instr.uses_only_registers())
                {
                    auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                    CHECK_SHIFT(shift_ok);
                    address += shifted;
                }
                else
                {
                    offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                    if (instr.flags.index)
                    {
                        address = offset_address;
                    }
                }

                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

                if (!ignore_alignment && arm_functions::align(address, bytes) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }

                u32 result = read_memory_internal(address, bytes);

                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }


                /**
                 * @brief shadow register update
                 * 
                 */
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);



                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
                }


                write_register_internal(instr.Rd, result);
                
                if (instr.flags.wback)
                {
                    write_register_internal(instr.Rn, offset_address);
                }


                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                    write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                }
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MUL)
    {
        if (evaluate_condition(instr))
        {
            u32 result = read_register_internal(instr.Rn) * read_register_internal(instr.Rm);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STR || instr.name == Mnemonic::STRT || instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT || instr.name == Mnemonic::STRB
             || instr.name == Mnemonic::STRBT)
    {
        if (evaluate_condition(instr))
        {
            u32 offset_addr = 0;

            u32 address = read_register_internal(instr.Rn);

            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                address += shifted;
            }
            else
            {
                offset_addr = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                if (instr.flags.index)
                {
                    address = offset_addr;
                }
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::STRB || instr.name == Mnemonic::STRBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT)
            {
                bytes = 2;
            }

            bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

            if (!ignore_alignment && arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_memory_internal(address, read_register_internal(instr.Rd), bytes);

            /**
             * @brief shadow register update
             * 
             */
            m_memory_shadow_register = read_register_internal(instr.Rd);
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_addr);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SUB || instr.name == Mnemonic::SUBW)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RSB)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(~reg, value, 1);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, value, 0);
            cpu.psr.N                      = result >> 31;
            cpu.psr.Z                      = (result == 0);
            cpu.psr.C                      = carry;
            cpu.psr.V                      = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMP)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            cpu.psr.V = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MOV || instr.name == Mnemonic::MOVW || instr.name == Mnemonic::MOVT)
    {
        if (evaluate_condition(instr))
        {
            if (instr.Rd == Register::PC)
            {
                u32 reg = read_register_internal(instr.Rm);
                branch_write_PC(reg);
            }
            else
            {
                
                u32 value = 0;
                u8 carry  = cpu.psr.C;

                if (instr.name == Mnemonic::MOVW)
                {
                    value = instr.imm;
                }
                else if (instr.name == Mnemonic::MOVT)
                {
                    u32 reg = read_register_internal(instr.Rd);
                    value   = (reg & 0xFFFF) | (instr.imm << 16);
                }
                else if (instr.uses_only_registers())
                {
                    u32 reg = read_register_internal(instr.Rm);
                    value   = reg;
                }
                else
                {
                    auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, carry);
                    CHECK_IMM(imm_ok);
                    value = v;
                    carry = c;
                }
                write_register_internal(instr.Rd, value);
                if (instr.flags.S)
                {
                    cpu.psr.N = value >> 31;
                    cpu.psr.Z = (value == 0);
                    cpu.psr.C = carry;
                    UPDATE_PSR
                }

            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MVN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, v, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = v;
                carry = c;
            }
            else
            {
                auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = v;
                carry = c;
            }

            u32 result = ~value;
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RBIT)
    {
        if (evaluate_condition(instr))
        {
            u32 n = read_register_internal(instr.Rm);

            // reverse bits in 32-bit integer
            n = ((n >> 1) & 0x55555555) | ((n << 1) & 0xaaaaaaaa);
            n = ((n >> 2) & 0x33333333) | ((n << 2) & 0xcccccccc);
            n = ((n >> 4) & 0x0f0f0f0f) | ((n << 4) & 0xf0f0f0f0);
            n = ((n >> 8) & 0x00ff00ff) | ((n << 8) & 0xff00ff00);
            n = ((n >> 16) & 0x0000ffff) | ((n << 16) & 0xffff0000);

            write_register_internal(instr.Rd, n);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 24) | ((val & 0xFF00) << 8) | ((val & 0xFF0000) >> 8) | ((val >> 24) & 0xFF);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV16)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 8) | ((val & 0xFF00) >> 8) | ((val & 0xFF0000) << 8) | ((val & 0xFF000000) >> 8);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REVSH)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = arm_functions::sign_extend(((val & 0xFF) << 8) | ((val & 0xFF00) >> 8), 16);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SXTB || instr.name == Mnemonic::SXTH || instr.name == Mnemonic::UXTB || instr.name == Mnemonic::UXTH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                  = read_register_internal(instr.Rm);
            auto [shift_ok, rotated] = arm_functions::ROR(reg, instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            if (instr.name == Mnemonic::SXTB)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFF, 8));
            }
            else if (instr.name == Mnemonic::SXTH)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFFFF, 16));
            }
            else if (instr.name == Mnemonic::UXTB)
            {
                write_register_internal(instr.Rd, rotated & 0xFF);
            }
            else    // UXTH
            {
                write_register_internal(instr.Rd, rotated & 0xFFFF);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TST)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }
            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg & value;
            cpu.psr.N  = result >> 31;
            cpu.psr.Z  = (result == 0);
            cpu.psr.C  = carry;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADR)
    {
        if (evaluate_condition(instr))
        {
            u32 reg   = read_register_internal(PC);
            u32 value = arm_functions::align(reg, 4);
            value += (instr.flags.add) ? instr.imm : -instr.imm;
            write_register_internal(instr.Rd, value);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }
            u32 cnt = 0;
            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    /**
                     * @brief shadow register update
                     * 
                     */
                    if(Helper.ProbeMemoryShadowRegister){
                        uint32_t memory_values_not_consider = 0;

                        //check if read memory address contains global input range -> if yes do not consider the specific bytes
                        for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                            if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                                memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                                break;
                            }
                        }
                        uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                        SwapEndian(next_shadow_register_value);

                        //overwrite shadow register with new value
                        m_memory_shadow_register = next_shadow_register_value;
                    }


                    //if randomness was used update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    }

                    address += 4;
                    cnt++;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 cnt = 0;
            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_memory_internal(address, read_register_internal((Register)i), 4);
                    /**
                     * @brief shadow register update
                     * 
                     */
                    m_memory_shadow_register = read_register_internal((Register)i);
                    
                    address += 4;
                    cnt++;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CBZ || instr.name == Mnemonic::CBNZ)
    {
        u32 value = read_register_internal(instr.Rn);
        if ((instr.name == Mnemonic::CBZ && value == 0) || (instr.name == Mnemonic::CBNZ && value != 0))
        {
            branch_write_PC(read_register_internal(PC) + instr.imm);
            increment_pc = false;
        }
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BLX)
    {
        if (evaluate_condition(instr))
        {
            write_register_internal(LR, (read_register_internal(PC) - 2) | 1);
            blx_write_PC(read_register_internal(instr.Rm));
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);
            bx_write_PC(reg);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::B)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            branch_write_PC(reg + instr.imm);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            write_register_internal(LR, reg | 1);
            branch_write_PC(reg + instr.imm);

            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::POP)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);
            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 end_val = address + arm_functions::bit_count(instr.imm) * 4;

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));
                    /**
                     * @brief shadow register update
                     * 
                     */
                    m_memory_shadow_register = read_register_internal((Register)i);
                    address += 4;
                }
            }

            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }

            write_register_internal(SP, end_val);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::PUSH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);

            address -= arm_functions::bit_count(instr.imm) * 4;

            u32 end_val = address;

            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg1 = read_register_internal((Register)i);


                    write_memory_internal(address, reg1, 4);

                    /**
                     * @brief shadow register update
                     * 
                     */
                    m_memory_shadow_register = reg1;
                    address += 4;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            write_register_internal(SP, end_val);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::IT && m_decoder.get_architecture() >= Architecture::ARMv7M)
    {
        cpu.psr.it_state = instr.imm;
        UPDATE_PSR
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::NOP || instr.name == Mnemonic::SEV || instr.name == Mnemonic::DSB || instr.name == Mnemonic::ISB || instr.name == Mnemonic::DMB || instr.name == Mnemonic::CSDB
             || instr.name == Mnemonic::DBG || instr.name == Mnemonic::CLREX || instr.name == Mnemonic::SSBB || instr.name == Mnemonic::PSSBB || instr.name == Mnemonic::PLD
             || instr.name == Mnemonic::PLI)
    {
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDF)
    {
        m_return_code = ReturnCode::UNDEFINED;
        return false;
    }
    else if (instr.name == Mnemonic::STMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg = read_register_internal((Register)i);

                    write_memory_internal(address, reg, 4);


                    /**
                     * @brief shadow register update
                     * 
                     */
                    m_memory_shadow_register = reg;

                    address += 4;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, end_val);
            }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    /**
                     * @brief shadow register update
                     * 
                     */
                    if(Helper.ProbeMemoryShadowRegister){
                        uint32_t memory_values_not_consider = 0;

                        //check if read memory address contains global input range -> if yes do not consider the specific bytes
                        for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                            if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                                memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                                break;
                            }
                        }
                        uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                        SwapEndian(next_shadow_register_value);

                        //overwrite shadow register with new value
                        m_memory_shadow_register = next_shadow_register_value;
                    }


                    //if randomness was used update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    }

                    address += 4;
                }
            }
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }

            if (instr.flags.wback && _1BIT(instr.imm > instr.Rn) != 0)
            {
                write_register_internal(instr.Rn, end_val);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address        = read_register_internal(instr.Rn);
            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_memory_internal(address, read_register_internal(instr.Rd), 4);
            
            /**
             * @brief shadow register update
             * 
             */
            m_memory_shadow_register = read_register_internal(instr.Rd);


            write_memory_internal(address + 4, read_register_internal(instr.Rm), 4);


            /**
             * @brief shadow register update
             * 
             */
            m_memory_shadow_register = read_register_internal(instr.Rm);
            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            if (instr.operand_type == OperandType::RRI)    // LDRD (literal)
            {
                address = arm_functions::align(address, 4);
            }

            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);

            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_register_internal(instr.RdHi, read_memory_internal(address, 4));

            /**
             * @brief shadow register update
             * 
             */
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t memory_values_not_consider = 0;

                //check if read memory address contains global input range -> if yes do not consider the specific bytes
                for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                    if(((address-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                        memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address-(4-4));
                        break;
                    }
                }
                uint32_t next_shadow_register_value = (((read_memory_internal(address-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                SwapEndian(next_shadow_register_value);

                //overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
            }


            //if randomness was used update it
            if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
            }

            write_register_internal(instr.RdLo, read_memory_internal(address + 4, 4));

            /**
             * @brief shadow register update
             * 
             */
            if(Helper.ProbeMemoryShadowRegister){
                uint32_t memory_values_not_consider = 0;

                //check if read memory address contains global input range -> if yes do not consider the specific bytes
                for(uint32_t inputIdx = 0; inputIdx < (uint32_t)ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.size(); ++inputIdx){
                    if(((address+4-(4-4)) >= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(0)) && ((address+4-(4-4)) <= ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1))){
                        memory_values_not_consider = ThreadSimulation.StartRAM_EndRAM_EmulatorInputs.at(inputIdx).at(1) + 1 - (address+4-(4-4));
                        break;
                    }
                }
                uint32_t next_shadow_register_value = (((read_memory_internal(address+4-(4-4), 4) >> (8*memory_values_not_consider)) << (8*memory_values_not_consider)));
                SwapEndian(next_shadow_register_value);

                //overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
            }

            ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            //if randomness was used update it
            if((randomness_start_addr <= (address+4)) && ((address+4) < randomness_end_addr)){
                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                
            }

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STREX || instr.name == Mnemonic::STREXB || instr.name == Mnemonic::STREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::STREX)
            {
                address += instr.imm;
            }

            u32 bytes = 4;
            if (instr.name == Mnemonic::STREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            if (exclusive_monitors_pass(address, bytes))
            {
                write_memory_internal(address, read_register_internal(instr.Rm), bytes);

                /**
                 * @brief shadow register update
                 * 
                 */
                m_memory_shadow_register = read_register_internal(instr.Rm);
                write_register_internal(instr.Rd, 0);
                ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            }
            else
            {
                write_register_internal(instr.Rd, 1);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDREX || instr.name == Mnemonic::LDREXB || instr.name == Mnemonic::LDREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::LDREX)
            {
                address += instr.imm;
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::LDREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            set_exclusive_monitors(address, bytes);
            write_register_internal(instr.Rd, read_memory_internal(address, bytes));

            /**
             * @brief shadow register update
             * 
             */
            if(Helper.ProbeMemoryShadowRegister){
                // uint32_t memory_values_not_consider = 0;
                uint32_t next_shadow_register_value = 0;

                check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);

                //overwrite shadow register with new value
                m_memory_shadow_register = next_shadow_register_value;
                ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
            }

           //if randomness was used update it
           if((randomness_start_addr <= address) && (address < randomness_end_addr)){
                   write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
           }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TBB || instr.name == Mnemonic::TBH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1 = read_register_internal(instr.Rn);
            u32 reg2 = read_register_internal(instr.Rm);

            u32 data;
            if (instr.name == Mnemonic::TBH)
            {
                auto [shift_ok, shifted] = arm_functions::LSL(reg2, 1);
                CHECK_SHIFT(shift_ok);
                u32 address           = reg1 + shifted;
                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;
                if (!ignore_alignment && arm_functions::align(address, 2) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
                data = read_memory_internal(address, 2);

                /**
                 * @brief shadow register update
                 * 
                 */
                if(Helper.ProbeMemoryShadowRegister){
                    uint8_t bytes = 2;
                    uint32_t next_shadow_register_value = 0;

                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);

                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
                }

            }
            else
            {
                uint8_t bytes = 1;
                uint32_t address = reg1 + reg2;
                data = read_memory_internal(address, bytes);

                /**
                 * @brief shadow register update
                 * 
                 */
                if(Helper.ProbeMemoryShadowRegister){
                    uint32_t next_shadow_register_value = 0;
                    check_shadow_register_constraints(next_shadow_register_value, ThreadSimulation, address, bytes);


                    //overwrite shadow register with new value
                    m_memory_shadow_register = next_shadow_register_value;
                    ProbeTracker.MemoryLatestClockCycle = m_emulated_time;
                }

            }

            branch_write_PC(read_register_internal(PC) + 2 * data);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TEQ)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg ^ value;

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            UPDATE_PSR

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SSAT || instr.name == Mnemonic::USAT)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                = read_register_internal(instr.Rn);
            auto [shift_ok, value] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            u32 result;
            bool sat;
            if (instr.name == Mnemonic::SSAT)
            {
                auto [r, s] = arm_functions::signed_sat_Q(value, instr.imm);
                sat         = s;
                result      = arm_functions::sign_extend(r, 5);
            }
            else
            {
                auto [r, s] = arm_functions::unsigned_sat_Q(value, instr.imm);
                sat         = s;
                result      = r;
            }
            write_register_internal(instr.Rd, result);
            if (sat)
            {
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBFX || instr.name == Mnemonic::UBFX)
    {
        if (evaluate_condition(instr))
        {
            u32 lsbit = instr.imm;
            u32 width = instr.imm2;

            u32 reg = read_register_internal(instr.Rn);

            u32 result = (reg >> lsbit) & (0xFFFFFFFF >> (32 - width));

            if (width + lsbit <= 32)
            {
                if (instr.name == Mnemonic::SBFX)
                {
                    result = arm_functions::sign_extend(result, width);
                }
                write_register_internal(instr.Rd, result);
            }
            else
            {
                m_return_code = ReturnCode::UNPREDICTABLE;
                return false;
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BFI || instr.name == Mnemonic::BFC)
    {
        if (evaluate_condition(instr))
        {
            u32 lsb   = instr.imm;
            u32 width = instr.imm2;
            u32 msb   = lsb + width;

            u32 old = read_register_internal(instr.Rd);

            u32 low  = 0;
            u32 high = 0;
            if (lsb > 0)
                low = old & (0xFFFFFFFF >> (32 - lsb));
            if (msb < 32)
                high = old & ((u32)0xFFFFFFFF << msb);
            u32 result = low | high;

            if (instr.name == Mnemonic::BFI)
            {
                u32 value = read_register_internal(instr.Rn) & (0xFFFFFFFF >> (32 - width));
                result |= value << lsb;
            }

            write_register_internal(instr.Rd, result);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CLZ)
    {
        if (evaluate_condition(instr))
        {
            u32 result = 0;
            u32 val    = read_register_internal(instr.Rm);
            // count leading zeros
            for (u32 i = 0; i < 32; ++i)
            {
                if (val & 0x80000000)
                {
                    break;
                }
                result++;
                val <<= 1;
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MLA || instr.name == Mnemonic::MLS)
    {
        if (evaluate_condition(instr))
        {
            u32 op1    = read_register_internal(instr.Rn);
            u32 op2    = read_register_internal(instr.Rm);
            u32 addend = read_register_internal(instr.Ra);
            u32 result = op1 * op2;
            if (instr.name == Mnemonic::MLA)
            {
                result += addend;
            }
            else
            {
                result = addend - result;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1              = read_register_internal(instr.Rn);
            u32 reg2              = read_register_internal(instr.Rm);
            i32 op1               = reg1;
            i32 op2               = reg2;
            i32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 op1               = read_register_internal(instr.Rn);
            u32 op2               = read_register_internal(instr.Rm);
            u32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 add    = ((i64)reg3 << 32) | reg4;
            i64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 add    = ((u64)reg3 << 32) | reg4;
            u64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CPS)
    {
        if (in_priviledged_mode())
        {
            bool enable      = _1BIT(instr.imm >> 4) == 0;
            bool affectPRI   = _1BIT(instr.imm >> 1) == 1;
            bool affectFAULT = _1BIT(instr.imm) == 1;
            if (enable)
            {
                if (affectPRI)
                    cpu.PRIMASK = 0;
                if (affectFAULT)
                    cpu.FAULTMASK = 0;
            }
            else
            {
                if (affectPRI)
                    cpu.PRIMASK = 1;
                if (affectFAULT && get_execution_priority() > -1)
                    cpu.FAULTMASK = 1;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MRS)
    {
        if (evaluate_condition(instr))
        {
            auto psr  = read_register_internal(Register::PSR);
            u32 value = 0;
            u8 tmp    = _5BIT(instr.imm >> 3);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm) == 1)
                {
                    // IPSR
                }
                if (_1BIT(instr.imm >> 1) == 1)
                {
                    // EPSR reads as zero
                }
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    value |= psr & 0xF8000000;
                    if (get_architecture() == Architecture::ARMv7EM)
                    {
                        // DSP Extension
                        value |= psr & 0x000F0000;
                    }
                }
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        value = read_register_internal(Register::SP);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        value = read_register_internal(Register::SP);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.PRIMASK);
                }
                else if ((tmp == 0b001 || tmp == 0b010) && in_priviledged_mode())
                {
                    value = cpu.BASEPRI;
                }
                else if (tmp == 0b011 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.FAULTMASK);
                }
                else if (tmp == 0b100)
                {
                    // FP Extension not supported
                    value = _2BIT(cpu.CONTROL);
                }
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MSR)
    {
        if (evaluate_condition(instr))
        {
            auto value = read_register_internal(instr.Rn);
            auto psr   = read_register_internal(Register::PSR);
            u8 tmp     = _5BIT(instr.imm >> 3);
            u8 mask    = _2BIT(instr.imm >> 8);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    if (_1BIT(mask) == 1)
                    {
                        if (get_architecture() != Architecture::ARMv7EM)
                        {
                            m_return_code = ReturnCode::UNPREDICTABLE;
                            return false;
                        }
                        else
                        {
                            psr = (psr & ~0x000F0000) | (value & 0x000F0000);
                        }
                    }

                    if (_1BIT(mask >> 1) == 1)
                    {
                        psr = (psr & ~0xF8000000) | (value & 0xF8000000);
                    }
                }
                write_register_internal(Register::PSR, psr);
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        write_register_internal(Register::SP, value);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        write_register_internal(Register::SP, value);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    cpu.PRIMASK = _1BIT(value);
                }
                else if (tmp == 0b001 && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b010 && _8BIT(value) != 0 && (_8BIT(value) < cpu.BASEPRI || cpu.BASEPRI == 0) && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b011 && in_priviledged_mode() && get_execution_priority() > -1)
                {
                    cpu.FAULTMASK = _1BIT(value);
                }
                else if (tmp == 0b100 && in_priviledged_mode())
                {
                    cpu.CONTROL = _2BIT(value);
                    // FP Extension not supported
                }
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD8){
        if (evaluate_condition(instr))
        {
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                uint16_t tmp = ((Rn >> (i*8)) & 0xff) + ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(1 << i))) | (((tmp & 0x100) >> 8) << i);
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SEL){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t tmp = read_register_internal((mulator::Register)PSR);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                if(tmp & (1 << (16+i))){ //GE bit set
                    res |= (Rn & (0xff << (i*8)));
                }
                else{
                    res |= (Rm & (0xff << (i*8)));
                }
            }
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::USUB16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                int32_t tmp = ((Rn >> (i*16)) & 0xffff) - ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x30000) >> 16) ^ 0b11) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                uint32_t tmp = ((Rn >> (i*16)) & 0xffff) + ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x10000) >> 16) | (((tmp & 0x10000) >> 16) << 1)) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHBT){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (value & 0xffff0000) | (Rn & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHTB){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (Rn & 0xffff0000) | (value & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBB){
        if(evaluate_condition(instr)){
            int16_t Rn = read_register_internal(instr.Rn) & 0xffff;
            int16_t Rm = read_register_internal(instr.Rm) & 0xffff;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff);
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTB){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::SMLABB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLABT){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff));
            int32_t operand2 = static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn)) >> 16);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATT){
        if(evaluate_condition(instr)){
            uint32_t operand1 = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            uint32_t operand2 = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QADD){
        if(evaluate_condition(instr)){
            int64_t i = static_cast<int64_t>(instr.Rm) + static_cast<int32_t>(instr.Rn);
            auto [res, sat] = arm_functions::signed_sat_Q(i, 32);
            write_register_internal(instr.Rd, res);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::QADD16){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            res |= arm_functions::signed_sat(sum1, 16) & 0xffff;
            res |= arm_functions::signed_sat(sum2, 16) << 16;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QADD8){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int32_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int32_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff00) >> 8) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff00) >> 8);
            int32_t sum3 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff0000) >> 16) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff0000) >> 16);
            int32_t sum4 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff000000) >> 24) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff000000) >> 24);
            res |= (arm_functions::signed_sat(sum1, 8) & 0xff);
            res |= ((arm_functions::signed_sat(sum2, 8) & 0xff) << 8);
            res |= ((arm_functions::signed_sat(sum3, 8) & 0xff) << 16);
            res |= ((arm_functions::signed_sat(sum4, 8) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QASX){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff0000) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            res |= (arm_functions::signed_sat(diff, 16) & 0xffff);
            res |= ((arm_functions::signed_sat(sum, 16) & 0xffff) << 16);

            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDADD){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) + static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDSUB){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + ((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t diff = ((read_register_internal(instr.Rn) & 0xffff0000) >> 16) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (diff << 16) | (sum & 0xffff);
            if(sum & 0x10000){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USUB8){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int16_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + (rotated & 0xff)) & 0xffff;
            res |= (((read_register_internal(instr.Rn) & 0xffff0000) + (rotated & 0xff0000)) & 0xffff0000);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;     
    }
    else if(instr.name == Mnemonic::UXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::UXTB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = rotated & 0x00ff00ff;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            if(diff1 >= 0){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff2 >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            uint32_t res = (diff2 << 16) | (diff1 & 0xffff);
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB8){
        if(evaluate_condition(instr)){
            int32_t Rn = read_register_internal(instr.Rn);
            int32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int32_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;      
    }
    else if(instr.name == Mnemonic::SXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xff, 32);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;         
    }
    else if(instr.name == Mnemonic::SXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(arm_functions::sign_extend(rotated & 0xff,16))) & 0xffff;
            res |= (((read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(arm_functions::sign_extend((rotated & 0xff0000) >> 16, 16))) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = (read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xffff, 16));
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UASX){
        if(evaluate_condition(instr)){
            int32_t diff = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) >> 16);
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = ((sum & 0xffff) << 16) | (diff & 0xffff);
            write_register_internal(instr.Rd, res);
            if(diff >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0x10000){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSAX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int16_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);;
            uint32_t res = (arm_functions::signed_sat(sum, 16) & 0xffff) | (arm_functions::signed_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB){
        if(evaluate_condition(instr)){
            auto [res, sat] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(read_register_internal(instr.Rn)), 32);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, res);
        }
        
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB16){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::signed_sat(diff1, 16) | (arm_functions::signed_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QSUB8){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff));
            int64_t diff3 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff));
            int64_t diff4 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff));
            uint32_t res = arm_functions::signed_sat(diff1, 8) | (arm_functions::signed_sat(diff2, 8) << 8) | (arm_functions::signed_sat(diff3, 8) << 16) | (arm_functions::signed_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm) >> 16));
            uint32_t res = (sum1 & 0xffff) | (sum2 << 16);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD8){
        if(evaluate_condition(instr)){
            int16_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int16_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int16_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int16_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = (sum1 & 0xff) | ((sum2 & 0xff) << 8) | ((sum3 & 0xff) << 16) | ((sum4 & 0xff) << 24);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b1; 
            }
            else{
                cpu.psr.GE &= 0b11111110;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b10;
            }
            else{
                cpu.psr.GE &= 0b11111101;
            }
            if(sum3 >= 0){
                cpu.psr.GE |= 0b100; 
            }
            else{
                cpu.psr.GE &= 0b11111011;
            }
            if(sum4 >= 0){
                cpu.psr.GE |= 0b1000;
            }
            else{
                cpu.psr.GE &= 0b11110111;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SASX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int16_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = (sum << 16) | (diff);
            if(diff >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum1 & 0b11111111111111110) >> 1) | ((sum2 & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }

        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD8){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((sum1 & 0b111111110) >> 1) | ((sum2 & 0b111111110) << 7) | ((sum3 & 0b111111110) << 15) | ((sum4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHASX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = ((diff & 0b11111111111111110) >> 1) | ((sum & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSAX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff)) + static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff & 0b11111111111111110) << 15) | ((sum & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) - static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff2 & 0b11111111111111110) << 15) | ((diff1 & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB8){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t diff2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t diff3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t diff4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 & 0b111111110) >> 1) | ((diff2 & 0b111111110) << 7) | ((diff3 & 0b111111110) << 15) | ((diff4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWB){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWT){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLADX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLDX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMMLA){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }  
    else if(instr.name == Mnemonic::SMMLAR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLS){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLSR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMUL){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMULR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMUAD){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(read_register_internal(instr.Rm));
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUADX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWB){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWT){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount );
            auto [res2, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount );
            uint32_t res = 0;
            res = arm_functions::sign_extend(res1,16) & 0xffff;
            res |= (arm_functions::sign_extend(res2,16) << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount);
            auto [res2, sat2] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount);
            uint32_t res = 0;
            res = res1 & 0xffff;
            res |= (res2 << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAX){
        if(evaluate_condition(instr)){
            int32_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (sum & 0xffff) | ((diff & 0xffff) << 16);
            if(sum >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(diff >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum2 >> 1) << 16) | ((sum1 >> 1) & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 >> 1) & 0xff) | (((diff2 >> 1) & 0xff) << 8) | (((diff3 >> 1) & 0xff) << 16) | (((diff4 >> 1) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UMAAL){
        if(evaluate_condition(instr)){
            uint64_t res = static_cast<uint64_t>(read_register_internal(instr.Rn)) * read_register_internal(instr.Rm) + read_register_internal(instr.RdHi) + read_register_internal(instr.RdLo);
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = arm_functions::unsigned_sat(sum1, 16) | (arm_functions::unsigned_sat(sum2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD8){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xff) + (read_register_internal(instr.Rm) & 0xff);
            uint32_t sum2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) + ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t sum3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) + ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t sum4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) + ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(sum1, 8) | (arm_functions::unsigned_sat(sum2, 8) << 8) | (arm_functions::unsigned_sat(sum3, 8) << 16) | (arm_functions::unsigned_sat(sum4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(diff1, 8) | (arm_functions::unsigned_sat(diff2, 8) << 8) | (arm_functions::unsigned_sat(diff3, 8) << 16) | (arm_functions::unsigned_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB16){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff1, 16) | (arm_functions::unsigned_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) >> 16);
            uint32_t diff = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) & 0xffff));
            uint32_t res = arm_functions::unsigned_sat(sum, 16) | (arm_functions::unsigned_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQASX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff = ((read_register_internal(instr.Rn) & 0xffff)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff, 16) | (arm_functions::unsigned_sat(sum, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USAD8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USADA8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4 + read_register_internal(instr.Ra);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }

    m_return_code = ReturnCode::UNSUPPORTED;
    return false;
}

bool Emulator::execute(const Instruction& instr, uint32_t randomness_start_addr, uint32_t randomness_end_addr)
{
    m_psr_updated             = false;
    bool instruction_executed = false;
    bool increment_pc         = true;
    if (instr.name == Mnemonic::ADC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADD || instr.name == Mnemonic::ADDW)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            auto [result, carry, overflow] = arm_functions::add_with_carry(read_register_internal(instr.Rn), value, 0);
            if (instr.Rd == Register::PC)
            {
                cpu.registers[PC] = result & ~((u32)1);
                increment_pc      = false;
            }
            else
            {
                write_register_internal(instr.Rd, result);
                if (instr.flags.S)
                {
                    cpu.psr.N = result >> 31;
                    cpu.psr.Z = (result == 0);
                    cpu.psr.C = carry;
                    cpu.psr.V = overflow;
                    UPDATE_PSR
                }
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::AND || instr.name == Mnemonic::BIC || instr.name == Mnemonic::EOR || instr.name == Mnemonic::ORR || instr.name == Mnemonic::ORN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg = read_register_internal(instr.Rn);

            u32 result;
            if (instr.name == Mnemonic::AND)
            {
                result = reg & value;
            }
            else if (instr.name == Mnemonic::BIC)
            {
                result = reg & ~value;
            }
            else if (instr.name == Mnemonic::EOR)
            {
                result = reg ^ value;
            }
            else if (instr.name == Mnemonic::ORR)
            {
                result = reg | value;
            }
            else    // if (instr.name == Mnemonic::ORN)
            {
                result = reg | ~value;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ASR || instr.name == Mnemonic::LSL || instr.name == Mnemonic::LSR || instr.name == Mnemonic::ROR)
    {
        if (evaluate_condition(instr))
        {
            u32 amount = 0;
            u32 base;
            if (instr.uses_only_registers())
            {
                {
                    u32 reg = read_register_internal(instr.Rm);

                    amount = reg & 0xFF;
                }
                {
                    u32 reg = read_register_internal(instr.Rn);

                    base = reg;
                }
            }
            else
            {
                amount = instr.shift_amount;

                u32 reg = read_register_internal(instr.Rm);

                base = reg;
            }
            auto [shift_ok, result, carry] = arm_functions::shift_c(base, instr.shift_type, amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RRX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);

            auto [shift_ok, result, carry] = arm_functions::shift_c(reg, ShiftType::RRX, 1, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDR || instr.name == Mnemonic::LDRT || instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRB
             || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
    {
        if (evaluate_condition(instr))
        {
            u8 bytes = 4;
            if (instr.name == Mnemonic::LDRB || instr.name == Mnemonic::LDRBT || instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDRH || instr.name == Mnemonic::LDRHT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
            {
                bytes = 2;
            }

            if (instr.operand_type == OperandType::RI)
            {
                u32 reg = read_register_internal(Register::PC);

                u32 address = arm_functions::align(reg, 4);
                address += ((instr.flags.add) ? instr.imm : -instr.imm);
                u32 result = read_memory_internal(address, bytes);


                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSH)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }

                write_register_internal(instr.Rd, result);

                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                    write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                    
                }
                
            }
            else
            {
                u32 offset_address = 0;

                u32 address = read_register_internal(instr.Rn);

                if (instr.uses_only_registers())
                {
                    auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                    CHECK_SHIFT(shift_ok);
                    address += shifted;
                }
                else
                {
                    offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                    if (instr.flags.index)
                    {
                        address = offset_address;
                    }
                }

                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

                if (!ignore_alignment && arm_functions::align(address, bytes) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }

                u32 result = read_memory_internal(address, bytes);

                if (instr.name == Mnemonic::LDRSB || instr.name == Mnemonic::LDRSBT || instr.name == Mnemonic::LDRSH || instr.name == Mnemonic::LDRSHT)
                {
                    result = arm_functions::sign_extend(result, 8 * bytes);
                }

                

                write_register_internal(instr.Rd, result);
                
                if (instr.flags.wback)
                {
                    write_register_internal(instr.Rn, offset_address);
                }


                //if randomness was used update it
                if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                        write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);

                    
                }
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MUL)
    {
        if (evaluate_condition(instr))
        {
            u32 result = read_register_internal(instr.Rn) * read_register_internal(instr.Rm);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBC)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, cpu.psr.C);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STR || instr.name == Mnemonic::STRT || instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT || instr.name == Mnemonic::STRB
             || instr.name == Mnemonic::STRBT)
    {
        if (evaluate_condition(instr))
        {
            u32 offset_addr = 0;

            u32 address = read_register_internal(instr.Rn);

            if (instr.uses_only_registers())
            {
                auto [shift_ok, shifted] = arm_functions::shift(read_register_internal(instr.Rm), instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                address += shifted;
            }
            else
            {
                offset_addr = address + ((instr.flags.add) ? instr.imm : -instr.imm);
                if (instr.flags.index)
                {
                    address = offset_addr;
                }
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::STRB || instr.name == Mnemonic::STRBT)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STRH || instr.name == Mnemonic::STRHT)
            {
                bytes = 2;
            }

            bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;

            if (!ignore_alignment && arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_memory_internal(address, read_register_internal(instr.Rd), bytes);

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_addr);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SUB || instr.name == Mnemonic::SUBW)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RSB)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(~reg, value, 1);
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                cpu.psr.V = overflow;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }
            u32 reg                        = read_register_internal(instr.Rn);
            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, value, 0);
            cpu.psr.N                      = result >> 31;
            cpu.psr.Z                      = (result == 0);
            cpu.psr.C                      = carry;
            cpu.psr.V                      = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CMP)
    {
        if (evaluate_condition(instr))
        {
            u32 value = 0;
            if (instr.uses_only_registers())
            {
                u32 reg                  = read_register_internal(instr.Rm);
                auto [shift_ok, shifted] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = shifted;
            }
            else
            {
                value = instr.imm;
            }

            u32 reg = read_register_internal(instr.Rn);

            auto [result, carry, overflow] = arm_functions::add_with_carry(reg, ~value, 1);

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            cpu.psr.V = overflow;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MOV || instr.name == Mnemonic::MOVW || instr.name == Mnemonic::MOVT)
    {
        if (evaluate_condition(instr))
        {
            if (instr.Rd == Register::PC)
            {
                u32 reg = read_register_internal(instr.Rm);
                branch_write_PC(reg);
            }
            else
            {
                
                u32 value = 0;
                u8 carry  = cpu.psr.C;

                if (instr.name == Mnemonic::MOVW)
                {
                    value = instr.imm;
                }
                else if (instr.name == Mnemonic::MOVT)
                {
                    u32 reg = read_register_internal(instr.Rd);
                    value   = (reg & 0xFFFF) | (instr.imm << 16);
                }
                else if (instr.uses_only_registers())
                {
                    u32 reg = read_register_internal(instr.Rm);
                    value   = reg;
                }
                else
                {
                    auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, carry);
                    CHECK_IMM(imm_ok);
                    value = v;
                    carry = c;
                }
                write_register_internal(instr.Rd, value);
                if (instr.flags.S)
                {
                    cpu.psr.N = value >> 31;
                    cpu.psr.Z = (value == 0);
                    cpu.psr.C = carry;
                    UPDATE_PSR
                }

            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MVN)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, v, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = v;
                carry = c;
            }
            else
            {
                auto [imm_ok, v, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = v;
                carry = c;
            }

            u32 result = ~value;
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                cpu.psr.C = carry;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::RBIT)
    {
        if (evaluate_condition(instr))
        {
            u32 n = read_register_internal(instr.Rm);

            // reverse bits in 32-bit integer
            n = ((n >> 1) & 0x55555555) | ((n << 1) & 0xaaaaaaaa);
            n = ((n >> 2) & 0x33333333) | ((n << 2) & 0xcccccccc);
            n = ((n >> 4) & 0x0f0f0f0f) | ((n << 4) & 0xf0f0f0f0);
            n = ((n >> 8) & 0x00ff00ff) | ((n << 8) & 0xff00ff00);
            n = ((n >> 16) & 0x0000ffff) | ((n << 16) & 0xffff0000);

            write_register_internal(instr.Rd, n);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 24) | ((val & 0xFF00) << 8) | ((val & 0xFF0000) >> 8) | ((val >> 24) & 0xFF);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REV16)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = ((val & 0xFF) << 8) | ((val & 0xFF00) >> 8) | ((val & 0xFF0000) << 8) | ((val & 0xFF000000) >> 8);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::REVSH)
    {
        if (evaluate_condition(instr))
        {
            u32 val    = read_register_internal(instr.Rm);
            u32 result = arm_functions::sign_extend(((val & 0xFF) << 8) | ((val & 0xFF00) >> 8), 16);
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SXTB || instr.name == Mnemonic::SXTH || instr.name == Mnemonic::UXTB || instr.name == Mnemonic::UXTH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                  = read_register_internal(instr.Rm);
            auto [shift_ok, rotated] = arm_functions::ROR(reg, instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            if (instr.name == Mnemonic::SXTB)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFF, 8));
            }
            else if (instr.name == Mnemonic::SXTH)
            {
                write_register_internal(instr.Rd, arm_functions::sign_extend(rotated & 0xFFFF, 16));
            }
            else if (instr.name == Mnemonic::UXTB)
            {
                write_register_internal(instr.Rd, rotated & 0xFF);
            }
            else    // UXTH
            {
                write_register_internal(instr.Rd, rotated & 0xFFFF);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TST)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }
            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg & value;
            cpu.psr.N  = result >> 31;
            cpu.psr.Z  = (result == 0);
            cpu.psr.C  = carry;
            UPDATE_PSR
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::ADR)
    {
        if (evaluate_condition(instr))
        {
            u32 reg   = read_register_internal(PC);
            u32 value = arm_functions::align(reg, 4);
            value += (instr.flags.add) ? instr.imm : -instr.imm;
            write_register_internal(instr.Rd, value);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }
            u32 cnt = 0;
            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    //if randomness was used update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                            write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);

                        
                    }

                    address += 4;
                    cnt++;
                }
            }
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STM)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 cnt = 0;
            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_memory_internal(address, read_register_internal((Register)i), 4);
                    address += 4;
                    cnt++;
                }
            }
            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CBZ || instr.name == Mnemonic::CBNZ)
    {
        u32 value = read_register_internal(instr.Rn);
        if ((instr.name == Mnemonic::CBZ && value == 0) || (instr.name == Mnemonic::CBNZ && value != 0))
        {
            branch_write_PC(read_register_internal(PC) + instr.imm);
            increment_pc = false;
        }
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BLX)
    {
        if (evaluate_condition(instr))
        {
            write_register_internal(LR, (read_register_internal(PC) - 2) | 1);
            blx_write_PC(read_register_internal(instr.Rm));
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BX)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(instr.Rm);
            bx_write_PC(reg);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::B)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            branch_write_PC(reg + instr.imm);
            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg = read_register_internal(PC);
            write_register_internal(LR, reg | 1);
            branch_write_PC(reg + instr.imm);

            instruction_executed = true;
            increment_pc         = false;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::POP)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);
            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            u32 end_val = address + arm_functions::bit_count(instr.imm) * 4;

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));
                    address += 4;
                }
            }
            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }

            write_register_internal(SP, end_val);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::PUSH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(SP);

            address -= arm_functions::bit_count(instr.imm) * 4;

            u32 end_val = address;

            if (arm_functions::align(address, 4) != address && !instr.flags.unaligned_allowed)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg1 = read_register_internal((Register)i);


                    write_memory_internal(address, reg1, 4);
                    address += 4;
                }
            }

            write_register_internal(SP, end_val);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::IT && m_decoder.get_architecture() >= Architecture::ARMv7M)
    {
        cpu.psr.it_state = instr.imm;
        UPDATE_PSR
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::NOP || instr.name == Mnemonic::SEV || instr.name == Mnemonic::DSB || instr.name == Mnemonic::ISB || instr.name == Mnemonic::DMB || instr.name == Mnemonic::CSDB
             || instr.name == Mnemonic::DBG || instr.name == Mnemonic::CLREX || instr.name == Mnemonic::SSBB || instr.name == Mnemonic::PSSBB || instr.name == Mnemonic::PLD
             || instr.name == Mnemonic::PLI)
    {
        ADVANCE_PC
        instruction_executed = true;
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDF)
    {
        m_return_code = ReturnCode::UNDEFINED;
        return false;
    }
    else if (instr.name == Mnemonic::STMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    u32 reg = read_register_internal((Register)i);

                    write_memory_internal(address, reg, 4);
                    address += 4;
                }
            }

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, end_val);
            }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDMDB)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            address -= arm_functions::bit_count(instr.imm) * 4;
            u32 end_val = address;

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            for (u32 i = 0; i < 15; ++i)
            {
                if ((instr.imm >> i) & 1)
                {
                    write_register_internal((Register)i, read_memory_internal(address, 4));

                    //if randomness was used update it
                    if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                            write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);

                        
                    }

                    address += 4;
                }
            }

            if ((instr.imm >> 15) & 1)
            {
                bx_write_PC(read_memory_internal(address, 4));
                increment_pc = false;
            }

            if (instr.flags.wback && _1BIT(instr.imm > instr.Rn) != 0)
            {
                write_register_internal(instr.Rn, end_val);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address        = read_register_internal(instr.Rn);
            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);
            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_memory_internal(address, read_register_internal(instr.Rd), 4);
            write_memory_internal(address + 4, read_register_internal(instr.Rm), 4);

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDRD)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);

            if (instr.operand_type == OperandType::RRI)    // LDRD (literal)
            {
                address = arm_functions::align(address, 4);
            }

            u32 offset_address = address + ((instr.flags.add) ? instr.imm : -instr.imm);

            if (instr.flags.index)
            {
                address = offset_address;
            }

            if (arm_functions::align(address, 4) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            write_register_internal(instr.RdHi, read_memory_internal(address, 4));

            //if randomness was used update it
            if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);

                
            }

            write_register_internal(instr.RdLo, read_memory_internal(address + 4, 4));

            //if randomness was used update it
            if((randomness_start_addr <= (address+4)) && ((address+4) < randomness_end_addr)){
                write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);
                
            }

            if (instr.flags.wback)
            {
                write_register_internal(instr.Rn, offset_address);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::STREX || instr.name == Mnemonic::STREXB || instr.name == Mnemonic::STREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::STREX)
            {
                address += instr.imm;
            }

            u32 bytes = 4;
            if (instr.name == Mnemonic::STREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::STREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            if (exclusive_monitors_pass(address, bytes))
            {
                write_memory_internal(address, read_register_internal(instr.Rm), bytes);
                write_register_internal(instr.Rd, 0);
            }
            else
            {
                write_register_internal(instr.Rd, 1);
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::LDREX || instr.name == Mnemonic::LDREXB || instr.name == Mnemonic::LDREXH)
    {
        if (evaluate_condition(instr))
        {
            u32 address = read_register_internal(instr.Rn);
            if (instr.name == Mnemonic::LDREX)
            {
                address += instr.imm;
            }

            u8 bytes = 4;
            if (instr.name == Mnemonic::LDREXB)
            {
                bytes = 1;
            }
            else if (instr.name == Mnemonic::LDREXH)
            {
                bytes = 2;
            }

            if (arm_functions::align(address, bytes) != address)
            {
                m_return_code = ReturnCode::HARD_FAULT;
                return false;
            }

            set_exclusive_monitors(address, bytes);
            write_register_internal(instr.Rd, read_memory_internal(address, bytes));

           //if randomness was used update it
           if((randomness_start_addr <= address) && (address < randomness_end_addr)){

                   write_memory_internal(randomness_start_addr, get_PRNG_randomness() , 4);

               
           }

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TBB || instr.name == Mnemonic::TBH)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1 = read_register_internal(instr.Rn);
            u32 reg2 = read_register_internal(instr.Rm);

            u32 data;
            if (instr.name == Mnemonic::TBH)
            {
                auto [shift_ok, shifted] = arm_functions::LSL(reg2, 1);
                CHECK_SHIFT(shift_ok);
                u32 address           = reg1 + shifted;
                bool ignore_alignment = _1BIT(cpu.CCR >> 3) == 0;
                if (!ignore_alignment && arm_functions::align(address, 2) != address)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
                data = read_memory_internal(address, 2);
            }
            else
            {
                data = read_memory_internal(reg1 + reg2, 1);
            }

            branch_write_PC(read_register_internal(PC) + 2 * data);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::TEQ)
    {
        if (evaluate_condition(instr))
        {
            u32 value;
            u8 carry;
            if (instr.uses_only_registers())
            {
                u32 reg               = read_register_internal(instr.Rm);
                auto [shift_ok, s, c] = arm_functions::shift_c(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
                CHECK_SHIFT(shift_ok);
                value = s;
                carry = c;
            }
            else
            {
                auto [imm_ok, s, c] = arm_functions::thumb_expand_imm_C(instr.imm, cpu.psr.C);
                CHECK_IMM(imm_ok);
                value = s;
                carry = c;
            }

            u32 reg    = read_register_internal(instr.Rn);
            u32 result = reg ^ value;

            cpu.psr.N = result >> 31;
            cpu.psr.Z = (result == 0);
            cpu.psr.C = carry;
            UPDATE_PSR

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SSAT || instr.name == Mnemonic::USAT)
    {
        if (evaluate_condition(instr))
        {
            u32 reg                = read_register_internal(instr.Rn);
            auto [shift_ok, value] = arm_functions::shift(reg, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            u32 result;
            bool sat;
            if (instr.name == Mnemonic::SSAT)
            {
                auto [r, s] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(value)), instr.imm);
                sat         = s;
                result      = arm_functions::sign_extend(r, 5);
            }
            else
            {
                auto [r, s] = arm_functions::unsigned_sat_Q(value, instr.imm);
                sat         = s;
                result      = r;
            }
            write_register_internal(instr.Rd, result);
            if (sat)
            {
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SBFX || instr.name == Mnemonic::UBFX)
    {
        if (evaluate_condition(instr))
        {
            u32 lsbit = instr.imm;
            u32 width = instr.imm2;

            u32 reg = read_register_internal(instr.Rn);

            u32 result = (reg >> lsbit) & (0xFFFFFFFF >> (32 - width));

            if (width + lsbit <= 32)
            {
                if (instr.name == Mnemonic::SBFX)
                {
                    result = arm_functions::sign_extend(result, width);
                }
                write_register_internal(instr.Rd, result);
            }
            else
            {
                m_return_code = ReturnCode::UNPREDICTABLE;
                return false;
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::BFI || instr.name == Mnemonic::BFC)
    {
        if (evaluate_condition(instr))
        {
            u32 lsb   = instr.imm;
            u32 width = instr.imm2;
            u32 msb   = lsb + width;

            u32 old = read_register_internal(instr.Rd);

            u32 low  = 0;
            u32 high = 0;
            if (lsb > 0)
                low = old & (0xFFFFFFFF >> (32 - lsb));
            if (msb < 32)
                high = old & ((u32)0xFFFFFFFF << msb);
            u32 result = low | high;

            if (instr.name == Mnemonic::BFI)
            {
                u32 value = read_register_internal(instr.Rn) & (0xFFFFFFFF >> (32 - width));
                result |= value << lsb;
            }

            write_register_internal(instr.Rd, result);

            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CLZ)
    {
        if (evaluate_condition(instr))
        {
            u32 result = 0;
            u32 val    = read_register_internal(instr.Rm);
            // count leading zeros
            for (u32 i = 0; i < 32; ++i)
            {
                if (val & 0x80000000)
                {
                    break;
                }
                result++;
                val <<= 1;
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MLA || instr.name == Mnemonic::MLS)
    {
        if (evaluate_condition(instr))
        {
            u32 op1    = read_register_internal(instr.Rn);
            u32 op2    = read_register_internal(instr.Rm);
            u32 addend = read_register_internal(instr.Ra);
            u32 result = op1 * op2;
            if (instr.name == Mnemonic::MLA)
            {
                result += addend;
            }
            else
            {
                result = addend - result;
            }
            write_register_internal(instr.Rd, result);
            if (instr.flags.S)
            {
                cpu.psr.N = result >> 31;
                cpu.psr.Z = (result == 0);
                UPDATE_PSR
            }
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMULL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 result = op1 * op2;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1              = read_register_internal(instr.Rn);
            u32 reg2              = read_register_internal(instr.Rm);
            i32 op1               = reg1;
            i32 op2               = reg2;
            i32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UDIV)
    {
        if (evaluate_condition(instr))
        {
            u32 op1               = read_register_internal(instr.Rn);
            u32 op2               = read_register_internal(instr.Rm);
            u32 result            = 0;
            bool div_by_zero_trap = _1BIT(cpu.CCR >> 4) == 1;
            if (op2 == 0)
            {
                if (div_by_zero_trap)
                {
                    m_return_code = ReturnCode::HARD_FAULT;
                    return false;
                }
            }
            else
            {
                result = (u32)std::llround((double)op1 / (double)op2);
            }
            write_register_internal(instr.Rd, result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::SMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            i64 op1    = (i32)reg1;
            i64 op2    = (i32)reg2;
            i64 add    = ((i64)reg3 << 32) | reg4;
            i64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::UMLAL)
    {
        if (evaluate_condition(instr))
        {
            u32 reg1   = read_register_internal(instr.Rn);
            u32 reg2   = read_register_internal(instr.Rm);
            u32 reg3   = read_register_internal(instr.RdHi);
            u32 reg4   = read_register_internal(instr.RdLo);
            u64 op1    = reg1;
            u64 op2    = reg2;
            u64 add    = ((u64)reg3 << 32) | reg4;
            u64 result = op1 * op2 + add;
            write_register_internal(instr.RdHi, (u32)(result >> 32));
            write_register_internal(instr.RdLo, (u32)result);
            instruction_executed = true;
        }
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::CPS)
    {
        if (in_priviledged_mode())
        {
            bool enable      = _1BIT(instr.imm >> 4) == 0;
            bool affectPRI   = _1BIT(instr.imm >> 1) == 1;
            bool affectFAULT = _1BIT(instr.imm) == 1;
            if (enable)
            {
                if (affectPRI)
                    cpu.PRIMASK = 0;
                if (affectFAULT)
                    cpu.FAULTMASK = 0;
            }
            else
            {
                if (affectPRI)
                    cpu.PRIMASK = 1;
                if (affectFAULT && get_execution_priority() > -1)
                    cpu.FAULTMASK = 1;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MRS)
    {
        if (evaluate_condition(instr))
        {
            auto psr  = read_register_internal(Register::PSR);
            u32 value = 0;
            u8 tmp    = _5BIT(instr.imm >> 3);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm) == 1)
                {
                    // IPSR
                }
                if (_1BIT(instr.imm >> 1) == 1)
                {
                    // EPSR reads as zero
                }
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    value |= psr & 0xF8000000;
                    if (get_architecture() == Architecture::ARMv7EM)
                    {
                        // DSP Extension
                        value |= psr & 0x000F0000;
                    }
                }
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        value = read_register_internal(Register::SP);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        value = read_register_internal(Register::SP);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.PRIMASK);
                }
                else if ((tmp == 0b001 || tmp == 0b010) && in_priviledged_mode())
                {
                    value = cpu.BASEPRI;
                }
                else if (tmp == 0b011 && in_priviledged_mode())
                {
                    value = _1BIT(cpu.FAULTMASK);
                }
                else if (tmp == 0b100)
                {
                    // FP Extension not supported
                    value = _2BIT(cpu.CONTROL);
                }
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if (instr.name == Mnemonic::MSR)
    {
        if (evaluate_condition(instr))
        {
            auto value = read_register_internal(instr.Rn);
            auto psr   = read_register_internal(Register::PSR);
            u8 tmp     = _5BIT(instr.imm >> 3);
            u8 mask    = _2BIT(instr.imm >> 8);
            if (tmp == 0b00000)
            {
                if (_1BIT(instr.imm >> 2) == 0)
                {
                    if (_1BIT(mask) == 1)
                    {
                        if (get_architecture() != Architecture::ARMv7EM)
                        {
                            m_return_code = ReturnCode::UNPREDICTABLE;
                            return false;
                        }
                        else
                        {
                            psr = (psr & ~0x000F0000) | (value & 0x000F0000);
                        }
                    }

                    if (_1BIT(mask >> 1) == 1)
                    {
                        psr = (psr & ~0xF8000000) | (value & 0xF8000000);
                    }
                }
                write_register_internal(Register::PSR, psr);
            }
            else if (tmp == 0b00001)
            {
                tmp = _3BIT(instr.imm);
                if (in_priviledged_mode())
                {
                    if (tmp == 0b000)
                    {
                        // SP_MAIN
                        write_register_internal(Register::SP, value);
                    }
                    else if (tmp == 0b001)
                    {
                        // SP_PROCESS
                        write_register_internal(Register::SP, value);
                    }
                }
            }
            else if (tmp == 0b00010)
            {
                tmp = _3BIT(instr.imm);

                if (tmp == 0b000 && in_priviledged_mode())
                {
                    cpu.PRIMASK = _1BIT(value);
                }
                else if (tmp == 0b001 && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b010 && _8BIT(value) != 0 && (_8BIT(value) < cpu.BASEPRI || cpu.BASEPRI == 0) && in_priviledged_mode())
                {
                    cpu.BASEPRI = _8BIT(value);
                }
                else if (tmp == 0b011 && in_priviledged_mode() && get_execution_priority() > -1)
                {
                    cpu.FAULTMASK = _1BIT(value);
                }
                else if (tmp == 0b100 && in_priviledged_mode())
                {
                    cpu.CONTROL = _2BIT(value);
                    // FP Extension not supported
                }
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD8){
        if (evaluate_condition(instr))
        {
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                uint16_t tmp = ((Rn >> (i*8)) & 0xff) + ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(1 << i))) | (((tmp & 0x100) >> 8) << i);
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SEL){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t tmp = read_register_internal((mulator::Register)PSR);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                if(tmp & (1 << (16+i))){ //GE bit set
                    res |= (Rn & (0xff << (i*8)));
                }
                else{
                    res |= (Rm & (0xff << (i*8)));
                }
            }
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::USUB16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                int32_t tmp = ((Rn >> (i*16)) & 0xffff) - ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x30000) >> 16) ^ 0b11) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::UADD16){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 2; ++i){
                uint32_t tmp = ((Rn >> (i*16)) & 0xffff) + ((Rm >> (i*16)) & 0xffff);
                //set APSR.GE register
                cpu.psr.GE = (cpu.psr.GE & (~(0b11 << (i*2)))) | ((((tmp & 0x10000) >> 16) | (((tmp & 0x10000) >> 16) << 1)) << (i*2));
                res |= ((tmp & 0xffff) << (i*16));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHBT){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (value & 0xffff0000) | (Rn & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::PKHTB){
        if(evaluate_condition(instr)){
            auto [shift_ok, value] = arm_functions::shift(instr.Rm, instr.shift_type, instr.shift_amount, cpu.psr.C);
            CHECK_SHIFT(shift_ok);
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t res = (Rn & 0xffff0000) | (value & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBB){
        if(evaluate_condition(instr)){
            int16_t Rn = read_register_internal(instr.Rn) & 0xffff;
            int16_t Rm = read_register_internal(instr.Rm) & 0xffff;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULBT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff);
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTB){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;
    }
    else if(instr.name == Mnemonic::SMULTT){
        if(evaluate_condition(instr)){
            int16_t Rn = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            int16_t Rm = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            uint32_t res = Rn * Rm;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::SMLABB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLABT){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff));
            int32_t operand2 = static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATB){
        if(evaluate_condition(instr)){
            int32_t operand1 = static_cast<int16_t>((read_register_internal(instr.Rn)) >> 16);
            int32_t operand2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SMLATT){
        if(evaluate_condition(instr)){
            uint32_t operand1 = (read_register_internal(instr.Rn) & 0xffff0000) >> 16;
            uint32_t operand2 = (read_register_internal(instr.Rm) & 0xffff0000) >> 16;
            int64_t res = (static_cast<int64_t>(operand1) * operand2) + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, static_cast<uint32_t>(res & 0xffffffff));
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QADD){
        if(evaluate_condition(instr)){
            int64_t i = static_cast<int64_t>(instr.Rm) + static_cast<int32_t>(instr.Rn);
            auto [res, sat] = arm_functions::signed_sat_Q(i, 32);
            write_register_internal(instr.Rd, res);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;   
    }
    else if(instr.name == Mnemonic::QADD16){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            res |= arm_functions::signed_sat(sum1, 16) & 0xffff;
            res |= arm_functions::signed_sat(sum2, 16) << 16;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QADD8){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t sum1 = static_cast<int32_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int32_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff00) >> 8) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff00) >> 8);
            int32_t sum3 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff0000) >> 16) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff0000) >> 16);
            int32_t sum4 = static_cast<int32_t>((read_register_internal(instr.Rn) & 0xff000000) >> 24) + static_cast<int32_t>((read_register_internal(instr.Rm) & 0xff000000) >> 24);
            res |= (arm_functions::signed_sat(sum1, 8) & 0xff);
            res |= ((arm_functions::signed_sat(sum2, 8) & 0xff) << 8);
            res |= ((arm_functions::signed_sat(sum3, 8) & 0xff) << 16);
            res |= ((arm_functions::signed_sat(sum4, 8) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QASX){
        if(evaluate_condition(instr)){
            uint32_t res = 0;
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff0000) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            res |= (arm_functions::signed_sat(diff, 16) & 0xffff);
            res |= ((arm_functions::signed_sat(sum, 16) & 0xffff) << 16);

            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDADD){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) + static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QDSUB){
        if(evaluate_condition(instr)){
            auto [doubled, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) << 1, 32);
            auto [value, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(doubled), 32);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, value);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + ((read_register_internal(instr.Rm) & 0xffff0000) >> 16);
            int32_t diff = ((read_register_internal(instr.Rn) & 0xffff0000) >> 16) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (diff << 16) | (sum & 0xffff);
            if(sum & 0x10000){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USUB8){
        if(evaluate_condition(instr)){
            uint32_t Rn = read_register_internal(instr.Rn);
            uint32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int16_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + (rotated & 0xff)) & 0xffff;
            res |= (((read_register_internal(instr.Rn) & 0xffff0000) + (rotated & 0xff0000)) & 0xffff0000);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;     
    }
    else if(instr.name == Mnemonic::UXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + (rotated & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::UXTB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = rotated & 0x00ff00ff;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            if(diff1 >= 0){
                cpu.psr.GE |= (0b11);
            }
            else{
                cpu.psr.GE &= (0b11111100);
            }
            if(diff2 >= 0){
                cpu.psr.GE |= (0b1100);
            }
            else{
                cpu.psr.GE &= (0b11110011);
            }
            uint32_t res = (diff2 << 16) | (diff1 & 0xffff);
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::SSUB8){
        if(evaluate_condition(instr)){
            int32_t Rn = read_register_internal(instr.Rn);
            int32_t Rm = read_register_internal(instr.Rm);
            uint32_t res = 0;
            for(uint8_t i = 0; i < 4; ++i){
                int32_t tmp = ((Rn >> (i*8)) & 0xff) - ((Rm >> (i*8)) & 0xff);
                //set APSR.GE register
                if(tmp >= 0){
                    cpu.psr.GE |= (0x1 << i);
                }
                else{
                    cpu.psr.GE = (cpu.psr.GE & (~(1 << i)));
                }
                res |= ((tmp & 0xff) << (i*8));
            }
            UPDATE_PSR
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;      
    }
    else if(instr.name == Mnemonic::SXTAB){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xff, 32);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;         
    }
    else if(instr.name == Mnemonic::SXTAB16){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = ((read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(arm_functions::sign_extend(rotated & 0xff,16))) & 0xffff;
            res |= (((read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(arm_functions::sign_extend((rotated & 0xff0000) >> 16, 16))) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SXTAH){
        if(evaluate_condition(instr)){
            auto [shift_ok, rotated] = arm_functions::ROR(read_register_internal(instr.Rm), instr.shift_amount);
            CHECK_SHIFT(shift_ok);
            uint32_t res = (read_register_internal(instr.Rn) + arm_functions::sign_extend(rotated & 0xffff, 16));
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::UASX){
        if(evaluate_condition(instr)){
            int32_t diff = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) >> 16);
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = ((sum & 0xffff) << 16) | (diff & 0xffff);
            write_register_internal(instr.Rd, res);
            if(diff >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0x10000){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSAX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int16_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);;
            uint32_t res = (arm_functions::signed_sat(sum, 16) & 0xffff) | (arm_functions::signed_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB){
        if(evaluate_condition(instr)){
            auto [res, sat] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rm))) - static_cast<int32_t>(read_register_internal(instr.Rn)), 32);
            if(sat){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
            write_register_internal(instr.Rd, res);
        }
        
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;    
    }
    else if(instr.name == Mnemonic::QSUB16){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::signed_sat(diff1, 16) | (arm_functions::signed_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::QSUB8){
        if(evaluate_condition(instr)){
            int64_t diff1 = static_cast<int64_t>(static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff));
            int64_t diff2 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff));
            int64_t diff3 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff));
            int64_t diff4 = static_cast<int64_t>(static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff));
            uint32_t res = arm_functions::signed_sat(diff1, 8) | (arm_functions::signed_sat(diff2, 8) << 8) | (arm_functions::signed_sat(diff3, 8) << 16) | (arm_functions::signed_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm) >> 16));
            uint32_t res = (sum1 & 0xffff) | (sum2 << 16);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SADD8){
        if(evaluate_condition(instr)){
            int16_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int16_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int16_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int16_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = (sum1 & 0xff) | ((sum2 & 0xff) << 8) | ((sum3 & 0xff) << 16) | ((sum4 & 0xff) << 24);
            if(sum1 >= 0){
                cpu.psr.GE |= 0b1; 
            }
            else{
                cpu.psr.GE &= 0b11111110;
            }
            if(sum2 >= 0){
                cpu.psr.GE |= 0b10;
            }
            else{
                cpu.psr.GE &= 0b11111101;
            }
            if(sum3 >= 0){
                cpu.psr.GE |= 0b100; 
            }
            else{
                cpu.psr.GE &= 0b11111011;
            }
            if(sum4 >= 0){
                cpu.psr.GE |= 0b1000;
            }
            else{
                cpu.psr.GE &= 0b11110111;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SASX){
        if(evaluate_condition(instr)){
            int16_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int16_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = (sum << 16) | (diff);
            if(diff >= 0){
                cpu.psr.GE |= 0b11; 
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(sum >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
        }
        UPDATE_PSR
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD16){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum1 & 0b11111111111111110) >> 1) | ((sum2 & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }

        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHADD8){
        if(evaluate_condition(instr)){
            int32_t sum1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) + static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t sum2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t sum3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t sum4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) + static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((sum1 & 0b111111110) >> 1) | ((sum2 & 0b111111110) << 7) | ((sum3 & 0b111111110) << 15) | ((sum4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHASX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) + static_cast<int16_t>((read_register_internal(instr.Rm)) & 0xffff);
            uint32_t res = ((diff & 0b11111111111111110) >> 1) | ((sum & 0b11111111111111110) << 15);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSAX){
        if(evaluate_condition(instr)){
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t sum = static_cast<int16_t>((read_register_internal(instr.Rn) & 0xffff)) + static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff & 0b11111111111111110) << 15) | ((sum & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB16){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            int32_t diff2 = static_cast<int16_t>((read_register_internal(instr.Rn) >> 16)) - static_cast<int16_t>((read_register_internal(instr.Rm)) >> 16);
            uint32_t res = ((diff2 & 0b11111111111111110) << 15) | ((diff1 & 0b11111111111111110) >> 1);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SHSUB8){
        if(evaluate_condition(instr)){
            int32_t diff1 = static_cast<int8_t>(read_register_internal(instr.Rn) & 0xff) - static_cast<int8_t>(read_register_internal(instr.Rm) & 0xff);
            int32_t diff2 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 8) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 8) & 0xff);
            int32_t diff3 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 16) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 16) & 0xff);
            int32_t diff4 = static_cast<int8_t>((read_register_internal(instr.Rn) >> 24) & 0xff) - static_cast<int8_t>((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 & 0b111111110) >> 1) | ((diff2 & 0b111111110) << 7) | ((diff3 & 0b111111110) << 15) | ((diff4 & 0b111111110) << 23);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 + prod2 + static_cast<int64_t>((static_cast<uint64_t>(read_register_internal(instr.RdHi)) << 32) | (read_register_internal(instr.RdLo)));

            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWB){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAWT){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t res = static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Rn))) * op2 + (static_cast<int64_t>(static_cast<int32_t>(read_register_internal(instr.Ra))) << 16);
            write_register_internal(instr.Rd, (res >> 16) & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>((res >> 16) & 0xffffffff);
            if((res >> 16) != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLAD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLADX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSD){
        if(evaluate_condition(instr)){
            uint32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) - prod2 + static_cast<int32_t>(read_register_internal(instr.Ra));
            write_register_internal(instr.Rd, res & 0xffffffff);
            int64_t signed_res = static_cast<int32_t>(res & 0xffffffff);
            if(res != signed_res){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTB){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALBT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLALTT){
        if(evaluate_condition(instr)){
            int32_t op1 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16);
            int32_t op2 = static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            uint64_t res = static_cast<int64_t>(op1) * op2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));            
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMLSLDX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok)
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            uint64_t res = prod1 - prod2 + ((static_cast<int64_t>(read_register_internal(instr.RdHi)) << 32) | read_register_internal(instr.RdLo));
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMMLA){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }  
    else if(instr.name == Mnemonic::SMMLAR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) + static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLS){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMLSR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Ra)) << 32) - static_cast<int64_t>(read_register_internal(instr.Rn)) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMUL){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMMULR){
        if(evaluate_condition(instr)){
            uint64_t res = (static_cast<int64_t>(read_register_internal(instr.Rn))) * static_cast<int32_t>(read_register_internal(instr.Rm));
            res += 0x80000000;
            write_register_internal(instr.Rd, res >> 32);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    } 
    else if(instr.name == Mnemonic::SMUAD){
        if(evaluate_condition(instr)){
            int32_t op2 = static_cast<int32_t>(read_register_internal(instr.Rm));
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUADX){
        if(evaluate_condition(instr)){
            auto[shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)) * static_cast<int32_t>(static_cast<int16_t>(op2 & 0xffff));
            int32_t prod2 = static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)) * static_cast<int32_t>(static_cast<int16_t>(op2 >> 16));
            int64_t res = static_cast<int64_t>(prod1) + prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
            if(res != static_cast<int64_t>(static_cast<int32_t>(res & 0xffffffff))){
                cpu.psr.Q = true;
                UPDATE_PSR
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWB){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMULWT){
        if(evaluate_condition(instr)){
            int64_t op2 = static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rm) >> 16));
            int64_t prod = static_cast<int32_t>(read_register_internal(instr.Rn)) * op2;
            write_register_internal(instr.Rd, (prod >> 16) & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSD){
        if(evaluate_condition(instr)){
            int32_t op2 = read_register_internal(instr.Rm);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SMUSDX){
        if(evaluate_condition(instr)){
            auto [shift_ok, op2] = arm_functions::ROR(read_register_internal(instr.Rm), 16);
            CHECK_SHIFT(shift_ok);
            int32_t prod1 = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) * static_cast<int16_t>(op2 & 0xffff);
            int32_t prod2 = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) * static_cast<int16_t>(op2 >> 16);
            int64_t res = prod1 - prod2;
            write_register_internal(instr.Rd, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount );
            auto [res2, sat2] = arm_functions::signed_sat_Q(static_cast<int64_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount );
            uint32_t res = 0;
            res = arm_functions::sign_extend(res1,16) & 0xffff;
            res |= (arm_functions::sign_extend(res2,16) << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::USAT16){
        if(evaluate_condition(instr)){
            auto [res1, sat1] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff)), instr.shift_amount);
            auto [res2, sat2] = arm_functions::unsigned_sat_Q(static_cast<int32_t>(static_cast<int16_t>(read_register_internal(instr.Rn) >> 16)), instr.shift_amount);
            uint32_t res = 0;
            res = res1 & 0xffff;
            res |= (res2 << 16);
            write_register_internal(instr.Rd, res);
            if(sat1 || sat2){
                cpu.psr.Q = true;
                UPDATE_PSR;
            }
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed; 
    }
    else if(instr.name == Mnemonic::SSAX){
        if(evaluate_condition(instr)){
            int32_t sum = static_cast<int16_t>(read_register_internal(instr.Rn) & 0xffff) + static_cast<int16_t>(read_register_internal(instr.Rm) >> 16);
            int32_t diff = static_cast<int16_t>(read_register_internal(instr.Rn) >> 16) - static_cast<int16_t>(read_register_internal(instr.Rm) & 0xffff);
            uint32_t res = (sum & 0xffff) | ((diff & 0xffff) << 16);
            if(sum >= 0){
                cpu.psr.GE |= 0b11;
            }
            else{
                cpu.psr.GE &= 0b11111100;
            }
            if(diff >= 0){
                cpu.psr.GE |= 0b1100;
            }
            else{
                cpu.psr.GE &= 0b11110011;
            }
            write_register_internal(instr.Rd, res);
            UPDATE_PSR
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = ((sum2 >> 1) << 16) | ((sum1 >> 1) & 0xffff);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UHSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = ((diff1 >> 1) & 0xff) | (((diff2 >> 1) & 0xff) << 8) | (((diff3 >> 1) & 0xff) << 16) | (((diff4 >> 1) & 0xff) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UMAAL){
        if(evaluate_condition(instr)){
            uint64_t res = static_cast<uint64_t>(read_register_internal(instr.Rn)) * read_register_internal(instr.Rm) + read_register_internal(instr.RdHi) + read_register_internal(instr.RdLo);
            write_register_internal(instr.RdHi, res >> 32);
            write_register_internal(instr.RdLo, res & 0xffffffff);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD16){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t sum2 = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) >> 16);
            uint32_t res = arm_functions::unsigned_sat(sum1, 16) | (arm_functions::unsigned_sat(sum2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQADD8){
        if(evaluate_condition(instr)){
            uint32_t sum1 = (read_register_internal(instr.Rn) & 0xff) + (read_register_internal(instr.Rm) & 0xff);
            uint32_t sum2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) + ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t sum3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) + ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t sum4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) + ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(sum1, 8) | (arm_functions::unsigned_sat(sum2, 8) << 8) | (arm_functions::unsigned_sat(sum3, 8) << 16) | (arm_functions::unsigned_sat(sum4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB8){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xff) - (read_register_internal(instr.Rm) & 0xff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff);
            uint32_t diff3 = ((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff);
            uint32_t diff4 = ((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff);
            uint32_t res = arm_functions::unsigned_sat(diff1, 8) | (arm_functions::unsigned_sat(diff2, 8) << 8) | (arm_functions::unsigned_sat(diff3, 8) << 16) | (arm_functions::unsigned_sat(diff4, 8) << 24);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSUB16){
        if(evaluate_condition(instr)){
            uint32_t diff1 = (read_register_internal(instr.Rn) & 0xffff) - (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff2 = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff1, 16) | (arm_functions::unsigned_sat(diff2, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQSAX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) & 0xffff) + (read_register_internal(instr.Rm) >> 16);
            uint32_t diff = ((read_register_internal(instr.Rn) >> 16)) - ((read_register_internal(instr.Rm) & 0xffff));
            uint32_t res = arm_functions::unsigned_sat(sum, 16) | (arm_functions::unsigned_sat(diff, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::UQASX){
        if(evaluate_condition(instr)){
            uint32_t sum = (read_register_internal(instr.Rn) >> 16) + (read_register_internal(instr.Rm) & 0xffff);
            uint32_t diff = ((read_register_internal(instr.Rn) & 0xffff)) - ((read_register_internal(instr.Rm) >> 16));
            uint32_t res = arm_functions::unsigned_sat(diff, 16) | (arm_functions::unsigned_sat(sum, 16) << 16);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USAD8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4;
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    else if(instr.name == Mnemonic::USADA8){
        if(evaluate_condition(instr)){
            uint8_t absdiff1 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn)) & 0xff) - ((read_register_internal(instr.Rm)) & 0xff)));
            uint8_t absdiff2 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 8) & 0xff) - ((read_register_internal(instr.Rm) >> 8) & 0xff)));
            uint8_t absdiff3 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 16) & 0xff) - ((read_register_internal(instr.Rm) >> 16) & 0xff)));
            uint8_t absdiff4 = abs(static_cast<int8_t>(((read_register_internal(instr.Rn) >> 24) & 0xff) - ((read_register_internal(instr.Rm) >> 24) & 0xff)));
            uint32_t res = absdiff1 + absdiff2 + absdiff3 + absdiff4 + read_register_internal(instr.Ra);
            write_register_internal(instr.Rd, res);
        }
        instruction_executed = true;
        ADVANCE_PC
        return instruction_executed;  
    }
    m_return_code = ReturnCode::UNSUPPORTED;
    return false;
}