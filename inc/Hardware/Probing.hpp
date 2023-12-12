#pragma once

#include <omp.h>

#include <cinttypes>
#include <iostream>
#include <vector>

#include "Hardware/Simulate.hpp"

namespace Hardware {
/**
 * The stats namespace encompasses everything which is related to probing.
 * In particular, all functions related to probes, probing sets, and the
 * evaluation under probing models.
 */
namespace probing {
/**
 * Our intention is to ease the integration of new models into PROLEAD.
 * Hence, we try to allow different data structures for building probing sets.
 */
/**
 * Here, we define a first basic-structure that stores a set of signal indiices.
 * The signal indices abstract the signals/wires which are probed after
 * extending a standard probe according to the robust probing model.
 */
using RobustProbeExtension = std::vector<unsigned int>;

/**
 * We derive all probe-extension procedures of current and future models from
 * this abstract base class. In particular, it defines the data and features
 * every probe-propagation strategy should support.
 */
template <typename ExtensionContainer>
class AbstractProbeExtension {
 public:
  /**
   * @brief Contrusts the probe-extension by placing a standard probe on a
   * signal.
   * @param signal_index The index of the signal probed by the standard probe.
   * @author Nicolai Müller
   */
  AbstractProbeExtension(unsigned int signal_index);

  /**
   * @brief Returns the index of the probed signal.
   * @return The signal index probed by the standard probe.
   * @author Nicolai Müller
   */
  unsigned int GetSignalIndex();

  /**
   * @brief Returns all signal indices which are part of the probe-extension.
   * @return All signal indices which are in the probe-extension list.
   * @author Nicolai Müller
   */
  std::vector<unsigned int> GetAllExtensionIndices();

 protected:
  /**
   * Every probe-propagation starts by placing a standard probe on a certain
   * signal. We store the probed signal by its index, i.e. we store
   * signal_index_ = index to indicate a probe on circuit->Signals[index].
   */
  unsigned int signal_index_;

  /**
   * Every probe-propagation extens a standard probe in a way that a set of
   * multiple other probes is generated. For example, a standard probe is
   * extended to a list of probe-extensions (probes on other signals) according
   * to the robust probing model. We repreat that this data structure can be
   * changed to integrate new probing models into PROLEAD.
   */
  ExtensionContainer extension_indices_;

  /**
   * Every probe-propagation must define how a probe is propagated.
   * This process always starts with a standard probe on a signal and ends with
   * multiple probe extensions on signals. This process must be defined for ever
   * new model, i.e. there is no default propagation.
   *
   * @brief Defines the probe-propagation procedure.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  virtual void PropagateProbe(LibraryStruct& library, CircuitStruct& circuit,
                              SettingsStruct& settings) = 0;
};

/**
 * This class defines the concrete probe-extension based on the templated
 * extension structure.
 */
template <typename ExtensionContainer>
class ProbeExtension : public AbstractProbeExtension<ExtensionContainer> {
 public:
  /**
   * This constructor first calls the constructor of the abstract class and then
   * the probe-propagation procedure.
   * @brief Contrusts the probe-extension.
   * @param signal_index The index of the signal probed by the standard probe.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  ProbeExtension(unsigned int signal_index, LibraryStruct& library,
                 CircuitStruct& circuit, SettingsStruct& settings);

 private:
  /**
   * @brief Defines the probe-propagation procedure.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void PropagateProbe(LibraryStruct& library, CircuitStruct& circuit,
                      SettingsStruct& settings) override;
};

/**
 * This class defines a probe that records the stable signal driven by one wire
 * during a single clock cycle. A probe can be extended based on a
 * probe-extension procedure in order to get a list of probe extensions. The
 * difference to the probe-extension classes is that all probes have a notion of
 * time, i.e. the clock cycle in which they record.
 */
class Probe {
 public:
  /**
   * @brief Contructs the probe by setting the probed signal and the clock
   * cycle.
   * @param signal_index The index of the probed signal.
   * @param clock_cycle  The clock cycle to record.
   * @author Nicolai Müller
   */
  Probe(unsigned int signal_index, unsigned int clock_cycle);

  /**
   * @brief Returns the index of the probed signal.
   * @return The index of the probed signal.
   * @author Nicolai Müller
   */
  unsigned int GetSignalIndex();

  /**
   * @brief Returns the clock cycle in which the probe records.
   * @return The recorded clock cycle.
   * @author Nicolai Müller
   */
  unsigned int GetCycle();

  /**
   * We need to overload some operators for probes as we need to sort a list of
   * probes and also to search for particular probes within a list. To ease
   * further steps, we compare probes based on the clock cycle and compare the
   * signal index only if the clock cycles are equal.
   */
  bool operator<(const Probe& other) const;
  bool operator==(const Probe& other) const;
  bool operator!=(const Probe& other) const;

 private:
  /**
   * The index of the signal recorded by the probe.
   */
  unsigned int signal_index_;

  /**
   * @brief Returns the clock cycle in which the probe records.
   * @return The recorded clock cycle.
   * @author Nicolai Müller
   */
  unsigned int clock_cycle_;
};

/**
 * For the compact mode, every probe has to store the indices of all probing
 * sets in which it occurrs. For this, we derived this class from the above
 * defined probe and added a list of probing set indices.
 */
class UniqueProbe : public Probe {
 public:
  /**
   * @brief Constructs a unique probe.
   * @author Nicolai Müller
   */
  UniqueProbe(unsigned int signal_index, unsigned int clock_cycle,
              std::vector<unsigned int> probing_set_indices);

  /**
   * @brief Returns the number of probing sets containing this probe.
   * @return The number of probing sets.
   * @author Nicolai Müller
   */
  size_t GetNumberOfProbeSetIndices();

  /**
   * @brief Returns the index of one probing set containing this probe.
   * @return The probing set index.
   * @author Nicolai Müller
   */
  unsigned int GetProbeSetIndex(size_t index);

 private:
  /**
   * The indices of all probing sets in which this particular probe occurrs.
   */
  std::vector<unsigned int> probing_set_indices_;
};

/**
 * This class defines a probing set, i.e. a set of multiple standard probes
 * which are extended to a joint set of probe extensions.
 */
template <typename ExtensionContainer>
class ProbingSet {
 public:
  /**
   * @brief Contructs a probing set.
   * @param standard_probe_indices The list of signals probed by standard
   * probes.
   * @param probe_extension_indices The list of resulting probe extensions.
   * @author Nicolai Müller
   */
  ProbingSet(std::vector<unsigned int>& standard_probe_indices,
             ExtensionContainer& probe_extension_indices);

  /**
   * @brief Returns the number of standard probes.
   * @return The number of standard probes.
   * @author Nicolai Müller
   */
  size_t GetNumberOfStandardProbes() const;

  /**
   * @brief Returns a certain standard probe.
   * @param standard_probe_index The index (in standard_probe_indices_) of the
   * standard probe to return.
   * @return The index (in standard_probes_ (see adversary)) of the returned
   * standard probe.
   * @author Nicolai Müller
   */
  size_t GetStandardProbeIndex(size_t standard_probe_index);

  /**
   * @brief Returns the number of probe-extensions.
   * @return The number of probe-extensions.
   * @author Nicolai Müller
   */
  size_t GetNumberOfProbeExtensions() const;

  /**
   * @brief Returns a certain extended probe.
   * @param extended_probe_index The index (in probe_extension_indices_) of the
   * extended probe to return.
   * @return The index (in extended_probes_ (see adversary)) of the returned
   * extended probe.
   * @author Nicolai Müller
   */
  size_t GetExtendedProbeIndex(size_t extended_probe_index);

  /**
   * We remark that the probe_extension_indices list is sorted.
   * Hence, if we need the extension with the smallest clock cycle we can just
   * take the first element in the list. For example, finding the
   * probe-extension with the smallest clock cycle is required to check the
   * distance.
   * @brief Returns the first probe-extension in the list.
   * @return The index (in extended_probes_ (see adversary)) of the returned
   * extended probe.
   * @author Nicolai Müller
   */
  unsigned int GetFirstProbeExtension() const;

  /**
   * We remark that the probe_extension_indices list is sorted.
   * Hence, if we need the extension with the highest clock cycle we can just
   * take the last element in the list. For example, finding the probe-extension
   * with the highest clock cycle is required to check the distance.
   * @brief Returns the last probe-extension in the list.
   * @return The index (in extended_probes_ (see adversary)) of the returned
   * extended probe.
   * @author Nicolai Müller
   */
  unsigned int GetLastProbeExtension() const;

  /**
   * @brief Returns a list with all different probe extensions.
   * @return A list of different probe-extensions.
   * @author Nicolai Müller
   */
  std::vector<unsigned int> GetAllProbeExtensions() const;

  /**
   * @brief Marks the probing set as removable, i.e. strictly less informative
   * compared to another set.
   * @author Nicolai Müller
   */
  void MarkAsRemovable();

  /**
   * @brief Checks whether a probing set is already marked as removable.
   * @author Nicolai Müller
   */
  bool IsRemovable() const;

  /**
   * We need to overload some operators for the probing sets as well to sort a
   * list of probing sets and also to search for particular probing sets within
   * a list. The operators are defined based on the probe-extensions, i.e. two
   * probing sets are equal if there probe-extensions are equal.
   */
  bool operator<(const ProbingSet& other) const;
  bool operator==(const ProbingSet& other) const;
  bool operator!=(const ProbingSet& other) const;

  /**
   * @brief Checks whether a probing set fully-includes another probing set.
   * @param other The other probing set which is maybe included.
   * @return True if other is fully-included, False if not.
   * @author Nicolai Müller
   */
  bool Includes(const ProbingSet& other) const;

  /**
   * @brief Initializes the contingency table.
   * @param number_of_groups The number of groups.
   * @param is_in_compact_mode decision whether PROLEAD operates in compact mode
   * or not.
   * @author Nicolai Müller
   */
  void Initialize(size_t number_of_groups, bool is_in_compact_mode);

  /**
   * @brief Checks if a particular extended probe is in the extension set..
   * @param index The index of the extended probe to find.
   * @return True if the extended probe is in the extension set, False if not.
   * @author Nicolai Müller
   */
  bool ContainsExtension(size_t index);

  /**
   * @brief Returns -log10(p).
   * @return -log10(p)
   * @author Nicolai Müller
   */
  double GetGValue();

  /**
   * @brief Sets -log10(p) = 0.0.
   * @author Nicolai Müller
   */
  void ResetGValue();

  /**
   * @brief Performs the full g-test procedure.
   * @param number_of_groups The number of groups.
   * @param number_of_simulations The number of already performed simulations.
   * @param frequencies The pre-computed frequencies.
   * @author Nicolai Müller
   */
  void ComputeGTest(size_t number_of_groups, size_t number_of_simulations,
                    std::vector<double> frequencies);

  /**
   * @brief Returns the number of required traces.
   * @return The number of required traces.
   * @author Nicolai Müller
   */
  size_t GetNumberOfRequiredTraces();

  /**
   * @brief Computes the number of required traces.
   * @param number_of_groups The number of groups.
   * @param beta_threshold The desired false-negative probability to achieve.
   * @param effect_size The desired effect size to achieve.
   * @author Nicolai Müller
   */
  void ComputeNumberOfRequiredTraces(size_t number_of_groups,
                                     double beta_threshold, double effect_size);

  /**
   * @brief Returns a pointer to all counters of the entry in the contingency
   * table.
   * @param index first-layer index of the hash table.
   * @return A pointer thats points on the counter array.
   * @author Nicolai Müller
   */
  unsigned int* GetCounters(size_t index);

  /**
   * @brief Updates the contingency table with new simulations in normal mode.
   * @param simulation The simulations to update.
   * @param extended_probes The list of extended probes (see adversary).
   * @author Nicolai Müller
   */
  void NormalTableUpdate(SimulationStruct& simulation,
                         std::vector<Probe>& extended_probes);

  /**
   * @brief Print all standard probes for the report.
   * @param circuit The circuit read from the gate-level netlist.
   * @param standard_probes The list of standard probes (see adversary).
   * @author Nicolai Müller
   */
  std::string PrintStandardProbes(const CircuitStruct& circuit,
                                  std::vector<Probe>& standard_probes);

  /**
   * @brief Print all extended probes for the report.
   * @param circuit The circuit read from the gate-level netlist.
   * @param extended_probes The list of extended probes (see adversary).
   * @author Nicolai Müller
   */
  std::string PrintExtendedProbes(const CircuitStruct& circuit,
                                  std::vector<Probe>& extended_probes);

 private:
  /**
   * The list of signal indices probed by standard probes.
   * For the robust d-probing model, an adversary can place d standard probes on
   * arbitrary signals.
   */
  std::vector<unsigned int> standard_probe_indices_;

  /**
   * The list of all probe-extensions derived by extending all standard probes
   * in the list. We repeat that the concrete data structure of the
   * probe-extensions depends on the concrete model and we want to encourage
   * users  to integrate other probing models into PROLEAD.
   */
  ExtensionContainer probe_extension_indices_;

  /**
   * The contingency table required to store the distributions of probed
   * signals.
   */
  hardware::stats::ContingencyTable<hardware::stats::TableBucketVector>
      contingency_table_;
};

/**
 * This class defines all possible adversaries under the desired adversary
 * (probing) model.
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
   * @brief Evaluates all adversaries under the robust d-probing model
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @param shared_data The shared state of a simulation.
   * @param simulation The simulations to update.
   * @author Nicolai Müller
   */
  void EvaluateRobustProbingSecurity(LibraryStruct& library,
                                     CircuitStruct& circuit,
                                     SettingsStruct& settings,
                                     SharedDataStruct* shared_data,
                                     SimulationStruct& simulation);

 private:
  /**
   * The list of all probe extensions required to create the other lists of
   * probes.
   */
  std::vector<ProbeExtension<ExtensionContainer>> probe_extensions_;

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

  /**
   * The list of all unique probes. Only required in the compact mode.
   */
  std::vector<UniqueProbe> unique_probes_;

  /**
   * The list of all probing sets.
   * Every probing set is based on standard and extended probes.
   * To save memory, every probing set just stores the indices of probes in
   * standard_probes_ or extended_probes_.
   */
  std::vector<ProbingSet<ExtensionContainer>> probing_sets_;

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
   * @author Nicolai Müller
   */
  void EvaluateUnivariateRobustProbingSecurity(LibraryStruct& library,
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
   * @author Nicolai Müller
   */
  void EvaluateMultivariateRobustProbingSecurity(LibraryStruct& library,
                                                 CircuitStruct& circuit,
                                                 SettingsStruct& settings,
                                                 SharedDataStruct* shared_data,
                                                 SimulationStruct& simulation,
                                                 timespec& start_time);

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
   * @return The index of the probing set with the highest g-value.
   * @author Nicolai Müller
   */
  size_t GetIndexOfMostLeakingProbingSet();

  /**
   * @brief Returns the maximum number of required simulations to get a
   * confident result for all probing sets.
   * @return The maximum number of required simulations.
   * @author Nicolai Müller
   */
  size_t GetMaximumNumberOfRequiredTraces();

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
}  // namespace probing
}  // namespace Hardware