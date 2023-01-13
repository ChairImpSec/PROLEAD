#pragma once

#include "Software/mulator/types.h"
#include "Software/mulator/mnemonics.h"
#include "Software/mulator/conditions.h"
#include "Software/mulator/registers.h"
#include "Software/mulator/architectures.h"
#include "Software/mulator/shift_types.h"

namespace mulator
{

    struct Instruction
    {
        Instruction();
        ~Instruction() = default;

        u32 address;
        u8 size;
        u32 encoding;

        Mnemonic name;

        Condition condition;

        ShiftType shift_type;
        u32 shift_amount;

        struct
        {
            bool S;
            bool wback;
            bool index;
            bool add;
            bool unaligned_allowed;
        } flags;

        enum class OperandType
        {
            NONE,
            I,    // immediate
            R,    // register
            RI,   // register, immediate
            RR,   // register, register
            RRI,  // register, register, immediate
            RRR,  // register, register, register
            RRII, // register, register, immediate, immediate
            RRRI, // register, register, register,  immediate
            RRRR  // register, register, register,  register
        } operand_type;

        Register Rd;
        Register Rn;
        Register Rm;
        Register Ra;
        u32 imm;
        u32 imm2;

        //armv7e-m specific
        Register RdLo;
        Register RdHi;

        bool uses_immediate() const;
        bool uses_only_registers() const;
        u32 get_register_count() const;
        u32 get_immediate_count() const;
    };
}
