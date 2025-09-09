#include "Hardware/ProbingSets.hpp"

namespace Hardware {

ProbingSet::ProbingSet(const CircuitStruct& circuit, const Settings& settings, 
  const std::vector<const Probe*>& probes) : probes_(probes){
  Extend(circuit);

  if (settings.side_channel_analysis.notion != sca_notion_t::ps) {
    SetSimulators(settings);
  }
};

bool ProbingSet::operator<(const ProbingSet& other) const {
  return (extensions_ < other.extensions_);
}

bool ProbingSet::operator==(const ProbingSet& other) const {
  return (extensions_ == other.extensions_);
}

bool ProbingSet::operator!=(const ProbingSet& other) const {
  return (extensions_ != other.extensions_);
}

const std::vector<const Probe*>& ProbingSet::GetProbes() const {
  return probes_;
}

uint64_t ProbingSet::GetSizeOfKeyInBits() const {
  return number_of_extensions_ + number_of_enablers_;
}

const std::vector<const Probe*>& ProbingSet::GetExtensions() const {
  return extensions_;
}

void ProbingSet::Initialize(bool is_in_compact_mode, uint64_t number_of_groups) {
  contingency_table_.Initialize(GetSizeOfKeyInBits(),  number_of_groups, is_in_compact_mode);
}

double ProbingSet::GetGValue() const {
  return contingency_table_.GetLog10pValue();
}

uint64_t ProbingSet::GetNumberOfEntries() const {
  return contingency_table_.GetNumberOfEntries();
}

void ProbingSet::DeconstructTable() {
  contingency_table_.Deconstruct();
};

void ProbingSet::Deconstruct() {
  probes_.clear();
  extensions_.clear();
  DeconstructTable();
};

void ProbingSet::ComputeGTest(uint64_t number_of_groups, uint64_t number_of_simulations, std::vector<double>& group_simulation_ratio) {
  contingency_table_.SetLog10pValue(number_of_groups, number_of_simulations, simulators_, group_simulation_ratio);
}

bool ProbingSet::IsSampleSizeSufficient(uint64_t number_of_samples, const Settings& settings) const {
  uint64_t degrees_of_freedom = (settings.GetNumberOfGroups() - 1) * (GetNumberOfEntries() - 1);
  double beta_threshold = settings.side_channel_analysis.beta_threshold;
  double effect_size = settings.side_channel_analysis.effect_size;

  if (degrees_of_freedom) {
    boost::math::chi_squared_distribution<> distribution(degrees_of_freedom);
    double critical_value = boost::math::quantile(
        boost::math::complement(distribution, beta_threshold));
    double non_centrality_parameter =
        number_of_samples * effect_size * effect_size;
    boost::math::non_central_chi_squared_distribution<> dist(
        degrees_of_freedom, non_centrality_parameter);
    return boost::math::cdf(dist, critical_value) <= beta_threshold;
  } else {
    return false;
  }
}

std::string ProbingSet::PrintProbes(const Settings& settings) const{
  std::string result;
  clk_edge_t edge = settings.GetClkEdge();

  assert(edge != clk_edge_t::undef && "Error in PrintProbes(): Clock edge undefined!");
  assert(!probes_.empty() && "Error in PrintProbes(): probes is empty!");

  for (const Probe* probe : probes_) {
    result += probe->Print(edge, true) + ", ";
  }

  result.pop_back();
  result.pop_back();
  return result;
}

void ProbingSet::CompactRelaxedTableUpdate(const Simulation& simulation) {
  uint64_t grp_idx, sim_idx, ctr;
  std::queue<const Probe*> indices;
  std::vector<const Probe*> extensions;
  const Probe* probe = nullptr;
  const Enabler* enabler = nullptr;
  std::unordered_set<const Enabler*> finished_enabler;

  uint64_t number_of_simulations =
      simulation.considered_simulation_indices_.size();

  for (uint64_t idx = 0; idx < number_of_simulations; ++idx) {
    extensions.clear();
    finished_enabler.clear();
    sim_idx = simulation.considered_simulation_indices_[idx];
    grp_idx = simulation.selected_groups_[sim_idx];
    ctr = 0;

    for (const Probe* standard_probe : probes_) {
      indices.push(standard_probe);

      while (!indices.empty()) {
        probe = indices.front();
        enabler = probe->GetEnabler();
        indices.pop();

        if (enabler == nullptr) {
          for (const Probe* extension : probe->GetTransitionExtensions()) {
            extensions.push_back(extension);
          }
        } else {
          if (finished_enabler.insert(enabler).second) {      
            if ((probe->GetBitslicedPropValue(sim_idx >> 6) >> (sim_idx & 0b111111)) & 1) {
              for (const Probe* extension : probe->GetGlitchExtensions()) {
                indices.push(extension);
              }
            } else {
              for (const Probe* extension : probe->GetTransitionExtensions()) {
                extensions.push_back(extension);
              }
            }
          }
        }
      }
    }

    std::sort(extensions.begin(), extensions.end());
    extensions.erase(std::unique(extensions.begin(), extensions.end()), extensions.end());

    for (const Probe* extension : extensions) {
      if (extension->GetBitslicedValue(0, sim_idx >> 6) >>(sim_idx & 0b111111) & 1) {
        ctr++;          
      }
    }

    contingency_table_.IncrementSpecificCounter(ctr, grp_idx);
  }
}

void ProbingSet::NormalRobustTableUpdateWithAllSimulations(const Settings& settings, const Simulation& simulation) {
  uint64_t grp_idx, sim_idx;
  uint64_t number_of_groups = settings.GetNumberOfGroups();
  uint64_t number_of_simulations = simulation.considered_simulation_indices_.size();
  uint64_t number_of_key_blocks = contingency_table_.GetSizeOfKeyInBytes();

  TableBucketVector datasets(number_of_simulations);
  for (uint64_t idx = 0; idx < number_of_simulations; ++idx) {
    grp_idx = simulation.selected_groups_[simulation.considered_simulation_indices_[idx]];
    datasets[idx].key_ = std::make_unique<uint8_t[]>(number_of_key_blocks);
    std::memset(datasets[idx].key_.get(), 0, number_of_key_blocks);
    datasets[idx].data_ = std::make_unique<uint32_t[]>(number_of_groups);
    std::memset(datasets[idx].data_.get(), 0, sizeof(uint32_t) * number_of_groups);
    datasets[idx].data_[grp_idx] = 1;
  }

  for (uint64_t idx = 0; idx < number_of_simulations; ++idx) {  
    sim_idx = simulation.considered_simulation_indices_[idx];
    for (uint64_t ext_idx = 0; ext_idx < extensions_.size(); ++ext_idx) {
      datasets[idx].key_[ext_idx >> 3] |= ((extensions_[ext_idx]->GetBitslicedValue(0, sim_idx >> 6) 
        >> (sim_idx & 0b111111)) & 1) << (ext_idx & 0b111);
    }
  }

  contingency_table_.UpdateBucket(datasets, number_of_groups);
}

void ProbingSet::NormalRelaxedTableUpdate(const Settings& settings, const Simulation& simulation) {
  uint64_t en_idx, grp_idx, key_idx, sim_idx;
  uint64_t number_of_key_blocks = contingency_table_.GetSizeOfKeyInBytes();
  uint64_t number_of_groups = settings.GetNumberOfGroups();
  std::queue<const Probe*> indices;
  std::vector<const Probe*> extensions;
  const Probe* probe = nullptr;
  const Enabler* enabler = nullptr;
  std::unordered_set<const Enabler*> finished_enabler;

  uint64_t number_of_simulations =
      simulation.considered_simulation_indices_.size();

  TableBucketVector datasets(number_of_simulations);
  for (uint64_t idx = 0; idx < number_of_simulations; ++idx) {
    grp_idx = simulation.selected_groups_[simulation.considered_simulation_indices_[idx]];
    datasets[idx].key_ = std::make_unique<uint8_t[]>(number_of_key_blocks);
    std::memset(datasets[idx].key_.get(), 0, number_of_key_blocks);
    datasets[idx].data_ = std::make_unique<uint32_t[]>(number_of_groups);
    std::memset(datasets[idx].data_.get(), 0,
                sizeof(uint32_t) * number_of_groups);
    datasets[idx].data_[grp_idx] = 1;
  }

  for (uint64_t idx = 0; idx < number_of_simulations; ++idx) {
    sim_idx = simulation.considered_simulation_indices_[idx];
    en_idx = 0;
    extensions.clear();
    finished_enabler.clear();

    for (const Probe* standard_probe : probes_) {
      indices.push(standard_probe);

      while (!indices.empty()) {
        probe = indices.front();
        enabler = probe->GetEnabler();
        indices.pop();

        if (enabler == nullptr) {
          for (const Probe* extension : probe->GetTransitionExtensions()) {
            extensions.push_back(extension);
          }
        } else {
          if (finished_enabler.insert(enabler).second) {      
            if ((probe->GetBitslicedPropValue(sim_idx >> 6) >> (sim_idx & 0b111111)) & 1) {
              for (const Probe* extension : probe->GetGlitchExtensions()) {
                indices.push(extension);
              }

              datasets[idx].key_[en_idx >> 3] |= 1 << (en_idx & 0b111);
              en_idx++;
            } else {
              for (const Probe* extension : probe->GetTransitionExtensions()) {
                extensions.push_back(extension);
              }
            }
          }
        }
      }
    }

    std::sort(extensions.begin(), extensions.end());
    extensions.erase(std::unique(extensions.begin(), extensions.end()), extensions.end());

    for (uint64_t ext_idx = 0; ext_idx < extensions.size(); ++ext_idx) {
      key_idx = (ext_idx + number_of_enablers_) >> 3;
      datasets[idx].key_[key_idx] |= ((extensions[ext_idx]->GetBitslicedValue(0, sim_idx >> 6) >>
        (sim_idx & 0b111111)) & 1) << ((ext_idx + number_of_enablers_) & 0b111);
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

void ProbingSet::NormalRobustTableUpdate(const Settings& settings, const Simulation& simulation) {
  uint64_t group_index;
  TableBucketVector datasets;
  uint64_t key_size_in_bytes = contingency_table_.GetSizeOfKeyInBytes();
  uint64_t tmp_index, value;

  datasets.resize(simulation.considered_simulation_indices_.size());
  for (uint64_t idx = 0; idx < simulation.considered_simulation_indices_.size(); ++idx) {
    datasets[idx].key_ = std::make_unique<uint8_t[]>(key_size_in_bytes);
    std::memset(datasets[idx].key_.get(), 0, key_size_in_bytes);
    datasets[idx].data_ = std::make_unique<uint32_t[]>(settings.GetNumberOfGroups());
    std::memset(datasets[idx].data_.get(), 0, sizeof(uint32_t) * settings.GetNumberOfGroups());

    group_index = simulation.selected_groups_[simulation.considered_simulation_indices_[idx]];
    datasets[idx].data_[group_index] = 1;

    uint64_t ctr = 0;
    for (const Probe* probe : extensions_) {
      value = probe->GetBitslicedValue(0, simulation.considered_simulation_indices_[idx] >> 6);
      tmp_index = ctr++ >> 3;
      datasets[idx].key_[tmp_index] <<= 1;
      datasets[idx].key_[tmp_index] |= 
        (value >> (simulation.considered_simulation_indices_[idx] & 0b111111)) & 1;
    }
  }

  contingency_table_.UpdateBucket(datasets, settings.GetNumberOfGroups());
}

uint64_t ProbingSet::GetHighestClockCycle() const {
  assert(!probes_.empty() && "Error in GetHighestClockCycle(): Probes is empty!");
  assert(std::is_sorted(probes_.begin(), probes_.end()) &&
         "Error in GetHighestClockCycle(): Probes not sorted!");
  return probes_.back()->GetCycle();
}

uint64_t ProbingSet::GetSizeOfKeyInBytes() {
  return contingency_table_.GetSizeOfKeyInBytes();
}

void ProbingSet::IncrementSpecificCounter(uint64_t key_index, uint64_t group_index) {
  contingency_table_.IncrementSpecificCounter(key_index, group_index);
}

void ProbingSet::Extend(const CircuitStruct& circuit) {
  std::queue<const Probe*> path;
  std::unordered_set<const Probe*> visited;
  std::vector<const Enabler*> enablers;

  for (const Probe* probe : probes_) {
    if (visited.insert(probe).second) {
      path.push(probe);
    }
  }

  while (!path.empty()) {
    const Probe* probe = path.front();
    if (probe->DoesExtend(circuit)) {
      if (probe->GetEnabler() != nullptr) {
        enablers.push_back(probe->GetEnabler());
      }
      for (const Probe* extension : probe->GetGlitchExtensions()) {
        if (visited.insert(extension).second) {
          path.push(extension);
        }
      }
    } else {
      for (const Probe* extension : probe->GetTransitionExtensions()) {
        extensions_.push_back(extension);
      }
    }

    path.pop();
  }

  std::sort(extensions_.begin(), extensions_.end(), [](const Probe* lhs, const Probe* rhs) {return *lhs < *rhs;});
  extensions_.erase(std::unique(extensions_.begin(), extensions_.end()), extensions_.end()); 
  number_of_enablers_ = enablers.size();
  number_of_extensions_ = extensions_.size();
}

void ProbingSet::SetSimulators(const Settings& settings) {
  uint64_t upper_bound;
  if (settings.side_channel_analysis.notion == sca_notion_t::ni) {
    upper_bound = settings.GetTestOrder();
  } else if (settings.side_channel_analysis.notion == sca_notion_t::sni || 
             settings.side_channel_analysis.notion == sca_notion_t::pini) {
    upper_bound = std::count_if(probes_.begin(), probes_.end(),
      [](const Probe* probe) { return probe->IsInternal(); });
  } else {
    throw std::logic_error("Error in ProbingSet::SetSimulators(): Invalid security notion!");
  }

  uint64_t input_size_in_bits = std::ceil(std::log2l(settings.input_finite_field.base)) 
                                                   * settings.input_finite_field.exponent;
  uint64_t group_size_in_bits = settings.GetNumberOfBitsPerGroup();
  uint64_t number_of_inputs = group_size_in_bits / input_size_in_bits;
  std::vector<bool> bitmask(number_of_inputs, false);
  std::vector<uint64_t> share_count_per_input(number_of_inputs);
  std::vector<uint64_t> enabled_input_share_indices;
  std::vector<uint64_t> output_share_indices, input_share_indices;

  if (settings.side_channel_analysis.notion == sca_notion_t::pini) {
    std::map<std::string, uint64_t> signal_name_to_share_index;
    for (uint64_t share_idx = 0; share_idx < settings.GetNumberOfOutputShares(); ++share_idx) {
      for (uint64_t bit_idx = 0; bit_idx < settings.GetNumberOfBitsPerOutputShare(); ++bit_idx) {
        std::string signal_name = settings.GetOutputShareName(share_idx, bit_idx);
        signal_name_to_share_index[signal_name] = share_idx;
      }
    }

    for (const Probe* probe : probes_) {
      if (!probe->IsInternal()) {
        for (const SignalStruct* signal : probe->GetSignals()) {
          std::string signal_name = signal->Name;
          auto it = signal_name_to_share_index.find(signal_name);
          if (it != signal_name_to_share_index.end()) {
            output_share_indices.push_back(it->second);
          }
        }
      }
    }

    std::sort(output_share_indices.begin(), output_share_indices.end());
    output_share_indices.erase(std::unique(output_share_indices.begin(), 
      output_share_indices.end()), output_share_indices.end()); 
  }

  do {
    std::fill(share_count_per_input.begin(), share_count_per_input.end(), 0);
  
    bool valid_simulator = false;
    if (settings.side_channel_analysis.notion == sca_notion_t::pini) {
      for (const auto& elem : settings.GetMapping()) {
        uint64_t share_idx = std::get<0>(elem.first);
        uint64_t group_idx = elem.second;

        if (bitmask[group_idx]) {
          enabled_input_share_indices.push_back(group_idx);
          input_share_indices.push_back(share_idx);
        }

        if (std::find(output_share_indices.begin(), output_share_indices.end(), share_idx) != output_share_indices.end()) {
          enabled_input_share_indices.push_back(group_idx);
        }
      }

      std::sort(input_share_indices.begin(), input_share_indices.end());
      input_share_indices.erase(std::unique(input_share_indices.begin(), 
        input_share_indices.end()), input_share_indices.end());
      valid_simulator = input_share_indices.size() <= upper_bound;   
    } else {
      for (const auto& elem : settings.GetMapping()) {
        uint64_t value_idx = std::get<1>(elem.first);
        uint64_t group_idx = elem.second;

        if (bitmask[group_idx]) {
          enabled_input_share_indices.push_back(group_idx);
          ++share_count_per_input[value_idx];
        }
      }

      valid_simulator = std::all_of(share_count_per_input.begin(), share_count_per_input.end(), 
        [upper_bound](uint64_t ctr) { return ctr <= upper_bound; });
    }

    if (valid_simulator) {
      std::sort(enabled_input_share_indices.begin(), enabled_input_share_indices.end());
      enabled_input_share_indices.erase(std::unique(enabled_input_share_indices.begin(), 
        enabled_input_share_indices.end()), enabled_input_share_indices.end());
      simulators_.emplace_back(enabled_input_share_indices, std::vector<uint64_t>());
    }
    enabled_input_share_indices.clear();
    input_share_indices.clear();
  } while (Next(bitmask));

  BOOST_LOG_TRIVIAL(info) << "Successfully set " << simulators_.size() 
    << " simulators for probing set " << PrintProbes(settings) << ".";
}

}  // namespace Hardware