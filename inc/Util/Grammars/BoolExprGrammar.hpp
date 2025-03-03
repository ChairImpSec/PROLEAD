/**
 * @file BoolExprGrammar.hpp
 * @brief A grammar for parsing Boolean Expressions.
 *
 * @version 0.0.1
 * @date 2025-02-28
 *
 * @author Nicolai Müller
 */
#pragma once

#include <boost/algorithm/string.hpp>   // For e.g. replace_all_copy
#include <boost/phoenix/phoenix.hpp>    // For e.g. _val
#include <boost/spirit/include/qi.hpp>  // For e.g. lit
#include <cinttypes>                    // For uint64_t
#include <functional>                   // For std::function
#include <unordered_map>                // For std::unordered_map
#include <vector>                       // For std::vector

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;

/**
 * @brief We represent all possible operands of a Boolean expression as static
 * functions.
 */
extern std::function<uint64_t(uint64_t, uint64_t)> Zero, One, Not, And, Or, Xor;

class Clause {
 public:
  Clause(uint64_t lhs_idx, uint64_t rhs_idx,
         const std::function<uint64_t(uint64_t, uint64_t)>* op);
  bool operator==(const Clause& other) const;
  uint64_t Eval(const std::vector<uint64_t>& vals) const;

 private:
  uint64_t lhs_idx_;  ///< Index of the left hand side operand.
  uint64_t rhs_idx_;  ///< Index of the right hand side operand.
  const std::function<uint64_t(uint64_t, uint64_t)>* op_;  ///< Operation.
};

/**
 * @brief A grammar for parsing a Boolean expression.
 * @details The following operations are supported:
 * - |: Boolean or, i.e. i0 or i1
 * - ^: Boolean xor, i.e. i0 xor i1
 * - &: Boolean and, i.e. i0 and i1
 * - ~: Boolean negate, i.e. not i0
 * - 0: Logic zero, false
 * - 1: Logic one, true
 *
 * Further, brackets for prioritizing operations are supported.
 *
 * @note Examples, are outlined as test cases under
 * tests/Util/Grammar/BoolExprGrammar.cpp.
 */
class BoolExprGrammar
    : public qi::grammar<std::string::iterator, uint64_t(), qi::space_type> {
 public:
  BoolExprGrammar();
  std::vector<Clause> Parse(const std::string& expr,
                            const std::vector<std::string>& names);
  std::vector<Clause> clauses_;
  uint64_t number_of_inputs_;

 private:
  uint64_t SetClause(uint64_t lhs, uint64_t rhs,
                     const std::function<uint64_t(uint64_t, uint64_t)>* op);

  qi::rule<std::string::iterator, uint64_t(), qi::space_type> or_term, xor_term,
      and_term, not_term, var, zero, one;
};