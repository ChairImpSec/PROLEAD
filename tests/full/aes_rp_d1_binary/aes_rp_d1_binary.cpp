#include <boost/program_options.hpp>
#include <catch2/catch.hpp>
#include <cstdint>

#include "Util/ProgramOptions.hpp"
#include "Software/Analyze.hpp"
#include "Software/Prepare.hpp"

namespace po = boost::program_options;

namespace Software {
TEST_CASE("Test full verification (aes_rp_d1_binary)", "[software][aes_rp_d1_binary]") {
  const std::string config_file_name =
      "tests/full/aes_rp_d1_binary/aes_rp_d1_binary.json";
  boost::json::object config_file = ValidateJson(config_file_name);

  po::variables_map vm;
  vm.insert({"designfile",
             po::variable_value{
                 std::string("tests/full/aes_rp_d1_binary/aes_rp_d1_binary_c.c"),
                 false}});
  vm.insert(
      {"resultfolder",
       po::variable_value{std::string("tests/full/aes_rp_d1_binary/"), false}});
  vm.insert({"linkerfile",
             po::variable_value{
                 std::string("tests/full/aes_rp_d1_binary/aes_rp_d1_binary.ld"),
                 false}});
  vm.insert({"binary",
             po::variable_value{
                 std::string("tests/full/aes_rp_d1_binary/aes_rp_d1_binary.elf"),
                 false}});
  vm.insert({"mapfile",
             po::variable_value{
                 std::string("tests/full/aes_rp_d1_binary/aes_rp_d1_binary.map"),
                 false}});
  vm.insert({"asmfile",
             po::variable_value{
                 std::string("tests/full/aes_rp_d1_binary/aes_rp_d1_binary.txt"),
                 false}});
  vm.insert({"platform", po::variable_value{std::string("software"), false}});

  const std::string result_folder_path = vm["resultfolder"].as<std::string>();

  ConfigProbesStruct probes;
  SettingsStruct settings;
  HelperStruct global_helper;
  std::vector<SharedDataStruct> shared_data;
  std::vector<ThreadSimulationStruct> global_thread_simulations;
  double maximum_leakage;

  settings.externalBinaryInformation.resize(3);
  settings.externalBinaryInformation[0] = vm["binary"].as<std::string>();
  settings.externalBinaryInformation[1] = vm["mapfile"].as<std::string>();
  settings.externalBinaryInformation[2] = vm["asmfile"].as<std::string>();
  Settings settings2(config_file, false);
  Read::SettingsFile(settings, settings2, probes, true);

  SECTION("With transitions in normal mode") {
    settings.TestTransitional = 1;
    Read::BinaryFile(vm, settings);

    uint32_t number_of_threads = settings.Max_no_of_Threads;
    uint32_t number_of_cycles = settings.Max_No_ClockCycles;
    uint32_t number_of_simulations = settings.NumberOfStepSimulations;
    uint32_t cycle_counter = 0, index;
    std::vector<uint32_t> number_of_cycles_per_thread(number_of_threads);

    global_thread_simulations.resize(number_of_threads);
    shared_data.resize(number_of_simulations);

    for (index = 0; index < number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) =
          number_of_cycles / number_of_threads;
    }

    for (index = 0; index < number_of_cycles % number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) += 1;
    }

    for (index = 0; index < number_of_threads; ++index) {
      Prepare::ThreadSimulation(global_thread_simulations[index], settings,
                                result_folder_path, index, cycle_counter,
                                number_of_cycles_per_thread);
      cycle_counter += number_of_cycles_per_thread[index];
    }

    for (index = 0; index < number_of_simulations; ++index) {
      Prepare::SharedData(settings, shared_data[index]);
    }

    Prepare::Helper(probes, global_helper);

    // We expect leakage in the first order if transitions are considered.
    settings.TestTransitional = 1;
    maximum_leakage = Analyze::All(settings, shared_data, global_helper,
                                   global_thread_simulations);

    REQUIRE(maximum_leakage >= 5.0);
  }

SECTION("With transitions in compact mode") {
    settings.CompactDistributions = 1;
    settings.TestTransitional = 1;
    Read::BinaryFile(vm, settings);

    uint32_t number_of_threads = settings.Max_no_of_Threads;
    uint32_t number_of_cycles = settings.Max_No_ClockCycles;
    uint32_t number_of_simulations = settings.NumberOfStepSimulations;
    uint32_t cycle_counter = 0, index;
    std::vector<uint32_t> number_of_cycles_per_thread(number_of_threads);

    global_thread_simulations.resize(number_of_threads);
    shared_data.resize(number_of_simulations);

    for (index = 0; index < number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) =
          number_of_cycles / number_of_threads;
    }

    for (index = 0; index < number_of_cycles % number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) += 1;
    }

    for (index = 0; index < number_of_threads; ++index) {
      Prepare::ThreadSimulation(global_thread_simulations[index], settings,
                                result_folder_path, index, cycle_counter,
                                number_of_cycles_per_thread);
      cycle_counter += number_of_cycles_per_thread[index];
    }

    for (index = 0; index < number_of_simulations; ++index) {
      Prepare::SharedData(settings, shared_data[index]);
    }

    Prepare::Helper(probes, global_helper);

    // We expect leakage in the first order if transitions are considered.
    settings.TestTransitional = 1;
    maximum_leakage = Analyze::All(settings, shared_data, global_helper,
                                   global_thread_simulations);

    REQUIRE(maximum_leakage >= 5.0);
  }

  SECTION("Without transitions in normal mode") {
    settings.TestTransitional = 0;
    Read::BinaryFile(vm, settings);

    uint32_t number_of_threads = settings.Max_no_of_Threads;
    uint32_t number_of_cycles = settings.Max_No_ClockCycles;
    uint32_t number_of_simulations = settings.NumberOfStepSimulations;
    uint32_t cycle_counter = 0, index;
    std::vector<uint32_t> number_of_cycles_per_thread(number_of_threads);

    global_thread_simulations.resize(number_of_threads);
    shared_data.resize(number_of_simulations);

    for (index = 0; index < number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) =
          number_of_cycles / number_of_threads;
    }

    for (index = 0; index < number_of_cycles % number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) += 1;
    }

    for (index = 0; index < number_of_threads; ++index) {
      Prepare::ThreadSimulation(global_thread_simulations[index], settings,
                                result_folder_path, index, cycle_counter,
                                number_of_cycles_per_thread);
      cycle_counter += number_of_cycles_per_thread[index];
    }

    for (index = 0; index < number_of_simulations; ++index) {
      Prepare::SharedData(settings, shared_data.at(index));
    }

    Prepare::Helper(probes, global_helper);

    // We expect no leakage in the first order if transitions are ignored.
    maximum_leakage = Analyze::All(settings, shared_data, global_helper,
                                   global_thread_simulations);
    REQUIRE(maximum_leakage < 6.0);
  }

  SECTION("Without transitions in compact mode") {
    settings.CompactDistributions = 1;
    settings.TestTransitional = 0;
    Read::BinaryFile(vm, settings);

    uint32_t number_of_threads = settings.Max_no_of_Threads;
    uint32_t number_of_cycles = settings.Max_No_ClockCycles;
    uint32_t number_of_simulations = settings.NumberOfStepSimulations;
    uint32_t cycle_counter = 0, index;
    std::vector<uint32_t> number_of_cycles_per_thread(number_of_threads);

    global_thread_simulations.resize(number_of_threads);
    shared_data.resize(number_of_simulations);

    for (index = 0; index < number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) =
          number_of_cycles / number_of_threads;
    }

    for (index = 0; index < number_of_cycles % number_of_threads; ++index) {
      number_of_cycles_per_thread.at(index) += 1;
    }

    for (index = 0; index < number_of_threads; ++index) {
      Prepare::ThreadSimulation(global_thread_simulations[index], settings,
                                result_folder_path, index, cycle_counter,
                                number_of_cycles_per_thread);
      cycle_counter += number_of_cycles_per_thread[index];
    }

    for (index = 0; index < number_of_simulations; ++index) {
      Prepare::SharedData(settings, shared_data.at(index));
    }

    Prepare::Helper(probes, global_helper);

    // We expect no leakage in the first order if transitions are ignored.
    maximum_leakage = Analyze::All(settings, shared_data, global_helper,
                                   global_thread_simulations);
    REQUIRE(maximum_leakage < 6.0);
  }

  std::remove((result_folder_path + "code_section.ARM.exidx").c_str());
  std::remove((result_folder_path + "code_section.bss").c_str());
  std::remove((result_folder_path + "code_section.data").c_str());
  std::remove((result_folder_path + "code_section.eh_frame").c_str());
  std::remove((result_folder_path + "code_section.fini").c_str());
  std::remove((result_folder_path + "code_section.fini_array").c_str());
  std::remove((result_folder_path + "code_section.init").c_str());
  std::remove((result_folder_path + "code_section.init_array").c_str());
  std::remove((result_folder_path + "code_section.init_array.00000").c_str());
  std::remove((result_folder_path + "code_section.randomness").c_str());
  std::remove((result_folder_path + "code_section.text").c_str());
  std::remove((result_folder_path + "code_section.text.startup").c_str());
}
}  // namespace Software
