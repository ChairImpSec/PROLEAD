#include "Hardware/Circuit.hpp"

// TODO: add to circuit.cpp
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
    return Cells[Signals[signal_index]->Output]->type->GetNumberOfInputs();
  }
}

std::vector<uint64_t> Hardware::CircuitStruct::GetSignals() const {
  std::vector<uint64_t> result;
  int cell_index, output_index;

  result.push_back(0);
  result.push_back(1); 
  result.push_back(2);
  result.push_back(3); 
  result.push_back(4);
  result.push_back(5);

  for (cell_index = 0; cell_index < NumberOfInputs; ++cell_index) {
    result.push_back(Inputs[cell_index]);
  }

  for (cell_index = 0; cell_index < NumberOfRegs; ++cell_index) {
    for (output_index = 0;
         output_index < (int)Cells[Regs[cell_index]]->type->GetNumberOfOutputs();
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
           (int)Cells[CellsInDepth[depth_index][cell_index]]->type->GetNumberOfOutputs();
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

  if ((Signals[signal_index]->Output == -1) || Cells[Signals[signal_index]->Output]->type->IsRegister()) {
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

  if ((Signals[signal_index]->Output == -1) || Cells[Signals[signal_index]->Output]->type->IsRegister()) {
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
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_elements)) {
          Signals[index]->is_probe_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
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
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
        Signals[index]->is_probe_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.locations.included_elements)) {
          Signals[index]->is_probe_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
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
        if (!Cells[Signals[index]->Inputs[input_index]]->type->IsRegister()){
          Signals[index]->is_probe_allowed = false;
          break;
        }
      }
    }

    if (settings.IsRelaxedModel()) {
      uint64_t signal_index;
      for (uint64_t index = 0; index < number_of_signals; ++index) {
        if (Signals[index]->is_probe_allowed) {
          signal_index = index;
          
          while ((Signals[signal_index]->Output != -1) && (GetNumberOfInputsForSignalsComputingCell(signal_index) == 1) && (!Signals[signal_index]->Deleted)){
            signal_index = Cells[Signals[signal_index]->Output]->Inputs[0];
          }

          if (Signals[signal_index]->Output != -1) {
            Signals[signal_index]->is_probe_allowed = true;
          }
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
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_elements)) {
          Signals[index]->is_extension_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
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
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
        Signals[index]->is_extension_allowed = false;
      } else {
        signal_name = Signals[index]->Name;
        if (std::regex_match(signal_name, settings.side_channel_analysis.extension.included_elements)) {
          Signals[index]->is_extension_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((Signals[index]->Output == -1) || Cells[Signals[index]->Output]->type->IsRegister()) {
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


// NOTE: Global inputs are not allowed to be faulted!
// TODO: I would prefer to switch to pointer here!
bool Hardware::CircuitStruct::IsFaultOnSignalAllowed(
    size_t signal_index, size_t clock_signal_index) const{

  return !Signals[signal_index]->Deleted &&
         (signal_index != clock_signal_index) &&
         Signals[signal_index]->Type != SignalType_input;
}
