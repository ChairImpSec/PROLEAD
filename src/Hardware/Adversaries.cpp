#include "Hardware/Adversaries.hpp"

namespace Hardware{

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfPropagations() {
  return propagations_.size();
}

template size_t Adversaries<RobustProbe>::GetNumberOfPropagations();
template size_t Adversaries<RelaxedProbe>::GetNumberOfPropagations();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfSpots() {
  std::vector<uint64_t> spots;

  for (Probe it : standard_probes_){
    spots.push_back(it.GetSignalIndex());
  }

  std::sort(spots.begin(), spots.end());
  spots.erase(std::unique(spots.begin(), spots.end()), spots.end());
  return spots.size();
}

template <class ExtensionContainer>
Propagation<ExtensionContainer> Adversaries<ExtensionContainer>::GetPropagation(uint64_t index) {
  return propagations_[index];
}

template Propagation<RobustProbe> Adversaries<RobustProbe>::GetPropagation(uint64_t);
template Propagation<RelaxedProbe> Adversaries<RelaxedProbe>::GetPropagation(uint64_t);

template <class ExtensionContainer>
std::vector<Propagation<ExtensionContainer>> Adversaries<ExtensionContainer>::GetPropagations() {
  return propagations_;
}

template std::vector<Propagation<RobustProbe>> Adversaries<RobustProbe>::GetPropagations();
template std::vector<Propagation<RelaxedProbe>> Adversaries<RelaxedProbe>::GetPropagations();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfStandardProbes() {
  return standard_probes_.size();
}

template size_t Adversaries<RobustProbe>::GetNumberOfStandardProbes();
template size_t Adversaries<RelaxedProbe>::GetNumberOfStandardProbes();

template <class ExtensionContainer>
Probe Adversaries<ExtensionContainer>::GetStandardProbe(size_t index) {
  return standard_probes_[index];
}

template Probe Adversaries<RobustProbe>::GetStandardProbe(size_t);
template Probe Adversaries<RelaxedProbe>::GetStandardProbe(size_t);

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfExtendedProbes() {
  return extended_probes_.size();
}

template size_t Adversaries<RobustProbe>::GetNumberOfExtendedProbes();
template size_t Adversaries<RelaxedProbe>::GetNumberOfExtendedProbes();

template <class ExtensionContainer>
Probe Adversaries<ExtensionContainer>::GetProbeExtension(size_t index) {
  return extended_probes_[index];
}

template Probe Adversaries<RobustProbe>::GetProbeExtension(size_t);
template Probe Adversaries<RelaxedProbe>::GetProbeExtension(size_t);

template <class ExtensionContainer>
std::vector<Probe> Adversaries<ExtensionContainer>::GetProbeExtensions() {
  return extended_probes_;
}

template std::vector<Probe> Adversaries<RobustProbe>::GetProbeExtensions();
template std::vector<Probe> Adversaries<RelaxedProbe>::GetProbeExtensions();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfEnablers(){
  return enabler_.size();
}

template size_t Adversaries<RobustProbe>::GetNumberOfEnablers();
template size_t Adversaries<RelaxedProbe>::GetNumberOfEnablers();

template <>
Enabler<CustomOperation> Adversaries<RelaxedProbe>::GetEnabler(size_t index){
  return enabler_[index];
}

template <class ExtensionContainer>
std::vector<Enabler<CustomOperation>> Adversaries<ExtensionContainer>::GetEnablers() {
  return enabler_;
}

template std::vector<Enabler<CustomOperation>> Adversaries<RobustProbe>::GetEnablers();
template std::vector<Enabler<CustomOperation>> Adversaries<RelaxedProbe>::GetEnablers();

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::GetNumberOfProbingSets() {
  return probing_sets_.size();
}

template size_t Adversaries<RobustProbe>::GetNumberOfProbingSets();
template size_t Adversaries<RelaxedProbe>::GetNumberOfProbingSets();

template <class ExtensionContainer>
std::vector<uint64_t> Adversaries<ExtensionContainer>::GetProbingSets(){
  return probing_sets_;
}

template <class ExtensionContainer>
std::string Adversaries<ExtensionContainer>::PrintProbingSet(size_t index, CircuitStruct& circuit){
  return printer_.PrintProbingSet(probing_sets_[index], propagations_, extended_probes_, circuit, settings_);
}

template std::string Adversaries<RobustProbe>::PrintProbingSet(size_t, CircuitStruct&);
template std::string Adversaries<RelaxedProbe>::PrintProbingSet(size_t, CircuitStruct&);

template <class ExtensionContainer>
std::vector<Probe*> Adversaries<ExtensionContainer>::GetProbeAddressesOfProbingSet(size_t index){
  return probing_sets_[index].GetProbeAddresses();
}

template std::vector<Probe*> Adversaries<RobustProbe>::GetProbeAddressesOfProbingSet(size_t);
template std::vector<Probe*> Adversaries<RelaxedProbe>::GetProbeAddressesOfProbingSet(size_t);

template <class ExtensionContainer>
  std::vector<uint64_t> Adversaries<ExtensionContainer>::GetProbeExtensionsOfProbingSet(size_t index){
  return probing_sets_[index].GetProbeExtensions();
}

template std::vector<uint64_t> Adversaries<RobustProbe>::GetProbeExtensionsOfProbingSet(size_t);
template std::vector<uint64_t> Adversaries<RelaxedProbe>::GetProbeExtensionsOfProbingSet(size_t);

template <class ExtensionContainer>
size_t Adversaries<ExtensionContainer>::SearchExtendedProbe(uint64_t signal_index, uint64_t clock_cycle) {
  Probe probe(signal_index, clock_cycle);
  std::vector<Probe>::iterator it = std::lower_bound(extended_probes_.begin(), extended_probes_.end(), probe,[](const Probe& lhs, const Probe& rhs) { return lhs < rhs; });
  std::iterator_traits<std::vector<Probe>::iterator>::difference_type diff = std::distance(extended_probes_.begin(), it);

  if ((it == extended_probes_.end()) || (extended_probes_.at(diff) != probe)) {
    std::string error_message ="A glitch-extended probe was not found in the list of glitch-extended probes.\n  signal index: " + std::to_string(signal_index) + ", clock cycle: " + std::to_string(clock_cycle);
    throw std::runtime_error(error_message);
  }

  return (size_t)diff;
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetPropagations() {
    uint64_t number_of_signals = circuit_.NumberOfSignals;

    for (uint64_t index = 0; index < number_of_signals; ++index){
      propagations_.emplace_back(index);
    }

    for (Propagation<ExtensionContainer>& propagation : propagations_){
      propagation.Propagate(library_, circuit_, propagations_);
    }

    propagations_.erase(std::remove_if(propagations_.begin(), propagations_.end(), [this](Propagation<ExtensionContainer> lhs) {
        return lhs.IsObsolete(this->library_, this->circuit_, this->settings_);
    }), propagations_.end());

    std::sort(propagations_.begin(), propagations_.end(), [](Propagation<ExtensionContainer>& lhs, Propagation<ExtensionContainer>& rhs) {
        return lhs.GetSignalIndex() < rhs.GetSignalIndex();
    });

    if (propagations_.empty()) {
        throw std::runtime_error("PROLEAD was not able to found a suited spot for a probe!\n\n This means that all meaningful spots are excluded in the settings file. Please review the settings for the \"probes_include\" and \"probes_exclude\" parameters to ensure they are configured correctly.");
    }
}

template void Adversaries<RobustProbe>::SetPropagations();
template void Adversaries<RelaxedProbe>::SetPropagations();

template <>
void Adversaries<RelaxedProbe>::UpdatePropagations() {
  std::vector<Propagation<RelaxedProbe>> propagations(settings_.side_channel_analysis.clock_cycles.size() * propagations_.size());
  uint64_t clock_cycle, cycle_index;
  size_t index;

  //#pragma omp parallel for schedule(guided)
  for (cycle_index = 0; cycle_index < settings_.side_channel_analysis.clock_cycles.size(); ++cycle_index) {
    clock_cycle = settings_.side_channel_analysis.clock_cycles[cycle_index] - 1;

    for (index = 0; index < propagations_.size(); ++index){
      propagations[cycle_index * propagations_.size() + index] = propagations_[index].ExtendWithTime(clock_cycle, extended_probes_, enabler_);
    }
  }

  //#pragma omp parallel for schedule(guided)
  for (index = 0; index < propagations.size(); ++index){
    propagations[index].UpdateNumberOfSignals(propagations);
  }

  for (Propagation<RelaxedProbe>& it : propagations){
    it.Finalize(propagations);
  }

  propagations_ = propagations;
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetStandardProbes() {
  uint64_t signal_index;

  for (uint64_t clock_cycle : settings_.side_channel_analysis.clock_cycles) {
    for (Propagation<ExtensionContainer>& propagation : propagations_) {
      signal_index = propagation.GetSignalIndex();

      if (circuit_.Signals[signal_index]->is_probe_allowed) {
        standard_probes_.emplace_back(signal_index, clock_cycle - 1);
      }
    }
  }
}

template void Adversaries<RobustProbe>::SetStandardProbes();
template void Adversaries<RelaxedProbe>::SetStandardProbes();

template <>
void Adversaries<RobustProbe>::SetExtendedProbes() {
  std::vector<uint64_t> indices, tmp_indices;

  for (Propagation<RobustProbe>& it : propagations_) {
    tmp_indices = it.GetExtensionIndices();
    indices.insert(indices.end(), tmp_indices.begin(), tmp_indices.end());
  }

  std::sort(indices.begin(), indices.end());
  indices.erase(std::unique(indices.begin(), indices.end()), indices.end());

  for (uint64_t index : indices){
    for (uint64_t clock_cycle : settings_.side_channel_analysis.clock_cycles){
      --clock_cycle;

      if (settings_.IsTransitionalLeakage() && (clock_cycle != 0)) {
        extended_probes_.emplace_back(index, clock_cycle - 1);
      }

      extended_probes_.emplace_back(index, clock_cycle);
    }
  }

  std::sort(extended_probes_.begin(), extended_probes_.end(), [](Probe& lhs, Probe& rhs) {return lhs < rhs;});
  extended_probes_.erase(std::unique(extended_probes_.begin(), extended_probes_.end(), [](Probe& lhs, Probe& rhs) { return lhs == rhs; }), extended_probes_.end());
}

template <>
void Adversaries<RelaxedProbe>::SetExtendedProbes() {
  std::vector<std::vector<uint64_t>> tmp_indices(GetNumberOfPropagations());
  std::vector<uint64_t> extension_indices, indices;
  uint64_t enable_index, input_index, signal_index, number_of_inputs;

  for (Propagation<RelaxedProbe>& propagation : propagations_) {
    extension_indices = propagation.GetExtensionIndices(propagations_);
    indices.insert(indices.end(), extension_indices.begin(), extension_indices.end());

    if (propagation.GetNumberOfEnableIndices()) {
      enable_index = propagation.GetEnableIndex();
      number_of_inputs = circuit_.Cells[circuit_.Signals[enable_index]->Output]->NumberOfInputs;

      for (input_index = 0; input_index < number_of_inputs; ++input_index) {
        signal_index = circuit_.Cells[circuit_.Signals[enable_index]->Output]->Inputs[input_index];
        signal_index = BackpropagateUntilBranch(circuit_, signal_index);
        indices.push_back(signal_index);
      }
    }
  }

  std::sort(indices.begin(), indices.end());
  indices.erase(std::unique(indices.begin(), indices.end()), indices.end());

  for (uint64_t index : indices) {
    for (uint64_t clock_cycle : settings_.side_channel_analysis.clock_cycles) {
      --clock_cycle;

      if (clock_cycle != 0) {
        extended_probes_.emplace_back(index, clock_cycle - 1);
      }

      extended_probes_.emplace_back(index, clock_cycle);
    }
  }

  std::sort(extended_probes_.begin(), extended_probes_.end(), [](Probe& lhs, Probe& rhs) {return lhs < rhs;});
  extended_probes_.erase(std::unique(extended_probes_.begin(), extended_probes_.end(), [](Probe& lhs, Probe& rhs) { return lhs == rhs; }), extended_probes_.end());
}

template <>
void Adversaries<RobustProbe>::SetUniqueProbes() {
  uint64_t unique_index, extension_index, set_index;
  std::vector<uint64_t> probing_set_indices;
  unique_probes_.clear();

  for (unique_index = 0; unique_index < GetNumberOfExtendedProbes(); ++unique_index) {
    probing_set_indices.clear();
    for (set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
      for (extension_index = 0; extension_index < probing_sets_[set_index].GetNumberOfProbeExtensions(propagations_); ++extension_index) {
        if (probing_sets_[set_index].GetExtendedProbeIndex(extension_index) == unique_index) {
          probing_set_indices.push_back(set_index);
        }
      }
    }

    unique_probes_.emplace_back(extended_probes_[unique_index].GetSignalIndex(), extended_probes_[unique_index].GetCycle(), probing_set_indices);
  }
}

template <>
void Adversaries<RelaxedProbe>::SetEnablers() {
  size_t extended_probe_index, probe_index;
  int input_index;
  std::vector<uint64_t> indices, indices_new, tmp_indices, list_of_probes;
  std::vector<std::unique_ptr<uint64_t[]>*> input_addresses;
  std::vector<std::vector<int>> not_transformed_global;
  std::vector<int> not_transformed_local;
  int number_of_inputs;
  uint64_t cell_index, output_index, signal_index;

  for (Propagation<RelaxedProbe>& it : propagations_) {
    if (it.GetNumberOfEnableIndices()){
      indices.push_back(it.GetEnableIndex());
    }
  }

  std::sort(indices.begin(), indices.end());
  indices.erase(std::unique(indices.begin(), indices.end()), indices.end());

  // Sorting
  std::vector<uint64_t>::iterator it;
  for (uint64_t signal : circuit_.GetSignals()){
    it = std::lower_bound(indices.begin(), indices.end(), signal);

    if (it != indices.end() && *it == signal){
      indices_new.push_back(signal);
    }
  }

  indices = indices_new;

  simulation_.constant_zero_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(1);
  simulation_.constant_zero_[0] = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);

	simulation_.is_simulation_faulty_ = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  for (size_t index = 0; index < settings_.GetNumberOfSimulationsPerStep() >> 6; ++index){
    simulation_.is_simulation_faulty_[index] = 0;
  }

  simulation_.probe_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(GetNumberOfExtendedProbes());
  for (size_t index = 0; index < GetNumberOfExtendedProbes(); ++index){
    simulation_.probe_values_[index] = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  }

	simulation_.propagation_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(indices.size() * settings_.side_channel_analysis.clock_cycles.size());
  for (size_t index = 0; index < indices.size() * settings_.side_channel_analysis.clock_cycles.size(); ++index){
    simulation_.propagation_values_[index] = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  }

	simulation_.glitch_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(indices.size() * settings_.side_channel_analysis.clock_cycles.size());
	for (size_t index = 0; index < indices.size() * settings_.side_channel_analysis.clock_cycles.size(); ++index){
    simulation_.glitch_values_[index] = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
	}

  for (uint64_t clock_cycle : settings_.side_channel_analysis.clock_cycles) {
    --clock_cycle;

    for (uint64_t index : indices){
      cell_index = circuit_.Signals[index]->Output;

      output_index = 0;
      while ((uint64_t)circuit_.Cells[cell_index]->Outputs[output_index] != index){
        output_index++;
      }

      extended_probe_index = SearchExtendedProbe(index, clock_cycle);

      input_addresses.clear();
      not_transformed_local.clear();

      number_of_inputs = circuit_.Cells[cell_index]->NumberOfInputs;


      if (clock_cycle) {
        for (input_index = 0; input_index < number_of_inputs; ++input_index){
          signal_index = circuit_.Cells[cell_index]->Inputs[input_index];

          while ((circuit_.Signals[signal_index]->Output != -1) && (circuit_.GetNumberOfInputsForSignalsComputingCell(signal_index) == 1) && (!circuit_.Signals[signal_index]->Deleted) && (signal_index != simulation_.clock_signal_index_)){
            signal_index = circuit_.Cells[circuit_.Signals[signal_index]->Output]->Inputs[0];
          }

          probe_index = SearchExtendedProbe(signal_index, clock_cycle - 1);
          input_addresses.push_back(&simulation_.probe_values_[probe_index]);
          not_transformed_local.push_back(-1);

          probe_index = SearchExtendedProbe(signal_index, clock_cycle);
          input_addresses.push_back(&simulation_.probe_values_[probe_index]);
          not_transformed_local.push_back(-1);

          if (circuit_.Signals[signal_index]->is_extension_allowed){
            input_addresses.push_back(nullptr);
            not_transformed_local.push_back(probe_index);
          } else {
            input_addresses.push_back(&simulation_.constant_zero_[0]);
            not_transformed_local.push_back(-1);
          }
        }
      }else{
          for (input_index = 0; input_index < number_of_inputs; ++input_index){
            signal_index = circuit_.Cells[circuit_.Signals[index]->Output]->Inputs[input_index];

            while ((circuit_.Signals[signal_index]->Output != -1) && (circuit_.GetNumberOfInputsForSignalsComputingCell(signal_index) == 1) && (!circuit_.Signals[signal_index]->Deleted) && (signal_index != simulation_.clock_signal_index_)){
              signal_index = circuit_.Cells[circuit_.Signals[signal_index]->Output]->Inputs[0];
            }

            input_addresses.push_back(&simulation_.constant_zero_[0]);
            not_transformed_local.push_back(-1);

            probe_index = SearchExtendedProbe(signal_index, clock_cycle);
            input_addresses.push_back(&simulation_.probe_values_[probe_index]);
            not_transformed_local.push_back(-1);

            if (circuit_.Signals[signal_index]->is_extension_allowed){
              input_addresses.push_back(nullptr);
              not_transformed_local.push_back(probe_index);
            } else{
              input_addresses.push_back(&simulation_.constant_zero_[0]);
              not_transformed_local.push_back(-1);
            }
          }
      }

      list_of_probes.push_back(extended_probe_index);
      not_transformed_global.push_back(not_transformed_local);

      Enabler<CustomOperation> enabler = Enabler<CustomOperation>(library_.GetCell(circuit_.Cells[cell_index]->Type), output_index, extended_probe_index, input_addresses);
      // Sorted insert
      enabler_.insert(std::upper_bound(enabler_.begin(), enabler_.end(), enabler), enabler);
    }
  }

  for (size_t i = 0; i < list_of_probes.size(); ++i){
    signal_index = SearchEnabler(list_of_probes[i], enabler_);

    for (size_t j = 0; j < not_transformed_global[i].size(); ++j){
      if (not_transformed_global[i][j] != -1){
        enabler_[signal_index].SetInputAddress(j, &simulation_.glitch_values_[SearchEnabler(not_transformed_global[i][j], enabler_)]);
      }
    }
  }

  std::vector<std::tuple<size_t, size_t, size_t>> pair_of_index_and_depth;

  for (size_t i = 0; i < GetNumberOfEnablers(); ++i){
    pair_of_index_and_depth.push_back(std::make_tuple(i, (size_t)circuit_.Signals[extended_probes_[enabler_[i].GetExtendedProbeIndex()].GetSignalIndex()]->Depth, extended_probes_[enabler_[i].GetExtendedProbeIndex()].GetCycle()));
  }

  std::sort(pair_of_index_and_depth.begin(), pair_of_index_and_depth.end(),[](const auto& a, const auto& b) {
    if (std::get<2>(a) == std::get<2>(b)){
      return std::get<1>(a) < std::get<1>(b);
    }else{
      return std::get<2>(a) < std::get<2>(b);
    }
  });

  for (size_t i = 0; i < GetNumberOfEnablers(); ++i){
    enabler_evaluation_order_.push_back(std::get<0>(pair_of_index_and_depth[i]));
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetFaults() {
  // FIXME: Replace all uses of this function by calling the ComputAllFaults function of the fault
  // manager.
  // I think this makes more sense.
  // For now we make the AddXYZFault function public instead of private.
  // TBD with nico.

  uint64_t number_of_signals = circuit_.NumberOfSignals;
  for (uint64_t clock_cycle : settings_.fault_injection.clock_cycles) {
    --clock_cycle;

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      const Hardware::SignalStruct * const signal = circuit_.Signals[index];
      if (signal->is_fault_allowed) {
        switch (settings_.fault_injection.type)
        {
        case FaultType::stuck_at_0:
          fault_manager_.AddStuckAtZeroFault(signal, index, clock_cycle, 1.0);
          break;
        case FaultType::stuck_at_1:
          fault_manager_.AddStuckAtOneFault(signal, index, clock_cycle, 1.0);
          break;
        case FaultType::toggle:
          fault_manager_.AddToggleFault(signal, index, clock_cycle, 1.0);
          break;
        default:
          throw std::runtime_error("Error while setting the faults. Unsupported fault type!");
          break;
        }
      }
    }
  }
}

template <>
Adversaries<RobustProbe>::Adversaries(Library& library, CircuitStruct& circuit, Settings& settings, Simulation& simulation) : library_(library), circuit_(circuit), settings_(settings), simulation_(simulation), fault_manager_(FaultManager(settings.fault_injection, circuit)){

  SetPropagations();
  SetStandardProbes();
  SetExtendedProbes();

	simulation_.is_simulation_faulty_ = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  for (size_t index = 0; index < settings_.GetNumberOfSimulationsPerStep() >> 6; ++index){
    simulation_.is_simulation_faulty_[index] = 0;
  }

	simulation_.probe_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(GetNumberOfExtendedProbes());
  for (size_t index = 0; index < GetNumberOfExtendedProbes(); ++index){
    simulation_.probe_values_[index] = std::make_unique<uint64_t[]>(settings_.GetNumberOfSimulationsPerStep() >> 6);
  }

  SetFaults();
}

template <>
Adversaries<RelaxedProbe>::Adversaries(Library& library, CircuitStruct& circuit, Settings& settings, Simulation& simulation) : library_(library), circuit_(circuit), settings_(settings), simulation_(simulation) , fault_manager_(FaultManager(settings.fault_injection, circuit)){
  SetPropagations();
  SetStandardProbes();
  SetExtendedProbes();
  SetEnablers();
  UpdatePropagations();
  SetFaults();
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::InitializeUnivariateProbeCombinations(std::vector<Probe*>& addresses, std::vector<bool>& bitmask) {
  uint64_t number_of_spots = GetNumberOfSpots();

  if (settings_.GetTestOrder() > number_of_spots) {
    addresses.resize(number_of_spots);
    std::fill(bitmask.begin(), bitmask.end(), true);
  } else {
    addresses.resize(settings_.GetTestOrder());
    std::fill(bitmask.begin(), bitmask.begin() + settings_.GetTestOrder(), true);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::InitializeMultivariateProbeCombinations(std::vector<Probe*>& addresses, std::vector<bool>& bitmask) {
  uint64_t number_of_standard_probes = GetNumberOfStandardProbes();

  if (settings_.GetTestOrder() > number_of_standard_probes) {
    addresses.resize(number_of_standard_probes);
    std::fill(bitmask.begin(), bitmask.end(), true);
  } else {
    addresses.resize(settings_.GetTestOrder());
    std::fill(bitmask.begin(), bitmask.begin() + settings_.GetTestOrder(), true);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::InitializeFaultCombinations(uint64_t number_of_faults_per_run, std::vector<uint64_t>& combination, std::vector<bool>& bitmask) {
  uint64_t number_of_faults = fault_manager_.GetNumberOfFaults();

  if (number_of_faults) {
    if (number_of_faults_per_run > number_of_faults) {
      combination.resize(number_of_faults);
      std::fill(bitmask.begin(), bitmask.end(), true);
    } else {
      combination.resize(number_of_faults_per_run);
      std::fill(bitmask.begin(), bitmask.begin() + number_of_faults_per_run, true);
    }
  }
}

template <class ExtensionContainer>
double Adversaries<ExtensionContainer>::GetMaximumLeakage() {
  std::vector<bool> bitmask(GetNumberOfProbingSets(), true);
  return probing_sets_[GetIndexOfMostLeakingProbingSet(probing_sets_, bitmask)].GetGValue();
}

template <class ExtensionContainer>
uint64_t Adversaries<ExtensionContainer>::RemoveProbingSetsWithEnoughTraces(uint64_t number_of_simulations, double& maximum_g_value_deleted, std::string& printed_probing_set_deleted) {
  uint64_t index, number_of_probing_sets = GetNumberOfProbingSets();
  std::vector<Probe*> addresses;
  boost::dynamic_bitset<> bitmask(number_of_probing_sets);
  bitmask.set();

  //#pragma omp parallel for schedule(guided)
  for (index = 0; index < number_of_probing_sets; ++index) {
    if (probing_sets_[index].GetProbeAddresses().size()){
      if (IsSampleSizeSufficient(number_of_simulations, settings_.GetNumberOfGroups(), probing_sets_[index].GetNumberOfEntries(), settings_.side_channel_analysis.beta_threshold, settings_.side_channel_analysis.effect_size)){
        bitmask[index] = false;
        double g_value = probing_sets_[index].GetGValue();

        //#pragma omp critical
        //{
          if (g_value > maximum_g_value_deleted) {
            addresses = probing_sets_[index].GetProbeAddresses();
            maximum_g_value_deleted = g_value;
            printed_probing_set_deleted = printer_.PrintProbes(addresses, circuit_, settings_);
          }
        //}

        probing_sets_[index].Deconstruct();
      }
    }else{
      bitmask[index] = false;
    }
  }

  uint64_t result = bitmask.count();
  return result;
}

template <class ExtensionContainer>
bool Adversaries<ExtensionContainer>::IsInDistance(std::vector<Probe*>& probe_addresses) {
  std::vector<uint64_t> cycles;

  for (Probe* probe: probe_addresses){
    cycles.push_back(probe->GetCycle());
  }

  std::sort(cycles.begin(), cycles.end());
  int distance = cycles.back() - cycles.front();
  bool is_distance_small_enough = distance <= (int)settings_.GetDistance();
  bool is_no_unallowed_univariate_set = (settings_.GetVariate() != Analysis::exclusive_multivariate) || distance != 0;
  return is_distance_small_enough && is_no_unallowed_univariate_set;
}

template <>
void Adversaries<RobustProbe>::ReplaceWireIndexWithListIndex(std::vector<uint64_t>& result, std::vector<uint64_t>& signal_indices, uint64_t clock_cycle, bool is_with_transitional_leakage) {

  for (uint64_t index : signal_indices) {
    result.push_back(SearchProbe(index, clock_cycle, extended_probes_));

    if (is_with_transitional_leakage && (clock_cycle != 0)) {
      result.push_back(SearchProbe(index, clock_cycle - 1, extended_probes_));
    }
  }

  RemoveDuplicates(result);
}

template <>
void Adversaries<RelaxedProbe>::ReplaceWireIndexWithListIndex(std::vector<uint64_t>& result, std::vector<uint64_t>& signal_indices, uint64_t, bool) {
  std::vector<Propagation<RelaxedProbe>>::iterator it;

  for (uint64_t index : signal_indices) {
    it = std::lower_bound(propagations_.begin(), propagations_.end(), index, [](Propagation<RelaxedProbe>& p, uint64_t signal_index) {
      return p.GetSignalIndex() < signal_index;
    });

    if (it != propagations_.end() && it->GetSignalIndex() == index) {
      result.push_back(std::distance(propagations_.begin(), it));
    } else {
      throw std::out_of_range("Unable to find the propagation belonging to a signal! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
    }
  }
}

template <>
std::vector<uint64_t> Adversaries<RobustProbe>::GetSearchedIndices(uint64_t signal_index, uint64_t) {
  auto it = std::lower_bound(propagations_.begin(), propagations_.end(), signal_index, [](auto& propagation, uint64_t index) {
    return propagation.GetSignalIndex() < index;
  });

  if (it != propagations_.end() && it->GetSignalIndex() == signal_index) {
    uint64_t index = std::distance(propagations_.begin(), it);
    return GetPropagation(index).GetExtensionContainer();
  }else{
    throw std::out_of_range("Error while searching for the index of a propagation: The signal index was not found in the list of propagations!");
  }
}

template <>
std::vector<uint64_t> Adversaries<RelaxedProbe>::GetSearchedIndices(uint64_t signal_index, uint64_t clock_cycle) {
    return { SearchProbe(signal_index, clock_cycle, extended_probes_) };
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::AddProbingSet(std::vector<Probe*>& probe_addresses, uint64_t& index) {
  uint64_t signal_index, clock_cycle;
  std::vector<uint64_t> indices, indices_to_search;

  if (IsInDistance(probe_addresses)) {
    for (Probe* probe : probe_addresses) {
      clock_cycle = probe->GetCycle();
      signal_index = probe->GetSignalIndex();
      indices_to_search = GetSearchedIndices(signal_index, clock_cycle);
      ReplaceWireIndexWithListIndex(indices, indices_to_search, clock_cycle, settings_.IsTransitionalLeakage());
    }

    probing_sets_[index].SetProbes(probe_addresses, indices);
    ++index;
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveOneStrictlyLessInformativeProbingSet(uint64_t set_index, uint64_t start, uint64_t end) {
  for (uint64_t index = start; index < end; index++) {
    if (set_index != index) {
      if (probing_sets_[set_index].Includes(probing_sets_[index], propagations_)) {
        probing_sets_[index].MarkAsRemovable();
      }
    }
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveStrictlyLessInformativeProbingSets(uint64_t start, uint64_t end) {
  for (uint64_t index = start; index < end; index++) {
    RemoveOneStrictlyLessInformativeProbingSet(index, start, end);
  }
}

template <class ExtensionContainer>
double Adversaries<ExtensionContainer>::GetLeakageOfSet(size_t probing_set_index) {
  return probing_sets_[probing_set_index].GetGValue();
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveDuplicatedProbingSets() {
  std::cout << "Remove duplicated probing sets..." << std::flush;
  std::sort(probing_sets_.begin(), probing_sets_.end(), [](ProbingSet<ExtensionContainer>& lhs, ProbingSet<ExtensionContainer>& rhs) {
    return lhs < rhs;
  });

  probing_sets_.erase(std::unique(probing_sets_.begin(), probing_sets_.end(), [](ProbingSet<ExtensionContainer>& lhs, ProbingSet<ExtensionContainer>& rhs) {
    return lhs == rhs;
  }), probing_sets_.end());

  std::cout << GetNumberOfProbingSets() << " probing sets remain...done!" << std::endl;
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::
    RemoveUninformativeProbingSetsInUnivariateSetting(size_t number_of_probing_sets) {
  std::vector<uint64_t> start_indices(1, 0), end_indices;

  for (size_t index = 1; index < number_of_probing_sets; index++) {
    if (probing_sets_[index-1].GetHighestClockCycle(propagations_, extended_probes_) != probing_sets_[index].GetHighestClockCycle(propagations_, extended_probes_)) {
      start_indices.push_back(index);
      end_indices.push_back(index);
    }
  }

  end_indices.push_back(number_of_probing_sets);

  // Each set of probing sets with the same clock cycle can be minimized in
  // parallel As they are independend, the runtime is decreased
  #pragma omp parallel for schedule(guided)
  for (size_t index = 0; index < start_indices.size(); ++index) {
    RemoveStrictlyLessInformativeProbingSets(start_indices[index], end_indices[index]);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::RemoveUninformativeProbingSets() {
  RemoveDuplicatedProbingSets();
  size_t number_of_probing_sets = GetNumberOfProbingSets();

  if (settings_.GetMinimization() == Minimization::aggressive) {
    std::cout << "Remove strictly less informative probing sets..." << std::flush;
    if (settings_.IsMultivariateEvaluationRequired()) {
      std::cout << "Setting multivariate case..." << std::flush;
      RemoveStrictlyLessInformativeProbingSets(0, number_of_probing_sets);
    } else {
      std::cout << "Setting univariate case..." << std::flush;
      if (settings_.side_channel_analysis.clock_cycles.size() != 1) {
        RemoveUninformativeProbingSetsInUnivariateSetting(number_of_probing_sets);
      } else {
        if (number_of_probing_sets > 1) {
          RemoveStrictlyLessInformativeProbingSets(0, number_of_probing_sets);
        }
      }
    }

    probing_sets_.erase(std::remove_if(probing_sets_.begin(), probing_sets_.end(),[](ProbingSet<ExtensionContainer>& lhs) {
      return lhs.IsRemovable();
    }), probing_sets_.end());
    std::cout << "done! " << GetNumberOfProbingSets() << " probing sets remain!" << std::endl;
  }
}

template <class ExtensionContainer> void Adversaries<ExtensionContainer>::NormalTest(std::vector<double_t>& group_simulation_ratio) {
  if (simulation_.considered_simulation_indices_.size() == settings_.GetNumberOfSimulationsPerStep()) {
    #pragma omp parallel for schedule(guided)
    for (size_t set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
      if (probing_sets_[set_index].GetNumberOfProbeAddresses()){
        probing_sets_[set_index].NormalTableUpdateWithAllSimulations(settings_, simulation_, propagations_);
        probing_sets_[set_index].ComputeGTest(settings_.GetNumberOfGroups(), simulation_.number_of_processed_simulations, group_simulation_ratio);
      }
    }
  } else {
    #pragma omp parallel for schedule(guided)
    for (size_t set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
      if (probing_sets_[set_index].GetNumberOfProbeAddresses()){
        probing_sets_[set_index].NormalTableUpdate(settings_, simulation_, propagations_);
        probing_sets_[set_index].ComputeGTest(settings_.GetNumberOfGroups(), simulation_.number_of_processed_simulations, group_simulation_ratio);
      }
    }
  }

}

template <> 
void Adversaries<RobustProbe>::CompactTest(std::vector<double_t>& group_simulation_ratio) {
  uint64_t number_of_groups = settings_.GetNumberOfGroups();
  uint64_t number_of_probing_sets = GetNumberOfProbingSets();
  uint64_t number_of_simulations = simulation_.considered_simulation_indices_.size();
  std::vector<std::vector<uint64_t>> counters(number_of_simulations, std::vector<uint64_t>(number_of_probing_sets, 0));

  #pragma omp parallel for schedule(guided)
  for (uint64_t index = 0; index < number_of_simulations; ++index) {
    uint64_t simulation_index = simulation_.considered_simulation_indices_[index];

    for (uint64_t unique_index = 0; unique_index < unique_probes_.size(); ++unique_index) {
      if (simulation_.probe_values_[unique_index][simulation_index >> 6] & (1ULL << (simulation_index & 63))) {
        for (uint64_t set_index : unique_probes_[unique_index].GetProbingSetIndices()) {
          ++counters[index][set_index];
        }
      }
    }
  }

  #pragma omp parallel for schedule(guided)
  for (uint64_t set_index = 0; set_index < number_of_probing_sets; ++set_index) {
    for (uint64_t index = 0; index < number_of_simulations; ++index) {
      probing_sets_[set_index].IncrementSpecificCounter(counters[index][set_index], simulation_.selected_groups_[simulation_.considered_simulation_indices_[index]]); 
    }

    probing_sets_[set_index].ComputeGTest(number_of_groups, simulation_.number_of_processed_simulations, group_simulation_ratio);
  }
}

template <> 
void Adversaries<RelaxedProbe>::CompactTest(std::vector<double_t>& group_simulation_ratio) {
  #pragma omp parallel for schedule(guided)
  for (size_t set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index) {
    if (probing_sets_[set_index].GetNumberOfProbeAddresses()){
      probing_sets_[set_index].CompactTableUpdate(settings_, simulation_, propagations_);
      probing_sets_[set_index].ComputeGTest(settings_.GetNumberOfGroups(), simulation_.number_of_processed_simulations, group_simulation_ratio);
    }
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::Test(std::vector<double_t>& group_simulation_ratio,
    bool is_in_compact_mode) {
  if (is_in_compact_mode) {
    CompactTest(group_simulation_ratio);
  } else {
    NormalTest(group_simulation_ratio);
  }
}

template <class ExtensionContainer>
void Adversaries<ExtensionContainer>::SetConsideredSimulations(std::vector<uint64_t>& number_of_simulations_per_group) {
  uint64_t number_of_batches = settings_.GetNumberOfSimulationsPerStep() >> 6;
  uint64_t batch_index, bit_index, simulation_index;

  simulation_.considered_simulation_indices_.clear();
  switch (settings_.fault_injection.analysis)
  {
  case FaultAnalysis::only_fault_free_simulations:
    for (batch_index = 0; batch_index < number_of_batches; ++batch_index) {
      for (bit_index = 0; bit_index < 64; ++bit_index) {
        if (!((simulation_.is_simulation_faulty_[batch_index] >> bit_index) & 1)) {
          ++simulation_.number_of_processed_simulations;
          simulation_index = (batch_index << 6) ^ bit_index;
          simulation_.considered_simulation_indices_.push_back(simulation_index);
          ++number_of_simulations_per_group[simulation_.selected_groups_[simulation_index]];
        }
      }
    }

    break;
  case FaultAnalysis::only_faulty_simulations:
    for (batch_index = 0; batch_index < number_of_batches; ++batch_index) {
      for (bit_index = 0; bit_index < 64; ++bit_index) {
        if ((simulation_.is_simulation_faulty_[batch_index] >> bit_index) & 1) {
          ++simulation_.number_of_processed_simulations;
          simulation_index = (batch_index << 6) ^ bit_index;
          simulation_.considered_simulation_indices_.push_back(simulation_index);
          ++number_of_simulations_per_group[simulation_.selected_groups_[simulation_index]];
        }
      }
    }

    break;
  default:
    simulation_.number_of_processed_simulations += settings_.GetNumberOfSimulationsPerStep();
    for (simulation_index = 0; simulation_index < settings_.GetNumberOfSimulationsPerStep(); ++simulation_index) {
      simulation_.considered_simulation_indices_.push_back(simulation_index);
      ++number_of_simulations_per_group[simulation_.selected_groups_[simulation_index]];
    }

    break;
  }
}

template <>
void Adversaries<RobustProbe>::EvaluateProbingSets(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t& probe_step_index) {
  std::vector<uint64_t> number_of_simulations_per_group(settings_.GetNumberOfGroups(), 0);
  std::vector<double_t> group_simulation_ratio(settings_.GetNumberOfGroups());

  std::vector<boost::mt19937> thread_rng(settings_.GetNumberOfThreads());
  uint64_t step_simulation_index, simulation_index;
  omp_set_num_threads(settings_.GetNumberOfThreads());
  double elapsed_time_period, maximum_g_value_deleted = 0.0;
  int thread_index;
  std::string printed_probing_set_deleted;
  std::vector<Probe> extended_probes = GetProbeExtensions();
  std::vector<size_t> enabler_evaluation_order = enabler_evaluation_order_;
  std::vector<Enabler<CustomOperation>> enablers = GetEnablers();
  std::cout << "Evaluate security under the robust probing model!" << std::endl;
  uint64_t number_of_remaining_probing_sets;

  // We use a PRNG that is thread safe
  GenerateThreadRng(thread_rng, settings_.GetNumberOfThreads());
  printer_.SetColumnSize(probing_sets_, circuit_, settings_);
  printer_.PrintEvaluationHeader();

  simulation_.number_of_processed_simulations = 0;

  if (settings_.IsCompactDistribution()) {
    SetUniqueProbes();
  }

  for (step_simulation_index = 0; step_simulation_index < (settings_.GetNumberOfSimulations() / settings_.GetNumberOfSimulationsPerStep()); ++step_simulation_index) {
    #pragma omp parallel for schedule(guided) private(thread_index)
    for (simulation_index = 0; simulation_index < (settings_.GetNumberOfSimulationsPerStep() / 64); ++simulation_index) {
      thread_index = omp_get_thread_num();
      Hardware::Simulate::All(library_, circuit_, settings_, shared_data[thread_index], extended_probes, enablers, enabler_evaluation_order, simulation_, simulation_index, thread_rng[thread_index]);
    }

    SetConsideredSimulations(number_of_simulations_per_group);
    std::transform(number_of_simulations_per_group.begin(), number_of_simulations_per_group.end(), group_simulation_ratio.begin(),
                   [this](uint64_t x) { return static_cast<double_t>(x) / static_cast<double_t>(this->simulation_.number_of_processed_simulations); });

    Test(group_simulation_ratio, settings_.IsCompactDistribution());

    elapsed_time_period = EndClock(start_time);
    printer_.PrintEvaluationBody(probing_sets_, circuit_, settings_, simulation_, maximum_g_value_deleted, printed_probing_set_deleted, elapsed_time_period);

    if (settings_.GetNumberOfSimulationsPerWrite()) {
      if ((simulation_.number_of_processed_simulations % settings_.GetNumberOfSimulationsPerWrite()) == 0) {
        printer_.PrintReport(propagations_, extended_probes_, probing_sets_, circuit_, settings_, simulation_, probe_step_index);
      }
    }

    if (settings_.IsRemoveFullProbingSets()) {  // Remove probing set if enough traces are processed
      number_of_remaining_probing_sets = RemoveProbingSetsWithEnoughTraces(simulation_.number_of_processed_simulations, maximum_g_value_deleted, printed_probing_set_deleted);
      if (number_of_remaining_probing_sets == 0) {

        if (settings_.GetNumberOfSimulationsPerWrite()) {
          if ((simulation_.number_of_processed_simulations % settings_.GetNumberOfSimulationsPerWrite()) != 0) {
            printer_.PrintReport(propagations_, extended_probes_, probing_sets_, circuit_, settings_, simulation_, probe_step_index);
          }
        }
        break;
      }
    }
  }
}

template <>
void Adversaries<RelaxedProbe>::EvaluateProbingSets(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t& probe_step_index) {
  std::vector<uint64_t> number_of_simulations_per_group(settings_.GetNumberOfGroups(), 0.0);
  std::vector<double_t> group_simulation_ratio(settings_.GetNumberOfGroups());

  std::vector<boost::mt19937> thread_rng(settings_.GetNumberOfThreads());
  uint64_t step_simulation_index, simulation_index;
  omp_set_num_threads(settings_.GetNumberOfThreads());
  double elapsed_time_period, maximum_g_value_deleted = 0.0;
  int thread_index;
  std::string printed_probing_set_deleted;
  std::vector<size_t> enabler_evaluation_order = enabler_evaluation_order_;
  std::vector<Probe> extended_probes = GetProbeExtensions();
  std::vector<Enabler<CustomOperation>> enablers = GetEnablers();
  uint64_t number_of_remaining_probing_sets;
  std::cout << "Evaluate security under the relaxed robust probing model!" << std::endl;

  // We use a PRNG that is thread safe
  GenerateThreadRng(thread_rng, settings_.GetNumberOfThreads());
  printer_.SetColumnSize(probing_sets_, circuit_, settings_);
  printer_.PrintEvaluationHeader();

  simulation_.number_of_processed_simulations = 0;
  simulation_.number_of_enablers_ = enablers.size();

  for (step_simulation_index = 0; step_simulation_index < (settings_.GetNumberOfSimulations() / settings_.GetNumberOfSimulationsPerStep()); ++step_simulation_index) {
    #pragma omp parallel for schedule(guided) private(thread_index)
    for (simulation_index = 0; simulation_index < (settings_.GetNumberOfSimulationsPerStep() / 64); ++simulation_index) {
      thread_index = omp_get_thread_num();
      Hardware::Simulate::All(library_, circuit_, settings_, shared_data[thread_index], extended_probes, enablers, enabler_evaluation_order, simulation_, simulation_index, thread_rng[thread_index]);
    }

    SetConsideredSimulations(number_of_simulations_per_group);
    std::transform(number_of_simulations_per_group.begin(), number_of_simulations_per_group.end(), group_simulation_ratio.begin(),
                   [this](uint64_t x) { return static_cast<double_t>(x) / static_cast<double_t>(this->simulation_.number_of_processed_simulations); });

    Test(group_simulation_ratio, settings_.IsCompactDistribution());

    elapsed_time_period = EndClock(start_time);
    printer_.PrintEvaluationBody(probing_sets_, circuit_, settings_, simulation_, maximum_g_value_deleted, printed_probing_set_deleted, elapsed_time_period);

    if (settings_.GetNumberOfSimulationsPerWrite()) {
      if ((simulation_.number_of_processed_simulations % settings_.GetNumberOfSimulationsPerWrite()) == 0) {
        printer_.PrintReport(propagations_, extended_probes_, probing_sets_, circuit_, settings_, simulation_, probe_step_index);
      }
    }

    if (settings_.IsRemoveFullProbingSets()) {
      number_of_remaining_probing_sets = RemoveProbingSetsWithEnoughTraces(simulation_.number_of_processed_simulations, maximum_g_value_deleted, printed_probing_set_deleted);

      if (number_of_remaining_probing_sets == 0) {
        if (settings_.GetNumberOfSimulationsPerWrite()) {
          if ((simulation_.number_of_processed_simulations % settings_.GetNumberOfSimulationsPerWrite()) != 0) {
            printer_.PrintReport(propagations_, extended_probes_, probing_sets_, circuit_, settings_, simulation_, probe_step_index);
          }
        }
        break;
      }
    }
  }
}

template <class ExtensionContainer>
double Adversaries<ExtensionContainer>::EvaluateProbingSetsUnderFaults(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t& probe_step_index) {
  uint64_t number_of_faults = fault_manager_.GetNumberOfFaults();
  std::vector<uint64_t> combination_for_faults;
  std::vector<bool> bitmask_for_faults(number_of_faults, false);
  std::vector<Fault const*> faults;
  std::vector<uint64_t> number_of_faults_per_cycle(settings_.GetNumberOfClockCycles(), 0);
  uint64_t maximum, minimum;
  std::string fault_message;
  double maximum_leakage = 0.0;

  for (ProbingSet<ExtensionContainer>& it : probing_sets_) {
    it.Initialize(settings_.IsCompactDistribution(), propagations_, settings_.GetNumberOfGroups());
  }

  std::sort(probing_sets_.begin(), probing_sets_.end(), [this](ProbingSet<ExtensionContainer>& lhs, ProbingSet<ExtensionContainer>& rhs) {
    return lhs.GetNumberOfProbeExtensions(propagations_) < rhs.GetNumberOfProbeExtensions(propagations_);
  });

  if (number_of_faults && settings_.fault_injection.minimum_per_run) {
    for (uint64_t index = settings_.fault_injection.minimum_per_run; index <= settings_.fault_injection.maximum_per_run; ++index) {
      InitializeFaultCombinations(index, combination_for_faults, bitmask_for_faults);

      do {
        ExtractCombinationFromBitmask(combination_for_faults, bitmask_for_faults);
        std::fill(number_of_faults_per_cycle.begin(), number_of_faults_per_cycle.end(), 0);
        maximum = 0x0000000000000000;
        minimum = 0xffffffffffffffff;
        faults.clear();

        fault_message = "Induce faults at: [";
        for (uint64_t fault_index : combination_for_faults){
          Fault const* fault = fault_manager_.GetFault(fault_index);
          faults.push_back(fault);
          ++number_of_faults_per_cycle[fault->GetFaultedClockCycle()];
          fault_message += std::string(circuit_.Signals[fault->GetFaultedSignalIndex()]->Name) + " (" + std::to_string(fault->GetFaultedClockCycle()) + "), ";
        }

        fault_message.pop_back();
        fault_message.back() = ']';

        for (uint64_t test_cycle : settings_.fault_injection.clock_cycles) {
          --test_cycle;
          if (number_of_faults_per_cycle[test_cycle] > maximum) {
            maximum = number_of_faults_per_cycle[test_cycle];
          }

          if (number_of_faults_per_cycle[test_cycle] < minimum) {
            minimum = number_of_faults_per_cycle[test_cycle];
          }
        }

        if (maximum <= settings_.fault_injection.maximum_per_cycle && minimum >= settings_.fault_injection.minimum_per_cycle) {
          std::cout << fault_message << std::endl;
          simulation_.fault_set.emplace_back(faults);
          EvaluateProbingSets(shared_data, start_time, probe_step_index);
          simulation_.fault_set.pop_back();

          if (GetMaximumLeakage() > maximum_leakage) {
            maximum_leakage = GetMaximumLeakage();
          }

          #pragma omp parallel for schedule(guided)
          for (uint64_t set_index = 0; set_index < GetNumberOfProbingSets(); ++set_index){
            probing_sets_[set_index].DeconstructTable();
          }
        }

      } while (std::prev_permutation(bitmask_for_faults.begin(), bitmask_for_faults.end()));
    }
  } else {
    EvaluateProbingSets(shared_data, start_time, probe_step_index);

    if (GetMaximumLeakage() > maximum_leakage) {
      maximum_leakage = GetMaximumLeakage();
    }
  }

  return maximum_leakage;
}

template <>
double Adversaries<RobustProbe>::EvaluateMultivariateRobustProbingSecurity(std::vector<SharedData>& shared_data, timespec& start_time) {
  std::cout << "Generate multivariate probing sets..." << std::flush;
  uint64_t number_of_standard_probes = GetNumberOfStandardProbes();
  uint64_t index, probe_step_index = 0;
  uint64_t address_index, bitmask_index, set_index = 0;
  std::vector<Probe*> addresses_for_probes;
  std::vector<bool> bitmask_for_probes(number_of_standard_probes, false);
  InitializeMultivariateProbeCombinations(addresses_for_probes, bitmask_for_probes);
  double maximum_leakage = 0.0;
  double leakage_per_run;

  uint64_t number_of_probes_per_set = std::min(number_of_standard_probes, settings_.GetTestOrder());
  uint64_t maximum_number_of_probing_sets = (uint64_t)boost::math::binomial_coefficient<double>(number_of_standard_probes, number_of_probes_per_set);
  uint64_t number_of_probing_sets = std::min(maximum_number_of_probing_sets, settings_.GetNumberOfProbingSetsPerStep());

  // TODO: Change this allocation as many sets are removed by InDistance;
  probing_sets_.resize(number_of_probing_sets);

  do {
    address_index = 0;
    bitmask_index = 0;

    while (address_index != addresses_for_probes.size()){
      if (bitmask_for_probes[bitmask_index]){
        addresses_for_probes[address_index] = &standard_probes_[bitmask_index];
        ++address_index;
      }
      ++bitmask_index;
    }

    AddProbingSet(addresses_for_probes, set_index);

    if (set_index == number_of_probing_sets) {
      std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
      if (settings_.GetMinimization() != Minimization::none) {
        RemoveUninformativeProbingSets();
      }
      printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
      leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

      if (leakage_per_run > maximum_leakage) {
        maximum_leakage = leakage_per_run;
      }

      if (number_of_probing_sets != maximum_number_of_probing_sets) {
        #pragma omp parallel for schedule(guided)
        for (index = 0; index < GetNumberOfProbingSets(); ++index){
          if (probing_sets_[index].GetProbeAddresses().size()){
            probing_sets_[index].Deconstruct();
          }
        }
      }

      set_index = 0;
    }
  } while (std::prev_permutation(bitmask_for_probes.begin(), bitmask_for_probes.end()));


  if (set_index) {
    probing_sets_.resize(set_index);
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
    if (settings_.GetMinimization() != Minimization::none) {
      RemoveUninformativeProbingSets();
    }
    printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
    leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

    if (leakage_per_run > maximum_leakage) {
      maximum_leakage = leakage_per_run;
    }
  }

  return maximum_leakage;
}

template <>
double Adversaries<RelaxedProbe>::EvaluateMultivariateRobustProbingSecurity(std::vector<SharedData>& shared_data, timespec& start_time) {
  std::cout << "Generate multivariate probing sets..." << std::flush;
  uint64_t number_of_standard_probes = GetNumberOfStandardProbes();
  uint64_t probe_step_index = 0;
  uint64_t bitmask_index, address_index, set_index = 0;
  std::vector<Probe*> addresses_for_probes;
  std::vector<bool> bitmask_for_probes(number_of_standard_probes, false);
  InitializeMultivariateProbeCombinations(addresses_for_probes, bitmask_for_probes);
  double maximum_leakage = 0.0;
  double leakage_per_run;

  uint64_t number_of_probes_per_set = std::min(number_of_standard_probes, settings_.GetTestOrder());
  uint64_t maximum_number_of_probing_sets = (uint64_t)boost::math::binomial_coefficient<double>(number_of_standard_probes, number_of_probes_per_set);
  uint64_t number_of_probing_sets = std::min(maximum_number_of_probing_sets, settings_.GetNumberOfProbingSetsPerStep());
  probing_sets_.resize(number_of_probing_sets);

  do {
    address_index = 0;
    bitmask_index = 0;

    while (address_index != addresses_for_probes.size()){
      if (bitmask_for_probes[bitmask_index]){
        addresses_for_probes[address_index] = &standard_probes_[bitmask_index];
        ++address_index;
      }
      ++bitmask_index;
    }

    AddProbingSet(addresses_for_probes, set_index);

    if (set_index == number_of_probing_sets) {
      std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
      printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
      leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

      if (leakage_per_run > maximum_leakage) {
        maximum_leakage = leakage_per_run;
      }

      if (number_of_probing_sets != maximum_number_of_probing_sets) {
        #pragma omp parallel for schedule(guided)
        for (size_t index = 0; index < GetNumberOfProbingSets(); ++index){
          if (probing_sets_[index].GetProbeAddresses().size()){
            probing_sets_[index].Deconstruct();
          }
        }
      }

      set_index = 0;
    }
  } while (std::prev_permutation(bitmask_for_probes.begin(), bitmask_for_probes.end()));

  if (set_index) {
    probing_sets_.resize(set_index);
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
    printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
    leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

    if (leakage_per_run > maximum_leakage) {
      maximum_leakage = leakage_per_run;
    }
  }

  return maximum_leakage;
}

template <>
double Adversaries<RobustProbe>::EvaluateUnivariateRobustProbingSecurity(std::vector<SharedData>& shared_data, timespec& start_time) {
  uint64_t number_of_spots = GetNumberOfSpots();
  std::cout << number_of_spots << " different spots to probe detected!" << std::endl;

  std::cout << "Generate univariate probing sets..." << std::flush;

  uint64_t bitmask_index, address_index, set_index = 0;
  uint64_t probe_step_index = 0;
  std::vector<Probe*> addresses_for_probes;
  std::vector<bool> bitmask_for_probes(number_of_spots, false);
  double maximum_leakage = 0.0;
  double leakage_per_run;

  uint64_t number_of_probes_per_set = std::min(number_of_spots, settings_.GetTestOrder());
  uint64_t maximum_number_of_probing_sets = (uint64_t)(settings_.side_channel_analysis.clock_cycles.size() * boost::math::binomial_coefficient<double>(number_of_spots, number_of_probes_per_set));
  uint64_t number_of_probing_sets = std::min(maximum_number_of_probing_sets, settings_.GetNumberOfProbingSetsPerStep());
  probing_sets_.resize(number_of_probing_sets);

  for (uint64_t cycle_index = 0; cycle_index < settings_.side_channel_analysis.clock_cycles.size(); ++cycle_index) {
    InitializeUnivariateProbeCombinations(addresses_for_probes, bitmask_for_probes);

    do {
      address_index = 0;
      bitmask_index = 0;

      while (address_index != addresses_for_probes.size()){
        if (bitmask_for_probes[bitmask_index]){
          addresses_for_probes[address_index] = &standard_probes_[bitmask_index + cycle_index * number_of_spots];
          ++address_index;
        }
        ++bitmask_index;
      }

      AddProbingSet(addresses_for_probes, set_index);

      if (set_index == number_of_probing_sets) {
        std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
        if (settings_.GetMinimization() != Minimization::none) {
          RemoveUninformativeProbingSets();
        }
        printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
        leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

        if (leakage_per_run > maximum_leakage) {
          maximum_leakage = leakage_per_run;
        }

        if (number_of_probing_sets != maximum_number_of_probing_sets) {
          #pragma omp parallel for schedule(guided)
          for (size_t index = 0; index < GetNumberOfProbingSets(); ++index){
            if (probing_sets_[index].GetProbeAddresses().size()){
              probing_sets_[index].Deconstruct();
            }
          }
        }

        set_index = 0;
      }

    } while (std::prev_permutation(bitmask_for_probes.begin(), bitmask_for_probes.end()));
  }

  if (set_index) {
    probing_sets_.resize(set_index);
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
    if (settings_.GetMinimization() != Minimization::none) {
      RemoveUninformativeProbingSets();
    }
    printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
    leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

    if (leakage_per_run > maximum_leakage) {
      maximum_leakage = leakage_per_run;
    }
  }

  return maximum_leakage;
}

template <>
double Adversaries<RelaxedProbe>::EvaluateUnivariateRobustProbingSecurity(std::vector<SharedData>& shared_data, timespec& start_time) {
  uint64_t number_of_spots = GetNumberOfSpots();
  std::cout << number_of_spots << " different spots to probe detected!" << std::endl;

  std::cout << "Generate univariate probing sets..." << std::flush;
  uint64_t bitmask_index, address_index, set_index = 0;
  uint64_t probe_step_index = 0;
  std::vector<uint64_t> combination_for_faults;
  std::vector<Probe*> addresses_for_probes;
  std::vector<bool> bitmask_for_probes(number_of_spots, false);
  double maximum_leakage = 0.0;
  double leakage_per_run;

  uint64_t number_of_probes_per_set = std::min(number_of_spots, settings_.GetTestOrder());
  uint64_t maximum_number_of_probing_sets = (uint64_t)(settings_.side_channel_analysis.clock_cycles.size() * boost::math::binomial_coefficient<double>(number_of_spots, number_of_probes_per_set));
  uint64_t number_of_probing_sets = std::min(maximum_number_of_probing_sets, settings_.GetNumberOfProbingSetsPerStep());
  probing_sets_.resize(number_of_probing_sets);

  for (uint64_t cycle_index = 0; cycle_index < settings_.side_channel_analysis.clock_cycles.size(); ++cycle_index) {
    InitializeUnivariateProbeCombinations(addresses_for_probes, bitmask_for_probes);

    do {
      address_index = 0;
      bitmask_index = 0;

      while (address_index != addresses_for_probes.size()){
        if (bitmask_for_probes[bitmask_index]){
          addresses_for_probes[address_index] = &standard_probes_[bitmask_index + cycle_index * number_of_spots];
          ++address_index;
        }
        ++bitmask_index;
      }

      AddProbingSet(addresses_for_probes, set_index);

      if (set_index == number_of_probing_sets) {
        std::cout << GetNumberOfProbingSets() << " probing sets generated...done!" << std::endl;
        printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
        leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

        if (leakage_per_run > maximum_leakage) {
          maximum_leakage = leakage_per_run;
        }

        if (number_of_probing_sets != maximum_number_of_probing_sets) {
          #pragma omp parallel for schedule(guided)
          for (size_t index = 0; index < GetNumberOfProbingSets(); ++index){
            if (probing_sets_[index].GetProbeAddresses().size()){
              probing_sets_[index].Deconstruct();
            }
          }
        }

        set_index = 0;
      }

    } while (std::prev_permutation(bitmask_for_probes.begin(), bitmask_for_probes.end()));
  }

  if (set_index) {
    probing_sets_.resize(set_index);
    std::cout << GetNumberOfProbingSets() << " probing sets generated...done!"
              << std::endl;
    printer_.PrintProbingSetInformation(propagations_, standard_probes_, extended_probes_, probing_sets_);
    leakage_per_run = EvaluateProbingSetsUnderFaults(shared_data, start_time, probe_step_index);

    if (leakage_per_run > maximum_leakage) {
      maximum_leakage = leakage_per_run;
    }
  }

  return maximum_leakage;
}

template <class ExtensionContainer>
double Adversaries<ExtensionContainer>::EvaluateRobustProbingSecurity(std::vector<SharedData>& shared_data) {
  struct timespec start_time;
  StartClock(start_time);
  double maximum_leakage;
  printer_.SetPath(simulation_.result_folder_name_);

  if (settings_.IsMultivariateEvaluationRequired()) {
    maximum_leakage = EvaluateMultivariateRobustProbingSecurity(shared_data, start_time);
  } else {
    maximum_leakage = EvaluateUnivariateRobustProbingSecurity(shared_data, start_time);
  }

  std::cout << "Evaluation done in " << EndClock(start_time) << " seconds!" << std::endl;
  return maximum_leakage;
}

template double Adversaries<RobustProbe>::EvaluateRobustProbingSecurity(std::vector<SharedData>&);
template double Adversaries<RelaxedProbe>::EvaluateRobustProbingSecurity(std::vector<SharedData>&);
}
