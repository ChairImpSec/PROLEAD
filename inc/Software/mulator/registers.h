#pragma once

#include <cstdint>
#include <ostream>

namespace mulator
{

    const int REGISTER_COUNT = 17;

    enum Register
    {
        R0 = 0,
        R1,
        R2,
        R3,
        R4,
        R5,
        R6,
        R7,
        R8,
        R9,
        R10,
        R11,
        R12,
        R13,
        R14,
        R15,

        SB = R9,
        SL = R10,
        FP = R11,
        IP = R12,
        SP = R13,
        LR = R14,
        PC = R15,

        PSR,
    };

    std::string to_string(const Register& x);
    std::string to_string_probe(const Register& x);
    uint32_t to_int(const Register& x);
    std::ostream& operator<<(std::ostream& os, const Register& x);

}
