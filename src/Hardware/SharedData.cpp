#include "Hardware/SharedData.hpp"

SharedData::SharedData(const CircuitStruct& circuit, const Settings& settings)
    : one_in_64_(64),
      zero_in_64_(64),
      signal_values_(circuit.NumberOfSignals),
      register_values_(circuit.NumberOfRegValues),
      group_values_(
          settings.GetNumberOfGroups(),
          std::vector<uint64_t>(settings.GetNumberOfBitsPerGroup(), 0)) {
  uint64_t cycle_index, input_index, value_index, bitmask = 1;
  std::string signal_name;

  for (uint64_t index = 0; index < 64; ++index) {
    one_in_64_[index] = bitmask;
    zero_in_64_[index] = ~bitmask;
    bitmask <<= 1;
  }

  signal_values_[1] = 0xffffffffffffffff;
  signal_values_[3] = 0xffffffffffffffff;

  uint64_t size_of_input_element_in_bits =
      std::ceil(std::log2l(settings.input_finite_field.base)) *
      settings.input_finite_field.exponent;
  uint64_t number_of_clock_cycles = settings.GetCyclesForInputSequence();
  uint64_t number_of_assignments, input_sequence_size;

  input_sequence_.resize(number_of_clock_cycles);

  for (cycle_index = 0; cycle_index < number_of_clock_cycles; ++cycle_index) {
    for (const InputAssignment& input_assignment :
         settings.GetInputSequenceOfOneCycle(cycle_index)) {
      if (input_assignment.signal_values_.empty()) {
        if ((input_assignment.signal_names_.size() %
             size_of_input_element_in_bits) != 0) {
          throw std::invalid_argument(
              "Error while setting the input sequence. Invalid assignment "
              "length!");
        } else {
          number_of_assignments = input_assignment.signal_names_.size() /
                                  size_of_input_element_in_bits;
          input_sequence_size = input_sequence_[cycle_index].size();
          input_sequence_[cycle_index].resize(input_sequence_size +
                                              number_of_assignments);

          for (value_index = 0; value_index < number_of_assignments;
               ++value_index) {
            input_sequence_[cycle_index][input_sequence_size + value_index]
                .is_inverted_ = input_assignment.is_inverted_;
            input_sequence_[cycle_index][input_sequence_size + value_index]
                .signal_names_.resize(size_of_input_element_in_bits);
            input_sequence_[cycle_index][input_sequence_size + value_index]
                .group_indices_.resize(size_of_input_element_in_bits);
            std::copy(
                input_assignment.signal_names_.begin() +
                    value_index * size_of_input_element_in_bits,
                input_assignment.signal_names_.begin() +
                    (value_index + 1) * size_of_input_element_in_bits,
                input_sequence_[cycle_index][input_sequence_size + value_index]
                    .signal_names_.begin());
            std::copy(
                input_assignment.group_indices_.begin() +
                    value_index * size_of_input_element_in_bits,
                input_assignment.group_indices_.begin() +
                    (value_index + 1) * size_of_input_element_in_bits,
                input_sequence_[cycle_index][input_sequence_size + value_index]
                    .group_indices_.begin());
            input_sequence_[cycle_index][input_sequence_size + value_index]
                .share_index_ = input_assignment.share_index_;
            input_sequence_[cycle_index][input_sequence_size + value_index]
                .signal_indices_.resize(size_of_input_element_in_bits);
          }
        }
      } else {
        input_sequence_[cycle_index].push_back(input_assignment);
        input_sequence_[cycle_index].back().signal_indices_.resize(
            input_assignment.signal_names_.size());
      }
    }
  }

  for (cycle_index = 0; cycle_index < number_of_clock_cycles; ++cycle_index) {
    for (InputAssignment& input_assignment : input_sequence_[cycle_index]) {
      for (value_index = 0; value_index < input_assignment.signal_names_.size();
           ++value_index) {
        for (input_index = 0; input_index < (uint64_t)circuit.NumberOfSignals;
             ++input_index) {
          signal_name = circuit.signals_[input_index].Name;

          if (signal_name == input_assignment.signal_names_[value_index]) {
            input_assignment.signal_indices_[value_index] = input_index;
            break;
          }
        }
      }
    }
  }

  std::vector<uint64_t> group_values(size_of_input_element_in_bits);
  for (cycle_index = 0; cycle_index < number_of_clock_cycles; ++cycle_index) {
    for (const InputAssignment& input_assignment :
         input_sequence_[cycle_index]) {
      if (!input_assignment.group_indices_.empty()) {
        if ((selected_group_values.find(input_assignment.group_indices_) ==
             selected_group_values.end()) ||
            (selected_group_values[input_assignment.group_indices_].size() <
             input_assignment.share_index_ + 1)) {
          selected_group_values[input_assignment.group_indices_].resize(
              input_assignment.share_index_ + 1,
              std::vector<uint64_t>(input_assignment.group_indices_.size(), 0));
        }
      }
    }
  }
}
