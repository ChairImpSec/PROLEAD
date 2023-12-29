
#pragma once
#include <thread>

enum class CpuSelectionOption { all, half, third, quarter, specific };

/**
 * The class encapsulates the logic for determining the number of threads,
 * making it reusable and easy to integrate.
 */
class CpuCoreSelector {
 public:
  /**
   * @brief Retrieves the calculated number of threads.
   * @param option The specified cpu option.
   * @param specified_number_of_cores The specified number of cores to use.
   * @return The number of threads.
   * @author https://github.com/gmottajr
   */
  static unsigned int getOptimalCount(
      CpuSelectionOption option, unsigned int specified_number_of_cores = 0);
};