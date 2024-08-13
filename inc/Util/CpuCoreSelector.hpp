/**
 * @file CpuCoreSelector.hpp
 * @author https://github.com/gmottajr
 */
#pragma once
#include <algorithm>
#include <map>
#include <stdexcept>
#include <string>
#include <thread>

enum class CpuSelectionOption { all, half, third, quarter, specific };

/**
 * @brief A class to select the optimal number of CPU cores.
 */
class CpuCoreSelector {
 public:
  /**
   * @brief Determines the optimal number of threads based on the provided
   * option.
   *
   * This function selects the number of threads to use based on a given option.
   * The option can either be a string representing a specific number of threads
   * or a keyword that indicates a fraction of the available hardware
   * concurrency (e.g., "half", "third").
   *
   * @param option A string that specifies the desired number of threads or a
   * keyword indicating a fraction of the hardware concurrency. Recognized
   * keywords are:
   *        - "all": Use all available threads.
   *        - "half": Use half of the available threads.
   *        - "third": Use one third of the available threads.
   *        - "quarter": Use one fourth of the available threads.
   *        If the option is a number, it directly specifies the number of
   * threads to use.
   *
   * @return The optimal number of threads to use based on the provided option.
   * If the option is invalid or exceeds the available hardware concurrency, it
   * defaults to a valid number of threads.
   *
   * @throws std::invalid_argument if the option string cannot be converted to a
   * valid number.
   * @throws std::out_of_range if the option string represents a number less
   * than 1.
   *
   * This function works as follows:
   * - It first estimates the number of available hardware threads using
   * std::thread::hardware_concurrency().
   * - If the option matches a predefined keyword, it returns the corresponding
   * fraction of the estimated number of threads.
   * - If the option can be parsed as a number, it returns the minimum of the
   * specified number and the estimated number of threads, ensuring at least one
   * thread is used.
   * - If the option is invalid, appropriate exceptions are thrown.
   */
  uint64_t GetOptimalNumberOfThreads(std::string option);

 private:
  /**
   * @brief A map to convert string options to CpuSelectionOption enum values.
   */
  const std::map<std::string, CpuSelectionOption> cpu_option_map = {
      {"all", CpuSelectionOption::all},
      {"half", CpuSelectionOption::half},
      {"third", CpuSelectionOption::third},
      {"quarter", CpuSelectionOption::quarter}};
};