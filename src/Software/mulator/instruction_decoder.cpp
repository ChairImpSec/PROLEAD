#include "Software/mulator/instruction_decoder.h"
#include "Software/mulator/arm_functions.h"

using namespace mulator;

using OperandType = Instruction::OperandType;

#define REQUIRE_ARCH(arch) \
    if (m_arch < arch)     \
        return {ReturnCode::UNSUPPORTED, instr};

#define is15(X) (instr.X == Register::PC)
#define is13(X) (instr.X == Register::SP)
#define is13or15(X) (is13(X) || is15(X))

#define THROW_UNDEFINED return {ReturnCode::UNDEFINED, instr};
#define THROW_UNPREDICTABLE return {ReturnCode::UNPREDICTABLE, instr};
#define THROW_UNEXPECTED return {ReturnCode::UNEXPECTED_ENCODING, instr};
#define THROW_NOT_IMPLEMENTED return {ReturnCode::NOT_IMPLEMENTED, instr};
#define THROW_UNKNOWN return {ReturnCode::UNKNOWN_INSTRUCTION, instr};
#define CHECK_IMM(X)                                   \
    if (!X)                                            \
    {                                                  \
        return {ReturnCode::INVALID_IMMEDIATE, instr}; \
    }

InstructionDecoder::InstructionDecoder(Architecture arch)
{
    m_arch = arch;
}

Architecture InstructionDecoder::get_architecture() const
{
    return m_arch;
}

u8 InstructionDecoder::get_instruction_size(const u8* bytes)
{
    u16* instruction_stream = (u16*)bytes;
    u16 encoding            = instruction_stream[0];
    u8 mask                 = _5BIT(encoding >> 11);
    if (mask == 0b11101 || mask == 0b11110 || mask == 0b11111)
    {
        return 4;
    }
    return 2;
}

std::pair<ReturnCode, Instruction> InstructionDecoder::decode_instruction(u32 address, const u8* bytes, u32 code_size, bool in_IT_block, bool last_in_IT_block)
{
    Instruction instr;
    instr.address = address;

    u16* instruction_stream = (u16*)bytes;

    instr.size = get_instruction_size(bytes);
    if (instr.size == 2 && code_size < 2)
    {
        return {ReturnCode::INCOMPLETE_DATA, instr};
    }
    else if (instr.size == 4 && code_size < 4)
    {
        return {ReturnCode::INCOMPLETE_DATA, instr};
    }

    if (instr.size == 2)
    {
        u16 encoding   = instruction_stream[0];
        instr.encoding = encoding;

        // 16-bit thumb code
        u8 opcode   = encoding >> 10;
        u8 opcode_5 = opcode >> 1;
        u8 opcode_4 = opcode >> 2;
        u8 opcode_3 = opcode >> 3;
        u8 opcode_2 = opcode >> 4;

        if ((encoding >> 6) == 0)
        {
            // MOVS on page A6-140
            instr.name         = Mnemonic::MOV;
            instr.flags.S      = true;
            instr.Rd           = (Register)(_3BIT(encoding));
            instr.Rm           = (Register)(_3BIT(encoding >> 3));
            instr.operand_type = OperandType::RR;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_2 == 0b00)
        {
            // Shift (immediate), add, subtract, move, and compare on page A5-79
            opcode   = _5BIT(encoding >> 9);
            opcode_3 = opcode >> 2;

            if (opcode_3 == 0b000)
            {
                // LSL (immediate) on page A6-135
                instr.name    = Mnemonic::LSL;
                instr.flags.S = !in_IT_block;
                instr.Rd      = (Register)(_3BIT(encoding));
                instr.Rm      = (Register)(_3BIT(encoding >> 3));
                u32 imm5      = _5BIT(encoding >> 6);

                auto [shift_type, shift_amount] = arm_functions::decode_imm_shift(0b00, imm5);
                instr.shift_type                = shift_type;
                instr.shift_amount              = shift_amount;

                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b001)
            {
                // LSR (immediate) on page A6-137
                instr.name    = Mnemonic::LSR;
                instr.flags.S = !in_IT_block;
                instr.Rd      = (Register)(_3BIT(encoding));
                instr.Rm      = (Register)(_3BIT(encoding >> 3));
                u32 imm5      = _5BIT(encoding >> 6);

                auto [shift_type, shift_amount] = arm_functions::decode_imm_shift(0b01, imm5);
                instr.shift_type                = shift_type;
                instr.shift_amount              = shift_amount;

                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b010)
            {
                // ASR (immediate) on page A6-108
                instr.name    = Mnemonic::ASR;
                instr.flags.S = !in_IT_block;
                instr.Rd      = (Register)(_3BIT(encoding));
                instr.Rm      = (Register)(_3BIT(encoding >> 3));
                u32 imm5      = _5BIT(encoding >> 6);

                auto [shift_type, shift_amount] = arm_functions::decode_imm_shift(0b10, imm5);
                instr.shift_type                = shift_type;
                instr.shift_amount              = shift_amount;

                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b01100)
            {
                // ADD (register) on page A6-102
                instr.name         = Mnemonic::ADD;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b01101)
            {
                // SUB (register) on page A6-165
                instr.name         = Mnemonic::SUB;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b01110)
            {
                // Add 3-bit immediate ADD (immediate) on page A6-101
                instr.name         = Mnemonic::ADD;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _3BIT(encoding >> 6);
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b01111)
            {
                // Subtract 3-bit immediate SUB (immediate) on page A6-164
                instr.name         = Mnemonic::SUB;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _3BIT(encoding >> 6);
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b100)
            {
                // MOV (immediate) on page A6-139
                instr.name         = Mnemonic::MOV;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding >> 8));
                instr.imm          = _8BIT(encoding);
                instr.operand_type = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b101)
            {
                // CMP (immediate) on page A6-117
                instr.name         = Mnemonic::CMP;
                instr.Rn           = (Register)(_3BIT(encoding >> 8));
                instr.imm          = _8BIT(encoding);
                instr.operand_type = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b110)
            {
                // Add 8-bit immediate ADD (immediate) on page A6-101
                instr.name    = Mnemonic::ADD;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding >> 8));
                instr.imm           = _8BIT(encoding);
                instr.operand_type  = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b111)
            {
                // Subtract 8-bit immediate SUB (immediate) on page A6-164
                instr.name    = Mnemonic::SUB;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding >> 8));
                instr.imm           = _8BIT(encoding);
                instr.operand_type  = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
        }
        else if (opcode == 0b010000)
        {
            // Data processing on page A5-80
            opcode = _4BIT(encoding >> 6);

            if (opcode == 0b0000)
            {
                // Bitwise AND AND (register) on page A6-107
                instr.name    = Mnemonic::AND;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0001)
            {
                // Exclusive OR EOR (register) on page A6-123
                instr.name    = Mnemonic::EOR;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0010)
            {
                // Logical Shift Left LSL (register) on page A6-136
                instr.name       = Mnemonic::LSL;
                instr.flags.S    = !in_IT_block;
                instr.shift_type = ShiftType::LSL;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));

                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0011)
            {
                // Logical Shift Right LSR (register) on page A6-138
                instr.name       = Mnemonic::LSR;
                instr.flags.S    = !in_IT_block;
                instr.shift_type = ShiftType::LSR;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));

                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0100)
            {
                // Arithmetic Shift Right ASR (register) on page A6-109
                instr.name       = Mnemonic::ASR;
                instr.flags.S    = !in_IT_block;
                instr.shift_type = ShiftType::ASR;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));

                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101)
            {
                // Add with Carry ADC (register) on page A6-100
                instr.name    = Mnemonic::ADC;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0110)
            {
                // Subtract with Carry SBC (register) on page A6-155
                instr.name    = Mnemonic::SBC;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0111)
            {
                // Rotate Right ROR (register) on page A6-153
                instr.name       = Mnemonic::ROR;
                instr.flags.S    = !in_IT_block;
                instr.shift_type = ShiftType::ROR;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1000)
            {
                // Set flags on bitwise AND TST (register) on page A6-170
                instr.name         = Mnemonic::TST;
                instr.Rn           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1001)
            {
                // Reverse Subtract from 0 RSB (immediate) on page A6-154
                instr.name         = Mnemonic::RSB;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = 0;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1010)
            {
                // Compare Registers CMP (register) on page A6-118
                instr.name         = Mnemonic::CMP;
                instr.Rn           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1011)
            {
                // Compare Negative CMN (register) on page A6-116
                instr.name         = Mnemonic::CMN;
                instr.Rn           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1100)
            {
                // Logical OR ORR (register) on page A6-147
                instr.name    = Mnemonic::ORR;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1101)
            {
                // Multiply Two Registers MUL on page A6-143
                instr.name    = Mnemonic::MUL;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rm = (Register)(_3BIT(encoding));
                instr.Rn            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1110)
            {
                // Bit Clear BIC (register) on page A6-111
                instr.name    = Mnemonic::BIC;
                instr.flags.S = !in_IT_block;
                instr.Rd = instr.Rn = (Register)(_3BIT(encoding));
                instr.Rm            = (Register)(_3BIT(encoding >> 3));
                instr.operand_type  = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1111)
            {
                // Bitwise NOT MVN (register) on page A6-144
                instr.name         = Mnemonic::MVN;
                instr.flags.S      = !in_IT_block;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
        }
        else if (opcode == 0b010001)
        {
            // Special data instructions and branch and exchange on page A5-81
            opcode   = _4BIT(encoding >> 6);
            opcode_3 = opcode >> 1;
            opcode_2 = opcode >> 2;

            if (opcode_2 == 0b00)
            {
                // Add Registers ADD (register) on page A6-102
                instr.name    = Mnemonic::ADD;
                instr.flags.S = false;
                instr.Rd = instr.Rn = (Register)((_1BIT(encoding >> 7) << 3) | _3BIT(encoding));
                instr.Rm            = (Register)(_4BIT(encoding >> 3));
                if (instr.Rd == 0b1101 || instr.Rm == 0b1101)
                {
                    // SEE ADD (SP plus register);
                    if (instr.Rm == 0b1101)
                    {
                        instr.Rm = instr.Rd;
                        instr.Rn = Register::SP;

                        if (instr.Rd == 15 && in_IT_block && !last_in_IT_block)
                        {
                            THROW_UNPREDICTABLE;
                        }

                        instr.operand_type = OperandType::RRR;
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        instr.Rd = instr.Rn = Register::SP;
                        instr.operand_type  = OperandType::RRR;
                        return {ReturnCode::OK, instr};
                    }
                }
                if (instr.Rd == 15 && instr.Rm == 15)
                {
                    THROW_UNPREDICTABLE;
                }
                if (instr.Rd == 15 && in_IT_block && !last_in_IT_block)
                {
                    THROW_UNPREDICTABLE;
                }
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0100)
            {
                THROW_UNPREDICTABLE;
            }
            else if (opcode == 0b0101 || opcode_3 == 0b011)
            {
                // Compare Registers CMP (register) on page A6-118
                instr.name = Mnemonic::CMP;
                instr.Rn   = (Register)((_1BIT(encoding >> 7) << 3) | _3BIT(encoding));
                instr.Rm   = (Register)(_4BIT(encoding >> 3));
                if ((instr.Rn < 8 && instr.Rm < 8) || is15(Rn) || is15(Rm))
                {
                    THROW_UNPREDICTABLE;
                }
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_2 == 0b10)
            {
                // Move Registers MOV (register) on page A6-140
                instr.name         = Mnemonic::MOV;
                instr.Rd           = (Register)((_1BIT(encoding >> 7) << 3) | _3BIT(encoding));
                instr.Rm           = (Register)(_4BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b110)
            {
                // Branch and Exchange BX on page A6-115
                instr.name = Mnemonic::BX;
                instr.Rm   = (Register)(_4BIT(encoding >> 3));

                if (_3BIT(encoding) != 0)
                {
                    THROW_UNEXPECTED;
                }
                if ((in_IT_block && !last_in_IT_block) || is15(Rm))
                {
                    THROW_UNPREDICTABLE;
                }

                instr.operand_type = OperandType::R;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b111)
            {
                // Branch with Link and Exchange BLX (register) on page A6-114
                instr.name = Mnemonic::BLX;
                instr.Rm   = (Register)(_4BIT(encoding >> 3));

                if (_3BIT(encoding) != 0)
                {
                    THROW_UNEXPECTED;
                }
                if ((in_IT_block && !last_in_IT_block) || is15(Rm))
                {
                    THROW_UNPREDICTABLE;
                }

                instr.operand_type = OperandType::R;
                return {ReturnCode::OK, instr};
            }
        }
        else if (opcode_5 == 0b01001)
        {
            // Load from Literal Pool, see LDR (literal) on page A6-127
            instr.name         = Mnemonic::LDR;
            instr.Rd           = (Register)(_3BIT(encoding >> 8));
            instr.imm          = _8BIT(encoding) << 2;
            instr.flags.add    = true;
            instr.operand_type = OperandType::RI;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_4 == 0b0101 || opcode_3 == 0b011 || opcode_3 == 0b100)
        {
            // Load/store single data item on page A5-82

            opcode   = encoding >> 9;
            opcode_5 = opcode >> 2;

            if (opcode == 0b0101000)
            {
                // Store Register STR (register) on page A6-159
                instr.name         = Mnemonic::STR;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101001)
            {
                // Store Register Halfword STRH (register) on page A6-163
                instr.name         = Mnemonic::STRH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101010)
            {
                // Store Register Byte STRB (register) on page A6-161
                instr.name         = Mnemonic::STRB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101011)
            {
                // Load Register Signed Byte LDRSB (register) on page A6-133
                instr.name         = Mnemonic::LDRSB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101100)
            {
                // Load Register LDR (register) on page A6-128
                instr.name         = Mnemonic::LDR;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101101)
            {
                // Load Register Halfword LDRH (register) on page A6-132
                instr.name         = Mnemonic::LDRH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101110)
            {
                // Load Register Byte LDRB (register) on page A6-130
                instr.name         = Mnemonic::LDRB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0101111)
            {
                // Load Register Signed Halfword LDRSH (register) on page A6-134
                instr.name         = Mnemonic::LDRSH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.Rm           = (Register)(_3BIT(encoding >> 6));
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b01100)
            {
                // Store Register STR (immediate) on page A6-158
                instr.name         = Mnemonic::STR;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6) << 2;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b01101)
            {
                // Load Register LDR (immediate) on page A6-126
                instr.name         = Mnemonic::LDR;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6) << 2;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b01110)
            {
                // Store Register Byte STRB (immediate) on page A6-160
                instr.name         = Mnemonic::STRB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6);
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b01111)
            {
                // Load Register Byte LDRB (immediate) on page A6-129
                instr.name         = Mnemonic::LDRB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6);
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b10000)
            {
                // Store Register Halfword STRH (immediate) on page A6-162
                instr.name         = Mnemonic::STRH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6) << 1;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b10001)
            {
                // Load Register Halfword LDRH (immediate) on page A6-131
                instr.name         = Mnemonic::LDRH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rn           = (Register)(_3BIT(encoding >> 3));
                instr.imm          = _5BIT(encoding >> 6) << 1;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b10010)
            {
                // Store Register SP relative STR (immediate) on page A6-158
                instr.name         = Mnemonic::STR;
                instr.Rd           = (Register)(_3BIT(encoding >> 8));
                instr.Rn           = Register::SP;
                instr.imm          = _8BIT(encoding) << 2;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b10011)
            {
                // Load Register SP relative LDR (immediate) on page A6-126
                instr.name         = Mnemonic::LDR;
                instr.Rd           = (Register)(_3BIT(encoding >> 8));
                instr.Rn           = Register::SP;
                instr.imm          = _8BIT(encoding) << 2;
                instr.flags.index  = true;
                instr.flags.add    = true;
                instr.flags.wback  = false;
                instr.operand_type = OperandType::RRI;
                return {ReturnCode::OK, instr};
            }
        }
        else if (opcode_5 == 0b10100)
        {
            // Generate PC-relative address, see ADR on page A6-106
            instr.name         = Mnemonic::ADR;
            instr.Rd           = (Register)(_3BIT(encoding >> 8));
            instr.imm          = _8BIT(encoding) << 2;
            instr.flags.add    = true;
            instr.operand_type = OperandType::RI;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_5 == 0b10101)
        {
            // Generate SP-relative address, see ADD (SP plus immediate) on page A6-104
            instr.name         = Mnemonic::ADD;
            instr.flags.S      = false;
            instr.Rd           = (Register)(_3BIT(encoding >> 8));
            instr.Rn           = Register::SP;
            instr.imm          = _8BIT(encoding) << 2;
            instr.operand_type = OperandType::RRI;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_4 == 0b1011)
        {
            // Miscellaneous 16-bit instructions on page A5-83

            opcode      = _7BIT(encoding >> 5);
            u8 opcode_6 = opcode >> 1;
            opcode_5    = opcode >> 2;
            opcode_4    = opcode >> 3;
            opcode_3    = opcode >> 4;

            if (opcode_5 == 0b00000)
            {
                // Add Immediate to SP ADD (SP plus immediate) on page A6-104
                instr.name         = Mnemonic::ADD;
                instr.flags.S      = false;
                instr.Rd           = Register::SP;
                instr.Rn           = Register::SP;
                instr.imm          = _7BIT(encoding) << 2;
                instr.operand_type = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_5 == 0b00001)
            {
                // Subtract Immediate from SP SUB (SP minus immediate) on page A6-166
                instr.name         = Mnemonic::SUB;
                instr.flags.S      = false;
                instr.Rd           = Register::SP;
                instr.Rn           = Register::SP;
                instr.imm          = _7BIT(encoding) << 2;
                instr.operand_type = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if ((opcode_4 == 0b0001 || opcode_4 == 0b0011 || opcode_4 == 0b1001 || opcode_4 == 0b1011) && m_arch >= Architecture::ARMv7M)
            {
                REQUIRE_ARCH(Architecture::ARMv7M);

                // Compare and Branch on Zero CBNZ, CBZ on page A7-216
                instr.name = (_1BIT(encoding >> 11) == 1) ? Mnemonic::CBNZ : Mnemonic::CBZ;
                instr.Rn   = (Register)(_3BIT(encoding));
                instr.imm  = (_1BIT(encoding >> 9) << 6) | (_5BIT(encoding >> 3) << 1);

                if (in_IT_block)
                {
                    THROW_UNPREDICTABLE;
                }

                instr.operand_type = OperandType::RI;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b001000)
            {
                // Signed Extend Halfword SXTH on page A6-169
                instr.name         = Mnemonic::SXTH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.shift_amount = 0;
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b001001)
            {
                // Signed Extend Byte SXTB on page A6-168
                instr.name         = Mnemonic::SXTB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.shift_amount = 0;
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b001010)
            {
                // Unsigned Extend Halfword UXTH on page A6-173
                instr.name         = Mnemonic::UXTH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.shift_amount = 0;
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b001011)
            {
                // Unsigned Extend Byte UXTB on page A6-172
                instr.name         = Mnemonic::UXTB;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.shift_amount = 0;
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b010)
            {
                // Push Multiple Registers PUSH on page A6-149
                instr.name = Mnemonic::PUSH;
                u32 m      = _1BIT(encoding >> 8);
                instr.imm  = (m << 14) | _8BIT(encoding);
                if (instr.imm == 0)
                {
                    THROW_UNPREDICTABLE;
                }
                instr.operand_type = OperandType::I;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b0110011)
            {
                // Change Processor State CPS on page B4-264
                instr.name         = Mnemonic::CPS;
                instr.imm          = _5BIT(encoding);
                instr.operand_type = OperandType::I;

                if (_2BIT(encoding >> 2) != 0b00)
                {
                    THROW_UNEXPECTED;
                }
                if (in_IT_block)
                {
                    THROW_UNPREDICTABLE;
                }
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b101000)
            {
                // Byte-Reverse Word REV on page A6-150
                instr.name         = Mnemonic::REV;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b101001)
            {
                // Byte-Reverse Packed Halfword REV16 on page A6-151
                instr.name         = Mnemonic::REV16;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_6 == 0b101011)
            {
                // Byte-Reverse Signed Halfword REVSH on page A6-152
                instr.name         = Mnemonic::REVSH;
                instr.Rd           = (Register)(_3BIT(encoding));
                instr.Rm           = (Register)(_3BIT(encoding >> 3));
                instr.operand_type = OperandType::RR;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_3 == 0b110)
            {
                // Pop Multiple Registers POP on page A6-148
                instr.name = Mnemonic::POP;
                u32 p      = _1BIT(encoding >> 8);
                instr.imm  = (p << 15) | _8BIT(encoding);
                if (instr.imm == 0)
                {
                    THROW_UNPREDICTABLE;
                }
                if (p && in_IT_block && !last_in_IT_block)
                {
                    THROW_UNPREDICTABLE;
                }
                instr.operand_type = OperandType::I;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_4 == 0b1110)
            {
                // Breakpoint BKPT on page A6-112
                instr.name = Mnemonic::BKPT;
                return {ReturnCode::OK, instr};
            }
            else if (opcode_4 == 0b1111)
            {
                // Hints Hint instructions on page A5-84
                opcode = _4BIT(encoding >> 4);

                if (_4BIT(encoding) != 0b0000)
                {
                    // IT on page A7-236
                    REQUIRE_ARCH(Architecture::ARMv7M);

                    u32 firstcond = _4BIT(encoding >> 4);
                    u32 mask      = _4BIT(encoding);

                    if (firstcond == 0b1111 || (firstcond == 0b1110 && arm_functions::bit_count(mask) != 1))
                    {
                        THROW_UNPREDICTABLE;
                    }

                    if (in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }

                    instr.name         = Mnemonic::IT;
                    instr.imm          = (firstcond << 4) | mask;
                    instr.operand_type = OperandType::I;
                    return {ReturnCode::OK, instr};
                }

                if (opcode == 0b0000)
                {
                    // No Operation hint NOP on page A6-146
                    instr.name = Mnemonic::NOP;
                    return {ReturnCode::OK, instr};
                }
                else if (opcode == 0b0001)
                {
                    // Yield hint YIELD on page A6-176
                    instr.name = Mnemonic::YIELD;
                    return {ReturnCode::OK, instr};
                }
                else if (opcode == 0b0010)
                {
                    // Wait for Event hint WFE on page A6-174
                    instr.name = Mnemonic::WFE;
                    return {ReturnCode::OK, instr};
                }
                else if (opcode == 0b0011)
                {
                    // Wait for Interrupt hint WFI on page A6-175
                    instr.name = Mnemonic::WFI;
                    return {ReturnCode::OK, instr};
                }
                else if (opcode == 0b0100)
                {
                    // Send Event hint SEV on page A6-156
                    instr.name = Mnemonic::SEV;
                    return {ReturnCode::OK, instr};
                }
            }
        }
        else if (opcode_5 == 0b11000)
        {
            // Store multiple registers, see STM, STMIA, STMEA on page A6-157
            instr.name        = Mnemonic::STM;
            instr.Rn          = (Register)(_3BIT(encoding >> 8));
            instr.imm         = _8BIT(encoding);
            instr.flags.wback = true;
            if (instr.imm == 0)
            {
                THROW_UNPREDICTABLE;
            }
            if (_1BIT(instr.imm >> instr.Rn) && instr.flags.wback && instr.Rn != arm_functions::lowest_set_bit(instr.imm))
            {
                THROW_UNPREDICTABLE;
            }
            instr.operand_type = OperandType::RI;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_5 == 0b11001)
        {
            // Load multiple registers, see LDM, LDMIA, LDMFD on page A6-125
            instr.name        = Mnemonic::LDM;
            instr.Rn          = (Register)(_3BIT(encoding >> 8));
            instr.imm         = _8BIT(encoding);
            instr.flags.wback = (_1BIT(instr.imm >> instr.Rn) == 0);
            if (instr.imm == 0)
            {
                THROW_UNPREDICTABLE;
            }
            instr.operand_type = OperandType::RI;
            return {ReturnCode::OK, instr};
        }
        else if (opcode_4 == 0b1101)
        {
            // Conditional branch, and Supervisor Call on page A5-84
            opcode   = _4BIT(encoding >> 8);
            opcode_3 = opcode >> 1;

            if (opcode_3 != 0b111)
            {
                // Conditional branch B on page A6-110
                instr.name      = Mnemonic::B;
                instr.condition = (Condition)(_4BIT(encoding >> 8));
                instr.imm       = arm_functions::sign_extend(_8BIT(encoding) << 1, 9);

                if (in_IT_block)
                {
                    THROW_UNPREDICTABLE;
                }

                instr.operand_type = OperandType::I;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1110)
            {
                // Permanently UNDEFINED UDF on page A6-171
                instr.name = Mnemonic::UDF;
                return {ReturnCode::OK, instr};
            }
            else if (opcode == 0b1111)
            {
                // Supervisor Call SVC on page A6-167
                instr.name         = Mnemonic::SVC;
                instr.imm          = _8BIT(encoding);
                instr.operand_type = OperandType::I;
                return {ReturnCode::OK, instr};
            }
        }
        else if (opcode_5 == 0b11100)
        {
            // Unconditional Branch, see B on page A6-110
            instr.name = Mnemonic::B;
            instr.imm  = arm_functions::sign_extend(_11BIT(encoding) << 1, 12);

            if (in_IT_block && !last_in_IT_block)
            {
                THROW_UNPREDICTABLE;
            }

            instr.operand_type = OperandType::I;
            return {ReturnCode::OK, instr};
        }
    }
    else
    {
        u16 encoding_high = instruction_stream[0];
        u16 encoding_low  = instruction_stream[1];
        instr.encoding    = ((u32)encoding_high << 16) | encoding_low;

        // 32-bit thumb code

        u8 op1 = _2BIT(encoding_high >> 11);
        u8 op2 = _7BIT(encoding_high >> 4);
        u8 op  = (encoding_low >> 15);

        if (op1 == 0b01)
        {
            if (_2BIT(op2 >> 5) == 0 && _1BIT(op2 >> 2) == 0)    // 0b00xx0xx
            {
                // Load Multiple and Store Multiple on page A5 - 144
                op     = (_2BIT(encoding_high >> 7) << 1) | _1BIT(encoding_high >> 4);
                u8 wrn = (_1BIT(encoding_high >> 5) << 4) | _4BIT(encoding_high);

                if (op == 0b010)
                {
                    // Store Multiple (Increment After, Empty Ascending) STM, STMIA, STMEA on page A7 - 383
                    REQUIRE_ARCH(Architecture::ARMv7M);

                    if (_1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 15) != 0)
                    {
                        THROW_UNEXPECTED;
                    }

                    instr.name        = Mnemonic::STM;
                    instr.Rn          = (Register)(_4BIT(encoding_high));
                    instr.imm         = encoding_low;
                    instr.flags.wback = _1BIT(encoding_high >> 5) == 1;
                    if (arm_functions::bit_count(instr.imm) < 2 || is15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }

                    instr.operand_type = OperandType::RI;
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b011 && wrn != 0b11101)
                {
                    // Load Multiple (Increment After, Full Descending) LDM, LDMIA, LDMFD on page A7 - 242
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::LDM;
                    instr.Rn           = (Register)(_4BIT(encoding_high));
                    instr.imm          = encoding_low;
                    instr.flags.wback  = _1BIT(encoding_high >> 5) == 1;
                    instr.operand_type = OperandType::RI;

                    if (_1BIT(encoding_low >> 13) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (arm_functions::bit_count(instr.imm) < 2 || is15(Rn) || _2BIT(encoding_low >> 14) == 0b11)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(instr.imm >> 15) == 1 && in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(instr.imm >> instr.Rn) == 1 && instr.flags.wback)
                    {
                        THROW_UNPREDICTABLE;
                    }

                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b011 && wrn == 0b11101)
                {
                    // Pop Multiple Registers from the stack POP on page A7 - 319
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::POP;
                    instr.imm          = encoding_low;
                    instr.operand_type = OperandType::I;
                    if (_1BIT(encoding_low >> 13) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (arm_functions::bit_count(instr.imm) < 2 && _2BIT(encoding_low >> 14) == 0b11)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(encoding_low >> 15) == 1 && in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b100 && wrn != 0b11101)
                {
                    // Store Multiple (Decrement Before, Full Descending) STMDB, STMFD on page A7 - 385
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name        = Mnemonic::STMDB;
                    instr.Rn          = (Register)_4BIT(encoding_high);
                    instr.flags.wback = (_1BIT(encoding_high >> 5) == 1);
                    instr.imm         = encoding_low;
                    if (_1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 15) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (arm_functions::bit_count(instr.imm) < 2 || is15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(instr.imm >> instr.Rn) == 1 && instr.flags.wback)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    instr.operand_type = OperandType::RI;
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b100 && wrn == 0b11101)
                {
                    // Push Multiple Registers to the stack. PUSH on page A7 - 322
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name = Mnemonic::PUSH;
                    instr.imm  = encoding_low;
                    if (_1BIT(encoding_low >> 15) != 0 || _1BIT(encoding_low >> 13) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (arm_functions::bit_count(instr.imm) < 2)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    instr.operand_type = OperandType::I;
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b101)
                {
                    // Load Multiple (Decrement Before, Empty Ascending) LDMDB, LDMEA on page A7 - 244
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name        = Mnemonic::LDMDB;
                    instr.Rn          = (Register)_4BIT(encoding_high);
                    instr.flags.wback = (_1BIT(encoding_high >> 5) == 1);
                    instr.imm         = encoding_low;
                    if (_1BIT(encoding_low >> 13) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (arm_functions::bit_count(instr.imm) < 2 || is15(Rn) || _2BIT(encoding_low >> 14) == 0b11)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(instr.imm >> 15) == 1 && in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    if (_1BIT(instr.imm >> instr.Rn) == 1 && instr.flags.wback)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    instr.operand_type = OperandType::RI;
                    return {ReturnCode::OK, instr};
                }
            }
            else if (_2BIT(op2 >> 5) == 0 && _1BIT(op2 >> 2) == 1)    // 0b00xx1xx
            {
                // Load / store dual or exclusive, table branch on page A5 - 145
                op1    = _2BIT(encoding_high >> 7);
                op2    = _2BIT(encoding_high >> 4);
                u8 op3 = _4BIT(encoding_low >> 4);

                if ((_1BIT(op1 >> 1) == 0 && op2 == 0b10) || (_1BIT(op1 >> 1) == 1 && _1BIT(op2) == 0))
                {
                    // Store Register Dual STRD (immediate) on page A7 - 393
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name        = Mnemonic::STRD;
                    instr.Rd          = (Register)_4BIT(encoding_low >> 12);
                    instr.Rn          = (Register)_4BIT(encoding_high);
                    instr.Rm          = (Register)_4BIT(encoding_low >> 8);
                    instr.imm         = _8BIT(encoding_low) << 2;
                    instr.flags.index = _1BIT(encoding_high >> 8) == 1;
                    instr.flags.add   = _1BIT(encoding_high >> 7) == 1;
                    instr.flags.wback = _1BIT(encoding_high >> 5) == 1;
                    if ((instr.Rn == instr.Rd || instr.Rn == instr.Rm) && instr.flags.wback)
                    {
                        THROW_UNPREDICTABLE;
                    }

                    if (is15(Rn) || is13or15(Rd) || is13or15(Rm))
                    {
                        THROW_UNPREDICTABLE;
                    }

                    instr.operand_type = OperandType::RRRI;
                    return {ReturnCode::OK, instr};
                }
                else if ((_1BIT(op1 >> 1) == 0 && op2 == 0b11) || (_1BIT(op1 >> 1) == 1 && _1BIT(op2) == 1))
                {
                    // Load Register Dual LDRD (immediate) on page A7 - 257, LDRD (literal) on page A7 - 259
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name        = Mnemonic::LDRD;
                    instr.RdHi          = (Register)_4BIT(encoding_low >> 12);
                    instr.Rn          = (Register)_4BIT(encoding_high);
                    instr.RdLo          = (Register)_4BIT(encoding_low >> 8);
                    instr.imm         = _8BIT(encoding_low) << 2;
                    instr.flags.wback = _1BIT(encoding_high >> 5) == 1;
                    instr.flags.add   = _1BIT(encoding_high >> 7) == 1;
                    instr.flags.index = _1BIT(encoding_high >> 8) == 1;

                    if (is13or15(RdHi) || is13or15(RdLo) || (instr.RdHi == instr.RdLo))
                    {
                        THROW_UNPREDICTABLE;
                    }

                    if (instr.Rn == 0b1111)
                    {
                        // LDRD (literal)
                        if (instr.flags.wback)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        instr.flags.index  = true;
                        instr.operand_type = OperandType::RRI;
                    }
                    else
                    {
                        // LDRD (immediate)
                        if ((instr.Rn == instr.RdHi || instr.Rn == instr.RdLo) && instr.flags.wback)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        instr.operand_type = OperandType::RRRI;
                    }

                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0)
                {
                    if (op2 == 0b00)
                    {
                        // Store Register Exclusive STREX on page A7 - 394
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::STREX;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rm           = (Register)_4BIT(encoding_low >> 12);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = _8BIT(encoding_low) << 2;
                        instr.operand_type = OperandType::RRRI;

                        if (is13or15(Rd) || is13or15(Rm) || is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        if (instr.Rd == instr.Rn || instr.Rd == instr.Rm)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op2 == 0b01)
                    {
                        // Load Register Exclusive LDREX on page A7 - 261
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::LDREX;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = _8BIT(encoding_low) << 2;
                        instr.operand_type = OperandType::RRI;

                        if (_4BIT(encoding_low >> 8) != 0b1111)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rd) || is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b01)
                {
                    if (op2 == 0b00)
                    {
                        if (op3 == 0b0100)
                        {
                            // Store Register Exclusive Byte STREXB on page A7 - 395
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::STREXB;
                            instr.Rd           = (Register)_4BIT(encoding_low);
                            instr.Rm           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRR;

                            if (_4BIT(encoding_low >> 8) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rd) || is13or15(Rm) || is15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            if (instr.Rd == instr.Rn || instr.Rd == instr.Rm)
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op3 == 0b0101)
                        {
                            // Store Register Exclusive Halfword STREXH on page A7 - 396
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::STREXH;
                            instr.Rd           = (Register)_4BIT(encoding_low);
                            instr.Rm           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRR;

                            if (_4BIT(encoding_low >> 8) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rd) || is13or15(Rm) || is15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            if (instr.Rd == instr.Rn || instr.Rd == instr.Rm)
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b01)
                    {
                        if (op3 == 0b0000 || op3 == 0b0001)
                        {
                            // Table Branch Byte TBB, TBH on page A7 - 416
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = (_1BIT(encoding_low >> 4) == 1) ? Mnemonic::TBH : Mnemonic::TBB;
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RR;
                            if (_4BIT(encoding_low >> 12) != 0b1111 || _4BIT(encoding_low >> 8) != 0b0000)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            if (in_IT_block && !last_in_IT_block)
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op3 == 0b0100)
                        {
                            // Load Register Exclusive Byte LDREXB on page A7 - 262
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDREXB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RR;

                            if (_4BIT(encoding_low >> 8) != 0b1111 || _4BIT(encoding_low) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rd) || is15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op3 == 0b0101)
                        {
                            // Load Register Exclusive Halfword LDREXH on page A7 - 263
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDREXH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RR;

                            if (_4BIT(encoding_low >> 8) != 0b1111 || _4BIT(encoding_low) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rd) || is15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                }
            }
            else if (_2BIT(op2 >> 5) == 0b01)    // 0b01xxxxx
            {
                // Data processing (shifted register) on page A5 - 150
                op    = _4BIT(encoding_high >> 5);
                u8 S  = _1BIT(encoding_high >> 4);
                u8 Rn = _4BIT(encoding_high);
                u8 Rd = _4BIT(encoding_low >> 8);

                if (op == 0b0000)
                {
                    if (Rd != 0b1111)
                    {
                        // Bitwise AND AND (register) on page A7 - 201 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::AND;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13or15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        if (S == 0)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        // Test TST (register) on page A7 - 420 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::TST;
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0001)
                {
                    // Bitwise Bit Clear BIC (register) on page A7 - 210 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::BIC;
                    instr.flags.S           = _1BIT(encoding_high >> 4);
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRR;
                    if (encoding_low >> 15 != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b0010)
                {
                    if (Rn != 0b1111)
                    {
                        // Bitwise OR ORR (register) on page A7 - 310 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::ORR;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13(Rn) || is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Move register and immediate shifts -
                        u8 type = _2BIT(encoding_low >> 4);
                        u8 imm  = (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6);

                        if (type == 0b00)
                        {
                            if (imm == 0b00000)
                            {
                                // Move MOV (register) on page A7 - 293
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::MOV;
                                instr.flags.S      = _1BIT(encoding_high >> 4);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.operand_type = OperandType::RR;
                                if (encoding_low >> 15 != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                if (instr.flags.S && (is13or15(Rm) || is13or15(Rd)))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                if (!instr.flags.S && (is15(Rm) || is15(Rd) || (is13(Rd) || is13(Rm))))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else
                            {
                                // Logical Shift Left LSL (immediate) on page A7 - 282
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name              = Mnemonic::LSL;
                                instr.flags.S           = _1BIT(encoding_high >> 4);
                                instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                                instr.Rm                = (Register)_4BIT(encoding_low);
                                auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b00, imm);
                                instr.shift_type        = shift_t;
                                instr.shift_amount      = shift_n;
                                instr.operand_type      = OperandType::RRI;
                                if (encoding_low >> 15 != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                if (is13or15(Rm) || is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                        else if (type == 0b01)
                        {
                            // Logical Shift Right LSR (immediate) on page A7 - 284
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name              = Mnemonic::LSR;
                            instr.flags.S           = _1BIT(encoding_high >> 4);
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b01, imm);
                            instr.shift_type        = shift_t;
                            instr.shift_amount      = shift_n;
                            instr.operand_type      = OperandType::RRI;
                            if (encoding_low >> 15 != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (type == 0b10)
                        {
                            // Arithmetic Shift Right ASR (immediate) on page A7 - 203
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name              = Mnemonic::ASR;
                            instr.flags.S           = _1BIT(encoding_high >> 4);
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b10, imm);
                            instr.shift_type        = shift_t;
                            instr.shift_amount      = shift_n;
                            instr.operand_type      = OperandType::RRI;
                            if (encoding_low >> 15 != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (type == 0b11)
                        {
                            if (imm == 0b00000)
                            {
                                // Rotate Right with Extend RRX on page A7 - 340
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::RRX;
                                instr.flags.S      = _1BIT(encoding_high >> 4);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.operand_type = OperandType::RR;
                                if (encoding_low >> 15 != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                if (is13or15(Rm) || is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else
                            {
                                // Rotate Right ROR (immediate) on page A7 - 338
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name              = Mnemonic::ROR;
                                instr.flags.S           = _1BIT(encoding_high >> 4);
                                instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                                instr.Rm                = (Register)_4BIT(encoding_low);
                                auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b11, imm);
                                instr.shift_type        = shift_t;
                                instr.shift_amount      = shift_n;
                                instr.operand_type      = OperandType::RRI;
                                if (encoding_low >> 15 != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                if (is13or15(Rm) || is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                    }
                }
                else if (op == 0b0011)
                {
                    if (Rn != 0b1111)
                    {
                        // Bitwise OR NOT ORN (register) on page A7 - 308 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::ORN;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13(Rn) || is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Bitwise NOT MVN (register) on page A7 - 304 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::MVN;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0100)
                {
                    if (Rd != 0b1111)
                    {
                        // Bitwise Exclusive OR EOR (register) on page A7 - 233 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::EOR;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13(Rn) || is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        if (S == 0)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        // Test Equivalence TEQ (register) on page A7 - 418 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::TEQ;
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0110)
                {
                    // Pack Halfword PKHBT, PKHTB on page A7 - 312 v7E-M
                    REQUIRE_ARCH(Architecture::ARMv7EM);
                    uint8_t type = (_1BIT(encoding_low >> 5) << 1);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(type, (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));

                    if(shift_t == mulator::ShiftType::ASR){
                        instr.name              = Mnemonic::PKHTB;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                    }
                    else{
                        instr.name              = Mnemonic::PKHBT;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                    }


                    if (is13or15(Rm) || is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }

                    if(instr.flags.S || (_1BIT(encoding_low >> 3))){
                        THROW_UNPREDICTABLE;
                    }

                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b1000)
                {
                    if (Rd != 0b1111)
                    {
                        // Add ADD (register) on page A7 - 192 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::ADD;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;

                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13(Rn))
                        {
                            // see ADD (SP plus register) on page A7-196.
                            if (is13or15(Rm) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is13or15(Rm) || is15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }

                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        if (S == 0)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        // Compare Negative CMN (register) on page A7 - 222 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::CMN;
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b1010)
                {
                    // Add with Carry ADC (register) on page A7 - 188 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::ADC;
                    instr.flags.S           = _1BIT(encoding_high >> 4);
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRR;
                    if (encoding_low >> 15 != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b1011)
                {
                    // Subtract with Carry SBC (register) on page A7 - 347 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::SBC;
                    instr.flags.S           = _1BIT(encoding_high >> 4);
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRR;
                    if (encoding_low >> 15 != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b1101)
                {
                    if (Rd != 0b1111)
                    {
                        // Subtract SUB (register) on page A7 - 404 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::SUB;
                        instr.flags.S           = _1BIT(encoding_high >> 4);
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RRR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13(Rn))
                        {
                            // see SUB (SP minus register) on page A7-196.
                            if (is13or15(Rm) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is13or15(Rm) || is15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        if (S == 0)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        // Compare CMP (register) on page A7 - 224 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name              = Mnemonic::CMP;
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                        instr.shift_type        = shift_t;
                        instr.shift_amount      = shift_n;
                        instr.operand_type      = OperandType::RR;
                        if (encoding_low >> 15 != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        if (is13or15(Rm) || is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b1110)
                {
                    // Reverse Subtract RSB (register) on page A7 - 342 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::RSB;
                    instr.flags.S           = _1BIT(encoding_high >> 4);
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(_2BIT(encoding_low >> 4), (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRR;
                    if (encoding_low >> 15 != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
            }
        }
        else if (op1 == 0b10)
        {
            if (_1BIT(op2 >> 5) == 0 && op == 0)    // 0bx0xxxxx
            {
                // Data processing (modified immediate) on page A5 - 138

                op    = _4BIT(encoding_high >> 5);
                u8 Rn = _4BIT(encoding_high);
                u8 Rd = _4BIT(encoding_low >> 8);

                if (op == 0b0000)
                {
                    if (Rd != 0b1111)
                    {
                        // Bitwise AND AND (immediate) on page A7 - 200
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::AND;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13or15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Test TST (immediate) on page A7 - 419
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::TST;
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0001)
                {
                    // Bitwise Clear BIC (immediate) on page A7 - 209
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::BIC;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    instr.operand_type = OperandType::RRI;
                    if (is13or15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b0010)
                {
                    if (Rn != 0b1111)
                    {
                        // Bitwise Inclusive OR ORR (immediate) on page A7 - 309
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ORR;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13or15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Move MOV (immediate) on page A7 - 291
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::MOV;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0011)
                {
                    if (Rn != 0b1111)
                    {
                        // Bitwise OR NOT ORN (immediate) on page A7 - 307
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ORN;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13or15(Rn) || is13(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Bitwise NOT MVN (immediate) on page A7 - 303
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::MVN;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b0100)
                {
                    if (Rd != 0b1111)
                    {
                        // Bitwise Exclusive OR EOR (immediate) on page A7 - 232
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::EOR;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13or15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Test Equivalence TEQ (immediate) on page A7 - 417
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::TEQ;
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b1000)
                {
                    if (Rd != 0b1111)
                    {
                        // Add ADD (immediate) on page A7 - 190
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ADD;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                        CHECK_IMM(imm_ok);
                        instr.imm          = val;
                        instr.operand_type = OperandType::RRI;
                        if (is13(Rn))
                        {
                            // see ADD (SP plus register)
                            if (is15(Rd) && !instr.flags.S)
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Compare Negative CMN (immediate) on page A7 - 221
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::CMN;
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                        CHECK_IMM(imm_ok);
                        instr.imm          = val;
                        instr.operand_type = OperandType::RI;
                        if (is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b1010)
                {
                    // Add with Carry ADC (immediate) on page A7 - 187
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::ADC;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                    CHECK_IMM(imm_ok);
                    instr.imm          = val;
                    instr.operand_type = OperandType::RRI;
                    if (is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b1011)
                {
                    // Subtract with Carry SBC (immediate) on page A7 - 346
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::SBC;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                    CHECK_IMM(imm_ok);
                    instr.imm          = val;
                    instr.operand_type = OperandType::RRI;
                    if (is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b1101)
                {
                    if (Rd != 0b1111)
                    {
                        // Subtract SUB (immediate) on page A7 - 402
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::SUB;
                        instr.flags.S      = _1BIT(encoding_high >> 4);
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                        CHECK_IMM(imm_ok);
                        instr.imm          = val;
                        instr.operand_type = OperandType::RRI;
                        if (is13(Rn))
                        {
                            // see SUB (SP plus register)
                            if (is15(Rd) && !instr.flags.S)
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is15(Rn) || is13(Rd) || (is15(Rd) && !instr.flags.S))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Compare CMP (immediate) on page A7 - 223
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::CMP;
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                        CHECK_IMM(imm_ok);
                        instr.imm          = val;
                        instr.operand_type = OperandType::RI;
                        if (is15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b1110)
                {
                    // Reverse Subtract RSB (immediate) on page A7 - 341
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::RSB;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    auto [imm_ok, val] = arm_functions::thumb_expand_imm(instr.imm);
                    CHECK_IMM(imm_ok);
                    instr.imm          = val;
                    instr.operand_type = OperandType::RRI;
                    if (is13or15(Rn) || is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
            }
            else if (_1BIT(op2 >> 5) == 1 && op == 0)    // 0bx1xxxxx
            {
                // Data processing (plain binary immediate) on page A5 - 141

                op    = _5BIT(encoding_high >> 4);
                u8 Rn = _4BIT(encoding_high);

                if (op == 0b00000)
                {
                    if (Rn != 0b1111)
                    {
                        // Add Wide, 12 - bit ADD (immediate) on page A7 - 190 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ADDW;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13(Rn))
                        {
                            // see ADD (SP plus register)
                            if (is15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Form PC - relative Address ADR on page A7 - 198 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ADR;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.flags.add    = true;
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b00100)
                {
                    // Move Wide, 16 - bit MOV (immediate) on page A7 - 291 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::MOVW;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.imm          = (_4BIT(encoding_high) << 12) | (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    instr.operand_type = OperandType::RI;
                    if (is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b01010)
                {
                    if (Rn != 0b1111)
                    {
                        // Subtract Wide, 12 - bit SUB (immediate) on page A7 - 402 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::SUBW;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.operand_type = OperandType::RRI;
                        if (is13(Rn))
                        {
                            // see ADD (SP plus register)
                            if (is15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        else
                        {
                            if (is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Form PC - relative Address ADR on page A7 - 198 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::ADR;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.imm          = (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                        instr.flags.add    = false;
                        instr.operand_type = OperandType::RI;
                        if (is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b01100)
                {
                    // Move Top, 16 - bit MOVT on page A7 - 296 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::MOVT;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.imm          = (_4BIT(encoding_high) << 12) | (_1BIT(encoding_high >> 10) << 11) | (_3BIT(encoding_low >> 12) << 8) | _8BIT(encoding_low);
                    instr.operand_type = OperandType::RI;
                    if (is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b10000 || (op == 0b10010 && _3BIT(encoding_low >> 12) != 0 && _2BIT(encoding_low >> 6) != 0))
                {
                    // Signed Saturate SSAT on page A7 - 375 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::SSAT;
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.imm               = _5BIT(encoding_low) + 1;
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b00, (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRI;
                    if (_1BIT(encoding_high >> 10) != 0 || _1BIT(encoding_low >> 5) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b10010 && _3BIT(encoding_low >> 12) == 0 && _2BIT(encoding_low >> 6) == 0)
                {
                    // Signed Saturate, two 16 - bit SSAT16 on page A7 - 376 v7E-M
                    REQUIRE_ARCH(Architecture::ARMv7EM);
                    instr.name         = Mnemonic::SSAT16;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = _4BIT(encoding_low);
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};    
                }
                else if (op == 0b10100)
                {
                    // Signed Bit Field Extract SBFX on page A7 - 349 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::SBFX;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6);
                    instr.imm2         = _5BIT(encoding_low) + 1;
                    instr.operand_type = OperandType::RRII;
                    if (_1BIT(encoding_high >> 10) != 0 || _1BIT(encoding_low >> 5) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b10110)
                {
                    if (Rn != 0b1111)
                    {
                        // Bit Field Insert BFI on page A7 - 208 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name = Mnemonic::BFI;
                        instr.Rd   = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn   = (Register)_4BIT(encoding_high);
                        u32 lsb    = (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6);
                        u32 msb    = _5BIT(encoding_low);
                        if (lsb > msb)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        instr.imm          = lsb;              // lsb
                        instr.imm2         = msb - lsb + 1;    // width
                        instr.operand_type = OperandType::RRII;
                        if (is13or15(Rd) || is13(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Bit Field Clear BFC on page A7 - 207 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name = Mnemonic::BFC;
                        instr.Rd   = (Register)_4BIT(encoding_low >> 8);
                        u32 lsb    = (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6);
                        u32 msb    = _5BIT(encoding_low);
                        if (lsb > msb)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        instr.imm          = lsb;              // lsb
                        instr.imm2         = msb - lsb + 1;    // width
                        instr.operand_type = OperandType::RRII;
                        if (is13or15(Rd))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op == 0b11000 || (op == 0b11010 && _3BIT(encoding_low >> 12) != 0 && _2BIT(encoding_low >> 6) != 0))
                {
                    // Unsigned Saturate USAT on page A7 - 444 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name              = Mnemonic::USAT;
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.imm               = _5BIT(encoding_low);
                    auto [shift_t, shift_n] = arm_functions::decode_imm_shift(0b00, (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6));
                    instr.shift_type        = shift_t;
                    instr.shift_amount      = shift_n;
                    instr.operand_type      = OperandType::RRI;
                    if (_1BIT(encoding_high >> 10) != 0 || _1BIT(encoding_low >> 5) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op == 0b11010 && _3BIT(encoding_low >> 12) == 0 && _2BIT(encoding_low >> 6) == 0)
                {
                    // Unsigned Saturate 16 USAT16 on page A7 - 445 v7E-M
                    REQUIRE_ARCH(Architecture::ARMv7EM);
                    instr.name         = Mnemonic::USAT16;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = _4BIT(encoding_low);
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};  
                }
                else if (op == 0b11100)
                {
                    // Unsigned Bit Field Extract UBFX on page A7 - 424 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::UBFX;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.imm          = (_3BIT(encoding_low >> 12) << 2) | _2BIT(encoding_low >> 6);
                    instr.imm2         = _5BIT(encoding_low) + 1;
                    instr.operand_type = OperandType::RRII;
                    if (_1BIT(encoding_high >> 10) != 0 || _1BIT(encoding_low >> 5) != 0)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
            }
            else if (op == 1)    // 0bxxxxxxx
            {
                // Branches and miscellaneous control on page A5 - 142

                op  = _7BIT(encoding_high >> 4);
                op1 = _3BIT(encoding_low >> 12);

                if (op1 == 0b000 || op1 == 0b010)
                {
                    if (_3BIT(op >> 3) != 0b111)
                    {
                        // Conditional branch B on page A7 - 205
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name      = Mnemonic::B;
                        u32 s           = _1BIT(encoding_high >> 10);
                        u32 j1          = _1BIT(encoding_low >> 13);
                        u32 j2          = _1BIT(encoding_low >> 11);
                        instr.condition = (Condition)_4BIT(encoding_high >> 6);
                        instr.imm       = (s << 19) | (j1 << 18) | (j2 << 17) | (_6BIT(encoding_high) << 11) | _11BIT(encoding_low);
                        instr.imm       = arm_functions::sign_extend(instr.imm << 1, 21);

                        if (in_IT_block)
                        {
                            THROW_UNPREDICTABLE;
                        }

                        instr.operand_type = OperandType::I;
                        return {ReturnCode::OK, instr};
                    }
                    else if (op >> 1 == 0b011100)
                    {
                        // Move to Special Register MSR on page A7 - 301
                        if (m_arch == Architecture::ARMv6M && (_1BIT(encoding_high >> 4) != 0 || _6BIT(encoding_low >> 8) != 0b001000))
                        {
                            THROW_UNEXPECTED;
                        }
                        if (m_arch > Architecture::ARMv6M && (_1BIT(encoding_high >> 4) != 0 || _1BIT(encoding_low >> 13) != 0 || _2BIT(encoding_low >> 8) != 0))
                        {
                            THROW_UNEXPECTED;
                        }
                        instr.name         = Mnemonic::MSR;
                        instr.Rn           = (Register)(_4BIT(encoding_high));
                        instr.imm          = _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;

                        if (is13or15(Rn) || instr.imm == 4 || (instr.imm > 9 && instr.imm < 16) || instr.imm > 20)
                        {
                            THROW_UNDEFINED;
                        }

                        if (m_arch > Architecture::ARMv6M)
                        {
                            u32 mask = _2BIT(encoding_low >> 10);
                            if (mask == 0b00 || (mask != 0b10 && instr.imm > 3))
                            {
                                THROW_UNDEFINED;
                            }
                            instr.imm |= mask << 8;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op == 0b0111010)
                    {
                        // Hint instructions on page A5 - 143

                        op1 = _3BIT(encoding_low >> 8);
                        op2 = _8BIT(encoding_low);

                        if (op1 != 0)
                        {
                            // UNDEFINED
                            THROW_UNDEFINED;
                        }
                        else
                        {
                            if (op2 == 0b00000000)
                            {
                                // No Operation hint NOP on page A7 - 306
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::NOP;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b00000001)
                            {
                                // Yield hint YIELD on page A7 - 506
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::YIELD;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b00000010)
                            {
                                // Wait For Event hint WFE on page A7 - 504
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::WFE;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b00000011)
                            {
                                // Wait For Interrupt hint WFI on page A7 - 505
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::WFI;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b00000100)
                            {
                                // Send Event hint SEV on page A7 - 352
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::SEV;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b00010100)
                            {
                                // Consumption of Speculative Data Barrier CSDB on page A7 - 228
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::CSDB;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 >> 4 == 0b1111)
                            {
                                // Debug hint DBG on page A7 - 229
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _1BIT(encoding_low >> 11) != 0)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::DBG;
                                return {ReturnCode::OK, instr};
                            }
                        }
                    }
                    else if (op == 0b0111011)
                    {
                        // Miscellaneous control instructions on page A5 - 143

                        op1 = _4BIT(encoding_low >> 4);
                        op2 = _4BIT(encoding_low);

                        if (op1 == 0b0010)
                        {
                            // Clear Exclusive CLREX on page A7 - 219
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111 || _4BIT(encoding_low) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            instr.name = Mnemonic::CLREX;
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b0100)
                        {
                            if (op2 == 0b0000)
                            {
                                // Speculative Store Bypass Barrier SSBB on page A7 - 378
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::SSBB;
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0b0100)
                            {
                                // Physical Speculative Store Bypass Barrier PSSBB on page A7 - 321
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::PSSBB;
                                return {ReturnCode::OK, instr};
                            }
                            else
                            {
                                // Data Synchronization Barrier DSB on page A7 - 231
                                if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111)
                                {
                                    THROW_UNEXPECTED;
                                }
                                instr.name = Mnemonic::DSB;
                                return {ReturnCode::OK, instr};
                            }
                        }
                        else if (op1 == 0b0101)
                        {
                            // Data Memory Barrier DMB on page A7 - 230
                            if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            instr.name = Mnemonic::DMB;
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b0110)
                        {
                            // Instruction Synchronization Barrier ISB on page A7 - 235
                            if (_4BIT(encoding_high) != 0b1111 || _1BIT(encoding_low >> 13) != 0 || _4BIT(encoding_low >> 8) != 0b1111)
                            {
                                THROW_UNEXPECTED;
                            }
                            instr.name = Mnemonic::ISB;
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op >> 1 == 0b011111)
                    {
                        // Move from Special Register MRS on page A7 - 300
                        if (_5BIT(encoding_high) != 0b01111 || _1BIT(encoding_low >> 13) != 0)
                        {
                            THROW_UNEXPECTED;
                        }
                        instr.name         = Mnemonic::MRS;
                        instr.Rd           = (Register)(_4BIT(encoding_low >> 8));
                        instr.imm          = _8BIT(encoding_low);
                        instr.operand_type = OperandType::RI;

                        if (is13(Rd) || instr.imm == 4 || (instr.imm > 9 && instr.imm < 16) || instr.imm > 20)
                        {
                            THROW_UNDEFINED;
                        }
                        return {ReturnCode::OK, instr};
                    }

                    if (op1 == 0b010 && op == 0b1111111)
                    {
                        // Permanently UNDEFINED UDF on page A7 - 425
                        instr.name = Mnemonic::UDF;
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b001 || op1 == 0b011)
                {
                    // Branch B on page A7 - 205
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name = Mnemonic::B;
                    u32 s      = _1BIT(encoding_high >> 10);
                    u32 i1     = !(_1BIT(encoding_low >> 13) ^ s);
                    u32 i2     = !(_1BIT(encoding_low >> 11) ^ s);
                    instr.imm  = (s << 23) | (i1 << 22) | (i2 << 21) | (_10BIT(encoding_high) << 11) | _11BIT(encoding_low);
                    instr.imm  = arm_functions::sign_extend(instr.imm << 1, 25);

                    if (in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }

                    instr.operand_type = OperandType::I;
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b101 || op1 == 0b111)
                {
                    // Branch with Link BL on page A7 - 213
                    instr.name = Mnemonic::BL;
                    u32 s      = _1BIT(encoding_high >> 10);
                    u32 i1     = !(_1BIT(encoding_low >> 13) ^ s);
                    u32 i2     = !(_1BIT(encoding_low >> 11) ^ s);
                    instr.imm  = (s << 23) | (i1 << 22) | (i2 << 21) | (_10BIT(encoding_high) << 11) | _11BIT(encoding_low);
                    instr.imm  = arm_functions::sign_extend(instr.imm << 1, 25);

                    if (in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }

                    instr.operand_type = OperandType::I;
                    return {ReturnCode::OK, instr};
                }
            }
        }
        else if (op1 == 0b11)
        {
            if (_3BIT(op2 >> 4) == 0 && _1BIT(op2) == 0)    // 0b000xxx0
            {
                // Store single data item on page A5 - 149

                op1 = _3BIT(encoding_high >> 5);
                op2 = _1BIT(encoding_low >> 11);

                if (op1 == 0b100 || (op1 == 0b000 && op2 == 1))
                {
                    // Store Register Byte STRB (immediate) on page A7 - 389
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name = Mnemonic::STRB;
                    instr.Rn   = (Register)_4BIT(encoding_high);
                    instr.Rd   = (Register)_4BIT(encoding_low >> 12);

                    if (op1 == 0b000)    // 8bit immediate
                    {
                        if (_3BIT(encoding_low >> 8) == 0b110)
                        {
                            instr.name = Mnemonic::STRBT;
                        }
                        instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                        instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                        instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                        instr.imm         = _8BIT(encoding_low);
                        if (!instr.flags.index && !instr.flags.wback)
                        {
                            THROW_UNDEFINED;
                        }
                        if (instr.Rn == instr.Rd && instr.flags.wback)
                        {
                            THROW_UNPREDICTABLE;
                        }
                    }
                    else    // 12bit immediate
                    {
                        instr.imm         = _12BIT(encoding_low);
                        instr.flags.index = true;
                        instr.flags.add   = true;
                    }
                    instr.operand_type = OperandType::RRI;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b000 && op2 == 0)
                {
                    // Store Register Byte STRB (register) on page A7 - 391
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::STRB;
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::LSL;
                    instr.shift_amount = _2BIT(encoding_low >> 4);
                    instr.flags.index  = true;
                    instr.flags.add    = true;
                    instr.operand_type = OperandType::RRR;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is13or15(Rd) || is13or15(Rm))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b101 || (op1 == 0b001 && op2 == 1))
                {
                    // Store Register Halfword STRH (immediate) on page A7 - 397
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name = Mnemonic::STRH;
                    instr.Rn   = (Register)_4BIT(encoding_high);
                    instr.Rd   = (Register)_4BIT(encoding_low >> 12);

                    if (op1 == 0b001)    // 8bit immediate
                    {
                        if (_3BIT(encoding_low >> 8) == 0b110)
                        {
                            instr.name = Mnemonic::STRHT;
                        }
                        instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                        instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                        instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                        instr.imm         = _8BIT(encoding_low);
                        if (!instr.flags.index && !instr.flags.wback)
                        {
                            THROW_UNDEFINED;
                        }
                        if (instr.Rn == instr.Rd && instr.flags.wback)
                        {
                            THROW_UNPREDICTABLE;
                        }
                    }
                    else    // 12bit immediate
                    {
                        instr.imm         = _12BIT(encoding_low);
                        instr.flags.index = true;
                        instr.flags.add   = true;
                    }
                    instr.operand_type = OperandType::RRI;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is13or15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b001 && op2 == 0)
                {
                    // Store Register Halfword STRH (register) on page A7 - 399
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::STRH;
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::LSL;
                    instr.shift_amount = _2BIT(encoding_low >> 4);
                    instr.flags.index  = true;
                    instr.flags.add    = true;
                    instr.operand_type = OperandType::RRR;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is13or15(Rd) || is13or15(Rm))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b110 || (op1 == 0b010 && op2 == 1))
                {
                    // Store Register STR (immediate) on page A7 - 386
                    REQUIRE_ARCH(Architecture::ARMv7M);

                    if (_4BIT(encoding_high) == 0b1101 && _3BIT(encoding_low >> 8) == 0b101 && _8BIT(encoding_low) == 0b100)    // PUSH single register
                    {
                        instr.name                    = Mnemonic::PUSH;
                        u8 t                          = encoding_low >> 12;
                        instr.imm                     = 1 << t;
                        instr.flags.unaligned_allowed = true;
                        if (t == 13 || t == 15)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        instr.operand_type = OperandType::I;
                        return {ReturnCode::OK, instr};
                    }

                    instr.name = Mnemonic::STR;
                    instr.Rn   = (Register)_4BIT(encoding_high);
                    instr.Rd   = (Register)_4BIT(encoding_low >> 12);
                    if (op1 == 0b010)    // 8bit immediate
                    {
                        if (_3BIT(encoding_low >> 8) == 0b110)
                        {
                            instr.name = Mnemonic::STRT;
                        }
                        instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                        instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                        instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                        instr.imm         = _8BIT(encoding_low);
                        if (!instr.flags.index && !instr.flags.wback)
                        {
                            THROW_UNDEFINED;
                        }
                        if (instr.Rd == instr.Rn && instr.flags.wback)
                        {
                            THROW_UNPREDICTABLE;
                        }
                    }
                    else    // 12bit immediate
                    {
                        instr.imm         = _12BIT(encoding_low);
                        instr.flags.index = true;
                        instr.flags.add   = true;
                    }
                    instr.operand_type = OperandType::RRI;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is15(Rd))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b010 && op2 == 0)
                {
                    // Store Register STR (register) on page A7 - 388
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::STR;
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::LSL;
                    instr.shift_amount = _2BIT(encoding_low >> 4);
                    instr.flags.index  = true;
                    instr.flags.add    = true;
                    instr.operand_type = OperandType::RRR;
                    if (instr.Rn == 0b1111)
                    {
                        THROW_UNDEFINED;
                    }
                    if (is15(Rd) || is13or15(Rm))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
            }
            else if (_2BIT(op2 >> 5) == 0 && _3BIT(op2) == 0b001)    // 0b00xx001
            {
                // Load byte, memory hints on page A5 - 148

                op1   = _2BIT(encoding_high >> 7);
                op2   = _6BIT(encoding_low >> 6);
                u8 Rn = _4BIT(encoding_high);
                u8 Rt = _4BIT(encoding_low >> 12);

                if (Rt != 0b1111)
                {
                    if (Rn == 0b1111)
                    {
                        if (op1 >> 1 == 0)
                        {
                            // Load Register Byte LDRB (literal) on page A7 - 254
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.imm          = _12BIT(encoding_low);
                            instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                            instr.operand_type = OperandType::RI;
                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Load Register Signed Byte LDRSB (literal) on page A7 - 272
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRSB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.imm          = _12BIT(encoding_low);
                            instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                            instr.operand_type = OperandType::RI;
                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else
                    {
                        if (op1 == 0b01 || (op1 == 0b00 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b100)))
                        {
                            // Load Register Byte LDRB (immediate) on page A7 - 252
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRI;

                            if (op1 == 0b01)    // 12 bit
                            {
                                instr.imm         = _12BIT(encoding_low);
                                instr.flags.index = true;
                                instr.flags.add   = true;
                            }
                            else    // 8 bit
                            {
                                instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                                instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                                instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                                instr.imm         = _8BIT(encoding_low);
                                if (!instr.flags.index && !instr.flags.wback)
                                {
                                    THROW_UNDEFINED;
                                }
                                if (instr.Rn == instr.Rd && instr.flags.wback)
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                if (is15(Rd) && _3BIT(encoding_low >> 8) == 0b011)
                                {
                                    THROW_UNPREDICTABLE;
                                }
                            }

                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b00)
                        {
                            if (op2 >> 2 == 0b1110)
                            {
                                // Load Register Byte Unprivileged LDRBT on page A7 - 256
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRBT;
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.flags.add    = true;
                                instr.imm          = _8BIT(encoding_low);
                                instr.operand_type = OperandType::RRI;
                                if (is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0)
                            {
                                // Load Register Byte LDRB (register) on page A7 - 255
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRB;
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.shift_type   = ShiftType::LSL;
                                instr.shift_amount = _2BIT(encoding_low >> 4);
                                instr.flags.index  = true;
                                instr.flags.add    = true;
                                instr.operand_type = OperandType::RRR;
                                if (is13(Rd) || is13or15(Rm))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                        else if (op1 == 0b11 || (op1 == 0b10 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b100)))
                        {
                            // Load Register Signed Byte LDRSB (immediate) on page A7 - 270
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRSB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRI;

                            if (op1 == 0b11)    // 12 bit
                            {
                                instr.imm         = _12BIT(encoding_low);
                                instr.flags.index = true;
                                instr.flags.add   = true;
                            }
                            else    // 8 bit
                            {
                                instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                                instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                                instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                                instr.imm         = _8BIT(encoding_low);
                                if (!instr.flags.index && !instr.flags.wback)
                                {
                                    THROW_UNDEFINED;
                                }
                                if ((is15(Rd) || instr.Rn == instr.Rd) && instr.flags.wback)
                                {
                                    THROW_UNPREDICTABLE;
                                }
                            }

                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b10)
                        {
                            if (op2 >> 2 == 0b1110)
                            {
                                // Load Register Signed Byte Unprivileged LDRSBT on page A7 - 274
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRSBT;
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.imm          = _8BIT(encoding_low);
                                instr.operand_type = OperandType::RRI;
                                instr.flags.add    = true;
                                if (is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 == 0)
                            {
                                // Load Register Signed Byte LDRSB (register) on page A7 - 273
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRSB;
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.shift_type   = ShiftType::LSL;
                                instr.shift_amount = _2BIT(encoding_low >> 4);
                                instr.flags.index  = true;
                                instr.flags.add    = true;
                                instr.operand_type = OperandType::RRR;
                                if (is13(Rd) || is13or15(Rm))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                    }
                }
                else
                {
                    if (Rn == 0b1111 && op1 >> 1 == 0)
                    {
                        // Preload Data PLD (literal) on page A7 - 314
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::PLD;
                        instr.imm          = _12BIT(encoding_low);
                        instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                        instr.operand_type = OperandType::I;
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        if (((op1 == 0 && op2 >> 2 == 0b1100) || op1 == 0b01) && Rn != 0b1111)
                        {
                            // Preload Data PLD (immediate) on page A7 - 313
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name = Mnemonic::PLD;
                            instr.Rn   = (Register)_4BIT(encoding_high);

                            if (op1 == 0b01)
                            {
                                instr.imm       = _12BIT(encoding_low);
                                instr.flags.add = true;
                            }
                            else
                            {
                                instr.imm = _8BIT(encoding_low);
                            }
                            instr.operand_type = OperandType::RI;
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0 && op2 == 0 && Rn != 0b1111)
                        {
                            // Preload Data PLD (register) on page A7 - 315
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::PLD;
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::LSL;
                            instr.shift_amount = _2BIT(encoding_low >> 4);
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b110) && Rn != 0b1111)
                        {
                            // UNPREDICTABLE
                            THROW_UNPREDICTABLE;
                        }
                        else if ((op1 >> 1 == 1 && Rn == 0b1111) || (op1 == 0b11 && Rn != 0b1111) || (op1 == 0b10 && op2 >> 2 == 0b1100 && Rn != 0b1111))
                        {
                            // Preload Instruction PLI (immediate, literal) on page A7 - 316
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name = Mnemonic::PLI;
                            instr.Rn   = (Register)_4BIT(encoding_high);
                            instr.imm  = _12BIT(encoding_low);
                            if (op1 == 0b10 && op2 >> 2 == 0b1100 && Rn != 0b1111)    // 8bit
                            {
                                instr.imm = _8BIT(encoding_low);
                            }
                            instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                            instr.operand_type = OperandType::RI;
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b10 && Rn != 0b1111)
                        {
                            if (op2 == 0)
                            {
                                // Preload Instruction PLI (register) on page A7 - 318
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::PLI;
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.shift_type   = ShiftType::LSL;
                                instr.shift_amount = _2BIT(encoding_low >> 4);
                                instr.operand_type = OperandType::RR;
                                if (is13or15(Rm))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b110))
                            {
                                // UNPREDICTABLE
                                THROW_UNPREDICTABLE;
                            }
                        }
                    }
                }
            }
            else if (_2BIT(op2 >> 5) == 0 && _3BIT(op2) == 0b011)    // 0b00xx011
            {
                // Load halfword, memory hints on page A5 - 147

                op1   = _2BIT(encoding_high >> 7);
                op2   = _6BIT(encoding_low >> 6);
                u8 Rn = _4BIT(encoding_high);
                u8 Rt = _4BIT(encoding_low >> 12);

                if (Rt != 0b1111)
                {
                    if (Rn == 0b1111)
                    {
                        if (op1 >> 1 == 0)
                        {
                            // Load Register Halfword LDRH (literal) on page A7 - 266
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.imm          = _12BIT(encoding_low);
                            instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                            instr.operand_type = OperandType::RI;
                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Load Register Signed Halfword LDRSH (literal) on page A7 - 277
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRSH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.imm          = _12BIT(encoding_low);
                            instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                            instr.operand_type = OperandType::RI;
                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else
                    {
                        if (op1 == 0b01 || (op1 == 0b00 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b100)))
                        {
                            // Load Register Halfword LDRH (immediate) on page A7 - 264
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRI;

                            if (op1 == 0b01)    // 12 bit
                            {
                                instr.imm         = _12BIT(encoding_low);
                                instr.flags.index = true;
                                instr.flags.add   = true;
                            }
                            else    // 8 bit
                            {
                                instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                                instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                                instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                                instr.imm         = _8BIT(encoding_low);
                                if (!instr.flags.index && !instr.flags.wback)
                                {
                                    THROW_UNDEFINED;
                                }
                                if ((is15(Rd) || instr.Rn == instr.Rd) && instr.flags.wback)
                                {
                                    THROW_UNPREDICTABLE;
                                }
                            }

                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b00)
                        {
                            if (op2 == 0)
                            {
                                // Load Register Halfword LDRH (register) on page A7 - 267
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRH;
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.shift_type   = ShiftType::LSL;
                                instr.shift_amount = _2BIT(encoding_low >> 4);
                                instr.flags.index  = true;
                                instr.flags.add    = true;
                                instr.operand_type = OperandType::RRR;
                                if (is13(Rd) || is13or15(Rm))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 >> 2 == 0b1110)
                            {
                                // Load Register Halfword Unprivileged LDRHT on page A7 - 269
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRHT;
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.flags.add    = true;
                                instr.imm          = _8BIT(encoding_low);
                                instr.operand_type = OperandType::RRI;
                                if (is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                        else if (op1 == 0b11 || (op1 == 0b10 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b100)))
                        {
                            // Load Register Signed Halfword LDRSH (immediate) on page A7 - 275
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRSH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.operand_type = OperandType::RRI;

                            if (op1 == 0b11)    // 12 bit
                            {
                                instr.imm         = _12BIT(encoding_low);
                                instr.flags.index = true;
                                instr.flags.add   = true;
                            }
                            else    // 8 bit
                            {
                                instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                                instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                                instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                                instr.imm         = _8BIT(encoding_low);
                                if (!instr.flags.index && !instr.flags.wback)
                                {
                                    THROW_UNDEFINED;
                                }
                                if ((is15(Rd) || instr.Rn == instr.Rd) && instr.flags.wback)
                                {
                                    THROW_UNPREDICTABLE;
                                }
                            }

                            if (is13(Rd))
                            {
                                THROW_UNPREDICTABLE
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b10)
                        {
                            if (op2 == 0)
                            {
                                // Load Register Signed Halfword LDRSH (register) on page A7 - 278
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRSH;
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rm           = (Register)_4BIT(encoding_low);
                                instr.shift_type   = ShiftType::LSL;
                                instr.shift_amount = _2BIT(encoding_low >> 4);
                                instr.flags.index  = true;
                                instr.flags.add    = true;
                                instr.operand_type = OperandType::RRR;
                                if (is13(Rd) || is13or15(Rm))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                            else if (op2 >> 2 == 0b1110)
                            {
                                // Load Register Signed Halfword Unprivileged LDRSHT on page A7 - 280
                                REQUIRE_ARCH(Architecture::ARMv7M);
                                instr.name         = Mnemonic::LDRSHT;
                                instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                                instr.Rn           = (Register)_4BIT(encoding_high);
                                instr.imm          = _8BIT(encoding_low);
                                instr.operand_type = OperandType::RRI;
                                instr.flags.add    = true;
                                if (is13or15(Rd))
                                {
                                    THROW_UNPREDICTABLE;
                                }
                                return {ReturnCode::OK, instr};
                            }
                        }
                    }
                }
                else
                {
                    if (Rn != 0b1111 && ((op1 == 0 && op2 == 0) || (op1 == 0 && op2 >> 2 == 0b1100) || op1 == 0b01))
                    {
                        // Unallocated memory hint, treat as NOP
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name = Mnemonic::NOP;
                        return {ReturnCode::OK, instr};
                    }
                    else if ((Rn != 0b1111 && op1 == 0 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b110)) || (op1 >> 1 == 0 && Rn == 0b1111))
                    {
                        // UNPREDICTABLE
                        THROW_UNPREDICTABLE;
                    }
                    else if ((Rn != 0b1111 && op1 == 0b10 && (op2 == 0 || op2 >> 2 == 0b1110)) || (Rn == 0b1111 && op1 >> 1 == 1))
                    {
                        // Unallocated memory hint, treat as NOP
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name = Mnemonic::NOP;
                        return {ReturnCode::OK, instr};
                    }
                    else if (op1 == 0b10 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b110))
                    {
                        // UNPREDICTABLE
                        THROW_UNPREDICTABLE;
                    }
                    else if (op1 == 0b11)
                    {
                        // Unallocated memory hint, treat as NOP
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name = Mnemonic::NOP;
                        return {ReturnCode::OK, instr};
                    }
                }
            }
            else if (_2BIT(op2 >> 5) == 0 && _3BIT(op2) == 0b101)    // 0b00xx101
            {
                // Load word on page A5 - 146

                op1   = _2BIT(encoding_high >> 7);
                op2   = _6BIT(encoding_low >> 6);
                u8 Rn = _4BIT(encoding_high);

                if (Rn != 0b1111)
                {
                    if (op1 == 0b01 || (op1 == 0b00 && op2 >> 5 == 1 && (_1BIT(op2 >> 2) == 1 || _3BIT(op2 >> 2) == 0b100)))
                    {
                        // Load Register LDR (immediate) on page A7 - 246
                        REQUIRE_ARCH(Architecture::ARMv7M);

                        if (_4BIT(encoding_high) == 0b1101 && _3BIT(encoding_low >> 8) == 0b011 && _8BIT(encoding_low) == 0b100)    // POP single register
                        {
                            instr.name                    = Mnemonic::POP;
                            u8 t                          = encoding_low >> 12;
                            instr.imm                     = 1 << t;
                            instr.flags.unaligned_allowed = true;
                            instr.operand_type            = OperandType::I;
                            if (t == 13 || (t == 15 && in_IT_block && !last_in_IT_block))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }

                        instr.name         = Mnemonic::LDR;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.operand_type = OperandType::RRI;

                        if (op1 == 0b01)    // 12 bit
                        {
                            instr.imm         = _12BIT(encoding_low);
                            instr.flags.index = true;
                            instr.flags.add   = true;
                        }
                        else    // 8 bit
                        {
                            instr.flags.index = _1BIT(encoding_low >> 10) == 1;
                            instr.flags.add   = _1BIT(encoding_low >> 9) == 1;
                            instr.flags.wback = _1BIT(encoding_low >> 8) == 1;
                            instr.imm         = _8BIT(encoding_low);
                            if (!instr.flags.index && !instr.flags.wback)
                            {
                                THROW_UNDEFINED;
                            }
                            if (instr.Rn == instr.Rd && instr.flags.wback)
                            {
                                THROW_UNPREDICTABLE;
                            }
                        }

                        if (is15(Rd) && in_IT_block && !last_in_IT_block)
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op1 == 0)
                    {
                        if (op2 >> 2 == 0b1110)
                        {
                            // Load Register Unprivileged LDRT on page A7 - 281
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDRT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.flags.add    = true;
                            instr.imm          = _8BIT(encoding_low);
                            instr.operand_type = OperandType::RRI;
                            if (is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0)
                        {
                            // Load Register LDR (register) on page A7 - 250
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::LDR;
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::LSL;
                            instr.shift_amount = _2BIT(encoding_low >> 4);
                            instr.operand_type = OperandType::RRR;
                            if ((is15(Rd) && in_IT_block && !last_in_IT_block) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                }
                else if (op1 >> 1 == 0)
                {
                    // Load Register LDR (literal) on page A7 - 248
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::LDR;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 12);
                    instr.imm          = _12BIT(encoding_low);
                    instr.flags.add    = _1BIT(encoding_high >> 7) == 1;
                    instr.operand_type = OperandType::RI;
                    if (is15(Rd) && in_IT_block && !last_in_IT_block)
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
            }
            else if (_2BIT(op2 >> 5) == 0 && _3BIT(op2) == 0b111)    // 0b00xx111
            {
                // UNDEFINED
                THROW_UNDEFINED;
            }
            else if (_3BIT(op2 >> 4) == 0b010)    // 0b010xxxx
            {
                // Data processing (register) on page A5 - 152

                op1   = _4BIT(encoding_high >> 4);
                op2   = _4BIT(encoding_low >> 4);
                u8 Rn = _4BIT(encoding_high);

                if (op2 == 0 && op1 >> 1 == 0b000)
                {
                    // Logical Shift Left LSL (register) on page A7 - 283 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::LSL;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::LSL;
                    instr.operand_type = OperandType::RRR;
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op2 == 0 && op1 >> 1 == 0b001)
                {
                    // Logical Shift Right LSR (register) on page A7 - 285 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::LSR;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::LSR;
                    instr.operand_type = OperandType::RRR;
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op2 == 0 && op1 >> 1 == 0b010)
                {
                    // Arithmetic Shift Right ASR (register) on page A7 - 204 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::ASR;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::ASR;
                    instr.operand_type = OperandType::RRR;
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op2 == 0 && op1 >> 1 == 0b011)
                {
                    // Rotate Right ROR (register) on page A7 - 339 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::ROR;
                    instr.flags.S      = _1BIT(encoding_high >> 4);
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.shift_type   = ShiftType::ROR;
                    instr.operand_type = OperandType::RRR;
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 >> 3 == 1 && op2 >> 2 == 0b00)
                {
                    // Parallel addition and subtraction, signed - on page A5 - 152
                    op1 = _3BIT(encoding_high >> 4);
                    op2 = _2BIT(encoding_low >> 4);

                    if (op2 == 0)
                    {
                        if (op1 == 0b001)
                        {
                            // Add 16 - bit SADD16 on page A7 - 343 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b010)
                        {
                            // Add, Subtract SASX on page A7 - 345 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SASX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b110)
                        {
                            // Subtract, Add SSAX on page A7 - 377 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SSAX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b101)
                        {
                            // Subtract 16 - bit SSUB16 on page A7 - 379 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SSUB16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b000)
                        {
                            // Add 8 - bit SADD8 on page A7 - 344 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SADD8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b100)
                        {
                            // Subtract 8 - bit SSUB8 on page A7 - 380 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SSUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b01)
                    {
                        if (op1 == 0b001)
                        {
                            // Saturating Add 16 - bit QADD16 on page A7 - 325 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};

                        }
                        else if (op1 == 0b010)
                        {
                            // Saturating Add, Subtract QASX on page A7 - 327 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QASX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b110)
                        {
                            // Saturating Subtract, Add QSAX on page A7 - 330 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QSAX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b101)
                        {
                            // Saturating Subtract 16 - bit QSUB16 on page A7 - 332 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::QSUB16;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b000)
                        {
                            // Saturating Add 8 - bit QADD8 on page A7 - 326 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QADD8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b100)
                        {
                            // Saturating Subtract 8 - bit QSUB8 on page A7 - 333 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QSUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b10)
                    {
                        if (op1 == 0b001)
                        {
                            // Halving Add 16 - bit SHADD16 on page A7 - 353 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b010)
                        {
                            // Halving Add, Subtract SHASX on page A7 - 355 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHASX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b110)
                        {
                            // Halving Subtract, Add SHSAX on page A7 - 356 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHSAX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b101)
                        {
                            // Halving Subtract 16 - bit SHSUB16 on page A7 - 357 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHSUB16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b000)
                        {
                            // Halving Add 8 - bit SHADD8 on page A7 - 354 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHADD8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b100)
                        {
                            // Halving Subtract 8 - bit SHSUB8 on page A7 - 358 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::SHSUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                }
                else if (op1 >> 3 == 1 && op2 >> 2 == 0b01)
                {
                    // Parallel addition and subtraction, unsigned on page A5 - 153 -

                    op1 = _3BIT(encoding_high >> 4);
                    op2 = _2BIT(encoding_low >> 4);
                    if (op2 == 0b00)
                    {
                        if (op1 == 0b001)
                        {
                            // Add 16 - bit UADD16 on page A7 - 421 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b010)
                        {
                            // Add, Subtract UASX on page A7 - 423 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UASX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b110)
                        {
                            // Subtract, Add USAX on page A7 - 446 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::USAX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b101)
                        {
                            // Subtract 16 - bit USUB16 on page A7 - 447 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::USUB16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) )
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b000)
                        {
                            // Add 8 - bit UADD8 on page A7 - 422 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UADD8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) )
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b100)
                        {
                            // Subtract 8 - bit USUB8 on page A7 - 448 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::USUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b01)
                    {
                        if (op1 == 0b001)
                        {
                            // Saturating Add 16 - bit UQADD16 on page A7 - 436 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b010)
                        {
                            // Saturating Add, Subtract UQASX on page A7 - 438 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQASX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b110)
                        {
                            // Saturating Subtract, Add UQSAX on page A7 - 439 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQSAX;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b101)
                        {
                            // Saturating Subtract 16 - bit UQSUB16 on page A7 - 440 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQSUB16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
    
                        }
                        else if (op1 == 0b000)
                        {
                            // Saturating Add 8 - bit UQADD8 on page A7 - 437 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQADD8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b100)
                        {
                            // Saturating Subtract 8 - bit UQSUB8 on page A7 - 441 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UQSUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b10)
                    {
                        if (op1 == 0b001)
                        {
                            // Halving Add 16 - bit UHADD16 on page A7 - 427 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UHADD16;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op1 == 0b010)
                        {
                            // Halving Add, Subtract UHASX on page A7 - 429 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                        }
                        else if (op1 == 0b110)
                        {
                            // Halving Subtract, Add UHSAX on page A7 - 430 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                        }
                        else if (op1 == 0b101)
                        {
                            // Halving Subtract 16 - bit UHSUB16 on page A7 - 431 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                        }
                        else if (op1 == 0b000)
                        {
                            // Halving Add 8 - bit UHADD8 on page A7 - 428 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                        }
                        else if (op1 == 0b100)
                        {
                            // Halving Subtract 8 - bit UHSUB8 on page A7 - 432 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::UHSUB8;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                }
                else if (op1 >> 2 == 0b10 && op2 >> 2 == 0b10)
                {
                    // Miscellaneous operations on page A5 - 155 -

                    op1 = _2BIT(encoding_high >> 4);
                    op2 = _2BIT(encoding_low >> 4);

                    if (op1 == 0b00)
                    {
                        if (op2 == 0b00)
                        {
                            // Saturating Add QADD on page A7 - 324 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::QADD;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b01)
                        {
                            // Saturating Double and Add QDADD on page A7 - 328 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QDADD;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b10)
                        {
                            // Saturating Subtract QSUB on page A7 - 331 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QSUB;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b11)
                        {
                            // Saturating Double and Subtract QDSUB on page A7 - 329 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name              = Mnemonic::QDSUB;
                            instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRR;
                            if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b01)
                    {
                        if (op2 == 0b00)
                        {
                            // Byte - Reverse Word REV on page A7 - 335 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::REV;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm) || is13or15(Rd) || _4BIT(encoding_high) != _4BIT(encoding_low))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b01)
                        {
                            // Byte - Reverse Packed Halfword REV16 on page A7 - 336 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::REV16;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm) || is13or15(Rd) || _4BIT(encoding_high) != _4BIT(encoding_low))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b10)
                        {
                            // Reverse Bits RBIT on page A7 - 334 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::RBIT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm) || is13or15(Rd) || _4BIT(encoding_high) != _4BIT(encoding_low))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if (op2 == 0b11)
                        {
                            // Byte - Reverse Signed Halfword REVSH on page A7 - 337 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::REVSH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm) || is13or15(Rd) || _4BIT(encoding_high) != _4BIT(encoding_low))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b10 && op2 == 0b00)
                    {
                        // Select Bytes SEL on page A7 - 351 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        instr.name         = Mnemonic::SEL;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.Rm           = (Register)_4BIT(encoding_low);
                        instr.operand_type = OperandType::RRR;
                        if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op1 == 0b11 && op2 == 0b00)
                    {
                        // Count Leading Zeros CLZ on page A7 - 220 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::CLZ;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rm           = (Register)_4BIT(encoding_low);
                        instr.operand_type = OperandType::RR;
                        if (is13or15(Rm) || is13or15(Rd) || _4BIT(encoding_high) != _4BIT(encoding_low))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op2 >> 3 == 1)
                {
                    if (op1 == 0b0000)
                    {
                        if (Rn != 0b1111)
                        {
                            // Signed Extend and Add Halfword SXTAH on page A7 - 412 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::SXTAH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Signed Extend Halfword SXTH on page A7 - 415 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::SXTH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RR;
                            if (_1BIT(encoding_low >> 6) != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b0001)
                    {
                        if (Rn != 0b1111)
                        {
                            // Unsigned Extend and Add Halfword UXTAH on page A7 - 451 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::UXTAH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Unsigned Extend Halfword UXTH on page A7 - 454 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::UXTH;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RR;
                            if (_1BIT(encoding_low >> 6) != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b0010)
                    {
                        if (Rn != 0b1111)
                        {
                            // Signed Extend and Add Byte 16 SXTAB16 on page A7 - 411 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::SXTAB16;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Signed Extend Byte 16 SXTB16 on page A7 - 414 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                        }
                    }
                    else if (op1 == 0b0011)
                    {
                        if (Rn != 0b1111)
                        {
                            // Unsigned Extend and Add Byte 16 UXTAB16 on page A7 - 450 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::UXTAB16;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Unsigned Extend Byte 16 UXTB16 on page A7 - 453 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::UXTB16;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RR;
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b0100)
                    {
                        if (Rn != 0b1111)
                        {
                            // Signed Extend and Add Byte SXTAB on page A7 - 410 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::SXTAB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Signed Extend Byte SXTB on page A7 - 413 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::SXTB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RR;
                            if (_1BIT(encoding_low >> 6) != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op1 == 0b0101)
                    {
                        if (Rn != 0b1111)
                        {
                            // Unsigned Extend and Add Byte UXTAB on page A7 - 449 v7E-M
                            REQUIRE_ARCH(Architecture::ARMv7EM);
                            instr.name         = Mnemonic::UXTAB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Unsigned Extend Byte UXTB on page A7 - 452 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::UXTB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.shift_type   = ShiftType::ROR;
                            instr.shift_amount = _2BIT(encoding_low >> 4) << 3;
                            instr.operand_type = OperandType::RR;
                            if (_1BIT(encoding_low >> 6) != 0)
                            {
                                THROW_UNEXPECTED;
                            }
                            if (is13or15(Rm) || is13or15(Rd))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                }
            }
            else if (_4BIT(op2 >> 3) == 0b0110)    // 0b0110xxx
            {
                // Multiply, multiply accumulate, and absolute difference on page A5 - 156

                op1   = _3BIT(encoding_high >> 4);
                op2   = _2BIT(encoding_low >> 4);
                u8 Ra = encoding_low >> 12;

                if (op1 == 0b000)
                {
                    if (op2 == 0b00)
                    {
                        if (Ra != 0b1111)
                        {
                            // Multiply Accumulate MLA on page A7 - 289 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::MLA;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                            instr.operand_type = OperandType::RRRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn) || is13(Ra))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else
                        {
                            // Multiply MUL on page A7 - 302 All
                            REQUIRE_ARCH(Architecture::ARMv7M);
                            instr.name         = Mnemonic::MUL;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RRR;
                            if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 == 0b01)
                    {
                        // Multiply and Subtract MLS on page A7 - 290 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::MLS;
                        instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.Rm           = (Register)_4BIT(encoding_low);
                        instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type = OperandType::RRRR;
                        if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn) || is13or15(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b001)
                {
                    if (Ra != 0b1111)
                    {
                        // Signed Multiply Accumulate, Halfwords SMLABB, SMLABT, SMLATB, SMLATT on page A7 - 359 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        uint8_t N = _1BIT(encoding_low >> 4);
                        uint8_t M = _1BIT(encoding_low >> 5);

                        if((N == 0) && (M == 0)){
                            instr.name         = Mnemonic::SMLABB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);  
                            instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                            instr.operand_type = OperandType::RRRR;   
                        }
                        else if((N == 0) && (M == 1)){
                            instr.name         = Mnemonic::SMLABT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                            instr.operand_type = OperandType::RRRR;
                        }
                        else if((N == 1) && (M == 0)){
                            instr.name         = Mnemonic::SMLATB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low); 
                            instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                            instr.operand_type = OperandType::RRRR;
                        }
                        else{ // N == 1 && M == 1
                            instr.name         = Mnemonic::SMLATT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.Ra           = (Register)_4BIT(encoding_low >> 12);
                            instr.operand_type = OperandType::RRRR;
                        }

                        if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                    }
                    else
                    {
                        // Signed Multiply, Halfwords SMULBB, SMULBT, SMULTB, SMULTT on page A7 - 371 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        uint8_t N = _1BIT(encoding_low >> 4);
                        uint8_t M = _1BIT(encoding_low >> 5);

                        if((N == 0) && (M == 0)){
                            instr.name         = Mnemonic::SMULBB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);  
                            instr.operand_type = OperandType::RRR;   
                        }
                        else if((N == 0) && (M == 1)){
                            instr.name         = Mnemonic::SMULBT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RRR;
                        }
                        else if((N == 1) && (M == 0)){
                            instr.name         = Mnemonic::SMULTB;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low); 
                            instr.operand_type = OperandType::RRR;
                        }
                        else{ // N == 1 && M == 1
                            instr.name         = Mnemonic::SMULTT;
                            instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn           = (Register)_4BIT(encoding_high);
                            instr.Rm           = (Register)_4BIT(encoding_low);
                            instr.operand_type = OperandType::RRR;
                        }

                        if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b010 && op2 >> 1 == 0)
                {
                    if (Ra != 0b1111)
                    {
                        // Signed Multiply Accumulate Dual SMLAD, SMLADX on page A7 - 360 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name              = Mnemonic::SMLADX;
                        }
                        else{
                            instr.name              = Mnemonic::SMLAD;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type      = OperandType::RRRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Signed Dual Multiply Add SMUAD, SMUADX on page A7 - 370 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMUADX;
                        }
                        else{
                            instr.name          = Mnemonic::SMUAD;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b011 && op2 >> 1 == 0)
                {
                    if (Ra != 0b1111)
                    {
                        // Signed Multiply Accumulate, Word by halfword SMLAWB, SMLAWT on page A7 - 364 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMLAWT;
                        }
                        else{
                            instr.name          = Mnemonic::SMLAWB;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type      = OperandType::RRRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Signed Multiply, Word by halfword SMULWB, SMULWT on page A7 - 373 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name              = Mnemonic::SMULWT;
                        }
                        else{
                            instr.name              = Mnemonic::SMULWB;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b100 && op2 >> 1 == 0)
                {
                    if (Ra != 0b1111)
                    {
                        // Signed Multiply Subtract Dual SMLSD, SMLSDX on page A7 - 365 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMLSDX;
                        }
                        else{
                            instr.name          = Mnemonic::SMLSD;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type      = OperandType::RRRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Signed Dual Multiply Subtract SMUSD, SMUSDX on page A7 - 374 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMUSDX;
                        }
                        else{
                            instr.name          = Mnemonic::SMUSD;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b101 && op2 >> 1 == 0)
                {
                    if (Ra != 0b1111)
                    {
                        // Signed Most Significant Word Multiply Accumulate SMMLA, SMMLAR on page A7 - 367 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMMLAR;
                        }
                        else{
                            instr.name          = Mnemonic::SMMLA;
                        }
                        instr.name              = Mnemonic::SADD16;
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type      = OperandType::RRRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Signed Most Significant Word Multiply SMMUL, SMMULR on page A7 - 369 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMMULR;
                        }
                        {
                            instr.name          = Mnemonic::SMMUL;
                        }
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b110 && op2 >> 1 == 0)
                {
                    // Signed Most Significant Word Multiply Subtract SMMLS, SMMLSR on page A7 - 368 v7E-M
                    REQUIRE_ARCH(Architecture::ARMv7EM);
                    if(_1BIT(encoding_low >> 4)){
                        instr.name          = Mnemonic::SMMLSR;
                    }
                    else{
                        instr.name          = Mnemonic::SMMLS;
                    }
                    instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                    instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    instr.operand_type      = OperandType::RRRR;
                    if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13or15(Ra))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b111 && op2 == 0)
                {
                    if (Ra == 0b1111)
                    {
                        //Unsigned Sum of Absolute Differences, Accumulate USADA8 on page A7 - 443 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        instr.name              = Mnemonic::USADA8;
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.Ra                = (Register)_4BIT(encoding_low >> 12);
                        instr.operand_type      = OperandType::RRRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm) || is13(Ra))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else
                    {
                        // Unsigned Sum of Absolute Differences USAD8 on page A7 - 442 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        instr.name              = Mnemonic::USAD8;
                        instr.Rd                = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(Rd) || is13or15(Rn) || is13or15(Rm))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
            }
            else if (_4BIT(op2 >> 3) == 0b0111)    // 0b0111xxx
            {
                // Long multiply, long multiply accumulate, and divide on page A5 - 156

                op1 = _3BIT(encoding_high >> 4);
                op2 = _4BIT(encoding_low >> 4);

                if (op1 == 0b000 && op2 == 0b0000)
                {
                    // Signed Multiply Long SMULL on page A7 - 372 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::SMULL;
                    instr.RdHi           = (Register)_4BIT(encoding_low >> 8);     // RdHi
                    instr.RdLo           = (Register)_4BIT(encoding_low >> 12);    // RdLo
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.operand_type = OperandType::RRRR;
                    if (is13or15(Rm) || is13or15(RdHi) || is13or15(Rn) || is13or15(RdLo) || (instr.RdHi == instr.RdLo))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b001 && op2 == 0b1111)
                {
                    // Signed Divide SDIV on page A7 - 350 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::SDIV;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.operand_type = OperandType::RRR;
                    if (_4BIT(encoding_low >> 12) != 0b1111)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b010 && op2 == 0b0000)
                {
                    // Unsigned Multiply Long UMULL on page A7 - 435 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::UMULL;
                    instr.RdHi         = (Register)_4BIT(encoding_low >> 8);     // RdHi
                    instr.RdLo         = (Register)_4BIT(encoding_low >> 12);    // RdLo
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.operand_type = OperandType::RRRR;
                    if (is13or15(Rm) || is13or15(RdHi) || is13or15(Rn) || is13or15(RdLo) || (instr.RdLo == instr.RdHi))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b011 && op2 == 0b1111)
                {
                    // Unsigned Divide UDIV on page A7 - 426 All
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    instr.name         = Mnemonic::UDIV;
                    instr.Rd           = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn           = (Register)_4BIT(encoding_high);
                    instr.Rm           = (Register)_4BIT(encoding_low);
                    instr.operand_type = OperandType::RRR;
                    if (_4BIT(encoding_low >> 12) != 0b1111)
                    {
                        THROW_UNEXPECTED;
                    }
                    if (is13or15(Rm) || is13or15(Rd) || is13or15(Rn))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b100)
                {
                    if (op2 == 0b0000)
                    {
                        // Signed Multiply Accumulate Long SMLAL on page A7 - 361 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::SMLAL;
                        instr.RdHi           = (Register)_4BIT(encoding_low >> 8);     // RdHi
                        instr.RdLo           = (Register)_4BIT(encoding_low >> 12);    // RdLo
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.Rm           = (Register)_4BIT(encoding_low);
                        instr.operand_type = OperandType::RRRR;
                        if (is13or15(Rm) || is13or15(RdHi) || is13or15(Rn) || is13or15(RdLo) || (instr.RdHi == instr.RdLo))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op2 >> 2 == 0b10)
                    {
                        // Signed Multiply Accumulate Long, Halfwords SMLALBB, SMLALBT, SMLALTB, SMLALTT on page A7 - 362 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        uint8_t N = _1BIT(encoding_low >> 5);
                        uint8_t M = _1BIT(encoding_low >> 4);
                        if((N == 0) && (M == 0)){
                            instr.name              = Mnemonic::SMLALBB;
                            instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                            instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRRR;
                            if (is13or15(RdHi) || is13or15(RdLo) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if((N == 0) && (M == 1)){
                            instr.name              = Mnemonic::SMLALBT;
                            instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                            instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRRR;
                            if (is13or15(RdHi) || is13or15(RdLo) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else if((N == 1) && (M == 0)){
                            instr.name              = Mnemonic::SMLALTB;
                            instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                            instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRRR;
                            if (is13or15(RdHi) || is13or15(RdLo) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                        else{ // N == 1 && M == 1
                            instr.name              = Mnemonic::SMLALTT;
                            instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                            instr.RdLo              = (Register)_4BIT(encoding_low >> 12);                            
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRRR;
                            if (is13or15(RdHi) || is13or15(RdLo) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                        }
                    }
                    else if (op2 >> 1 == 0b110)
                    {
                        // Signed Multiply Accumulate Long Dual SMLALD, SMLALDX on page A7 - 363 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        if(_1BIT(encoding_low >> 4)){
                            instr.name          = Mnemonic::SMLALDX;
                        }
                        else{
                            instr.name          = Mnemonic::SMLALD;
                        }
                            instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                            instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                            instr.Rn                = (Register)_4BIT(encoding_high);
                            instr.Rm                = (Register)_4BIT(encoding_low);
                            instr.operand_type      = OperandType::RRRR;
                            if (is13or15(Rn) || is13or15(Rm) || is13or15(RdHi) || is13or15(RdLo) ||(instr.RdHi == instr.RdLo))
                            {
                                THROW_UNPREDICTABLE;
                            }
                            return {ReturnCode::OK, instr};
                    }
                }
                else if (op1 == 0b101 && op2 >> 1 == 0b110)
                {
                    // Signed Multiply Subtract Long Dual SMLSLD, SMLSLDX on page A7 - 366 v7E-M
                    REQUIRE_ARCH(Architecture::ARMv7EM);
                    if(_1BIT(encoding_low >> 4)){
                        instr.name          = Mnemonic::SMLSLDX;
                    }
                    else{
                        instr.name          = Mnemonic::SMLSLD;
                    }
                    instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                    instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                    instr.Rn                = (Register)_4BIT(encoding_high);
                    instr.Rm                = (Register)_4BIT(encoding_low);
                    instr.operand_type      = OperandType::RRR;
                    if (is13or15(RdLo) || is13or15(RdHi) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                    {
                        THROW_UNPREDICTABLE;
                    }
                    return {ReturnCode::OK, instr};
                }
                else if (op1 == 0b110)
                {
                    if (op2 == 0b0000)
                    {
                        // Unsigned Multiply Accumulate Long UMLAL on page A7 - 434 All
                        REQUIRE_ARCH(Architecture::ARMv7M);
                        instr.name         = Mnemonic::UMLAL;
                        instr.RdHi           = (Register)_4BIT(encoding_low >> 8);     // RdHi
                        instr.RdLo           = (Register)_4BIT(encoding_low >> 12);    // RdLo
                        instr.Rn           = (Register)_4BIT(encoding_high);
                        instr.Rm           = (Register)_4BIT(encoding_low);
                        instr.operand_type = OperandType::RRRR;
                        if (is13or15(Rm) || is13or15(RdHi) || is13or15(Rn) || is13or15(RdLo) || (instr.RdHi == instr.RdLo))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                    else if (op2 == 0b0110)
                    {
                        // Unsigned Multiply Accumulate Accumulate Long UMAAL on page A7 - 433 v7E-M
                        REQUIRE_ARCH(Architecture::ARMv7EM);
                        instr.name              = Mnemonic::UMAAL;
                        instr.RdLo              = (Register)_4BIT(encoding_low >> 12);
                        instr.RdHi              = (Register)_4BIT(encoding_low >> 8);
                        instr.Rn                = (Register)_4BIT(encoding_high);
                        instr.Rm                = (Register)_4BIT(encoding_low);
                        instr.operand_type      = OperandType::RRR;
                        if (is13or15(RdLo) || is13or15(RdHi) || is13or15(Rn) || is13or15(Rm) || (instr.RdHi == instr.RdLo))
                        {
                            THROW_UNPREDICTABLE;
                        }
                        return {ReturnCode::OK, instr};
                    }
                }
            }
        }

        if ((op1 == 0b01 || op1 == 0b11) && _1BIT(op2 >> 6) == 1)    // 0b1xxxxxx
        {
            // Coprocessor instructions on page A5 - 158

            op1 = _6BIT(encoding_high >> 4);
            op  = _1BIT(encoding_low >> 4);

            if (_1BIT(op1 >> 5) == 0 && _1BIT(op1) == 0 && !(_3BIT(op1 >> 3) == 0 && _1BIT(op1 >> 1) == 0))
            {
                // Store Coprocessor STC, STC2 on page A7 - 381
                REQUIRE_ARCH(Architecture::ARMv7M);
                THROW_NOT_IMPLEMENTED;
            }
            else if (_1BIT(op1 >> 5) == 0 && _1BIT(op1) == 1 && !(_3BIT(op1 >> 3) == 0 && _1BIT(op1 >> 1) == 0))
            {
                // Load Coprocessor LDC, LDC2 (immediate) on page A7 - 238 and LDC, LDC2 (literal) on page A7 - 240
                REQUIRE_ARCH(Architecture::ARMv7M);
                THROW_NOT_IMPLEMENTED;
            }
            else if (op1 == 0b000100)
            {
                // Move to Coprocessor from two ARM core registers MCRR, MCRR2 on page A7 - 288
                REQUIRE_ARCH(Architecture::ARMv7M);
                THROW_NOT_IMPLEMENTED;
            }
            else if (op1 == 0b000101)
            {
                // Move to two ARM core registers from Coprocessor MRRC, MRRC2 on page A7 - 299
                REQUIRE_ARCH(Architecture::ARMv7M);
                THROW_NOT_IMPLEMENTED;
            }
            else if (_2BIT(op1 >> 4) == 0b10)
            {
                if (op == 0)
                {
                    // Coprocessor data operations CDP, CDP2 on page A7 - 217
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    THROW_NOT_IMPLEMENTED;
                }
                else if (_1BIT(op1) == 0 && op == 1)
                {
                    // Move to Coprocessor from ARM core register MCR, MCR2 on page A7 - 286
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    THROW_NOT_IMPLEMENTED;
                }
                else if (_1BIT(op1) == 1 && op == 1)
                {
                    // Move to ARM core register from Coprocessor MRC, MRC2 on page A7 - 297
                    REQUIRE_ARCH(Architecture::ARMv7M);
                    THROW_NOT_IMPLEMENTED;
                }
            }
        }
    }

    THROW_UNKNOWN;
}
