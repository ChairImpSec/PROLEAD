#include "Hardware/SampledRFAdversary.hpp"
#include "Util/Logger.hpp"
#include "Util/Util.hpp"
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <ostream>
#include <stdexcept>
#include <string>
#include <utility>

SampledRFAdversary::SampledRFAdversary(const Library &library,
                                       const CircuitStruct &circuit,
                                       const Settings &settings,
                                       Simulation &simulation,
                                       const size_t idx_adversary,
                                       Logger logger) :
  number_of_effective_cases_{0},
  number_of_effective_cases_per_thread_(settings.GetNumberOfThreads(), 0),
  library_{library},
  circuit_{circuit},
  settings_{settings},
  shared_data_{std::vector<SharedData>(settings.GetNumberOfThreads(), SharedData(circuit, settings))},
  shared_data_faulted_{std::vector<SharedData>(settings.GetNumberOfThreads(), SharedData(circuit, settings))},
  simulation_{simulation},
  fault_manager_{settings.fault_injection, circuit},
  logger_{logger}
{


  this->logger_.PrintInitialMessage(
    "Prepare statistical evaluation of adversary " +
    std::to_string(idx_adversary) +
    " in the general random fault model!"
  );

  // TODO: move all functions used to initialize the fault manage in the constructor of it.
  fault_manager_.SelectStrategyAndComputeAllFaults(simulation_.clock_signal_index_, idx_adversary);
  this->logger_.PrintInfoMessage(
    "All possible faults are derived from configuration file.\n"
  );

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

size_t SampledRFAdversary::CountEffectiveFaultInSimulation(//const std::vector<FaultSet> &fault_sets,
                                                        std::vector<boost::mt19937> &thread_rng,
                                                        size_t number_of_group_values,
                                                        size_t number_of_output_shares,
                                                        size_t output_element_size,
                                                        size_t thread_index,
                                                        size_t simulation_index,
                                                        std::vector<std::vector<std::vector<FaultType>>> &fault_type) {


  Hardware::Simulate::SimulateFaultedAndFaultFree2(//library_,
                                                  circuit_,
                                                  settings_,
                                                  shared_data_[thread_index],
                                                  shared_data_faulted_[thread_index],
                                                  simulation_,
                                                  simulation_index,
                                                  thread_rng[thread_index],
                                                  //fault_sets,
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
                                                    std::vector<std::mt19937>& gen_fault_combination
                                               ){


  #pragma omp parallel for schedule(guided)
  for (size_t simulation_index = 0;
       simulation_index < settings_.GetNumberOfVectorizedSimulationsPerStep();
       ++simulation_index) {

    size_t thread_index = omp_get_thread_num();
    std::vector<FaultSet> fault_sets;
    this->fault_manager_.SampleRandomFaultVector(gen_fault_combination[thread_index], fault_sets);

    const size_t number_of_signals = circuit_.NumberOfSignals;
    const size_t number_of_clock_cycles_ = settings_.GetNumberOfClockCycles();
    std::vector<std::vector<std::vector<FaultType>>> fault_type_(64, std::vector<std::vector<FaultType>>(number_of_signals, std::vector<FaultType>(number_of_clock_cycles_, FaultType::none))); // [bit_index][signal_index][clock_index]

    for(size_t bit_index = 0; bit_index < 64; ++bit_index){
      for (uint64_t index = 0; index < fault_sets[bit_index].GetNumberOfFaultsInSet(); ++index) {
        const Fault* fault = fault_sets[bit_index].GetFault(index);
        fault_type_[bit_index][fault->GetSignals()[0]->id][fault->GetCycle()] = fault->GetType();
      }

    }

    this->number_of_effective_cases_per_thread_[thread_index] += CountEffectiveFaultInSimulation(//fault_sets,
                                    thread_rng,
                                    number_of_group_values,
                                    number_of_output_shares,
                                    output_element_size,
                                    thread_index,
                                    simulation_index,
                                    fault_type_);

  }
}


void SampledRFAdversary::MergeMultithreadedResults(){
  size_t num_eff_faults_accumulation{0};
  for (const auto num : this->number_of_effective_cases_per_thread_) {
     num_eff_faults_accumulation += num;
  }
  this->number_of_effective_cases_ = num_eff_faults_accumulation;
}

void SampledRFAdversary::PrintDetailsOfAnalyisThatWillBeComputed() {
  std::vector<TableCell> table_cells_header{
    {"#Used Threads", 13},
    {"#Faults", 12},
    {"#Positions", 12},
    {"Confidence Level", 16},
    {"Fault Probability (min / max)", 30}
  };


  std::vector<TableCell> table_cells_row{
    {std::to_string(this->settings_.GetNumberOfThreads()),13},
    {std::to_string(this->fault_manager_.GetNumberOfFaults()), 12},
    {std::to_string(this->fault_manager_.GetNumberOfFaultsPerClockCycle()), 12},
    {std::to_string(this->settings_.GetConfidenceLevel()), 16},
    {
      std::to_string(fault_manager_.GetMinProbability()) +
      " / " +
      std::to_string(fault_manager_.GetMaxProbability()), 30
    }
    // {std::to_string(this->settings_.confidence), 30}
  };

  this->logger_.PrintInfoMessage("Properties of the analysis:");
  this->logger_.PrintHeader(table_cells_header);
  this->logger_.PrintRowWithSeparation(table_cells_row, true);
}

void SampledRFAdversary::EvaluateRandomFaultAdversary(){

  // Prepare timer
  StartClock(this->start_time_);

  // Prepare Multithreading
  omp_set_num_threads(settings_.GetNumberOfThreads());

  // Prepare Simulation
  std::vector<uint64_t> number_of_simulations_per_group(settings_.GetNumberOfGroups(), 0.0);
  std::vector<double> group_simulation_ratio(settings_.GetNumberOfGroups());
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

  PrintDetailsOfAnalyisThatWillBeComputed();

  simulation_.number_of_processed_simulations = 0;

  std::vector<std::mt19937> gen_fault_combination(settings_.GetNumberOfThreads());

  this->logger_.PrintInfoMessage("Analysis is starting...");
  this->logger_.PrintHeader(SampledRFAdversary::GetFinalReportHeader());

  for (size_t step_simulation_index = 0;
       step_simulation_index < settings_.GetNumberOfSimulationSteps();
       ++step_simulation_index) {
    MultithreadedAnalysis(thread_rng,
                        number_of_group_values,
                        number_of_output_shares,
                        output_element_size,
                        gen_fault_combination);
    simulation_.number_of_processed_simulations += settings_.GetNumberOfSimulationsPerStep();

    MergeMultithreadedResults();
    ComputeConfidenceInterval();
    ReportStep(step_simulation_index);


  }

  this->logger_.PrintInfoMessage("Analysis has finished!\n");
  Report();

}

void SampledRFAdversary::ComputeConfidenceInterval(){
  this->lower_bound_success_probability_ =
    boost::math::binomial_distribution<>::find_lower_bound_on_p(
      this->simulation_.number_of_processed_simulations,
      this->number_of_effective_cases_,
      (1-this->settings_.fault_injection.confidence_level)/2
    );

  this->upper_bound_success_probability_ =
    boost::math::binomial_distribution<>::find_upper_bound_on_p(
      this->simulation_.number_of_processed_simulations,
      this->number_of_effective_cases_,
      (1-this->settings_.fault_injection.confidence_level)/2
    );
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


std::vector<TableCell> SampledRFAdversary::GetFinalReportHeader(){
  std::vector<TableCell> table_cells_header{
    {"Elapsed Time", 18},
    {"Used Memory", 18},
    {"#Effective Faults", 17},
    {"Lower Bound", 11},
    {"Upper Bound", 11},
    {"Interval Size", 13}
  };
  return table_cells_header;
}

std::vector<TableCell> SampledRFAdversary::GetFinalReportRow(){
  const size_t precision{8};
  const uint64_t width_of_successes{static_cast<uint64_t>(std::ceil(std::log10(settings_.GetNumberOfSimulations())))};
  std::string trials =  std::to_string(this->simulation_.number_of_processed_simulations);
  if (width_of_successes - trials.size() > 0) {
    const std::string padding_of_trials = std::string(width_of_successes - trials.size() ,' ');
    trials = padding_of_trials + trials;
  }

  std::vector<TableCell> logging_row{
    this->logger_.GetTimeCell(EndClock(this->start_time_), 18),
    this->logger_.GetMemoryCell(GetUsedMemory(), 18),
    // TODO: we need to fix the width of the number of performed simulations
    TableCell(std::to_string(this->number_of_effective_cases_) + " / " + trials,17),
    TableCell(std::format("{:.{}f}",  lower_bound_success_probability_, precision),11),
    TableCell(std::format("{:.{}f}",  upper_bound_success_probability_, precision),11),
    TableCell(std::format("{:.{}f}",  upper_bound_success_probability_ - lower_bound_success_probability_, precision),13)
  };
  return logging_row;
}

void SampledRFAdversary::ReportStep(size_t step_simulation_index){
  std::vector<TableCell> logging_row = GetFinalReportRow();
  if (step_simulation_index == settings_.GetNumberOfSimulationSteps() - 1) {
    this->logger_.PrintRowWithSeparation(logging_row);
  }
  else{
    this->logger_.PrintRow(logging_row);
  }
}

void SampledRFAdversary::Report(){

  this->logger_.PrintInfoMessage("Final Report:");
  this->logger_.PrintHeader(SampledRFAdversary::GetFinalReportHeader());

  std::vector<TableCell> logging_row = SampledRFAdversary::GetFinalReportRow();

  this->logger_.PrintRowWithSeparation(logging_row, true);
  this->logger_.PrintFinalMessage("Evaluation done in " + std::to_string(EndClock(this->start_time_)) + " seconds.");
}

double SampledRFAdversary::GetLowerBound() const {
  return this->lower_bound_success_probability_;
}

double SampledRFAdversary::GetUpperBound() const {
  return this->upper_bound_success_probability_;
}
