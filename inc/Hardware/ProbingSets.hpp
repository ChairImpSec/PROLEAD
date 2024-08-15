#pragma once

#include <algorithm>
#include <execution>
#include <queue>
#include <variant>

#include "Util/Settings.hpp"
#include "Hardware/Probes.hpp"
#include "Hardware/Propagation.hpp"

namespace Hardware{
/**
 * This class defines a probing set, i.e. a set of multiple standard probes
 * which are extended to a joint set of probe extensions.
 */
template <typename ExtensionContainer>
class ProbingSet {
 public:
  /**
   * We need to overload some operators for the probing sets as well to sort a
   * list of probing sets and also to search for particular probing sets within
   * a list. The operators are defined based on the probe-extensions, i.e. two
   * probing sets are equal if there probe-extensions are equal.
   */
  bool operator<(const ProbingSet& other) const;
  bool operator==(const ProbingSet& other) const;
  bool operator!=(const ProbingSet& other) const;

  ProbingSet();

  /**
   * @brief Contructs a probing set.
   * @param probe_addresses A vector of probes storing all the probes placed by
   * the adversary.
   * @param probe_extension_indices The list of resulting probe extensions.
   * @author Nicolai Müller
   */
  void SetProbes(std::vector<Probe*>& probe_addresses,
             std::vector<uint64_t>& probe_extension_indices);

  /**
   * @brief Returns the addresses of all probes in the probing set.
   * @return The adresses of all probes in the probing set.
   * @author Nicolai Müller
   */
  std::vector<Probe*> GetProbeAddresses();

  uint64_t GetNumberOfProbeAddresses(){
    return probe_addresses_.size();
  }

  /**
   * @brief Returns the number of probe-extensions.
   * @return The number of probe-extensions.
   * @author Nicolai Müller
   */
  size_t GetNumberOfProbeExtensions(std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Returns a certain extended probe.
   * @param extended_probe_index The index (in probe_extension_indices_) of the
   * extended probe to return.
   * @return The index (in extended_probes_ (see adversary)) of the returned
   * extended probe.
   * @author Nicolai Müller
   */
  uint64_t GetExtendedProbeIndex(size_t extended_probe_index);

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
  ExtensionContainer GetFirstProbeExtension();

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
  ExtensionContainer GetLastProbeExtension();

  /**
   * @brief Returns a list with all different probe extensions.
   * @return A list of different probe-extensions.
   * @author Nicolai Müller
   */
  std::vector<uint64_t> GetProbeExtensions();

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
  bool IsRemovable();

  /**
   * @brief Checks whether a probing set fully-includes another probing set.
   * @param other The other probing set which is maybe included.
   * @return True if other is fully-included, False if not.
   * @author Nicolai Müller
   */
  bool Includes(ProbingSet& other, std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Initializes the contingency table.
   * @param is_in_compact_mode decision whether PROLEAD operates in compact mode
   * or not.
   * @author Nicolai Müller
   */
  void Initialize(bool is_in_compact_mode, std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Checks if a particular extended probe is in the extension set..
   * @param index The index of the extended probe to find.
   * @return True if the extended probe is in the extension set, False if not.
   * @author Nicolai Müller
   */
  //bool ContainsExtension(size_t index);

  /**
   * @brief Returns -log10(p).
   * @return -log10(p)
   * @author Nicolai Müller
   */
  double GetGValue();

  /**
   * @brief Performs the full g-test procedure.
   * @param number_of_groups The number of groups.
   * @param number_of_simulations The number of already performed simulations.
   * @param frequencies The pre-computed frequencies.
   * @author Nicolai Müller
   */
  void ComputeGTest(uint64_t number_of_groups, uint64_t number_of_simulations,
                    std::vector<double_t>& group_simulation_ratio);


  uint64_t GetNumberOfEntries();

  /**
   * @brief Computes the number of required traces.
   * @param number_of_groups The number of groups.
   * @param beta_threshold The desired false-negative probability to achieve.
   * @param effect_size The desired effect size to achieve.
   * @author Nicolai Müller
   */
  void ComputeNumberOfRequiredTraces(size_t number_of_groups, double beta_threshold, double effect_size);

  void CompactTableUpdate(const Settings& settings, Simulation& simulation,
                         std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Updates the contingency table with new simulations in normal mode.
   * @param simulation The simulations to update.
   * @param extended_probes The list of extended probes (see adversary).
   * @author Nicolai Müller
   */
  void NormalTableUpdate(const Settings& settings, Simulation& simulation,
                         std::vector<Propagation<ExtensionContainer>>& propagations);

  /**
   * @brief Print all probes for the report.
   * @param circuit The circuit read from the gate-level netlist.
   * @author Nicolai Müller
   */
  std::string PrintProbes(CircuitStruct& circuit);

  void DeconstructTable();
  void Deconstruct();

  uint64_t GetHighestClockCycle(std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions);

 private:
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
   * users  to integrate other probing models into PROLEAD.
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
size_t GetIndexOfMostLeakingProbingSet(std::vector<ProbingSet<ExtensionContainer>>& probing_sets, std::vector<bool>& bitmask);

template <typename ExtensionContainer>
uint64_t GetNumberOfRequiredTraces(std::vector<ProbingSet<ExtensionContainer>>& probing_sets, const Settings& settings);

}  // namespace Hardware