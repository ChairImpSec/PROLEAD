#define CATCH_CONFIG_ENABLE_BENCHMARKING
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "Hardware/Faulting.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the induction of the fault",
          "[uint64_t InduceFault(uint64_t)]") {
  uint64_t value_to_fault = 0x00ff00ff00ff00ff;

  SECTION("Stuck at zero fault") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::StuckAt0);
    REQUIRE(fault_target.InduceFault(value_to_fault) == 0);
  }

  SECTION("Stuck at one fault") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::StuckAt1);
    REQUIRE(fault_target.InduceFault(value_to_fault) == 0xffffffffffffffff);
  }

  SECTION("Toggle fault") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::Toggle);
    REQUIRE(fault_target.InduceFault(value_to_fault) == 0xff00ff00ff00ff00);
  }

  SECTION("Multiple faults") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::All);
    REQUIRE_THROWS_WITH(fault_target.InduceFault(value_to_fault),
                        "Tried to perform more than one fault at once!");
  }
}

TEST_CASE("Test if the fault target is equal to a signal",
          "[bool FaultTarget::IsEqualToSignal(unsigned int, unsigned int)]") {
  SECTION("Equal signal index and equal clock cycle") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::All);
    REQUIRE(fault_target.IsEqualToSignal(0, 0));
  }

  SECTION("Unequal signal index and equal clock cycle") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::All);
    REQUIRE_FALSE(fault_target.IsEqualToSignal(1, 0));
  }

  SECTION("Equal signal index and unequal clock cycle") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::All);
    REQUIRE_FALSE(fault_target.IsEqualToSignal(0, 1));
  }

  SECTION("Unequal signal index and unequal clock cycle") {
    Hardware::faulting::FaultTarget fault_target(
        0, 0, Hardware::faulting::FaultType::All);
    REQUIRE_FALSE(fault_target.IsEqualToSignal(1, 1));
  }
}