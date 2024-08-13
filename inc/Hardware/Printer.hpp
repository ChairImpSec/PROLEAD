#pragma once

#include <string>

#include "Hardware/ProbingSets.hpp"

namespace Hardware {

/*
The Printer class takes care of printing all necessary information to the
console or into files.
*/
template <typename ExtensionContainer>
class Printer {
 public:
  Printer();

  void SetColumnSize(std::vector<ProbingSet<ExtensionContainer>>& probing_sets, const CircuitStruct& circuit);

  void SetPath(std::string path);                   
  std::string PrintProbes(std::vector<Probe>& probes, const CircuitStruct& circuit);
  std::string PrintProbes(std::vector<Probe*>& probes, const CircuitStruct& circuit);

  std::string PrintProbingSet(
      ProbingSet<ExtensionContainer>& probing_set,
      std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
      const CircuitStruct& circuit);
  void PrintProbingSetInformation(
      std::vector<Propagation<ExtensionContainer>>& propagations,
      std::vector<Probe>& standard_probes, std::vector<Probe>& probe_extensions,
      std::vector<ProbingSet<ExtensionContainer>>& probing_sets);
  void PrintEvaluationHeader();
  void PrintEvaluationBody(
      std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
      const CircuitStruct& circuit, const Settings& settings,
      Simulation& simulation, double& maximum_g_value_deleted,
      std::string& printed_probing_set_deleted, double elapsed_time_period);
  void PrintReport(std::vector<Propagation<ExtensionContainer>>& propagations,
                   std::vector<Probe>& probe_extensions,
                   std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
                   const CircuitStruct& circuit, const Settings& settings,
                   Simulation& simulation, unsigned int probe_step_index);
void PrintError(std::string error_message);

 private:
  unsigned int column_size_;
  std::string path_;
  const std::string report_prefix_ = "report_";

  const std::string standard_error_text =
      "We apologize for any inconvenience caused by the bug you encountered in "
      "PROLEAD. Our team is committed to resolving this issue promptly to "
      "enhance your experience. Please reach out to me directly at "
      "nicolai.mueller@rub.de so that we can assist you in fixing the problem. "
      "Thank you for bringing this to our attention.\n";

  std::string PrintProbe(Probe& probe, const CircuitStruct& circuit);
  std::string PrintRelaxedExtension(
      ExtensionContainer& probe, std::vector<Probe>& probe_extensions,
      std::vector<Propagation<ExtensionContainer>>& propagations,
      const CircuitStruct& circuit);
  std::string PrintExtensions(
      ProbingSet<ExtensionContainer>& probing_set,
      std::vector<Propagation<ExtensionContainer>>& propagations,
      std::vector<Probe>& probe_extensions, const CircuitStruct& circuit);
  void PrintMostLeakingSetsPerCycle(
      std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
      std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
      const CircuitStruct& circuit, const Settings& settings, std::ofstream& stream);
  void PrintMostLeakingSets(
      std::vector<Propagation<ExtensionContainer>>& propagations, std::vector<Probe>& probe_extensions,
      std::vector<ProbingSet<ExtensionContainer>>& probing_sets,
      const CircuitStruct& circuit, const Settings& settings, std::ofstream& stream);
};
}  // namespace Hardware