#include "Hardware/Execute.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

void RunLmdpl3AndsD1(const std::string& configfile, const std::string& expected_probe_report_name) {
    std::string path = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/";
    po::variables_map vm;
    vm.insert({"configfile", po::variable_value(boost::any(path + configfile), false)});
    vm.insert({"designfile", po::variable_value(
      boost::any(std::vector<std::string>{path + "lmdpl_3_ands_d1.v"}), false)});
    vm.insert({"libraryfile", po::variable_value(boost::any(std::string("libs/nang45.json")), false)});
    vm.insert({"libraryname", po::variable_value(boost::any(std::string("nang45")), false)});
    vm.insert({"modulename", po::variable_value(boost::any(std::string("lmdpl_3_ands_d1")), false)});
    vm.insert({"resultfolder", po::variable_value(boost::any(std::string(path)), false)});

    Hardware::Execute(vm);

    const std::string probe_report_name = path + "prolead_lmdpl_3_ands_d1_probes.json";
    boost::property_tree::ptree expected, received;
    boost::property_tree::read_json(path + expected_probe_report_name, expected);
    boost::property_tree::read_json(probe_report_name, received);
    BOOST_CHECK(expected == received);
    std::filesystem::remove(probe_report_name);
}

bool CheckLmdpl3AndsD1(bool expected_leakage) {
  std::string leakage_report_name;

  uint64_t idx = 0;
  leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/"
    "prolead_lmdpl_3_ands_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    boost::property_tree::ptree pt, sets;
    try {
      boost::property_tree::read_json(leakage_report_name, pt);
      const boost::property_tree::ptree& most_leaking_sets =
        pt.get_child("most_leaking_probing_sets_per_cycle");
      
      for (const auto& set : most_leaking_sets) {
        double log10_p;
        try {
          if (set.second.get<std::string>("-log10(p)") == "inf") {
            log10_p = std::numeric_limits<double>::infinity();
          } else {
            log10_p = set.second.get<double>("-log10(p)");
          }
        } catch (const std::exception& e) {
          BOOST_LOG_TRIVIAL(error) << "Error reading -log10(p) value: " << e.what();
          return false;
        }

        if (expected_leakage && log10_p >= 5.0) {
          return true;
        }
        
        if (!expected_leakage && log10_p >= 5.0) {
          return false;
        }
      }    
    } catch (const std::exception& e) {
      BOOST_LOG_TRIVIAL(error) << "Error reading json file: " << e.what();
      return false;
    }  
    leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/prolead_lmdpl_3_ands_d1_" 
      + std::to_string(++idx) + "_0_16384_leakages.json";
  }

  return true;
}

BOOST_AUTO_TEST_SUITE(test_lmdpl_3_ands_d1_induce_glitch)

BOOST_AUTO_TEST_CASE(t1, *utf::label("lmdpl_3_ands_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("relaxed")) {
  RunLmdpl3AndsD1("relaxed_normal_1_ps_all.json", "relaxed_normal_1_ps_all_expected_probes.json");
  BOOST_CHECK(CheckLmdpl3AndsD1(false));

  uint64_t idx = 0;
  std::string leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/"
    "prolead_lmdpl_3_ands_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    std::filesystem::remove(leakage_report_name);
    leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/prolead_lmdpl_3_ands_d1_" 
      + std::to_string(++idx) + "_0_16384_leakages.json";
  }
}

BOOST_AUTO_TEST_CASE(t2, *utf::label("lmdpl_3_ands_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("combined") *utf::label("probing security") *utf::label("normal mode") 
  *utf::label("relaxed") *utf::label("induce glitch")) {
  RunLmdpl3AndsD1("relaxed_normal_1_ps_all_induce_glitch.json", "relaxed_normal_1_ps_all_induce_glitch_expected_probes.json");
  BOOST_CHECK(CheckLmdpl3AndsD1(true));

  uint64_t idx = 0;
  std::string leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/"
    "prolead_lmdpl_3_ands_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    std::filesystem::remove(leakage_report_name);
    leakage_report_name = "tests/full/prolead/combined/lmdpl_3_ands_d1_induce_glitch/prolead_lmdpl_3_ands_d1_" 
      + std::to_string(++idx) + "_0_16384_leakages.json";
  }
}

BOOST_AUTO_TEST_SUITE_END()