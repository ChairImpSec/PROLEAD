#include "Util/CpuCoreSelector.hpp"

#include <algorithm>
#include <thread>

unsigned int CpuCoreSelector::getOptimalCount(
    CpuSelectionOption option, unsigned int specified_number_of_cores) {
  unsigned int estimated_number_of_cores = std::thread::hardware_concurrency();
  switch (option) {
    case CpuSelectionOption::all:
      return estimated_number_of_cores;
    case CpuSelectionOption::half:
      return estimated_number_of_cores / 2;
    case CpuSelectionOption::third:
      return estimated_number_of_cores / 3;
    case CpuSelectionOption::quarter:
      return estimated_number_of_cores / 4;
    case CpuSelectionOption::specific:
      return std::min(specified_number_of_cores, estimated_number_of_cores);
    default:
      return 1;  // Default case for safety
  }
}
