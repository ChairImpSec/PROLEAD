#pragma once

#include <string>
#include <ostream>

namespace mulator
{

    enum Condition
    {
        EQ = 0, // Equal Z == 1
        NE, // Not equal Z == 0
        CS, //  HS (unsigned higher or same) is a synonym for CS. Carry set C == 1
        CC, //  LO (unsigned lower) is a synonym for CC. Carry clear C == 0
        MI, // Minus, negative N == 1
        PL, // Plus, positive or zero N == 0
        VS, // Overflow V == 1
        VC, // No overflow V == 0
        HI, // Unsigned higher C == 1 and Z == 0
        LS, // Unsigned lower or same C == 0 or Z == 1
        GE, // Signed greater than or equal N == V
        LT, // Signed less than N != V
        GT, // Signed greater than Z == 0 and N == V
        LE, // Signed less than or equal Z == 1 or N != V
        AL, // Always (never encoded)
    };

    std::string to_string(const Condition& x);
    std::ostream& operator<<(std::ostream& os, const Condition& x);

}
