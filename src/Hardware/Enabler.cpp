#include "Hardware/Enabler.hpp"

namespace Hardware {

template <>
Enabler<CustomOperation>::Enabler(
    const Cell* cell, uint64_t output_index, unsigned int extended_probe_index,
    std::vector<std::unique_ptr<uint64_t[]>*> input_addresses)
    : cell_(cell), output_index_(output_index), extended_probe_index_(extended_probe_index),
      input_addresses_(input_addresses) {}

template <>
unsigned int Enabler<CustomOperation>::GetExtendedProbeIndex() {
  return extended_probe_index_;
}

template <>
void Enabler<CustomOperation>::SetInputAddress(
    unsigned int index, std::unique_ptr<uint64_t[]>* ptr) {
  input_addresses_[index] = ptr;
}

template <>
uint64_t Enabler<CustomOperation>::EvaluateGlitch(
    std::vector<uint64_t>& input_values) {
  return cell_->EvaluateGlitch(output_index_, input_values);
}

template <>
uint64_t Enabler<CustomOperation>::EvaluatePropagation(
    std::vector<uint64_t>& input_values) {
  return cell_->EvaluatePropagation(output_index_, input_values);    
}

template <>
bool Enabler<CustomOperation>::operator==(
    const Enabler<CustomOperation>& other) const {
  return (extended_probe_index_ == other.extended_probe_index_) &&
         (input_addresses_ == other.input_addresses_) &&
         (output_index_ == other.output_index_);
}

template <>
bool Enabler<CustomOperation>::operator<(
    const Enabler<CustomOperation>& other) const {
  return extended_probe_index_ < other.extended_probe_index_;
}

size_t SearchEnabler(unsigned int signal_index,
                     std::vector<Enabler<CustomOperation>>& enabler) {
  std::vector<Enabler<CustomOperation>>::iterator it =
      std::lower_bound(enabler.begin(), enabler.end(), signal_index,
                       [](Enabler<CustomOperation>& e, unsigned int index) {
                         return e.GetExtendedProbeIndex() < index;
                       });

  if (it != enabler.end() && it->GetExtendedProbeIndex() == signal_index) {
    return std::distance(enabler.begin(), it);
  } else {
    std::cout << "Signal index: " << signal_index << std::endl;
    throw std::runtime_error(
        "Tried to find an enable operation which is not part of the given "
        "list! It seems "
        "that you found a bug in PROLEAD. Please get in touch with me "
        "(nicolai.mueller@rub.de) so that we can fix this issue!");
  }

  return 0;
}

}  // namespace Hardware
