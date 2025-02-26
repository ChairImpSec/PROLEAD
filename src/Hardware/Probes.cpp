#include "Hardware/Probes.hpp"

Probe::Probe(const std::vector<uint64_t>& signal_indices, uint64_t clock_cycle)
    : signal_indices_(signal_indices), clock_cycle_(clock_cycle) {}

uint64_t Probe::GetCycle() const { return clock_cycle_; }

const std::vector<uint64_t>& Probe::GetSignalIndices() const {
  assert(std::is_sorted(signal_indices_.begin(), signal_indices_.end()) &&
         "Error in Probe::GetSignalIndices(): Signal indices not sorted!");
  return signal_indices_;
}

bool Probe::operator<(const Probe& other) const {
  if (clock_cycle_ == other.clock_cycle_) {
    assert(std::is_sorted(signal_indices_.begin(), signal_indices_.end()) &&
           "Error in Probe::operator<: First operand not sorted!");
    assert(std::is_sorted(other.signal_indices_.begin(),
                          other.signal_indices_.end()) &&
           "Error in Probe::operator<: Second operand not sorted!");

    return signal_indices_ < other.signal_indices_;
  } else {
    return clock_cycle_ < other.clock_cycle_;
  }
}

bool Probe::operator==(const Probe& other) const {
  assert(std::is_sorted(signal_indices_.begin(), signal_indices_.end()) &&
         "Error in Probe::operator==: First operand not sorted!");
  assert(std::is_sorted(other.signal_indices_.begin(),
                        other.signal_indices_.end()) &&
         "Error in Probe::operator==: Second operand not sorted!");

  return (signal_indices_ == other.signal_indices_) &&
         (clock_cycle_ == other.clock_cycle_);
}

bool Probe::operator!=(const Probe& other) const {
  assert(std::is_sorted(signal_indices_.begin(), signal_indices_.end()) &&
         "Error in Probe::operator!=: First operand not sorted!");
  assert(std::is_sorted(other.signal_indices_.begin(),
                        other.signal_indices_.end()) &&
         "Error in Probe::operator!=: Second operand not sorted!");

  return (signal_indices_ != other.signal_indices_) ||
         (clock_cycle_ != other.clock_cycle_);
}

std::optional<uint64_t> SearchProbe(const Probe& probe,
                                    const std::vector<Probe>& probes) {
  assert(std::is_sorted(probes.begin(), probes.end()) &&
         "Error in SearchProbe(): Probes not sorted!");

  std::vector<Probe>::const_iterator it =
      std::lower_bound(probes.begin(), probes.end(), probe);
  if (it != probes.end() && *it == probe) {
    return std::distance(probes.begin(), it);
  } else {
    return std::nullopt;
  }
}

UniqueProbe::UniqueProbe(const std::vector<uint64_t>& signal_indices,
                         uint64_t clock_cycle,
                         const std::vector<uint64_t>& probing_set_indices)
    : Probe(signal_indices, clock_cycle),
      probing_set_indices_(probing_set_indices) {}

const std::vector<uint64_t>& UniqueProbe::GetProbingSetIndices() const {
  assert(std::is_sorted(probing_set_indices_.begin(),
                        probing_set_indices_.end()) &&
         "Error in Probe::GetProbingSetIndices(): Probing set indices not "
         "sorted!");
  return probing_set_indices_;
}