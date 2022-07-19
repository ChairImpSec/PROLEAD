#pragma once

#include <time.h>

namespace Util
{
    void StartClock(timespec&);
    double EndClock(timespec&);
}
