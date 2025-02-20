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

#include <algorithm>                    // For remove
#include <boost/phoenix/phoenix.hpp>    // For e.g. _val
#include <boost/spirit/include/qi.hpp>  // For e.g. lit
#include <cmath>                        // For log2
#include <string>                       // For stoi

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
  std::vector<vlog_bit_t> Parse(std::string& vlog_const);

 private:
  qi::rule<std::string::iterator, std::string(), qi::space_type> bin_val,
      hex_val;
  qi::rule<std::string::iterator, std::vector<vlog_bit_t>(), qi::space_type>
      accum, bin, concat, dec, expr, hex, inv, rep, reg;
  qi::rule<std::string::iterator, uint64_t(), qi::space_type> bin_nr, dec_nr,
      dec_val, hex_nr, rep_nr, width;

  std::vector<vlog_bit_t> Invert(std::vector<vlog_bit_t>& value);
  std::vector<vlog_bit_t> Repeat(uint64_t number_of_reps,
                                 std::vector<vlog_bit_t>& value);
  std::vector<vlog_bit_t> Append(std::vector<std::vector<vlog_bit_t>>& values);

  uint64_t ParseRepCount(uint64_t width_in_bits, uint64_t value);
  std::vector<vlog_bit_t> ParseBin(uint64_t width_in_bits, std::string value);
  std::vector<vlog_bit_t> ParseDec(uint64_t width_in_bits, uint64_t value);
  std::vector<vlog_bit_t> ParseHex(uint64_t width_in_bits, std::string value);
};