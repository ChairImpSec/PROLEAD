#include "Hardware/Probing.hpp"

namespace Hardware {
namespace probing {

template <class ExtensionContainer>
void RemoveDuplicates(std::vector<ExtensionContainer>& extensions) {
  std::sort(extensions.begin(), extensions.end(),
            std::greater<ExtensionContainer>());
  extensions.erase(std::unique(extensions.begin(), extensions.end()),
                   extensions.end());
}

template void RemoveDuplicates(std::vector<GlitchExtendedProbe>&);

template <class ExtensionContainer>
AbstractProbeExtension<ExtensionContainer>::AbstractProbeExtension(
    unsigned int signal_index)
    : signal_index_(signal_index) {}

template <class ExtensionContainer>
unsigned int AbstractProbeExtension<ExtensionContainer>::GetSignalIndex() {
  return signal_index_;
}

template unsigned int
AbstractProbeExtension<GlitchExtendedProbe>::GetSignalIndex();

template <>
std::vector<unsigned int>
AbstractProbeExtension<GlitchExtendedProbe>::GetAllExtensionIndices() {
  return extension_indices_;
}

template std::vector<unsigned int>
AbstractProbeExtension<GlitchExtendedProbe>::GetAllExtensionIndices();

template <class ExtensionContainer>
std::vector<ExtensionContainer>
AbstractProbeExtension<ExtensionContainer>::GetExtensionContainer() {
  return extension_indices_;
}

template std::vector<GlitchExtendedProbe>
AbstractProbeExtension<GlitchExtendedProbe>::GetExtensionContainer();

template <class ExtensionContainer>
ProbeExtension<ExtensionContainer>::ProbeExtension(unsigned int signal_index,
                                                   LibraryStruct& library,
                                                   CircuitStruct& circuit,
                                                   SettingsStruct& settings)
    : AbstractProbeExtension<ExtensionContainer>(signal_index) {
  PropagateProbe(library, circuit, settings);
}

template ProbeExtension<GlitchExtendedProbe>::ProbeExtension(unsigned int,
                                                             LibraryStruct&,
                                                             CircuitStruct&,
                                                             SettingsStruct&);

template <>
void ProbeExtension<GlitchExtendedProbe>::PropagateProbe(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings) {
  std::vector<bool> probe_already_considered(circuit.NumberOfSignals, false);
  std::queue<GlitchExtendedProbe> signals_in_progress;
  int tmp_index, probe_index, next_index;

  signals_in_progress.push(signal_index_);

  while (!signals_in_progress.empty()) {
    tmp_index = signals_in_progress.front();
    signals_in_progress.pop();

    if (circuit.IsProbeOnSignalAllowed(signal_index_, tmp_index,
                                       settings.ClockSignal)) {
      if (!circuit.CanProbeOnSignalBePropagated(tmp_index, library)) {
        if (!probe_already_considered[tmp_index]) {
          extension_indices_.push_back(tmp_index);
        }
      } else {
        if (!circuit.IsGateThatOutputsSignalDeleted(tmp_index)) {
          for (probe_index = 0;
               probe_index <
               circuit.GetNumberOfInputsForSignalsComputingCell(tmp_index);
               ++probe_index) {
            next_index = circuit.Cells[circuit.Signals[tmp_index]->Output]
                             ->Inputs[probe_index];

            if (!probe_already_considered[next_index]) {
              signals_in_progress.push(next_index);
            }
          }
        }
      }
    }

    probe_already_considered[tmp_index] = true;
  }

  std::sort(extension_indices_.begin(), extension_indices_.end());
  extension_indices_.erase(
      std::unique(extension_indices_.begin(), extension_indices_.end()),
      extension_indices_.end());
}

unsigned int Probe::GetCycle() { return clock_cycle_; }

unsigned int Probe::GetSignalIndex() { return signal_index_; }

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

size_t UniqueProbe::GetNumberOfProbeSetIndices() {
  return probing_set_indices_.size();
}

unsigned int UniqueProbe::GetProbeSetIndex(size_t index) {
  if (probing_set_indices_.empty()) {
    throw std::out_of_range(
        "Tried to access a probing set index from an empty vector!");
  }

  if (index >= probing_set_indices_.size()) {
    throw std::out_of_range("Tried to access an invalid probing set index!");
  }

  return probing_set_indices_[index];
}

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetNumberOfStandardProbes() const {
  return standard_probe_indices_.size();
}

template size_t ProbingSet<GlitchExtendedProbe>::GetNumberOfStandardProbes()
    const;

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetNumberOfProbeExtensions() const {
  return probe_extension_indices_.size();
}

template size_t ProbingSet<GlitchExtendedProbe>::GetNumberOfProbeExtensions()
    const;

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetStandardProbeIndex(
    size_t standard_probe_index) {
  if (standard_probe_indices_.empty()) {
    throw std::out_of_range(
        "Tried to access a standard probe index from an empty vector!");
  }

  if (standard_probe_index >= standard_probe_indices_.size()) {
    throw std::out_of_range("Tried to access an invalid standard probe index!");
  }

  return standard_probe_indices_[standard_probe_index];
}

template size_t ProbingSet<GlitchExtendedProbe>::GetStandardProbeIndex(size_t);

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetExtendedProbeIndex(
    size_t extended_probe_index) {
  if (probe_extension_indices_.empty()) {
    throw std::out_of_range(
        "Tried to access a probe-extension index from an empty vector!");
  }

  if (extended_probe_index >= probe_extension_indices_.size()) {
    throw std::out_of_range(
        "Tried to access an invalid probe-extension index!");
  }

  return probe_extension_indices_[extended_probe_index];
}

template <class ExtensionContainer>
ProbingSet<ExtensionContainer>::ProbingSet(
    std::vector<unsigned int>& standard_probe_indices,
    std::vector<ExtensionContainer>& probe_extension_indices)
    : standard_probe_indices_(standard_probe_indices),
      probe_extension_indices_(probe_extension_indices) {}

template ProbingSet<GlitchExtendedProbe>::ProbingSet(
    std::vector<unsigned int>&, std::vector<GlitchExtendedProbe>&);

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetFirstProbeExtension()
    const {
  if (!probe_extension_indices_.empty()) {
    return probe_extension_indices_.front();
  } else {
    throw std::out_of_range(
        "Tried to return the first element of an empty vector!");
  }
}

template GlitchExtendedProbe
ProbingSet<GlitchExtendedProbe>::GetFirstProbeExtension() const;

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetLastProbeExtension()
    const {
  if (!probe_extension_indices_.empty()) {
    return probe_extension_indices_.back();
  } else {
    throw std::out_of_range(
        "Tried to return the last element of an empty vector!");
  }
}

template GlitchExtendedProbe
ProbingSet<GlitchExtendedProbe>::GetLastProbeExtension() const;

template <class ExtensionContainer>
std::vector<ExtensionContainer>
ProbingSet<ExtensionContainer>::GetAllProbeExtensions() const {
  return probe_extension_indices_;
}

template std::vector<GlitchExtendedProbe>
ProbingSet<GlitchExtendedProbe>::GetAllProbeExtensions() const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::IsRemovable() const {
  return contingency_table_.IsRemovable();
}

template bool ProbingSet<GlitchExtendedProbe>::IsRemovable() const;

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::MarkAsRemovable() {
  contingency_table_.MarkAsRemovable();
}

template void ProbingSet<GlitchExtendedProbe>::MarkAsRemovable();

template <class ExtensionContainer>
double ProbingSet<ExtensionContainer>::GetGValue() {
  return contingency_table_.GetGValue();
}

template double ProbingSet<GlitchExtendedProbe>::GetGValue();

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetNumberOfRequiredTraces() {
  return contingency_table_.GetNumberOfRequiredTraces();
}

template size_t ProbingSet<GlitchExtendedProbe>::GetNumberOfRequiredTraces();

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ComputeGTest(
    size_t number_of_groups, size_t number_of_simulations,
    std::vector<double> frequencies) {
  contingency_table_.ComputeGTest(number_of_groups, number_of_simulations,
                                  frequencies);
}

template void ProbingSet<GlitchExtendedProbe>::ComputeGTest(
    size_t, size_t, std::vector<double>);

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ComputeNumberOfRequiredTraces(
    size_t number_of_groups, double beta_threshold, double effect_size) {
  contingency_table_.ComputeNumberOfRequiredTraces(number_of_groups,
                                                   beta_threshold, effect_size);
}

template void ProbingSet<GlitchExtendedProbe>::ComputeNumberOfRequiredTraces(
    size_t, double, double);

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::Initialize(size_t number_of_groups,
                                                bool is_in_compact_mode) {
  contingency_table_.Initialize(number_of_groups, GetNumberOfProbeExtensions(),
                                is_in_compact_mode);
}

template void ProbingSet<GlitchExtendedProbe>::Initialize(size_t, bool);

template <class ExtensionContainer>
std::string ProbingSet<ExtensionContainer>::PrintStandardProbes(
    const CircuitStruct& circuit, std::vector<Probe>& standard_probes) {
  unsigned int signal_index;
  std::string cycle, printed_probing_set, signal_name;
  size_t number_of_standard_probes = GetNumberOfStandardProbes();

  for (size_t probe_index = 0; probe_index < number_of_standard_probes;
       ++probe_index) {
    signal_index =
        standard_probes[GetStandardProbeIndex(probe_index)].GetSignalIndex();
    signal_name = circuit.Signals[signal_index]->Name;
    cycle = std::to_string(
        standard_probes[GetStandardProbeIndex(probe_index)].GetCycle());

    if (probe_index == (number_of_standard_probes - 1)) {
      printed_probing_set += signal_name + " (" + cycle + ")";
    } else {
      printed_probing_set += signal_name + " (" + cycle + "), ";
    }
  }

  return printed_probing_set;
}

template std::string ProbingSet<GlitchExtendedProbe>::PrintStandardProbes(
    const CircuitStruct&, std::vector<Probe>&);

template <>
std::string ProbingSet<GlitchExtendedProbe>::PrintExtendedProbes(
    const CircuitStruct& circuit, std::vector<Probe>& extended_probes) {
  unsigned int signal_index;
  std::string cycle, printed_probing_set, signal_name;
  size_t number_of_extended_probes = GetNumberOfProbeExtensions();

  for (size_t probe_index = 0; probe_index < number_of_extended_probes;
       ++probe_index) {
    signal_index =
        extended_probes[GetExtendedProbeIndex(probe_index)].GetSignalIndex();
    signal_name = circuit.Signals[signal_index]->Name;
    cycle = std::to_string(
        extended_probes[GetExtendedProbeIndex(probe_index)].GetCycle());

    if (probe_index == (number_of_extended_probes - 1)) {
      printed_probing_set += signal_name + " (" + cycle + ")";
    } else {
      printed_probing_set += signal_name + " (" + cycle + "), ";
    }
  }

  return printed_probing_set;
}

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator<(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ < other.probe_extension_indices_);
}

template bool ProbingSet<GlitchExtendedProbe>::operator<(
    const ProbingSet<GlitchExtendedProbe>&) const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator==(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ == other.probe_extension_indices_);
}

template bool ProbingSet<GlitchExtendedProbe>::operator==(
    const ProbingSet<GlitchExtendedProbe>&) const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator!=(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ != other.probe_extension_indices_);
}

template bool ProbingSet<GlitchExtendedProbe>::operator!=(
    const ProbingSet<GlitchExtendedProbe>&) const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::Includes(
    const ProbingSet<ExtensionContainer>& other) const {
  if (IsRemovable() || other.IsRemovable()) {
    return false;
  } else {
    if (GetNumberOfProbeExtensions() <= other.GetNumberOfProbeExtensions()) {
      return false;
    } else {
      if ((GetFirstProbeExtension() >= other.GetFirstProbeExtension()) &&
          (GetLastProbeExtension() <= other.GetLastProbeExtension())) {
        if (std::includes(probe_extension_indices_.begin(),
                          probe_extension_indices_.end(),
                          other.probe_extension_indices_.begin(),
                          other.probe_extension_indices_.end(),
                          std::greater<ExtensionContainer>())) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}

template bool ProbingSet<GlitchExtendedProbe>::Includes(
    const ProbingSet<GlitchExtendedProbe>&) const;

template <>
void ProbingSet<GlitchExtendedProbe>::NormalTableUpdate(
    SimulationStruct& simulation, std::vector<Probe>& extended_probes) {
  unsigned int group_index;
  unsigned char hash_value0, hash_value1;
  hardware::stats::Key key;
  size_t bit_index, key_index, tmp_index;
  size_t number_of_layers = contingency_table_.GetNumberOfLayers();
  size_t number_of_extended_probes = GetNumberOfProbeExtensions();
  size_t key_size = contingency_table_.GetKeySizeExcludingHashValues();
  std::vector<GlitchExtendedProbe> probe_extension_indices =
      GetAllProbeExtensions();
  std::vector<unsigned int> signal_indices(number_of_extended_probes);
  std::vector<unsigned int> cycles(number_of_extended_probes);

  for (bit_index = 0; bit_index < number_of_extended_probes; ++bit_index) {
    signal_indices[bit_index] =
        simulation.GlitchExtendedProbeIndex_of_Signal
            [extended_probes[probe_extension_indices[bit_index]]
                 .GetSignalIndex()];
    cycles[bit_index] =
        extended_probes[probe_extension_indices[bit_index]].GetCycle();
  }

  for (uint64_t sim_index = 0; sim_index < simulation.NumberOfStepSimulations;
       ++sim_index) {
    hash_value0 = 0;
    hash_value1 = 0;
    key = std::make_unique<unsigned char[]>(key_size);

    // Set first hash value
    for (bit_index = 0;
         (bit_index < 8) && (bit_index < number_of_extended_probes);
         ++bit_index) {
      hash_value0 <<= 1;
      hash_value0 |= simulation.ProbeValues[sim_index][cycles[bit_index]]
                                           [signal_indices[bit_index]];
    }

    // Set second hash value
    for (bit_index = 8;
         (bit_index < 16) && (bit_index < number_of_extended_probes);
         ++bit_index) {
      hash_value1 <<= 1;
      hash_value1 |= simulation.ProbeValues[sim_index][cycles[bit_index]]
                                           [signal_indices[bit_index]];
    }

    // Get regular key
    for (key_index = 0; key_index < key_size; ++key_index) {
      tmp_index = key_size - key_index - 1;
      for (bit_index = (key_index + number_of_layers) << 3;
           bit_index < ((key_index + number_of_layers + 1) << 3) &&
           (bit_index < number_of_extended_probes);
           ++bit_index) {
        key[tmp_index] <<= 1;
        key[tmp_index] |= simulation.ProbeValues[sim_index][cycles[bit_index]]
                                                [signal_indices[bit_index]];
      }
    }

    group_index = simulation.SelectedGroups[sim_index];
    contingency_table_.UpdateTable(std::move(key), hash_value0, hash_value1,
                                   simulation.NumberOfGroups, group_index);
  }
}

template <class ExtensionContainer>
unsigned int* ProbingSet<ExtensionContainer>::GetCounters(size_t index) {
  return contingency_table_.GetCounters(index);
}

template unsigned int* ProbingSet<GlitchExtendedProbe>::GetCounters(size_t);

template <>
bool ProbingSet<GlitchExtendedProbe>::ContainsExtension(size_t index) {
  return std::find(probe_extension_indices_.begin(),
                   probe_extension_indices_.end(),
                   index) != probe_extension_indices_.end();
}

Probe::Probe(unsigned int signal_index, unsigned int clock_cycle)
    : signal_index_(signal_index), clock_cycle_(clock_cycle) {}

UniqueProbe::UniqueProbe(unsigned int signal_index, unsigned int clock_cycle,
                         std::vector<unsigned int> probing_set_indices)
    : Probe(signal_index, clock_cycle),
      probing_set_indices_(probing_set_indices) {}

}  // namespace probing
}  // namespace Hardware