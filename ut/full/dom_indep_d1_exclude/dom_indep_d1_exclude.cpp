#define CATCH_CONFIG_ENABLE_BENCHMARKING
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include <catch2/catch.hpp>

#include "Hardware/Execute.hpp"

TEST_CASE(
    "Test the full verification of a first-order secure DOM-indep multiplier "
    "with exluded probes",
    "[dom_indep_d1_exclude]") {
  CommandLineParameterStruct command_line_parameters;
  command_line_parameters.LibraryFileName = "library.lib";
  command_line_parameters.LibraryName = "NANG45";
  command_line_parameters.DesignFileName =
      "ut/full/dom_indep_d1_exclude/dom_indep_d1_exclude.v";
  command_line_parameters.MainModuleName = "dom_indep_d1_exclude";
  command_line_parameters.SettingsFileName =
      "ut/full/dom_indep_d1_exclude/dom_indep_d1_exclude.set";

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
  Hardware::Adversaries<Hardware::probing::GlitchExtendedProbe>
      glitch_extended_adversary(library, circuit, settings);
  double maximum_leakage =
      glitch_extended_adversary.EvaluateRobustProbingSecurity(
          library, circuit, settings, shared_data, simulation);

  REQUIRE(settings.Max_no_of_Threads ==
          (int)(std::thread::hardware_concurrency() / 2));
  REQUIRE(glitch_extended_adversary.GetNumberOfProbeExtensions() == 2);
  REQUIRE(glitch_extended_adversary.GetNumberOfStandardProbes() == 6);
  REQUIRE(glitch_extended_adversary.GetNumberOfExtendedProbes() == 18);
  REQUIRE(glitch_extended_adversary.GetNumberOfUniqueProbes() == 0);
  REQUIRE(glitch_extended_adversary.GetNumberOfFaultTargets() == 0);
  REQUIRE(maximum_leakage < 5.0);
}