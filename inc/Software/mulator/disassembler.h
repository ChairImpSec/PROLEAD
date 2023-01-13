#pragma once

#include "Software/mulator/instruction_decoder.h"

#include <string>

namespace mulator
{
    class Disassembler
    {
    public:
        Disassembler(Architecture arch);
        ~Disassembler();

        /*
         * Getters for internals.
         */
        InstructionDecoder get_decoder() const;
        Architecture get_architecture() const;

        /*
         * Resets the disassembler by clearing the IT state.
         */
        void reset();

        /*
         * Decode and disassemble a single instruction from a byte array.
         *
         * @param[in] address - current address
         * @param[in] code - pointer to the first byte of the instruction
         * @param[in] code_size - length of the remaining bytes in byte array
         */
        ReturnCode disassemble(u32 address, const u8* code, u32 code_size);

        /*
         * Disassemble a single already decoded instruction.
         *
         * @param[in] instr - the instruction to disassemble
         */
        ReturnCode disassemble(Instruction instr);

        /*
         * Getters for disassembled data.
         */
        Instruction get_instruction() const;
        std::string get_mnemonic() const;
        std::string get_operands() const;
        std::string get_string() const;

    private:
        InstructionDecoder m_decoder;
        u32 m_it_state;

        std::string format_name(const Instruction& instr) const;
        std::string format_shift(const Instruction& instr) const;
        std::string format_immediate(u32 value, bool add_flag = true, bool decimal = false, bool print_signed = false) const;

        bool is_load_operation(const Mnemonic& mnemonic) const;
        bool is_store_operation(const Mnemonic& mnemonic) const;
        bool is_shift_operation(const Mnemonic& mnemonic) const;

        Instruction m_instruction;
        std::string m_mnemonic;
        std::string m_operands;

        bool in_IT_block() const;
        bool last_in_IT_block() const;
        Condition pop_IT_condition();
    };

} // namespace mulator
