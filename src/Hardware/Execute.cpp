#include "Hardware/Execute.hpp"

void Hardware::Execute(const CommandLineParameterStruct& parameter) {
  Hardware::CircuitStruct circuit;
  Hardware::LibraryStruct library;
  Hardware::SettingsStruct settings;
  Hardware::ProbesStruct probes;
  Hardware::SimulationStruct simulation;
  Hardware::SharedDataStruct* shared_data = NULL;

  std::cout << "Start Hardware Leakage Evaluation" << std::endl << std::endl;
  Hardware::Prepare::All(parameter, circuit, library, settings, probes,
                         simulation, shared_data);

  // Store the module name to have access during vcd file generation
  settings.ModuleName = new char[parameter.MainModuleName.length() + 1];
  strcpy(settings.ModuleName, parameter.MainModuleName.c_str());
  Hardware::Adversaries<Hardware::probing::GlitchExtendedProbe>
      glitch_extended_adversary(library, circuit, settings);
  glitch_extended_adversary.EvaluateRobustProbingSecurity(
      library, circuit, settings, shared_data, simulation);
  std::cout << "done!" << std::endl;
}
