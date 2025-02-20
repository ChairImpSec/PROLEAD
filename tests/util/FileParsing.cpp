#include "Util/FileParsing.hpp"

#include <catch2/catch.hpp>

TEST_CASE("Test the IntegerRangeGrammar parser", "[IntegerRangeGrammar]") {
  IntegerRangeGrammar grammar(10);
  std::string input;
  std::pair<uint64_t, uint64_t> expected, result;

  SECTION("Test with valid range") {
    input = "1-5";
    expected = std::make_pair(1, 5);
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with single valid integer") {
    input = "5";
    expected = std::make_pair(5, 5);
    REQUIRE(grammar.Parse(input) == expected);
  }

  SECTION("Test with invalid range") {
    input = "5-15";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with single invalid integer") {
    input = "15";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with negative range") {
    input = "-5-10";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }

  SECTION("Test with single negative integer") {
    input = "-5";
    REQUIRE_THROWS_AS(grammar.Parse(input), std::invalid_argument);
  }
}

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
  }

  SECTION("Test valid identifiers with range") {
    input = "signal[0:0]";
    expected = {"signal[0]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[2:0]";
    expected = {"signal[0]", "signal[1]", "signal[2]"};
    REQUIRE(expected == grammar.Parse(input));

    input = "signal[0:2]";
    expected = {"signal[2]", "signal[1]", "signal[0]"};
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

TEST_CASE("Test the InputAssignmentGrammar parser",
          "[InputAssignmentGrammar]") {
  InputAssignmentGrammar grammar;
  std::string input;
  InputAssignment received;
  std::vector<uint64_t> expected;

  SECTION("Test valid shared assignments") {
    input = "group_in2[7:4]";
    expected = {4, 5, 6, 7};
    received = grammar.Parse(input);
    REQUIRE(received.is_inverted_ == false);
    REQUIRE(received.share_index_ == 2);
    REQUIRE(received.group_indices_ == expected);
    REQUIRE(received.signal_names_.empty());
    REQUIRE(received.signal_values_.empty());

    input = "~group_in3[4:7]";
    expected = {7, 6, 5, 4};
    received = grammar.Parse(input);
    REQUIRE(received.is_inverted_ == true);
    REQUIRE(received.share_index_ == 3);
    REQUIRE(received.group_indices_ == expected);
    REQUIRE(received.signal_names_.empty());
    REQUIRE(received.signal_values_.empty());

    input = "~8'hE$";
    std::vector<vlog_bit_t> bits = {
        vlog_bit_t::random, vlog_bit_t::random,
        vlog_bit_t::random, vlog_bit_t::random,
        vlog_bit_t::one,    vlog_bit_t::zero,
        vlog_bit_t::zero,   vlog_bit_t::zero};
    received = grammar.Parse(input);
    REQUIRE(received.is_inverted_ == true);
    REQUIRE(received.share_index_ == 0);
    REQUIRE(received.group_indices_.empty());
    REQUIRE(received.signal_names_.empty());
    REQUIRE(received.signal_values_ == bits);
  }
}

TEST_CASE("Test the IrreduciblePolynomialGrammar parser",
          "[IrreduciblePolynomialGrammar]") {
  SECTION("Test valid Polynomials") {
    auto [polynomial, expected, base,
          exponent] = GENERATE(table<std::string, std::vector<uint64_t>,
                                     uint64_t, uint64_t>(
        {{"3x^2 + 2x + 1", {1, 2, 3}, 4, 2},
         {"5x^3 + 4x^2 + x + 7", {7, 1, 4, 5}, 8, 3},
         {"x^4 + 3x^3 + 2x^2 + 7x + 5", {5, 7, 2, 3, 1}, 8, 4},
         {"2x^5 + x^4 + 4x^3 + 3x^2 + 2x + 1", {1, 2, 3, 4, 1, 2}, 5, 5},
         {"7x^6 + x^3 + 5x + 8", {8, 5, 0, 1, 0, 0, 7}, 9, 6},
         {"3x^7 + 2x^5 + x^4 + x^2 + 6", {6, 0, 1, 0, 1, 2, 0, 3}, 7, 7},
         {"4x^8 + 3x^6 + 2x^4 + x^2 + 5", {5, 0, 1, 0, 2, 0, 3, 0, 4}, 6, 8},
         {"x^9 + x^7 + x^5 + x^3 + x", {0, 1, 0, 1, 0, 1, 0, 1, 0, 1}, 2, 9},
         {"2x^10 + 3x^8 + 4x^6 + 5x^4 + 6x^2 + 7",
          {7, 0, 6, 0, 5, 0, 4, 0, 3, 0, 2},
          8,
          10},
         {"6x^11 + 5x^9 + 4x^7 + 3x^5 + 2x^3 + x",
          {0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6},
          7,
          11}}));

    IrreduciblePolynomialGrammar grammar;
    REQUIRE(expected == grammar.Parse(polynomial, base, exponent));
  }

  SECTION("Test valid Polynomials with aren't minimized and unordered") {
    auto [polynomial, expected, base, exponent] =
        GENERATE(table<std::string, std::vector<uint64_t>, uint64_t, uint64_t>(
            {{"x^2 + 1 + x^2 + x + x^2 + x", {1, 2, 3}, 4, 2},
             {"3x^3 + 5 + 3x^2 + x + 2 + x^2 + 2x^3", {7, 1, 4, 5}, 8, 3}}));

    IrreduciblePolynomialGrammar grammar;
    REQUIRE(expected == grammar.Parse(polynomial, base, exponent));
  }

  SECTION("Test invalid Polynomials") {
    auto [polynomial, expected, base, exponent] =
        GENERATE(table<std::string, std::vector<uint64_t>, uint64_t, uint64_t>(
            {{"x^2 + 1 + x^2 + x + x^2 + x", {1, 2, 3}, 3, 2},
             {"3x^3 + 5 + 3x^2 + x + 2 + x^2 + 2x^3", {7, 1, 4, 5}, 8, 2}}));

    IrreduciblePolynomialGrammar grammar;
    REQUIRE_THROWS_AS(grammar.Parse(polynomial, base, exponent),
                      std::invalid_argument);
  }
}

TEST_CASE("Test the OpenFile function", "[OpenFile]") {
  SECTION("Opens a file correctly when given a valid path") {
    std::filesystem::path valid_path = "library.json";
    REQUIRE_NOTHROW(OpenFile(valid_path));
    std::ifstream stream = OpenFile(valid_path);
    REQUIRE(stream.is_open());
  }

  SECTION("Throws an exception when given a non existent path") {
    std::filesystem::path invalid_path = "non_existent_file_path.json";
    REQUIRE_THROWS_AS(OpenFile(invalid_path), std::runtime_error);
  }
}

TEST_CASE("Test the ParseJsonFile function", "[ParseJsonFile]") {
  SECTION("Correctly parses a JSON file when given a valid path") {
    std::filesystem::path valid_path = "library.json";
    REQUIRE_NOTHROW(ParseJsonFile(valid_path));
  }

  SECTION("Throws an exception when given a non existent path") {
    std::filesystem::path invalid_path = "non_existent_file_path";
    REQUIRE_THROWS_AS(ParseJsonFile(invalid_path), std::runtime_error);
  }
}

TEST_CASE("Test theCheckValueType function", "[CheckValueType]") {
  js::object json_object = {{"int64", 123},
                            {"double", 123.456},
                            {"string", "abc"},
                            {"bool", true},
                            {"array", js::array{1, 2, 3}},
                            {"object", js::object{{"key", "value"}}}};

  SECTION(
      "Does not throw an exception when the value type of the specified key "
      "matches the expected type") {
    REQUIRE_NOTHROW(CheckValueType(json_object, "int64", js::kind::int64));
    REQUIRE_NOTHROW(CheckValueType(json_object, "double", js::kind::double_));
    REQUIRE_NOTHROW(CheckValueType(json_object, "string", js::kind::string));
    REQUIRE_NOTHROW(CheckValueType(json_object, "bool", js::kind::bool_));
    REQUIRE_NOTHROW(CheckValueType(json_object, "array", js::kind::array));
    REQUIRE_NOTHROW(CheckValueType(json_object, "object", js::kind::object));
  }

  SECTION(
      "Throws an exception when the value type of the specified key does not "
      "match the expected type") {
    REQUIRE_THROWS_AS(CheckValueType(json_object, "int64", js::kind::string),
                      std::runtime_error);
    REQUIRE_THROWS_AS(CheckValueType(json_object, "int64", js::kind::bool_),
                      std::runtime_error);
  }
}

TEST_CASE("Test the SetValue function", "[SetValue]") {
  js::object json_object = {{"int64", -1},
                            {"uint64", 1234567890},
                            {"double", 123.456},
                            {"string", "test"},
                            {"bool", true},
                            {"array", js::array{1, 2, 3}},
                            {"object", js::object{{"key", "value"}}}};

  SECTION("Test uint64") {
    uint64_t variable = 0;
    SetValue(json_object, "uint64", variable);
    REQUIRE(variable == 1234567890);
  }

  SECTION("Test double") {
    double variable = 0.0;
    SetValue(json_object, "double", variable);
    REQUIRE(variable == 123.456);
  }

  SECTION("Test string") {
    std::string variable;
    SetValue(json_object, "string", variable);
    REQUIRE(variable == "test");
  }

  SECTION("Test bool") {
    bool variable = false;
    SetValue(json_object, "bool", variable);
    REQUIRE(variable == true);
  }

  SECTION("Test array") {
    js::array variable;
    SetValue(json_object, "array", variable);
    REQUIRE(variable == js::array{1, 2, 3});
  }

  SECTION("Test object") {
    js::object variable;
    SetValue(json_object, "object", variable);
    REQUIRE(variable == js::object{{"key", "value"}});
  }

  SECTION("Test negative number") {
    uint64_t variable = 0.0f;
    REQUIRE_THROWS_AS(SetValue(json_object, "int64", variable),
                      std::runtime_error);
  }
}