/**
 * @file StuckAtOneFault.hpp
 * @brief Declaration of the StuckAtOneFault class.
 *
 * @version 0.0.1
 * @date 2024-08-02
 *
 * @author Felix Uhle
 */

#pragma once

#include "Hardware/Fault.hpp"

class StuckAtOneFault : public Fault {
public:
  /**
   * @brief Constructor of StuckAtOneFault.
   *
   * @param signal A pointer to the signal, which is faulted.
   * @param signal_index The index of the signal/the position, which is faulted.
   * @param clock_cycle The clock cycle in which the Fault is injected.
   * @param fault_probability The probability with that the fault is induced.
   */
  StuckAtOneFault(const Hardware::SignalStruct *const signal,
                  size_t signal_index, size_t clock_cycle,
                  double fault_probability)
      : Fault(signal, signal_index, clock_cycle, fault_probability,
              FaultType::stuck_at_1) {}

  /**
   * @brief Computes the effect of this fault on a given fault-free computation
   * of a signal.
   *
   * @param fault_free_computation The fault-free computation computed by the
   * simulator.
   * @return One is returned since for StuckAtZero fault, the signal is always
   * set to 0.
   */
  virtual uint64_t
  ComputeFaultEffect([[maybe_unused]] uint64_t fault_free_computation) const override {
    return 0xfffffffffffffffful;
    ;
  }
};
