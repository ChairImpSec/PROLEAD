
#pragma once
#include <thread>

enum class CpuSelectionOption {
    All, Half, Third, Quarter, Specific
};


/// <summary>
///     The CpuCoreSelector class takes a std::string in its constructor, which represents the setting for max_no_of_threads.
///     It calculates the optimal number of threads in the updateThreadCount method based on this setting.
///     getOptimalThreadCount method can be used to retrieve the calculated number of threads.
///     The class encapsulates the logic for determining the number of threads, making it reusable and easy to integrate.
/// </summary>
class CpuCoreSelector
{
public:
    static unsigned int getOptimalCount(CpuSelectionOption option, unsigned int specificCount = 0);
};




