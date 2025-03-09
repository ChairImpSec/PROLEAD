/**
 * @file SharedData.hpp
 * @author Amir Moradi & Nicolai Müller
 */

#pragma once
#include <cinttypes>
#include <vector>

#include "Hardware/Circuit.hpp"

class SharedData {
 public:
  SharedData(const CircuitStruct& circuit, const Settings& settings);

 //private:
  std::vector<uint64_t> one_in_64_;
  std::vector<uint64_t> zero_in_64_;
  std::vector<uint64_t> signal_values_;
  std::vector<uint64_t> register_values_;
  std::vector<std::vector<uint64_t>> group_values_;
  std::vector<std::vector<InputAssignment>> input_sequence_;
  std::map<std::vector<uint64_t>, std::vector<std::vector<uint64_t>>>
      selected_group_values;

};
