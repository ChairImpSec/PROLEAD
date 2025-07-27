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
    // const FaultInjectionSettings *const fault_injection_settings,
    // const CircuitStruct *const circuit_to_be_faulted)
    const FaultInjectionSettings &fault_injection_settings,
    const CircuitStruct &circuit_to_be_faulted)
    : fault_injection_settings_(fault_injection_settings),
      circuit_to_be_faulted_(circuit_to_be_faulted), // nothing happens if not set
      size_of_fault_sets_(0)
      // fault_sets_(std::vector<std::unique_ptr<FaultSet>>(fault_injection_settings.number_of_fault_sets_per_step)),
    {
  //fault_sets_.reserve(fault_injection_settings_.number_of_fault_sets_per_step*fault_injection_settings_.clock_cycles.size());
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

// void FaultManager::ComputeAllFaultsExcludeFirst(
//     const std::function<void(const SignalStruct *const, uint64_t,
//                              uint64_t)>
//         AddFaultFunction,
//     const int *const elements, const uint64_t number_of_elements,
//     const uint64_t clock_signal_index, const std::regex &include_elements,
//     const std::regex &exclude_elements) {
//
//   for (uint64_t i = 0; i < number_of_elements; ++i) {
//
//     const uint64_t index_of_gate = elements[i];
//     const CellStruct *const cell =
//         this->circuit_to_be_faulted_->Cells[index_of_gate];
//     const uint64_t number_of_outputs = cell.NumberOfOutputs;
//
//     for (uint64_t j = 0; j < number_of_outputs; ++j) {
//
//       const uint64_t signal_index = cell.Outputs[j];
//       const SignalStruct *const signal =
//           this->circuit_to_be_faulted_->Signals[signal_index];
//
//       // NOTE: Default is include in this case:
//       // 1. Check if it is allowed to fault the signal of the circuit
//       // 2. If the signal is not excluded include it
//       // 3. If the signal is excluded, but included, include it.
//       //    This is modled by the ||.
//       if (this->circuit_to_be_faulted_->IsFaultOnSignalAllowed(
//               signal_index, clock_signal_index) &&
//           (!std::regex_match(std::string(signal.Name), exclude_elements) ||
//            std::regex_match(std::string(signal.Name), include_elements))) {
//
//         for (auto clock_cycle :
//         this->fault_injection_settings_->clock_cycles) {
//           AddFaultFunction(signal, signal_index, clock_cycle);
//         }
//       }
//     }
//   }
// }
//


// Function to calculate and store all valid combinations up to r (size of one combination)
void FaultManager::ComputeCombinations(const std::vector<FaultLUT>& fault_types, uint64_t r_max, std::vector<std::vector<std::vector<std::vector<uint64_t>>>>& combination_table) {
  uint64_t n = fault_types.size(); // n = number of faults
  combination_table.assign(r_max + 1, std::vector<std::vector<std::vector<uint64_t>>>(n + 1));

  // Initialize base case
  combination_table[0][0].push_back(std::vector<uint64_t>(n, 0));

  // Fill the combination table up to r_max
  for (uint64_t ip = 1; ip <= n; ++ip) {  // For each probability (here called group)
    for (uint64_t j = 0; j <= r_max; ++j) {  // For each number of fault location count up to r_max
      combination_table[j][ip] = combination_table[j][ip - 1];

      // Select x faults from group i-1
      for (uint64_t x = 1; x <= fault_types[ip - 1].g && x <= j; ++x) {
        for (const auto& comb : combination_table[j - x][ip - 1]) {
          auto newComb = comb;
          newComb[ip - 1] = x;  // Set k_i = x for the current group
          combination_table[j][ip].push_back(newComb);
        }
      }
    }
  }
}

// Function to get combinations for a specific r using the precomputed table
std::vector<std::vector<uint64_t>> FaultManager::GetCombinationsForR(const std::vector<std::vector<std::vector<std::vector<uint64_t>>>>& combination_table, uint64_t r, uint64_t n) {
    return combination_table[r][n];  // Return all combinations for exactly 'r' faults across 'n' groups
}

// combination consists of n integers.
// each counting the number of elements in this combination from group i.
double FaultManager::ComputeProbabilityOfOneCombination(const std::vector<uint64_t> &combination,
                                          const std::vector<FaultLUT> &fault_types){

  const uint64_t n{combination.size()};

  double probability_of_combination{1};
  for (uint64_t i = 0; i < n; ++i) {
    const double gi = fault_types[i].g;
    const double ki = combination[i];
    const double pi = fault_types[i].p;
    // const double npi = fault_types[i].np;

    // std::cout << "i: " << i << " gi: " << gi << " ki: " << ki << std::endl;
    // const double giki = boost::math::binomial_coefficient<double>(gi, ki);
    // const double pki  = std::pow(pi, ki);
    // const double npki = std::pow(npi, (gi-ki));

    boost::math::binomial distribution_comb(gi, pi);
    probability_of_combination *= pdf(distribution_comb, ki);
    // std::cout << probability_of_combination << std::endl;
    // std::cout << giki * pki * npki << std::endl;
  }

  return probability_of_combination;
}

double FaultManager::ComputeProbabilityOfAnyCombinationToOccur(uint64_t r_min, uint64_t r_max, const std::vector<FaultLUT> &fault_types, const std::vector<std::vector<std::vector<std::vector<uint64_t>>>>& combination_table){

  double total_p{0};
  // Retrieve combinations for each r <= r_max
  for (uint64_t r = r_min; r <= r_max; ++r) {
    std::vector<std::vector<uint64_t>> combinations = GetCombinationsForR(combination_table, r, fault_types.size());

    // std::cout << "Combinations for r = " << r << ":\n";
    for (const auto& comb : combinations) {

      // std::cout << "(";
      // for (uint64_t i = 0; i < comb.size(); ++i) {
      //   std::cout << comb[i] << (i < comb.size() - 1 ? ", " : "");
      // }
      // std::cout << ")\n";

      const double prob_k0kn = ComputeProbabilityOfOneCombination(comb, fault_types);

      // std::cout << prob_k0kn << std::endl;

      total_p+=prob_k0kn;
    }
  }
  return total_p;
}


double FaultManager::ComputeProbabilityOfNoCombinationToOccur(const std::vector<FaultLUT> & fault_types){

  double not_p{1};
  for (const auto& fault_type : fault_types) {
    not_p *= std::pow(fault_type.np, fault_type.g);
  }

  return not_p;
}


void FaultManager::DetermineProbabilityOfNonEvaluatedFaultSets(){
  // Precompute all combinations up to r_max
  // FIXME: when changing behavior of cycles adopt the second parameter
  uint64_t r_max = this->faults_at_cycle_.cbegin()->second.size();
  uint64_t r_min = this->max_order_of_fault_set_to_be_evaluated+1;
  //FIXME: Is it required that rmin > rmax? when all sets should be evaluated.
  std::cout << "\tAssume no simulations for:\n\t\trmin: " << r_min << "\n\t\trmax " << r_max << std::endl;
  std::vector<std::vector<std::vector<std::vector<uint64_t>>>> combination_table;

  FaultManager::ComputeCombinations(this->similar_faults_, r_max, combination_table);

  this->probability_of_non_evaluated_fault_sets_ =
    FaultManager::ComputeProbabilityOfAnyCombinationToOccur(r_min, r_max, this->similar_faults_, combination_table);
  this->probability_of_no_fault_to_occur_ =
    FaultManager::ComputeProbabilityOfNoCombinationToOccur(this->similar_faults_);
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


    // TODO: here I want to compute the probability of an effectivly faulted circuit,
    // assuming that all fault_set with |fault_set| > settings.max_size_of_combinations
    similar_faults_.emplace_back(number_of_added_faults, fault_property.probability);
  }


  // TODO: add testcase for this!
  if(RedundantFaultLocation()){
    throw std::invalid_argument("It is not allowed to fault one location two times within a single attack!");
  }

  // All faults are created, thus we can init a vector by the size of faults.

  // BUG: This is not working anymore:
  // Since we have to generate fault combination per cycle,
  // we have to take the size of the vector holding all faults of a single cycle.
  // Luckily, all faults are used in all specified cycles.
  // Therefore, we do not have to resize this vector for each clock cycle!
  const auto first_element = faults_at_cycle_.cbegin();
  // combination_generation_state_ = std::vector<bool>(first_element->second.size(), false);

  // for (const auto &fault_template : similar_faults_) {
  //   std::cout << "\nG: " << fault_template.g <<
  //     "\tp: " << fault_template.p <<
  //     "\tnp: " << fault_template.np << "\n"
  //     << std::endl;
  // }

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

double FaultManager::GetProbabilityOfNonEvaluatedFaultSets() const{
  return this->probability_of_non_evaluated_fault_sets_;
}

double FaultManager::GetProbabilityOfNoFaultToOccur() const{
  return this->probability_of_no_fault_to_occur_;
}

uint64_t FaultManager::GetMaxOrderOfFaultSet() const {
  return this->max_order_of_fault_set_to_be_evaluated;
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

void FaultManager::SetSizeOfFaultSets(uint64_t size_of_fault_sets){
  if (size_of_fault_sets > this->faults_at_cycle_.cbegin()->second.size()) {
    throw std::runtime_error("We cannot construct fault sets with " +
                             std::to_string(size_of_fault_sets) +
                             " elements were only " +
                            std::to_string(this->faults_at_cycle_.cbegin()->second.size())+
                             " faults are available! ");
  }
  this->size_of_fault_sets_ = size_of_fault_sets;
}

void FaultManager::RegisterFaultSetGenerator(){
  // TODO: might not be required since after completing all combinations the first state is
  // restored -> only the first size_of_combinations bit are true, therefore we add just one true
  // position one index later

  std::fill(this->combination_generation_state_.begin(),
            this->combination_generation_state_.end(),
            false);
  std::fill(this->combination_generation_state_.begin(),
            this->combination_generation_state_.begin() + this->size_of_fault_sets_,
            true);
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

