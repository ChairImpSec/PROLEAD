#include "Hardware/Definitions.hpp"
#include "Hardware/Circuit.hpp"


Simulation::Simulation(Hardware::CircuitStruct& circuit, Settings& settings){
  uint64_t index, signal_index, signal_value;
  std::string fresh_mask_signal_names;

	number_of_clock_cycles_ = settings.GetNumberOfClockCycles();
	if ((settings.GetEndConditionClockCycles()) &&
		((settings.GetEndConditionClockCycles() + 1 + settings.GetNumberOfWaitCycles()) < settings.GetEndConditionClockCycles()))
		number_of_clock_cycles_ = settings.GetEndConditionClockCycles() + 1 + settings.GetNumberOfWaitCycles();

    number_of_processed_simulations = 0;
    selected_groups_.resize(settings.GetNumberOfSimulationsPerStep());

    clock_signal_index_ = circuit.GetSignalIndexByName(settings.GetClockSignalName());

    always_random_inputs_rising_edge_indices_.resize(settings.GetNumberOfAlwaysRandomInputSignalsRisingEdge());
    for (index = 0; index < settings.GetNumberOfAlwaysRandomInputSignalsRisingEdge(); ++index) {
      fresh_mask_signal_names += "{";
      for (const std::string& signal_name : settings.GetAlwaysRandomInputRisingEdgeElement(index)) {
        signal_index = circuit.GetSignalIndexByName(signal_name);
        always_random_inputs_rising_edge_indices_[index].push_back(signal_index);
        fresh_mask_signal_names += signal_name + ", ";
      }

      if (fresh_mask_signal_names.length() > 2) {
        fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
      }

      fresh_mask_signal_names += "}, ";
    }
	
	if (fresh_mask_signal_names.length() > 2) {
		fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
		std::cout << "Successfully matched " << always_random_inputs_rising_edge_indices_.size() <<
			         " fresh mask signals (for rising edge) [" << fresh_mask_signal_names << "]." << std::endl;
	}

	fresh_mask_signal_names.clear();

	always_random_inputs_falling_edge_indices_.resize(settings.GetNumberOfAlwaysRandomInputSignalsFallingEdge());
	for (index = 0; index < settings.GetNumberOfAlwaysRandomInputSignalsFallingEdge(); ++index) {
		fresh_mask_signal_names += "{";
		for (const std::string& signal_name : settings.GetAlwaysRandomInputFallingEdgeElement(index)) {
			signal_index = circuit.GetSignalIndexByName(signal_name);
			always_random_inputs_falling_edge_indices_[index].push_back(signal_index);
			fresh_mask_signal_names += signal_name + ", ";
		}

		if (fresh_mask_signal_names.length() > 2) {
			fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
		}

		fresh_mask_signal_names += "}, ";
	}

    if (fresh_mask_signal_names.length() > 2) {
      fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
	  std::cout << "Successfully matched " << always_random_inputs_falling_edge_indices_.size() <<
		           " fresh mask signals (for falling edge) [" << fresh_mask_signal_names << "]." << std::endl;
    }

    for (const std::pair<std::string, bool>& end_condition_signal : settings.GetEndConditionSignalValuePairs()) {
      signal_index = circuit.GetSignalIndexByName(end_condition_signal.first);
      signal_value = end_condition_signal.second ? 0xffffffffffffffff : 0x0000000000000000;
      end_condition_signals_.emplace_back(signal_index, signal_value);
    }

    for (const std::pair<std::string, bool>& fault_detection_flag : settings.GetFaultDetectionSignalValuePairs()) {
      signal_index = circuit.GetSignalIndexByName(fault_detection_flag.first);
      signal_value = fault_detection_flag.second ? 0xffffffffffffffff : 0x0000000000000000;
      fault_detection_flags_.emplace_back(signal_index, signal_value);
    }

    output_share_signal_indices_.resize(settings.GetNumberOfOutputShares());

    uint64_t number_of_values, number_of_bits;

    for (uint64_t share_index = 0; share_index < settings.GetNumberOfOutputShares(); ++share_index) {
        number_of_bits = std::ceil(std::log2l(settings.output_finite_field.base)) * settings.output_finite_field.exponent;
        number_of_values = settings.GetNumberOfBitsPerOutputShare() / number_of_bits;
        output_share_signal_indices_[share_index].resize(number_of_values);

        for (uint64_t value_index = 0; value_index < number_of_values; ++value_index) {
            for (uint64_t bit_index = 0; bit_index < number_of_bits; ++bit_index) {
                output_share_signal_indices_[share_index][value_index].push_back(circuit.GetSignalIndexByName(settings.GetOutputShareName(share_index, value_index * number_of_bits + bit_index)));
            }
        }
    }

    if (settings.GetNumberOfExpectedOutputs() != 0 && settings.GetNumberOfOutputShares() != 0) {
      expected_unshared_output_values_.resize(settings.GetNumberOfGroups());
      for (uint64_t share_index = 0; share_index < settings.GetNumberOfGroups(); ++share_index) {
          number_of_bits = std::ceil(std::log2l(settings.output_finite_field.base)) * settings.output_finite_field.exponent;
          number_of_values = settings.GetNumberOfBitsPerOutputShare() / number_of_bits;
          expected_unshared_output_values_[share_index].resize(number_of_values);

          for (uint64_t value_index = 0; value_index < number_of_values; ++value_index) {
              for (uint64_t bit_index = 0; bit_index < number_of_bits; ++bit_index) {
                  expected_unshared_output_values_[share_index][value_index].push_back(settings.GetExpectedOutputBit(share_index, value_index * number_of_bits + bit_index));
              }
          }
      }
    }
}
