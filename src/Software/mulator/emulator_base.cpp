#include "Software/mulator/arm_functions.h"
#include "Software/mulator/emulator.h"

#include <omp.h>

#include <cstring>
#include <stdexcept>
#include <iostream>

#include <unordered_map>

using namespace mulator;
#define REDUCE_PROBEVALUES

Emulator::Emulator(Architecture arch, boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> ThreadPrng, uint32_t NrOfPipelineStages) : m_decoder(arch), m_prolead_prng(ThreadPrng)
{
    m_emulated_time  = 0;
    m_cpu_state.time = 0;
    m_memory_shadow_register = 0;
    m_return_code    = ReturnCode::UNINITIALIZED;

    m_ram.bytes   = nullptr;
    m_flash.bytes = nullptr;
    m_ram.accessed_in_probing_scope = nullptr;
    m_flash.accessed_in_probing_scope = nullptr;
    m_pipeline_stages = NrOfPipelineStages;
    m_pipeline_cpu_states.resize(m_pipeline_stages);

    std::memset(&m_cpu_state, 0, sizeof(m_cpu_state));
    m_cpu_state.registers[Register::LR] = 0xFFFFFFFF;
}

Emulator::Emulator(const Emulator& other) : m_decoder(other.get_architecture()), m_prolead_prng{other.m_prolead_prng}
{
    m_memory_shadow_register = 0;

    m_return_code = other.m_return_code;

    m_flash       = other.m_flash;
    m_flash.bytes = new u8[m_flash.size];
    m_flash.accessed_in_probing_scope = new bool[m_flash.size];
    std::memcpy(m_flash.bytes, other.m_flash.bytes, m_flash.size);
    std::memcpy(m_flash.accessed_in_probing_scope, other.m_flash.accessed_in_probing_scope, m_flash.size);

    m_ram       = other.m_ram;
    m_ram.bytes = new u8[m_ram.size];
    m_ram.accessed_in_probing_scope = new bool[m_ram.size];
    std::memcpy(m_ram.bytes, other.m_ram.bytes, m_ram.size);
    std::memcpy(m_ram.accessed_in_probing_scope, other.m_ram.accessed_in_probing_scope, m_ram.size);


    m_pipeline_cpu_states = other.m_pipeline_cpu_states;
    m_pipeline_stages = other.m_pipeline_stages;

    m_cpu_state     = other.m_cpu_state;
    m_emulated_time = other.m_emulated_time;

}

Emulator::~Emulator()
{
    delete[] m_ram.bytes;
    delete[] m_flash.bytes;
    delete[] m_ram.accessed_in_probing_scope;
    delete[] m_flash.accessed_in_probing_scope;
}

InstructionDecoder Emulator::get_decoder() const
{
    return m_decoder;
}

Architecture Emulator::get_architecture() const
{
    return m_decoder.get_architecture();
}

void Emulator::set_flash_region(u32 offset, u32 size)
{
    if (m_flash.bytes != nullptr)
    {
        delete[] m_flash.bytes;
    }

    if (m_flash.accessed_in_probing_scope != nullptr)
    {
        delete[] m_flash.accessed_in_probing_scope;
    }

    m_flash.offset         = offset;
    m_flash.size           = size;
    m_flash.bytes          = new u8[size];
    m_flash.accessed_in_probing_scope = new bool[size];
    m_flash.access.read    = true;
    m_flash.access.write   = false;
    m_flash.access.execute = true;
    std::memset(m_flash.bytes, 0xFF, size);
    std::memset(m_flash.accessed_in_probing_scope, false, size);
}
u32 Emulator::get_flash_offset() const
{
    return m_flash.offset;
}
u32 Emulator::get_flash_size() const
{
    return m_flash.size;
}
u8* Emulator::get_flash() const
{
    return m_flash.bytes;
}

void Emulator::set_ram_region(u32 offset, u32 size)
{
    if (m_ram.bytes != nullptr)
    {
        delete[] m_ram.bytes;
    }

    if (m_ram.accessed_in_probing_scope != nullptr)
    {
        delete[] m_ram.accessed_in_probing_scope;
    }

    m_ram.offset         = offset;
    m_ram.size           = size;
    m_ram.bytes          = new u8[size];
    m_ram.accessed_in_probing_scope = new bool[size];
    m_ram.access.read    = true;
    m_ram.access.write   = true;
    m_ram.access.execute = false;

    std::memset(m_ram.bytes, 0x00, size);
    std::memset(m_ram.accessed_in_probing_scope, false, size);
}
u32 Emulator::get_ram_offset() const
{
    return m_ram.offset;
}
u32 Emulator::get_ram_size() const
{
    return m_ram.size;
}
u8* Emulator::get_ram() const
{
    return m_ram.bytes;
}

u32 Emulator::read_register(Register reg) const
{
    if ((u32)reg >= REGISTER_COUNT)
    {
        throw std::runtime_error("INVALID_REGISTER");
    }

    if (reg == PC)
    {
        return m_cpu_state.registers[Register::PC] + 4;
    }

    return m_cpu_state.registers[reg];
}

void Emulator::write_register(Register reg, u32 value)
{
    if ((u32)reg >= REGISTER_COUNT)
    {
        throw std::runtime_error("INVALID_REGISTER");
    }

    if (reg == SP)
    {
        value = arm_functions::align(value, 4);
    }
    else if (reg == PSR)
    {
        if (get_architecture() > Architecture::ARMv6M)
        {
            value &= 0xFE00FC00;
        }
        else
        {
            value &= 0xF0000000;
        }
        m_cpu_state.psr.N = _1BIT(value >> 31);
        m_cpu_state.psr.Z = _1BIT(value >> 30);
        m_cpu_state.psr.C = _1BIT(value >> 29);
        m_cpu_state.psr.V = _1BIT(value >> 28);
        m_cpu_state.psr.Q = _1BIT(value >> 27);

        m_cpu_state.psr.it_state = (_2BIT(value >> 25) << 6) | _6BIT(value >> 10);
    }

    m_cpu_state.registers[reg] = value;
}

void Emulator::read_memory(u32 address, u8* buffer, u32 len) const
{
    if (m_flash.contains(address, len))
    {
        std::memcpy(buffer, m_flash.get(address), len);
    }
    else if (m_ram.contains(address, len))
    {
        std::memcpy(buffer, m_ram.get(address), len);
    }
    else
    {
        throw std::runtime_error("INVALID_MEMORY_ACCESS");
    }
}

void Emulator::write_memory(u32 dst_address, const u8* buffer, u32 len)
{
    if (m_flash.contains(dst_address, len))
    {
        std::memcpy(m_flash.get(dst_address), buffer, len);
    }
    else if (m_ram.contains(dst_address, len))
    {
        std::memcpy(m_ram.get(dst_address), buffer, len);
    }
    else
    {
        throw std::runtime_error("INVALID_MEMORY_ACCESS");
    }
}

void Emulator::emulate_PROLEAD(::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, const int InstrNr, const uint64_t SimulationIdx, const uint32_t randomness_start_addr, const uint32_t randomness_end_addr){
    bool MemoryOperation = false;
    
    if (m_ram.bytes == nullptr || m_flash.bytes == nullptr)
    {
        printf("RAM and/or FLASH uninitialized. Aborting...\n");
        exit(-1);
    }

    m_return_code   = ReturnCode::OK;

    branch_write_PC(m_cpu_state.registers[PC]);
    
    /*
    *           CLOCK_CPU Started
    */

    u32 address = read_register_internal(Register::PC) - 4; //is address as in disassembled file 
    auto memory = validate_address(address);                //this is the isa encoded instruction


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    //the isa encoded instruction will be decoded and returns instruction class
    auto [status, instr] = m_decoder.decode_instruction(address, memory, m_decoder.get_instruction_size(memory), in_IT_block(), last_in_IT_block());
    if (status != ReturnCode::OK)
    {
        m_return_code = status;
        return;
    }


    bool InTestClockCycles = false;

    if(std::binary_search(ThreadSimulation.TestClockCycles.begin(), ThreadSimulation.TestClockCycles.end(), InstrNr)){
        InTestClockCycles = true;
    }

    execute_PROLEAD(instr, ThreadSimulation, ProbeTracker, Helper,  InTestClockCycles, MemoryOperation, InstrNr, SimulationIdx, randomness_start_addr, randomness_end_addr, ProbeValues);

    
    u32 PSR_value = 0;
    if (m_psr_updated)
    {
        
        PSR_value |= ((u32)m_cpu_state.psr.N) << 31;
        PSR_value |= ((u32)m_cpu_state.psr.Z) << 30;
        PSR_value |= ((u32)m_cpu_state.psr.C) << 29;
        PSR_value |= ((u32)m_cpu_state.psr.V) << 28;
        PSR_value |= ((u32)m_cpu_state.psr.Q) << 27;

        PSR_value |= (m_cpu_state.psr.GE & 0xf) << 16;

        PSR_value |= (((u32)m_cpu_state.psr.it_state >> 6) << 25) | (_6BIT((u32)m_cpu_state.psr.it_state) << 10);

        write_register_internal(Register::PSR, PSR_value);

    }

    //write cpu state after executing current instruction into pipeline forwarding vector -> stores up to #NrOfPipelineStages last states 
    //shift elements of vector one position to left
    std::rotate(m_pipeline_cpu_states.begin(), m_pipeline_cpu_states.begin() + 1, m_pipeline_cpu_states.end());

    //fill last element in vector with new cpu state
    m_pipeline_cpu_states.back() = m_cpu_state;
    m_pipeline_cpu_states.back().containing_valid_pipeline_values = true;

    if(InTestClockCycles && (!MemoryOperation)){

        uint8_t RegNr = 17, low_RegNr = 17, high_RegNr = 17;
        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();;

        /**
         * @brief Probe all specified combinations
         * 
         */
        switch(to_int(instr.Instruction::Rd)){
            case 0xFFFFFFFF: break;
            default: 
                RegNr = to_int(instr.Instruction::Rd);
                uint32_t DestinationRegisterValue = read_register(instr.Instruction::Rd);
                uint32_t PCRegisterValue = read_register(Register::PC);

                uint8_t SeperatePCUpdate = (uint8_t)(RegNr != Register::PC);

                ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();

                //one resize for all following probes
                uint32_t ProbeSize = 0;
                //add normal probe sizes
                ProbeSize = Helper.NormalProbesIncluded.at(RegNr).size() + SeperatePCUpdate * Helper.NormalProbesIncluded.at(Register::PC).size() + (uint8_t)(m_psr_updated) * Helper.NormalProbesIncluded.at(Register::PSR).size();
                //add horizontal probe sizes
                ProbeSize += ((uint8_t)(!Helper.HorizontalProbesExcluded.at(RegNr))) + ((uint8_t)((SeperatePCUpdate && ((uint8_t)(!Helper.HorizontalProbesExcluded.at(Register::PC)))))) + ((uint8_t)(m_psr_updated && (!Helper.HorizontalProbesExcluded.at(Register::PSR))));
                //add vertical probe sizes
                ProbeSize += Helper.VerticalProbesSize.at(RegNr).back() + SeperatePCUpdate * (Helper.VerticalProbesSize.at(Register::PC).back() - Helper.VerticalProbesSize.at(Register::PC).at(RegNr)) + (uint8_t)m_psr_updated * SeperatePCUpdate * (Helper.VerticalProbesSize.at(Register::PSR).back() - Helper.VerticalProbesSize.at(Register::PSR).at(RegNr) - Helper.VerticalProbesSize.at(Register::PSR).at(Register::PC)) + (uint8_t)m_psr_updated * (uint8_t)(!SeperatePCUpdate) * (Helper.VerticalProbesSize.at(Register::PSR).back() - Helper.VerticalProbesSize.at(Register::PSR).at(Register::PC));
                //add full horizontal probe sizes
                ProbeSize += Helper.FullHorizontalProbesSize.at(RegNr).back() + SeperatePCUpdate * (Helper.FullHorizontalProbesSize.at(Register::PC).back() - Helper.FullHorizontalProbesSize.at(Register::PC).at(RegNr)) + (uint8_t)m_psr_updated * SeperatePCUpdate * (Helper.FullHorizontalProbesSize.at(Register::PSR).back() - Helper.FullHorizontalProbesSize.at(Register::PSR).at(RegNr) - Helper.FullHorizontalProbesSize.at(Register::PSR).at(Register::PC)) + (uint8_t)m_psr_updated * (uint8_t)(!SeperatePCUpdate) * (Helper.FullHorizontalProbesSize.at(Register::PSR).back() - Helper.FullHorizontalProbesSize.at(Register::PSR).at(Register::PC));
                //add full vertical probe sizes
                ProbeSize += (uint8_t)Helper.ProbeFullVertical * Helper.FullVerticalProbesSize;



                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + ProbeSize);


                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << CYCLE_OFFSET) | (4 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);

                //normal probe Rd
                Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(RegNr), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(RegNr), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(RegNr), InstrNr, SimulationIdx, DestinationRegisterValue, RegNr);

                //normal probe PC
                if(SeperatePCUpdate){
                    Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(Register::PC), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(Register::PC), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), InstrNr, SimulationIdx, PCRegisterValue, Register::PC);
                }

                //normal probe PSR
                if(m_psr_updated){
                    Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(Register::PSR), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(Register::PSR), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), InstrNr, SimulationIdx, PSR_value, Register::PSR);
                }

                //horizontal probe Rd
                if(!Helper.HorizontalProbesExcluded.at(RegNr)){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(RegNr), Helper.HorizontalBitsIncluded.at(RegNr).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, RegNr);
                }

                //horizontal probe PC
                if(SeperatePCUpdate && ((uint8_t)(!Helper.HorizontalProbesExcluded.at(Register::PC)))){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(Register::PC), Helper.HorizontalBitsIncluded.at(Register::PC).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, Register::PC);
                }

                //horizontal probe PSR
                if(m_psr_updated && ((uint8_t)(!Helper.HorizontalProbesExcluded.at(Register::PSR)))){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), Helper.HorizontalBitsIncluded.at(Register::PSR).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, Register::PSR);
                }

                //vertical probe Rd
                uint8_t PartnerRegNr, BitIdx;
                uint8_t HigherIdOccurred = 0;
                bool Increment_HigherId = false;

                for(const auto& tup: Helper.VerticalProbesIncluded.at(RegNr)){
                    std::tie(PartnerRegNr, BitIdx) = tup;
                    if((PartnerRegNr == Register::PC) || ((PartnerRegNr == Register::PSR) && m_psr_updated)){
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (HigherIdOccurred << DEPENDENCY_OFFSET) | (7 << ID_OFFSET) | (RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + 2 * ThreadSimulation.TestTransitional);
                        Software::Probing::CreateLargeVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(RegNr), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        Increment_HigherId = true;
                    }
                    else{
                        HigherIdOccurred += (uint8_t)Increment_HigherId;
                        Increment_HigherId = false;
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (HigherIdOccurred << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                        Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(RegNr), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                    }
                }

                //vertical probe PC
                if(SeperatePCUpdate){
                    for(const auto& tup: Helper.VerticalProbesIncluded.at(Register::PC)){
                        std::tie(PartnerRegNr, BitIdx) = tup;
                        
                        if((PartnerRegNr == RegNr)){
                            continue;
                        }
                        else if((PartnerRegNr == Register::PSR) && m_psr_updated){
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (3 << DEPENDENCY_OFFSET) | (7 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + 2 * ThreadSimulation.TestTransitional);
                            Software::Probing::CreateLargeVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (3 << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                            Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        }
                    }
                }

                //vertical probe PSR
                if(m_psr_updated){
                    for(const auto& tup: Helper.VerticalProbesIncluded.at(Register::PSR)){
                        std::tie(PartnerRegNr, BitIdx) = tup;
                        if((PartnerRegNr == RegNr || (PartnerRegNr == Register::PC))){
                            continue;
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (4 << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (Register::PSR << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                            Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        }
                    }
                }


                //full horizontal probe

                if(Helper.ProbeFullHorizontal){
                    HigherIdOccurred = 0;
                    // if(!Helper.FullHRRegisterExcluded.at(RegNr)){
                   
                    for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(RegNr)){
                        if((RegisterIndex == Register::PC) || ((RegisterIndex == Register::PSR) && m_psr_updated)){
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((5 + HigherIdOccurred) << DEPENDENCY_OFFSET) |  (9 << ID_OFFSET) | (RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(RegisterIndex).size() + (1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(RegNr).size());
                            Software::Probing::CreateLargeFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            HigherIdOccurred = 1;
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((5 + HigherIdOccurred) << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | (Helper.NormalProbesIncluded.at(RegisterIndex).size() + (1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(RegNr).size());
                            Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                        }

                    }
                    // }

                    if(SeperatePCUpdate){
                        for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(Register::PC)){

                            if((RegisterIndex == RegNr)){
                                continue;
                            }
                            else if((RegisterIndex == Register::PSR) && m_psr_updated){
                                ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (7 << DEPENDENCY_OFFSET) | (9 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(RegisterIndex).size() + (1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(Register::PC).size());
                                Software::Probing::CreateLargeFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            }
                            else{
                                ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (7 << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | (Helper.NormalProbesIncluded.at(RegisterIndex).size() + (1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(Register::PC).size());
                                Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            }
                        }
                    }

                    if(m_psr_updated){
                        for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(Register::PSR)){
                            if((RegisterIndex == RegNr || (RegisterIndex == Register::PC))){
                                continue;
                            }
                            else{
                                ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (8 << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (Register::PSR << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | (Helper.NormalProbesIncluded.at(RegisterIndex).size() + (1 + ThreadSimulation.TestTransitional) * Helper.NormalProbesIncluded.at(Register::PSR).size());
                                Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            }
                        }
                    }
                }

                //full vertical probe
                if(Helper.ProbeFullVertical){
                
                    if(m_psr_updated && SeperatePCUpdate){ //Rd + PC + PSR
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (9 << DEPENDENCY_OFFSET) | (11 << ID_OFFSET) | (RegNr << REG1_OFFSET);
                        uint32_t TransitionValueRegNr = ProbeTracker.RegisterLatestValue.at(RegNr);
                        uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                        uint32_t TransitionValuePSR = ProbeTracker.RegisterLatestValue.at(Register::PSR);
                        for(const auto& Bit: Helper.FullVerticalRelevantBits){ 
                            Software::Probing::CreateLargeFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, RegNr, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValueRegNr, TransitionValuePC, TransitionValuePSR);
                        }

                    }
                    else if(m_psr_updated && (!SeperatePCUpdate)){ // (Rd = PC) + PSR
                        uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                        uint32_t TransitionValuePSR = ProbeTracker.RegisterLatestValue.at(Register::PSR);
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (9 << DEPENDENCY_OFFSET)  | (10 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (Register::PSR << REG2_OFFSET);
                        for(const auto& Bit: Helper.FullVerticalRelevantBits){
                            Software::Probing::CreateSmallFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, Register::PC, Register::PSR, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValuePC, TransitionValuePSR);
                        }
                    }
                    else if(!m_psr_updated && (SeperatePCUpdate)){ //Rd + PC
                        uint32_t TransitionValueRegNr = ProbeTracker.RegisterLatestValue.at(RegNr);
                        uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (9 << DEPENDENCY_OFFSET)  | (10 << ID_OFFSET) | (RegNr << REG1_OFFSET) | (Register::PC << REG2_OFFSET);
                        for(const auto& Bit: Helper.FullVerticalRelevantBits){
                            Software::Probing::CreateSmallFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, RegNr, Register::PC, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValueRegNr, TransitionValuePC);
                        }
                    }
                    else{ //Rd
                        uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (9 << DEPENDENCY_OFFSET)  | (12 << ID_OFFSET) | (Register::PC << REG1_OFFSET);
                        for(const auto& Bit: Helper.FullVerticalRelevantBits){
                            Software::Probing::CreateOneRegisterOnlyFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, Register::PC, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValuePC);
                        }
                    }
                }
            
                //set transition values and cycles of changed registers
                ProbeTracker.RegisterLatestClockCycle.at(RegNr) = InstrNr;
                ProbeTracker.RegisterLatestValue.at(RegNr) = DestinationRegisterValue;
                if(SeperatePCUpdate){
                    ProbeTracker.RegisterLatestClockCycle.at(Register::PC) = InstrNr;
                    ProbeTracker.RegisterLatestValue.at(Register::PC) = PCRegisterValue;
                }
                if(m_psr_updated){
                    ProbeTracker.RegisterLatestClockCycle.at(Register::PSR) = InstrNr;
                    ProbeTracker.RegisterLatestValue.at(Register::PSR) = PSR_value;
                }


        }
        switch(to_int(instr.Instruction::RdHi)){ //everytime RdHi is used, also RdLo is used -> check only one register occurrance
            case 0xFFFFFFFF: break;
            default: 
                //registers have to be ordered according to register number
                if(to_int(instr.Instruction::RdHi) > to_int(instr.Instruction::RdLo)){ // RdHi has higher register number
                    high_RegNr= to_int(instr.Instruction::RdHi);
                    low_RegNr = to_int(instr.Instruction::RdLo);
                }
                else{
                    high_RegNr = to_int(instr.Instruction::RdLo);
                    low_RegNr = to_int(instr.Instruction::RdHi);
                }

                uint32_t high_DestinationRegisterValue = read_register((mulator::Register)high_RegNr);
                uint32_t low_DestinationRegisterValue = read_register((mulator::Register)low_RegNr);
                uint32_t PCRegisterValue = read_register(Register::PC);
                
                //one resize for all following probes
                uint32_t ProbeSize = 0;
                //add normal probe sizes
                ProbeSize = Helper.NormalProbesIncluded.at(low_RegNr).size() + Helper.NormalProbesIncluded.at(high_RegNr).size() + Helper.NormalProbesIncluded.at(Register::PC).size() + (uint8_t)(m_psr_updated) * Helper.NormalProbesIncluded.at(Register::PSR).size();

                //add horizontal probe sizes
                ProbeSize += ((uint8_t)(!Helper.HorizontalProbesExcluded.at(low_RegNr))) + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(high_RegNr))) + ((uint8_t)(!Helper.HorizontalProbesExcluded.at(Register::PC))) + ((uint8_t)(m_psr_updated && (!Helper.HorizontalProbesExcluded.at(Register::PSR))));

                // add vertical probe sizes
                ProbeSize += Helper.VerticalProbesSize.at(low_RegNr).back() + Helper.VerticalProbesSize.at(high_RegNr).back() - Helper.VerticalProbesSize.at(high_RegNr).at(low_RegNr) + Helper.VerticalProbesSize.at(Register::PC).back() - Helper.VerticalProbesSize.at(Register::PC).at(low_RegNr) - Helper.VerticalProbesSize.at(Register::PC).at(high_RegNr) + (uint8_t)m_psr_updated * (Helper.VerticalProbesSize.at(Register::PSR).back() - Helper.VerticalProbesSize.at(Register::PSR).at(low_RegNr) - Helper.VerticalProbesSize.at(Register::PSR).at(high_RegNr) - Helper.VerticalProbesSize.at(Register::PSR).at(Register::PC));

                // //add full horizontal probe sizes
                ProbeSize += Helper.FullHorizontalProbesSize.at(low_RegNr).back() + Helper.FullHorizontalProbesSize.at(high_RegNr).back() - Helper.FullHorizontalProbesSize.at(high_RegNr).at(low_RegNr) + Helper.FullHorizontalProbesSize.at(Register::PC).back() - Helper.FullHorizontalProbesSize.at(Register::PC).at(low_RegNr) - Helper.FullHorizontalProbesSize.at(Register::PC).at(high_RegNr) + (uint8_t)m_psr_updated * (Helper.FullHorizontalProbesSize.at(Register::PSR).back() - Helper.FullHorizontalProbesSize.at(Register::PSR).at(low_RegNr) - Helper.FullHorizontalProbesSize.at(Register::PSR).at(high_RegNr) - Helper.FullHorizontalProbesSize.at(Register::PSR).at(Register::PC));

                //add full vertical probe sizes
                ProbeSize += (uint8_t)Helper.ProbeFullVertical * Helper.FullVerticalProbesSize;


                ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
                
                // one resize for all following probes
                ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + ProbeSize);

                uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << CYCLE_OFFSET) | (4 << ID_OFFSET) | (1 << ThreadSimulation.TestTransitional);

                //normal probe RdLo
                Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(low_RegNr), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(low_RegNr), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(low_RegNr), InstrNr, SimulationIdx, low_DestinationRegisterValue, low_RegNr);

                //normal probe RdHi
                Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(high_RegNr), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(high_RegNr), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), InstrNr, SimulationIdx, high_DestinationRegisterValue, high_RegNr);

                //normal probe PC
                Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(Register::PC), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(Register::PC), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), InstrNr, SimulationIdx, PCRegisterValue, Register::PC);

                //normal probe PSR
                if(m_psr_updated){
                    Software::Probing::CreateNormalProbe(Helper.NormalProbesIncluded.at(Register::PSR), ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeValues.at(Register::PSR), ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), InstrNr, SimulationIdx, PSR_value, Register::PSR);
                }

                //horizontal probe RdLo
                if(!Helper.HorizontalProbesExcluded.at(low_RegNr)){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(low_RegNr), Helper.HorizontalBitsIncluded.at(low_RegNr).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, low_RegNr);
                }

                //horizontal probe RdHi
                if(!Helper.HorizontalProbesExcluded.at(high_RegNr)){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), Helper.HorizontalBitsIncluded.at(high_RegNr).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, high_RegNr);
                }

                //horizontal probe PC
                if(!Helper.HorizontalProbesExcluded.at(Register::PC)){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(Register::PC), Helper.HorizontalBitsIncluded.at(Register::PC).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, Register::PC);
                }

                //horizontal probe PSR
                if(m_psr_updated && (!Helper.HorizontalProbesExcluded.at(Register::PSR))){
                    Software::Probing::CreateHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), Helper.HorizontalBitsIncluded.at(Register::PSR).size() << ThreadSimulation.TestTransitional, ProbeIndex, InstrNr, Register::PSR);
                }

                
                uint8_t PartnerRegNr, BitIdx;
                uint8_t HigherIdOccurred = 0;
                bool Increment_HigherId = false;

                //vertical probe RdLo
                for(const auto& tup: Helper.VerticalProbesIncluded.at(low_RegNr)){
                    std::tie(PartnerRegNr, BitIdx) = tup;
                    if((PartnerRegNr == Register::PC) || ((PartnerRegNr == Register::PSR) && m_psr_updated) || (PartnerRegNr == high_RegNr)){
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((HigherIdOccurred) << DEPENDENCY_OFFSET) | (7 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + 2 * ThreadSimulation.TestTransitional);
                        Software::Probing::CreateLargeVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(low_RegNr), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        Increment_HigherId = true;
                    }
                    else{
                        HigherIdOccurred += (uint8_t)Increment_HigherId;
                        Increment_HigherId = false;
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((HigherIdOccurred) << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                        Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(low_RegNr),  ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                    }
                }

                //vertical probe RdHi
                Increment_HigherId = false;
                HigherIdOccurred += 1;
                for(const auto& tup: Helper.VerticalProbesIncluded.at(high_RegNr)){
                    std::tie(PartnerRegNr, BitIdx) = tup;
                    if((PartnerRegNr == Register::PC) || ((PartnerRegNr == Register::PSR) && m_psr_updated)){
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((HigherIdOccurred) << DEPENDENCY_OFFSET) | (7 << ID_OFFSET) | (high_RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + 2 * ThreadSimulation.TestTransitional);
                        Software::Probing::CreateLargeVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        Increment_HigherId = true;
                    }
                    else if((PartnerRegNr == low_RegNr)){
                        continue;
                    }
                    else{
                        HigherIdOccurred += (uint8_t)Increment_HigherId;
                        Increment_HigherId = false;
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((HigherIdOccurred) << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (high_RegNr << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                        Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                    }
                }

                //vertical probe PC
                for(const auto& tup: Helper.VerticalProbesIncluded.at(Register::PC)){
                    std::tie(PartnerRegNr, BitIdx) = tup;
                    
                    if((PartnerRegNr == low_RegNr) || (PartnerRegNr == high_RegNr)){
                        continue;
                    }
                    else if((PartnerRegNr == Register::PSR) && m_psr_updated){
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (5 << DEPENDENCY_OFFSET) | (7 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + 2 * ThreadSimulation.TestTransitional);
                        Software::Probing::CreateLargeVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                    }
                    else{
                        ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (5 << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                        Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                    }
                }

                //vertical probe PSR
                if(m_psr_updated){
                    for(const auto& tup: Helper.VerticalProbesIncluded.at(Register::PSR)){
                        std::tie(PartnerRegNr, BitIdx) = tup;
                        if(((PartnerRegNr == high_RegNr) || (PartnerRegNr == low_RegNr) || (PartnerRegNr == Register::PC))){
                            continue;
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (6 << DEPENDENCY_OFFSET) | (6 << ID_OFFSET) | (Register::PSR << REG1_OFFSET) | (PartnerRegNr << REG2_OFFSET) | (BitIdx << BIT_OFFSET) | (2 + ThreadSimulation.TestTransitional);
                            Software::Probing::CreateSmallVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), ProbeTracker.RegisterLatestClockCycle.at(PartnerRegNr));
                        }
                    }
                }

                //full horizontal probe
                HigherIdOccurred = 0;
                if(Helper.ProbeFullHorizontal){
                    // RdLo
                    for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(low_RegNr)){
                        if((RegisterIndex == Register::PC) || ((RegisterIndex == Register::PSR) && m_psr_updated) || (RegisterIndex == high_RegNr)){                      
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((7 + HigherIdOccurred) << DEPENDENCY_OFFSET) | (9 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(low_RegNr).size() << ThreadSimulation.TestTransitional) + (Helper.NormalProbesIncluded.at(RegisterIndex).size() << ThreadSimulation.TestTransitional));
                            Software::Probing::CreateLargeFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(low_RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            HigherIdOccurred += 1;
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((7 + HigherIdOccurred) << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(low_RegNr).size() << ThreadSimulation.TestTransitional) + Helper.NormalProbesIncluded.at(RegisterIndex).size());
                            Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(low_RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                        }

                    }

                    //RdHi
                    HigherIdOccurred = 0;
                    for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(high_RegNr)){
                        if((RegisterIndex == Register::PC) || ((RegisterIndex == Register::PSR) && m_psr_updated)){
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((10 + HigherIdOccurred) << DEPENDENCY_OFFSET) | (9 << ID_OFFSET) | (high_RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(high_RegNr).size() << ThreadSimulation.TestTransitional) + (Helper.NormalProbesIncluded.at(RegisterIndex).size() << ThreadSimulation.TestTransitional));
                            Software::Probing::CreateLargeFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            HigherIdOccurred = 1;
                        }
                        else if((RegisterIndex == low_RegNr)){
                            continue;
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | ((10 + HigherIdOccurred) << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (high_RegNr << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(high_RegNr).size() << ThreadSimulation.TestTransitional) + Helper.NormalProbesIncluded.at(RegisterIndex).size());
                            Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(high_RegNr), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                        }
                    }

                    // PC
                    for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(Register::PC)){
                        
                        if((RegisterIndex == low_RegNr) || (RegisterIndex == high_RegNr)){
                            continue;
                        }
                        else if((RegisterIndex == Register::PSR) && m_psr_updated){
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (12 << DEPENDENCY_OFFSET) | (9 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(Register::PC).size() << ThreadSimulation.TestTransitional) + (Helper.NormalProbesIncluded.at(RegisterIndex).size() << ThreadSimulation.TestTransitional));
                            Software::Probing::CreateLargeFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                        }
                        else{
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (12 << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (Register::PC << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(Register::PC).size() << ThreadSimulation.TestTransitional) + Helper.NormalProbesIncluded.at(RegisterIndex).size());
                            Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PC), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                        }
                    }

                    //PSR
                    if(m_psr_updated){
                        for(const auto& RegisterIndex: Helper.FULLHRProbesIncluded.at(Register::PSR)){
                            if(((RegisterIndex == high_RegNr) || (RegisterIndex == low_RegNr) || (RegisterIndex == Register::PC))){
                                continue;
                            }
                            else{
                                ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (13 << DEPENDENCY_OFFSET) | (8 << ID_OFFSET) | (Register::PSR << REG1_OFFSET) | (RegisterIndex << REG2_OFFSET) | ((Helper.NormalProbesIncluded.at(Register::PSR).size() << ThreadSimulation.TestTransitional) + Helper.NormalProbesIncluded.at(RegisterIndex).size());
                                Software::Probing::CreateSmallFullHorizontalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), ProbeInfo, ProbeIndex, ProbeTracker.RegisterLatestClockCycle.at(Register::PSR), ProbeTracker.RegisterLatestClockCycle.at(RegisterIndex));
                            }
                        }
                    }

                }

                //full vertical probe

                if(Helper.ProbeFullVertical){
                        if(m_psr_updated){ //RdHi + RdLo + PC + PSR
                            uint32_t TransitionValueRdHi = ProbeTracker.RegisterLatestValue.at(high_RegNr);
                            uint32_t TransitionValueRdLo = ProbeTracker.RegisterLatestValue.at(low_RegNr);
                            uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                            uint32_t TransitionValuePSR = ProbeTracker.RegisterLatestValue.at(Register::PSR);
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (14 << DEPENDENCY_OFFSET) | (14 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (high_RegNr << REG2_OFFSET);
                            for(const auto& Bit: Helper.FullVerticalRelevantBits){ 
                                Software::Probing::CreateDSPLargeFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, low_RegNr, high_RegNr, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValueRdLo, TransitionValueRdHi, TransitionValuePC, TransitionValuePSR);
                            }
                        }
                        else{   //RdHi + RdLo + PC
                            uint32_t TransitionValueRdHi = ProbeTracker.RegisterLatestValue.at(high_RegNr);
                            uint32_t TransitionValueRdLo = ProbeTracker.RegisterLatestValue.at(low_RegNr);
                            uint32_t TransitionValuePC = ProbeTracker.RegisterLatestValue.at(Register::PC);
                            ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (14 << DEPENDENCY_OFFSET) | (13 << ID_OFFSET) | (low_RegNr << REG1_OFFSET) | (high_RegNr << REG2_OFFSET);
                            for(const auto& Bit: Helper.FullVerticalRelevantBits){ 
                                Software::Probing::CreateDSPSmallFullVerticalProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.FullVerticalProbesIncluded.at(Bit), Bit, low_RegNr, high_RegNr, ProbeIndex, ProbeInfo, ProbeTracker.RegisterLatestValue, TransitionValueRdLo, TransitionValueRdHi, TransitionValuePC);
                            }
                        }
                }

                //set transition values and cycles of changed registers
                ProbeTracker.RegisterLatestClockCycle.at(low_RegNr) = InstrNr;
                ProbeTracker.RegisterLatestValue.at(low_RegNr) = low_DestinationRegisterValue;
                ProbeTracker.RegisterLatestClockCycle.at(high_RegNr) = InstrNr;
                ProbeTracker.RegisterLatestValue.at(high_RegNr) = high_DestinationRegisterValue;
                ProbeTracker.RegisterLatestClockCycle.at(Register::PC) = InstrNr;
                ProbeTracker.RegisterLatestValue.at(Register::PC) = PCRegisterValue;
                if(m_psr_updated){
                    ProbeTracker.RegisterLatestClockCycle.at(Register::PSR) = InstrNr;
                    ProbeTracker.RegisterLatestValue.at(Register::PSR) = PSR_value;
                }

        }

    }
        //PipelineForwarding probes are special in the sense that it does not depend if it was a dsp instruction or not
    if(InTestClockCycles && Helper.ProbePipelineForwarding){

        uint32_t ProbeIndex = ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size();
        uint32_t ProbeSize = 0;
        for(auto tmp: m_pipeline_cpu_states){
            if(tmp.containing_valid_pipeline_values == true){
                ProbeSize = Helper.PipelineForwardingProbesSize;
                break;
            }
        }
        ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).resize(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx).size() + ProbeSize);

        uint64_t ProbeInfo = (static_cast<uint64_t>(InstrNr) << 32) | (static_cast<uint64_t>(15) << DEPENDENCY_OFFSET)  | (static_cast<uint64_t>(15) << ID_OFFSET);
        for(const auto& Bit: Helper.PipelineForwardingRelevantBits){
            Software::Probing::CreatePipelineForwardingProbe(ThreadSimulation.StandardProbesPerSimulation.at(SimulationIdx), Helper.PipelineForwardingProbesIncluded.at(Bit), Bit, ProbeIndex, ProbeInfo, m_pipeline_stages, m_pipeline_cpu_states);
        }
    }



    m_cpu_state.time++;
    m_emulated_time++;

}

//todo
ReturnCode Emulator::emulate(u64 max_instructions, uint32_t randomness_start_addr,uint32_t randomness_end_addr)
{
    return emulate(1, max_instructions,  randomness_start_addr, randomness_end_addr);
}

ReturnCode Emulator::emulateInstantiation(u64 max_instructions, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, uint32_t randomness_start_addr, uint32_t randomness_end_addr, uint32_t SimulationIndex){
    if (m_ram.bytes == nullptr || m_flash.bytes == nullptr)
    {
        return ReturnCode::UNINITIALIZED;
    }

    m_return_code   = ReturnCode::OK;
    m_emulated_time = 0;

    branch_write_PC(m_cpu_state.registers[PC]);

    while (m_return_code == ReturnCode::OK)
    {
        if (m_emulated_time >= max_instructions)
        {
            m_return_code = ReturnCode::MAX_INSTRUCTIONS_REACHED;
            break;
        }
        if(m_cpu_state.registers[PC] == 1)
        {
            m_return_code = ReturnCode::END_ADDRESS_REACHED;
            break;
        }
        clock_cpu_instantiation(ProbeTracker, ThreadSimulation, Helper, ProbeValues, randomness_start_addr,  randomness_end_addr, SimulationIndex);

    }

    return m_return_code;
}


ReturnCode Emulator::emulate(u32 end_address, u64 max_instructions, uint32_t randomness_start_addr,uint32_t randomness_end_addr)
{
    if (m_ram.bytes == nullptr || m_flash.bytes == nullptr)
    {
        return ReturnCode::UNINITIALIZED;
    }

    m_return_code   = ReturnCode::OK;
    m_emulated_time = 0;

    branch_write_PC(m_cpu_state.registers[PC]);

    while (m_return_code == ReturnCode::OK)
    {
        if (m_emulated_time >= max_instructions)
        {
            m_return_code = ReturnCode::MAX_INSTRUCTIONS_REACHED;
            break;
        }
        if(m_cpu_state.registers[PC] == end_address)
        {
            m_return_code = ReturnCode::END_ADDRESS_REACHED;
            break;
        }
        clock_cpu( randomness_start_addr, randomness_end_addr);
    }

    return m_return_code;
}

u32 Emulator::get_time() const
{
    return m_cpu_state.time;
}

u32 Emulator::get_emulated_time() const
{
    return m_emulated_time;
}

u32 Emulator::get_PRNG_randomness()
{
    //m_prolead_rng.seed(time(NULL) + rand());
    return (u32)m_prolead_prng();
}

void Emulator::stop_emulation()
{
    m_return_code = ReturnCode::STOP_EMULATION_CALLED;
}

bool Emulator::is_running() const
{
    return m_return_code == ReturnCode::OK;
}

CPU_State Emulator::get_cpu_state() const
{
    return m_cpu_state;
}

void Emulator::set_cpu_state(const CPU_State& state)
{
    m_cpu_state = state;
}

///////////////////////////////////////////
/////////////  PRIVATE  ///////////////////
///////////////////////////////////////////

u8* Emulator::validate_address(u32 address)
{
    if (m_flash.access.execute && m_flash.contains(address, 2))
    {
        u32 size = m_decoder.get_instruction_size(m_flash.get(address));
        if (size == 2 || m_flash.contains(address, size))
        {
            return m_flash.get(address);
        }
        else
        {
            m_return_code = ReturnCode::INCOMPLETE_DATA;
            return nullptr;
        }
    }
    else if (m_ram.access.execute && m_ram.contains(address, 2))
    {
        u32 size = m_decoder.get_instruction_size(m_ram.get(address));
        if (size == 2 || m_ram.contains(address, size))
        {
            return m_ram.get(address);
        }
        else
        {
            m_return_code = ReturnCode::INCOMPLETE_DATA;
            return nullptr;
        }
    }

    m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
    return nullptr;
}

void Emulator::clock_cpu_instantiation(::Software::ProbeTrackingStruct& ProbeTracker, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, uint32_t randomness_start_addr, uint32_t randomness_end_addr, uint32_t SimulationIndex)
{
    u32 address = read_register_internal(Register::PC) - 4;
    auto memory = validate_address(address);

    if (m_return_code != ReturnCode::OK)
    {
        return;
    }


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (m_cpu_state.registers[PC] != address)    // hook changed PC
    {
        address = read_register_internal(Register::PC) - 4;
        memory  = validate_address(address);
        if (m_return_code != ReturnCode::OK)
        {
            return;
        }
    }

    //dummy read to execute hooks
    read_register_internal(Register::PSR);



    auto [status, instr] = m_decoder.decode_instruction(address, memory, m_decoder.get_instruction_size(memory), in_IT_block(), last_in_IT_block());


    Instruction tmp_instr = instr;


    if (status != ReturnCode::OK)
    {
        m_return_code = status;
        return;
    }


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    execute_instantiation(instr, ThreadSimulation, ProbeTracker, Helper, randomness_start_addr, randomness_end_addr);

    /**
     * @brief track which values were used up to the point the probing starts
     * 
     */
    switch(to_int(instr.Instruction::Rd)){
        case 0xFFFFFFFF: break;
        default: 
            uint8_t RegInt = to_int(instr.Instruction::Rd);
            uint32_t DestinationRegisterValue = read_register((mulator::Register)RegInt);

            for(const auto& BitIdx: Helper.NormalProbesIncluded.at(RegInt)){
                ProbeValues.at(RegInt).at(BitIdx).at(this->m_emulated_time) |= (((DestinationRegisterValue >> BitIdx) & 0x1) << (SimulationIndex & 0x7));
            }


            ProbeTracker.RegisterLatestValue.at(RegInt) = read_register(instr.Instruction::Rd); 
            ProbeTracker.VerticalLatestClockCycle.at(RegInt) = ProbeTracker.RegisterLatestClockCycle.at(RegInt);
            ProbeTracker.RegisterLatestClockCycle.at(RegInt) = this->m_emulated_time;
            break;
    }

    switch (to_int(instr.Instruction::RdHi))
    {
    case 0xFFFFFFFF: break;
    default:
        uint32_t high_RegisterNumber = 0;
        uint32_t low_RegisterNumber = 0;
        //registers have to be ordered according to register number
        if(to_int(instr.Instruction::RdHi) > to_int(instr.Instruction::RdLo)){ // RdHi has higher register number
            high_RegisterNumber = to_int(instr.Instruction::RdHi);
            low_RegisterNumber = to_int(instr.Instruction::RdLo);
        }
        else{
            high_RegisterNumber = to_int(instr.Instruction::RdLo);
            low_RegisterNumber = to_int(instr.Instruction::RdHi);
        }

        uint32_t high_DestinationRegisterValue = read_register((mulator::Register)high_RegisterNumber);
        uint32_t low_DestinationRegisterValue = read_register((mulator::Register)low_RegisterNumber);

        for(const auto& BitIdx: Helper.NormalProbesIncluded.at(low_RegisterNumber)){
            ProbeValues.at(low_RegisterNumber).at(BitIdx).at(this->m_emulated_time) |= (((low_DestinationRegisterValue >> BitIdx) & 0x1) << (SimulationIndex & 0x7));
        }


        ProbeTracker.VerticalLatestClockCycle.at(low_RegisterNumber) = ProbeTracker.RegisterLatestClockCycle.at(low_RegisterNumber);
        ProbeTracker.RegisterLatestValue.at(low_RegisterNumber) = low_DestinationRegisterValue;
        ProbeTracker.RegisterLatestClockCycle.at(low_RegisterNumber) = this->m_emulated_time;

        for(const auto& BitIdx: Helper.NormalProbesIncluded.at(high_RegisterNumber)){
            ProbeValues.at(high_RegisterNumber).at(BitIdx).at(this->m_emulated_time) |= (((high_DestinationRegisterValue >> BitIdx) & 0x1) << (SimulationIndex & 0x7));
        }


        ProbeTracker.VerticalLatestClockCycle.at(high_RegisterNumber) = ProbeTracker.RegisterLatestClockCycle.at(high_RegisterNumber);
        ProbeTracker.RegisterLatestValue.at(high_RegisterNumber) = high_DestinationRegisterValue;
        ProbeTracker.RegisterLatestClockCycle.at(high_RegisterNumber) = this->m_emulated_time;


        break;
    }

    if (m_psr_updated)
    {
        u32 value = 0;
        value |= ((u32)m_cpu_state.psr.N) << 31;
        value |= ((u32)m_cpu_state.psr.Z) << 30;
        value |= ((u32)m_cpu_state.psr.C) << 29;
        value |= ((u32)m_cpu_state.psr.V) << 28;
        value |= ((u32)m_cpu_state.psr.Q) << 27;

        value |= (m_cpu_state.psr.GE & 0xf) << 16;

        value |= (((u32)m_cpu_state.psr.it_state >> 6) << 25) | (_6BIT((u32)m_cpu_state.psr.it_state) << 10);

        write_register_internal(Register::PSR, value);


        for(const auto& BitIdx: Helper.NormalProbesIncluded.at(16)){
            ProbeValues.at(16).at(BitIdx).at(this->m_emulated_time) |= (((value >> BitIdx) & 0x1) << (SimulationIndex & 0x7));
        }


        ProbeTracker.RegisterLatestValue.at(16) = value;
        ProbeTracker.VerticalLatestClockCycle.at(16) = ProbeTracker.RegisterLatestClockCycle.at(16);
        ProbeTracker.RegisterLatestClockCycle.at(16) = this->m_emulated_time;
    }



    for(const auto& BitIdx: Helper.NormalProbesIncluded.at(15)){
        ProbeValues.at(15).at(BitIdx).at(this->m_emulated_time) |= (((read_register((mulator::Register)15) >> BitIdx) & 0x1) << (SimulationIndex & 0x7));
    }

    ProbeTracker.RegisterLatestValue.at(15) = read_register((mulator::Register)15);
    ProbeTracker.VerticalLatestClockCycle.at(15) = ProbeTracker.RegisterLatestClockCycle.at(15);
    ProbeTracker.RegisterLatestClockCycle.at(15) = this->m_emulated_time;

    //write cpu state after executing current instruction into pipeline forwarding vector -> stores up to #NrOfPipelineStages last states 
    //shift elements of vector one position to left
    std::rotate(m_pipeline_cpu_states.begin(), m_pipeline_cpu_states.begin() + 1, m_pipeline_cpu_states.end());

    //fill last element in vector with new cpu state
    m_pipeline_cpu_states.back() = m_cpu_state;
    m_pipeline_cpu_states.back().containing_valid_pipeline_values = true;

    m_cpu_state.time++;
    m_emulated_time++;
}

//todo
void Emulator::clock_cpu(uint32_t randomness_start_addr,uint32_t randomness_end_addr)
{
    u32 address = read_register_internal(Register::PC) - 4;
    auto memory = validate_address(address);

    if (m_return_code != ReturnCode::OK)
    {
        return;
    }


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (m_cpu_state.registers[PC] != address)    // hook changed PC
    {
        address = read_register_internal(Register::PC) - 4;
        memory  = validate_address(address);
        if (m_return_code != ReturnCode::OK)
        {
            return;
        }
    }

    //dummy read to execute hooks
    read_register_internal(Register::PSR);

    auto [status, instr] = m_decoder.decode_instruction(address, memory, m_decoder.get_instruction_size(memory), in_IT_block(), last_in_IT_block());

    #ifdef DEBUG
    std::cout << "current executed instruction : " << to_string(instr.name) << " with dest " << to_int(instr.Rd) << " and " << to_int(instr.Rm) << " " << to_int(instr.Rn) << " " << to_int(instr.Ra) << " at " << std::hex << address <<" time: " << m_emulated_time << std::endl; 
    std::cout << "contents before execution: " << std::endl;
    switch(to_int(instr.Ra)){
        case 0xFFFFFFFF: break;                                 //register was not accessed by this instruction
        default: std::cout << "R" << to_int(instr.Ra) << ": " << read_register(instr.Ra) << std::endl; break;
    }
    switch(to_int(instr.Rn)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rn) << ": " << read_register(instr.Rn) << std::endl; break;
    }
    switch(to_int(instr.Rd)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rd) << ": " << read_register(instr.Rd) << std::endl; break;
    }
    switch(to_int(instr.Rm)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rm) << ": " << read_register(instr.Rm) << std::endl; break;
    }

    if(instr.name == Mnemonic::POP){
        std::cout << "R2: " << read_register((Register)2);
    }
    #endif

    if (status != ReturnCode::OK)
    {
        m_return_code = status;
        return;
    }


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    execute(instr, randomness_start_addr, randomness_end_addr);


    #ifdef DEBUG
    std::cout << "contents after execution: " << std::endl;
    switch(to_int(instr.Ra)){
        case 0xFFFFFFFF: break;                                 //register was not accessed by this instruction
        default: std::cout << "R" << to_int(instr.Ra) << ": " << read_register(instr.Ra) << std::endl; break;
    }
    switch(to_int(instr.Rn)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rn) << ": " << read_register(instr.Rn) << std::endl; break;
    }
    switch(to_int(instr.Rd)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rd) << ": " << read_register(instr.Rd) << std::endl; break;
    }
    switch(to_int(instr.Rm)){
        case 0xFFFFFFFF: break;
        default: std::cout << "R" << to_int(instr.Rm) << ": " << read_register(instr.Rm) << std::endl; break;
    }

    if(instr.name == Mnemonic::POP){
        std::cout << "R2: " << read_register((Register)2);
    }
    #endif


    if (m_psr_updated)
    {
        u32 value = 0;
        value |= ((u32)m_cpu_state.psr.N) << 31;
        value |= ((u32)m_cpu_state.psr.Z) << 30;
        value |= ((u32)m_cpu_state.psr.C) << 29;
        value |= ((u32)m_cpu_state.psr.V) << 28;
        value |= ((u32)m_cpu_state.psr.Q) << 27;
        value |= (m_cpu_state.psr.GE & 0xf) << 16;

        value |= (((u32)m_cpu_state.psr.it_state >> 6) << 25) | (_6BIT((u32)m_cpu_state.psr.it_state) << 10);

        write_register_internal(Register::PSR, value);
    }

    m_cpu_state.time++;
    m_emulated_time++;
}

u32 Emulator::read_register_internal(Register reg)
{
    if ((u32)reg >= REGISTER_COUNT)
    {
        m_return_code = ReturnCode::INVALID_REGISTER;
        return 0;
    }

    if (m_return_code != ReturnCode::OK)
    {
        return 0;
    }

    u32 value;

    if (reg == PC)
    {
        value = m_cpu_state.registers[Register::PC] + 4;
    }
    else
    {
        value = m_cpu_state.registers[reg];
    }


    return value;
}

void Emulator::write_register_internal(Register reg, u32 value)
{
    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if ((u32)reg >= REGISTER_COUNT)
    {
        m_return_code = ReturnCode::INVALID_REGISTER;
        return;
    }

    if (reg == SP)
    {
        value = arm_functions::align(value, 4);
    }
    else if (reg == PSR)
    {
        if (get_architecture() > Architecture::ARMv6M)
        {
            value &= 0xFE0FFC00; //include GE bits
        }
        else
        {
            value &= 0xF0000000;
        }
    }


    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (reg == PSR)
    {
        m_cpu_state.psr.N = _1BIT(value >> 31);
        m_cpu_state.psr.Z = _1BIT(value >> 30);
        m_cpu_state.psr.C = _1BIT(value >> 29);
        m_cpu_state.psr.V = _1BIT(value >> 28);
        m_cpu_state.psr.Q = _1BIT(value >> 27);

        m_cpu_state.psr.it_state = (_2BIT(value >> 25) << 6) | _6BIT(value >> 10);
    }

    m_cpu_state.registers[reg] = value;

}

u32 Emulator::read_memory_internal(u32 address, u8 bytes)
{
    if (m_return_code != ReturnCode::OK)
    {
        return 0;
    }

    if (bytes != 4 && bytes != 2 && bytes != 1)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return 0;
    }

    MemoryRegion* mem = nullptr;

    if (m_ram.contains(address, bytes))
    {
        mem = &m_ram;
    }
    else if (m_flash.contains(address, bytes))
    {
        mem = &m_flash;
    }

    if (mem == nullptr || !mem->access.read)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return 0;
    }

    u8* memory = mem->get(address);
    u32 value;


    if (m_return_code != ReturnCode::OK)
    {
        return 0;
    }

    // read again since hook might have changed data
    if (bytes == 1)
    {
        value = *(memory);
    }
    else if (bytes == 2)
    {
        value = *((u16*)memory);
    }
    else
    {
        value = *((u32*)memory);
    }

    return value;
}

void Emulator::write_memory_internal(u32 address, u32 value, u8 bytes)
{
    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (bytes != 4 && bytes != 2 && bytes != 1)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return;
    }

    MemoryRegion* mem = nullptr;

    if (m_ram.contains(address, bytes))
    {
        mem = &m_ram;
    }
    else if (m_flash.contains(address, bytes))
    {
        mem = &m_flash;
    }

    if (mem == nullptr || !mem->access.write)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return;
    }

    u8* memory = mem->get(address);

    if (bytes == 1)
    {
        value = (u8)value;
    }
    else if (bytes == 2)
    {
        value = (u16)value;
    }

    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (bytes == 1)
    {
        *(memory) = (u8)value;
    }
    else if (bytes == 2)
    {
        *((u16*)memory) = (u16)value;
    }
    else
    {
        *((u32*)memory) = value;
    }

}


void Emulator::make_memory_visible_for_probing(u32 address, u8 bytes){
    if (m_return_code != ReturnCode::OK)
    {
        return;
    }

    if (bytes != 4 && bytes != 2 && bytes != 1)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return;
    }

    MemoryRegion* mem = nullptr;

    if (m_ram.contains(address, bytes))
    {
        mem = &m_ram;
    }
    else if (m_flash.contains(address, bytes))
    {
        mem = &m_flash;
    }

    if (mem == nullptr || !mem->access.write)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return;
    }

    bool* memory_to_probe = mem->get_probing_scope(address);

    if (m_return_code != ReturnCode::OK)
    {
        return;
    }


    std::memset(memory_to_probe, true, bytes);

}

u32 Emulator::mask_probing_memory(u32 address, u8 bytes, u32 memory_simulation_value){
    if (m_return_code != ReturnCode::OK)
    {
        return 0;
    }

    if (bytes != 4 && bytes != 2 && bytes != 1)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return 0;
    }

    MemoryRegion* mem = nullptr;

    if (m_ram.contains(address, bytes))
    {
        mem = &m_ram;
    }
    else if (m_flash.contains(address, bytes))
    {
        mem = &m_flash;
    }

    if (mem == nullptr || !mem->access.write)
    {
        m_return_code = ReturnCode::INVALID_MEMORY_ACCESS;
        return 0;
    }

    bool* memory_to_probe = mem->get_probing_scope(address);

    uint32_t lsb_byte_mask = 0xff * static_cast<uint32_t>(*memory_to_probe);
    uint32_t second_lsb_byte_mask = 0xff00 * static_cast<uint32_t>(*(memory_to_probe + 1));
    uint32_t second_msb_byte_mask = 0xff0000 * static_cast<uint32_t>(*(memory_to_probe + 2));
    uint32_t msb_byte_mask = 0xff000000 * static_cast<uint32_t>(*(memory_to_probe + 3));
    uint32_t memory_probing_mask = lsb_byte_mask | second_lsb_byte_mask | second_msb_byte_mask | msb_byte_mask;

    return memory_simulation_value & memory_probing_mask;
}