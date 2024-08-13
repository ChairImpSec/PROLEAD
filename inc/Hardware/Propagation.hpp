#pragma once

#include <set>

#include "Hardware/Definitions.hpp"
#include "Hardware/Enabler.hpp"
#include "Hardware/Probes.hpp"
#include "Util/Settings.hpp"

namespace Hardware {
/**
 * Our intention is to ease the integration of new models into PROLEAD.
 * Hence, we try to allow different data structures for building probing sets.
 */

/**
 * RobustProbe stores the index of a Probe element in the
 * extension_indices_ vector.
 */
using RobustProbe = uint64_t;

class RelaxedProbe {
 public:
  uint64_t enable_index_;  ///< The index of the enabler in the enabler_
                               ///< vector of the Adversaries class.
  uint64_t number_of_enable_indices_;  ///< The maximum number of enablers
                                           ///< that must be evaluated when
                                           ///< extending this relaxed probe.
  uint64_t number_of_signal_indices_;
  std::vector<uint64_t> signal_indices_;
  std::vector<uint64_t> propagation_indices_;
};

/**
 * @brief Removes duplicates from an extension.
 * @return The extension container where we remove duplicates.
 * @author Nicolai Müller
 */
template <typename ExtensionContainer>
void RemoveDuplicates(std::vector<ExtensionContainer>& extensions);

/**
 * This class defines the concrete probe-extension based on the templated
 * extension structure.
 */
template <typename ExtensionContainer>
class Propagation {
 public:
  Propagation();
  Propagation(uint64_t signal_index);
  Propagation(uint64_t signal_index,
              std::vector<ExtensionContainer> extension_indices);

  // Only for testing purposes
  Propagation(uint64_t signal_index, uint64_t enable_index,
              uint64_t number_of_enable_indices,
              uint64_t number_of_signal_indices,
              std::vector<uint64_t> signal_indices,
              std::vector<uint64_t> propagation_indices);

  bool operator==(const Propagation& other) const;

  /**
   * @brief Returns the index of the probed signal.
   * @return The signal index probed by the standard probe.
   * @author Nicolai Müller
   */
  uint64_t GetSignalIndex();

  /**
   * @brief Returns all signal indices which are part of the probe-extension.
   * @return All signal indices which are in the probe-extension list.
   * @author Nicolai Müller
   */
  std::vector<uint64_t> GetExtensionIndices();
  std::vector<uint64_t> GetExtensionIndices(
      std::vector<Propagation>& propagations);

  std::vector<uint64_t> GetEnableIndices(
      std::vector<Propagation>& propagations);

  uint64_t GetEnableIndex();

  /**
   * @brief Returns the structed extension.
   * @return The probe-extension with structure.
   * @author Nicolai Müller
   */
  std::vector<ExtensionContainer>& GetExtensionContainer();

  bool IsObsolete(const Library& library, const CircuitStruct& circuit, const Settings& settings);

  Propagation<ExtensionContainer> ExtendWithTime(
      uint64_t clock_cycle,
      std::vector<Probe>& probes,
      std::vector<Enabler<CustomOperation>>& enabler);

  void Finalize(std::vector<Propagation<ExtensionContainer>>& propagations);
  void UpdateNumberOfSignals(
      std::vector<Propagation<ExtensionContainer>>& propagations);

  uint64_t GetNumberOfEnableIndices();
  uint64_t GetNumberOfSignalIndices();

  ExtensionContainer* GetProbeAddress(uint64_t index);

  /**
   * @brief Defines the probe-propagation procedure.
   * @param library The given cell-library.
   * @param circuit The circuit read from the gate-level netlist.
   * @param settings The settings read from the config file.
   * @author Nicolai Müller
   */
  void Propagate(const Library& library, const CircuitStruct& circuit, std::vector<Propagation>& propagations);

 private:
  /**
   * Every probe-propagation starts by placing a standard probe on a certain
   * signal. We store the probed signal by its index, i.e. we store
   * signal_index_ = index to indicate a probe on circuit->Signals[index].
   */
  uint64_t signal_index_;

  /**
   * Every probe-propagation extens a standard probe in a way that a set of
   * multiple other probes is generated. For example, a standard probe is
   * extended to a list of probe-extensions (probes on other signals) according
   * to the robust probing model. We repreat that this data structure can be
   * changed to integrate new probing models into PROLEAD.
   */
  std::vector<ExtensionContainer> extension_indices_;


  uint64_t BackpropagateUntilBranch(const CircuitStruct& circuit, uint64_t signal_index);

  };
}  // namespace Hardware