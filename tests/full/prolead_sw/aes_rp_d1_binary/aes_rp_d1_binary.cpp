#include <boost/program_options.hpp>
#include <boost/test/unit_test.hpp>
#include <cstdint>
#include <cstdio>  // For std::remove

#include "Software/Analyze.hpp"
#include "Software/Prepare.hpp"
#include "Util/ProgramOptions.hpp"

namespace utf = boost::unit_test;
namespace po = boost::program_options;

BOOST_AUTO_TEST_SUITE(test_aes_rp_d1_binary)

const std::string path = "tests/full/prolead_sw/aes_rp_d1_binary/";

struct TestFixture {
  po::variables_map vm;
  Software::SettingsStruct settings;
  Software::ConfigProbesStruct probes;
  Software::HelperStruct global_helper;
  std::vector<Software::SharedDataStruct> shared_data;
  std::vector<Software::ThreadSimulationStruct> global_thread_simulations;
  std::string result_folder_path;

  TestFixture() {
    const std::string config_file_name = path + "aes_rp_d1_binary.json";
    boost::json::object config_file = ValidateJson(config_file_name);

    vm.insert(
        {"designfile", po::variable_value{
                           std::string(path + "aes_rp_d1_binary_c.c"), false}});
    vm.insert({"resultfolder", po::variable_value{path, false}});
    vm.insert(
        {"linkerfile",
         po::variable_value{std::string(path + "aes_rp_d1_binary.ld"), false}});
    vm.insert(
        {"binary", po::variable_value{
                       std::string(path + "aes_rp_d1_binary.elf"), false}});
    vm.insert(
        {"mapfile", po::variable_value{
                        std::string(path + "aes_rp_d1_binary.map"), false}});
    vm.insert(
        {"asmfile", po::variable_value{
                        std::string(path + "aes_rp_d1_binary.txt"), false}});
    vm.insert({"platform", po::variable_value{std::string("software"), false}});
    result_folder_path = vm["resultfolder"].as<std::string>();

    settings.externalBinaryInformation = {vm["binary"].as<std::string>(),
                                          vm["mapfile"].as<std::string>(),
                                          vm["asmfile"].as<std::string>()};

    Settings settings2(config_file, false);
    Software::Read::SettingsFile(settings, settings2, probes, true);
  }

  double TestRun() {
    uint32_t number_of_threads = settings.Max_no_of_Threads;
    uint32_t number_of_cycles = settings.Max_No_ClockCycles;
    uint32_t number_of_simulations = settings.NumberOfStepSimulations;
    uint32_t cycle_counter = 0;

    std::vector<uint32_t> number_of_cycles_per_thread(
        number_of_threads, number_of_cycles / number_of_threads);

    for (uint32_t i = 0; i < number_of_cycles % number_of_threads; ++i) {
      number_of_cycles_per_thread[i]++;
    }

    global_thread_simulations.resize(number_of_threads);
    shared_data.resize(number_of_simulations);

    for (uint32_t i = 0; i < number_of_threads; ++i) {
      Software::Prepare::ThreadSimulation(
          global_thread_simulations[i], settings, result_folder_path, i,
          cycle_counter, number_of_cycles_per_thread);
      cycle_counter += number_of_cycles_per_thread[i];
    }

    for (uint32_t i = 0; i < number_of_simulations; ++i) {
      Software::Prepare::SharedData(settings, shared_data[i]);
    }

    Software::Prepare::Helper(probes, global_helper);
    return Software::Analyze::All(settings, shared_data, global_helper,
                                  global_thread_simulations);
  }

  ~TestFixture() {
    const std::vector<std::string> files = {"code_section.ARM.exidx",
                                            "code_section.bss",
                                            "code_section.data",
                                            "code_section.eh_frame",
                                            "code_section.fini",
                                            "code_section.fini_array",
                                            "code_section.init",
                                            "code_section.init_array",
                                            "code_section.init_array.00000",
                                            "code_section.randomness",
                                            "code_section.text",
                                            "code_section.text.startup"};

    for (const std::string& file : files) {
      std::remove((result_folder_path + file).c_str());
    }
  }
};

BOOST_FIXTURE_TEST_CASE(w_trans_normal_mode, TestFixture,
                        *utf::label("software") * utf::label("aes_rp_d1") *
                            utf::label("binary") * utf::label("normal") *
                            utf::label("aes_rp_d1_binary")) {
  settings.TestTransitional = 1;
  Software::Read::BinaryFile(vm, settings);
  double leakage = TestRun();
  BOOST_CHECK_GE(leakage, 5.0);
}

BOOST_FIXTURE_TEST_CASE(w_trans_compact_mode, TestFixture,
                        *utf::label("software") * utf::label("aes_rp_d1") *
                            utf::label("binary") * utf::label("compact") *
                            utf::label("aes_rp_d1_binary")) {
  settings.TestTransitional = 1;
  settings.CompactDistributions = 1;
  Software::Read::BinaryFile(vm, settings);
  double leakage = TestRun();
  BOOST_CHECK_GE(leakage, 5.0);
}

BOOST_FIXTURE_TEST_CASE(wo_trans_normal_mode, TestFixture,
                        *utf::label("software") * utf::label("aes_rp_d1") *
                            utf::label("binary") * utf::label("normal") *
                            utf::label("aes_rp_d1_binary")) {
  settings.TestTransitional = 0;
  Software::Read::BinaryFile(vm, settings);
  double leakage = TestRun();
  BOOST_CHECK_LT(leakage, 5.0);
}

BOOST_FIXTURE_TEST_CASE(wo_trans_compact_mode, TestFixture,
                        *utf::label("software") * utf::label("aes_rp_d1") *
                            utf::label("binary") * utf::label("compact") *
                            utf::label("aes_rp_d1_binary")) {
  settings.TestTransitional = 0;
  settings.CompactDistributions = 1;
  Software::Read::BinaryFile(vm, settings);
  double leakage = TestRun();
  BOOST_CHECK_LT(leakage, 5.0);
}

BOOST_AUTO_TEST_SUITE_END()
