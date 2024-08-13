#include "Util/CpuCoreSelector.hpp"

uint64_t CpuCoreSelector::GetOptimalNumberOfThreads(std::string option) {
  uint64_t estimated_number_of_threads = std::thread::hardware_concurrency();

  if (cpu_option_map.count(option)) {
    switch (cpu_option_map.at(option)) {
      case CpuSelectionOption::all:
        return estimated_number_of_threads;
      case CpuSelectionOption::half:
        return estimated_number_of_threads / 2;
      case CpuSelectionOption::third:
        return estimated_number_of_threads / 3;
      case CpuSelectionOption::quarter:
        return estimated_number_of_threads / 4;
      default:
        return 1;
    }
  } else {
    try {
      int64_t parsed_number_of_threads = std::stoll(option);
      if (parsed_number_of_threads < 1) {
        throw std::out_of_range("Error while setting the number of threads: " +
                                std::to_string(parsed_number_of_threads) +
                                " is not a valid number of threads!");
      }

      uint64_t specified_number_of_threads = (uint64_t)parsed_number_of_threads;
      return std::min(specified_number_of_threads, estimated_number_of_threads);
    } catch (const std::invalid_argument& e) {
      throw std::invalid_argument("Error while setting the number of threads:" +
                                  std::string(e.what()));
    } catch (const std::out_of_range& e) {
      throw std::out_of_range("Error while setting the number of threads:" +
                              std::string(e.what()));
    }
  }
}
