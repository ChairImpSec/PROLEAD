#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Util/CpuCoreSelector.hpp"

#include <catch2/catch.hpp>

TEST_CASE("CpuCoreSelector returns correct thread counts",
          "[CpuCoreSelector]") {
  SECTION("Return all cores for all option") {
    REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::all) ==
            std::thread::hardware_concurrency());
  }

  SECTION("Return half cores for half option") {
    REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::half) ==
            std::thread::hardware_concurrency() / 2);
  }

  SECTION("Return third cores for third option") {
    REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::third) ==
            std::thread::hardware_concurrency() / 3);
  }

  SECTION("Return quarter cores for quarter option") {
    REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::quarter) ==
            std::thread::hardware_concurrency() / 4);
  }
}

TEST_CASE("CpuCoreSelector handles invalid cases", "[CpuCoreSelector]") {
  SECTION("Handle invalid specific count gracefully") {
    REQUIRE(
        CpuCoreSelector::getOptimalCount(CpuSelectionOption::specific, 10000) == 10000);
  }

  SECTION("Handle invalid specific count gracefully") {
    REQUIRE(CpuCoreSelector::getOptimalCount(
                static_cast<CpuSelectionOption>(-1)) == 1);
  }
}