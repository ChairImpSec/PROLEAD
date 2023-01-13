#include "Software/mulator/mnemonics.h"

namespace mulator
{

    std::string to_string(const Mnemonic& x)
    {
        switch (x)
        {
            case Mnemonic::ADC :   return "adc";
            case Mnemonic::ADD :   return "add";
            case Mnemonic::ADR :   return "adr";
            case Mnemonic::AND :   return "and";
            case Mnemonic::ASR :   return "asr";
            case Mnemonic::B :     return "b";
            case Mnemonic::BIC :   return "bic";
            case Mnemonic::BKPT :  return "bkpt";
            case Mnemonic::BL :    return "bl";
            case Mnemonic::BLX :   return "blx";
            case Mnemonic::BX :    return "bx";
            case Mnemonic::CMN :   return "cmn";
            case Mnemonic::CMP :   return "cmp";
            case Mnemonic::CPS :   return "cps";
            case Mnemonic::DMB :   return "dmb";
            case Mnemonic::DSB :   return "dsb";
            case Mnemonic::EOR :   return "eor";
            case Mnemonic::ISB :   return "isb";
            case Mnemonic::LDM :   return "ldm";
            case Mnemonic::LDR :   return "ldr";
            case Mnemonic::LDRB :  return "ldrb";
            case Mnemonic::LDRH :  return "ldrh";
            case Mnemonic::LDRSB : return "ldrsb";
            case Mnemonic::LDRSH : return "ldrsh";
            case Mnemonic::LSL :   return "lsl";
            case Mnemonic::LSR :   return "lsr";
            case Mnemonic::MOV :   return "mov";
            case Mnemonic::MRS :   return "mrs";
            case Mnemonic::MSR :   return "msr";
            case Mnemonic::MUL :   return "mul";
            case Mnemonic::MVN :   return "mvn";
            case Mnemonic::NOP :   return "nop";
            case Mnemonic::ORR :   return "orr";
            case Mnemonic::POP :   return "pop";
            case Mnemonic::PUSH :  return "push";
            case Mnemonic::REV :   return "rev";
            case Mnemonic::REV16 : return "rev16";
            case Mnemonic::REVSH : return "revsh";
            case Mnemonic::ROR :   return "ror";
            case Mnemonic::RSB :   return "rsb";
            case Mnemonic::SBC :   return "sbc";
            case Mnemonic::SEV :   return "sev";
            case Mnemonic::STM :   return "stm";
            case Mnemonic::STR :   return "str";
            case Mnemonic::STRB :  return "strb";
            case Mnemonic::STRH :  return "strh";
            case Mnemonic::SUB :   return "sub";
            case Mnemonic::SVC :   return "svc";
            case Mnemonic::SXTB :  return "sxtb";
            case Mnemonic::SXTH :  return "sxth";
            case Mnemonic::TST :   return "tst";
            case Mnemonic::UDF :   return "udf";
            case Mnemonic::UXTB :  return "uxtb";
            case Mnemonic::UXTH :  return "uxth";
            case Mnemonic::WFE :   return "wfe";
            case Mnemonic::WFI :   return "wfi";
            case Mnemonic::YIELD : return "yield";

            // armv7m only
            case Mnemonic::ADDW : return "addw";
            case Mnemonic::BFC : return "bfc";
            case Mnemonic::BFI : return "bfi";
            case Mnemonic::CBZ : return "cbz";
            case Mnemonic::CBNZ : return "cbnz";
            case Mnemonic::CLREX : return "clrex";
            case Mnemonic::CLZ : return "clz";
            case Mnemonic::CSDB : return "csdb";
            case Mnemonic::DBG : return "dbg";
            case Mnemonic::IT : return "it";
            case Mnemonic::LDMDB : return "ldmdb";
            case Mnemonic::LDRBT : return "ldrbt";
            case Mnemonic::LDRD : return "ldrd";
            case Mnemonic::LDREX : return "ldrex";
            case Mnemonic::LDREXB : return "ldrexb";
            case Mnemonic::LDREXH : return "ldrexh";
            case Mnemonic::LDRHT : return "ldrht";
            case Mnemonic::LDRSBT : return "ldrsbt";
            case Mnemonic::LDRSHT : return "ldrsht";
            case Mnemonic::LDRT : return "ldrt";
            case Mnemonic::MLA : return "mla";
            case Mnemonic::MLS : return "mls";
            case Mnemonic::MOVT : return "movt";
            case Mnemonic::MOVW : return "movw";
            case Mnemonic::ORN : return "orn";
            case Mnemonic::PLD : return "pld";
            case Mnemonic::PLI : return "pli";
            case Mnemonic::PSSBB : return "pssbb";
            case Mnemonic::RBIT : return "rbit";
            case Mnemonic::RRX : return "rrx";
            case Mnemonic::SBFX : return "sbfx";
            case Mnemonic::SDIV : return "sdiv";
            case Mnemonic::SMLAL : return "smlal";
            case Mnemonic::SMULL : return "smull";
            case Mnemonic::SSAT : return "ssat";
            case Mnemonic::SSBB : return "ssbb";
            case Mnemonic::STMDB : return "stmdb";
            case Mnemonic::STRBT : return "strbt";
            case Mnemonic::STRD : return "strd";
            case Mnemonic::STREX : return "strex";
            case Mnemonic::STREXB : return "strexb";
            case Mnemonic::STREXH : return "strexh";
            case Mnemonic::STRHT : return "strht";
            case Mnemonic::STRT : return "strt";
            case Mnemonic::SUBW : return "subw";
            case Mnemonic::TBB : return "tbb";
            case Mnemonic::TBH : return "tbh";
            case Mnemonic::TEQ : return "teq";
            case Mnemonic::UBFX : return "ubfx";
            case Mnemonic::UDIV : return "udiv";
            case Mnemonic::UMLAL : return "umlal";
            case Mnemonic::UMULL : return "umull";
            case Mnemonic::USAT : return "usat";

            // armv7e-m only
            case Mnemonic::UADD8 : return "uadd8";
            case Mnemonic::SEL : return "sel";
            case Mnemonic::USUB16 : return "usub16";
            case Mnemonic::UADD16 : return "uadd16";
            case Mnemonic::PKHBT : return "pkhbt";
            case Mnemonic::PKHTB : return "pkhtb";
            case Mnemonic::SMULBB : return "smulbb";
            case Mnemonic::SMULBT : return "smulbt";
            case Mnemonic::SMULTB : return "smultb";
            case Mnemonic::SMULTT : return "smultt";
            case Mnemonic::SMLABB : return "smlabb";
            case Mnemonic::SMLABT : return "smlabt";
            case Mnemonic::SMLATB : return "smlatb";
            case Mnemonic::SMLATT : return "smlatt";
            case Mnemonic::QADD : return "qadd";
            case Mnemonic::QADD16 : return "qadd16";
            case Mnemonic::QADD8 : return "qadd8";
            case Mnemonic::QASX : return "qasx";
            case Mnemonic::QDADD : return "qdadd";
            case Mnemonic::QDSUB : return "qdsub";
            case Mnemonic::USUB8 : return "usub8";
            case Mnemonic::UXTAB : return "uxtab";
            case Mnemonic::UXTAB16 : return "uxtab16";
            case Mnemonic::UXTAH : return "uxtah";
            case Mnemonic::UXTB16 : return "uxtb16";
            case Mnemonic::USAX : return "usax";
            case Mnemonic::SSUB16 : return "ssub16";
            case Mnemonic::SSUB8 : return "ssub8";
            case Mnemonic::SXTAB : return "sxtab";
            case Mnemonic::SXTAB16 : return "sxtab16";
            case Mnemonic::SXTAH : return "sxtah";
            case Mnemonic::UASX : return "uasx";
            case Mnemonic::UHADD16 : return "uhadd16";
            case Mnemonic::UHSUB8 : return "uhsub8";
            case Mnemonic::QSAX : return "qsax";
            case Mnemonic::QSUB : return "qsub";
            case Mnemonic::SHADD16 : return "shadd16";
            case Mnemonic::SMLALD : return "smlald";
            case Mnemonic::SHADD8 : return "shadd8";
            case Mnemonic::SMLALDX : return "smlaldx";
            case Mnemonic::QSUB16 : return "qsub16";
            case Mnemonic::SHASX : return "shasx";
            case Mnemonic::SMLAD : return "smlad";
            case Mnemonic::SMLAWB : return "smlawb";
            case Mnemonic::QSUB8 : return "qsub8";
            case Mnemonic::SHSAX : return "shsax";
            case Mnemonic::SMLADX : return "smladx";
            case Mnemonic::SMLAWT : return "smlawt";
            case Mnemonic::SADD16 : return "sadd16";
            case Mnemonic::SHSUB16 : return "shsub16";
            case Mnemonic::SMLALBB : return "smlalbb";
            case Mnemonic::SMLSD : return "smlsd";
            case Mnemonic::SADD8 : return "sadd8";
            case Mnemonic::SHSUB8 : return "shsub8";
            case Mnemonic::SMLALBT : return "smlalbt";
            case Mnemonic::SMLSDX : return "smlsdx";
            case Mnemonic::SMLSLD : return "smlsld";
            case Mnemonic::SMLSLDX : return "smlsldx";
            case Mnemonic::SMMLA : return "smmla";
            case Mnemonic::SMMLAR : return "smmlar";
            case Mnemonic::SMMLS : return "smmls";
            case Mnemonic::SMMLSR : return "smmlsr";
            case Mnemonic::SMMUL : return "smmul";
            case Mnemonic::SMMULR : return "smmulr";
            case Mnemonic::SMUAD : return "smuad";
            case Mnemonic::SMUADX : return "smuadx";
            case Mnemonic::SMULWB : return "smulwb";
            case Mnemonic::SMULWT : return "smulwt";
            case Mnemonic::SMUSD : return "smusd";
            case Mnemonic::SMUSDX : return "smusdx";
            case Mnemonic::SSAT16 : return "ssat16";
            case Mnemonic::SSAX : return "ssax";
            case Mnemonic::UMAAL : return "umaal";
            case Mnemonic::UQADD16 : return "uqadd16";
            case Mnemonic::UQADD8 : return "uqadd8";
            case Mnemonic::UQASX : return "uqasx";
            case Mnemonic::UQSAX : return "uqsax";
            case Mnemonic::UQSUB16 : return "uqsub16";
            case Mnemonic::UQSUB8 : return "uqsub8";
            case Mnemonic::USAD8 : return "usad8";
            case Mnemonic::USADA8 : return "usada8";
            case Mnemonic::USAT16 : return "usat16";
            case Mnemonic::SASX : return "sasx";
            case Mnemonic::SMLALTT : return "smlaltt";
            case Mnemonic::SMLALTB : return "smlaltb";

        }

        return "<unknown mnemonic " + std::to_string(static_cast<int>(x)) + ">";
    }

    std::ostream& operator<<(std::ostream& os, const Mnemonic& x)
    {
        return os << to_string(x);
    }

    bool has_narrow_encoding(const Mnemonic& x)
    {
        switch (x)
        {
            case Mnemonic::ADC:
            case Mnemonic::ADD:
            case Mnemonic::ADR:
            case Mnemonic::AND:
            case Mnemonic::ASR:
            case Mnemonic::B:
            case Mnemonic::BIC:
            case Mnemonic::BKPT:
            case Mnemonic::BLX:
            case Mnemonic::BX:
            case Mnemonic::CMN:
            case Mnemonic::CMP:
            case Mnemonic::CPS:
            case Mnemonic::EOR:
            case Mnemonic::LDM:
            case Mnemonic::LDR:
            case Mnemonic::LDRB:
            case Mnemonic::LDRH:
            case Mnemonic::LDRSB:
            case Mnemonic::LDRSH:
            case Mnemonic::LSL:
            case Mnemonic::LSR:
            case Mnemonic::MOV:
            case Mnemonic::MUL:
            case Mnemonic::MVN:
            case Mnemonic::NOP:
            case Mnemonic::ORR:
            case Mnemonic::POP:
            case Mnemonic::PUSH:
            case Mnemonic::REV16:
            case Mnemonic::REV:
            case Mnemonic::REVSH:
            case Mnemonic::ROR:
            case Mnemonic::RSB:
            case Mnemonic::SBC:
            case Mnemonic::SEV:
            case Mnemonic::STM:
            case Mnemonic::STR:
            case Mnemonic::STRB:
            case Mnemonic::STRH:
            case Mnemonic::SUB:
            case Mnemonic::SVC:
            case Mnemonic::SXTB:
            case Mnemonic::TST:
            case Mnemonic::UDF:
            case Mnemonic::UXTB:
            case Mnemonic::UXTH:
            case Mnemonic::WFE:
            case Mnemonic::WFI:
            case Mnemonic::YIELD: return true;
            default: return false;
        }
    }



    bool has_wide_encoding(const Mnemonic& x)
    {
        switch (x)
        {
            case Mnemonic::ADC:
            case Mnemonic::ADD:
            case Mnemonic::ADDW:
            case Mnemonic::ADR:
            case Mnemonic::AND:
            case Mnemonic::ASR:
            case Mnemonic::B:
            case Mnemonic::BFC:
            case Mnemonic::BFI:
            case Mnemonic::BIC:
            case Mnemonic::BL:
            case Mnemonic::CLREX:
            case Mnemonic::CLZ:
            case Mnemonic::CMN:
            case Mnemonic::CMP:
            case Mnemonic::CSDB:
            case Mnemonic::DBG:
            case Mnemonic::DMB:
            case Mnemonic::DSB:
            case Mnemonic::EOR:
            case Mnemonic::ISB:
            case Mnemonic::LDM:
            case Mnemonic::LDMDB:
            case Mnemonic::LDR:
            case Mnemonic::LDRB:
            case Mnemonic::LDRBT:
            case Mnemonic::LDRD:
            case Mnemonic::LDREX:
            case Mnemonic::LDREXB:
            case Mnemonic::LDREXH:
            case Mnemonic::LDRH:
            case Mnemonic::LDRHT:
            case Mnemonic::LDRSB:
            case Mnemonic::LDRSBT:
            case Mnemonic::LDRSH:
            case Mnemonic::LDRSHT:
            case Mnemonic::LDRT:
            case Mnemonic::LSL:
            case Mnemonic::LSR:
            case Mnemonic::MLA:
            case Mnemonic::MLS:
            case Mnemonic::MOV:
            case Mnemonic::MOVT:
            case Mnemonic::MOVW:
            case Mnemonic::MRS:
            case Mnemonic::MSR:
            case Mnemonic::MUL:
            case Mnemonic::MVN:
            case Mnemonic::NOP:
            case Mnemonic::ORN:
            case Mnemonic::ORR:
            case Mnemonic::PLD:
            case Mnemonic::PLI:
            case Mnemonic::POP:
            case Mnemonic::PSSBB:
            case Mnemonic::PUSH:
            case Mnemonic::RBIT:
            case Mnemonic::REV16:
            case Mnemonic::REV:
            case Mnemonic::REVSH:
            case Mnemonic::ROR:
            case Mnemonic::RRX:
            case Mnemonic::RSB:
            case Mnemonic::SBC:
            case Mnemonic::SBFX:
            case Mnemonic::SDIV:
            case Mnemonic::SEV:
            case Mnemonic::SMLAL:
            case Mnemonic::SMULL:
            case Mnemonic::SSAT:
            case Mnemonic::SSBB:
            case Mnemonic::STM:
            case Mnemonic::STMDB:
            case Mnemonic::STR:
            case Mnemonic::STRB:
            case Mnemonic::STRBT:
            case Mnemonic::STRD:
            case Mnemonic::STREX:
            case Mnemonic::STREXB:
            case Mnemonic::STREXH:
            case Mnemonic::STRH:
            case Mnemonic::STRHT:
            case Mnemonic::STRT:
            case Mnemonic::SUB:
            case Mnemonic::SUBW:
            case Mnemonic::SXTB:
            case Mnemonic::SXTH:
            case Mnemonic::TEQ:
            case Mnemonic::TST:
            case Mnemonic::UBFX:
            case Mnemonic::UDF:
            case Mnemonic::UDIV:
            case Mnemonic::UMLAL:
            case Mnemonic::UMULL:
            case Mnemonic::USAT:
            case Mnemonic::UXTB:
            case Mnemonic::UXTH:
            case Mnemonic::WFE:
            case Mnemonic::WFI:
            case Mnemonic::YIELD: return true;
            default: return false;
        }
    }
}
