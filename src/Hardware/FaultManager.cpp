/**
 * @file FaultManager.cpp
 * @brief Implementation of the FaultManager class.
 *
 * @version 0.0.1
 * @date 2024-08-02
 *
 * @author Felix Uhle
 */

#include "Hardware/FaultManager.hpp"

#include <functional>
#include <regex>
#include <stdexcept>

#include "Util/Types.hpp"

FaultManager::FaultManager(
    // const FaultInjectionSettings *const fault_injection_settings,
    // const CircuitStruct *const circuit_to_be_faulted)
    const FaultInjectionSettings &fault_injection_settings,
    const CircuitStruct &circuit_to_be_faulted)
    : fault_injection_settings_(fault_injection_settings),
      circuit_to_be_faulted_(circuit_to_be_faulted) {}

void FaultManager::AddStuckAtZeroFault(const SignalStruct *const signal,
                                       uint64_t signal_index,
                                       uint64_t clock_cycle,
                                       double fault_probability) {
  auto fault = std::make_unique<StuckAtZeroFault>(
      signal, signal_index, clock_cycle, fault_probability);
  stuck_at_zero_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::AddStuckAtOneFault(const SignalStruct *const signal,
                                      uint64_t signal_index,
                                      uint64_t clock_cycle,
                                      double fault_probability) {
  auto fault = std::make_unique<StuckAtOneFault>(
      signal, signal_index, clock_cycle, fault_probability);
  stuck_at_one_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::AddToggleFault(const SignalStruct *const signal,
                                  uint64_t signal_index, uint64_t clock_cycle,
                                  double fault_probability) {
  auto fault = std::make_unique<ToggleFault>(signal, signal_index, clock_cycle,
                                             fault_probability);
  toggle_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::ComputeAllFaults(
    const std::function<void(const SignalStruct *const, uint64_t, uint64_t)>
        AddFaultFunction,

    const std::function<bool(const std::string &, const std::regex &,
                             const std::regex &)>
        IncludeStrategy,
    std::vector<uint64_t> elements, const uint64_t number_of_elements,
    const uint64_t clock_signal_index, const std::regex &include_elements,
    const std::regex &exclude_elements) {
  for (uint64_t i = 0; i < number_of_elements; ++i) {
    const uint64_t index_of_gate = elements[i];
    const CellStruct *const cell =
        &this->circuit_to_be_faulted_.cells_[index_of_gate];
    const uint64_t number_of_outputs = cell->type->GetNumberOfOutputs();

    for (uint64_t j = 0; j < number_of_outputs; ++j) {
      const uint64_t signal_index = cell->Outputs[j];
      const SignalStruct *const signal =
          &this->circuit_to_be_faulted_.signals_[signal_index];

      if (this->circuit_to_be_faulted_.IsFaultOnSignalAllowed(
              signal_index, clock_signal_index) &&
          IncludeStrategy(std::string(signal->Name), include_elements,
                          exclude_elements))
      // std::regex_match(std::string(signal->Name), include_elements) &&
      // !std::regex_match(std::string(signal->Name), exclude_elements))
      {
        for (auto clock_cycle : this->fault_injection_settings_.clock_cycles) {
          AddFaultFunction(signal, signal_index, clock_cycle);
        }
      }
    }
  }
}

// TODO: somehow prevent that clock_signal_index must be parsed!
// Easy step would be to give FaultManager access to hardware settigns.
// Even better would be to give Circuit access to hardware/circuit settings,
// which would prevent that clock_signal_index must be given to the circuit,
// which is stupid since the Circuit Object should be aware of which wire is the
// clock signal!
void FaultManager::SelectStrategyAndComputeAllFaults(
    uint64_t clock_signal_index) {
  for (const auto &fault_property :
       this->fault_injection_settings_.fault_properties) {
    // Check if parameter are set as desired
    if (fault_property.probability <= 0 || fault_property.probability > 1) {
      throw std::invalid_argument(
          "FaultProperties.probability must be in range [0,1]");
    }

    const std::function<void(const SignalStruct *const, uint64_t, uint64_t)>
        AddFaultFunction{ChoseAddFaultFunction(fault_property)};

    // std::function<void(FaultManager*,SignalStruct*, uint64_t, uint64_t,
    // double)> AddFault;
    //  No Lambda

    const std::function<bool(const std::string &, const std::regex &,
                             const std::regex &)>
        IncludeStrategy{
            DetermineIncludeStrategy(fault_property.locations.first_include)};

    if (fault_property.fault_logic_gates) {
      // TODO: replace function<> stuff with templates? Might be faster?
      ComputeAllFaults(AddFaultFunction, IncludeStrategy,
                       this->circuit_to_be_faulted_.gates_,
                       this->circuit_to_be_faulted_.gates_.size(),
                       clock_signal_index,
                       fault_property.locations.included_elements,
                       fault_property.locations.excluded_elements);
    }

    std::vector<uint64_t> elements;
    for (uint64_t idx = 0; idx < this->circuit_to_be_faulted_.regs_.size();
         ++idx) {
      elements.push_back(this->circuit_to_be_faulted_.regs_[idx]);
    }

    if (fault_property.fault_storage_gates) {
      ComputeAllFaults(AddFaultFunction, IncludeStrategy, elements,
                       this->circuit_to_be_faulted_.regs_.size(),
                       clock_signal_index,
                       fault_property.locations.included_elements,
                       fault_property.locations.excluded_elements);
    }
  }
}

const Fault *FaultManager::GetFault(uint64_t index) const {
  return faults_[index].get();
}

const std::vector<std::unique_ptr<const Fault>> &FaultManager::GetFaults()
    const {
  return faults_;
}

uint64_t FaultManager::GetNumberOfFaults() const { return faults_.size(); }

const std::vector<StuckAtZeroFault const *> &
FaultManager::GetStuckAtZeroFaults() const {
  return stuck_at_zero_faults_;
}

const std::vector<StuckAtOneFault const *> &FaultManager::GetStuckAtOneFaults()
    const {
  return stuck_at_one_faults_;
}

const std::vector<ToggleFault const *> &FaultManager::GetToggleFaults() const {
  return toggle_faults_;
}

const std::function<void(const SignalStruct *const, uint64_t, uint64_t)>
FaultManager::ChoseAddFaultFunction(const FaultProperties &fault_property) {
  switch (fault_property.fault_type) {
    case FaultType::stuck_at_0:
      return [this, &fault_property](const SignalStruct *const signal,
                                     uint64_t signal_index,
                                     uint64_t clock_signal_index) {
        AddStuckAtZeroFault(signal, signal_index, clock_signal_index,
                            fault_property.probability);
      };
      // AddFault = &FaultManager::AddStuckAtZeroFault; // No Lambda
      break;

    case FaultType::stuck_at_1:
      return [this, &fault_property](const SignalStruct *const signal,
                                     uint64_t signal_index,
                                     uint64_t clock_signal_index) {
        AddStuckAtOneFault(signal, signal_index, clock_signal_index,
                           fault_property.probability);
      };
      break;

    case FaultType::toggle:
      return [this, &fault_property](const SignalStruct *const signal,
                                     uint64_t signal_index,
                                     uint64_t clock_signal_index) {
        AddToggleFault(signal, signal_index, clock_signal_index,
                       fault_property.probability);
      };
      break;

    default:
      throw std::invalid_argument(
          "The FaultType of all FaultProperties must be "
          "set to a valid FaultType. Valid FaultTypes are "
          "StuckAtZero, StuckAtOne, and Toggle");
  }
}

const std::function<bool(const std::string &, const std::regex &,
                         const std::regex &)>
FaultManager::DetermineIncludeStrategy(bool first_include) {
  if (first_include) {
    return [](const std::string signal_name, const std::regex include_elements,
              const std::regex exclude_elements) {
      return (std::regex_match(signal_name, include_elements) &&
              !std::regex_match(signal_name, exclude_elements));
    };
  } else {
    return [](const std::string signal_name, const std::regex include_elements,
              const std::regex exclude_elements) {
      // NOTE: Default is include in this case:
      // 1. Check if it is allowed to fault the signal of the circuit
      // 2. If the signal is not excluded include it
      // 3. If the signal is excluded, but included, include it.
      //    This is modled by the ||.
      return (!std::regex_match(signal_name, exclude_elements) ||
              std::regex_match(signal_name, include_elements));
    };
  }
}

// void GenerateFaultSets(uint64_t)
