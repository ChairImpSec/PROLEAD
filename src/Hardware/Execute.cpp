#include "Hardware/Execute.hpp"

void Hardware::Execute(const po::variables_map& vm) {
  Hardware::CircuitStruct circuit;

  std::string result_folder_name = vm["resultfolder"].as<std::string>();
  std::string library_file_name = vm["libraryfile"].as<std::string>();
  std::string design_file_name = vm["designfile"].as<std::string>();
  std::string config_file_name = vm["configfile"].as<std::string>();
  std::string topmodule_name = vm["modulename"].as<std::string>();
  std::string library_name = vm["libraryname"].as<std::string>();

  Settings settings(config_file_name, true);
  Library library(library_file_name, library_name, settings.IsRelaxedModel());
  Hardware::Read::DesignFile(design_file_name, topmodule_name, settings,
                             library, &circuit, 0, 0, 0, NULL);

  circuit.SetIsProbeAllowed(library, settings);
  circuit.SetIsExtensionAllowed(library, settings);
  circuit.SetIsAnalysisAllowed(settings);
  circuit.SetIsFaultAllowed(settings);
  std::cout << "done" << std::endl;

  Hardware::Prepare::MakeCircuitDepth(library, &circuit);

  std::vector<SharedData> shared_data(settings.GetNumberOfThreads(),
                                      SharedData(circuit, settings));
  Simulation simulation(circuit, settings);
  simulation.topmodule_name_ = topmodule_name;
  simulation.result_folder_name_ = result_folder_name;

  if (settings.IsRelaxedModel()) {
    std::cout
        << "Evaluate the circuit under the robust but relaxed probing model!"
        << std::endl;
    Hardware::Adversaries<RelaxedProbe> adversary(library, circuit, settings,
                                                  simulation);
    adversary.EvaluateRobustProbingSecurity(shared_data);
  } else {
    std::cout << "Evaluate the circuit under the robust probing model!"
              << std::endl;
    Hardware::Adversaries<RobustProbe> adversary(library, circuit, settings,
                                                 simulation);
    adversary.EvaluateRobustProbingSecurity(shared_data);
  }
}
