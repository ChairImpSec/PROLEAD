#include "Hardware/Execute.hpp"

void Hardware::Execute(const po::variables_map& vm) {
  std::string result_folder_name = vm["resultfolder"].as<std::string>();
  std::string library_file_name = vm["libraryfile"].as<std::string>();
  std::vector<std::string> design_file_names =
      vm["designfile"].as<std::vector<std::string>>();
  std::string config_file_name = vm["configfile"].as<std::string>();
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

  boost::json::object library_file = ValidateJson(library_file_name);
  boost::json::object config_file = ValidateJson(config_file_name);
  Settings settings(config_file, true);
  Library library(library_file, library_name);
  CircuitStruct circuit(design_file_name, topmodule_name, settings, library);

  std::vector<SharedData> shared_data(settings.GetNumberOfThreads(),
                                      SharedData(circuit, settings));
  Simulation simulation(circuit, settings);
  simulation.topmodule_name_ = topmodule_name;
  simulation.result_folder_name_ = result_folder_name;



  if (settings.analysis_strategy == analysis_t::fia) {
    double max_upper = 0.0;
    double max_lower = 0.0;
    uint64_t max_index = 0;

    // TODO: integrate gdsscanner
    if(vm.count("layoutfile") != 0){
      const std::string path{vm["layoutfile"].as<std::string>()};
      const std::vector<std::string> ignore_gate_types{"physical", "combinatorial", "buffer", "clk_buffer"};

      const Coordinate init_center_probe{0,0};           // Start with half overlap
      const size_t max_size_combination{100};            // Limit the number of simultanous faulted gates


      GDSScanner scanner{
        path,
        topmodule_name,
        ignore_gate_types,
        settings.fault_injection,
        init_center_probe, // NOTE: Where to start with the evaluation. Note that a current limitation
                           // is that we can only move to higher corrdinates from this start point on.
        max_size_combination
      };
    }


    for (uint64_t adv_idx = 0; adv_idx < settings.fault_injection.fault_adversaries.size(); ++adv_idx) {
      SampledRFAdversary adversary(library, circuit, settings, simulation, adv_idx);
      adversary.EvaluateRandomFaultAdversary();
      adversary.WriteJsonOutput(adv_idx);

      if(adversary.GetUpperBound() > max_upper){
        max_upper = adversary.GetUpperBound();
        max_lower = adversary.GetLowerBound();
        max_index = adv_idx;
      }
    }
  } else {
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
}
