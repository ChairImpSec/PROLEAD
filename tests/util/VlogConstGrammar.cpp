#include "Util/VlogConstGrammar.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the parser for Verilog constants", "[VlogConstGrammar]") {
  std::vector<vlog_bit_t> expected;
  VlogConstGrammar grammar;
  std::string input;

  SECTION("Test with valid deterministic binary") {
    expected = {vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::zero, vlog_bit_t::one};

    input = "8'b10100011";
    grammar.Parse(input);
    REQUIRE(grammar.Parse(input) == expected);
    input = "8'B10100011";
    REQUIRE(grammar.Parse(input) == expected);
    input = "8'b1010_0011";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with valid inverted binary") {
    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::one,  vlog_bit_t::zero};

    input = "~8'b10100011";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with valid deterministic decimal") {
    expected = {vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::zero,
                vlog_bit_t::one,  vlog_bit_t::zero};

    input = "8'd67";
    REQUIRE(grammar.Parse(input) == expected);
    input = "8'D67";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::zero,
                vlog_bit_t::one};
    input = "7'D67";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with inverted valid inverted decimal") {
    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::one,
                vlog_bit_t::zero, vlog_bit_t::one};

    input = "~8'd67";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::one,
                vlog_bit_t::zero};

    input = "~7'd67";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with valid deterministic hex") {
    expected = {vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::zero,
                vlog_bit_t::one,  vlog_bit_t::zero};

    input = "8'h43";
    REQUIRE(grammar.Parse(input) == expected);
    input = "8'H43";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::zero,
                vlog_bit_t::one};
    input = "7'h43";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with inverted valid deterministic hex") {
    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::one,
                vlog_bit_t::zero, vlog_bit_t::one};

    input = "~8'h43";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one,  vlog_bit_t::one,  vlog_bit_t::one,
                vlog_bit_t::zero};

    input = "~7'h43";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with concatenation") {
    expected = {vlog_bit_t::high_impedance,
                vlog_bit_t::unknown,
                vlog_bit_t::high_impedance,
                vlog_bit_t::unknown,
                vlog_bit_t::one,
                vlog_bit_t::one,
                vlog_bit_t::zero,
                vlog_bit_t::one};
    input = "{1'b1, 2'h1, ~1'b0, 4'bxzxz}";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::one,  vlog_bit_t::one,   vlog_bit_t::zero,
                vlog_bit_t::zero, vlog_bit_t::zero,  vlog_bit_t::zero,
                vlog_bit_t::one,  vlog_bit_t::random};
    input = "{1'b$, 7'd67}";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::one, vlog_bit_t::zero, vlog_bit_t::zero,
                vlog_bit_t::one};
    input = "{{1'b1, 1'b0}, {1'b0, 1'b1}}";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with nested mixtures") {
    expected = {vlog_bit_t::high_impedance, vlog_bit_t::unknown,
                vlog_bit_t::high_impedance, vlog_bit_t::unknown};
    input = "{2'b10{{1'bx,1'bz}}}";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::zero, vlog_bit_t::zero, vlog_bit_t::one,
                vlog_bit_t::one};
    input = "{{2'h2{1'b1}},{2'd2{1'b0}}}";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with repetition") {
    expected = {
        vlog_bit_t::high_impedance,
        vlog_bit_t::unknown,
        vlog_bit_t::high_impedance,
        vlog_bit_t::unknown,
    };
    input = "{2'd2{2'bxz}}";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {vlog_bit_t::high_impedance, vlog_bit_t::unknown,
                vlog_bit_t::high_impedance, vlog_bit_t::unknown,
                vlog_bit_t::high_impedance, vlog_bit_t::unknown,
                vlog_bit_t::high_impedance, vlog_bit_t::unknown};
    input = "{2'd2{{2'd2{2'bxz}}}}";
    REQUIRE(grammar.Parse(input) == expected);

    expected = {
        vlog_bit_t::high_impedance,
        vlog_bit_t::unknown,
        vlog_bit_t::high_impedance,
        vlog_bit_t::unknown,
    };
    input = "{1'b1{{2'bxz, 2'bxz}}}";
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with invalid binary character") {
    input = "4'b1021";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with invalid hex character") {
    input = "4'hG";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with invalid length") {
    input = "-4'b1010";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
    input = "0'b1010";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
    input = "{1'd0{1'b1}}";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test without or invalid format identifier") {
    input = "3'011";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
    input = "8'bbb";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }
}