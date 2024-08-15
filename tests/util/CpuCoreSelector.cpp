#include "Util/CpuCoreSelector.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the GetOptimalNumberOfThreads function",
          "[GetOptimalNumberOfThreads]") {
  CpuCoreSelector core_selector;
  uint64_t hardware_concurrency = std::thread::hardware_concurrency();

  SECTION("Test 'all' option") {
    REQUIRE(core_selector.GetOptimalNumberOfThreads("all") ==
            hardware_concurrency);
  }

  SECTION("Test 'half' option") {
    REQUIRE(core_selector.GetOptimalNumberOfThreads("half") ==
            hardware_concurrency / 2);
  }

  SECTION("Test 'third' option") {
    REQUIRE(core_selector.GetOptimalNumberOfThreads("third") ==
            hardware_concurrency / 3);
  }

  SECTION("Test 'quarter' option") {
    REQUIRE(core_selector.GetOptimalNumberOfThreads("quarter") ==
            hardware_concurrency / 4);
  }

  SECTION("Test valid number option") {
    REQUIRE(core_selector.GetOptimalNumberOfThreads("2") ==
            std::min<uint64_t>(2, hardware_concurrency));
  }

  SECTION("Test invalid option") {
    REQUIRE_THROWS_AS(core_selector.GetOptimalNumberOfThreads("invalid"),
                      std::invalid_argument);
  }

  SECTION("Test out of range option") {
    REQUIRE_THROWS_AS(core_selector.GetOptimalNumberOfThreads("-1"),
                      std::out_of_range);
  }
}