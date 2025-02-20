/**
 * @file VlogConstGrammar.hpp
 * @brief A grammar for parsing a Verilog constant.
 *
 * @version 0.0.1
 * @date 2025-02-19
 *
 * @author Nicolai Müller
 */
#pragma once

#include <boost/phoenix/phoenix.hpp>    // For e.g. _val
#include <boost/spirit/include/qi.hpp>  // For e.g. lit
#include <cmath>                        // For log2

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;

/**
 * @brief Represents the possible values of a Verilog bit.
 *
 * @details following constants are supported in Verilog constants:
 * - 0: Logic zero, false
 * - 1: Logic one, true
 * - $: Random logic value
 * - x or X: Unknown or undefined value
 * - z or Z: High impedance value
 */
enum class vlog_bit_t { zero, one, random, unknown, high_impedance };

/**
 * @brief A grammar for parsing a Verilog constant.
 * @details The general structure is expr = width'radix value
 * The following radices are supported:
 * - b or B: Binary
 * - d or D: Decimal (only with positive integer values)
 * - h or H: Hexadecimal
 *
 * Further, the following (nested) statements are supported:
 * - Concatentation: {expr, expr, ...}
 * - Repetition: {expr_nr{expr}} (only with positive integer values for expr_nr)
 * - Inversion: ~expr
 *
 * @note Examples, are outlined as test cases under
 * tests/Util/VlogConstGrammar.cpp.
 */
class VlogConstGrammar
    : public qi::grammar<std::string::iterator, std::vector<vlog_bit_t>(),
                         qi::space_type> {
 public:
  VlogConstGrammar();

  /**
   * @brief Parses a Verilog constant as a string into a vector of vlog_bit_t.
   * @param vlog_const The Verilog constant as a string.
   * @return The parsed Verilog constant as a vector of vlog_bit_t.
   */
  std::vector<vlog_bit_t> Parse(std::string& vlog_const);

 private:
  qi::rule<std::string::iterator, std::string(), qi::space_type> bin_val,
      hex_val;
  qi::rule<std::string::iterator, std::vector<vlog_bit_t>(), qi::space_type>
      accum, bin, concat, dec, expr, hex, inv, rep, reg;
  qi::rule<std::string::iterator, uint64_t(), qi::space_type> bin_nr, dec_nr,
      dec_val, hex_nr, rep_nr, width;

  /**
   * @brief Inverts a parsed Verilog constant, i.e. by changing every
   * vlog_bit_t::zero to vlog_bit_t::one and vice versa.
   * @param value The parsed Verilog constant.
   * @return The inverted Verilog constant.
   */
  std::vector<vlog_bit_t> Invert(std::vector<vlog_bit_t>& value);

  /**
   * @brief Repeats a parsed Verilog constant a given number of times.
   * @param number_of_reps The number of repetitions.
   * @param value The parsed Verilog constant.
   * @return The repeated Verilog constant.
   * @throws std::invalid_argument If the number of repetitions is zero.
   */
  std::vector<vlog_bit_t> Repeat(uint64_t number_of_reps,
                                 std::vector<vlog_bit_t>& value);

  /**
   * @brief Flattens a vector of vectors of vlog_bit_t into a single vector by
   * concatenating the vectors.
   * @param values The vector of vectors of vlog_bit_t.
   * @return The flattened vector of vlog_bit_t.
   */
  std::vector<vlog_bit_t> Flatten(std::vector<std::vector<vlog_bit_t>>& values);

  /**
   * @brief Checks if the width of an integer matches the expected width.
   * @param width_in_bits The expected width in bits.
   * @param value The integer to check.
   * @return The integer to check.
   * @throws std::invalid_argument If the width of the integer does not match
   * the expected width.
   */
  uint64_t CheckWidth(uint64_t width_in_bits, uint64_t value);

  /**
   * @brief Parses a binary Verilog constant.
   * @param width_in_bits The width of the Verilog constant in bits.
   * @param value The binary Verilog constant as a string.
   * @return The parsed Verilog constant as a vector of vlog_bit_t.
   * @throws std::invalid_argument If the length of the binary constant does
   * not match the expected width.
   */
  std::vector<vlog_bit_t> ParseBin(uint64_t width_in_bits, std::string value);

  /**
   * @brief Parses a decimal Verilog constant.
   * @param width_in_bits The width of the Verilog constant in bits.
   * @param value The decimal Verilog constant as a string.
   * @return The parsed Verilog constant as a vector of vlog_bit_t.
   * @throws std::invalid_argument If the length of the decimal constant does
   * not match the expected width.
   */
  std::vector<vlog_bit_t> ParseDec(uint64_t width_in_bits, uint64_t value);

  /**
   * @brief Parses a hexadecimal Verilog constant.
   * @param width_in_bits The width of the Verilog constant in bits.
   * @param value The hexadecimal Verilog constant as a string.
   * @return The parsed Verilog constant as a vector of vlog_bit_t.
   * @throws std::invalid_argument If the length of the hexadecimal constant
   * does not match the expected width.
   */
  std::vector<vlog_bit_t> ParseHex(uint64_t width_in_bits, std::string value);
};