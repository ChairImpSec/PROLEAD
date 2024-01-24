#define CATCH_CONFIG_ENABLE_BENCHMARKING
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include <catch2/catch.hpp>

#include "Hardware/Execute.hpp"

TEST_CASE(
    "Test the full verification of a first-order secure DOM-indep multiplier "
    "without the consideration of any probe",
    "[dom_indep_d1_no_probes]") {
  CommandLineParameterStruct command_line_parameters;
  command_line_parameters.LibraryFileName = "library.lib";
  command_line_parameters.LibraryName = "NANG45";
  command_line_parameters.DesignFileName =
      "ut/full/dom_indep_d1_no_probes/dom_indep_d1_no_probes.v";
  command_line_parameters.MainModuleName = "dom_indep_d1_no_probes";
  command_line_parameters.SettingsFileName =
      "ut/full/dom_indep_d1_no_probes/dom_indep_d1_no_probes.set";

  Hardware::CircuitStruct circuit;
  Hardware::LibraryStruct library;
  Hardware::SettingsStruct settings;
  Hardware::ProbesStruct probes;
  Hardware::SimulationStruct simulation;
  Hardware::SharedDataStruct* shared_data = NULL;
  Hardware::Prepare::All(command_line_parameters, circuit, library, settings,
                         probes, simulation, shared_data);
  settings.ModuleName =
      new char[command_line_parameters.MainModuleName.length() + 1];
  strcpy(settings.ModuleName, command_line_parameters.MainModuleName.c_str());

  REQUIRE_THROWS_WITH(
      Hardware::Adversaries<Hardware::probing::GlitchExtendedProbe>(
          library, circuit, settings),
      "No suited probe positions considered during the evaluation!\n\n It "
      "appears that no probes were included or excluded during the "
      "evaluation process. Please review the settings for the "
      "\"probes_include\" and \"probes_exclude\" parameters to ensure they "
      "are configured correctly.");
}