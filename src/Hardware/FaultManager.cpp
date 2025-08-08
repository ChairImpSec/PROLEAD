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
#include "Util/Types.hpp"
#include <algorithm>
#include <functional>
#include <memory>
#include <regex>
#include <stdexcept>
#include <boost/math/special_functions/binomial.hpp>
#include <boost/math/distributions/binomial.hpp>
#include <string>
#include <strings.h>
#include <unordered_set>

FaultManager::FaultManager(
    const FaultInjectionSettings &fault_injection_settings,
    const CircuitStruct &circuit_to_be_faulted)
    : fault_injection_settings_(fault_injection_settings),
      circuit_to_be_faulted_(circuit_to_be_faulted), // nothing happens if not set
      size_of_fault_sets_(0)
    {
}

void FaultManager::AddStuckAtZeroFault(
    const SignalStruct& signal, uint64_t signal_index,
    uint64_t clock_cycle, double fault_probability) {

  auto fault = std::make_unique<StuckAtZeroFault>(&signal, signal_index, clock_cycle, fault_probability);
  stuck_at_zero_faults_.push_back(fault.get());
  faults_at_cycle_[clock_cycle].push_back(fault.get());
  // TODO: should we change the order here? first faults_ than stuck_at_X_faults_?
  faults_.push_back(std::move(fault));
}

void FaultManager::AddStuckAtOneFault(
    const SignalStruct& signal, uint64_t signal_index,
    uint64_t clock_cycle, double fault_probability) {

  auto fault = std::make_unique<StuckAtOneFault>(
      &signal, signal_index, clock_cycle, fault_probability);
  stuck_at_one_faults_.push_back(fault.get());
  faults_at_cycle_[clock_cycle].push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::AddToggleFault(const SignalStruct& signal,
                                  uint64_t signal_index, uint64_t clock_cycle,
                                  double fault_probability) {

  auto fault = std::make_unique<ToggleFault>(&signal, signal_index, clock_cycle,
                                             fault_probability);
  toggle_faults_.push_back(fault.get());
  faults_at_cycle_[clock_cycle].push_back(fault.get());
  faults_.push_back(std::move(fault));
}

uint64_t FaultManager::ComputeAllFaults(
    const std::function<void(const SignalStruct&, uint64_t, uint64_t)> AddFaultFunction,
    const std::function<bool(const std::string &, const std::regex &, const std::regex &)> IncludeStrategy,
    const std::vector<uint64_t>& elements, const uint64_t number_of_elements,
    const uint64_t clock_signal_index, const std::regex &include_elements,
    const std::regex &exclude_elements) {


  // each cycles has the same number of faults.
  uint64_t number_of_added_faults{0};
  for (uint64_t i = 0; i < number_of_elements; ++i) {

    const uint64_t index_of_gate = elements[i];
    const CellStruct& cell =
        this->circuit_to_be_faulted_.cells_[index_of_gate];
    const uint64_t number_of_outputs = cell.expr_.size();
    // const std::string cell_name = std::string(cell.Name);

    for (uint64_t j = 0; j < number_of_outputs; ++j) {

      const int signal_index = cell.Outputs[j];
      // FIXME: I have no clue when this happens, but is required to prevent 0xffff...ffff (-1)
      // as signal index
      if(signal_index == -1){
        continue;
      }
      const SignalStruct& signal =
          this->circuit_to_be_faulted_.signals_[signal_index];


      const bool signal_name_given = false;
      if(signal_name_given){
        if (
          this->circuit_to_be_faulted_.IsFaultOnSignalAllowed(signal_index, clock_signal_index) &&
          IncludeStrategy(std::string(signal.Name), include_elements, exclude_elements)
        )
        // std::regex_match(std::string(signal.Name), include_elements) &&
        // !std::regex_match(std::string(signal.Name), exclude_elements))
        {
          // TODO: it makes probably more sense to use set clock cycles per fault property
          // (in settings.hpp)
          for (auto clock_cycle : this->fault_injection_settings_.clock_cycles) {

            // NOTE: the first cycle is prolead internal clock cycle 0!
            AddFaultFunction(signal, signal_index, (clock_cycle-1));
          }

          ++number_of_added_faults;
        }
      }
      else{
        if (
          this->circuit_to_be_faulted_.IsFaultOnSignalAllowed(signal_index, clock_signal_index) &&
          IncludeStrategy(std::string(cell.Name), include_elements, exclude_elements)
        )
        // std::regex_match(std::string(signal.Name), include_elements) &&
        // !std::regex_match(std::string(signal.Name), exclude_elements))
        {
          // TODO: it makes probably more sense to use set clock cycles per fault property
          // (in settings.hpp)
          for (auto clock_cycle : this->fault_injection_settings_.clock_cycles) {

            // NOTE: the first cycle is prolead internal clock cycle 0!
            AddFaultFunction(signal, signal_index, (clock_cycle-1));
          }

          ++number_of_added_faults;
        }

      }
    }
  }

  return number_of_added_faults;
}

// FIXME: This is temporary and the comparsion should be integrated into Fault itself!
bool FaultManager::RedundantFaultLocation() const {

  std::map<std::pair<uint64_t, uint64_t>, bool> seenKeys;
  for (const auto& fault: this->faults_) {
    std::pair<uint64_t, uint64_t> key{fault->GetFaultedSignalIndex(), fault->GetFaultedClockCycle()};
    if(seenKeys.find(key) != seenKeys.end()){
      return true;
    }
    seenKeys[key] = true;
  }

  return false;
}

// TODO: somehow prevent that clock_signal_index must be parsed!
// Easy step would be to give FaultManager access to hardware settigns.
// Even better would be to give Circuit access to hardware/circuit settings,
// which would prevent that clock_signal_index must be given to the circuit,
// which is stupid since the Circuit Object should be aware of which wire is the
// clock signal!
void FaultManager::SelectStrategyAndComputeAllFaults(
    uint64_t clock_signal_index, uint64_t idx_adversary) {

  for (const auto &fault_property :
       this->fault_injection_settings_.fault_adversaries[idx_adversary]) {

    // Check if parameter are set as desired
    if (fault_property.probability <= 0 || fault_property.probability >= 1) {
      throw std::invalid_argument(
          "FaultProperties.probability must be in range (0,1)");
    }

    const std::function<void(const SignalStruct&, uint64_t, uint64_t)>
        AddFaultFunction({ChoseAddFaultFunction(fault_property)});
    this->max_fault_probability_ = std::max(this->max_fault_probability_, fault_property.probability);
    this->min_fault_probability_ = std::min(this->min_fault_probability_, fault_property.probability);

    // std::function<void(FaultManager*,SignalStruct*, uint64_t, uint64_t,
    // double)> AddFault;
    //  No Lambda

    const std::function<bool(const std::string &, const std::regex &,
                             const std::regex &)>
        IncludeStrategy{DetermineIncludeStrategy(fault_property.locations.first_include)};

    uint64_t number_of_added_faults{0};
    // TODO: add a unittest to check if faults are generated as expected
    if (fault_property.fault_logic_gates) {
      // TODO: replace function<> stuff with templates? Might be faster?
      number_of_added_faults = ComputeAllFaults(AddFaultFunction, IncludeStrategy,
                       this->circuit_to_be_faulted_.gates_,
                       this->circuit_to_be_faulted_.gates_.size(),
                       clock_signal_index,
                       fault_property.locations.included_elements,
                       fault_property.locations.excluded_elements);
    }

    if (fault_property.fault_storage_gates) {
      number_of_added_faults += ComputeAllFaults(
          AddFaultFunction, IncludeStrategy, this->circuit_to_be_faulted_.regs_,
          this->circuit_to_be_faulted_.regs_.size(), clock_signal_index,
          fault_property.locations.included_elements,
          fault_property.locations.excluded_elements);
    }
  }


  // TODO: add testcase for this!
  if(RedundantFaultLocation()){
    throw std::invalid_argument("It is not allowed to fault one location two times within a single attack!");
  }

}



const Fault *FaultManager::GetFault(uint64_t index) const {
  return faults_[index].get();
}

const std::map<uint64_t,std::vector<Fault const *>>& FaultManager::GetCycleToFaultMap() const {
  return this->faults_at_cycle_;
}
const std::vector<Fault const *>& FaultManager::GetFaultInCycle(uint64_t clock_cycle) const {
  auto it = this->faults_at_cycle_.find(clock_cycle);
  if (it != this->faults_at_cycle_.end()) {
    return it->second; // Return a reference to the vector of faults for the specific cycle
  } else {
    throw std::runtime_error("Tried to access clock_cycles for which no faults where injected!");
    // static const std::vector<Fault const *> emptyVector; // Static empty vector for no faults
    // return emptyVector; // Return a reference to an empty vector if no faults are found
  }
}

const std::vector<std::unique_ptr<Fault>> &
FaultManager::GetFaults() {
  return faults_;
}

const std::vector<std::unique_ptr<FaultSet>> &
FaultManager::GetFaultSets() const {
  return fault_sets_;
}

uint64_t FaultManager::GetNumberOfFaults() const { return faults_.size(); }
uint64_t FaultManager::GetNumberOfFaultsPerClockCycle() const { return faults_at_cycle_.begin()->second.size(); }

const std::vector<StuckAtZeroFault const *> &
FaultManager::GetStuckAtZeroFaults() const {
  return stuck_at_zero_faults_;
}

const std::vector<StuckAtOneFault const *> &
FaultManager::GetStuckAtOneFaults() const {
  return stuck_at_one_faults_;
}

const std::vector<ToggleFault const *> &FaultManager::GetToggleFaults() const {
  return toggle_faults_;
}


double FaultManager::GetMaxProbability() const {
  return this->max_fault_probability_;
}
double FaultManager::GetMinProbability() const{
  return this->min_fault_probability_;
}

const std::function<void(const SignalStruct&, uint64_t, uint64_t)>
FaultManager::ChoseAddFaultFunction(const FaultProperties& fault_property) {

  switch (fault_property.fault_type) {
  case FaultType::stuck_at_0:
    return [this, &fault_property](const SignalStruct& signal,
                                   uint64_t signal_index,
                                   uint64_t clock_signal_index) {
      AddStuckAtZeroFault(signal, signal_index, clock_signal_index,
                          fault_property.probability);
    };
    // AddFault = &FaultManager::AddStuckAtZeroFault; // No Lambda
    break;

  case FaultType::stuck_at_1:
    return [this, &fault_property](const SignalStruct& signal,
                                   uint64_t signal_index,
                                   uint64_t clock_signal_index) {
      AddStuckAtOneFault(signal, signal_index, clock_signal_index,
                         fault_property.probability);
    };
    break;

  case FaultType::toggle:
    return [this, &fault_property](const SignalStruct& signal,
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

// TODO: write docu
// TODO: Write testcase
FaultSet FaultManager::SampleRandomFault(std::mt19937 &gen){

  std::vector<const Fault *> fault_set_elements;
  for(auto& fault : this->faults_){
    // const double probabilities[] = {
    //   fault->GetNotFaultProbability(), fault->GetFaultProbability()
    // };
    std::bernoulli_distribution dist(fault->GetFaultProbability());
    if(dist(gen)){
      fault_set_elements.push_back(fault.get());
      // std::cout << "Cycle: " << fault->GetFaultedClockCycle();
      // std::cout << "\nSignal: " << fault->GetFaultedSignalIndex();
      // std::cout << std::endl;
    }
  }

  return FaultSet(fault_set_elements);
}

void FaultManager::SampleRandomFaultVector(std::mt19937 &gen, std::vector<FaultSet> &fault_sets){
  constexpr uint64_t state_size = 64;
  fault_sets.clear();
  fault_sets.reserve(state_size);
  for (uint64_t i = 0; i < state_size; ++i) {
    fault_sets.emplace_back(SampleRandomFault(gen));
  }
}

