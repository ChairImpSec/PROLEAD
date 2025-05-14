#include "Hardware/Execute.hpp"

void Hardware::Execute(const po::variables_map& vm) {
  std::string result_folder_name = vm["resultfolder"].as<std::string>();
  boost::json::object library_file = vm["libraryfile"].as<boost::json::object>();
  std::vector<std::string> design_file_names =
      vm["designfile"].as<std::vector<std::string>>();
  boost::json::object config_file = vm["configfile"].as<boost::json::object>();
  std::string topmodule_name = vm["modulename"].as<std::string>();
  std::string library_name = vm["libraryname"].as<std::string>();

  std::string design_file_name;
  if (design_file_names.size() == 1) {
    design_file_name = design_file_names[0];
  } else {
    throw std::runtime_error(
        "Error while parsing the command line parameters: Only a single design "
        "file should be provided!");
  }

  Settings settings(config_file, true);
  Library library(library_file, library_name);
  CircuitStruct circuit(design_file_name, topmodule_name, settings, library);

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
