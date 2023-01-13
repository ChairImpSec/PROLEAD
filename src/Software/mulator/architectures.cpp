#include "Software/mulator/architectures.h"

namespace mulator
{

    std::string to_string(const Architecture& x)
    {
        switch (x)
        {
            case Architecture::ARMv6M: return "ARMv6-M";
            case Architecture::ARMv7M: return "ARMv7-M";
            case Architecture::ARMv7EM: return "ARMv7E-M";
        }

        return "<unknown architecture " + std::to_string(static_cast<int>(x)) + ">";
    }

    std::ostream& operator<<(std::ostream& os, const Architecture& x)
    {
        return os << to_string(x);
    }

}
