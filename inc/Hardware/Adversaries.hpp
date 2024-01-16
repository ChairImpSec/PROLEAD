#pragma once

#include <omp.h>

#include <cinttypes>
#include <iostream>
#include <vector>

#include "Hardware/Faulting.hpp"
#include "Hardware/Probing.hpp"

namespace Hardware {
/**
 * This class defines all possible adversaries under the desired adversary
 * (probing or fault) model.
 */
template <typename ExtensionContainer>
class Adversaries {
 public:
  /**
   * @brief Constructs the adversaries.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  Adversaries(LibraryStruct& library, CircuitStruct& circuit,
              SettingsStruct& settings);

  /**
   * @brief Returns the number of probe-extensions.
   * @return The number of probe-extensions.
   * @author Nicolai Müller
   */
  size_t GetNumberOfProbeExtensions();

  /**
   * @brief Returns the number of standard probes.
   * @return The number of standard probes.
   * @author Nicolai Müller
   */
  size_t GetNumberOfStandardProbes();

  /**
   * @brief Returns the number of extended probes.
   * @return The number of extended probes.
   * @author Nicolai Müller
   */
  size_t GetNumberOfExtendedProbes();

  /**
   * @brief Returns the number of unique probes.
   * @return The number of unique probes.
   * @author Nicolai Müller
   */
  size_t GetNumberOfUniqueProbes();

  /**
   * @brief Returns the number of fault targets.
   * @return The number of fault targets.
   * @author Nicolai Müller
   */
  size_t GetNumberOfFaultTargets();

  /**
   * @brief Evaluates all adversaries under the robust d-probing model
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @return The maximum leakage.
   * @author Nicolai Müller
   */
  double EvaluateRobustProbingSecurity(LibraryStruct& library,
                                     CircuitStruct& circuit,
                                     SettingsStruct& settings,
                                     SharedDataStruct* shared_data,
                                     SimulationStruct& simulation);

 private:
  /**
   * The list of all probe extensions required to create the other lists of
   * probes.
   */
  std::vector<Hardware::probing::ProbeExtension<ExtensionContainer>>
      probe_extensions_;

  /**
   * The list of all standard probes, i.e. all probes that the adversary can
   * place.
   */
  std::vector<Hardware::probing::Probe> standard_probes_;

  /**
   * The list of all extended probes, i.e. all probes that can be set by
   * extending the standard probes.
   */
  std::vector<Hardware::probing::Probe> extended_probes_;

  /**
   * The list of all unique probes. Only required in the compact mode.
   */
  std::vector<Hardware::probing::UniqueProbe> unique_probes_;

  /**
   * The list of all probing sets.
   * Every probing set is based on standard and extended probes.
   * To save memory, every probing set just stores the indices of probes in
   * standard_probes_ or extended_probes_.
   */
  std::vector<Hardware::probing::ProbingSet<ExtensionContainer>> probing_sets_;

  /**
   * The list of all fault targets, i.e. all possible locations where a fault
   * injection is allowed.
   */
  std::vector<Hardware::faulting::FaultTarget> fault_targets_;

  /**
   * This function finds all relevant positions for standard probes.
   * For example, for the robust probing model, only probes on register inputs
   * and primary outputs are necessary. Afterwards, it glitch-propagates the
   * probe to its extensions. This leads to a list of all probe extensions which
   * are considered.
   *
   * @brief Sets all possible probe extensions
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void SetProbeExtensions(LibraryStruct& library, CircuitStruct& circuit,
                          SettingsStruct& settings);

  /**
   * To create the standard probes we use the probe-extensions and extend it
   * with a notion of time. This leads to a list of all standard probes which
   * are considered.
   *
   * @brief Sets all possible standard probes
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void SetStandardProbes(SettingsStruct& settings);

  /**
   * To create a list of extended probes we go thorugh the probe extensions and
   * consider all extensions extended by a notion of time.
   * This leads to a list of all extended probes which are considered.
   *
   * @brief Sets all possible extended probes
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void SetExtendedProbes(SettingsStruct& settings);

  /**
   * To create a list of unique probes we go thorugh the probe extensions and
   * and set in which probing sets the extended probe occurrs.
   *
   * @brief Sets all unique probes
   * @author Nicolai Müller
   */
  void SetUniqueProbes();
  
   /**
   * @brief Finds all relevant positions for injecting faults
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Aykan Yüce
   */
  void SetFaultTargets(CircuitStruct& circuit, SettingsStruct& settings);

  /**
   * @brief Returns the number of probing sets in the list.
   * @return The number of probing sets.
   * @author Nicolai Müller
   */
  size_t GetNumberOfProbingSets();

  /**
   * @brief Reports if set of probes satisfies the distance constrains.
   * @param standard_probe_indices The indices of all standard probes belonging
   * to the probing set.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  bool IsInDistance(std::vector<unsigned int>& standard_probe_indices,
                    SettingsStruct& settings);

  /**
   * @brief Replaces the given signal indices with indices from the list of
   * extended probes.
   * @param signal_indices The signal indices to replace.
   * @param clock_cycle The cycle in which the probes should record.
   * @param is_with_transitional_leakage True if transitional leakage is
   * considered during evaluation, False if not.
   * @return The extended probe indices.
   * @author Nicolai Müller
   */
  std::vector<ExtensionContainer> ReplaceWireIndexWithListIndex(
      const std::vector<ExtensionContainer>& signal_indices,
      unsigned int clock_cycle, bool is_with_transitional_leakage);

  /**
   * @brief Adds a new probing set to the list of probing sets.
   * @param standard_probe_indices The indices of all standard probes belonging
   * to the probing set.
   * @param is_with_transitional_leakage True if transitional leakage is
   * considered during evaluation, False if not.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void AddProbingSet(std::vector<unsigned int>& standard_probe_indices,
                     bool is_with_transitional_leakage,
                     SettingsStruct& settings);

  /**
   * @brief Removes duplicated and strictly-less informative probing sets.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void RemoveUninformativeProbingSets(SettingsStruct& settings);

  /**
   * @brief Removes duplicated and strictly-less informative probing sets in a
   * univariate setting.
   * @param number_of_probing_sets The number of probing sets.
   * @author Nicolai Müller
   */
  void RemoveUninformativeProbingSetsInUnivariateSetting(
      size_t number_of_probing_sets);

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
  void RemoveStrictlyLessInformativeProbingSets(unsigned int start,
                                                unsigned int end);

  /**
   * @brief Removes all probing sets which are strictly less informative then
   * one probing set.
   * @param set_index The index of the probing set which should cover the other
   * sets.
   * @param start The first element in the list of probing sets to compare.
   * @param end The last element in the list of probing sets to compare.
   * @author Nicolai Müller
   */
  void RemoveOneStrictlyLessInformativeProbingSet(unsigned int set_index,
                                                  unsigned int start,
                                                  unsigned int end);

  /**
   * @brief Finds the extended-probe index based on the index of the probed
   * signal and its clock cycle.
   * @param signal_index The index of the probing set which should cover the
   * other sets.
   * @param clock_cycle The first element in the list of probing sets to
   * compare.
   * @return The extended probe index.
   * @author Nicolai Müller
   */
  size_t SearchExtendedProbe(unsigned int signal_index,
                             unsigned int clock_cycle);

  /**
   * @brief Returns the highest clock cycle in which a probe in a probing set
   * records.
   * @param probing_set_index The index of the probing set to check.
   * @return The highest clock cycle in which a probe in the probing sets
   * records.
   * @author Nicolai Müller
   */
  unsigned int GetHighestClockCycle(size_t probing_set_index);

  /**
   * @brief Initializes the combination data structure for the univariate
   * probing set generation.
   * @param settings The settings read from the config file.
   * @param combination The data structure storing the probe-extension indices
   * of a new probing set.
   * @param combination_bitmask A bitmask where a set bit indicates that one
   * probe-extension is part of the probing set.
   * @author Nicolai Müller
   */
  void InitializeUnivariateProbeCombinations(
      SettingsStruct& settings, std::vector<unsigned int>& combiantion,
      std::vector<bool>& combination_bitmask);

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
  void InitializeFaultCombinations(SettingsStruct& settings,
                                   std::vector<unsigned int>& combiantion,
                                   std::vector<bool>& combination_bitmask);

  /**
   * @brief Initializes the combination data structure for the multivariate
   * probing set generation.
   * @param settings The settings read from the config file.
   * @param combination The data structure storing the standard-probe indices of
   * a new probing set.
   * @param combination_bitmask A bitmask where a set bit indicates that one
   * standard probe is part of the probing set.
   * @author Nicolai Müller
   */
  void InitializeMultivariateProbeCombinations(
      SettingsStruct& settings, std::vector<unsigned int>& combiantion,
      std::vector<bool>& combination_bitmask);

  /**
   * @brief Generates and evaluates all univariate probing sets.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @param start_time The start time of PROLEAD.
   * @return The maximum leakage.
   * @author Nicolai Müller
   */
  double EvaluateUnivariateRobustProbingSecurity(LibraryStruct& library,
                                               CircuitStruct& circuit,
                                               SettingsStruct& settings,
                                               SharedDataStruct* shared_data,
                                               SimulationStruct& simulation,
                                               timespec& start_time);

  /**
   * @brief Generates and evaluates all multivariate probing sets.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @param start_time The start time of PROLEAD.
   * @return The maximum leakage.
   * @author Nicolai Müller
   */
  double EvaluateMultivariateRobustProbingSecurity(LibraryStruct& library,
                                                 CircuitStruct& circuit,
                                                 SettingsStruct& settings,
                                                 SharedDataStruct* shared_data,
                                                 SimulationStruct& simulation,
                                                 timespec& start_time);

  /**
   * @brief Evaluates all probing sets in the list based on potentially faulty
   * simulations.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @param start_time The start time of PROLEAD.
   * @param probe_step_index The step index.
   * @param number_of_fault_targets The number of fault targets.
   * @param combination The subset of faults in the set.
   * @param bitmask The bit mask indication which faults are considered.
   * @author Nicolai Müller
   */
  void EvaluateProbingSetsUnderFaults(
      LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings,
      SharedDataStruct* shared_data, SimulationStruct& simulation,
      timespec& start_time, unsigned int& probe_step_index,
      unsigned int number_of_fault_targets,
      std::vector<unsigned int>& combination, std::vector<bool>& bitmask);

  /**
   * @brief Evaluates all probing sets in the list.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @param start_time The start time of PROLEAD.
   * @param probe_step_index The step index.
   * @author Nicolai Müller
   */
  void EvaluateProbingSets(LibraryStruct& library, CircuitStruct& circuit,
                           SettingsStruct& settings,
                           SharedDataStruct* shared_data,
                           SimulationStruct& simulation, timespec& start_time,
                           unsigned int& probe_step_index);

  /**
   * @brief Updates the contingency table with new simulations in compact mode.
   * @param simulation The simulations to update.
   * @param simulation_index The index of the current simulation.
   * @author Nicolai Müller
   */
  void CompactTableUpdate(Hardware::SimulationStruct& simulation,
                          unsigned int simulation_index);

  /**
   * @brief Evaluates all contingency tables in the compact mode.
   * @param simulation The simulations to update.
   * @param number_of_simulations_per_group The number of processed simulations
   * per group.
   * @author Nicolai Müller
   */
  void CompactTest(Hardware::SimulationStruct& simulation,
                   const std::vector<double>& number_of_simulations_per_group);

  /**
   * @brief Evaluates all contingency tables in the compact mode.
   * @param settings The settings read from the config file.
   * @param simulation The simulations to update.
   * @param number_of_simulations_per_group The number of processed simulations
   * per group.
   * @author Nicolai Müller
   */
  void NormalTest(Hardware::SettingsStruct& settings,
                  Hardware::SimulationStruct& simulation,
                  const std::vector<double>& number_of_simulations_per_group);

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
  void Test(Hardware::SettingsStruct& settings,
            Hardware::SimulationStruct& simulation,
            const std::vector<double>& number_of_simulations_per_group,
            bool is_in_compact_mode);

  /**
   * @brief Returns the index of the probing set with the highest g-value.
   * @param bitmask An indicator whether the probing set was already considered.
   * @return The index of the probing set with the highest g-value.
   * @author Nicolai Müller
   */
  size_t GetIndexOfMostLeakingProbingSet(std::vector<bool>& bitmask);

  /**
   * @brief Returns the maximum number of required simulations to get a
   * confident result for all probing sets.
   * @return The maximum number of required simulations.
   * @author Nicolai Müller
   */
  size_t GetMaximumNumberOfRequiredTraces();

  /**
   * @brief Returns the maximum leakage, i.e. the maximum p-value
   * @return The maximum leakage.
   * @author Nicolai Müller
   */
  double GetMaximumLeakage();

  /**
   * Based on statistical power-analysis we can decide how many traces are
   * required for each probing set to give a confident result. Hence, if enough
   * traces are simulated for one probing set, we can store its final result and
   * then remove it.
   *
   * @brief Removes all probing sets which already lead to a confident result.
   * @param circuit The circuit read from the gate-level netlist.
   * @param number_of_simulations The number of already processed simulations.
   * @param maximum_g_value_deleted The maximum g-value of an already deleted
   * probing set.
   * @param printed_probing_set_deleted The already deleted probing set with the
   * highest g-value.
   * @author Nicolai Müller
   */
  void RemoveProbingSetsWithEnoughTraces(
      const CircuitStruct& circuit, uint64_t number_of_simulations,
      double& maximum_g_value_deleted,
      std::string& printed_probing_set_deleted);

  /**
   * @brief Prints all information belonging to the probing set generation.
   * @author Nicolai Müller
   */
  void PrintProbingSetInformation();

  /**
   * @brief Prints the header of the printed evaluation output.
   * @param circuit The circuit read from the gate-level netlist.
   * @author Nicolai Müller
   */
  size_t PrintEvaluationHeader(const CircuitStruct& circuit);

  /**
   * @brief Returns the maximum length of text to print an arbitrary probing
   * set.
   * @param circuit The circuit read from the gate-level netlist.
   * @return The maximum space of the probing set print.
   * @author Nicolai Müller
   */
  size_t GetMaximumLengthOfProbeNames(const CircuitStruct& circuit);

  /**
   * @brief Prints the evaluation output.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param simulation The simulations to update.
   * @param maximum_g_value_deleted The maximum g-value of an already deleted
   * probing set.
   * @param printed_probing_set_deleted The already deleted probing set with the
   * highest g-value.
   * @param elapsed_time_period The current runtime of PROLEAD.
   * @param space The space required to print the probing set with the longest
   * output string.
   * @author Nicolai Müller
   */
  void PrintEvaluationBody(const CircuitStruct& circuit,
                           const SettingsStruct& settings,
                           const SimulationStruct& simulation,
                           double& maximum_g_value_deleted,
                           std::string& printed_probing_set_deleted,
                           double elapsed_time_period, size_t space);

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
  void PrintReport(const CircuitStruct& circuit, const SettingsStruct& settings,
                   const SimulationStruct& simulation,
                   unsigned int probe_step_index, size_t space);
};
}  // namespace Hardware