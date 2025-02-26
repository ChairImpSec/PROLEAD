#pragma once
#define BOOST_BIND_GLOBAL_PLACEHOLDERS
#define BOOST_SPIRIT_DEBUG
#include <algorithm>
#include <boost/phoenix.hpp>
#include <boost/variant.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/spirit/include/qi.hpp>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

#include "Hardware/LibHelper.hpp"

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;

enum class op_t { undef, and_op, or_op, xor_op, not_op, zero_const, one_const };

// Stores first the operation as string, and secondly the amount of inputs
extern std::vector<std::pair<std::string, std::vector<std::string>>> operation_library;
extern std::vector<std::pair<std::string, std::vector<std::string>>> probe_extension_library;
extern std::vector<std::pair<std::string, std::vector<std::string>>> glitch_propagation_library;

struct ExpressionTree {
  op_t operation;
  std::vector<unsigned int> variables;
  std::vector<ExpressionTree> subclauses;

  ExpressionTree() = default;
  ExpressionTree(op_t op, const ExpressionTree& clause);
  ExpressionTree(op_t op, const ExpressionTree& left,
                 const ExpressionTree& right);
  ExpressionTree(op_t op);
  ExpressionTree(unsigned int variable);
};

class CustomOperation {
 public:
  CustomOperation() = default;
  CustomOperation(ExpressionTree& tree, size_t number_of_inputs);
  size_t GetNumberOfClauses() const;
  unsigned int GetNumberOfOperandsInClause(unsigned int clause_index) const;
  op_t GetOperationInClause(unsigned int clause_index) const;
  unsigned int GetOperandInClause(unsigned int clause_index,
                                  unsigned int input_index) const;

  CustomOperation(op_t operation_type, std::vector<unsigned int> input_signals);
  bool operator==(const CustomOperation& other) const;

 private:
  std::vector<op_t> operation_of_clause_;
  std::vector<std::vector<unsigned int>> operands_in_clause_;

  void SetClause(op_t operation, std::vector<unsigned int>& operands);
};

class BooleanExpressionGrammar
    : public qi::grammar<std::string::iterator, ExpressionTree(),
                         qi::space_type> {
 public:
  BooleanExpressionGrammar();

 private:
  qi::rule<std::string::iterator, ExpressionTree(), qi::space_type> or_term,
      xor_term, and_term, not_term, variable, const_zero, const_one, restart_parser;
};

template <typename OperationContainer>
class Operation {
 public:
  Operation();
  Operation(std::string expression, std::vector<std::string> names);
  Operation(op_t operation_type, std::vector<unsigned int>& input_signals);
  uint64_t Evaluate(std::vector<uint64_t> input_values) const; // Cannot be given as reference as the input vector is modified internally!
  /**
   * @brief Checks if two operations return the same result for all possible operations
   * @param other The other Operation that is checked for equivalence
   * @return true Both operations return the same value for all inputs
   * @return false There is at least one input where the outputs differ
   * @author Simon Osterheider
   */
  bool IsEquivalentTo(Operation& other);
  bool operator==(const Operation& other) const;

  OperationContainer GetOperationContainer(){
    return operation_;
  }

  size_t GetAmountInputs();

 private:
  OperationContainer operation_;
  size_t amount_of_inputs_;
};

