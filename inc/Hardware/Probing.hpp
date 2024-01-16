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
 * We define a first basic structure that stores a single probe-extension,
 * derived by extending a glitch-extended probe. According to the
 * glitch-extended probing model, the extension abtracts the probed signal by
 * storing the signal index.
 */
using GlitchExtendedProbe = unsigned int;

/**
 * @brief Removes duplicates from an extension.
 * @return The extension container where we remove duplicates.
 * @author Nicolai Müller
 */
template <typename ExtensionContainer>
void RemoveDuplicates(std::vector<ExtensionContainer>& extensions);

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

  /**
   * @brief Returns the structed extension.
   * @return The probe-extension with structure.
   * @author Nicolai Müller
   */
  std::vector<ExtensionContainer> GetExtensionContainer();

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
  std::vector<ExtensionContainer> extension_indices_;

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
             std::vector<ExtensionContainer>& probe_extension_indices);

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
  ExtensionContainer GetExtendedProbeIndex(size_t extended_probe_index);

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
  ExtensionContainer GetFirstProbeExtension() const;

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
  ExtensionContainer GetLastProbeExtension() const;

  /**
   * @brief Returns a list with all different probe extensions.
   * @return A list of different probe-extensions.
   * @author Nicolai Müller
   */
  std::vector<ExtensionContainer> GetAllProbeExtensions() const;

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
  std::vector<ExtensionContainer> probe_extension_indices_;

  /**
   * The contingency table required to store the distributions of probed
   * signals.
   */
  hardware::stats::ContingencyTable<hardware::stats::TableBucketVector>
      contingency_table_;
};
}  // namespace probing
}  // namespace Hardware