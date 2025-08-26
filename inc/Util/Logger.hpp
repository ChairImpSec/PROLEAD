#pragma once

#include <cstdint>
#include <string>
#include <vector>
#include <stdexcept>
#include <iostream>
#include <iomanip>
#include <boost/log/core.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/utility/setup/console.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/support/date_time.hpp>

struct TableCell {
  std::string content_;
  uint64_t width_;

  TableCell(std::string content, uint64_t width);
};

class Logger {

private:
  const std::string padding_;
  const uint64_t max_width_;
  const uint64_t normal_width_;

public:
  /** @brief The general base constructor */
  Logger(uint64_t padding_length, uint64_t max_width, uint64_t normal_width);

  uint64_t DetermineRowWidth(const std::vector<TableCell>& row);
  void PrintInitialMessage(const std::string& message);
  void PrintInfoMessage(const std::string& message);
  void PrintFinalMessage(const std::string& message);
  void PrintRow(const std::vector<TableCell>& row);
  void PrintRowWithSeparation(const std::vector<TableCell>& row, bool spacing=false);
  void PrintHeader(const std::vector<TableCell>& row);
  void PrintHorizontalTableLine(uint64_t width, bool spacing=false);
  void PrintMajorRule();
  void PrintMinorRule();
  TableCell GetTimeCell(const double & seconds_total, uint64_t width);
  TableCell GetMemoryCell(uint64_t mem_in_kb, uint64_t width);
  static void InitLogging();
};
