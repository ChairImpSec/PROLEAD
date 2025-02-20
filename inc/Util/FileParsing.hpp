/**
 * @file FileParsing.hpp
 * @author Nicolai Müller
 */

#pragma once
#define BOOST_BIND_GLOBAL_PLACEHOLDERS
#define BOOST_SPIRIT_DEBUG
#include <boost/bind.hpp>
#include <boost/fusion/include/adapt_struct.hpp>
#include <boost/fusion/include/io.hpp>
#include <boost/json.hpp>
#include <boost/phoenix.hpp>
#include <boost/phoenix/core.hpp>
#include <boost/phoenix/object.hpp>
#include <boost/phoenix/operator.hpp>
#include <boost/spirit/include/qi.hpp>
#include <cassert>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <memory>
#include <regex>

#include "Util/VlogConstGrammar.hpp"

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;
namespace js = boost::json;

enum class ValueType { arary, variable, standard };

class JsonSchema {
 public: 
  JsonSchema(const std::string& key, const std::string& type);
  JsonSchema(const std::string& key, const std::string& type, const std::vector<JsonSchema>& children);
  void Validate(const boost::json::object& json_object);

 private:
  std::string key_;
  std::string type_;
  std::vector<JsonSchema> children_;
};

class InputAssignment {
 public:
  bool is_inverted_;
  uint64_t share_index_;
  std::vector<uint64_t> group_indices_;
  ValueType type_;
  std::vector<std::string> signal_names_;
  std::vector<uint64_t> signal_indices_;
  std::vector<vlog_bit_t> signal_values_;
};

/**
 * @brief A grammar for parsing a range of integers.
 * @details The grammar is used to parse a range of integers in the form of "x"
 * or "x-y". The range is represented as a pair of integers, where the first
 * integer is the lower or equal to the second integer.
 */
class IntegerRangeGrammar
    : public qi::grammar<std::string::iterator, std::pair<uint64_t, uint64_t>(),
                         qi::space_type> {
 public:
  IntegerRangeGrammar(uint64_t maximum_value);
  std::pair<uint64_t, uint64_t> Parse(std::string& integer_range_string);

 private:
  qi::rule<std::string::iterator, std::pair<uint64_t, uint64_t>(),
           qi::space_type>
      range_;
};

class InputAssignmentGrammar
    : public qi::grammar<std::string::iterator, InputAssignment(),
                         qi::space_type> {
 public:
  InputAssignmentGrammar();
  InputAssignment Parse(std::string& input_assignment_string);

 private:
  qi::rule<std::string::iterator, std::string(), qi::space_type> bin_value,
      hex_value, shared_value, constant_value, index, range;
  qi::rule<std::string::iterator, InputAssignment(), qi::space_type> value;
  InputAssignment result_;
  int64_t left_index_, right_index_;
};

/**
 * @class IrreduciblePolynomialGrammar
 * @brief Grammar definition for parsing irreducible polynomials.
 * @details This grammar is used for parsing irreducible polynomials with terms
 * of the form "ax^b" where "a" and "b" are unsigned integers. The grammar
 * supports positive integer coefficients for monomials, optional exponents for
 * the variable "x", and addition of multiple monomials to form a polynomial.
 * For example "3x^2 + 2x + 1" is parsed into a vector of pairs: {(3, 2), (2,
 * 1), (1,0)}.
 */
class IrreduciblePolynomialGrammar
    : public qi::grammar<std::string::iterator,
                         std::vector<std::pair<uint64_t, uint64_t>>(),
                         qi::space_type> {
 public:
  IrreduciblePolynomialGrammar();
  std::vector<uint64_t> Parse(std::string& polynomial_string, uint64_t base,
                              uint64_t exponent);

 private:
  qi::rule<std::string::iterator, uint64_t(), qi::space_type> base_;
  qi::rule<std::string::iterator, uint64_t(), qi::space_type> exponent_;
  qi::rule<std::string::iterator, std::pair<uint64_t, uint64_t>(),
           qi::space_type>
      monomial_;
  qi::rule<std::string::iterator, std::vector<std::pair<uint64_t, uint64_t>>(),
           qi::space_type>
      polynomial_;
};

/**
 * @brief A grammar for parsing a signal name.
 * @details The grammar is used to parse a signal name or the composition of
 * multiple signal names in the form of "signale_name", "signal_name[0:9]", or
 * "{signal_name1,signal_name2,signal_name[0:9]}". It returns a vector of
 * strings, where each string represents a signal name. The signal name can be a
 * single signal name or a signal name with an index in the form of
 * "signal_name[0]" or "signal_name[1]".
 */
class SignalNameGrammar
    : public qi::grammar<std::string::iterator, std::vector<std::string>(),
                         qi::space_type> {
 public:
  SignalNameGrammar();
  std::vector<std::string> Parse(std::string& signal_name_string);

 private:
  qi::rule<std::string::iterator, std::vector<std::string>(), qi::space_type>
      value;
  qi::rule<std::string::iterator, std::vector<std::string>(), qi::space_type>
      vector_name;
  qi::rule<std::string::iterator, std::string(), qi::space_type> identifier;
  qi::rule<std::string::iterator, std::string(), qi::space_type> signal_name;
  qi::rule<std::string::iterator, std::string(), qi::space_type>
      signal_with_range;
  qi::rule<std::string::iterator, std::string(), qi::space_type>
      signal_with_index;
  qi::rule<std::string::iterator, std::string(), qi::space_type>
      signal_without_index_or_range;
  qi::rule<std::string::iterator, std::string(), qi::space_type> index;
  uint64_t left_index;
  std::string current_identifier;
  std::vector<std::string> result;
};

/**
 * @brief Opens a file for reading.
 * @param path The filesystem path to the file to be opened.
 * @return An ifstream object representing the opened file stream.
 * @throws A std::runtime_error if the file cannot be opened.
 */
std::ifstream OpenFile(const std::filesystem::path& path);

/**
 * @brief Parses a JSON file.
 * @param path The filesystem path to the JSON file to be parsed.
 * @return A js::object representing the parsed JSON file.
 * @throws A js::system_error if the file cannot be opened or if the
 * file cannot be parsed as JSON.
 */
js::object ParseJsonFile(const std::filesystem::path& path);

/**
 * @brief Checks if the type of a JSON object's value matches the expected type.
 * @param json_object The JSON object to be checked.
 * @param key The key of the value to be checked.
 * @param expected_type The expected type of the value.
 * @throws A std::runtime_error if the value's type does not match the expected
 * type.
 */
void CheckValueType(const js::object& json_object, const std::string& key,
                    js::kind expected_type);

/**
 * @brief Sets the value of a variable to the value of a JSON object's key.
 * @tparam T The type of the variable.
 * @param json_object The JSON object containing the key-value pair.
 * @param key The key of the value to be set.
 * @param variable The variable to be set.
 * @throws A std::runtime_error if the value's data type is unknown.
 */
template <typename T>
bool SetValue(const js::object& json_object, const std::string& key,
              T& variable);