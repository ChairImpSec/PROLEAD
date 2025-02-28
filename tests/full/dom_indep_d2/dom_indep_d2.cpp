#include <catch2/catch.hpp>
#include "Hardware/Adversaries.hpp"
#include "Hardware/Prepare.hpp"

class Test {
 public:
  Test(double maximum_leakage, uint64_t number_of_propagations,
       uint64_t number_of_standard_probes, uint64_t number_of_probe_extensions,
       uint64_t number_of_probing_sets)
      : maximum_leakage_(maximum_leakage),
        number_of_propagations_(number_of_propagations),
        number_of_standard_probes_(number_of_standard_probes),
        number_of_probe_extensions_(number_of_probe_extensions),
        number_of_probing_sets_(number_of_probing_sets) {}

  bool Require(bool leakage_expected, uint64_t number_of_propagations,
               uint64_t number_of_standard_probes,
               uint64_t number_of_probe_extensions,
               uint64_t number_of_probing_sets) {
    if (leakage_expected && maximum_leakage_ < 5.0) {
      return false;
    } else if (!leakage_expected && maximum_leakage_ >= 5.0) {
      return false;
    } else if (number_of_propagations != number_of_propagations_) {
      return false;
    } else if (number_of_standard_probes != number_of_standard_probes_) {
      return false;
    } else if (number_of_probe_extensions != number_of_probe_extensions_) {
      return false;
    } else if (number_of_probing_sets != number_of_probing_sets_) {
      return false;
    } else {
      return true;
    }
  }

 private:
  double maximum_leakage_;
  uint64_t number_of_propagations_;
  uint64_t number_of_standard_probes_;
  uint64_t number_of_probe_extensions_;
  uint64_t number_of_probing_sets_;
};

Test TestDomIndepd2(Settings& settings) {
  const std::string library_file_name = "library.json";
  const std::string library_name = "NANG45";
  const std::string design_file_name = "tests/full/dom_indep_d2/dom_indep_d2.v";
  const std::string topmodule_name = "dom_indep_d2";
  const std::string result_folder_name = "tests/full/dom_indep_d2";

  Hardware::CircuitStruct circuit;
  Library library(library_file_name, library_name,
                            settings.IsRelaxedModel());
  Hardware::Read::DesignFile(design_file_name, topmodule_name, settings,
                             library, &circuit, 0, 0, 0, NULL);
  circuit.SetIsProbeAllowed(library, settings);
  circuit.SetIsExtensionAllowed(library, settings);
  circuit.SetIsAnalysisAllowed(settings);
  circuit.SetIsFaultAllowed(settings);
  std::cout << "done" << std::endl;

  Hardware::Prepare::MakeCircuitDepth(library, &circuit);

  std::vector<SharedData> shared_data(settings.GetNumberOfThreads(),
                                      SharedData(circuit, settings));
  Simulation simulation(circuit, settings);
  simulation.topmodule_name_ = topmodule_name;
  simulation.result_folder_name_ = result_folder_name;

  if (settings.IsRelaxedModel()) {
    Hardware::Adversaries<Hardware::RelaxedProbe> adversary(
        library, circuit, settings, simulation);
    double maximum_leakage =
        adversary.EvaluateRobustProbingSecurity(shared_data);
    return Test(maximum_leakage, adversary.GetNumberOfPropagations(),
                adversary.GetNumberOfStandardProbes(),
                adversary.GetNumberOfExtendedProbes(),
                adversary.GetNumberOfProbingSets());
  } else {
    Hardware::Adversaries<Hardware::RobustProbe> adversary(
        library, circuit, settings, simulation);
    double maximum_leakage =
        adversary.EvaluateRobustProbingSecurity(shared_data);
    return Test(maximum_leakage, adversary.GetNumberOfPropagations(),
                adversary.GetNumberOfStandardProbes(),
                adversary.GetNumberOfExtendedProbes(),
                adversary.GetNumberOfProbingSets());
  }
}

TEST_CASE("Test full verification (dom_indep_d2)", "[dom_indep_d2]") {
  const std::string config_file_name =
      "tests/full/dom_indep_d2/dom_indep_d2.json";

  Settings settings(config_file_name, true);

  SECTION("Robust Probing Model with no minimization in normal mode") {
    settings.SetMinimization(Minimization::none);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 21, 42, 30, 420));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 21, 42, 30, 2660));
    }
  }

  SECTION("Robust Probing Model with trivial minimization in normal mode") {
    settings.SetMinimization(Minimization::trivial);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 9, 18, 30, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 9, 18, 30, 160));
    }
  }

  SECTION("Robust Probing Model with aggressive minimization in normal mode") {
    settings.SetMinimization(Minimization::aggressive);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 9, 18, 30, 36));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 9, 18, 30, 44));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with no minimization in normal mode") {
    settings.SetMinimization(Minimization::none);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 42, 72, 420));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 42, 72, 2660));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with trivial minimization in normal "
      "mode") {
    settings.SetMinimization(Minimization::trivial);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 18, 72, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 18, 72, 168));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with aggressive minimization in normal "
      "mode") {
    settings.SetMinimization(Minimization::aggressive);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 18, 72, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 18, 72, 168));
    }
  }

  SECTION("Robust Probing Model with no minimization in compact mode") {
    settings.SetMinimization(Minimization::none);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 21, 42, 30, 420));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 21, 42, 30, 2660));
    }
  }

  SECTION("Robust Probing Model with trivial minimization in compact mode") {
    settings.SetMinimization(Minimization::trivial);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 9, 18, 30, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 9, 18, 30, 160));
    }
  }

  SECTION("Robust Probing Model with aggressive minimization in compact mode") {
    settings.SetMinimization(Minimization::aggressive);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(false);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 9, 18, 30, 36));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 9, 18, 30, 44));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with no minimization in compact mode") {
    settings.SetMinimization(Minimization::none);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 42, 72, 420));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 42, 72, 2660));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with trivial minimization in compact "
      "mode") {
    settings.SetMinimization(Minimization::trivial);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 18, 72, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 18, 72, 168));
    }
  }

  SECTION(
      "Robust but Relaxed Probing Model with aggressive minimization in "
      "compact mode") {
    settings.SetMinimization(Minimization::aggressive);
    settings.SetCompactDistribution(true);
    settings.SetRelaxedModel(true);
    settings.SetTestOrder(GENERATE(2, 3));

    Test test = TestDomIndepd2(settings);

    if (settings.GetTestOrder() == 2) {
      // We expect no leakage in the second order.
      REQUIRE(test.Require(false, 72, 18, 72, 72));
    } else {
      // But we expect leakage in the third order.
      REQUIRE(test.Require(true, 72, 18, 72, 168));
    }
  }
}