#include "Util/RangeGrammar.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the parser for number ranges", "[RangeGrammar]") {
  RangeGrammar grammar;
  std::string input;
  std::pair<double, double> expected;

  SECTION("Test with single integer") {
    input = "5";
    expected = std::make_pair(5, 5);
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with range") {
    input = "1-5";
    expected = std::make_pair(1, 5);
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with single negative integer") {
    input = "-5";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with negative range") {
    input = "-5-10";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "5--10";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "-5--10";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }
}