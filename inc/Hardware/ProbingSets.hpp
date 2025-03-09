/**
 * @file ProbingSets.hpp
 * @brief Declaration of the ProbingSet class.
 *
 * @version 0.0.2
 * @date 2024-10-16
 *
 * @author Nicolai Müller
 */

#pragma once

#include <algorithm>
#include <execution>
#include <memory>
#include <queue>

#include "Hardware/Probes.hpp"
#include "Hardware/Propagation.hpp"
#include "Hardware/Simulate.hpp"
#include "Util/Settings.hpp"
#include "Util/Util.hpp"

namespace Hardware {
/**
 * @class ProbingSet
 * @brief Defines a set of standard probes extended into a unified set of probe
 * extensions.
 *
 * The ProbingSet class represents a set of probes (placed by a potential
 * adversary) that are extended to create a joint set of probes (observed by a
 * potential adversary). This class includes functionality for comparing,
 * managing, and analyzing a probing set.
 *
 * @tparam ExtensionContainer The data structure used for storing the probe
 * extensions.
 */
template <typename ExtensionContainer>
class ProbingSet {
 public:
  /**
   * @brief Default constructor for the ProbingSet class.
   *
   * Initializes an empty ProbingSet object.
   */
  ProbingSet();

  /**
   * @brief Compares this probing set with another probing set.
   *
   * Overloads the less-than operator to enable sorting of probing sets.
   * The comparison is based on the probe extensions, meaning two probing
   * sets are considered equal if their probe extensions are equal.
   *
   * @param other The other ProbingSet object to compare with.
   * @return True if this probing set is less than the other, false otherwise.
   */
  bool operator<(const ProbingSet& other) const;

  /**
   * @brief Checks for equality between two probing sets.
   *
   * Overloads the equality operator to compare two ProbingSet objects based
   * on their probe extensions.
   *
   * @param other The other ProbingSet object to compare with.
   * @return True if both probing sets are equal, false otherwise.
   */
  bool operator==(const ProbingSet& other) const;

  /**
   * @brief Checks for inequality between two probing sets.
   *
   * Overloads the inequality operator to compare two ProbingSet objects based
   * on their probe extensions.
   *
   * @param other The other ProbingSet object to compare with.
   * @return True if the probing sets are not equal, false otherwise.
   */
  bool operator!=(const ProbingSet& other) const;

  /**
   * @brief Initializes the probing set with probes and their corresponding
   * extensions.
   *
   * This method sets the probes and their corresponding extensions for the
   * probing set.
   *
   * @param probe_addresses A vector of pointers to the probes placed by the
   * adversary.
   * @param probe_extension_indices A vector of indices representing the
   * resulting probe extensions.
   */
  void SetProbes(std::vector<Probe*>& probe_addresses,
                 std::vector<uint64_t>& probe_extension_indices);

  /**
   * @brief Retrieves the addresses of all standard probes in the probing set.
   *
   * This method returns a vector containing the addresses of all standard
   * probes within the probing set.
   *
   * @return A vector of pointers to the standard probes in the probing set.
   */
  std::vector<Probe*> GetProbeAddresses();

  /**
   * @brief Retrieves the number of probe addresses in the probing set.
   *
   * @return The number of probe addresses in the probing set.
   */
  uint64_t GetNumberOfProbeAddresses();

  /**
   * @brief Retrieves the number of probe extensions in the probing set.
   *
   * This method calculates the (maximum) number of probe extensions based on
   * the probe type specialization. For `RobustProbe`, it returns the size of
   * the `probe_extension_indices_` vector, as each index corresponds to a
   * distinct extension. For `RelaxedProbe`, the method computes the total
   * number of extensions by summing the signal and enable indices from the
   * associated `Propagation` objects.
   *
   * @param propagations A vector of `Propagation` objects, which are used to
   * calculate the total number of extensions for `RelaxedProbe`
   * specializations. This parameter is unused for `RobustProbe`.
   * @return The total maximum number of probe extensions.
   * @tparam ExtensionContainer The type of the probe, either `RobustProbe` or
   * `RelaxedProbe`.
   * @note The method's behavior differs based on the specialization:
   * - For `RobustProbe`, it returns the count of elements in
   * `probe_extension_indices_`.
   * - For `RelaxedProbe`, it aggregates the number of signal and enable
   * indices.
   * @see Propagation
   */
  uint64_t GetNumberOfProbeExtensions(
      std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Retrieves a specific extended probe.
   *
   * This method returns the index of a specific extended probe based on its
   * position in the probe_extension_indices_ vector.
   *
   * @param extended_probe_index The index of the extended probe in the
   * probe_extension_indices_ vector.
   * @return The index of the extended probe in the extended_probes_ vector.
   * @see Adversaries
   */
  uint64_t GetExtendedProbeIndex(uint64_t extended_probe_index);

  /**
   * @brief Retrieves the first probe extension in the sorted list.
   *
   * Since the probe_extension_indices_ list is sorted, this method returns the
   * first probe extension, which is typically used for analyzing the smallest
   * clock cycle among the extensions.
   *
   * @return The index of the first extended probe in the extended_probes_
   * vector.
   * @see Adversaries
   */
  ExtensionContainer GetFirstProbeExtension();

  /**
   * @brief Retrieves the last probe extension in the sorted list.
   *
   * Since the probe_extension_indices_ list is sorted, this method returns the
   * last probe extension, which is typically used for analyzing the highest
   * clock cycle among the extensions.
   *
   * @return The index of the last extended probe in the extended_probes_
   * vector.
   * @see Adversaries
   */
  ExtensionContainer GetLastProbeExtension();

  uint64_t GetProbeExtension(uint64_t index);

  /**
   * @brief Retrieves all unique probe extensions.
   *
   * This method returns a list of all unique probe extensions in the probing
   * set.
   *
   * @return A vector containing the indices of unique probe extensions.
   */
  const std::vector<uint64_t>& GetProbeExtensions() const;

  /**
   * @brief Marks the probing set as removable.
   *
   * This method flags the probing set as removable, indicating that it is
   * strictly less informative compared to another set and can be discarded.
   *
   * @note This is typically used in optimization procedures to reduce the
   * number of probing sets.
   */
  void MarkAsRemovable();

  /**
   * @brief Checks if the probing set is marked as removable.
   *
   * This method checks whether the probing set has been flagged as removable.
   *
   * @return True if the probing set is marked as removable, false otherwise.
   */
  bool IsRemovable();

  /**
   * @brief Checks whether the current probing set fully includes another
   * probing set.
   *
   * This method determines if the current `ProbingSet` (referred to as "this")
   * fully includes another `ProbingSet` (referred to as "other"). A probing set
   * is said to fully include another if all the probe extensions in "other" are
   * also present in "this", and the set of extensions in "this" spans a wider
   * or equal range of clock cycles than those in "other".
   *
   * The inclusion check follows these steps:
   * 1. If either the current probing set or the other set is marked as
   * removable, they cannot include one another.
   * 2. If the number of probe extensions in "this" is less than or equal to
   * that in "other", "this" cannot include "other".
   * 3. If the range of clock cycles covered by "this" (from the first to the
   * last probe extension) is wider or equal to that of "other", the method
   * proceeds to the next step.
   * 4. Finally, if all probe extensions of "other" are found within "this", in
   * the correct order, the method returns true, indicating that "this" fully
   * includes "other". Otherwise, it returns false.
   *
   * @param other The other `ProbingSet` to check for inclusion within the
   * current set.
   * @param propagations A vector of `Propagation` objects used to retrieve
   * probe extension information.
   * @return True if the current probing set fully includes the other set, false
   * otherwise.
   * @tparam ExtensionContainer The type of the probe extension, typically
   * `RobustProbe` or `RelaxedProbe`.
   * @note This method ensures that "this" must have a wider or equal range of
   * probe extensions and include all probe extensions of the "other" set in
   * order to return true.
   * @see GetNumberOfProbeExtensions, GetFirstProbeExtension,
   * GetLastProbeExtension, IsRemovable, Propagation
   */
  bool Includes(ProbingSet& other,
                std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Initializes the contingency table.
   *
   * This method initializes the contingency table, which is used to store
   * distributions of the observation set. The initialization can vary based on
   * whether the system is operating in compact mode.
   *
   * @param is_in_compact_mode A boolean indicating whether PROLEAD operates in
   * compact mode.
   * @param propagations A vector of Propagation objects containing the
   * propagation procedures.
   */
  void Initialize(bool is_in_compact_mode,
                  std::vector<Propagation<ExtensionContainer>>& propagations,
                  uint64_t number_of_groups);

  /**
   * @brief Retrieves the value of -log10(p).
   *
   * This method returns the value of -log10(p), which is used in statistical
   * analysis.
   *
   * @return The computed value of -log10(p).
   */
  double GetGValue();

  /**
   * @brief Performs the full g-test procedure.
   *
   * This method conducts the full g-test procedure, which is a statistical test
   * used to analyze the distribution of probed signals.
   *
   * @param number_of_groups The number of groups to be tested.
   * @param number_of_simulations The number of simulations already performed.
   * @param frequencies The pre-computed frequencies for the g-test.
   */
  void ComputeGTest(uint64_t number_of_groups, uint64_t number_of_simulations,
                    std::vector<double_t>& group_simulation_ratio);

  /**
   * @brief Retrieves the number of entries in the contingency table.
   *
   * @return The number of entries in the contingency table.
   */
  uint64_t GetNumberOfEntries();

  void CompactTableUpdate(
      const Settings& settings, Simulation& simulation,
      std::vector<Propagation<ExtensionContainer>>& propagations);

  void NormalTableUpdateWithAllSimulations(
      const Settings& settings, Simulation& simulation,
      std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Updates the contingency table with new simulations in normal mode.
   * @param simulation The simulations to update.
   * @param extended_probes The list of extended probes (see adversary).
   * @author Nicolai Müller
   */
  void NormalTableUpdate(
      const Settings& settings, Simulation& simulation,
      std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Print all probes for the report.
   * @param circuit The circuit read from the gate-level netlist.
   * @author Nicolai Müller
   */
  std::string PrintProbes(CircuitStruct& circuit);

  void DeconstructTable();
  void Deconstruct();

  uint64_t GetHighestClockCycle(
      std::vector<Propagation<ExtensionContainer>>& propagations,
      std::vector<Probe>& probe_extensions);

  uint64_t GetSizeOfKeyInBytes();

  void IncrementSpecificCounter(uint64_t key_index, uint64_t group_index);

  // private:
  /**
   * A vector of probes storing all the probes placed by the adversary. All
   * probes are stored based on their addresses related to the list of all
   * possible probes.
   */
  std::vector<Probe*> probe_addresses_;

  /**
   * The list of all probe-extensions derived by extending all standard probes
   * in the list. We repeat that the concrete data structure of the
   * probe-extensions depends on the concrete model and we want to encourage
   * users to integrate other probing models into PROLEAD.
   */
  std::vector<uint64_t> probe_extension_indices_;

  /**
   * The contingency table required to store the distributions of probed
   * signals.
   */
  ContingencyTable<TableBucketVector> contingency_table_;

  bool should_be_removed_;
};

template <typename ExtensionContainer>
uint64_t GetIndexOfMostLeakingProbingSet(
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    std::vector<bool>& bitmask);

template <typename ExtensionContainer>
uint64_t GetNumberOfRequiredTraces(
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    const Settings& settings);

}  // namespace Hardware
