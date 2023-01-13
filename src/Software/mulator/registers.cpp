#include "Software/mulator/registers.h"

namespace mulator
{
    uint32_t to_int(const Register& x)
    {
        return static_cast<uint32_t>(x);
    }

    std::string to_string_probe(const Register& x)
    {
        switch(x){
            case 0: return "R0"; break;
            case 1: return "R1"; break;
            case 2: return "R2"; break;
            case 3: return "R3"; break;
            case 4: return "R4"; break;
            case 5: return "R5"; break;
            case 6: return "R6"; break;
            case 7: return "R7"; break;
            case 8: return "R8"; break;
            case 9: return "R9"; break;
            case 10:return "R10"; break;
            case 11:return "R11"; break;
            case 12:return "R12"; break;
            case 13:return "R13"; break;
            case 14:return "R14"; break;
            case 15:return "R15"; break;
            case 16:return "R16"; break;
            default: return "<unknown register " + std::to_string(static_cast<int>(x)) + ">"; break;
        }

    }

    std::string to_string(const Register& x)
    {
        switch(x){
            case 0: return "R0"; break;
            case 1: return "R1"; break;
            case 2: return "R2"; break;
            case 3: return "R3"; break;
            case 4: return "R4"; break;
            case 5: return "R5"; break;
            case 6: return "R6"; break;
            case 7: return "R7"; break;
            case 8: return "R8"; break;
            case 9: return "R9"; break;
            case 10:return "R10"; break;
            case 11:return "R11"; break;
            case 12:return "R12"; break;
            case 13:return "R13"; break;
            case 14:return "LR"; break;
            case 15:return "PC"; break;
            case 16:return "XPSR"; break;
            default: return "<unknown register " + std::to_string(static_cast<int>(x)) + ">"; break;
        }
    }


    std::ostream& operator<<(std::ostream& os, const Register& x)
    {
        return os << to_string(x);
    }
}
