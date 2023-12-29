#define CATCH_CONFIG_MAIN
#include <catch2/catch.hpp>
#include "CpuCoreSelector.hpp"
#include "CpuCoreSelector.cpp"
#include <thread>


TEST_CASE("CpuCoreSelector returns correct thread counts", "[CpuCoreSelector]") {
    SECTION("Return all cores for All option") {
        REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::All) == std::thread::hardware_concurrency());
    }

    SECTION("Return half cores for Half option") {
        REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::Half) == std::thread::hardware_concurrency() / 2);
    }

    SECTION("Return Third cores for Third option") {
        REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::Third) == std::thread::hardware_concurrency() / 3);
    }

    SECTION("Return Quarter cores for Quarter option") {
        REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::Quarter) == std::thread::hardware_concurrency() / 4);
    }

}

TEST_CASE("CpuCoreSelector handles invalid cases", "[CpuCoreSelector]") {
    SECTION("Handle invalid specific count gracefully") {
        // You can test for an unusually high specific count, expecting it to return the max hardware concurrency
        REQUIRE(CpuCoreSelector::getOptimalCount(CpuSelectionOption::Specific, 10000) == 1);
    }

    SECTION("Handle invalid specific count gracefully") {
        int threadsToUse = CpuCoreSelector::getOptimalCount(static_cast<CpuSelectionOption>(-1));
        REQUIRE(threadsToUse == 1);
    }
}