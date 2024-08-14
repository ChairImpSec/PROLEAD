#include "Hardware/ProbingSets.hpp"

namespace Hardware{

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator<(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ < other.probe_extension_indices_);
}

template bool ProbingSet<RobustProbe>::operator<(const ProbingSet<RobustProbe>&) const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator==(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ == other.probe_extension_indices_);
}

template bool ProbingSet<RobustProbe>::operator==(const ProbingSet<RobustProbe>&) const;

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::operator!=(
    const ProbingSet<ExtensionContainer>& other) const {
  return (probe_extension_indices_ != other.probe_extension_indices_);
}

template bool ProbingSet<RobustProbe>::operator!=(const ProbingSet<RobustProbe>&) const;

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::SetProbes(std::vector<Probe*>& probe_addresses, std::vector<uint64_t>& probe_extension_indices) {
  probe_addresses_ = probe_addresses;
  probe_extension_indices_ = probe_extension_indices;
} 

template void ProbingSet<RobustProbe>::SetProbes(std::vector<Probe*>&, std::vector<uint64_t>&);
template void ProbingSet<RelaxedProbe>::SetProbes(std::vector<Probe*>&, std::vector<uint64_t>&);

template <class ExtensionContainer>
ProbingSet<ExtensionContainer>::ProbingSet() {
  should_be_removed_ = false;
};

template ProbingSet<RobustProbe>::ProbingSet();
template ProbingSet<RelaxedProbe>::ProbingSet();

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::Deconstruct() {
  probe_addresses_.clear();
  //probe_addresses_.shrink_to_fit();
  probe_extension_indices_.clear();
  //probe_extension_indices_.shrink_to_fit(); 
  contingency_table_.Deconstruct();
};

template void ProbingSet<RobustProbe>::Deconstruct();
template void ProbingSet<RelaxedProbe>::Deconstruct();

template <class ExtensionContainer>
std::vector<Probe*> ProbingSet<ExtensionContainer>::GetProbeAddresses() {
  return probe_addresses_;
}

template std::vector<Probe*> ProbingSet<RobustProbe>::GetProbeAddresses();
template std::vector<Probe*> ProbingSet<RelaxedProbe>::GetProbeAddresses();

template <>
size_t ProbingSet<RobustProbe>::GetNumberOfProbeExtensions(std::vector<Propagation<RobustProbe>>&) {
  return probe_extension_indices_.size();
}

template <>
size_t ProbingSet<RelaxedProbe>::GetNumberOfProbeExtensions(std::vector<Propagation<RelaxedProbe>>& propagations) {
  size_t result = 0;

  for (uint64_t index : probe_extension_indices_){
    result += propagations[index].GetNumberOfSignalIndices();
    result += propagations[index].GetNumberOfEnableIndices();
  }

  return result; 
}

template <class ExtensionContainer>
uint64_t ProbingSet<ExtensionContainer>::GetExtendedProbeIndex(size_t extended_probe_index) {
  try {
    return probe_extension_indices_[extended_probe_index];
  } catch (const std::out_of_range& e) {
    throw std::out_of_range("Tried to access an invalid extended probe index within a probing set! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
  }
}

template uint64_t ProbingSet<RobustProbe>::GetExtendedProbeIndex(size_t);
template uint64_t ProbingSet<RelaxedProbe>::GetExtendedProbeIndex(size_t);

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetFirstProbeExtension() {
  try {
    return probe_extension_indices_.front();
  } catch (const std::out_of_range& e) {
    throw std::out_of_range("Tried to access the first element of an empty vector! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
  }
}

template RobustProbe ProbingSet<RobustProbe>::GetFirstProbeExtension();

template <class ExtensionContainer>
ExtensionContainer ProbingSet<ExtensionContainer>::GetLastProbeExtension() {
  try {
    return probe_extension_indices_.back();
  } catch (const std::out_of_range& e) {
    throw std::out_of_range("Tried to access the last element of an empty vector! It seems that you found a bug in PROLEAD. Please get in touch with me (nicolai.mueller@rub.de) so that we can fix this issue!");
  }
}

template RobustProbe ProbingSet<RobustProbe>::GetLastProbeExtension() ;

template <class ExtensionContainer>
std::vector<uint64_t> ProbingSet<ExtensionContainer>::GetProbeExtensions() {
  return probe_extension_indices_;
}

template std::vector<uint64_t> ProbingSet<RobustProbe>::GetProbeExtensions();
template std::vector<uint64_t> ProbingSet<RelaxedProbe>::GetProbeExtensions();

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::Initialize(bool is_in_compact_mode, std::vector<Propagation<ExtensionContainer>>& propagations) {
  contingency_table_.Initialize(GetNumberOfProbeExtensions(propagations), is_in_compact_mode);
}

template void ProbingSet<RobustProbe>::Initialize(bool, std::vector<Propagation<RobustProbe>>&);
template void ProbingSet<RelaxedProbe>::Initialize(bool, std::vector<Propagation<RelaxedProbe>>&);

template <class ExtensionContainer>
double ProbingSet<ExtensionContainer>::GetGValue() {
  return contingency_table_.GetLog10pValue();
}

template double ProbingSet<RobustProbe>::GetGValue();
template double ProbingSet<RelaxedProbe>::GetGValue();

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::ComputeGTest(uint64_t number_of_groups, uint64_t number_of_simulations, std::vector<double_t>& group_simulation_ratio) {
  contingency_table_.SetLog10pValue(number_of_groups, number_of_simulations, group_simulation_ratio);
}

template void ProbingSet<RobustProbe>::ComputeGTest(uint64_t, uint64_t, std::vector<double_t>&);
template void ProbingSet<RelaxedProbe>::ComputeGTest(uint64_t, uint64_t, std::vector<double_t>&);

template <class ExtensionContainer>
uint64_t ProbingSet<ExtensionContainer>::GetNumberOfEntries() {
  return contingency_table_.GetNumberOfEntries();
}

template uint64_t ProbingSet<RobustProbe>::GetNumberOfEntries();
template uint64_t ProbingSet<RelaxedProbe>::GetNumberOfEntries();

template <class ExtensionContainer>
std::string ProbingSet<ExtensionContainer>::PrintProbes(CircuitStruct& circuit) {
  std::string cycle, name, result;
  
  for (Probe* probe : GetProbeAddresses()){
    name = circuit.Signals[probe->GetSignalIndex()]->Name;
    cycle = std::to_string(probe->GetCycle());
    result += name + "(" + cycle + "), ";
  }
  
  result.pop_back();
  result.pop_back();
  return result;
}

template std::string ProbingSet<RobustProbe>::PrintProbes(CircuitStruct&);
template std::string ProbingSet<RelaxedProbe>::PrintProbes(CircuitStruct&);

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::IsRemovable() {
  return should_be_removed_;
}

template bool ProbingSet<RobustProbe>::IsRemovable();

template <class ExtensionContainer>
void ProbingSet<ExtensionContainer>::MarkAsRemovable() {
  should_be_removed_ = true;
}

template void ProbingSet<RobustProbe>::MarkAsRemovable();

template <class ExtensionContainer>
bool ProbingSet<ExtensionContainer>::Includes(ProbingSet<ExtensionContainer>& other, std::vector<Propagation<ExtensionContainer>>& propagations) {
  if (IsRemovable() || other.IsRemovable()) {
    return false;
  } else {
    if (GetNumberOfProbeExtensions(propagations) <= other.GetNumberOfProbeExtensions(propagations)) {
      return false;
    } else {
      if ((GetFirstProbeExtension() >= other.GetFirstProbeExtension()) && (GetLastProbeExtension() <= other.GetLastProbeExtension())) {
        if (std::includes(probe_extension_indices_.begin(), probe_extension_indices_.end(), other.probe_extension_indices_.begin(), other.probe_extension_indices_.end(), std::greater<ExtensionContainer>())) {
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

template bool ProbingSet<RobustProbe>::Includes(ProbingSet<RobustProbe>&, std::vector<Propagation<RobustProbe>>&);



template <>
void ProbingSet<RobustProbe>::CompactTableUpdate(
    const Settings& settings, Simulation& simulation, std::vector<Propagation<RobustProbe>>& propagations) {
  uint64_t group_index;
  TableBucketVector datasets;
  size_t number_of_extended_probes = GetNumberOfProbeExtensions(propagations);
  uint64_t size_of_key_in_bytes = contingency_table_.GetSizeOfKeyInBytes();
  std::vector<uint64_t> probe_extension_indices = GetProbeExtensions();
  uint64_t probe_index, value, counter;

  datasets.resize(simulation.considered_simulation_indices_.size());
  for (uint64_t index = 0; index < simulation.considered_simulation_indices_.size(); ++index){
    datasets[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    datasets[index].data_ = std::make_unique<uint32_t[]>(settings.GetNumberOfGroups());
    group_index = simulation.selected_groups_[simulation.considered_simulation_indices_[index]];
    datasets[index].data_[group_index] = 1;
    counter = 0;

    for (probe_index = 0; probe_index < number_of_extended_probes; ++probe_index){
      value = simulation.probe_values_[probe_extension_indices[probe_index]][simulation.considered_simulation_indices_[index] >> 6];
      if ((value >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1) {
        ++counter;
      }
    }

    for (probe_index = 0; probe_index < size_of_key_in_bytes; ++probe_index) {
      datasets[index].key_[probe_index] = (counter >> (probe_index << 3)) & 0xff;
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

template <>
void ProbingSet<RelaxedProbe>::CompactTableUpdate(const Settings& settings, Simulation& simulation, std::vector<Propagation<RelaxedProbe>>& propagations) {
  TableBucketVector datasets;
  uint64_t bit_index, group_index, key_index, probe_index, counter;
  uint64_t number_of_extended_probes;
  uint64_t size_of_key_in_bytes = contingency_table_.GetSizeOfKeyInBytes();
  std::queue<uint64_t> indices;
  std::vector<uint64_t> probe_extension_indices, propagation_indices;
  uint64_t enable_ctr, enable_bound;
  RelaxedProbe* probe;
  RelaxedProbe* new_probe;
  std::set<uint64_t> considered;

  uint64_t all_enable_size = 0;
  for (uint64_t probe_extension_index : probe_extension_indices_) {
    all_enable_size += propagations[probe_extension_index].GetNumberOfEnableIndices();
  }

  datasets.resize(simulation.considered_simulation_indices_.size());

  for (uint64_t index = 0; index < simulation.considered_simulation_indices_.size(); ++index) {
    probe_extension_indices.clear();
    enable_bound = 0;
    group_index = simulation.selected_groups_[simulation.considered_simulation_indices_[index]];
    datasets[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    datasets[index].data_ = std::make_unique<uint32_t[]>(settings.GetNumberOfGroups());
    datasets[index].data_[group_index] = 1;
    counter = 0;  

    for (probe_index = 0; probe_index < probe_extension_indices_.size(); ++probe_index) {
      enable_ctr = enable_bound;
      considered.clear();
      indices.push(probe_extension_indices_[probe_index]);

      if (propagations[indices.front()].GetProbeAddress(0)->number_of_enable_indices_){
        considered.insert(propagations[indices.front()].GetProbeAddress(0)->enable_index_);
      }  

      while (!indices.empty()){
        probe = propagations[indices.front()].GetProbeAddress(0);
        indices.pop();

        if (probe->propagation_indices_.empty()) {
          probe_extension_indices.insert(probe_extension_indices.end(), probe->signal_indices_.begin(), probe->signal_indices_.end());
        } else {  
          if ((simulation.propagation_values_[probe->enable_index_][simulation.considered_simulation_indices_[index] >> 6] >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1) {
            for (bit_index = 0; bit_index < probe->propagation_indices_.size(); ++bit_index) {
              key_index = probe->propagation_indices_[bit_index];
              new_probe = propagations[key_index].GetProbeAddress(0);
                
              if (new_probe->propagation_indices_.empty()){
                probe_extension_indices.insert(probe_extension_indices.end(), new_probe->signal_indices_.begin(), new_probe->signal_indices_.end());
              }else{
                if (considered.find(new_probe->enable_index_) == considered.end()){
                  indices.push(key_index);
                  considered.insert(new_probe->enable_index_);
                }                
              }
            }

            ++counter;
          }else{
            probe_extension_indices.insert(probe_extension_indices.end(), probe->signal_indices_.begin(), probe->signal_indices_.end());
          }

          ++enable_ctr;
        }
      }
                
      enable_bound += propagations[probe_extension_indices_[probe_index]].GetNumberOfEnableIndices();
    }

    std::sort(probe_extension_indices.begin(), probe_extension_indices.end());
    probe_extension_indices.erase(std::unique(probe_extension_indices.begin(), probe_extension_indices.end()), probe_extension_indices.end());  
      
    number_of_extended_probes = probe_extension_indices.size();

    for (bit_index = 0; bit_index < number_of_extended_probes; ++bit_index) {
      if ((simulation.probe_values_[probe_extension_indices[bit_index]][simulation.considered_simulation_indices_[index] >> 6] >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1) {
        ++counter;
      }
    }

    for (bit_index = 0; bit_index < size_of_key_in_bytes; ++bit_index) {
      datasets[index].key_[bit_index] = (counter >> (bit_index << 3)) & 0xff;
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

template <>
void ProbingSet<RobustProbe>::NormalTableUpdate(
    const Settings& settings, Simulation& simulation, std::vector<Propagation<RobustProbe>>& propagations) {
  uint64_t group_index;
  TableBucketVector datasets;
  size_t number_of_extended_probes = GetNumberOfProbeExtensions(propagations);
  uint64_t size_of_key_in_bytes = contingency_table_.GetSizeOfKeyInBytes();
  std::vector<uint64_t> probe_extension_indices = GetProbeExtensions();
  uint64_t probe_index, tmp_index, value;

  datasets.resize(simulation.considered_simulation_indices_.size());
  for (uint64_t index = 0; index < simulation.considered_simulation_indices_.size(); ++index){
    datasets[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    datasets[index].data_ = std::make_unique<uint32_t[]>(settings.GetNumberOfGroups());
    group_index = simulation.selected_groups_[simulation.considered_simulation_indices_[index]];
    datasets[index].data_[group_index] = 1;

    for (probe_index = 0; probe_index < number_of_extended_probes; ++probe_index){
      value = simulation.probe_values_[probe_extension_indices[probe_index]][simulation.considered_simulation_indices_[index] >> 6];
      tmp_index = probe_index >> 3;
      datasets[index].key_[tmp_index] <<= 1;
      datasets[index].key_[tmp_index] |= (value >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1;
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

template <>
void ProbingSet<RelaxedProbe>::NormalTableUpdate(const Settings& settings, Simulation& simulation, std::vector<Propagation<RelaxedProbe>>& propagations) {
  TableBucketVector datasets;
  uint64_t bit_index, group_index, key_index, probe_index, tmp_index;
  uint64_t number_of_extended_probes;
  uint64_t size_of_key_in_bytes = contingency_table_.GetSizeOfKeyInBytes();
  std::queue<uint64_t> indices;
  std::vector<uint64_t> probe_extension_indices, propagation_indices;
  uint64_t enable_ctr, enable_bound;
  RelaxedProbe* probe;
  RelaxedProbe* new_probe;
  std::set<uint64_t> considered;

  uint64_t all_enable_size = 0;
  for (uint64_t probe_extension_index : probe_extension_indices_) {
    all_enable_size += propagations[probe_extension_index].GetNumberOfEnableIndices();
  }

  datasets.resize(simulation.considered_simulation_indices_.size());

  for (uint64_t index = 0; index < simulation.considered_simulation_indices_.size(); ++index){
    probe_extension_indices.clear();
    enable_bound = 0;
    group_index = simulation.selected_groups_[simulation.considered_simulation_indices_[index]];
    datasets[index].key_ = std::make_unique<uint8_t[]>(size_of_key_in_bytes);
    datasets[index].data_ = std::make_unique<uint32_t[]>(settings.GetNumberOfGroups());
    datasets[index].data_[group_index] = 1;

    for (probe_index = 0; probe_index < probe_extension_indices_.size(); ++probe_index) {
      enable_ctr = enable_bound;
      considered.clear();
      indices.push(probe_extension_indices_[probe_index]);

      if (propagations[indices.front()].GetProbeAddress(0)->number_of_enable_indices_){
        considered.insert(propagations[indices.front()].GetProbeAddress(0)->enable_index_);
      }  

      while (!indices.empty()){
        probe = propagations[indices.front()].GetProbeAddress(0);
        indices.pop();

        if (probe->propagation_indices_.empty()) {
          probe_extension_indices.insert(probe_extension_indices.end(), probe->signal_indices_.begin(), probe->signal_indices_.end());
        } else {  
          tmp_index = enable_ctr  >> 3;
          datasets[index].key_[tmp_index] <<= 1;
          
          if ((simulation.propagation_values_[probe->enable_index_][simulation.considered_simulation_indices_[index] >> 6] >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1) {
            for (bit_index = 0; bit_index < probe->propagation_indices_.size(); ++bit_index) {
              key_index = probe->propagation_indices_[bit_index];
              new_probe = propagations[key_index].GetProbeAddress(0);
                
              if (new_probe->propagation_indices_.empty()){
                probe_extension_indices.insert(probe_extension_indices.end(), new_probe->signal_indices_.begin(), new_probe->signal_indices_.end());
              }else{
                if (considered.find(new_probe->enable_index_) == considered.end()){
                  indices.push(key_index);
                  considered.insert(new_probe->enable_index_);
                }                
              }
            }

            tmp_index = enable_ctr >> 3;
            datasets[index].key_[tmp_index] |= 1;
          }else{
            probe_extension_indices.insert(probe_extension_indices.end(), probe->signal_indices_.begin(), probe->signal_indices_.end());
          }

          ++enable_ctr;
        }
      }
                
      enable_bound += propagations[probe_extension_indices_[probe_index]].GetNumberOfEnableIndices();
    }

    std::sort(probe_extension_indices.begin(), probe_extension_indices.end());
    probe_extension_indices.erase(std::unique(probe_extension_indices.begin(), probe_extension_indices.end()), probe_extension_indices.end());  
      
    number_of_extended_probes = probe_extension_indices.size();
      
    for (bit_index = 0; bit_index < number_of_extended_probes; ++bit_index) {
      tmp_index = (bit_index + all_enable_size) >> 3;
      datasets[index].key_[tmp_index] <<= 1;
      datasets[index].key_[tmp_index] |= (simulation.probe_values_[probe_extension_indices[bit_index]][simulation.considered_simulation_indices_[index] >> 6] >> (simulation.considered_simulation_indices_[index] & 0b111111)) & 1;
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

template <>
uint64_t ProbingSet<RobustProbe>::GetHighestClockCycle(std::vector<Propagation<RobustProbe>>&, std::vector<Probe>& probe_extensions) {
  RobustProbe probe = GetLastProbeExtension();
  return probe_extensions[probe].GetCycle();
}

template <>
uint64_t ProbingSet<RelaxedProbe>::GetHighestClockCycle(std::vector<Propagation<RelaxedProbe>>& propagations, std::vector<Probe>& probe_extensions) {
  uint64_t clock_cycle, probe_index, result = 0;

  for (uint64_t index : GetProbeExtensions()){
    probe_index = propagations[index].GetSignalIndex();    
    clock_cycle = probe_extensions[probe_index].GetCycle();

    if (clock_cycle > result){
      result = clock_cycle;
    }
  }

  return result;
}

template <class ExtensionContainer>
size_t GetIndexOfMostLeakingProbingSet(std::vector<ProbingSet<ExtensionContainer>>& probing_sets, std::vector<bool>& bitmask) {
  size_t index = 0, set_index;
  double g_value, maximum = 0.0;

  // Unfortunately not sorted so linear complexity
  for (set_index = 0; set_index < probing_sets.size(); ++set_index) {
    g_value = probing_sets[set_index].GetGValue();

    if ((g_value > maximum) && bitmask[set_index]) {
      maximum = g_value;
      index = set_index;
    }
  }

  return index;
}

template size_t GetIndexOfMostLeakingProbingSet(std::vector<ProbingSet<RobustProbe>>&, std::vector<bool>&);
template size_t GetIndexOfMostLeakingProbingSet(std::vector<ProbingSet<RelaxedProbe>>&, std::vector<bool>&);

template <class ExtensionContainer>
uint64_t GetNumberOfRequiredTraces(std::vector<ProbingSet<ExtensionContainer>>& probing_sets, const Settings& settings) {
  uint64_t number_of_entries, maximum = 0;

  // Unfortunately not sorted so linear complexity
  for (ProbingSet<ExtensionContainer>& it : probing_sets){
    number_of_entries = it.GetNumberOfEntries();
    
    if (number_of_entries > maximum) {
      maximum = number_of_entries;
    }  
  }

  return ComputeRequiredSampleSize(settings.GetNumberOfGroups(), maximum, settings.side_channel_analysis.beta_threshold, settings.side_channel_analysis.effect_size);
}

template uint64_t GetNumberOfRequiredTraces(std::vector<ProbingSet<RobustProbe>>&, const Settings&);
template uint64_t GetNumberOfRequiredTraces(std::vector<ProbingSet<RelaxedProbe>>&, const Settings&);
}