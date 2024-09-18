/**
 * @file Fault.cpp
 * @brief Implementation of the Fault class.
 *
 * @version 0.0.1
 * @date 2024-07-31
 *
 * @author Felix Uhle
 */
#include "Hardware/Fault.hpp"

Fault::Fault(const Hardware::SignalStruct * signal, size_t signal_index, size_t clock_cycle,
             double fault_probability, FaultType fault_type)
    : signal_(signal), signal_index_(signal_index), clock_cycle_(clock_cycle),
      fault_probability_(fault_probability), fault_type_(fault_type) {}

// TODO: write as done in .hpp (add missing GetFaultedSignal function.
size_t Fault::GetFaultedSignalIndex() const { return this->signal_index_; }
size_t Fault::GetFaultedClockCycle() const { return this->clock_cycle_; }
double Fault::GetFaultProbability() const { return this->fault_probability_; }
FaultType Fault::GetFaultType() const { return this->fault_type_; }
bool Fault::IsSignalFaulted(uint64_t signal_index, uint64_t clock_cycle) const {
  return (signal_index == this->signal_index_) && (clock_cycle == this->clock_cycle_);
}
