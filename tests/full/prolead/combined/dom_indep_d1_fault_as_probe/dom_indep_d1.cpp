#include "Hardware/Execute.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

void RunDomIndepD1FaultAsProbe(const std::string& configfile, const std::string& expected_probe_report_name) {
    std::string path = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/";
    po::variables_map vm;
    vm.insert({"configfile", po::variable_value(boost::any(path + configfile), false)});
    vm.insert({"designfile", po::variable_value(
      boost::any(std::vector<std::string>{path + "dom_indep_d1.v"}), false)});
    vm.insert({"libraryfile", po::variable_value(boost::any(std::string("libs/nang45.json")), false)});
    vm.insert({"libraryname", po::variable_value(boost::any(std::string("nang45")), false)});
    vm.insert({"modulename", po::variable_value(boost::any(std::string("dom_indep_d1")), false)});
    vm.insert({"resultfolder", po::variable_value(boost::any(std::string(path)), false)});

    Hardware::Execute(vm);

    const std::string probe_report_name = path + "prolead_dom_indep_d1_probes.json";
    boost::property_tree::ptree expected, received;
    boost::property_tree::read_json(path + expected_probe_report_name, expected);
    boost::property_tree::read_json(probe_report_name, received);
    BOOST_CHECK(expected == received);
    std::filesystem::remove(probe_report_name);
}

bool CheckDomIndepD1FaultAsProbe(bool expected_leakage) {
  std::string leakage_report_name;

  uint64_t idx = 0;
  leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
    "prolead_dom_indep_d1_fault_as_probe_" + std::to_string(idx) + "_0_16384_leakages.json";
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
    leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
      "prolead_dom_indep_d1_fault_as_probe_" + std::to_string(++idx) + "_0_16384_leakages.json";
  }

  return true;
}

BOOST_AUTO_TEST_SUITE(test_dom_indep_d1_fault_as_probe)

BOOST_AUTO_TEST_CASE(t1, *utf::label("dom_indep_d1") *utf::label("dom") *utf::label("d1")
  *utf::label("combined") *utf::label("fault as probe")) {
  RunDomIndepD1FaultAsProbe("fault_as_probe_all.json", "fault_as_probe_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD1FaultAsProbe(false));

  uint64_t idx = 0;
  std::string leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
    "prolead_dom_indep_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    std::filesystem::remove(leakage_report_name);
    leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
      "prolead_dom_indep_d1_fault_as_probe_" + std::to_string(++idx) + "_0_16384_leakages.json";
  }
}

BOOST_AUTO_TEST_CASE(t2, *utf::label("dom_indep_d1") *utf::label("dom") *utf::label("d1")
  *utf::label("combined") *utf::label("fault as probe")) {
  RunDomIndepD1FaultAsProbe("fault_as_probe_faulty.json", "fault_as_probe_faulty_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD1FaultAsProbe(true));

  uint64_t idx = 0;
  std::string leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
    "prolead_dom_indep_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    std::filesystem::remove(leakage_report_name);
    leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
      "prolead_dom_indep_d1_fault_as_probe_" + std::to_string(++idx) + "_0_16384_leakages.json";
  }
}

BOOST_AUTO_TEST_CASE(t3, *utf::label("dom_indep_d1") *utf::label("dom") *utf::label("d1")
  *utf::label("combined") *utf::label("fault as probe")) {
  RunDomIndepD1FaultAsProbe("fault_as_probe_fault_free.json", "fault_as_probe_fault_free_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD1FaultAsProbe(true));

  uint64_t idx = 0;
  std::string leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
    "prolead_dom_indep_d1_" + std::to_string(idx) + "_0_16384_leakages.json";
  while (std::filesystem::exists(leakage_report_name)) {
    std::filesystem::remove(leakage_report_name);
    leakage_report_name = "tests/full/prolead/combined/dom_indep_d1_fault_as_probe/"
      "prolead_dom_indep_d1_fault_as_probe_" + std::to_string(++idx) + "_0_16384_leakages.json";
  }
}

BOOST_AUTO_TEST_SUITE_END()