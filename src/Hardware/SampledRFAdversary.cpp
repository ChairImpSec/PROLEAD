#include "Hardware/SampledRFAdversary.hpp"
#include "Util/Util.hpp"
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <ostream>
#include <stdexcept>
#include <utility>

SampledRFAdversary::SampledRFAdversary(const Library &library,
                                                 const CircuitStruct &circuit,
                                                 const Settings &settings,
                                                 Simulation &simulation,
                                                 const size_t idx_adversary) :
  number_of_effective_cases_{0},
  library_{library},
  circuit_{circuit},
  shared_data_{std::vector<SharedData>(settings.GetNumberOfThreads(), SharedData(circuit, settings))},
  shared_data_faulted_{std::vector<SharedData>(settings.GetNumberOfThreads(), SharedData(circuit, settings))},
  settings_{settings},
  simulation_{simulation},
  number_of_effective_cases_per_thread_(settings.GetNumberOfThreads(), 0),
  fault_manager_{settings.fault_injection, circuit}
{


  // TODO: move all functions used to initialize the fault manage in the constructor of it.
  fault_manager_.SelectStrategyAndComputeAllFaults(simulation_.clock_signal_index_, idx_adversary);
  // NOTE: DEBUG print only
  // for(const auto &f  : fault_manager_.GetFaults()){
  //
  //   std::cout << circuit_.signals_[f->GetFaultedSignalIndex()].Name << std::endl;;
  // }

	simulation_.is_simulation_faulty_ = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  for (size_t index = 0; index < settings_.GetNumberOfSimulationsPerStep() >> 6; ++index){
    simulation_.is_simulation_faulty_[index] = 0;
  }
}

size_t SampledRFAdversary::CountEffectiveFaultsInSimulatedVector(size_t number_of_group_values,
                                                                size_t number_of_output_shares,
                                                                size_t output_element_size,
                                                                size_t thread_index) const {


  // std::cout << "D: ";
  size_t number_of_faults{0};
  uint64_t all_differences_in_simulation_outputs{0};
  for (size_t value_index = 0; value_index < number_of_group_values; ++value_index) {
    for (size_t share_index = 0; share_index < number_of_output_shares; ++share_index) {
      for (size_t bit_index = 0; bit_index < output_element_size; ++bit_index) {

        // std::cout << "Value Index: " << value_index;
        // std::cout << "\nShare Index: " << share_index;
        // std::cout << "\nBit Index: " << bit_index;
        // std::cout << std::endl;
        uint64_t difference_in_one_output_of_simulations =
        (this->shared_data_[thread_index].signal_values_[simulation_.output_share_signal_indices_[share_index][value_index][bit_index]] ^
         this->shared_data_faulted_[thread_index].signal_values_[simulation_.output_share_signal_indices_[share_index][value_index][bit_index]]);

        // std::cout << "Dif: " << difference_in_one_output_of_simulations  << std::endl;
        all_differences_in_simulation_outputs |= difference_in_one_output_of_simulations;


      }
    }
  }

  // NOTE: use this if you want to count the number of faults!
  while (all_differences_in_simulation_outputs) {
    // std::cout << (all_differences_in_simulation_outputs & 1) << ", ";
    if(all_differences_in_simulation_outputs & 1) {
      ++number_of_faults;
    }
    all_differences_in_simulation_outputs = all_differences_in_simulation_outputs >> 1;

  }
  // std::cout << "CNT: " << number_of_faults << std::endl;

  // std::cout << std::endl;
  return number_of_faults;
}

size_t SampledRFAdversary::CountEffectiveFaultInSimulation(const std::vector<FaultSet> &fault_sets,
                                                        std::vector<boost::mt19937> &thread_rng,
                                                        size_t number_of_group_values,
                                                        size_t number_of_output_shares,
                                                        size_t output_element_size,
                                                        size_t thread_index,
                                                        size_t simulation_index,
                                                        std::vector<std::vector<std::vector<FaultType>>> &fault_type) {


  Hardware::Simulate::SimulateFaultedAndFaultFree2(library_,
                                                  circuit_,
                                                  settings_,
                                                  shared_data_[thread_index],
                                                  shared_data_faulted_[thread_index],
                                                  simulation_,
                                                  simulation_index,
                                                  thread_rng[thread_index],
                                                  fault_sets,
                                                  thread_index,
                                                  fault_type);

  return SampledRFAdversary::CountEffectiveFaultsInSimulatedVector(number_of_group_values,
                                                                  number_of_output_shares,
                                                                  output_element_size,
                                                                  thread_index);
}



void SampledRFAdversary::MultithreadedAnalysis(std::vector<boost::mt19937>& thread_rng,
                                                    size_t number_of_group_values,
                                                    size_t number_of_output_shares,
                                                    size_t output_element_size,
                                                    timespec &start_time){

  // Start Multithreading
  //
  // TODO: is this okay to be used in multithreaded environment?
  // std::vector<boost::mt19937> gen_fault_combination(settings_.GetNumberOfThreads());
  std::vector<std::mt19937> gen_fault_combination(settings_.GetNumberOfThreads());
  const size_t max_num_steps = (settings_.GetNumberOfSimulations() / settings_.GetNumberOfSimulationsPerStep());
  const size_t max_num_sims  = (settings_.GetNumberOfSimulationsPerStep() / 64);

  #pragma omp parallel for schedule(guided)
  for (size_t step_simulation_index = 0;
       step_simulation_index < max_num_steps;
       ++step_simulation_index) {

    size_t thread_index = omp_get_thread_num();
    std::vector<FaultSet> fault_sets;

    for (size_t simulation_index = 0;
         simulation_index < max_num_sims;
         ++simulation_index) {

      if(thread_index == 0){
        std::cout << "[" << std::setw(10) << EndClock(start_time) << "]";
        std::cout << " Step: " << std::setw(std::to_string(max_num_steps).length()) <<
          step_simulation_index << "/" << max_num_steps - 1;
        std::cout << ", Simulation: " << std::setw(std::to_string(max_num_sims).length()) <<
          simulation_index << "/" << max_num_sims - 1 << std::endl;
      }



      this->fault_manager_.SampleRandomFaultVector(gen_fault_combination[thread_index], fault_sets);
      // std::cout << "F: ";
      // for (const auto & fs : fault_sets) {
      //   std::cout << fs.GetNumberOfFaultsInSet() << ", ";
      // }
      // std::cout << std::endl;
      // std::cout << "FaultSets are selected!" << std::endl;

      const size_t number_of_signals = circuit_.NumberOfSignals;
      const size_t number_of_clock_cycles_ = settings_.GetNumberOfClockCycles();
      std::vector<std::vector<std::vector<FaultType>>> fault_type_(64, std::vector<std::vector<FaultType>>(number_of_signals, std::vector<FaultType>(number_of_clock_cycles_, FaultType::none))); // [bit_index][signal_index][clock_index]

      for(size_t bit_index = 0; bit_index < 64; ++bit_index){

        for (uint64_t index = 0; index < fault_sets[bit_index].GetNumberOfFaultsInSet(); ++index) {
          const Fault* fault = fault_sets[bit_index].GetFault(index);
          fault_type_[bit_index][fault->GetFaultedSignalIndex()][fault->GetFaultedClockCycle()] = fault->GetFaultType();
        }

      }

      this->number_of_effective_cases_per_thread_[thread_index] += CountEffectiveFaultInSimulation(fault_sets,
                                      thread_rng,
                                      number_of_group_values,
                                      number_of_output_shares,
                                      output_element_size,
                                      thread_index,
                                      simulation_index,
                                      fault_type_);

      // std::cout << "Effective Cases are computed!" << std::endl;
    }
  }
}


void SampledRFAdversary::MergeMultithreadedResults(){
  for (const auto num : this->number_of_effective_cases_per_thread_) {
    // std::cout << "Thread: " << num << std::endl;
    this->number_of_effective_cases_ += num;
  }
}


void SampledRFAdversary::EvaluateRandomFaultAdversary(){

  // Prepare timer
  struct timespec start_time;
  StartClock(start_time);

  // TODO: should we use a new logger e.g. the boost one?
  // Add a output for the folder which both simulators use as destination.

  // 1. For all FaultSets (implement this using some iterator!):
  // 1.1 Simulate golden circuit for x inputs   (in Simulate.cpp)
  // 1.2 Simulate faulty circuit for x inputs   (in Simulate.cpp)
  // 1.3 For each golden_sim != faulty_sim:
  // 1.3.1 increase counter of current FaultSet
  // 1.4 if FaultSet.number_of_effective_simulations_ > 0:
  // 1.4.1 guaranteed_success_probability_ += FaultSet.fault_probability
  // 1.5 else
  // 1.5.1 Compute confidence intervall (pl, pu) using tries: x, hits: 0, given confidence level.
  // 1.5.2 update lower_bound_part_success_probability_ += (pl*FaultSet.fault_probability) = 0;
  // 1.5.2 update upper_bound_part_success_probability_ += (pu*FaultSet.fault_probability);
  // 2. compute lower_bound_success_probability_ = guaranteed_success_probability_ +
  //                                              lower_bound_part_success_probability_   ;
  // 3. compute upper_bound_success_probability_ = guaranteed_success_probability_ +
  //                                              upper_bound_part_success_probability_   ;

  // std::cout << "[ ] Determine probability of |fault_set_| > max_size_of_combinations..." << std::endl;
  // fault_manager_.DetermineProbabilityOfNonEvaluatedFaultSets();
  // std::cout << "[+] Probability of |fault_set_| > max_size_of_combinations determined!" << std::endl;

  std::cout << "[ ] Prepare simulation engin..." << std::endl;
  // Prepare Multithreading
  omp_set_num_threads(settings_.GetNumberOfThreads());
  // simulation_.fault_set_ = std::vector<FaultSet *>(settings_.GetNumberOfThreads(), nullptr);


  // TODO: use for testcase
  // std::cout <<  "Faults: " << fault_manager_.GetNumberOfFaults() << std::endl;
  // boost::mt19937 gen;
  // double average =0;
  // for (size_t i =0 ; i < 1000000; ++i) {
  //   const FaultSet fs = this->fault_manager_.SampleRandomFault(gen);
  //   average += fs.GetNumberOfFaultsInSet();
  // }
  // std::cout << average/1000000 << std::endl;
  // return;

  // Prepare Simulation
  std::vector<uint64_t> number_of_simulations_per_group(settings_.GetNumberOfGroups(), 0.0);
  std::vector<double_t> group_simulation_ratio(settings_.GetNumberOfGroups());
  std::vector<boost::mt19937> thread_rng(settings_.GetNumberOfThreads());
  GenerateThreadRng(thread_rng, settings_.GetNumberOfThreads());// We use a PRNG that is thread safe


  // Retrive size of output elements to be checked
  size_t output_element_size = std::ceil(std::log2l(settings_.output_finite_field.base)) * settings_.output_finite_field.exponent;
  size_t number_of_output_shares = simulation_.output_share_signal_indices_.size();
  size_t number_of_group_values;

  if (number_of_output_shares) {
     number_of_group_values = simulation_.output_share_signal_indices_[0].size();
  } else {
    throw std::invalid_argument("At least one output is required which should be checked for faults!");
  }
  std::cout << "[+] Simulation enging is prepared with:" << std::endl;
  std::cout << "\tNumber of shares :"  << number_of_output_shares << std::endl;
  std::cout << "\tNumber of groups :"  << number_of_group_values << std::endl;
  std::cout << "\tNumber of bits :"  << output_element_size << std::endl;

  std::cout << "[+] Available fault locations: " << fault_manager_.GetNumberOfFaults();
  std::cout << "\n\t" << "Cycles:" << this->settings_.fault_injection.clock_cycles.size();
  std::cout << "\n\t"  << "fault_positions: " << this->fault_manager_.GetNumberOfFaultsPerClockCycle();
  std::cout << std::endl;

  simulation_.number_of_processed_simulations = 0;

  MultithreadedAnalysis(thread_rng,
                        number_of_group_values,
                        number_of_output_shares,
                        output_element_size,
                        start_time);

  MergeMultithreadedResults();

  this->lower_bound_success_probability_ =
    boost::math::binomial_distribution<>::find_lower_bound_on_p(
      this->settings_.GetNumberOfSimulations(),
      this->number_of_effective_cases_,
      (1-this->settings_.fault_injection.confidence_level)/2
    );

  this->upper_bound_success_probability_ =
    boost::math::binomial_distribution<>::find_upper_bound_on_p(
      this->settings_.GetNumberOfSimulations(),
      this->number_of_effective_cases_,
      (1-this->settings_.fault_injection.confidence_level)/2
    );


  Report(start_time);
}


void SampledRFAdversary::WriteJsonOutput(size_t idx_adversary) {
    boost::property_tree::ptree root;

    // Add Effective Faults
    root.put("number_of_effective_faults", this->number_of_effective_cases_);

    // Non-Correctable Fault Probabilities (all cycles)
    boost::property_tree::ptree nonCorrectableAllCyclesTree;
    nonCorrectableAllCyclesTree.put("p_l", this->lower_bound_success_probability_);
    nonCorrectableAllCyclesTree.put("p_u", this->upper_bound_success_probability_);
    root.add_child("probability_faults_non_correctable", nonCorrectableAllCyclesTree);

    // Write to JSON file
    boost::property_tree::write_json("output_sampled_"+std::to_string(idx_adversary)+".json", root);
}


void SampledRFAdversary::Report(timespec &start_time){

  std::cout << "\n\n-------------------- Evaluation Completed --------------------" << std::endl;
  std::cout << "\t Computation Time: " << EndClock(start_time) << " seconds!" << std::endl;
  std::cout << "\t Individual Faults: " << fault_manager_.GetFaults().size() << std::endl;
  std::cout << "\t Faulted Cycles: " ;
  for (const auto& clk : settings_.fault_injection.clock_cycles){
      std::cout << "\n\t\t" << clk;
  }
  std::cout << std::endl;

  std::cout << "\t Effective Faults Per Thread: ";
  for (const auto& num : this->number_of_effective_cases_per_thread_) {
    std::cout << "\n\t\t" << num;
  }
  std::cout << std::endl;

  std::cout << "\t Effective Faults Total: ";
  std::cout << "\n\t\t Success " << this->number_of_effective_cases_;
  std::cout << "\n\t\t Trials " << this->settings_.GetNumberOfSimulations();
  std::cout << std::endl;

  const size_t precision{8};
  // 1. Here the assumption is that the faults are induced in each clock cycle.
  // Adversary tries each cycle
  std::cout << "\n\n\tProbability faults lead to non correctable fault: ";
  std::cout << std::setprecision(precision) << "\n\t\tp_l: " << lower_bound_success_probability_;
  std::cout << std::setprecision(precision) << "\n\t\tp_u: " << upper_bound_success_probability_;

  std::cout << "\n-------------------------------------------------------------\n" << std::endl;

}

double SampledRFAdversary::GetLowerBound() const {
  return this->lower_bound_success_probability_;
}

double SampledRFAdversary::GetUpperBound() const {
  return this->upper_bound_success_probability_;
}
