#include "CpuCoreSelector.hpp"
#include <thread>
#include <algorithm>

unsigned int CpuCoreSelector::getOptimalCount(CpuSelectionOption option, unsigned int specificCount) {
    unsigned int nCores = std::thread::hardware_concurrency();
    switch (option) {
    case CpuSelectionOption::All:
        return nCores;
    case CpuSelectionOption::Half:
        return nCores / 2;
    case CpuSelectionOption::Third:
        return nCores / 3;
    case CpuSelectionOption::Quarter:
        return nCores / 4;
    case CpuSelectionOption::Specific:
        return std::min(specificCount, nCores);
    default:
        return 1;  // Default case for safety
    }
}

