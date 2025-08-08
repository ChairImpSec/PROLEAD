/**
 * @file ConservativeRFAdversary.hpp
 * @brief Declaration of the ConservativeRFAdversary class.
 *
 * @version 0.0.1
 * @date 2024-08-02
 *
 * @author Felix Uhle
 *
 */

#pragma once

#include "Hardware/FaultManager.hpp"
#include "Hardware/Library.hpp"
#include "Hardware/SharedData.hpp"
#include "Hardware/Simulate.hpp"
#include <Hardware/Logger.hpp>
#include "Util/Util.hpp"

#include "boost/random.hpp"
#include <boost/math/distributions/binomial.hpp>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

#include <cstddef>
#include <cstdint>
#include <omp.h>
#include <vector>
#include <format>


/**
 * @class ConservativeRFAdversary
 * @brief This class defines and implments the evaluation logic to verify security against a
 * conservative random fault adversary
 *
 */
class SampledRFAdversary {

public:
  SampledRFAdversary(const Library &library,
                          const CircuitStruct &circuit,
                          const Settings &settings,
                          Simulation &simulation,
                          const size_t idx_adversary,
                          Logger logger);



  void EvaluateRandomFaultAdversary();

  void Report();
  void ReportStep(size_t step_simulation_index);

  void WriteJsonOutput(size_t idx_adversary);

  double GetUpperBound() const;
  double GetLowerBound() const;
  static std::vector<TableCell> GetFinalReportHeader();

private:

  void MultithreadedAnalysis(std::vector<boost::mt19937>& thread_rng,
                              size_t number_of_group_values,
                              size_t number_of_output_shares,
                              size_t output_element_size,
                              std::vector<std::mt19937>& gen_fault_combination);

  void MergeMultithreadedResults();

  void ComputeConfidenceInterval();

  void PrintDetailsOfAnalyisThatWillBeComputed();

  std::vector<TableCell> GetFinalReportRow();

  size_t CountEffectiveFaultsInSimulatedVector(size_t number_of_group_values,
                                             size_t number_of_output_shares,
                                             size_t output_element_size,
                                             size_t thread_index) const;


  size_t CountEffectiveFaultInSimulation(const std::vector<FaultSet> &fault_sets,
                                       std::vector<boost::mt19937> &thread_rng,
                                       size_t number_of_group_values,
                                       size_t number_of_output_shares,
                                       size_t output_element_size,
                                       size_t thread_index,
                                       size_t simulation_index,
                                       std::vector<std::vector<std::vector<FaultType>>> &fault_type);


  /**
   * @brief The lower bound of the probability of the adversary to succesfully
   * inject a effective fault.
   *
   * Summation of guaranteed_success_probability and
   * lower_bound_part_success_probability.
   */
  double lower_bound_success_probability_;

  /**
   * @brief The upper bound of the probability of the adversary to succesfully
   * inject a effective fault.
   *
   * Summation of guaranteed_success_probability and
   * upper_bound_part_success_probability.
   */
  double upper_bound_success_probability_;

  /**
   * @brief Used to count the total number of fault combinations,
   * which are effective in at least one simulation.
   *
   * If one fault combinations causes an effective fault for more than one simulation it is only
   * counted once.
   */
  size_t number_of_effective_cases_;
  std::vector<size_t> number_of_effective_cases_per_thread_;

  /**
   * @brief The library_ used by the golden and faulty simulation.
   *
   * TODO: this should be a member variable of the simulator,
   * which should be itself a class.
   */
  const Library & library_;

  /**
   * @brief The circuit used by simulator to simulate the circuit.
   *
   * TODO: this should be a member variable of the simulator,
   * which should be itself a class.
   */
  const CircuitStruct &circuit_;

  /**
   * @brief Settings which define the strategy to evaluate the adversary.
   */
  const Settings &settings_;

  std::vector<SharedData> shared_data_;

  std::vector<SharedData> shared_data_faulted_;

  Simulation &simulation_; // I do not like this here!

  /**
   * @brief The FaultManager used by the Adversary to manage all possible fault combinations.
   */
  FaultManager fault_manager_;


  /**
   * @brief The time at which the analysis has started
   */
  struct timespec start_time_;

  Logger logger_;

};
