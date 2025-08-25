#pragma once

#include <omp.h>

#include <algorithm>
#include <boost/dynamic_bitset.hpp>
#include <boost/math/special_functions/binomial.hpp>
#include "Hardware/Enabler.hpp"
#include "Hardware/FaultManager.hpp"
#include "Hardware/ProbingSets.hpp"
#include "Util/Logger.hpp"

namespace Hardware {
/**
 * This class defines all possible adversaries under the desired adversary
 * (probing or fault) model.
 */

class Adversaries {
 public:
  std::string topmodule_name_;
  const Library& library_;
  const CircuitStruct& circuit_;
  const Settings& settings_;
  Simulation& simulation_;
  boost::property_tree::ptree report_;

  void PrintProbeReport() const;
  void PrintLeakageReport(uint64_t fault_idx, uint64_t step_idx) const;

  /**
   * @brief Constructs the adversaries.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  Adversaries(Library& library, CircuitStruct& circuit, Settings& settings, Simulation& simulation, const std::string& topmodule_name);
  
  void PrintSummary();

  uint64_t GetNumberOfSpots();

  uint64_t GetNumberOfEnablers();

  const Enabler& GetEnabler(uint64_t index) const;

  const std::vector<Enabler>& GetEnablers() const;

  double Eval(std::vector<SharedData>& shared_data);


  void SetProbes();  

  private:
    std::vector<Probe> probes_;
    std::vector<Enabler> enabler_;
    std::vector<const Probe*> placed_probes_;
    std::vector<const Probe*> extensions_;

    void CompactTableUpdate(uint64_t sim_idx, std::vector<uint64_t>& counters);
    void CompactRobustTest(std::vector<double>& group_simulation_ratio);
    void CompactRelaxedTest(std::vector<double>& group_simulation_ratio);
    void NormalTest(std::vector<double>& group_simulation_ratio);

    double GetMaximumLeakage();
    uint64_t GetNumberOfRequiredTraces() const;
    bool IsInDistance(const std::vector<const Probe*>& probes) const;
    void EvalProbingSets(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t fault_idx, uint64_t step_idx);
    void RemoveProbingSetsWithEnoughTraces(uint64_t number_of_simulations, double& maximum_g_value_deleted, std::string& printed_probing_set_deleted);
    double EvalProbingSetsUnderFaults(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t step_idx);
    double EvalCombinations(std::vector<SharedData>& shared_data, timespec& start_time, const std::vector<std::vector<bool>>& combinations);


  //Printer<ExtensionContainer> printer_;


  /**
   * The list of all standard probes, i.e. all probes that the adversary can
   * place.
   */
  std::vector<Probe> standard_probes_;

  /**
   * The list of all extended probes, i.e. all probes that can be set by
   * extending the standard probes.
   */
  std::vector<Probe> extended_probes_;

  std::vector<UniqueProbe> unique_probes_;

  /**
   * The list of all unique probes. Only required in the compact mode.
   */
  // std::vector<UniqueProbe> unique_probes_;

  std::vector<ProbingSet> probing_sets_;

  /**
   * The list of all fault targets, i.e. all possible locations where a fault
   * injection is allowed.
   */
  FaultManager fault_manager_;

  uint64_t GetProbingSetColumnSize();

  void SetSpots(CircuitStruct& circuit);

  /**
   * To create the standard probes we use the probe-extensions and extend it
   * with a notion of time. This leads to a list of all standard probes which
   * are considered.
   *
   * @brief Sets all possible standard probes
   * @author Nicolai Müller
   */
  void SetStandardProbes();

  /**
   * To create a list of extended probes we go thorugh the probe extensions and
   * consider all extensions extended by a notion of time.
   * This leads to a list of all extended probes which are considered.
   *
   * @brief Sets all possible extended probes
   * @author Nicolai Müller
   */
  void SetExtendedProbes();

  /**
   *
   * @brief Sets all possible unique probes
   * @author Nicolai Müller
   */
  void SetUniqueProbes();

  void SetEnablers();

  void SetConsideredSimulations(
      std::vector<uint64_t>& number_of_simulations_per_group);

  /**
   * To create a list of unique probes we go thorugh the probe extensions and
   * and set in which probing sets the extended probe occurrs.
   *
   * @brief Sets all unique probes
   * @author Nicolai Müller
   */
  // void SetUniqueProbes();

  /**
   * @brief Finds all relevant positions for injecting faults
   * @author Aykan Yüce
   */
  void SetFaults();

  /**
   * @brief Removes duplicated and strictly-less informative probing sets.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void RemoveUninformativeProbingSets();

  /**
   * @brief Removes duplicated and strictly-less informative probing sets in a
   * univariate setting.
   * @param number_of_probing_sets The number of probing sets.
   * @author Nicolai Müller
   */
  void RemoveUninformativeProbingSetsInUnivariateSetting(
      uint64_t number_of_probing_sets);

  /**
   * @brief Removes duplicated probing sets.
   * @author Nicolai Müller
   */
  void RemoveDuplicatedProbingSets();

  /**
   * For the robust d-probing model, we can remove all probing sets which
   * contain the same probes as another probing set. The reason is that such
   * sets give the adversary strictly less information than another advsary
   * already has. We remark that it is not always possible to jointly-compare
   * all probing sets. Hence, we allow to compare only parts of the list of
   * probing sets.
   *
   * @brief Removes strictly less informative probing sets.
   * @param start The first element in the list of probing sets to compare.
   * @param end The last element in the list of probing sets to compare.
   * @author Nicolai Müller
   */
  void RemoveStrictlyLessInformativeProbingSets(uint64_t start, uint64_t end);

  /**
   * @brief Removes all probing sets which are strictly less informative then
   * one probing set.
   * @param set_index The index of the probing set which should cover the other
   * sets.
   * @param start The first element in the list of probing sets to compare.
   * @param end The last element in the list of probing sets to compare.
   * @author Nicolai Müller
   */
  void RemoveOneStrictlyLessInformativeProbingSet(uint64_t set_index,
                                                  uint64_t start, uint64_t end);

  /**
   * @brief Returns the highest clock cycle in which a probe in a probing set
   * records.
   * @param probing_set_index The index of the probing set to check.
   * @return The highest clock cycle in which a probe in the probing sets
   * records.
   * @author Nicolai Müller
   */
  uint64_t GetHighestClockCycleOfSet(uint64_t probing_set_index);

  /**
   * @brief Initializes the combination data structure for the fault set
   * generation..
   * @param settings The settings read from the config file.
   * @param combination The data structure storing the fault-target indices
   * of a new fault set.
   * @param combination_bitmask A bitmask where a set bit indicates that one
   * fault target is part of the fault set.
   * @author Aykan Yüce
   */
  void InitializeFaultCombinations(uint64_t number_of_faults_per_run,
                                   std::vector<uint64_t>& combiantion,
                                   std::vector<bool>& bitmask);

  void InitializeUnivariateProbeCombinations(std::vector<Probe*>& addresses,
                                             std::vector<bool>& bitmask);

  void InitializeMultivariateProbeCombinations(
      std::vector<Probe*>& addresses, std::vector<bool>& combination_bitmask);


  /**
   * @brief Performs the evaluation procedure of PROLEAD.
   * @param settings The settings read from the config file.
   * @param simulation The simulations to update.
   * @param number_of_simulations_per_group The number of processed simulations
   * per group.
   * @param is_in_compact_mode True if the evaluation is in compact mode, False
   * if not.
   * @author Nicolai Müller
   */
  void Test(std::vector<double>& number_of_simulations_per_group,
            bool is_in_compact_mode);



    ProbingSet const* GetMostLeakingSet(const std::vector<bool>& bitmask) const;

    void PrintEvaluationBody(const std::vector<TableCell>& header, double max_p_value_deleted, const std::string& printed_probing_set_deleted, timespec& start_time) const;

  /**
   * @brief Prints the evaluation report.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param simulation The simulations to update.
   * @param probe_step_index The iteration count of PROLEAD.
   * @param space The space required to print the probing set with the longest
   * output string.
   * @author Nicolai Müller
   */
  void PrintReport(CircuitStruct& circuit, Settings& settings,
                   Simulation& simulation, uint64_t probe_step_index,
                   uint64_t space);
};
}  // namespace Hardware