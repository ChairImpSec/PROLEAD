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

template <class ExtensionContainer>
AbstractProbeExtension<ExtensionContainer>::AbstractProbeExtension(
    unsigned int signal_index)
    : signal_index_(signal_index) {}

template <class ExtensionContainer>
unsigned int AbstractProbeExtension<ExtensionContainer>::GetSignalIndex() {
  return signal_index_;
}

template <>
std::vector<unsigned int>
AbstractProbeExtension<GlitchExtendedProbe>::GetAllExtensionIndices() {
  return extension_indices_;
}

template <class ExtensionContainer>
std::vector<ExtensionContainer>
AbstractProbeExtension<ExtensionContainer>::GetExtensionContainer() {
  return extension_indices_;
}

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
  return probing_set_indices_[index];
}

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetNumberOfStandardProbes() const {
  return standard_probe_indices_.size();
}

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetStandardProbeIndex(
    size_t standard_probe_index) {
  return standard_probe_indices_[standard_probe_index];
}

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetExtendedProbeIndex(
    size_t extended_probe_index) {
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
size_t ProbingSet<ExtensionContainer>::GetNumberOfProbeExtensions() const {
  return probe_extension_indices_.size();
}

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

template <class ExtensionContainer>
std::vector<ExtensionContainer>
ProbingSet<ExtensionContainer>::GetAllProbeExtensions() const {
  return probe_extension_indices_;
}

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::IsRemovable() const {
  return contingency_table_.IsRemovable();
}

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::MarkAsRemovable() {
  contingency_table_.MarkAsRemovable();
}

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ResetGValue() {
  contingency_table_.ResetGValue();
}

template <class ExtensionContainer>
double ProbingSet<ExtensionContainer>::GetGValue() {
  return contingency_table_.GetGValue();
}

template <class ExtensionContainer>
size_t ProbingSet<ExtensionContainer>::GetNumberOfRequiredTraces() {
  return contingency_table_.GetNumberOfRequiredTraces();
}

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ComputeGTest(
    size_t number_of_groups, size_t number_of_simulations,
    std::vector<double> frequencies) {
  contingency_table_.ComputeGTest(number_of_groups, number_of_simulations,
                                  frequencies);
}

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ComputeNumberOfRequiredTraces(
    size_t number_of_groups, double beta_threshold, double effect_size) {
  contingency_table_.ComputeNumberOfRequiredTraces(number_of_groups,
                                                   beta_threshold, effect_size);
}

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::Initialize(size_t number_of_groups,
                                                bool is_in_compact_mode) {
  contingency_table_.Initialize(number_of_groups, GetNumberOfProbeExtensions(),
                                is_in_compact_mode);
}

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

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator==(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ == other.probe_extension_indices_);
}

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator!=(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ != other.probe_extension_indices_);
}

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

template <>
bool ProbingSet<GlitchExtendedProbe>::ContainsExtension(size_t index) {
  return std::find(probe_extension_indices_.begin(),
                   probe_extension_indices_.end(),
                   index) != probe_extension_indices_.end();
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfUniqueProbes() {
  return unique_probes_.size();
}

template <>
void Adversaries<GlitchExtendedProbe>::CompactTableUpdate(
    Hardware::SimulationStruct& simulation, unsigned int simulation_index) {
  size_t probe_index, set_index;
  std::vector<int> probe_values(GetNumberOfProbingSets(), 0);

  for (probe_index = 0; probe_index < GetNumberOfUniqueProbes();
       probe_index++) {
    if (simulation
            .ProbeValues[simulation_index]
                        [unique_probes_[probe_index].GetCycle()]
                        [simulation.GlitchExtendedProbeIndex_of_Signal
                             [unique_probes_[probe_index].GetSignalIndex()]]) {
      for (set_index = 0;
           set_index < unique_probes_[probe_index].GetNumberOfProbeSetIndices();
           set_index++) {
        ++probe_values.at(
            unique_probes_[probe_index].GetProbeSetIndex(set_index));
      }
    }
  }

  for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
#pragma omp atomic
    ++probing_sets_[set_index].GetCounters(
        probe_values[set_index])[simulation.SelectedGroups[simulation_index]];
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::CompactTest(
    Hardware::SimulationStruct& simulation,
    const std::vector<double>& number_of_simulations_per_group) {
#pragma omp parallel for schedule(guided)
  for (uint64_t index = 0; index < simulation.NumberOfStepSimulations;
       index++) {
    CompactTableUpdate(simulation, index);
  }

#pragma omp parallel for schedule(guided)
  for (size_t index = 0; index < GetNumberOfProbingSets(); index++) {
    probing_sets_[index].ComputeGTest(simulation.NumberOfGroups,
                                      simulation.NumberOfProcessedSimulations,
                                      number_of_simulations_per_group);
  }
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfProbingSets() {
  return probing_sets_.size();
}

template <class ExtensionContainer>
bool Adversaries<ExtensionContainer>::IsInDistance(
    std::vector<unsigned int>& standard_probe_indices,
    SettingsStruct& settings) {
  unsigned int standard_probe_index;
  std::vector<unsigned int> cycles(standard_probe_indices.size());

  for (size_t index = 0; index < standard_probe_indices.size(); ++index) {
    standard_probe_index = standard_probe_indices[index];
    cycles[index] = standard_probes_[standard_probe_index].GetCycle();
  }

  std::sort(cycles.begin(), cycles.end());
  int distance = cycles.back() - cycles.front();
  bool is_distance_small_enough = distance <= settings.MaxDistanceMultivariet;
  bool is_no_unallowed_univariate_set =
      (settings.TestMultivariate != 2) || distance != 0;
  return is_distance_small_enough && is_no_unallowed_univariate_set;
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::SearchExtendedProbe(
    unsigned int signal_index, unsigned int clock_cycle) {
  Probe probe(signal_index, clock_cycle);
  std::vector<Probe>::iterator it = std::lower_bound(
      extended_probes_.begin(), extended_probes_.end(), probe,
      [](const Probe& lhs, const Probe& rhs) { return lhs < rhs; });
  std::iterator_traits<std::vector<Probe>::iterator>::difference_type diff =
      std::distance(extended_probes_.begin(), it);

  if ((it == extended_probes_.end()) || (extended_probes_.at(diff) != probe)) {
    std::string error_message =
        "A glitch-extended probe was not found in the list of glitch-extended "
        "probes.\n  signal index: " +
        std::to_string(signal_index) +
        ", clock cycle: " + std::to_string(clock_cycle);
    throw std::runtime_error(error_message);
  }

  return (size_t)diff;
}

template <>
std::vector<GlitchExtendedProbe>
Adversaries<GlitchExtendedProbe>::ReplaceWireIndexWithListIndex(
    const std::vector<GlitchExtendedProbe>& signal_indices,
    unsigned int clock_cycle, bool is_with_transitional_leakage) {
  std::vector<GlitchExtendedProbe> extended_probe_indices;
  unsigned int signal_index;
  size_t index;

  for (index = 0; index < signal_indices.size(); ++index) {
    signal_index = signal_indices[index];
    extended_probe_indices.push_back(
        SearchExtendedProbe(signal_index, clock_cycle));

    if (is_with_transitional_leakage && (clock_cycle != 0)) {
      extended_probe_indices.push_back(
          SearchExtendedProbe(signal_index, clock_cycle - 1));
    }
  }

  return extended_probe_indices;
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::AddProbingSet(
    std::vector<unsigned int>& standard_probe_indices,
    bool is_with_transitional_leakage, SettingsStruct& settings) {
  size_t index;
  unsigned int signal_index, clock_cycle;
  std::vector<ExtensionContainer> extended_probes_indices, signal_indices;

  if (IsInDistance(standard_probe_indices, settings)) {
    for (index = 0; index < standard_probe_indices.size(); ++index) {
      signal_index =
          standard_probe_indices[index] % GetNumberOfProbeExtensions();
      clock_cycle = settings.TestClockCycles[standard_probe_indices[index] /
                                             GetNumberOfProbeExtensions()] -
                    1;
      signal_indices = probe_extensions_[signal_index].GetExtensionContainer();
      extended_probes_indices = ReplaceWireIndexWithListIndex(
          signal_indices, clock_cycle, is_with_transitional_leakage);
    }

    RemoveDuplicates(extended_probes_indices);
    probing_sets_.emplace_back(standard_probe_indices, extended_probes_indices);
  }
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfProbeExtensions() {
  return probe_extensions_.size();
}

template size_t Adversaries<GlitchExtendedProbe>::GetNumberOfProbeExtensions();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfStandardProbes() {
  return standard_probes_.size();
}

template size_t Adversaries<GlitchExtendedProbe>::GetNumberOfStandardProbes();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfExtendedProbes() {
  return extended_probes_.size();
}

template size_t Adversaries<GlitchExtendedProbe>::GetNumberOfExtendedProbes();

template <>
void Adversaries<GlitchExtendedProbe>::SetProbeExtensions(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings) {
  int input_index, signal_index;
  // finding the probes at the input of registers or signals which are not
  // connected to anywhere (but are primary output)
  for (signal_index = circuit.NumberOfConstants;
       signal_index < circuit.NumberOfSignals; ++signal_index) {
    if (circuit.IsProbeOnSignalAllowed(signal_index, signal_index,
                                       settings.ClockSignal)) {
      for (input_index = 0;
           input_index < circuit.Signals[signal_index]->NumberOfInputs;
           ++input_index) {
        if (library
                .CellTypes[circuit
                               .Cells[circuit.Signals[signal_index]
                                          ->Inputs[input_index]]
                               ->Type]
                ->GateOrReg == CellType_Gate) {
          break;
        }
      }

      if (input_index >= circuit.Signals[signal_index]->NumberOfInputs) {
        probe_extensions_.emplace_back(signal_index, library, circuit,
                                       settings);

        if (!probe_extensions_.back().GetAllExtensionIndices().size()) {
          std::cout << "    Warning A probe on signal \""
                    << circuit.Signals[signal_index]->Name
                    << "\" does not record any useful information. PROLEAD "
                       "automatically removes the probe on \""
                    << circuit.Signals[signal_index]->Name
                    << "\" during the evaluation!" << std::endl;
          probe_extensions_.pop_back();
        }
      }
    }
  }

  std::sort(probe_extensions_.begin(), probe_extensions_.end(),
            [](Hardware::probing::ProbeExtension<GlitchExtendedProbe>& lhs,
               Hardware::probing::ProbeExtension<GlitchExtendedProbe>& rhs) {
              return lhs.GetSignalIndex() < rhs.GetSignalIndex();
            });
}

Probe::Probe(unsigned int signal_index, unsigned int clock_cycle)
    : signal_index_(signal_index), clock_cycle_(clock_cycle) {}
UniqueProbe::UniqueProbe(unsigned int signal_index, unsigned int clock_cycle,
                         std::vector<unsigned int> probing_set_indices)
    : Probe(signal_index, clock_cycle),
      probing_set_indices_(probing_set_indices) {}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetStandardProbes(
    SettingsStruct& settings) {
  size_t extension_index;

  for (int cycle_index = 0; cycle_index < settings.NumberOfTestClockCycles;
       ++cycle_index) {
    for (extension_index = 0; extension_index < GetNumberOfProbeExtensions();
         ++extension_index) {
      standard_probes_.emplace_back(
          probe_extensions_[extension_index].GetSignalIndex(),
          settings.TestClockCycles[cycle_index] - 1);
    }
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetExtendedProbes(
    SettingsStruct& settings) {
  int cycle_index;
  size_t extension_index, probe_index;
  std::vector<unsigned int> probe_extensions;

  for (extension_index = 0; extension_index < GetNumberOfProbeExtensions();
       ++extension_index) {
    probe_extensions =
        probe_extensions_[extension_index].GetAllExtensionIndices();

    for (probe_index = 0; probe_index < probe_extensions.size();
         ++probe_index) {
      for (cycle_index = 0; cycle_index < settings.NumberOfTestClockCycles;
           ++cycle_index) {
        if (settings.TestTransitional &&
            ((settings.TestClockCycles[cycle_index] - 1) != 0)) {
          extended_probes_.emplace_back(
              probe_extensions[probe_index],
              settings.TestClockCycles[cycle_index] - 2);
        }

        extended_probes_.emplace_back(
            probe_extensions[probe_index],
            settings.TestClockCycles[cycle_index] - 1);
      }
    }
  }

  std::sort(extended_probes_.begin(), extended_probes_.end(),
            [](Probe& lhs, Probe& rhs) { return lhs < rhs; });
  extended_probes_.erase(
      std::unique(extended_probes_.begin(), extended_probes_.end(),
                  [](Probe& lhs, Probe& rhs) { return lhs == rhs; }),
      extended_probes_.end());
}

template <class ExtensionContainer>
Adversaries<ExtensionContainer>::Adversaries(LibraryStruct& library,
                                             CircuitStruct& circuit,
                                             SettingsStruct& settings) {
  SetProbeExtensions(library, circuit, settings);
  SetStandardProbes(settings);
  SetExtendedProbes(settings);
}

template Adversaries<GlitchExtendedProbe>::Adversaries(LibraryStruct&,
                                                       CircuitStruct&,
                                                       SettingsStruct&);

template <>
unsigned int Adversaries<GlitchExtendedProbe>::GetHighestClockCycle(
    size_t probing_set_index) {
  return extended_probes_[probing_sets_[probing_set_index]
                              .GetLastProbeExtension()]
      .GetCycle();
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::
    RemoveOneStrictlyLessInformativeProbingSet(unsigned int set_index,
                                               unsigned int start,
                                               unsigned int end) {
  for (unsigned int index = start; index < end; index++) {
    if (set_index != index) {
      if (probing_sets_[set_index].Includes(probing_sets_[index])) {
        probing_sets_[index].MarkAsRemovable();
      }
    }
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveStrictlyLessInformativeProbingSets(
    unsigned int start, unsigned int end) {
  for (unsigned int index = start; index < end; index++) {
    RemoveOneStrictlyLessInformativeProbingSet(index, start, end);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveDuplicatedProbingSets() {
  std::cout << "Remove duplicated probing sets..." << std::flush;
  std::sort(probing_sets_.begin(), probing_sets_.end(),
            [](ProbingSet<ExtensionContainer>& lhs,
               ProbingSet<ExtensionContainer>& rhs) { return lhs < rhs; });
  probing_sets_.erase(std::unique(probing_sets_.begin(), probing_sets_.end(),
                                  [](ProbingSet<ExtensionContainer>& lhs,
                                     ProbingSet<ExtensionContainer>& rhs) {
                                    return lhs == rhs;
                                  }),
                      probing_sets_.end());
  std::cout << GetNumberOfProbingSets() << " probing sets remain...done!"
            << std::endl;
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::
    RemoveUninformativeProbingSetsInUnivariateSetting(
        size_t number_of_probing_sets) {
  std::vector<unsigned int> start_indices(1, 0), end_indices;

  for (size_t index = 1; index < number_of_probing_sets; index++) {
    if (GetHighestClockCycle(index - 1) != GetHighestClockCycle(index)) {
      start_indices.push_back(index);
      end_indices.push_back(index);
    }
  }

  end_indices.push_back(number_of_probing_sets);

// Each set of probing sets with the same clock cycle can be minimized in
// parallel As they are independend, the runtime is decreased
#pragma omp parallel for schedule(guided)
  for (size_t index = 0; index < start_indices.size(); ++index) {
    RemoveStrictlyLessInformativeProbingSets(start_indices[index],
                                             end_indices[index]);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveUninformativeProbingSets(
    SettingsStruct& settings) {
  RemoveDuplicatedProbingSets();
  size_t number_of_probing_sets = GetNumberOfProbingSets();

  if (settings.MinimizeProbeSets) {
    std::cout << "Remove strictly less informative probing sets..."
              << std::flush;
    if (settings.IsInMultivariateSetting()) {
      std::cout << "Setting multivariate case..." << std::flush;
      RemoveStrictlyLessInformativeProbingSets(0, number_of_probing_sets);
    } else {
      std::cout << "Setting univariate case..." << std::flush;
      if (settings.NumberOfTestClockCycles != 1) {
        RemoveUninformativeProbingSetsInUnivariateSetting(
            number_of_probing_sets);
      } else {
        if (number_of_probing_sets > 1) {
          RemoveStrictlyLessInformativeProbingSets(0, number_of_probing_sets);
        }
      }
    }

    probing_sets_.erase(
        std::remove_if(probing_sets_.begin(), probing_sets_.end(),
                       [](const ProbingSet<ExtensionContainer>& lhs) {
                         return lhs.IsRemovable();
                       }),
        probing_sets_.end());
    std::cout << "done! " << GetNumberOfProbingSets() << " probing sets remain!"
              << std::endl;
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::InitializeUnivariateProbeCombinations(
    SettingsStruct& settings, std::vector<unsigned int>& combination,
    std::vector<bool>& combination_bitmask) {
  int number_of_probe_extensions = GetNumberOfProbeExtensions();
  // Cover the case that the order is higher than the number of different
  // probe positions In this case, multiple probing set with probes on all
  // positions are generated
  if (settings.TestOrder > number_of_probe_extensions) {
    combination.resize(number_of_probe_extensions);
    std::fill(combination_bitmask.begin(), combination_bitmask.end(), true);
  } else {
    combination.resize(settings.TestOrder);
    std::fill(combination_bitmask.begin(),
              combination_bitmask.begin() + settings.TestOrder, true);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::InitializeMultivariateProbeCombinations(
    SettingsStruct& settings, std::vector<unsigned int>& combination,
    std::vector<bool>& combination_bitmask) {
  int number_of_standard_probes = GetNumberOfStandardProbes();
  // Cover the case that the order is higher than the number of standard
  // probes In this case, only one probing set including all standard probes
  // is generated
  if (settings.TestOrder > number_of_standard_probes) {
    combination.resize(number_of_standard_probes);
    std::fill(combination_bitmask.begin(), combination_bitmask.end(), true);
  } else {
    combination.resize(settings.TestOrder);
    std::fill(combination_bitmask.begin(),
              combination_bitmask.begin() + settings.TestOrder, true);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::PrintProbingSetInformation() {
  std::vector<std::string> table_body(6);
  std::vector<std::string> table_header = {
      "#Standard Probes",        "#Extended Probes",
      "#Probing Sets",           "Minimum #Probes per Set",
      "Maximum #Probes per Set", "Average #Probes per Set"};
  std::vector<unsigned int> table_widths = {19, 19, 16, 26, 26, 26};

  size_t full_table_width = 133;

  size_t minimum_number_of_probes_in_a_set =
      std::min_element(probing_sets_.begin(), probing_sets_.end(),
                       [](const ProbingSet<ExtensionContainer>& lhs,
                          const ProbingSet<ExtensionContainer>& rhs) {
                         return lhs.GetNumberOfProbeExtensions() <
                                rhs.GetNumberOfProbeExtensions();
                       })
          ->GetNumberOfProbeExtensions();

  size_t maximum_number_of_probes_in_a_set =
      std::max_element(probing_sets_.begin(), probing_sets_.end(),
                       [](const ProbingSet<ExtensionContainer>& lhs,
                          const ProbingSet<ExtensionContainer>& rhs) {
                         return lhs.GetNumberOfProbeExtensions() <
                                rhs.GetNumberOfProbeExtensions();
                       })
          ->GetNumberOfProbeExtensions();

  double average_number_of_probes_in_a_set =
      std::accumulate(
          probing_sets_.begin(), probing_sets_.end(), 0,
          [](unsigned int sum, ProbingSet<ExtensionContainer>& set) {
            return sum + set.GetNumberOfProbeExtensions();
          }) /
      (double)GetNumberOfProbingSets();

  table_body[0] = std::to_string(GetNumberOfStandardProbes());
  table_body[1] = std::to_string(GetNumberOfExtendedProbes());
  table_body[2] = std::to_string(GetNumberOfProbingSets());
  table_body[3] = std::to_string(minimum_number_of_probes_in_a_set);
  table_body[4] = std::to_string(maximum_number_of_probes_in_a_set);
  table_body[5] = std::to_string(average_number_of_probes_in_a_set);

  Util::PrintHorizontalLine(full_table_width);
  std::cout.setf(std::ios::right, std::ios::adjustfield);
  Util::PrintRow(table_widths, table_header);
  Util::PrintHorizontalLine(full_table_width);
  Util::PrintRow(table_widths, table_body);
  Util::PrintHorizontalLine(full_table_width);
  std::cout << std::endl;
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetMaximumLengthOfProbeNames(
    const CircuitStruct& circuit) {
  std::string printed_probing_set;
  size_t number_of_probing_sets = GetNumberOfProbingSets();
  size_t number_of_characters = 47;

  for (size_t set_index = 0; set_index < number_of_probing_sets; ++set_index) {
    printed_probing_set =
        probing_sets_[set_index].PrintStandardProbes(circuit, standard_probes_);

    if (printed_probing_set.length() > number_of_characters) {
      number_of_characters = printed_probing_set.length();
    }

    printed_probing_set.clear();
  }

  return number_of_characters;
}

template size_t Adversaries<GlitchExtendedProbe>::GetMaximumLengthOfProbeNames(
    const CircuitStruct&);

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::PrintEvaluationHeader(
    const CircuitStruct& circuit) {
  size_t table_width = GetMaximumLengthOfProbeNames(circuit);
  std::vector<std::string> table_header = {
      "Elapsed Time",
      "Required Ram",
      "Processed Simulations",
      "Probing Set with highest Information Leakage",
      "-log10(p)",
      "Status"};
  std::vector<unsigned int> table_widths = {
      20, 20, 25, (unsigned int)table_width, 13, 10};
  table_width += 89;

  Util::PrintHorizontalLine(table_width);
  std::cout.setf(std::ios::right, std::ios::adjustfield);
  Util::PrintRow(table_widths, table_header);
  Util::PrintHorizontalLine(table_width);

  return table_width - 89;
}

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetIndexOfMostLeakingProbingSet() {
  size_t index = 0, set_index;
  double g_value, maximum = 0.0;

  for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
    g_value = probing_sets_[set_index].GetGValue();

    if (g_value > maximum) {
      maximum = g_value;
      index = set_index;
    }
  }

  return index;
}

template size_t
Adversaries<GlitchExtendedProbe>::GetIndexOfMostLeakingProbingSet();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetMaximumNumberOfRequiredTraces() {
  size_t number_of_traces, maximum = 0, set_index;

  for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
    number_of_traces = probing_sets_[set_index].GetNumberOfRequiredTraces();

    if (number_of_traces > maximum) {
      maximum = number_of_traces;
    }
  }

  return maximum;
}

template size_t
Adversaries<GlitchExtendedProbe>::GetMaximumNumberOfRequiredTraces();

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::PrintEvaluationBody(
    const CircuitStruct& circuit, const SettingsStruct& settings,
    const SimulationStruct& simulation, double& maximum_g_value_deleted,
    std::string& printed_probing_set_deleted, double elapsed_time_period,
    size_t space) {
  std::vector<unsigned int> table_widths = {20, 20, 25, (unsigned int)space,
                                            13, 10};
  std::vector<std::string> table_body(6);
  size_t maximum_index = GetIndexOfMostLeakingProbingSet();
  size_t number_of_traces = GetMaximumNumberOfRequiredTraces();
  double maximum_g_value = probing_sets_[maximum_index].GetGValue();
  double printed_g_value = std::max(maximum_g_value, maximum_g_value_deleted);

  table_body[0] = std::to_string(elapsed_time_period) + "s";
  table_body[1] = std::to_string(Util::PrintMemoryConsumption() / 1e6) + "GB";

  if (settings.CompactDistributions) {
    table_body[2] = std::to_string(simulation.NumberOfProcessedSimulations);
  } else {
    table_body[2] = std::to_string(simulation.NumberOfProcessedSimulations) +
                    " / " + std::to_string(number_of_traces);
  }

  if (maximum_g_value > maximum_g_value_deleted) {
    table_body[3] = probing_sets_[maximum_index].PrintStandardProbes(
        circuit, standard_probes_);
  } else {
    table_body[3] = printed_probing_set_deleted;
  }

  table_body[4] = std::to_string(printed_g_value);

  if (printed_g_value < 5.0) {
    table_body[5] = "OKAY";
  } else {
    table_body[5] = "LEAKAGE";
  }

  Util::PrintRow(table_widths, table_body);
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveProbingSetsWithEnoughTraces(
    const CircuitStruct& circuit, uint64_t number_of_simulations,
    double& maximum_g_value_deleted, std::string& printed_probing_set_deleted) {
  double g_value;

  for (size_t set_index = 0; set_index < GetNumberOfProbingSets();
       ++set_index) {
    if (number_of_simulations >
        probing_sets_[set_index].GetNumberOfRequiredTraces()) {
      g_value = probing_sets_[set_index].GetGValue();

      if (g_value > maximum_g_value_deleted) {
        maximum_g_value_deleted = g_value;
        printed_probing_set_deleted =
            probing_sets_[set_index].PrintStandardProbes(circuit,
                                                         standard_probes_);
      }
    }
  }

  probing_sets_.erase(
      std::remove_if(
          probing_sets_.begin(), probing_sets_.end(),
          [&number_of_simulations](ProbingSet<ExtensionContainer>& Ps) {
            return (number_of_simulations > Ps.GetNumberOfRequiredTraces());
          }),
      probing_sets_.end());
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetUniqueProbes() {
  size_t probe_index, set_index;
  unsigned int signal_index, clock_cycle;
  std::vector<unsigned int> probing_set_indices;

  for (probe_index = 0; probe_index < GetNumberOfExtendedProbes();
       ++probe_index) {
    signal_index = extended_probes_[probe_index].GetSignalIndex();
    clock_cycle = extended_probes_[probe_index].GetCycle();

    for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
      if (probing_sets_[set_index].ContainsExtension(probe_index)) {
        probing_set_indices.push_back(set_index);
      }
    }

    unique_probes_.emplace_back(signal_index, clock_cycle, probing_set_indices);
    probing_set_indices.clear();
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::Test(
    Hardware::SettingsStruct& settings, Hardware::SimulationStruct& simulation,
    const std::vector<double>& number_of_simulations_per_group,
    bool is_in_compact_mode) {
  if (is_in_compact_mode) {
    CompactTest(simulation, number_of_simulations_per_group);
  } else {
    NormalTest(settings, simulation, number_of_simulations_per_group);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::PrintReport(
    const CircuitStruct& circuit, const SettingsStruct& settings,
    const SimulationStruct& simulation, unsigned int probe_step_index,
    size_t space) {
  std::string report_file_name, printed_standard_probes,
      printed_extended_probes;
  int cycle_index;
  size_t set_index;

  if (settings.ProbeStepSize == UINT_MAX) {
    report_file_name =
        (std::string)simulation.EvaluationResultFolderName + "/Report_" +
        std::to_string(simulation.NumberOfProcessedSimulations) + ".dat";
  } else {
    report_file_name = (std::string)simulation.EvaluationResultFolderName +
                       "/Report_" +
                       std::to_string(simulation.NumberOfProcessedSimulations) +
                       "_Step_" + std::to_string(probe_step_index) + ".dat";
  }

  std::ofstream report_file(report_file_name);
  std::vector<unsigned int> index_of_set_with_highest_g_per_cycle(
      simulation.NumberOfClockCycles, 0);
  std::vector<bool> is_there_a_set_with_highest_g_per_cycle(
      simulation.NumberOfClockCycles, false);
  std::vector<double> maximum_g_value_per_cycle(simulation.NumberOfClockCycles,
                                                0.0);
  unsigned int clock_cycle;
  double g_value;
  int counter;

  report_file << "Report file after " << simulation.NumberOfProcessedSimulations
              << " simulations:" << std::endl
              << std::endl;
  report_file << "1.) Summary of most leaking (and already active) probing "
                 "sets per clock cycle: "
              << std::endl
              << std::endl;

  for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
    clock_cycle = GetHighestClockCycle(set_index);
    g_value = probing_sets_[set_index].GetGValue();

    if (g_value > maximum_g_value_per_cycle[clock_cycle]) {
      index_of_set_with_highest_g_per_cycle[clock_cycle] = set_index;
      is_there_a_set_with_highest_g_per_cycle[clock_cycle] = true;
      maximum_g_value_per_cycle[clock_cycle] = g_value;
    }
  }

  for (cycle_index = 0; cycle_index < simulation.NumberOfTestClockCycles;
       ++cycle_index) {
    clock_cycle = simulation.TestClockCycles[cycle_index] - 1;

    if (is_there_a_set_with_highest_g_per_cycle[clock_cycle]) {
      set_index = index_of_set_with_highest_g_per_cycle[clock_cycle];
      printed_standard_probes = probing_sets_[set_index].PrintStandardProbes(
          circuit, standard_probes_);
      printed_extended_probes = probing_sets_[set_index].PrintExtendedProbes(
          circuit, extended_probes_);
      g_value = probing_sets_[set_index].GetGValue();

      report_file << "Clock cycle " << clock_cycle + 1 << ": @["
                  << printed_standard_probes << "] ==> ["
                  << printed_extended_probes << "] -log10(p) = " << g_value;

      if (g_value > settings.AlphaThreshold) {
        report_file << " --> LEAKAGE" << std::endl;
      } else {
        report_file << " --> OKAY" << std::endl;
      }
    }
  }

  report_file << std::endl;
  report_file << "2.) Summary of the most leakging (and already active) "
                 "probing sets: "
              << std::endl
              << std::endl;

  for (counter = 0; ((counter < settings.Max_No_ReportEntries) &&
                     (counter < (int)GetNumberOfProbingSets()));
       ++counter) {
    set_index = GetIndexOfMostLeakingProbingSet();
    printed_standard_probes =
        probing_sets_[set_index].PrintStandardProbes(circuit, standard_probes_);
    printed_extended_probes =
        probing_sets_[set_index].PrintExtendedProbes(circuit, extended_probes_);
    g_value = probing_sets_[set_index].GetGValue();

    report_file << counter + 1 << ": @[" << printed_standard_probes << "] ==> ["
                << printed_extended_probes << "] -log10(p) = " << g_value;

    if (g_value > settings.AlphaThreshold) {
      report_file << " --> LEAKAGE" << std::endl;
    } else {
      report_file << " --> OKAY" << std::endl;
    }

    probing_sets_[set_index].ResetGValue();

    if (g_value == 0.0) {
      break;
    }
  }

  report_file.close();
  Util::PrintHorizontalLine(space);
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::EvaluateProbingSets(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings,
    SharedDataStruct* shared_data, SimulationStruct& simulation,
    timespec& start_time, unsigned int& probe_step_index) {
  std::vector<double> number_of_simulations_per_group(settings.NumberOfGroups,
                                                      0.0);
  std::vector<boost::mt19937> thread_rng(settings.Max_no_of_Threads);
  uint64_t step_simulation_index, simulation_index;
  omp_set_num_threads(settings.Max_no_of_Threads);
  double elapsed_time_period, maximum_g_value_deleted = 0.0;
  int thread_index;
  std::string printed_probing_set_deleted;
  size_t space, table_width;
  bool is_in_compact_mode = settings.CompactDistributions == 1;

  std::cout << "Evaluate security under the robust probing model!" << std::endl;

  for (size_t set_index = 0; set_index < GetNumberOfProbingSets();
       ++set_index) {
    probing_sets_[set_index].Initialize(settings.NumberOfGroups,
                                        is_in_compact_mode);
  }

  SetUniqueProbes();

  // We use a PRNG that is thread safe
  Util::GenerateThreadRng(thread_rng, settings.Max_no_of_Threads);
  space = PrintEvaluationHeader(circuit);
  table_width = space + 89;

  for (step_simulation_index = 0;
       step_simulation_index <
       (settings.NumberOfSimulations / settings.NumberOfStepSimulations);
       ++step_simulation_index) {
#pragma omp parallel for schedule(guided) private(thread_index)
    for (simulation_index = 0;
         simulation_index < (settings.NumberOfStepSimulations / 64);
         ++simulation_index) {
      thread_index = omp_get_thread_num();
      Hardware::Simulate::All(library, circuit, settings,
                              &shared_data[thread_index], simulation,
                              simulation_index, thread_rng[thread_index]);
    }

    simulation.NumberOfProcessedSimulations =
        (step_simulation_index + 1) * settings.NumberOfStepSimulations;

    for (simulation_index = 0;
         simulation_index < simulation.NumberOfStepSimulations;
         ++simulation_index) {
      number_of_simulations_per_group[simulation
                                          .SelectedGroups[simulation_index]] +=
          1.0;
    }

    Test(settings, simulation, number_of_simulations_per_group,
         is_in_compact_mode);

    elapsed_time_period = Util::EndClock(start_time);
    PrintEvaluationBody(circuit, settings, simulation, maximum_g_value_deleted,
                        printed_probing_set_deleted, elapsed_time_period,
                        space);

    if ((simulation.NumberOfProcessedSimulations %
         settings.NumberOfStepSimulationsToWrite) == 0) {
      PrintReport(circuit, settings, simulation, probe_step_index, table_width);
    }

    if (settings.RemoveProbingSets &&
        !settings.CompactDistributions) {  // Remove probing set if enough
                                           // traces are processed
      RemoveProbingSetsWithEnoughTraces(
          circuit, simulation.NumberOfProcessedSimulations,
          maximum_g_value_deleted, printed_probing_set_deleted);

      if (GetNumberOfProbingSets() == 0) {
        if ((simulation.NumberOfProcessedSimulations %
             settings.NumberOfStepSimulationsToWrite) != 0) {
          PrintReport(circuit, settings, simulation, probe_step_index,
                      table_width);
        }
        break;
      }
    }
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::EvaluateMultivariateRobustProbingSecurity(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings,
    SharedDataStruct* shared_data, SimulationStruct& simulation,
    timespec& start_time) {
  std::cout << "Generate multivariate probing sets..." << std::flush;
  size_t probe_index, number_of_standard_probes = GetNumberOfStandardProbes();
  int combination_index = 0;
  unsigned int probe_step_index = 0;
  std::vector<unsigned int> combination;
  std::vector<bool> combination_bitmask(number_of_standard_probes, false);
  InitializeMultivariateProbeCombinations(settings, combination,
                                          combination_bitmask);
  bool is_with_transitional_leakage = settings.TestTransitional == 1;

  do {
    combination_index = 0;
    probe_index = 0;

    while (combination_index != settings.TestOrder) {
      if (combination_bitmask.at(probe_index)) {
        combination.at(combination_index) = probe_index;
        ++combination_index;
      }

      ++probe_index;
    }

    AddProbingSet(combination, is_with_transitional_leakage, settings);

    if (probing_sets_.size() == (size_t)settings.ProbeStepSize) {
      std::cout << GetNumberOfProbingSets() << " probing sets generated...done!"
                << std::endl;
      RemoveUninformativeProbingSets(settings);
      PrintProbingSetInformation();
      EvaluateProbingSets(library, circuit, settings, shared_data, simulation,
                          start_time, probe_step_index);
      probing_sets_.clear();
      unique_probes_.clear();
    }
  } while (std::prev_permutation(combination_bitmask.begin(),
                                 combination_bitmask.end()));

  if (probing_sets_.size()) {
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!"
              << std::endl;
    RemoveUninformativeProbingSets(settings);
    PrintProbingSetInformation();
    EvaluateProbingSets(library, circuit, settings, shared_data, simulation,
                        start_time, probe_step_index);
    probing_sets_.clear();
    unique_probes_.clear();
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::EvaluateUnivariateRobustProbingSecurity(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings,
    SharedDataStruct* shared_data, SimulationStruct& simulation,
    timespec& start_time) {
  std::cout << "Generate univariate probing sets..." << std::flush;
  size_t probe_index = 0,
         number_of_probe_extensions = GetNumberOfProbeExtensions();
  int combination_index = 0;
  unsigned int probe_step_index = 0;
  std::vector<unsigned int> combination;
  std::vector<bool> combination_bitmask(number_of_probe_extensions, false);
  bool is_with_transitional_leakage = settings.TestTransitional == 1;

  for (int cycle_index = 0; cycle_index < settings.NumberOfTestClockCycles;
       ++cycle_index) {
    InitializeUnivariateProbeCombinations(settings, combination,
                                          combination_bitmask);

    do {
      combination_index = 0;
      probe_index = 0;

      while (combination_index != settings.TestOrder) {
        if (combination_bitmask.at(probe_index)) {
          combination.at(combination_index) =
              cycle_index * number_of_probe_extensions + probe_index;
          ++combination_index;
        }

        ++probe_index;
      }

      AddProbingSet(combination, is_with_transitional_leakage, settings);

      if (probing_sets_.size() == (size_t)settings.ProbeStepSize) {
        std::cout << GetNumberOfProbingSets()
                  << " probing sets generated...done!" << std::endl;
        RemoveUninformativeProbingSets(settings);
        PrintProbingSetInformation();
        EvaluateProbingSets(library, circuit, settings, shared_data, simulation,
                            start_time, probe_step_index);
        probing_sets_.clear();
        unique_probes_.clear();
      }

    } while (std::prev_permutation(combination_bitmask.begin(),
                                   combination_bitmask.end()));
  }

  if (probing_sets_.size()) {
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!"
              << std::endl;
    RemoveUninformativeProbingSets(settings);
    PrintProbingSetInformation();
    EvaluateProbingSets(library, circuit, settings, shared_data, simulation,
                        start_time, probe_step_index);
    probing_sets_.clear();
    unique_probes_.clear();
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::EvaluateRobustProbingSecurity(
    LibraryStruct& library, CircuitStruct& circuit, SettingsStruct& settings,
    SharedDataStruct* shared_data, SimulationStruct& simulation) {
  struct timespec start_time;
  Util::StartClock(start_time);

  if (settings.IsInMultivariateSetting()) {
    EvaluateMultivariateRobustProbingSecurity(
        library, circuit, settings, shared_data, simulation, start_time);
  } else {
    EvaluateUnivariateRobustProbingSecurity(
        library, circuit, settings, shared_data, simulation, start_time);
  }

  std::cout << "Evaluation done in " << Util::EndClock(start_time)
            << " seconds!" << std::endl;
}

template void Adversaries<GlitchExtendedProbe>::EvaluateRobustProbingSecurity(
    LibraryStruct&, CircuitStruct&, SettingsStruct&, SharedDataStruct*,
    SimulationStruct&);

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::NormalTest(
    SettingsStruct& settings, SimulationStruct& simulation,
    const std::vector<double>& number_of_simulations_per_group) {
#pragma omp parallel for schedule(guided)
  for (size_t set_index = 0; set_index < GetNumberOfProbingSets();
       ++set_index) {
    probing_sets_[set_index].NormalTableUpdate(simulation, extended_probes_);
    probing_sets_[set_index].ComputeGTest(
        settings.NumberOfGroups, simulation.NumberOfProcessedSimulations,
        number_of_simulations_per_group);
    probing_sets_[set_index].ComputeNumberOfRequiredTraces(
        settings.NumberOfGroups, settings.BetaThreshold, settings.EffectSize);
  }
}
}  // namespace probing
}  // namespace Hardware