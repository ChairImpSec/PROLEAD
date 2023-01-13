#pragma once

#include <string>
#include <ostream>

namespace mulator
{

    enum class ReturnCode
    {
        OK,

        INCOMPLETE_DATA,
        UNDEFINED,
        UNPREDICTABLE,
        UNSUPPORTED,
        UNEXPECTED_ENCODING,
        NOT_IMPLEMENTED,
        UNKNOWN_INSTRUCTION,
        INVALID_IMMEDIATE,

        INVALID_REGISTER,
        INVALID_ALIGNMENT,
        INVALID_MEMORY_ACCESS,
        INVALID_SHIFT_ARGUMENT,
        HARD_FAULT,

        UNINITIALIZED,
        MAX_INSTRUCTIONS_REACHED,
        END_ADDRESS_REACHED,
        STOP_EMULATION_CALLED,
    };

    std::string to_string(const ReturnCode& x);
    std::ostream& operator<<(std::ostream& os, const ReturnCode& x);

}
