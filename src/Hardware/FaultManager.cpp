/**
 * @file FaultManager.cpp
 * @brief Implementation of the FaultManager class.
 *
 * @version 0.0.1
 * @date 2024-08-02
 *
 * @author Felix Uhle
 */

#include "Hardware/FaultManager.hpp"

void FaultManager::AddStuckAtZeroFault(uint64_t signal_index,
                                       uint64_t clock_cycle,
                                       double fault_probability) {
  auto fault = std::make_unique<StuckAtZeroFault>(signal_index, clock_cycle,
                                                  fault_probability);
  stuck_at_zero_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::AddStuckAtOneFault(uint64_t signal_index,
                                      uint64_t clock_cycle,
                                      double fault_probability) {
  auto fault = std::make_unique<StuckAtOneFault>(signal_index, clock_cycle,
                                                 fault_probability);
  stuck_at_one_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

void FaultManager::AddToggleFault(uint64_t signal_index, uint64_t clock_cycle,
                                  double fault_probability) {
  auto fault = std::make_unique<ToggleFault>(signal_index, clock_cycle,
                                             fault_probability);
  toggle_faults_.push_back(fault.get());
  faults_.push_back(std::move(fault));
}

const Fault* FaultManager::GetFault(uint64_t index) const {
    return faults_[index].get();
}

const std::vector<std::unique_ptr<const Fault>> &
FaultManager::GetFaults() const {
  return faults_;
}

uint64_t FaultManager::GetNumberOfFaults() const {
  return faults_.size();
}

const std::vector<StuckAtZeroFault const *> &
FaultManager::GetStuckAtZeroFaults() const {
  return stuck_at_zero_faults_;
}

const std::vector<StuckAtOneFault const *> &
FaultManager::GetStuckAtOneFaults() const {
  return stuck_at_one_faults_;
}

const std::vector<ToggleFault const *> &FaultManager::GetToggleFaults() const {
  return toggle_faults_;
}

