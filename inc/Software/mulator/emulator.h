#pragma once
#ifndef EMULATOR_HPP
#define EMULATOR_HPP
#include "Software/mulator/architectures.h"
#include "Software/mulator/callback_hook.h"
#include "Software/mulator/instruction_decoder.h"
#include "Software/mulator/memory_region.h"
#include "Software/mulator/registers.h"
#include "Software/mulator/types.h"

#include "Software/Definitions.hpp"


#include <functional>
#include <map>
#include <tuple>
#include <vector>
#include <algorithm>

//use for PRNG
#include "boost/random/variate_generator.hpp"
#include "boost/random/mersenne_twister.hpp"
#include "boost/random/uniform_int.hpp"

// #define DEBUG

namespace mulator
{
    struct CPU_State
    {
        u32 registers[REGISTER_COUNT];

        struct
        {
            bool N;
            bool Z;
            bool C;
            bool V;
            bool Q;
            u8 GE;
            u8 it_state;
        } psr;

        u32 exclusive_address;

        u32 CCR;
        u8 PRIMASK;
        u8 FAULTMASK;
        u8 BASEPRI;
        u8 CONTROL;

        u32 time;

        bool containing_valid_pipeline_values;
    };

    class Emulator
    {
    public:
        Emulator(); //todo self written constructor
        Emulator(Architecture arch);
        Emulator(Architecture arch, boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> ThreadPrng, uint32_t NrOfPipelineStages); //self written constructor
        Emulator(const Emulator& other);
        ~Emulator();

        /*
         * Getters for internals.
         */
        InstructionDecoder get_decoder() const;
        Architecture get_architecture() const;

        /*
         * Sets the flash region.
         *
         * @param[in] offset - the starting address
         * @param[in] size - the memory region size
         */
        void set_flash_region(u32 offset, u32 size);

        /*
         * Getters for the flash region.
         */
        u32 get_flash_offset() const;
        u32 get_flash_size() const;
        u8* get_flash() const;

        /*
         * Sets the ram region.
         *
         * @param[in] offset - the starting address
         * @param[in] size - the memory region size
         */
        void set_ram_region(u32 offset, u32 size);

        /*
         * Getters for the ram region.
         */
        u32 get_ram_offset() const;
        u32 get_ram_size() const;
        u8* get_ram() const;

        /*
         * Read and write access to registers.
         * Does not fire any hooks!
         */
        u32 read_register(Register reg) const;
        void write_register(Register reg, u32 value);

        /*
         * Read and write access to memory.
         * Does not fire any hooks!
         */
        void read_memory(u32 address, u8* buffer, u32 len) const;
        void write_memory(u32 dst_address, const u8* buffer, u32 len);

        /*
         * Starts/continues emulation of the code from the current state.
         * Stops automatically after a maximum number of instructions or when the end address is hit.
         */
        ReturnCode emulate(u64 max_instructions, uint32_t randomness_start_addr,uint32_t randomness_end_addr);
        ReturnCode emulate(u32 end_address, u64 max_instructions, uint32_t randomness_start_addr,uint32_t randomness_end_addr);
        ReturnCode emulateInstantiation(u64 max_isntructions, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, uint32_t randomness_start_addr, uint32_t randomness_end_addr, uint32_t SimulationIndex);

        /*
        *   Starts emulation for PROLEAD
        */
        void emulate_PROLEAD(::Software::ThreadSimulationStruct& , ::Software::ProbeTrackingStruct&, ::Software::HelperStruct&, std::vector<std::vector<std::vector<uint8_t>>>&, const int , const uint64_t , const uint32_t , const uint32_t);    
        
        /*
        * Stop the ongoing emulation. Useful in hooks.
        */
        void stop_emulation();

        /*
         * Check whether the emulator is still emulating. Useful in hooks.
         */
        bool is_running() const;

        /*
         * Gets the total number of executed instructions in this emulator.
         */
        u32 get_time() const;

        /*
         * Gets a 32 bit random value.
         */
        u32 get_PRNG_randomness();

        /*
         * Gets the number of executed instructions in the last 'emulate' call.
         */
        u32 get_emulated_time() const;

        /*
         * Returns true if emulation is currently in an IT block.
         */
        bool in_IT_block() const;

        /*
         * Returns true if emulation is currently at the last instruction in an IT block.
         */
        bool last_in_IT_block() const;

        /*
         * Returns the current CPU state.
         * By backing up the CPU state and RAM contents the state of the emulator can be backed up completely.
         */
        CPU_State get_cpu_state() const;

        /*
         * Set the emulator to a specific CPU state.
         */
        void set_cpu_state(const CPU_State& state);

        uint32_t m_pipeline_stages;
        std::vector<CPU_State> m_pipeline_cpu_states;

    private:
        InstructionDecoder m_decoder;

        ReturnCode m_return_code;

        MemoryRegion m_flash;
        MemoryRegion m_ram;

        CPU_State m_cpu_state;
        u32 m_memory_shadow_register;
        u32 m_emulated_time;
        bool m_psr_updated;

        boost::variate_generator<boost::mt19937&, boost::uniform_int<uint64_t>> m_prolead_prng;

        u8* validate_address(u32 address);
        void clock_cpu(uint32_t randomness_start_addr,uint32_t randomness_end_addr);

        void clock_cpu_instantiation(::Software::ProbeTrackingStruct& ProbeTracker, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::HelperStruct& Helper, std::vector<std::vector<std::vector<uint8_t>>>& ProbeValues, uint32_t randomness_start_addr, uint32_t randomness_end_addr, uint32_t SimulationIndex);

        void clock_cpu_PROLEAD();

        u32 read_memory_internal(u32 address, u8 bytes);
        void write_memory_internal(u32 address, u32 value, u8 bytes);

        u32 read_register_internal(Register reg);
        void write_register_internal(Register reg, u32 value);

        Condition pop_IT_condition();
        
        bool execute_PROLEAD(const Instruction& instr, ::Software::ThreadSimulationStruct& , ::Software::ProbeTrackingStruct& , ::Software::HelperStruct&, bool, bool&, const int, const uint64_t, const uint32_t, const uint32_t);
        void check_shadow_register_constraints(uint32_t& next_shadow_register_value, Software::ThreadSimulationStruct& ThreadSimulation, uint32_t address, uint8_t byte);      

        bool execute(const Instruction& instr, uint32_t randomness_start_addr, uint32_t randomness_end_addr);

        bool execute_instantiation(const Instruction& instr, ::Software::ThreadSimulationStruct& ThreadSimulation, ::Software::ProbeTrackingStruct& ProbeTracker, ::Software::HelperStruct& Helper, uint32_t randomness_start_addr, uint32_t randomness_end_addr);

        bool evaluate_condition(const Instruction& instr);

        void branch_write_PC(u32 address);
        void bx_write_PC(u32 address);
        void blx_write_PC(u32 address);

        void set_exclusive_monitors(u32 address, u32 align);
        bool exclusive_monitors_pass(u32 address, u32 align) const;

        bool in_priviledged_mode() const;
        i32 get_execution_priority() const;
    };

}    // namespace mulator

#include "Software/Probing.hpp"

#endif