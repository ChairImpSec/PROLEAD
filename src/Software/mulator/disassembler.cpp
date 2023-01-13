#include "Software/mulator/disassembler.h"
#include "Software/mulator/arm_functions.h"

#include <cmath>
#include <iomanip>
#include <sstream>

using namespace mulator;

using OperandType = Instruction::OperandType;

Disassembler::Disassembler(Architecture arch) : m_decoder(arch)
{
    reset();
}

Disassembler::~Disassembler()
{
}

InstructionDecoder Disassembler::get_decoder() const
{
    return m_decoder;
}

Architecture Disassembler::get_architecture() const
{
    return m_decoder.get_architecture();
}

void Disassembler::reset()
{
    m_it_state = 0;
}

ReturnCode Disassembler::disassemble(u32 address, const u8* code, u32 code_size)
{
    m_mnemonic = "";
    m_operands = "";

    auto [status, instr] = m_decoder.decode_instruction(address, code, code_size, in_IT_block(), last_in_IT_block());
    m_instruction = instr;

    if (status == ReturnCode::OK)
    {
        status = disassemble(instr);

        if (status == ReturnCode::OK)
        {
            pop_IT_condition();
        }
    }

    return status;
}

Instruction Disassembler::get_instruction() const
{
    return m_instruction;
}

std::string Disassembler::get_mnemonic() const
{
    return m_mnemonic;
}

std::string Disassembler::get_operands() const
{
    return m_operands;
}

std::string Disassembler::get_string() const
{
    if (m_operands.empty())
    {
        return m_mnemonic;
    }
    return m_mnemonic + " " + m_operands;
}

///////////////////////////////////////////
/////////////  PRIVATE  ///////////////////
///////////////////////////////////////////

std::string Disassembler::format_name(const Instruction& instr) const
{
    std::stringstream stream;
    stream << instr.name;
    if (instr.flags.S)
    {
        stream << "s";
    }
    if (instr.condition != AL)
    {
        stream << instr.condition;
    }
    // if (instr.size == 4 && has_narrow_encoding(instr.name))
    // {
    //     stream << ".w";
    // }
    return stream.str();
}

std::string Disassembler::format_shift(const Instruction& instr) const
{
    std::stringstream stream;
    if (instr.shift_amount != 0)
    {
        stream << ", ";
        if (!is_shift_operation(instr.name))
        {
            stream << instr.shift_type << " ";
        }
        stream << "#" << instr.shift_amount;
    }
    return stream.str();
}

std::string Disassembler::format_immediate(u32 value, bool add_flag, bool decimal, bool print_signed) const
{
    std::stringstream stream;
    stream << "#";
    if (!add_flag)
    {
        stream << "-";
    }
    if (print_signed && value == 0xFFFFFFFF)
    {
        stream << "-1";
    }
    else
    {
        if (decimal || value < 10)
        {
            stream << std::dec;
        }
        else
        {
            stream << std::hex << "0x";
        }
        stream << (print_signed ? (i32)value : value);
    }
    return stream.str();
}

///////////////////////////////////////////
/////////////  INHERITED  /////////////////
///////////////////////////////////////////

bool Disassembler::in_IT_block() const
{
    if (m_decoder.get_architecture() == Architecture::ARMv6M)
    {
        return false;
    }

    return _4BIT(m_it_state) != 0;
}

bool Disassembler::last_in_IT_block() const
{
    if (m_decoder.get_architecture() == Architecture::ARMv6M)
    {
        return false;
    }
    return _4BIT(m_it_state) == 0b1000;
}

Condition Disassembler::pop_IT_condition()
{
    Condition c = (Condition)(m_it_state >> 4);
    if (_3BIT(m_it_state) == 0)
    {
        m_it_state = 0;
    }
    else
    {
        m_it_state = (m_it_state & 0xE0) | ((m_it_state << 1) & 0x1F);
    }
    return c;
}

bool Disassembler::is_load_operation(const Mnemonic& mnemonic) const
{
    return (mnemonic == Mnemonic::LDR || mnemonic == Mnemonic::LDRT || mnemonic == Mnemonic::LDRH || mnemonic == Mnemonic::LDRHT || mnemonic == Mnemonic::LDRB || mnemonic == Mnemonic::LDRBT || mnemonic == Mnemonic::LDRSH || mnemonic == Mnemonic::LDRSHT || mnemonic == Mnemonic::LDRSB || mnemonic == Mnemonic::LDRSBT || mnemonic == Mnemonic::LDRD || mnemonic == Mnemonic::LDREX || mnemonic == Mnemonic::LDREXB || mnemonic == Mnemonic::LDREXH || mnemonic == Mnemonic::PLD || mnemonic == Mnemonic::PLI);
}

bool Disassembler::is_store_operation(const Mnemonic& mnemonic) const
{
    return (mnemonic == Mnemonic::STR || mnemonic == Mnemonic::STRT || mnemonic == Mnemonic::STRH || mnemonic == Mnemonic::STRHT || mnemonic == Mnemonic::STRB || mnemonic == Mnemonic::STRBT || mnemonic == Mnemonic::STRD || mnemonic == Mnemonic::STREX || mnemonic == Mnemonic::STREXB || mnemonic == Mnemonic::STREXH);
}

bool Disassembler::is_shift_operation(const Mnemonic& mnemonic) const
{
    return (mnemonic == Mnemonic::ASR || mnemonic == Mnemonic::LSL || mnemonic == Mnemonic::LSR || mnemonic == Mnemonic::ROR);
}

ReturnCode Disassembler::disassemble(Instruction instr)
{
    u32 pc_value = instr.address + 4;
    m_instruction = instr;
    m_mnemonic = format_name(instr);
    m_operands = "";

    auto shift_extension = format_shift(instr);

    u32 max_regs = instr.get_register_count();

    u32 regs = 0;
    if ((u32)instr.Rn != 0xFFFFFFFF && (u32)instr.Rd != 0xFFFFFFFF && instr.Rn != instr.Rd && regs < max_regs)
    {
        m_operands = to_string(instr.Rd);
        regs++;
    }
    if ((u32)instr.Rn != 0xFFFFFFFF && regs < max_regs)
    {
        if (!m_operands.empty())
            m_operands += ", ";
        m_operands += to_string(instr.Rn);
        regs++;
    }
    if ((u32)instr.Rm != 0xFFFFFFFF && regs < max_regs)
    {
        if (!m_operands.empty())
            m_operands += ", ";
        m_operands += to_string(instr.Rm);
        regs++;
    }
    if ((u32)instr.Ra != 0xFFFFFFFF && regs < max_regs)
    {
        if (!m_operands.empty())
            m_operands += ", ";
        m_operands += to_string(instr.Ra);
        regs++;
    }

    if (regs < max_regs)
    {
        if (m_operands.empty())
        {
            m_operands = to_string(instr.Rd);
        }
        else
        {
            m_operands = to_string(instr.Rd) + ", " + m_operands;
        }
    }

    if (instr.uses_immediate() && (instr.name == Mnemonic::MOV || instr.name == Mnemonic::MVN || instr.name == Mnemonic::TST || instr.name == Mnemonic::TEQ || instr.name == Mnemonic::AND || instr.name == Mnemonic::BIC || instr.name == Mnemonic::EOR || instr.name == Mnemonic::ORR || instr.name == Mnemonic::ORN))
    {
        auto [b, v] = arm_functions::thumb_expand_imm(instr.imm);
        instr.imm = v;

        if (!b)
        {
            return ReturnCode::UNEXPECTED_ENCODING;
        }
    }

    if (instr.uses_immediate() && !is_shift_operation(instr.name))
    {
        m_operands += ", " + format_immediate(instr.imm);
        if (instr.get_immediate_count() > 1)
        {
            m_operands += ", " + format_immediate(instr.imm2);
        }
    }
    m_operands += shift_extension;

    if (instr.operand_type == Instruction::OperandType::NONE)
    {
        if (instr.name == Mnemonic::DMB || instr.name == Mnemonic::DSB || instr.name == Mnemonic::ISB)
        {
            m_operands = "sy";
        }
    }
    else if (instr.operand_type == Instruction::OperandType::I)
    {
        if (instr.name == Mnemonic::B || instr.name == Mnemonic::BL)
        {
            m_operands = format_immediate(instr.imm + pc_value, true, false, true);
        }
        else if (instr.name == Mnemonic::IT && m_decoder.get_architecture() >= Architecture::ARMv7M)
        {
            m_it_state = instr.imm;
            u8 mask = m_it_state & 0xF;
            u8 conditions = 3;
            while (_1BIT(mask) != 1)
            {
                mask >>= 1;
                conditions--;
            }
            mask >>= 1;

            u8 lsb = _1BIT(m_it_state >> 4);

            for (i32 i = conditions - 1; i >= 0; --i)
            {
                m_mnemonic += (_1BIT(mask >> i) == lsb) ? "t" : "e";
            }

            m_operands = to_string((Condition)(m_it_state >> 4));
        }
    } // end Instruction::OperandType::I
    else if (instr.operand_type == Instruction::OperandType::RRRR)
    {
        if (instr.name == Mnemonic::UMLAL || instr.name == Mnemonic::SMLAL || instr.name == Mnemonic::SMULL || instr.name == Mnemonic::UMULL)
        {
            m_operands = to_string(instr.Ra) + ", " + to_string(instr.Rd) + ", " + to_string(instr.Rn) + ", " + to_string(instr.Rm);
        }
    }

    if (is_load_operation(instr.name) || is_store_operation(instr.name))
    {
        bool add_flag = instr.flags.add;

        std::string base = "";
        std::string addr = "";
        u32 base_regs = 1;

        if (instr.name == Mnemonic::LDRD || instr.name == Mnemonic::STRD)
        {
            base_regs = 2;
        }

        if (instr.name == Mnemonic::PLD || instr.name == Mnemonic::PLI)
        {
            base_regs = 0;
        }

        if (instr.name == Mnemonic::LDREX || instr.name == Mnemonic::LDREXB || instr.name == Mnemonic::LDREXH)
        {
            add_flag = true;
        }

        if (instr.name == Mnemonic::STREX || instr.name == Mnemonic::STREXB || instr.name == Mnemonic::STREXH)
        {
            base_regs = 2;
            add_flag = true;
        }

        if (base_regs >= 1)
        {
            base = to_string(instr.Rd);
        }
        if (base_regs >= 2)
        {
            base += ", " + to_string(instr.Rm);
        }

        u32 addr_regs = instr.get_register_count() - base_regs;

        if (addr_regs == 0)
        {
            addr = "[" + to_string(Register::PC);
        }
        if (addr_regs >= 1)
        {
            addr = "[" + to_string(instr.Rn);
        }
        if (addr_regs >= 2)
        {
            addr += ", " + to_string(instr.Rm) + shift_extension;
        }

        std::string imm_str = "";
        if (instr.uses_immediate())
        {
            imm_str = ", " + format_immediate(instr.imm, add_flag);
        }

        if (instr.flags.index && instr.flags.wback)
        {
            addr += imm_str + "]!";
        }
        else if (!instr.flags.index && instr.flags.wback)
        {
            addr += "]" + imm_str;
        }
        else
        {
            if (imm_str != ", #0")
            {
                addr += imm_str;
            }
            addr += "]";
        }

        m_operands = base.empty() ? addr : base + ", " + addr;
    }

    if (instr.name == Mnemonic::PUSH || instr.name == Mnemonic::POP || instr.name == Mnemonic::LDM || instr.name == Mnemonic::LDMDB || instr.name == Mnemonic::STM || instr.name == Mnemonic::STMDB)
    {
        m_operands = "";
        if (instr.name == Mnemonic::LDM || instr.name == Mnemonic::LDMDB || instr.name == Mnemonic::STM || instr.name == Mnemonic::STMDB)
        {
            m_operands = to_string(instr.Rn) + (instr.flags.wback ? "!, " : ", ");
        }

        std::stringstream stream;
        stream << "{";
        u32 cnt = arm_functions::bit_count(instr.imm);
        for (u32 i = 0; i < 16; ++i)
        {
            if ((instr.imm >> i) & 1)
            {
                stream << to_string((Register)i);
                cnt--;
                if (cnt != 0)
                {
                    stream << ", ";
                }
            }
        }
        stream << "}";
        m_operands += stream.str();
    }

    if (instr.name == Mnemonic::SSAT || instr.name == Mnemonic::USAT)
    {
        m_operands = to_string(instr.Rd) + ", " + format_immediate(instr.imm) + ", " + to_string(instr.Rn) + shift_extension;
    }

    if (instr.name == Mnemonic::CPS)
    {
        bool enable = _1BIT(instr.imm >> 4) == 0;
        bool affectPRI = _1BIT(instr.imm >> 1) == 1;
        bool affectFAULT = _1BIT(instr.imm) == 1;
        m_mnemonic += enable ? "ie" : "id";
        m_operands = "";
        m_operands += affectPRI ? "i" : "";
        m_operands += affectFAULT ? "f" : "";
    }

    return ReturnCode::OK;
}
