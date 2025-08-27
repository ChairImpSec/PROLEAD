#include "Hardware/Execute.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

void RunLmdplAndD1(const std::string& configfile, const std::string& expected_probe_report_name) {
    std::string path = "tests/full/prolead/gadgets/lmdpl_and_d1/";
    po::variables_map vm;
    vm.insert({"configfile", po::variable_value(boost::any(path + configfile), false)});
    vm.insert({"designfile", po::variable_value(
      boost::any(std::vector<std::string>{path + "lmdpl_and_d1.v"}), false)});
    vm.insert({"libraryfile", po::variable_value(boost::any(std::string("libs/nang45.json")), false)});
    vm.insert({"libraryname", po::variable_value(boost::any(std::string("nang45")), false)});
    vm.insert({"modulename", po::variable_value(boost::any(std::string("lmdpl_and_d1")), false)});
    vm.insert({"resultfolder", po::variable_value(boost::any(std::string(path)), false)});

    Hardware::Execute(vm);

    const std::string probe_report_name = path + "prolead_lmdpl_and_d1_probes.json";
    boost::property_tree::ptree expected, received;
    boost::property_tree::read_json(path + expected_probe_report_name, expected);
    boost::property_tree::read_json(probe_report_name, received);
    BOOST_CHECK(expected == received);
    std::filesystem::remove(probe_report_name);
}

bool CheckLmdplAndD1(bool expected_leakage) {
  std::string leakage_report_name = 
    "tests/full/prolead/gadgets/lmdpl_and_d1/prolead_lmdpl_and_d1_0_0_16384_leakages.json";
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
        std::filesystem::remove(leakage_report_name);
        return true;
      }
      
      if (!expected_leakage && log10_p >= 5.0) {
        std::filesystem::remove(leakage_report_name);
        return false;
      }
    }    
  } catch (const std::exception& e) {
    BOOST_LOG_TRIVIAL(error) << "Error reading json file: " << e.what();
    std::filesystem::remove(leakage_report_name);
    return false;
  }  

  std::filesystem::remove(leakage_report_name);
  return true;
}

BOOST_AUTO_TEST_SUITE(test_lmdpl_and_d1)

BOOST_AUTO_TEST_CASE(t1, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("relaxed")) {
  RunLmdplAndD1("relaxed_compact_1_ps_all.json", "relaxed_compact_1_ps_all_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(false));
}

BOOST_AUTO_TEST_CASE(t2, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d2")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("relaxed")) {
  RunLmdplAndD1("relaxed_compact_2_ps_x2_t_in0.json", "relaxed_compact_2_ps_x2_t_in0_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(true));
}

BOOST_AUTO_TEST_CASE(t3, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("relaxed")) {
  RunLmdplAndD1("relaxed_normal_1_ps_all.json", "relaxed_normal_1_ps_all_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(false));
}

BOOST_AUTO_TEST_CASE(t4, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d2")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("relaxed")) {
  RunLmdplAndD1("relaxed_normal_2_ps_x2_t_in0.json", "relaxed_normal_2_ps_x2_t_in0_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(true));
}

BOOST_AUTO_TEST_CASE(t5, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunLmdplAndD1("robust_compact_1_ps_w_trans_all.json", "robust_compact_1_ps_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(false));
}

BOOST_AUTO_TEST_CASE(t6, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunLmdplAndD1("robust_compact_1_ps_wo_trans_all.json", "robust_compact_1_ps_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(false));
}

BOOST_AUTO_TEST_CASE(t7, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunLmdplAndD1("robust_normal_1_ps_w_trans_x2.json", "robust_normal_1_ps_w_trans_x2_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(true));
}

BOOST_AUTO_TEST_CASE(t8, *utf::label("lmdpl_and_d1") *utf::label("lmdpl") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunLmdplAndD1("robust_normal_1_ps_wo_trans_x2.json", "robust_normal_1_ps_wo_trans_x2_expected_probes.json");
  BOOST_CHECK(CheckLmdplAndD1(true));
}

BOOST_AUTO_TEST_SUITE_END()