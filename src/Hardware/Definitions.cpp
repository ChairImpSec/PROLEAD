#include "Hardware/Definitions.hpp"

bool Hardware::CircuitStruct::IsGateThatOutputsSignalDeleted(int signal_index) {
  return Cells[Signals[signal_index]->Output]->Deleted == 1;
}

uint64_t Hardware::CircuitStruct::GetNumberOfInputsForSignalsComputingCell(
    uint64_t signal_index) const {
  if (Signals[signal_index]->Output == -1) {
    std::string error_message =
        "Tried to access a cell that computes \"" +
        (std::string)Signals[signal_index]->Name + "\". As  \"" +
        (std::string)Signals[signal_index]->Name +
        "\" is a primary input, such a cell cannot be found!";
    throw std::logic_error(error_message);
  } else {
    return Cells[Signals[signal_index]->Output]->NumberOfInputs;
  }
}

std::vector<uint64_t> Hardware::CircuitStruct::GetSignals() const {
  std::vector<uint64_t> result;
  int cell_index, output_index;

  result.push_back(0); // Add 1'b0 and 1'b1
  result.push_back(1); // TODO: Change

  for (cell_index = 0; cell_index < NumberOfInputs; ++cell_index) {
    result.push_back(Inputs[cell_index]);
  }

  for (cell_index = 0; cell_index < NumberOfRegs; ++cell_index) {
    for (output_index = 0;
         output_index < Cells[Regs[cell_index]]->NumberOfOutputs;
         ++output_index) {
      if (Cells[Regs[cell_index]]->Outputs[output_index] != -1) {
        result.push_back(Cells[Regs[cell_index]]->Outputs[output_index]);
      }
    }
  }

  for (short depth_index = 1; depth_index <= MaxDepth; ++depth_index) {
    for (cell_index = 0; cell_index < NumberOfCellsInDepth[depth_index];
         ++cell_index) {
      for (output_index = 0;
           output_index <
           Cells[CellsInDepth[depth_index][cell_index]]->NumberOfOutputs;
           ++output_index) {
        result.push_back(Cells[CellsInDepth[depth_index][cell_index]]
                             ->Outputs[output_index]);
      }
    }
  }

  return result;
}

uint64_t Hardware::CircuitStruct::GetSignalIndexByName(const std::string& signal_name){
  uint64_t index, number_of_signals = NumberOfSignals;
  std::string current_signal_name;

  for (index = 0; index < number_of_signals; ++index) {
    current_signal_name = Signals[index]->Name;

    if (current_signal_name == signal_name) {
      return index;
    }
  }

  if (index == number_of_signals) {
    throw std::logic_error("Error while searching a signal. The signal \"" + signal_name + "\" could not be found!");
  }

  return 0;
}

void Hardware::CircuitStruct::PropagateProbe(Library& library, uint64_t signal_index, const bool allowed) {
  uint64_t input_index;
  Signals[signal_index]->is_probe_allowed = allowed;
  
  if ((Signals[signal_index]->Output == -1) || library.IsCellRegister(Cells[Signals[signal_index]->Output]->Type)) {
    Signals[signal_index]->is_probe_allowed = false;
  } else {
    for (uint64_t index = 0; index < GetNumberOfInputsForSignalsComputingCell(signal_index); ++index) {
      input_index = Cells[Signals[signal_index]->Output]->Inputs[index];
      PropagateProbe(library, input_index, allowed);
    }
  }
}

void Hardware::CircuitStruct::PropagateExtension(Library& library, uint64_t signal_index, const bool allowed) {
  uint64_t input_index;
  Signals[signal_index]->is_extension_allowed = allowed;
  
  if ((Signals[signal_index]->Output == -1) || library.IsCellRegister(Cells[Signals[signal_index]->Output]->Type)) {
    Signals[signal_index]->is_extension_allowed = false;
  } else {
    for (uint64_t index = 0; index < GetNumberOfInputsForSignalsComputingCell(signal_index); ++index) {
      input_index = Cells[Signals[signal_index]->Output]->Inputs[index];
      PropagateExtension(library, input_index, allowed);
    }
  }
}

void Hardware::CircuitStruct::SetIsProbeAllowed(Library& library, const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  std::string signal_name;

  if (settings.side_channel_analysis.locations.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_probe_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_elements)) {
          Signals[index]->is_probe_allowed = true;
        }  
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_paths)) {
          PropagateProbe(library, index, true);
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.locations.excluded_elements)) {
        Signals[index]->is_probe_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.locations.excluded_paths)) {
        PropagateProbe(library, index, false);
      }      
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_probe_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.locations.excluded_elements)) {
        Signals[index]->is_probe_allowed = false;
      }      
    }   

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.locations.excluded_paths)) {
        PropagateProbe(library, index, false);
      }      
    }  

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_elements)) {
          Signals[index]->is_probe_allowed = true;
        }  
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_paths)) {
          PropagateProbe(library, index, true);
        }
      }
    }  
  } 

  if (settings.GetMinimization() != Minimization::none) {
    for (uint64_t index = 0; index < number_of_signals; ++index) { 
      uint64_t number_of_inputs = Signals[index]->NumberOfInputs;
      for (uint64_t input_index = 0; input_index < number_of_inputs; ++input_index) {
        if (!library.IsCellRegister(Cells[Signals[index]->Inputs[input_index]]->Type)){
          Signals[index]->is_probe_allowed = false;
          break;
        }
      }
    }  
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {  
    if (Signals[index]->Deleted) {
      Signals[index]->is_probe_allowed = false;
    }
  }
}

void Hardware::CircuitStruct::SetIsExtensionAllowed(Library& library, const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  std::string signal_name;

  if (settings.side_channel_analysis.extension.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_extension_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_elements)) {
          Signals[index]->is_extension_allowed = true;
        }  
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_paths)) {
          PropagateExtension(library, index, true);
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.extension.excluded_elements)) {
        Signals[index]->is_extension_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.extension.excluded_paths)) {
        PropagateExtension(library, index, false);
      }      
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_extension_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.extension.excluded_elements)) {
        Signals[index]->is_extension_allowed = false;
      }      
    }   

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.extension.excluded_paths)) {
        PropagateExtension(library, index, false);
      }      
    }  

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_elements)) {
          Signals[index]->is_extension_allowed = true;
        }  
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      if ((Signals[index]->Output == -1) || library.IsCellRegister(Cells[Signals[index]->Output]->Type)) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_paths)) {
          PropagateExtension(library, index, true);
        }
      }
    }   
  }  

  for (uint64_t index = 0; index < number_of_signals; ++index) {  
    if (Signals[index]->Deleted) {
      Signals[index]->is_extension_allowed = false;
    }
  }
}

void Hardware::CircuitStruct::SetIsAnalysisAllowed(const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  uint64_t number_of_constants = NumberOfConstants;
  std::string signal_name;

  if (settings.side_channel_analysis.analysis.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_analysis_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.analysis.included_elements)) {
        Signals[index]->is_analysis_allowed = true;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.analysis.excluded_elements)) {
        Signals[index]->is_analysis_allowed = false;
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_analysis_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.analysis.excluded_elements)) {
        Signals[index]->is_analysis_allowed = false;
      }      
    }   

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.side_channel_analysis.analysis.included_elements)) {
        Signals[index]->is_analysis_allowed = true;
      }
    }   
  }  

  for (uint64_t index = 0; index < number_of_constants; ++index) {
    Signals[index]->is_analysis_allowed = false;
  }

  std::string with_point = "." + settings.GetClockSignalName();

  for (uint64_t index = 0; index < number_of_signals; ++index) {  
    signal_name = Signals[index]->Name;
    if (signal_name == settings.GetClockSignalName() || signal_name.find(with_point) != std::string::npos) {
      Signals[index]->is_analysis_allowed = false;
    }
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {  
    if (Signals[index]->Deleted) {
      Signals[index]->is_analysis_allowed = false;
    }
  }  
}

void Hardware::CircuitStruct::SetIsFaultAllowed(const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  std::string signal_name;

  if (settings.fault_injection.locations.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_fault_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.fault_injection.locations.included_elements)) {
        Signals[index]->is_fault_allowed = true;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.fault_injection.locations.excluded_elements)) {
        Signals[index]->is_fault_allowed = false;
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      Signals[index]->is_fault_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.fault_injection.locations.excluded_elements)) {
        Signals[index]->is_fault_allowed = false;
      }      
    }   

    for (uint64_t index = 0; index < number_of_signals; ++index) {  
      signal_name = Signals[index]->Name;
      if (std::regex_match(signal_name, settings.fault_injection.locations.included_elements)) {
        Signals[index]->is_fault_allowed = true;
      }
    }   
  }  

  for (uint64_t index = 0; index < number_of_signals; ++index) {  
    if (Signals[index]->Deleted) {
      Signals[index]->is_fault_allowed = false;
    }
  } 

  // TODO set clock signal to false
}


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

    always_random_inputs_indices_.resize(settings.GetNumberOfAlwaysRandomInputSignals());
    for (index = 0; index < settings.GetNumberOfAlwaysRandomInputSignals(); ++index) {
      fresh_mask_signal_names += "{";
      for (const std::string& signal_name : settings.GetAlwaysRandomInputElement(index)) {
        signal_index = circuit.GetSignalIndexByName(signal_name);
        always_random_inputs_indices_[index].push_back(signal_index);
        fresh_mask_signal_names += signal_name + ", ";
      }

      if (fresh_mask_signal_names.length() > 2) {
        fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
      }

      fresh_mask_signal_names += "}, ";
    }

    if (fresh_mask_signal_names.length() > 2) {
      fresh_mask_signal_names.erase(fresh_mask_signal_names.length() - 2);
    }

    std::cout << "Successfully matched " << always_random_inputs_indices_.size() << " fresh mask signals [" << fresh_mask_signal_names << "]." << std::endl;

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
