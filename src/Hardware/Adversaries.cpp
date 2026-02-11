#include "Hardware/Adversaries.hpp"
#include <cassert>

namespace Hardware {
void Adversaries::PrintProbeReport() const {
  boost::property_tree::ptree report, probes;

  for (const Probe* probe : placed_probes_) {
    boost::property_tree::ptree pt;
    pt.put("", probe->Print(settings_.GetClkEdge(), true));
    probes.push_back(std::make_pair("", pt));
  }

  report.add_child("placed_probes", probes);
  probes.clear();

  for (const Probe* probe : extensions_) {
    boost::property_tree::ptree pt;
    pt.put("", probe->Print(settings_.GetClkEdge(), true));
    probes.push_back(std::make_pair("", pt));
  }

  report.add_child("extended_probes", probes);
  probes.clear();

  std::set<uint64_t> unique_cycles;
  for (const Probe& probe : probes_) {
    unique_cycles.insert(probe.GetCycle());
  }

  uint64_t range = probes_.size() / unique_cycles.size();
  for (uint64_t idx = probes_.size() - range; idx < probes_.size(); ++idx) {
    if (!probes_[idx].GetGlitchExtensions().empty()) {
      boost::property_tree::ptree pt, ext, exts;
      pt.put("signals", probes_[idx].Print(settings_.GetClkEdge(), false));

      for (const Probe* extension : probes_[idx].GetGlitchExtensions()) {
        ext.put("", extension->Print(settings_.GetClkEdge(), false));
        exts.push_back(std::make_pair("", ext));
      }

      pt.add_child("glitch_extension", exts);
      probes.push_back(std::make_pair("", pt));
    }
  }
  report.add_child("extensions", probes);
  std::string file_name = simulation_.result_folder_name_ + "/prolead_" + topmodule_name_ + "_probes.json";
  write_json(file_name, report);
}

void Adversaries::PrintLeakageReport(uint64_t fault_idx, uint64_t step_idx) const {
  boost::property_tree::ptree report, sets;
  uint64_t number_of_sets_in_report =
    std::min(probing_sets_.size(), settings_.GetNumberOfEntriesInReport());
  report.put("timestamp", GetTimestamp());

  if (settings_.side_channel_analysis.notion == sca_notion_t::ps) {
    report.put("notion", "Probing Security");
  } else if (settings_.side_channel_analysis.notion == sca_notion_t::ni) {
    report.put("notion", "Non-Interference");
  } else if (settings_.side_channel_analysis.notion == sca_notion_t::sni) {
    report.put("notion", "Strong Non-Interference");
  } else if (settings_.side_channel_analysis.notion == sca_notion_t::pini) {
    report.put("notion", "Probe-Isolating Non-Interference");
  } else if (settings_.side_channel_analysis.notion == sca_notion_t::opini) {
    report.put("notion", "Output Probe-Isolating Non-Interference");
  } else {
    throw std::runtime_error("Error in Adversaries::PrintLeakageReport(): Unknown SCA notion!");
  }

  report.put("number_of_simulations", simulation_.number_of_processed_simulations);
  uint64_t number_of_leaking_sets = 0, number_of_non_leaking_sets = 0;
  for (const ProbingSet& probing_set : probing_sets_) {
    if (probing_set.GetGValue() >= 5.0) {
      ++number_of_leaking_sets;
    } else {
      ++number_of_non_leaking_sets;
    }
  }

  report.put("total_number_of_probing_sets", probing_sets_.size());
  report.put("number_of_leaking_probing_sets", number_of_leaking_sets);
  report.put("number_of_non_leaking_probing_sets", number_of_non_leaking_sets);

  if (!simulation_.fault_set_.empty()) {
    for (uint64_t idx = 0; idx < simulation_.fault_set_[0].GetNumberOfFaultsInSet(); ++idx) {
      boost::property_tree::ptree pt;
      std::string fault_text = simulation_.fault_set_[0].GetFault(idx)->Print(settings_.GetClkEdge(), true);
      const FaultType fault_type = simulation_.fault_set_[0].GetFault(idx)->GetType();
      if (fault_type == FaultType::stuck_at_0) {
        fault_text += " = 0 (stuck at 0)";
      } else if (fault_type == FaultType::stuck_at_1) {
        fault_text += " = 1 (stuck at 1)";
      } else if (fault_type == FaultType::toggle) {
        fault_text += "~" + fault_text + " (toggle)";
      } else {
        throw std::runtime_error("Error in Adversaries::PrintLeakageReport(): Unknown fault type!");
      }

      pt.put("", fault_text);
      sets.push_back(std::make_pair("", pt));
    }

    report.add_child("injected_faults", sets);
  }
  sets.clear();

  auto ProbingSetToJson = [&](const ProbingSet* probing_set) -> boost::property_tree::ptree {
    boost::property_tree::ptree probes, pt, set;
    for (const Probe* probe : probing_set->GetProbes()) {
      pt.put("", probe->Print(settings_.GetClkEdge(), true));
      probes.push_back(std::make_pair("", pt));
    }

    set.add_child("probes", probes);
    probes.clear();

    for (const Probe* extension : probing_set->GetExtensions()) {
      pt.put("", extension->Print(settings_.GetClkEdge(), true));
      probes.push_back(std::make_pair("", pt));
    }

    set.add_child("extensions", probes);
    set.put("-log10(p)", probing_set->GetGValue());
    return set;
  };

  std::vector<const ProbingSet*> probing_sets;
  probing_sets.reserve(probing_sets_.size());
  for (const ProbingSet& probing_set : probing_sets_) {
    probing_sets.push_back(&probing_set);
  }

  std::sort(probing_sets.begin(), probing_sets.end(), [](const ProbingSet* lhs, const ProbingSet* rhs) {
    return lhs->GetGValue() > rhs->GetGValue();
  });

  std::vector<const ProbingSet*> most_leaking_sets_per_cycle(settings_.GetNumberOfClockCycles(), nullptr);
  for (const ProbingSet* probing_set : probing_sets) {
    uint64_t cycle = probing_set->GetHighestClockCycle();
    if (most_leaking_sets_per_cycle[cycle] == nullptr) {
      most_leaking_sets_per_cycle[cycle] = probing_set;
    }
  }

  for (const ProbingSet* probing_set : most_leaking_sets_per_cycle) {
    if (probing_set != nullptr) {
      sets.push_back(std::make_pair("", ProbingSetToJson(probing_set)));
    }
  }

  report.add_child("most_leaking_probing_sets_per_cycle", sets);
  sets.clear();

  for (uint64_t idx = 0; idx < number_of_sets_in_report; ++idx) {
    sets.push_back(std::make_pair("", ProbingSetToJson(probing_sets[idx])));
  }

  if (number_of_sets_in_report) {
    report.add_child("most_leaking_probing_sets_in_total", sets);
  }

  std::string file_name = simulation_.result_folder_name_ + "/prolead_" +
    topmodule_name_ + "_" + std::to_string(fault_idx) + "_" + std::to_string(step_idx) + "_" +
    std::to_string(simulation_.number_of_processed_simulations) + "_leakages.json";
  write_json(file_name, report);
}

uint64_t Adversaries::GetNumberOfRequiredTraces() const {
  uint64_t number_of_entries, maximum = 0;

  for (const ProbingSet& probing_set : probing_sets_) {
    number_of_entries = probing_set.GetNumberOfEntries();

    if (number_of_entries > maximum) {
      maximum = number_of_entries;
    }
  }

  assert(maximum > 0 && "Error in Adversaries::GetNumberOfRequiredTraces(): "
                         "No probing sets found or all probing sets are empty.");

  return ComputeRequiredSampleSize(
      settings_.GetNumberOfGroups(), maximum,
      settings_.side_channel_analysis.beta_threshold,
      settings_.side_channel_analysis.effect_size);
}

void Adversaries::PrintSummary() {
  assert(!probing_sets_.empty() && "Error in Adversaries::PrintSummary(): No probing sets found!");
  uint64_t mini = UINT64_MAX;
  uint64_t maxi = 0;
  uint64_t key_size_in_bits = 0;
  double diff, avrg = 0, ctr = 0;

  for (const ProbingSet& probing_set : probing_sets_) {
    key_size_in_bits = probing_set.GetSizeOfKeyInBits();
    diff = key_size_in_bits - avrg;
    avrg += diff / ++ctr;

    if (key_size_in_bits < mini) { mini = key_size_in_bits; }
    if (key_size_in_bits > maxi) { maxi = key_size_in_bits; }
  }

  std::string number_of_probes = std::to_string(placed_probes_.size());
  std::string number_of_extensions = std::to_string(extensions_.size());
  std::string number_of_sets = std::to_string(probing_sets_.size());
  std::string minimum = std::to_string(mini);
  std::string maximum = std::to_string(maxi);
  std::string average = std::to_string(avrg);

  std::vector<TableCell> header{
    {"#Standard Probes", number_of_probes.size()},
    {"#Extended Probes", number_of_extensions.size()},
    {"#Probing Sets", number_of_sets.size()},
    {"Minimum #Probes per Set", minimum.size()},
    {"Maximum #Probes per Set", maximum.size()},
    {"Average #Probes per Set", average.size()}
  };

  std::vector<TableCell> body{
    {number_of_probes, header[0].width_},
    {number_of_extensions, header[1].width_},
    {number_of_sets, header[2].width_},
    {minimum, header[3].width_},
    {maximum, header[4].width_},
    {average, header[5].width_}
  };

  report_.put("name", "prolead");
  report_.put("version", "x.x.x");
  report_.put("#threads", std::to_string(settings_.GetNumberOfThreads()));
  report_.put("#probes", number_of_probes);
  report_.put("#extensions", number_of_extensions);
  report_.put("#sets", number_of_sets);
  report_.put("probes_per_set_min", minimum);
  report_.put("probes_per_set_max", maximum);
  report_.put("probes_per_set_avg", average);

  Logger logger(1,120,100);
  logger.PrintHeader(header);
  logger.PrintRowWithSeparation(body, true);
}

void Adversaries::PrintEvaluationBody(const std::vector<TableCell>& header,
  double max_p_value_deleted, const std::string& printed_probing_set_deleted, timespec& start_time) const{
  std::vector<bool> bitmask(this->probing_sets_.size(), true);

  Logger logger(1, 120, 100);
  TableCell time_cell = logger.GetTimeCell(EndClock(start_time), strlen("Elapsed Time"));
  TableCell memory_cell = logger.GetMemoryCell(GetUsedMemory(), strlen("Used Memory"));
  std::string processed_simulations = std::to_string(simulation_.number_of_processed_simulations) + " / " +
    std::to_string(GetNumberOfRequiredTraces());

  std::vector<TableCell> body{
    {time_cell.content_, header[0].width_},
    {memory_cell.content_, header[1].width_},
    {processed_simulations, header[2].width_}
  };

  ProbingSet const* probing_set = GetMostLeakingSet(bitmask);
  double p_value = 0.0;
  double max_p_value = 0.0;

  if (probing_set != nullptr) {
    p_value = probing_set->GetGValue();
    max_p_value = std::max(p_value, max_p_value_deleted);

    if (p_value > max_p_value_deleted) {
      body.push_back({probing_set->PrintProbes(settings_), header[3].width_});
    } else {
      body.push_back({printed_probing_set_deleted, header[3].width_});
    }

    body.push_back({std::to_string(max_p_value), header[4].width_});
    body.push_back({(max_p_value < 5.0) ? "OKAY" : "LEAKAGE", header[5].width_});
  } else {
    uint64_t width = header[3].width_ + header[4].width_ + header[5].width_;
    std::string stars = std::string((width - 22) / 2, '*');
    std::string warning = stars + " More Simulations Required! *" + stars;
    body.push_back({warning, width});
  }

  logger.PrintRow(body);
}

uint64_t Adversaries::GetProbingSetColumnSize() {
  std::string text;
  uint64_t result = 0;

  assert(!probing_sets_.empty() && "Error in Adversaries::GetProbingSetColumnSize(): "
                                 "The probing sets are empty.");

  for (const ProbingSet& probing_set : this->probing_sets_) {
    text = probing_set.PrintProbes(settings_);
    if (text.length() > result) {
      result = text.length();
    }
  }

  return result;
}

ProbingSet const* Adversaries::GetMostLeakingSet(const std::vector<bool>& bitmask) const {
  ProbingSet const* result = nullptr;
  double p_value, max_p_value = 0.0;

  assert(!bitmask.empty() && "Error in Adversaries::GetMostLeakingSet(): Empty bitmask!");
  assert(bitmask != std::vector<bool>(bitmask.size(), false) &&
         "Error in Adversaries::GetMostLeakingSet(): "
         "All bits in bitmask are false!");
  assert(!probing_sets_.empty() && "Error in Adversaries::GetMostLeakingSet(): "
                                 "The probing sets are empty!");

  for (uint64_t idx = 0; idx < probing_sets_.size(); ++idx) {
    if (bitmask[idx]) {
      p_value = probing_sets_[idx].GetGValue();

      if (p_value > max_p_value) {
        max_p_value = p_value;
        result = &probing_sets_[idx];
      }
    }
  }

  return result;
}

uint64_t Adversaries::GetNumberOfSpots() {
  std::vector<uint64_t> spots;

  for (const Probe* probe : placed_probes_) {
    assert(!probe->GetSignals().empty() && "Error in Adversaries::GetNumberOfSpots(): No signals in probe!");
    spots.push_back(probe->GetSignals()[0]->id);
  }

  std::sort(spots.begin(), spots.end());
  spots.erase(std::unique(spots.begin(), spots.end()), spots.end());
  return spots.size();
}

const Enabler& Adversaries::GetEnabler(uint64_t index) const {
  assert(index < enabler_.size() && "Error in Adversaries::GetEnabler(): Index out of boundes!");
  return enabler_[index];
}

const std::vector<Enabler>& Adversaries::GetEnablers() const {
  return enabler_;
}

void Adversaries::SetUniqueProbes() {
  std::vector<std::vector<uint64_t>> probing_set_indices(extensions_.size());
  unique_probes_.clear();

  for (uint64_t index = 0; index < probing_sets_.size(); ++index) {
    for (const Probe* probe : probing_sets_[index].GetExtensions()) {
      probing_set_indices[std::distance(extensions_.begin(), std::find(extensions_.begin(), extensions_.end(), probe))].push_back(index);
    }
  }

  for (uint64_t idx = 0; idx < extensions_.size(); ++idx) {
    unique_probes_.emplace_back(extensions_[idx]->GetSignals(), extensions_[idx]->GetCycle(), probing_set_indices[idx]);
  }
}

void Adversaries::SetEnablers() {
  std::queue<const Probe*> path;
  std::vector<const Probe*> enabled_probes;
  std::unordered_set<const Probe*> visited;

  for (const Probe* probe : placed_probes_) {
    if (visited.insert(probe).second) {
      path.push(probe);
    }
  }

  while (!path.empty()) {
    const Probe* probe = path.front();
    if (probe->DoesExtend(circuit_)) {
      enabled_probes.push_back(const_cast<Probe*>(probe));
      BOOST_LOG_TRIVIAL(trace) << "Probe: "
        << probe->Print(settings_.GetClkEdge(), true) << " requires an enabler.";
      for (const Probe* extension : probe->GetGlitchExtensions()) {
        if (extension->DoesExtend(circuit_) && visited.insert(extension).second) {
          path.push(extension);
        }
      }
    }

    path.pop();
  }

  std::sort(enabled_probes.begin(), enabled_probes.end(), [](const Probe* lhs, const Probe* rhs) {
    return *lhs < *rhs;
  });

  enabled_probes.erase(std::unique(enabled_probes.begin(), enabled_probes.end(),
    [](const Probe* lhs, const Probe* rhs) { return *lhs == *rhs; }), enabled_probes.end());

  BOOST_LOG_TRIVIAL(info) << "Successfully detected "
    << enabled_probes.size() << " probes that are conditionally extended.";

  uint64_t number_of_steps = settings_.GetNumberOfSimulationsPerStep() >> 6;
  simulation_.propagation_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(enabled_probes.size());
  simulation_.glitch_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(enabled_probes.size());
  for (uint64_t idx = 0; idx < enabled_probes.size(); ++idx) {
    simulation_.propagation_values_[idx] = std::make_unique<uint64_t[]>(number_of_steps);
    simulation_.glitch_values_[idx] = std::make_unique<uint64_t[]>(number_of_steps);
  }

  auto FindProbe = [&](const SignalStruct& searched_signal, uint64_t searched_cycle,
    const std::vector<const Probe*>& probes) -> uint64_t {
      Probe ext({&searched_signal}, searched_cycle);
      auto input_it = std::lower_bound(probes.begin(), probes.end(), ext,
        [](const Probe* lhs, const Probe& rhs) { return *lhs < rhs; });
      assert(input_it != probes.end() && "Error in Adversaries::SetEnablers(): Probe not found!");
      return std::distance(probes.begin(), input_it);
  };

  std::vector<uint64_t*> inputs_;
  std::vector<const Probe*>::iterator it;

  for (const Probe* probe : enabled_probes) {
    assert(!extensions_.empty() && "Error in Adversaries::SetEnablers(): No extensions found!");
    assert(std::is_sorted(extensions_.begin(), extensions_.end(),
      [](const Probe* lhs, const Probe* rhs) { return *lhs < *rhs; }) &&
        "Error in Adversaries::SetEnablers(): Extensions are not sorted!");

    const SignalStruct& signal = *probe->GetSignals()[0];
    const CellStruct& cell = circuit_.cells_[signal.Output];
    uint64_t number_of_inputs = cell.type->GetNumberOfInputs();
    uint64_t cycle = probe->GetCycle();

    for (uint64_t idx = 0; idx < number_of_inputs; ++idx) {
      SignalStruct input_signal = circuit_.signals_[cell.Inputs[idx]];

      while ((input_signal.Output != -1) && (!input_signal.Deleted)) {
        const CellStruct& input_cell = circuit_.cells_[input_signal.Output];
        if (input_cell.type->GetType() == cell_t::buffer) {
          input_signal = circuit_.signals_[input_cell.Inputs[0]];
        } else {
          break;
        }
      }

      if (cycle) {
        inputs_.push_back(simulation_.probe_values_[FindProbe(input_signal, cycle - 1, extensions_)].get());
      } else {
        inputs_.push_back(simulation_.constant_zero_[0].get());
      }

      inputs_.push_back(simulation_.probe_values_[FindProbe(input_signal, cycle, extensions_)].get());

      if ((input_signal.Output == -1) || (circuit_.cells_[input_signal.Output].type->GetType() == cell_t::sequential)) {
        inputs_.push_back(simulation_.constant_zero_[0].get());
      } else {
        inputs_.push_back(simulation_.glitch_values_[FindProbe(input_signal, cycle, enabled_probes)].get());
      }
    }

    for (uint64_t idx = 0; idx < cell.type->GetNumberOfOutputs(); ++idx) {
      assert(cell.Outputs[idx] >= 0 && "Error in Adversaries::SetEnabler(): cell.Outputs < 0!");
      if ((uint64_t)cell.Outputs[idx] == signal.id) {
        uint64_t find_idx = FindProbe(signal, cycle, enabled_probes);
        enabler_.emplace_back(&cell.expr_glitch_ext_[idx], &cell.expr_probe_prop_[idx], inputs_,
          simulation_.glitch_values_[find_idx].get(), simulation_.propagation_values_[find_idx].get());
        break;
      }
    }

    inputs_.clear();
  }

  for (uint64_t idx = 0; idx < enabled_probes.size(); ++idx) {
    const_cast<Probe*>(enabled_probes[idx])->SetEnabler(enabler_[idx]);
  }

  BOOST_LOG_TRIVIAL(info) << "Successfully specified " << enabler_.size() << " probe-extension conditions.";
}

void Adversaries::SetFaults() {
  // FIXME: Replace all uses of this function by calling the ComputAllFaults
  // function of the fault manager. I think this makes more sense. For now we
  // make the AddXYZFault function public instead of private. TBD with nico.

  uint64_t number_of_signals = circuit_.signals_.size();
  for (uint64_t clock_cycle : settings_.fault_injection.clock_cycles) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if (index >= (uint64_t)circuit_.NumberOfConstants && index != simulation_.clock_signal_index_) {
        const SignalStruct& signal = circuit_.signals_[index];
        if (circuit_.signals_[index].is_fault_allowed) {
          switch (settings_.fault_injection.type) {
            case FaultType::stuck_at_0:
              fault_manager_.AddStuckAtZeroFault(signal, clock_cycle - 1, 1.0);
              break;
            case FaultType::stuck_at_1:
              fault_manager_.AddStuckAtOneFault(signal, clock_cycle - 1, 1.0);
              break;
            case FaultType::toggle:
              fault_manager_.AddToggleFault(signal, clock_cycle - 1, 1.0);
              break;
            default:
              throw std::runtime_error(
                  "Error while setting the faults. Unsupported fault type!");
              break;
          }
        }
      }
    }
  }
}

void Adversaries::SetProbes() {
  const std::vector<uint64_t>& cycles = settings_.side_channel_analysis.clock_cycles;
  assert(!cycles.empty() && "Error in Adversaries::SetProbes(): No target cycles found!");
  assert(std::is_sorted(cycles.begin(), cycles.end()) &&
         "Error in Adversaries::SetProbes(): The target cycles are not sorted!");
  assert(settings_.GetNumberOfClockCycles() && "Error in Adversaries::SetProbes(): No target cycles found!");
  std::vector<const SignalStruct*> signals;

  for (uint64_t cycle : cycles) {
    for (const SignalStruct& signal : circuit_.signals_) {
      if (signal.id >= (uint64_t)circuit_.NumberOfConstants && signal.id != simulation_.clock_signal_index_) {
        signals = {&signal};
        probes_.emplace_back(signals, cycle - 1);

        if ((settings_.IsRelaxedModel() || settings_.IsTransitionalLeakage()) && (cycle != 1)) {
          probes_.emplace_back(signals, cycle - 2);
        }
      }
    }
  }

  std::sort(probes_.begin(), probes_.end(), [](const Probe& lhs, const Probe& rhs) { return lhs < rhs; });
  probes_.erase(std::unique(probes_.begin(), probes_.end(), [](const Probe& lhs, const Probe& rhs)
    { return lhs == rhs; }), probes_.end());

  assert(!probes_.empty() && "Error in Adversaries::SetProbes(): No probes found!");
  BOOST_LOG_TRIVIAL(info) << "Successfully detected " << probes_.size() << " possible probes in total.";

  // We precompute a map from Probe to Probe* to speed up the extension process.
  // Otherwise, for every extension, we would need to search for the corresponding Probe*
  // in the probes_ vector, which would be very inefficient.
  std::map<Probe, const Probe*> probe_map;
  for (uint64_t idx = 0; idx < probes_.size(); ++idx) {
    probe_map[probes_[idx]] = &probes_[idx];
  }

  auto it = cycles.begin();
  for (Probe& probe : probes_) {
    while (it != cycles.end() && *it < probe.GetCycle() + 1) { ++it; }
    if (it == cycles.end()) { break; }
    if (*it == probe.GetCycle() + 1) {
      probe.Extend(circuit_, probe_map, settings_);
      if (probe.IsPlaced(circuit_)) {
        placed_probes_.push_back(&probe);
      }
    }
  }

  BOOST_LOG_TRIVIAL(info) << "Successfully extended " << placed_probes_.size() << " placable probes in total.";

  std::queue<const Probe*> path;
  std::unordered_set<const Probe*> visited;

  for (const Probe* probe : placed_probes_) {
    if (visited.insert(probe).second) {
      path.push(probe);
      if (settings_.IsRelaxedModel() && probe->DoesExtend(circuit_)) {
        for (const Probe* extension : probe->GetTransitionExtensions()) {
          extensions_.push_back(extension);
        }
      }
    }
  }

  while (!path.empty()) {
    const Probe* probe = path.front();
    if (probe->DoesExtend(circuit_)) {
      for (const Probe* extension : probe->GetGlitchExtensions()) {
        if (visited.insert(extension).second) {
          path.push(extension);
          if (settings_.IsRelaxedModel()) {
            for (const Probe* trans : extension->GetTransitionExtensions()) {
              extensions_.push_back(trans);
            }
          }
        }
      }
    } else {
      for (const Probe* extension : probe->GetTransitionExtensions()) {
        extensions_.push_back(extension);
      }
    }

    path.pop();
  }

  std::sort(extensions_.begin(), extensions_.end(),
    [](const Probe* lhs, const Probe* rhs) { return *lhs < *rhs; });
  extensions_.erase(std::unique(extensions_.begin(), extensions_.end(),
    [](const Probe* lhs, const Probe* rhs) { return *lhs == *rhs; }), extensions_.end());
  BOOST_LOG_TRIVIAL(info) << "Successfully placed " << extensions_.size() << " possible extensions in total.";
}

Adversaries::Adversaries(Library& library, CircuitStruct& circuit,
  Settings& settings, Simulation& simulation, const std::string& topmodule_name)
    : topmodule_name_(topmodule_name), library_(library), circuit_(circuit), settings_(settings),
      simulation_(simulation), fault_manager_(FaultManager(settings.fault_injection, circuit)) {

  SetProbes();

  uint64_t number_of_steps = settings_.GetNumberOfSimulationsPerStep() >> 6;
  simulation_.is_simulation_faulty_ = std::make_unique<uint64_t[]>(number_of_steps);
  for (uint64_t idx = 0; idx < number_of_steps; ++idx) {
    simulation_.is_simulation_faulty_[idx] = 0;
  }

  simulation_.probe_values_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(extensions_.size());
  for (uint64_t idx = 0; idx < extensions_.size(); ++idx) {
    simulation_.probe_values_[idx] = std::make_unique<uint64_t[]>(number_of_steps);
  }

  if (settings_.IsRelaxedModel()) {
    simulation_.constant_zero_ = std::make_unique<std::unique_ptr<uint64_t[]>[]>(1);
    simulation_.constant_zero_[0] = std::make_unique<uint64_t[]>(number_of_steps);

    SetEnablers();
  }

  for (uint64_t idx = 0; idx < extensions_.size(); ++idx) {
    const_cast<Probe*>(extensions_[idx])->SetBitslicedValues({&simulation_.probe_values_[idx]});
  }

  SetFaults();
  PrintProbeReport();
}

void Adversaries::CompactTableUpdate(uint64_t sim_idx, std::vector<uint64_t>& counters) {
  uint64_t sim_idx1 = sim_idx >> 6;
  uint64_t sim_idx2 = 1ULL << (sim_idx & 63);
  std::fill(counters.begin(), counters.end(), 0);

  for (uint64_t idx = 0; idx < unique_probes_.size(); ++idx) {
    if (simulation_.probe_values_[idx][sim_idx1] & sim_idx2) {
      for (uint64_t set_idx : unique_probes_[idx].GetProbingSetIndices()) {
        ++counters[set_idx];
      }
    }
  }

  for (uint64_t idx = 0; idx < probing_sets_.size(); ++idx) {
  #pragma omp atomic
    probing_sets_[idx].contingency_table_.bucket_[counters[idx]].data_[simulation_.selected_groups_[sim_idx]]++;
  }
}

void Adversaries::CompactRelaxedTest(std::vector<double>& group_simulation_ratio) {
  #pragma omp parallel for schedule(guided)
  for (ProbingSet& probing_set : probing_sets_) {
    probing_set.CompactRelaxedTableUpdate(simulation_);
    probing_set.ComputeGTest(settings_.GetNumberOfGroups(),
      simulation_.number_of_processed_simulations, group_simulation_ratio);
  }
}

void Adversaries::CompactRobustTest(std::vector<double>& group_simulation_ratio) {
  uint64_t thread_idx;
  uint64_t number_of_groups = settings_.GetNumberOfGroups();
  uint64_t number_of_probing_sets = probing_sets_.size();
  std::vector<std::vector<uint64_t>> counters(
      settings_.GetNumberOfThreads(),
      std::vector<uint64_t>(number_of_probing_sets,0));

#pragma omp parallel for schedule(guided) private(thread_idx)
  for (uint64_t sim_idx : simulation_.considered_simulation_indices_) {
    thread_idx = omp_get_thread_num();
    CompactTableUpdate(sim_idx, counters[thread_idx]);
  }

#pragma omp parallel for schedule(guided)
  for (ProbingSet& probing_set : probing_sets_) {
    probing_set.ComputeGTest(number_of_groups, simulation_.number_of_processed_simulations,
      group_simulation_ratio);
  }
}

void Adversaries::NormalTest(std::vector<double>& group_simulation_ratio) {
  bool is_relaxed = settings_.IsRelaxedModel();
  bool all_simulations = (simulation_.considered_simulation_indices_.size() ==
    settings_.GetNumberOfSimulationsPerStep());

  std::function<void(ProbingSet&)> TableUpdate;

  if (is_relaxed) {
    TableUpdate = [this](ProbingSet& probing_set) {
      probing_set.NormalRelaxedTableUpdate(settings_, simulation_);
    };
  } else {
    if (all_simulations) {
      TableUpdate = [this](ProbingSet& probing_set) {
        probing_set.NormalRobustTableUpdateWithAllSimulations(settings_, simulation_);
      };
    } else {
      TableUpdate = [this](ProbingSet& probing_set) {
        probing_set.NormalRobustTableUpdate(settings_, simulation_);
      };
    }
  }

  #pragma omp parallel for schedule(guided)
  for (ProbingSet& probing_set : probing_sets_) {
    TableUpdate(probing_set);
    probing_set.ComputeGTest(settings_.GetNumberOfGroups(),
      simulation_.number_of_processed_simulations, group_simulation_ratio);
  }
}

void Adversaries::Test(
    std::vector<double>& group_simulation_ratio, bool is_in_compact_mode) {
  if (is_in_compact_mode) {
    if (settings_.IsRelaxedModel()) {
      CompactRelaxedTest(group_simulation_ratio);
    } else {
      CompactRobustTest(group_simulation_ratio);
    }
  } else {
    NormalTest(group_simulation_ratio);
  }
}

void Adversaries::RemoveProbingSetsWithEnoughTraces(uint64_t number_of_simulations,
  double& maximum_g_value_deleted, std::string& printed_probing_set_deleted) {
  probing_sets_.erase(std::remove_if(probing_sets_.begin(), probing_sets_.end(), [&](auto& elem) {
    if (elem.IsSampleSizeSufficient(number_of_simulations, settings_)) {
      double g_value = elem.GetGValue();
      if (g_value > maximum_g_value_deleted) {
        maximum_g_value_deleted = g_value;
        printed_probing_set_deleted = elem.PrintProbes(settings_);
      }

      elem.Deconstruct();
      return true;
    }

    return false;
  }), probing_sets_.end());
}

void Adversaries::SetConsideredSimulations(std::vector<uint64_t>& number_of_simulations_per_group) {
  uint64_t sim_idx, number_of_batches = settings_.GetNumberOfSimulationsPerStep() >> 6;
  FaultAnalysis type = settings_.fault_injection.analysis;
  assert(type != FaultAnalysis::none && "Error in Adversaries::SetConsideredSimulations(): "
    "Fault analysis type is none!");

  if (type == FaultAnalysis::both) {
    simulation_.number_of_processed_simulations += settings_.GetNumberOfSimulationsPerStep();
    for (sim_idx = 0; sim_idx < settings_.GetNumberOfSimulationsPerStep(); ++sim_idx) {
      simulation_.considered_simulation_indices_.push_back(sim_idx);
      ++number_of_simulations_per_group[simulation_.selected_groups_[sim_idx]];
    }
  } else {
    bool is_faulty = (type == FaultAnalysis::only_faulty_simulations);
    for (uint64_t batch_idx = 0; batch_idx < number_of_batches; ++batch_idx) {
      for (uint64_t bit_idx = 0; bit_idx < 64; ++bit_idx) {
        if (((simulation_.is_simulation_faulty_[batch_idx] >> bit_idx) & 1) == is_faulty) {
          ++simulation_.number_of_processed_simulations;
          sim_idx = (batch_idx << 6) ^ bit_idx;
          simulation_.considered_simulation_indices_.push_back(sim_idx);
          ++number_of_simulations_per_group[simulation_.selected_groups_[sim_idx]];
        }
      }
    }

    if (simulation_.considered_simulation_indices_.empty()) {
      throw std::runtime_error("Error in Adversaries::SetConsideredSimulations(): "
        "No considered simulations found. This indicates a mismatch between the "
        "fault analysis type setting and the available simulations. Ensure that "
        "you aren't configured to consider only fault-free simulations when all "
        "simulations are faulty, or vice versa.");
    }
  }
}

double Adversaries::GetMaximumLeakage() {
  std::vector<bool> bitmask(probing_sets_.size(), true);
  double g_value = 0.0;
  ProbingSet const* probing_set = GetMostLeakingSet(bitmask);
  if (probing_set != nullptr) {
    g_value = probing_set->GetGValue();
  }

  return g_value;
}

void Adversaries::EvalProbingSets(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t fault_idx, uint64_t step_idx) {
  uint64_t number_of_groups = settings_.GetNumberOfGroups();
  std::vector<uint64_t> number_of_simulations_per_group(number_of_groups, 0);
  std::vector<double> group_simulation_ratio(number_of_groups, 0.0);
  double maximum_leakage_deleted = 0.0;
  std::string printed_probing_set_deleted;
  std::string report_path = simulation_.result_folder_name_ + "/report.json";

  uint64_t thread_idx, number_of_threads = settings_.GetNumberOfThreads();
  std::vector<boost::mt19937> thread_rng(number_of_threads);
  GenerateThreadRng(thread_rng, number_of_threads);

  simulation_.number_of_processed_simulations = 0;
  simulation_.number_of_enablers_ = enabler_.size();

  Logger logger(1, 120, 100);
  TableCell time_cell = logger.GetTimeCell(EndClock(start_time), strlen("Elapsed Time"));
  TableCell memory_cell = logger.GetMemoryCell(GetUsedMemory(), strlen("Used Memory"));

  std::string processed_simulations = std::to_string(settings_.GetNumberOfSimulations()) + " / 10000000000";
  std::vector<TableCell> header{
    {"Elapsed Time", time_cell.width_},
    {"Used Memory", memory_cell.width_},
    {"#Simulations", processed_simulations.size()},
    {"Probing Set with Highest Information Leakage", this->GetProbingSetColumnSize()},
    {"-log10(p)", strlen("999.999999")},
    {"Status", strlen("LEAKAGE")}
  };

  logger.PrintHeader(header);

  if (!settings_.IsRelaxedModel() && settings_.IsCompactDistribution()) {
    SetUniqueProbes();
  }

  for (uint64_t idx = 0; idx < settings_.GetNumberOfSimulationSteps(); ++idx) {
    #pragma omp parallel for schedule(guided) private(thread_idx)
    for (uint64_t sim_idx = 0; sim_idx < (settings_.GetNumberOfSimulationsPerStep() >> 6); ++sim_idx) {
      thread_idx = omp_get_thread_num();
      Hardware::Simulate::All(circuit_, settings_, shared_data[thread_idx],
        extensions_, enabler_, simulation_, sim_idx, thread_rng[thread_idx]);
    }

    SetConsideredSimulations(number_of_simulations_per_group);
    std::transform(number_of_simulations_per_group.begin(), number_of_simulations_per_group.end(),
      group_simulation_ratio.begin(), [this](uint64_t x) {
        return static_cast<double>(x) / static_cast<double>(this->simulation_.number_of_processed_simulations);
      }
    );

    Test(group_simulation_ratio, settings_.IsCompactDistribution());
    PrintEvaluationBody(header, maximum_leakage_deleted, printed_probing_set_deleted, start_time);

    if (settings_.GetNumberOfSimulationsPerWrite()) {
      if ((simulation_.number_of_processed_simulations %
           settings_.GetNumberOfSimulationsPerWrite()) == 0) {
        PrintLeakageReport(fault_idx, step_idx);
        logger.PrintHorizontalTableLine(logger.DetermineRowWidth(header));
      }
    }

    if (settings_.IsRemoveFullProbingSets()) {
      RemoveProbingSetsWithEnoughTraces(simulation_.number_of_processed_simulations,
        maximum_leakage_deleted, printed_probing_set_deleted);

      if (probing_sets_.empty()) {
        PrintLeakageReport(fault_idx, step_idx);
        logger.PrintHorizontalTableLine(logger.DetermineRowWidth(header));
        break;
      }
    }

    simulation_.considered_simulation_indices_.clear();
  }
}

double Adversaries::EvalProbingSetsUnderFaults(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t step_idx) {
  uint64_t number_of_faults = fault_manager_.GetNumberOfFaults();
  uint64_t minimum = settings_.fault_injection.minimum_per_run;
  uint64_t maximum = settings_.fault_injection.maximum_per_run;
  uint64_t fault_idx = 0;
  double maximum_leakage = 0.0;

  for (ProbingSet& probing_set : probing_sets_) {
    probing_set.Initialize(settings_.IsCompactDistribution(), settings_.GetNumberOfGroups());
  }

  std::sort(probing_sets_.begin(), probing_sets_.end(), [this](ProbingSet& lhs, ProbingSet& rhs) {
    return lhs.GetSizeOfKeyInBits() < rhs.GetSizeOfKeyInBits();
  });

  if (number_of_faults && minimum) {
    const std::vector<uint64_t>& cycles = settings_.fault_injection.clock_cycles;
    assert(std::is_sorted(cycles.begin(), cycles.end()) && "Error in Adversaries::"
      "EvalProbingSetsUnderFaults(): The clock cycles for fault injection are not sorted!");
    std::vector<uint64_t> number_of_faults_per_cycle(settings_.GetNumberOfClockCycles(), 0);
    std::vector<bool> bitmask(number_of_faults, false);

    for (uint64_t faults_per_run = minimum; faults_per_run <= maximum; ++faults_per_run) {
      std::vector<Fault const*> faults;
      faults.reserve(faults_per_run);

      if (faults_per_run > number_of_faults) {
        std::fill(bitmask.begin(), bitmask.end(), true);
      } else {
        std::fill(bitmask.begin(), bitmask.begin() + faults_per_run, true);
      }

      do {
        for (uint64_t idx = 0; idx < bitmask.size(); ++idx) {
          if (bitmask[idx]) {
            Fault const* fault = fault_manager_.GetFault(idx);
            ++number_of_faults_per_cycle[fault->GetCycle()];
            faults.push_back(fault);
          }
        }

        std::vector<uint64_t> faults_per_target_cycle;
        for (uint64_t cycle : cycles) {
          faults_per_target_cycle.push_back(number_of_faults_per_cycle[cycle - 1]);
        }

        uint64_t minimum_faults = *std::min_element(faults_per_target_cycle.begin(), faults_per_target_cycle.end());
        uint64_t maximum_faults = *std::max_element(faults_per_target_cycle.begin(), faults_per_target_cycle.end());

        if (maximum_faults <= settings_.fault_injection.maximum_per_cycle &&
            minimum_faults >= settings_.fault_injection.minimum_per_cycle) {
          simulation_.fault_set_.emplace_back(faults);
          EvalProbingSets(shared_data, start_time, fault_idx++, step_idx);
          simulation_.fault_set_.pop_back();

          double step_leakage = GetMaximumLeakage();
          if (step_leakage > maximum_leakage) {
            maximum_leakage = step_leakage;
          }

          #pragma omp parallel for schedule(guided)
          for (ProbingSet& probing_set : probing_sets_) {
            probing_set.DeconstructTable();
          }
        }

        std::fill(number_of_faults_per_cycle.begin(), number_of_faults_per_cycle.end(), 0);
        faults.clear();
      } while (std::prev_permutation(bitmask.begin(), bitmask.end()));

      std::fill(bitmask.begin(), bitmask.end(), false);
    }
  } else {
    PrintSummary();
    EvalProbingSets(shared_data, start_time, fault_idx++, step_idx);

    double step_leakage = GetMaximumLeakage();
    if (step_leakage > maximum_leakage) {
      maximum_leakage = step_leakage;
    }
  }

  return maximum_leakage;
}

bool Adversaries::IsInDistance(const std::vector<const Probe*>& probes) const {
  std::vector<uint64_t> cycles;
  cycles.reserve(probes.size());

  for (const Probe* probe : probes) {
    cycles.push_back(probe->GetCycle());
  }

  std::sort(cycles.begin(), cycles.end());
  uint64_t diff = cycles.back() - cycles.front();
  assert((settings_.GetVariate() != Analysis::univariate || diff == 0) &&
    "Error in Adversaries::IsInDistance: Multivariate set in univariate analysis!");
  return (diff <= settings_.GetDistance());
}

double Adversaries::ProcessProbingSets(std::vector<SharedData>& shared_data, timespec& start_time, uint64_t step_idx) {
  if (settings_.GetMinimization() != Minimization::none) {
    uint64_t number_of_probing_sets = probing_sets_.size();
    std::sort(probing_sets_.begin(), probing_sets_.end(),
      [](const ProbingSet& lhs, const ProbingSet& rhs) { return lhs < rhs; });
    probing_sets_.erase(std::unique(probing_sets_.begin(), probing_sets_.end(),
      [](const ProbingSet& lhs, const ProbingSet& rhs) { return lhs == rhs; }), probing_sets_.end());
    BOOST_LOG_TRIVIAL(info) << "Successfully applied trivial minimization. "
      << number_of_probing_sets - probing_sets_.size() << " duplicated probing sets removed.";
  }

  if (settings_.GetMinimization() == Minimization::aggressive) {
    if (!settings_.IsRelaxedModel()) {
      uint64_t number_of_probing_sets = probing_sets_.size();
      std::vector<bool> remove(number_of_probing_sets, false);  

      if (settings_.IsMultivariateEvaluationRequired()) {
        std::sort(probing_sets_.begin(), probing_sets_.end(),
          [](const ProbingSet& lhs, const ProbingSet& rhs) { 
            return lhs.GetExtensions().size() > rhs.GetExtensions().size(); 
          });

        #pragma omp parallel for schedule(dynamic)
        for (uint64_t idx = 0; idx < number_of_probing_sets; ++idx) {
          if (remove[idx]) continue;
          const std::vector<const Probe*>& rhs = probing_sets_[idx].GetExtensions();

          // Only compare against larger probing sets to save time
          for (uint64_t jdx = 0; jdx < idx; ++jdx) { 
            if (remove[jdx]) continue;
            const std::vector<const Probe*>& lhs = probing_sets_[jdx].GetExtensions();
            if (std::includes(lhs.begin(), lhs.end(), rhs.begin(), rhs.end())) {
              remove[idx] = true;
              break;
            }
          }
        }
      } else {
        // In the univariate case, we further improve efficiency by 
        // comparing only sets with probes place in the same clock cycle
        std::sort(probing_sets_.begin(), probing_sets_.end(),
          [](const ProbingSet& lhs, const ProbingSet& rhs) { 
            const std::vector<const Probe*>& lhs_ext = lhs.GetExtensions();
            const std::vector<const Probe*>& rhs_ext = rhs.GetExtensions();

            assert(!lhs_ext.empty() && "Error in Adversaries::ProcessProbingSets(): "
              "lhs_ext is an empty set of extensions.");
            assert(!rhs_ext.empty() && "Error in Adversaries::ProcessProbingSets(): "
              "rhs_ext is an empty set of extensions."); 
            
            // Compare with the cycle of the first extension since then probing sets
            // on the first cycle (without transition) are in the same cycle group 
            // as probing sets in the first cycle with transition to cycle zero
            uint64_t lhs_cycle = lhs_ext.front()->GetCycle();
            uint64_t rhs_cycle = rhs_ext.front()->GetCycle();  
              
            if (lhs_cycle != rhs_cycle) {
              return lhs_cycle < rhs_cycle;
            }

            return lhs_ext.size() > rhs_ext.size(); 
          }
        );

        std::vector<std::pair<uint64_t, uint64_t>> cycle_groups;
        uint64_t start = 0;
        while (start < probing_sets_.size()) {
          uint64_t cycle = probing_sets_[start].GetExtensions().front()->GetCycle();
          uint64_t end = start + 1;
          while (end < probing_sets_.size() && 
            probing_sets_[end].GetExtensions().front()->GetCycle() == cycle) { ++end; }
          cycle_groups.emplace_back(start, end);
          start = end;
        }

        for (auto [begin, end] : cycle_groups) {
          // We convert the extension set for every probing set into a bitmask
          // in order to avoid std::include which increases performance
          std::unordered_set<const Probe*> visited;
          for (uint64_t idx = begin; idx < end; ++idx) {
            for (const Probe* probe : probing_sets_[idx].GetExtensions()) {
              visited.insert(probe);
            }
          }

          std::map<const Probe*, uint64_t> bitmask_map;
          uint64_t ctr = 0;
          for (const Probe* probe : visited) {
            bitmask_map[probe] = ctr++;
          }

          uint64_t bitmask_words = (ctr + 63) / 64;  
          std::vector<std::vector<uint64_t>> bitmasks(end - begin, 
            std::vector<uint64_t>(bitmask_words,0ULL));

          #pragma omp parallel for schedule(static)
          for (uint64_t idx = begin; idx < end; ++idx) {
            auto& bitmask = bitmasks[idx - begin];
            const auto& extensions = probing_sets_[idx].GetExtensions();

            for (const Probe* probe : extensions) {
              uint64_t bit = bitmask_map.at(probe);
              uint64_t word = bit >> 6;      
              uint64_t offset = bit & 63;   
              bitmask[word] |= (1ULL << offset);
            }
          }

          #pragma omp parallel for schedule(dynamic)
          for (uint64_t idx = begin; idx < end; ++idx) {
            if (remove[idx]) { continue; }
            const auto& rhs_mask = bitmasks[idx - begin];

            // Only compare against earlier sets with the same cycle
            for (uint64_t jdx = begin; jdx < idx; ++jdx) {
              if (remove[jdx]) { continue; }
              const auto& lhs_mask = bitmasks[jdx - begin];
              bool is_subset = true;
              for (uint64_t word_idx = 0; word_idx < bitmask_words; ++word_idx) {
                if ((lhs_mask[word_idx] & rhs_mask[word_idx]) != rhs_mask[word_idx]) {
                  is_subset = false;
                  break;
                }
              }

              if (is_subset) {
                remove[idx] = true;
                break;
              }
            }
          }
        }
      }
    
      uint64_t ctr = 0;
      for (uint64_t idx = 0; idx < number_of_probing_sets; ++idx) {
        if (!remove[idx]) {
          std::swap(probing_sets_[ctr++], probing_sets_[idx]);
        }
      }

      probing_sets_.erase(probing_sets_.begin() + ctr, probing_sets_.end());
      std::sort(probing_sets_.begin(), probing_sets_.end(),
        [](const ProbingSet& lhs, const ProbingSet& rhs) { return lhs < rhs; });

      BOOST_LOG_TRIVIAL(info) << "Successfully applied aggressive minimization. "
        << number_of_probing_sets - probing_sets_.size() << " covered probing sets removed.";
    } else {
      BOOST_LOG_TRIVIAL(warning) << "\033[38;5;13mwarning:\033[0m Aggressive minimization isn't supported "
        "in the robust but relaxed probing model and will be ignored!";
    }
  }

  double maximum_leakage = EvalProbingSetsUnderFaults(shared_data, start_time, step_idx++);

  #pragma omp parallel for schedule(guided)
  for (ProbingSet& probing_set : probing_sets_) {
    probing_set.Deconstruct();
  }

  probing_sets_.clear();
  return maximum_leakage;
}

double Adversaries::PrepareProbingSets(std::vector<SharedData>& shared_data, 
  timespec& start_time, uint64_t n, uint64_t number_of_sets_per_step, uint64_t number_of_cycles) {

  uint64_t number_of_probes_per_set = std::min(n, settings_.GetTestOrder());
  std::vector<const Probe*> probes(number_of_probes_per_set);
  probing_sets_.reserve(number_of_probes_per_set);

  // We made the probing sets based on a set of probe indices in probes_. 
  // This turned out to be more efficient than using bitmasks and std::prev_permutation(). 
  std::vector<uint64_t> probe_indices(number_of_probes_per_set);

  // The only drawback is that we need a custom implementation of the previous 
  // permutation algorithm that works on a vector of indices instead of a bitmask.
  auto next_combination = [k = number_of_probes_per_set](std::vector<uint64_t>& indices, uint64_t n) {
    for (int idx = static_cast<int>(k) - 1; idx >= 0; --idx) {
      if (indices[idx] < n - (k - idx)) {
        ++indices[idx];
        for (uint64_t jdx = idx + 1; jdx < k; ++jdx) {
          indices[jdx] = indices[jdx - 1] + 1;
        }
        return true;
      }
    }
    return false;
  };

  uint64_t step_idx = 0;
  double leakage_per_step, maximum_leakage = 0.0;

  // The distance check is only required in multivate analyses
  // so we avoid it in the univariate cases to increase performance
  if (settings_.GetVariate() == Analysis::univariate) {
    for (uint64_t idx = 0; idx < number_of_cycles; ++idx) {
      std::iota(probe_indices.begin(), probe_indices.end(), idx * n);

      // It's important to process probing sets on the fly to avoid
      // memory overflow when the number of probing sets is high.
      do{
        for (uint64_t probe_idx = 0; probe_idx < probe_indices.size(); ++probe_idx) {
          probes[probe_idx] = placed_probes_[probe_indices[probe_idx]];
        }

        probing_sets_.emplace_back(circuit_, settings_, probes);

        if (__builtin_expect(probing_sets_.size() == number_of_sets_per_step, 0)) {
          BOOST_LOG_TRIVIAL(info) << "Successfully set a batch of " << probing_sets_.size() << " probing sets.";
          leakage_per_step = ProcessProbingSets(shared_data, start_time, step_idx++);
          maximum_leakage = std::max(maximum_leakage, leakage_per_step);
        }
      } while (next_combination(probe_indices, (idx + 1) * n));
    }
  } else {
    std::iota(probe_indices.begin(), probe_indices.end(), 0);
    
    // It's important to process probing sets on the fly to avoid
    // memory overflow when the number of probing sets is high.
    do{
      for (uint64_t probe_idx = 0; probe_idx < probe_indices.size(); ++probe_idx) {
        probes[probe_idx] = placed_probes_[probe_indices[probe_idx]];
      }

      if (IsInDistance(probes)) {
        probing_sets_.emplace_back(circuit_, settings_, probes);
      }

      if (__builtin_expect(probing_sets_.size() == number_of_sets_per_step, 0)) {
        BOOST_LOG_TRIVIAL(info) << "Successfully set a batch of " << probing_sets_.size() << " probing sets.";
        leakage_per_step = ProcessProbingSets(shared_data, start_time, step_idx++);
        maximum_leakage = std::max(maximum_leakage, leakage_per_step);
      }
    } while (next_combination(probe_indices, n));
  }

  if (!probing_sets_.empty()) {
    BOOST_LOG_TRIVIAL(info) << "Successfully set a batch of " << probing_sets_.size() << " probing sets.";
    leakage_per_step = ProcessProbingSets(shared_data, start_time, step_idx++);
    maximum_leakage = std::max(maximum_leakage, leakage_per_step);
  }

  return maximum_leakage;
};

double Adversaries::Eval(std::vector<SharedData>& shared_data) {
  struct timespec start_time;
  StartClock(start_time);
  uint64_t number_of_cycles = settings_.side_channel_analysis.clock_cycles.size();
  uint64_t n, k, binom;
  uint64_t number_of_threads = settings_.GetNumberOfThreads();
  omp_set_num_threads(number_of_threads);

  if (settings_.IsMultivariateEvaluationRequired()) {
    n = placed_probes_.size();
    k = std::min(n, settings_.GetTestOrder());
    binom = boost::math::binomial_coefficient<double>(n, k);
    uint64_t number_of_sets_per_step = std::min(binom, settings_.GetNumberOfProbingSetsPerStep());
    BOOST_LOG_TRIVIAL(info) << "Successfully initialized a multivariate"
    " evaluation with " << binom << " probing sets.";
    return PrepareProbingSets(shared_data, start_time, n, number_of_sets_per_step, 1);
  } else {
    n = placed_probes_.size() / number_of_cycles;
    k = std::min(n, settings_.GetTestOrder());
    binom = boost::math::binomial_coefficient<double>(n, k);
    uint64_t number_of_sets_per_step = std::min(number_of_cycles * binom, settings_.GetNumberOfProbingSetsPerStep());
    BOOST_LOG_TRIVIAL(info) << "Successfully initialized a univariate"
    " evaluation with " << number_of_cycles * binom << " probing sets.";
    return PrepareProbingSets(shared_data, start_time, n, number_of_sets_per_step, number_of_cycles);
  }
}
}  // namespace Hardware
