#include "Hardware/Printer.hpp"

namespace Hardware {

template <class ExtensionContainer>
void Printer<ExtensionContainer>::SetColumnSize(
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets, const CircuitStruct& circuit) {
  std::string text = "  Probing Set with highest Information Leakage ";
  column_size_ = text.length();
  std::vector<Probe> probes;

  for (ProbingSet<ExtensionContainer>& probing_set : probing_sets) {
    for (Probe* probe : probing_set.GetProbeAddresses()) {
      probes.push_back(*probe);
    }

    text = PrintProbes(probes, circuit) + " |";

    if (text.length() > column_size_) {
      column_size_ = text.length();
    }

    probes.clear();
  }
}

template void Printer<RobustProbe>::SetColumnSize(
    std::vector<ProbingSet<RobustProbe>>&, const CircuitStruct&);
template void Printer<RelaxedProbe>::SetColumnSize(
    std::vector<ProbingSet<RelaxedProbe>>&, const CircuitStruct&);

template <class ExtensionContainer>
void Printer<ExtensionContainer>::SetPath(std::string path) {
  path_ = path;
}

template void Printer<RobustProbe>::SetPath(std::string);
template void Printer<RelaxedProbe>::SetPath(std::string);

template <class ExtensionContainer>
std::string Printer<ExtensionContainer>::PrintProbe(Probe& probe,
                                                    const CircuitStruct& circuit) {
  unsigned int signal_index = probe.GetSignalIndex();
  std::string signal_name, clock_cycle, error_message;

  try {
    signal_name = circuit.Signals[signal_index]->Name;
  } catch (const std::out_of_range& e) {
    error_message = "Tried to print a probe with an invalid signal index!\n" +
                    standard_error_text;
    throw std::out_of_range(error_message);
  }

  clock_cycle = std::to_string(probe.GetCycle());
  return signal_name + "(" + clock_cycle + ")";
}

template <class ExtensionContainer>
std::string Printer<ExtensionContainer>::PrintProbes(std::vector<Probe>& probes,
                                                     const CircuitStruct& circuit) {
  std::string result;

  for (Probe& probe : probes) {
    result += PrintProbe(probe, circuit) + ", ";
  }

  try {
    result.pop_back();
    result.pop_back();
  } catch (const std::out_of_range& e) {
    std::string error_message =
        "Tried to print an empty list of probes!\n" + standard_error_text;
    throw std::out_of_range(error_message);
  }

  return "[" + result + "]";
}

template <class ExtensionContainer>
std::string Printer<ExtensionContainer>::PrintProbes(std::vector<Probe*>& probes,
                                                     const CircuitStruct& circuit) {
  std::string result;

  for (Probe* probe : probes) {
    result += PrintProbe(*probe, circuit) + ", ";
  }

  try {
    result.pop_back();
    result.pop_back();
  } catch (const std::out_of_range& e) {
    std::string error_message =
        "Tried to print an empty list of probes!\n" + standard_error_text;
    throw std::out_of_range(error_message);
  }

  return "[" + result + "]";
}

template std::string Printer<RobustProbe>::PrintProbes(std::vector<Probe*>&, const CircuitStruct&);
template std::string Printer<RelaxedProbe>::PrintProbes(std::vector<Probe*>&, const CircuitStruct&);


template <>
std::string Printer<RelaxedProbe>::PrintRelaxedExtension(
    RelaxedProbe& probe, std::vector<Probe>& probe_extensions,
    std::vector<Propagation<RelaxedProbe>>& propagations,
    const CircuitStruct& circuit) {
  std::string result, probes;
  RelaxedProbe* new_probe;

  if (!probe.propagation_indices_.empty()) {
    result = "(if f_" + std::to_string(probe.enable_index_) + " = 1: ";

    for (unsigned int index : probe.propagation_indices_) {
      new_probe = propagations[index].GetProbeAddress(0);
      result += PrintRelaxedExtension(*new_probe, probe_extensions, propagations,
                                      circuit);
    }
  }

  for (unsigned int index : probe.signal_indices_) {
    probes += PrintProbe(probe_extensions[index], circuit) + ", ";
  }

  if (!probe.propagation_indices_.empty()) {
    result += " else: " + probes + "), ";
  } else {
    result = probes;
  }

  size_t pos = result.find(",  else");
  if (pos != std::string::npos){
    result.replace(pos, 7, " else");
  }

  pos = result.find(", )");
  if (pos != std::string::npos){
    result.replace(pos, 3, ")");
  }

  return result;
}

template <>
std::string Printer<RobustProbe>::PrintExtensions(
    ProbingSet<RobustProbe>& probing_set,
    std::vector<Propagation<RobustProbe>>&,
    std::vector<Probe>& probe_extensions, const CircuitStruct& circuit) {
  std::vector<Probe> probes;

  for (unsigned int index : probing_set.GetProbeExtensions()) {
    probes.push_back(probe_extensions[index]);
  }

  return PrintProbes(probes, circuit);
}

template <>
std::string Printer<RelaxedProbe>::PrintExtensions(
    ProbingSet<RelaxedProbe>& probing_set,
    std::vector<Propagation<RelaxedProbe>>& propagations,
    std::vector<Probe>& probe_extensions, const CircuitStruct& circuit) {
  std::vector<RelaxedProbe> probe_extensions_of_set;
  std::string result;

  for (unsigned int index : probing_set.GetProbeExtensions()) {
    probe_extensions_of_set.push_back(
        *propagations[index].GetProbeAddress(0));
  }

  for (RelaxedProbe probe : probe_extensions_of_set) {
    result +=
        PrintRelaxedExtension(probe, probe_extensions, propagations, circuit) +
        ", ";
  }

  try {
    result.pop_back();
    result.pop_back();
    result.pop_back();
    result.pop_back();
  } catch (const std::out_of_range& e) {
    std::string error_message =
        "Tried to print an empty probing set!\n" + standard_error_text;
    throw std::out_of_range(error_message);
  }

  return "[" + result + "]";
}

template <class ExtensionContainer>
std::string Printer<ExtensionContainer>::PrintProbingSet(
    ProbingSet<ExtensionContainer>& probing_set,
    std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
    const CircuitStruct& circuit) {
  std::vector<Probe> standard_probes_per_set;

  for (Probe* probe : probing_set.GetProbeAddresses()) {
    standard_probes_per_set.push_back(*probe);
  }

  return "@" + PrintProbes(standard_probes_per_set, circuit) + " ==> " + PrintExtensions(probing_set, propagations, probe_extensions, circuit);
}

template std::string Printer<RobustProbe>::PrintProbingSet(ProbingSet<RobustProbe>&, std::vector<Propagation<RobustProbe>>&, std::vector<Probe>&, const CircuitStruct&);
template std::string Printer<RelaxedProbe>::PrintProbingSet(ProbingSet<RelaxedProbe>&, std::vector<Propagation<RelaxedProbe>>&, std::vector<Probe>&, const CircuitStruct&);

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintEvaluationHeader() {
  std::vector<unsigned int> column_sizes = {20, 20, 25, column_size_, 13, 10};
  unsigned int table_size = column_size_ + 89;
  std::vector<std::string> table_header = {
      "Elapsed Time",
      "Required Ram",
      "Processed Simulations",
      "Probing Set with highest Information Leakage",
      "-log10(p)",
      "Status"};

  Util::PrintHorizontalLine(table_size);
  std::cout.setf(std::ios::right, std::ios::adjustfield);
  Util::PrintRow(column_sizes, table_header);
  Util::PrintHorizontalLine(table_size);
}

template void Printer<RobustProbe>::PrintEvaluationHeader();
template void Printer<RelaxedProbe>::PrintEvaluationHeader();

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintEvaluationBody(
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    const CircuitStruct& circuit, const Settings& settings,
    Simulation& simulation, double& maximum_g_value_deleted,
    std::string& printed_probing_set_deleted, double elapsed_time_period) {
  std::vector<unsigned int> table_widths = {20, 20, 25, column_size_, 13, 10};
  std::vector<std::string> table_body(6);
  std::vector<bool> bitmask(probing_sets.size(), true);
  unsigned int maximum_index =
      GetIndexOfMostLeakingProbingSet(probing_sets, bitmask);
  uint64_t number_of_traces = GetNumberOfRequiredTraces(probing_sets, settings);
  double maximum_g_value = probing_sets[maximum_index].GetGValue();
  double printed_g_value = std::max(maximum_g_value, maximum_g_value_deleted);
  std::vector<Probe> probes;
  table_body[0] = std::to_string(elapsed_time_period) + "s";
  table_body[1] = std::to_string(Util::PrintMemoryConsumption() / 1e6) + "GB";

  if (settings.IsCompactDistribution()) {
    table_body[2] = std::to_string(simulation.number_of_processed_simulations);
  } else {
    table_body[2] = std::to_string(simulation.number_of_processed_simulations) +
                    " / " + std::to_string(number_of_traces);
  }

  if (maximum_g_value > maximum_g_value_deleted) {
    for (Probe* probe : probing_sets[maximum_index].GetProbeAddresses()) {
      probes.push_back(*probe);
    }

    table_body[3] = PrintProbes(probes, circuit);
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

template void Printer<RobustProbe>::PrintEvaluationBody(std::vector<ProbingSet<RobustProbe>>&,
    const CircuitStruct&, const Settings&, Simulation&, double&, std::string&,
    double);
template void Printer<RelaxedProbe>::PrintEvaluationBody(std::vector<ProbingSet<RelaxedProbe>>&,
    const CircuitStruct&, const Settings&, Simulation&, double&, std::string&,
    double);

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintMostLeakingSetsPerCycle(
    std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    const CircuitStruct& circuit, const Settings& settings, std::ofstream& stream) {
  unsigned int set_index;
  double p_value = 0.0;
  std::vector<double> p_values(settings.GetNumberOfClockCycles(), 0.0);
  std::vector<unsigned int> set_indices(settings.GetNumberOfClockCycles(), 0);
  std::vector<bool> set_available(settings.GetNumberOfClockCycles(), false);

  stream << "1.) Summary of most leaking (and still active) probing sets per "
            "clock cycle: "
         << std::endl
         << std::endl;

  for (size_t index = 0; index < probing_sets.size(); ++index) {
    uint64_t clock_cycle = probing_sets[index].GetHighestClockCycle(propagations,
                                                           probe_extensions);
    p_value = probing_sets[index].GetGValue();

    if (p_value >= p_values[clock_cycle]) {
      set_indices[clock_cycle] = index;
      set_available[clock_cycle] = true;
      p_values[clock_cycle] = p_value;
    }
  }

  for (uint64_t clock_cycle : settings.side_channel_analysis.clock_cycles) {
    --clock_cycle;
    if (set_available[clock_cycle]) {
      set_index = set_indices[clock_cycle];
      stream << "Clock cycle " << clock_cycle + 1 << ": "
             << PrintProbingSet(probing_sets[set_index], propagations, probe_extensions, circuit)
             << " -log10(p) = " << p_values[clock_cycle];

      if (p_values[clock_cycle] > settings.side_channel_analysis.alpha_threshold) {
        stream << " --> LEAKAGE" << std::endl;
      } else {
        stream << " --> OKAY" << std::endl;
      }
    }
  }

  stream << std::endl;
}

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintMostLeakingSets(
    std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    const CircuitStruct& circuit, const Settings& settings, std::ofstream& stream) {
  stream << "2.) Summary of the most leaking (and still active) probing sets: "
         << std::endl
         << std::endl;
  size_t index, set_index;
  size_t number_of_probing_sets = probing_sets.size();
  size_t bound = std::min(number_of_probing_sets, settings.GetNumberOfEntriesInReport());
  std::vector<bool> set_unconsidered(number_of_probing_sets, true);
  double p_value;

  for (index = 0; index < bound; ++index) {
    set_index = GetIndexOfMostLeakingProbingSet(probing_sets, set_unconsidered);
    set_unconsidered[set_index] = false;
    p_value = probing_sets[set_index].GetGValue();
    stream << index + 1 << ": "
           << PrintProbingSet(probing_sets[set_index], propagations, probe_extensions, circuit)
           << " -log10(p) = " << p_value;

    if (p_value > settings.side_channel_analysis.alpha_threshold) {
      stream << " --> LEAKAGE" << std::endl;
    } else {
      stream << " --> OKAY" << std::endl;
    }

    if (p_value == 0.0) {
      break;
    }
  }
}

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintReport(
    std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
    const CircuitStruct& circuit, const Settings& settings,
    Simulation& simulation, unsigned int probe_step_index) {
  std::string file_name;
  unsigned int number_of_simulations = simulation.number_of_processed_simulations;

  if (settings.GetNumberOfProbingSetsPerStep() == UINT_MAX) {
    file_name = path_ + "/" + report_prefix_ +
                std::to_string(number_of_simulations) + ".dat";
  } else {
    file_name = path_ + "/" + report_prefix_ +
                std::to_string(number_of_simulations) + "_Step_" +
                std::to_string(probe_step_index) + ".dat";
  }

  std::ofstream stream(file_name);
  stream << "Report file after " << number_of_simulations
         << " simulations:" << std::endl
         << std::endl;

  PrintMostLeakingSetsPerCycle(propagations, probe_extensions, probing_sets, circuit, settings, stream);

  PrintMostLeakingSets(propagations, probe_extensions, probing_sets, circuit, settings, stream);

  stream.close();
  Util::PrintHorizontalLine(column_size_ + 89);
}

template void Printer<RobustProbe>::PrintReport(
    std::vector<Propagation<RobustProbe>>&, std::vector<Probe>&, std::vector<ProbingSet<RobustProbe>>&,
    const CircuitStruct&, const Settings&, Simulation&, unsigned int);
template void Printer<RelaxedProbe>::PrintReport(
    std::vector<Propagation<RelaxedProbe>>&, std::vector<Probe>&, std::vector<ProbingSet<RelaxedProbe>>&,
    const CircuitStruct&, const Settings&, Simulation&, unsigned int);

template <class ExtensionContainer>
Printer<ExtensionContainer>::Printer() {}

template Printer<RobustProbe>::Printer();
template Printer<RelaxedProbe>::Printer();

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintProbingSetInformation(
    std::vector<Propagation<ExtensionContainer>>& propagations,
    std::vector<Probe>& standard_probes, std::vector<Probe>& probe_extensions,
    std::vector<ProbingSet<ExtensionContainer>>& probing_sets) {
  std::vector<std::string> table_body(6);
  std::vector<std::string> table_header = {
      "#Standard Probes",        "#Extended Probes",
      "#Probing Sets",           "Minimum #Probes per Set",
      "Maximum #Probes per Set", "Average #Probes per Set"};
  std::vector<unsigned int> table_widths = {19, 19, 16, 26, 26, 26};

  size_t full_table_width = 133;

  size_t minimum_number_of_probes_in_a_set =
      std::min_element(probing_sets.begin(), probing_sets.end(),
                       [&propagations](ProbingSet<ExtensionContainer>& lhs,
                                       ProbingSet<ExtensionContainer>& rhs) {
                         return lhs.GetNumberOfProbeExtensions(propagations) <
                                rhs.GetNumberOfProbeExtensions(propagations);
                       })
          ->GetNumberOfProbeExtensions(propagations);

  size_t maximum_number_of_probes_in_a_set =
      std::max_element(probing_sets.begin(), probing_sets.end(),
                       [&propagations](ProbingSet<ExtensionContainer>& lhs,
                                       ProbingSet<ExtensionContainer>& rhs) {
                         return lhs.GetNumberOfProbeExtensions(propagations) <
                                rhs.GetNumberOfProbeExtensions(propagations);
                       })
          ->GetNumberOfProbeExtensions(propagations);

  double average_number_of_probes_in_a_set = 0;
  double diff;

  for (size_t index = 0; index < probing_sets.size(); ++index) {
    diff = probing_sets[index].GetNumberOfProbeExtensions(propagations) -
           average_number_of_probes_in_a_set;
    average_number_of_probes_in_a_set += diff / (index + 1);
  }

  table_body[0] = std::to_string(standard_probes.size());
  table_body[1] = std::to_string(probe_extensions.size());
  table_body[2] = std::to_string(probing_sets.size());
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

template void Printer<RobustProbe>::PrintProbingSetInformation(
    std::vector<Propagation<RobustProbe>>&, std::vector<Probe>&,
    std::vector<Probe>&, std::vector<ProbingSet<RobustProbe>>&);
template void Printer<RelaxedProbe>::PrintProbingSetInformation(
    std::vector<Propagation<RelaxedProbe>>&, std::vector<Probe>&,
    std::vector<Probe>&, std::vector<ProbingSet<RelaxedProbe>>&);

template <class ExtensionContainer>
void Printer<ExtensionContainer>::PrintError(std::string error_message){
  throw std::logic_error(error_message + "\n" + standard_error_text);
}

template void Printer<RobustProbe>::PrintError(std::string);
template void Printer<RelaxedProbe>::PrintError(std::string);

}  // namespace Hardware
