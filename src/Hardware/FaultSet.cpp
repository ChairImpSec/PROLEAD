/**
 * @file FaultSet.cpp
 * @brief Implementation of the Fault class.
 *
 * @version 0.0.1
 * @date 2024-08-01
 *
 * @author Felix Uhle
 */

#include "Hardware/FaultSet.hpp"

FaultSet::FaultSet(std::vector<Fault const *> &faults) : faults_(faults) {};

uint64_t FaultSet::GetNumberOfFaultsInSet() const {
  return this->faults_.size();
}

uint64_t FaultSet::GetNumberOfEffectiveSimulations() const {
  return this->number_of_effective_simulations_;
}

void FaultSet::FaultSetWasEffective() {
  ++this->number_of_effective_simulations_;
}

void FaultSet::FaultSetWasEffective(uint64_t number) {
  this->number_of_effective_simulations_ += number;
}

Fault const *FaultSet::GetFault(uint64_t index) const {
  return this->faults_[index];
};

void FaultSet::TryToInduceFaults(uint64_t &value, uint64_t signal_index,
                                 uint64_t clock_cycle) {
  for (const Fault *fault : faults_) {
    if (fault->IsSignalFaulted(signal_index, clock_cycle)) {
      value = fault->ComputeFaultEffect(value);
    }
  }
}
