#pragma once

#include <string>
#include <ostream>

namespace mulator
{

    enum Architecture
    {
        ARMv6M,
        ARMv7M,
        ARMv7EM,
    };

    std::string to_string(const Architecture& x);
    std::ostream& operator<<(std::ostream& os, const Architecture& x);

}
