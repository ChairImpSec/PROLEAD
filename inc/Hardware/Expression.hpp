/**
 * @file Expression.hpp
 * @brief Declares the Expression class.
 *
 * @version 0.0.1
 * @date 2025-03-01
 *
 * @author Nicolai Müller
 * @author Simon Osterheider
 */
#pragma once

#include "Hardware/LibHelper.hpp"
#include "Util/Grammars/BoolExprGrammar.hpp"

extern std::vector<std::pair<std::string, std::vector<std::string>>> expr_lib;
extern std::vector<std::pair<std::string, std::vector<std::string>>>
    expr_probe_prop_lib;
extern std::vector<std::pair<std::string, std::vector<std::string>>>
    expr_glitch_ext_lib;

/**
 * @brief The class represents a Boolean expression.
 */
class Expression {
 public:
  /**
   * @brief Constructs an Expression object.
   * @param expression The Boolean expression.
   * @param names The names of the inputs.
   */
  Expression(const std::string& expression, std::vector<std::string> names);

  /**
   * @brief Returns the number of inputs.
   * @return The number of inputs.
   */
  uint64_t GetNumberOfInputs() const;

  /**
   * @brief Evaluates the expression.
   * @param vals The values of the inputs.
   * @return The result of the evaluation.
   */
  uint64_t Eval(std::vector<uint64_t> vals) const;

 private:
  uint64_t number_of_inputs_;
  std::vector<Clause> clauses_;  ///< The clauses of the expression. Will be
                                 ///< evaluated sequentially.
};