#include "Software/mulator/return_codes.h"

namespace mulator
{

    std::string to_string(const ReturnCode& x)
    {
        switch (x)
        {
            case ReturnCode::OK: return "OK";
            case ReturnCode::INCOMPLETE_DATA: return "INCOMPLETE_DATA";
            case ReturnCode::UNDEFINED: return "UNDEFINED";
            case ReturnCode::UNPREDICTABLE: return "UNPREDICTABLE";
            case ReturnCode::UNSUPPORTED: return "UNSUPPORTED";
            case ReturnCode::UNEXPECTED_ENCODING: return "UNEXPECTED_ENCODING";
            case ReturnCode::NOT_IMPLEMENTED: return "NOT_IMPLEMENTED";
            case ReturnCode::UNKNOWN_INSTRUCTION: return "UNKNOWN_INSTRUCTION";
            case ReturnCode::INVALID_IMMEDIATE: return "INVALID_IMMEDIATE";

            case ReturnCode::INVALID_REGISTER: return "INVALID_REGISTER";
            case ReturnCode::INVALID_ALIGNMENT: return "INVALID_ALIGNMENT";
            case ReturnCode::INVALID_MEMORY_ACCESS: return "INVALID_MEMORY_ACCESS";
            case ReturnCode::INVALID_SHIFT_ARGUMENT: return "INVALID_SHIFT_ARGUMENT";
            case ReturnCode::HARD_FAULT: return "HARD_FAULT";

            case ReturnCode::UNINITIALIZED: return "UNINITIALIZED";
            case ReturnCode::MAX_INSTRUCTIONS_REACHED: return "MAX_INSTRUCTIONS_REACHED";
            case ReturnCode::END_ADDRESS_REACHED: return "END_ADDRESS_REACHED";
            case ReturnCode::STOP_EMULATION_CALLED: return "STOP_EMULATION_CALLED";
        }

        return "<unknown return code " + std::to_string(static_cast<int>(x)) + ">";
    }

    std::ostream& operator<<(std::ostream& os, const ReturnCode& x)
    {
        return os << to_string(x);
    }

}
