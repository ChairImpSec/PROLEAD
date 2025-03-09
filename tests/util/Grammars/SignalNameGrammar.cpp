#include "Util/Grammars/SignalNameGrammar.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the SignalNameGrammar parser", "[SignalNameGrammar]") {
  SignalNameGrammar grammar;
  std::string input;
  std::vector<std::string> expected;

  SECTION("Test valid identifiers without index or range") {
    input = "signal0";
    expected = {"signal0"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal_0";
    expected = {"signal_0"};
    REQUIRE(expected == grammar.Parse(input));
  }

  SECTION("Test valid identifiers with index") {
    input = "signal[0]";
    expected = {"signal[0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal_[0]";
    expected = {"signal_[0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0][0]";
    expected = {"signal[0][0]"};
    REQUIRE(expected == grammar.Parse(input));
  }

  SECTION("Test valid identifiers with range") {
    input = "signal[0:0]";
    expected = {"signal[0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0][0:0]";
    expected = {"signal[0][0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[2:0]";
    expected = {"signal[0]", "signal[1]", "signal[2]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0][2:0]";
    expected = {"signal[0][0]", "signal[0][1]", "signal[0][2]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0:2]";
    expected = {"signal[2]", "signal[1]", "signal[0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0][0:2]";
    expected = {"signal[0][2]", "signal[0][1]", "signal[0][0]"};
    REQUIRE(expected == grammar.Parse(input));
  }

  SECTION("Test valid vectors") {
    input = "{signal2, signal1, signal0}";
    expected = {"signal0", "signal1", "signal2"};
    REQUIRE(expected == grammar.Parse(input));

    input = "{signal[2:0]}";
    expected = {"signal[0]", "signal[1]", "signal[2]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "{signal[2:0],signal[4:5]}";
    expected = {"signal[5]", "signal[4]", "signal[0]", "signal[1]",
                "signal[2]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "{test,signal[2:0],signal[5:4]}";
    expected = {"signal[4]", "signal[5]", "signal[0]",
                "signal[1]", "signal[2]", "test"};
    REQUIRE(expected == grammar.Parse(input));
  }

  SECTION("Test invalid inputs") {
    input = "123";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "test[]";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "test[:]";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "test[0:]";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "test[:0]";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);

    input = "{,}";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }
}