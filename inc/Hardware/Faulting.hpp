#pragma once

#include <cinttypes>
#include <stdexcept>
#include <string>
#include <vector>

namespace Hardware {
namespace faulting {

enum FaultType {
  None = 0b000,
  StuckAt0 = 0b100,
  StuckAt1 = 0b010,
  Toggle = 0b001,
  StuckAt0_StuckAt1 = 0b110,
  StuckAt0_Toggle = 0b101,
  StuckAt1_Toggle = 0b011,
  All = 0b111,
  not_initialized = 0b1000
};

/**
 * We consider a fault target as the location of the fault (place and time)
 * together with a specific fault type.
 */
class FaultTarget {
 public:
  /**
   * @brief Contructs a fault target
   * @param signal_index The index of the signal which should be faulted.
   * @param clock_cycle The clock cycle in which the fault should occur.
   * @param fault_type The type of the fault.
   * @author Aykan Yüce
   */
  FaultTarget(unsigned int signal_index, unsigned int clock_cycle,
              FaultType fault_type);

  /**
   * @brief Induces the fault at the target
   * @param value_to_fault The unfaulted state of 64 simulations.
   * @return The faulted state of 64 simulations.
   * @author Aykan Yüce
   */
  uint64_t InduceFault(uint64_t value_to_fault);

  /**
   * @brief Checks if the faults targets a specific signal
   * @param signal_index The index of the signal.
   * @param clock_cycle The clock cycle.
   * @return True if the fault targets the given signal, false otherwise.
   * @author Aykan Yüce
   */
  bool IsEqualToSignal(unsigned int signal_index, unsigned int clock_cycle);

  unsigned int GetSignalIndex();
  unsigned int GetClockCycle();

 private:
  /**
   * The index of the signal which should be faulted.
   */
  unsigned int signal_index_;

  /**
   * The clock cycle in which the fault should occur.
   */
  unsigned int clock_cycle_;

  /**
   * The type of the fault.
   */
  FaultType fault_type_;
};

class FaultSet {
 public:
  FaultSet();
  FaultSet(std::vector<FaultTarget>& fault_targets_);

  size_t GetNumberOfFaultTargets();
  FaultTarget GetFaultTarget(size_t index);

  uint64_t TryToInduceFaults(uint64_t value_to_fault, unsigned int signal_index,
                             unsigned int clock_cycle);

 private:
  std::vector<FaultTarget> fault_targets_;
};

}  // namespace faulting
}  // namespace Hardware