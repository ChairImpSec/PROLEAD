#include "Hardware/Probes.hpp"

namespace Hardware {
Probe::Probe(uint64_t signal_index, uint64_t clock_cycle)
    : signal_index_(signal_index), clock_cycle_(clock_cycle) {}

uint64_t Probe::GetCycle() { return clock_cycle_; }

uint64_t Probe::GetSignalIndex() { return signal_index_; }

bool Probe::operator<(const Probe& other) const {
  if (clock_cycle_ == other.clock_cycle_) {
    return signal_index_ < other.signal_index_;
  } else {
    return clock_cycle_ < other.clock_cycle_;
  }
}

bool Probe::operator==(const Probe& other) const {
  return (signal_index_ == other.signal_index_) &&
         (clock_cycle_ == other.clock_cycle_);
}

bool Probe::operator!=(const Probe& other) const {
  return (signal_index_ != other.signal_index_) ||
         (clock_cycle_ != other.clock_cycle_);
}

uint64_t SearchProbe(uint64_t signal_index, uint64_t clock_cycle,
                     std::vector<Probe>& probes) {
  Probe probe(signal_index, clock_cycle);

  std::vector<Probe>::iterator it = std::lower_bound(
      probes.begin(), probes.end(), probe,
      [](const Probe& lhs, const Probe& rhs) { return lhs < rhs; });

  std::iterator_traits<std::vector<Probe>::iterator>::difference_type diff =
      std::distance(probes.begin(), it);

  if ((it == probes.end()) || (probes.at(diff) != probe)) {
    throw std::runtime_error(
        "Tried to find a probe which is not part of the given list! It seems "
        "that you found a bug in PROLEAD. Please get in touch with me "
        "(nicolai.mueller@rub.de) so that we can fix this issue!");
  }

  return (size_t)diff;
}

UniqueProbe::UniqueProbe(uint64_t signal_index, uint64_t clock_cycle,
                         std::vector<uint64_t>& probing_set_indices)
    : Probe(signal_index, clock_cycle),
      probing_set_indices_(probing_set_indices) {}

const std::vector<uint64_t>& UniqueProbe::GetProbingSetIndices() const {
  return probing_set_indices_;
}

}  // namespace Hardware