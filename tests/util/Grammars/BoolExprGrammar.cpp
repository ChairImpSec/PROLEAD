#include "Util/Grammars/BoolExprGrammar.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the parser for Boolean Expressions", "[BoolExprGrammar]") {
  BoolExprGrammar grammar;
  std::string input;
  std::vector<Clause> expected;
  std::vector<std::string> names;

  SECTION("Test with constants") {
    input = "0";
    names = {};
    expected = {Clause(0, 0, &Zero)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "1";
    names = {};
    expected = {Clause(0, 0, &One)};
    REQUIRE(grammar.Parse(input, names) == expected);
  }

  SECTION("Test with single operand") {
    input = "not A";
    names = {"A"};
    expected = {Clause(0, 0, &Not)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A and B";
    names = {"A", "B"};
    expected = {Clause(0, 1, &And)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "not (A and B)";
    names = {"A", "B"};
    expected = {Clause(0, 1, &And), Clause(2, 0, &Not)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A or B";
    names = {"A", "B"};
    expected = {Clause(0, 1, &Or)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "not (A or B)";
    names = {"A", "B"};
    expected = {Clause(0, 1, &Or), Clause(2, 0, &Not)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A xor B";
    names = {"A", "B"};
    expected = {Clause(0, 1, &Xor)};
    REQUIRE(grammar.Parse(input, names) == expected);
  
    input = "not (A xor B)";
    names = {"A", "B"};
    expected = {Clause(0, 1, &Xor), Clause(2, 0, &Not)};
    REQUIRE(grammar.Parse(input, names) == expected);  
  }

  SECTION("Test full expressions") {
    input = "A and B or C";
    names = {"A", "B", "C"};
    expected = {Clause(0, 1, &And), Clause(3, 2, &Or)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A or B xor C";
    names = {"A", "B", "C"};
    expected = {Clause(1, 2, &Xor), Clause(0, 3, &Or)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A xor B and C";
    names = {"A", "B", "C"};
    expected = {Clause(1, 2, &And), Clause(0, 3, &Xor)};
    REQUIRE(grammar.Parse(input, names) == expected);

    input = "A and B xor C or D";
    names = {"A", "B", "C", "D"};
    expected = {Clause(0, 1, &And), Clause(4, 2, &Xor), Clause(5, 3, &Or)};
    REQUIRE(grammar.Parse(input, names) == expected);
  }
}