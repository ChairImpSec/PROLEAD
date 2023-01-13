#include "Software/mulator/instruction.h"

using namespace mulator;

Instruction::Instruction()
{
    name = Mnemonic::UDF;
    address = 0xFFFFFFFF;
    condition = Condition::AL;
    shift_type = ShiftType::LSL;
    shift_amount = 0;

    flags.S = false;
    flags.wback = false;
    flags.index = false;
    flags.add = false;
    flags.unaligned_allowed = false;

    operand_type = OperandType::NONE;
    Rd = Rn = Rm = Ra = RdHi = RdLo = (Register)0xFFFFFFFF;
    imm = imm2 = 0xFFFFFFFF;
}

bool Instruction::uses_immediate() const
{
    return operand_type == OperandType::I || operand_type == OperandType::RI || operand_type == OperandType::RRI || operand_type == OperandType::RRII || operand_type == OperandType::RRRI;
}

bool Instruction::uses_only_registers() const
{
    return operand_type == OperandType::R || operand_type == OperandType::RR || operand_type == OperandType::RRR || operand_type == OperandType::RRRR;
}


u32 Instruction::get_register_count() const
{
    switch (operand_type)
    {
        case OperandType::R:
        case OperandType::RI: return 1;

        case OperandType::RR:
        case OperandType::RRI:
        case OperandType::RRII: return 2;

        case OperandType::RRR:
        case OperandType::RRRI: return 3;

        case OperandType::RRRR: return 4;

        default: return 0;
    }
}

u32 Instruction::get_immediate_count() const
{
    switch (operand_type)
    {
        case OperandType::I:
        case OperandType::RI:
        case OperandType::RRI:
        case OperandType::RRRI: return 1;

        case OperandType::RRII: return 2;

        default: return 0;
    }
}
