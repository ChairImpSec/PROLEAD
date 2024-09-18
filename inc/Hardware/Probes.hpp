/**
 * @file Probes.hpp
 * @brief Declaration of the Probe class.
 *
 * @version 0.0.1
 * @date 2024-08-19
 *
 * @author Nicolai Müller
 */

#pragma once

#include <algorithm>
#include <cinttypes>
#include <cstdint>
#include <stdexcept>
#include <string>
#include <vector>

namespace Hardware {
/**
 * @class Probe
 * @brief Represents a probe that records the stable signal driven by a wire
 * during a single clock cycle.
 *
 * The Probe class is used to capture the value of a specific signal at a
 * particular clock cycle. Probes can be extended based on a propagation
 * procedure to generate a list of Probe elements. Unlike the Propagation class,
 * the Probe class includes a notion of time (i.e., the clock cycle) in which
 * the signal is recorded. It does not store the propagation procedure.
 *
 * @note Probes are comparable, and comparisons prioritize the clock cycle over
 * the signal index.
 */
class Probe {
 public:
  /**
   * @brief Constructs a Probe object.
   *
   * This constructor initializes the probe by setting the signal index that is
   * being monitored and the specific clock cycle during which the signal is
   * recorded.
   *
   * @param signal_index The index of the signal being probed.
   * @param clock_cycle  The clock cycle during which the probe records the
   * signal.
   */
  Probe(uint64_t signal_index, uint64_t clock_cycle);

  /**
   * @brief Retrieves the index of the probed signal.
   *
   * This function returns the index of the signal that the probe is monitoring.
   *
   * @return The index of the probed signal.
   */
  uint64_t GetSignalIndex();

  /**
   * @brief Retrieves the clock cycle during which the probe records.
   *
   * This function returns the clock cycle during which the probe recorded the
   * signal.
   *
   * @return The clock cycle during which the probe records.
   */
  uint64_t GetCycle();

  /**
   * @brief Compares this probe with another probe.
   *
   * Overloads the less-than operator to enable sorting of probes. The
   * comparison prioritizes the clock cycle over the signal index.
   *
   * @param other The other Probe object to compare with.
   * @return True if this probe occurs before the other probe, false otherwise.
   */
  bool operator<(const Probe& other) const;

  /**
   * @brief Checks for equality between two probes.
   *
   * Overloads the equality operator to compare two Probe objects.
   *
   * @param other The other Probe object to compare with.
   * @return True if both probes are equal, false otherwise.
   */
  bool operator==(const Probe& other) const;

  /**
   * @brief Checks for inequality between two probes.
   *
   * Overloads the inequality operator to compare two Probe objects.
   *
   * @param other The other Probe object to compare with.
   * @return True if the probes are not equal, false otherwise.
   */
  bool operator!=(const Probe& other) const;

 private:
  /**
   * @brief The index of the probed signal.
   *
   * This member variable stores the index of the signal being monitored by the
   * probe. The index corresponds to the signal's index in a
   * CircuitStruct.Signals array.
   */
  uint64_t signal_index_;

  /**
   * @brief The clock cycle during which the probe records.
   *
   * This member variable stores the specific clock cycle during which the probe
   * captures the signal value.
   */
  uint64_t clock_cycle_;
};

/**
 * @brief Searches for a probe in a vector by signal index and clock cycle.
 *
 * This function searches a vector of probes for a specific probe that matches
 * the given signal index and clock cycle. If the probe is found, its index
 * within the vector is returned. If the probe is not found, a runtime error is
 * thrown.
 *
 * @param signal_index The signal index of the probe to search for.
 * @param clock_cycle  The clock cycle of the probe to search for.
 * @param probes       A vector containing Probe objects.
 * @return The index of the probe within the vector.
 * @throws std::runtime_error If the probe is not found in the vector.
 */
uint64_t SearchProbe(uint64_t signal_index, uint64_t clock_cycle,
                     std::vector<Probe>& probes);

class UniqueProbe : public Probe {
 public:
  UniqueProbe(uint64_t signal_index, uint64_t clock_cycle,
              std::vector<uint64_t>& probing_set_indices);

  const std::vector<uint64_t>& GetProbingSetIndices() const;

 private:
  std::vector<uint64_t> probing_set_indices_;
};
}  // namespace Hardware
