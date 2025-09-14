#include "Hardware/Execute.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

void RunDomIndepD2(const std::string& configfile, const std::string& expected_probe_report_name) {
    std::string path = "tests/full/prolead/gadgets/dom_indep_d2/";
    po::variables_map vm;
    vm.insert({"configfile", po::variable_value(boost::any(path + configfile), false)});
    vm.insert({"designfile", po::variable_value(
      boost::any(std::vector<std::string>{path + "dom_indep_d2.v"}), false)});
    vm.insert({"libraryfile", po::variable_value(boost::any(std::string("libs/nang45.json")), false)});
    vm.insert({"libraryname", po::variable_value(boost::any(std::string("nang45")), false)});
    vm.insert({"modulename", po::variable_value(boost::any(std::string("dom_indep_d2")), false)});
    vm.insert({"resultfolder", po::variable_value(boost::any(std::string(path)), false)});

    Hardware::Execute(vm);

    const std::string probe_report_name = path + "prolead_dom_indep_d2_probes.json";
    boost::property_tree::ptree expected, received;
    boost::property_tree::read_json(path + expected_probe_report_name, expected);
    boost::property_tree::read_json(probe_report_name, received);
    BOOST_CHECK(expected == received);
    std::filesystem::remove(probe_report_name);
}

bool CheckDomIndepD2(bool expected_leakage) {
  std::string leakage_report_name = 
    "tests/full/prolead/gadgets/dom_indep_d2/prolead_dom_indep_d2_0_0_65536_leakages.json";
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

  if (expected_leakage) {
    return false;
  } else {
    return true;
  }
}

BOOST_AUTO_TEST_SUITE(test_dom_indep_d2)

BOOST_AUTO_TEST_CASE(t1, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_1_ps_all.json", 
    "relaxed_normal_1_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t2, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_1_ni_all.json", 
    "relaxed_normal_1_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t3, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("strong non-interference") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_1_sni_all.json", 
    "relaxed_normal_1_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t4, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probe-isolating non-interference") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_1_pini_all.json", 
    "relaxed_normal_1_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t5, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_2_ps_all.json", 
    "relaxed_normal_2_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t6, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("relaxed")) {
  RunDomIndepD2("relaxed_normal_2_ni_all.json", 
    "relaxed_normal_2_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t7, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_ps_w_trans_all.json", 
    "robust_compact_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t8, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_ni_w_trans_all.json", 
    "robust_compact_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t9, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("strong non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_sni_w_trans_all.json", 
    "robust_compact_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t10, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probe-isolating non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_pini_w_trans_all.json", 
    "robust_compact_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t11, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_ps_wo_trans_all.json", 
    "robust_compact_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t12, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_ni_wo_trans_all.json", 
    "robust_compact_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t13, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("strong non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_sni_wo_trans_all.json", 
    "robust_compact_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t14, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probe-isolating non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_1_sni_wo_trans_all.json", 
    "robust_compact_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t15, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_2_ps_w_trans_all.json", 
    "robust_compact_2_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t16, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_2_ni_w_trans_all.json", 
    "robust_compact_2_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t17, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("probing security") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_2_ps_wo_trans_all.json", 
    "robust_compact_2_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t18, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("non-interference") *utf::label("compact mode") *utf::label("robust")) {
  RunDomIndepD2("robust_compact_2_ni_wo_trans_all.json", 
    "robust_compact_2_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t19, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_ps_w_trans_all.json", 
    "robust_normal_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t20, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_ni_w_trans_all.json", 
    "robust_normal_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t21, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("strong non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_sni_w_trans_all.json", 
    "robust_normal_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t22, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probe-isolating non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_pini_w_trans_all.json", 
    "robust_normal_1_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t23, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_ps_wo_trans_all.json", 
    "robust_normal_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t24, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_ni_wo_trans_all.json", 
    "robust_normal_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t25, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("strong non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_sni_wo_trans_all.json", 
    "robust_normal_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t26, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d1")
  *utf::label("probe-isolating non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_1_sni_wo_trans_all.json", 
    "robust_normal_1_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(true));
}

BOOST_AUTO_TEST_CASE(t27, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_2_ps_w_trans_all.json", 
    "robust_normal_2_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t28, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_2_ni_w_trans_all.json", 
    "robust_normal_2_w_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t29, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("probing security") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_2_ps_wo_trans_all.json", 
    "robust_normal_2_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_CASE(t30, *utf::label("dom_indep_d2") *utf::label("dom") *utf::label("d2")
  *utf::label("non-interference") *utf::label("normal mode") *utf::label("robust")) {
  RunDomIndepD2("robust_normal_2_ni_wo_trans_all.json", 
    "robust_normal_2_wo_trans_all_expected_probes.json");
  BOOST_CHECK(CheckDomIndepD2(false));
}

BOOST_AUTO_TEST_SUITE_END()