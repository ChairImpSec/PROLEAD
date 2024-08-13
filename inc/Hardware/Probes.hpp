#pragma once

#include <algorithm>
#include <cinttypes>
#include <stdexcept>
#include <string>
#include <vector>

namespace Hardware {
/**
 * This class defines a probe that records the stable signal driven by one wire
 * during a single clock cycle. A probe can be extended based on a
 * propagation procedure in order to get a list of Probe elements. The
 * difference to the Propagation class is that all probes have a notion of
 * time, i.e. the clock cycle in which they record and that they do not store
 * the propagation procedure.
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
  Probe(uint64_t signal_index, uint64_t clock_cycle);

  /**
   * @brief Returns the index of the probed signal.
   * @return The index of the probed signal.
   * @author Nicolai Müller
   */
  uint64_t GetSignalIndex();

  /**
   * @brief Returns the clock cycle in which the probe records.
   * @return The recorded clock cycle.
   * @author Nicolai Müller
   */
  uint64_t GetCycle();

  /**
   * We need to overload some operators for probes as we need to sort a list of
   * probes and also to search for particular probes within a list. When
   * comparing two Probe elements, the clock cycle has a higher priority than
   * the signal index.
   */
  bool operator<(const Probe& other) const;
  bool operator==(const Probe& other) const;
  bool operator!=(const Probe& other) const;

 private:
  /**
   * The signal index is related to the index of the signal in a CircuitStruct.
   */
  uint64_t signal_index_;

  uint64_t clock_cycle_;
};

/**
 * Searches a probe with a given signal index and clock cycle in a vector of
 * probes. If the probe was not found in the vector, the function throws an
 * runtime error.
 *
 * @brief Searches a probe in a vector.
 * @param signal_index The signal index of the probe to search.
 * @param clock_cycle The clock cycle of the probe to search.
 * @return The index of the probe in the vector.
 * @author Nicolai Müller
 */
uint64_t SearchProbe(uint64_t signal_index, uint64_t clock_cycle,
                   std::vector<Probe>& probes);
}  // namespace Hardware