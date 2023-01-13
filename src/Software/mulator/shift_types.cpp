#include "Software/mulator/shift_types.h"

namespace mulator
{

    std::string to_string(const ShiftType& x)
    {
        switch (x)
        {
            case ShiftType::LSL : return "lsl";
            case ShiftType::LSR : return "lsr";
            case ShiftType::ASR : return "asr";
            case ShiftType::ROR : return "ror";
            case ShiftType::RRX : return "rrx";
        }

        return "<unknown shift type " + std::to_string(static_cast<int>(x)) + ">";
    }


    std::ostream& operator<<(std::ostream& os, const ShiftType& x)
    {
        return os << to_string(x);
    }
}
