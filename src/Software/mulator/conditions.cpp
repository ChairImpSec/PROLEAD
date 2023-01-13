#include "Software/mulator/conditions.h"

namespace mulator
{

    std::string to_string(const Condition& x)
    {
        switch (x)
        {
            case EQ: return "eq";
            case NE: return "ne";
            case CS: return "cs";
            case CC: return "cc";
            case MI: return "mi";
            case PL: return "pl";
            case VS: return "vs";
            case VC: return "vc";
            case HI: return "hi";
            case LS: return "ls";
            case GE: return "ge";
            case LT: return "lt";
            case GT: return "gt";
            case LE: return "le";
            case AL: return "al";
        }

        return "<unknown condition " + std::to_string(static_cast<int>(x)) + ">";
    }

    std::ostream& operator<<(std::ostream& os, const Condition& x)
    {
        return os << to_string(x);
    }

}
