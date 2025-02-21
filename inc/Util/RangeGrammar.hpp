/**
 * @file RangeGrammar.hpp
 * @brief A grammar for parsing a list of numbers.
 *
 * @version 0.0.1
 * @date 2025-02-21
 *
 * @author Nicolai Müller
 * @author Amir Moradi
 */
#pragma once

#include <boost/phoenix/phoenix.hpp>    // For e.g. _val
#include <boost/spirit/include/qi.hpp>  // For e.g. double_

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;

/**
 * @brief A grammar for parsing a range of numbers.
 * @details The grammar is used to parse single numbers in the form of "x" or
 * ranges in the form of "x-y".
 *
 * @note Examples, are outlined as test cases under
 * tests/Util/RangeGrammar.cpp.
 */
class RangeGrammar
    : public qi::grammar<std::string::iterator, std::pair<double, double>(),
                         qi::space_type> {
 public:
  RangeGrammar();

  /**
   * @brief Parses a number range into a std::pair<double, double>.
   * @param range The number range as a string.
   * @return The parsed number range as a std::pair<double, double>.
   * @throws std::invalid_argument If the number range is invalid.
   */
  std::pair<double, double> Parse(std::string& range);

 private:
  qi::rule<std::string::iterator, double(), qi::space_type> number_;
  qi::rule<std::string::iterator, std::pair<double, double>(), qi::space_type>
      range_;

  /**
   * @brief Constructs a std::pair based on two doubles.
   * @param lhs The left-hand side of the range.
   * @param rhs The right-hand side of the range.
   * @return The parsed number range as a std::pair<double, double>.
   * @throws std::invalid_argument If one of the bounds is smaller than zero.
   */
  std::pair<double, double> Construct(double lhs, double rhs);
};