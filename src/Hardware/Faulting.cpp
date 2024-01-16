#include "Hardware/Faulting.hpp"

namespace Hardware {
namespace faulting {

FaultTarget::FaultTarget(unsigned int signal_index, unsigned int clock_cycle,
                         FaultType fault_type)
    : signal_index_(signal_index),
      clock_cycle_(clock_cycle),
      fault_type_(fault_type) {}

uint64_t FaultTarget::InduceFault(uint64_t value_to_fault) {
  if (fault_type_ == FaultType::StuckAt0) {
    return 0;
  } else if (fault_type_ == FaultType::StuckAt1) {
    return ~0;
  } else if (fault_type_ == FaultType::Toggle) {
    return ~value_to_fault;
  } else if (fault_type_ != FaultType::not_initialized) {
    throw std::runtime_error("Tried to perform more than one fault at once!");
  } else {
    throw std::runtime_error("Tried to perform an uninitialized fault!");
  }
}

bool FaultTarget::IsEqualToSignal(unsigned int signal_index,
                                  unsigned int clock_cycle) {
  if ((signal_index == signal_index_) && (clock_cycle == clock_cycle_)) {
    return true;
  }

  return false;
}

unsigned int FaultTarget::GetSignalIndex() {
  return signal_index_;
}

unsigned int FaultTarget::GetClockCycle() {
  return clock_cycle_;
}

FaultSet::FaultSet() {}

FaultSet::FaultSet(std::vector<FaultTarget>& fault_targets)
    : fault_targets_(fault_targets) {}

size_t FaultSet::GetNumberOfFaultTargets() { return fault_targets_.size(); }

FaultTarget FaultSet::GetFaultTarget(size_t index) {
  return fault_targets_[index];
}

uint64_t FaultSet::TryToInduceFaults(uint64_t value_to_fault,
                                     unsigned int signal_index,
                                     unsigned int clock_cycle) {
  for (size_t index = 0; index < GetNumberOfFaultTargets(); index++) {
    if (GetFaultTarget(index).IsEqualToSignal(signal_index, clock_cycle)) {
      return GetFaultTarget(index).InduceFault(value_to_fault);
    }
  }

  return value_to_fault;
}

}  // namespace faulting
}  // namespace Hardware