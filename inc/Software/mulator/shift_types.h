#pragma once

#include <ostream>

namespace mulator
{

    enum class ShiftType
    {
        LSL,
        LSR,
        ASR,
        ROR,
        RRX
    };

    std::string to_string(const ShiftType& x);
    std::ostream& operator<<(std::ostream& os, const ShiftType& x);

}
