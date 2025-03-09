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
#include "Util/Grammars/SignalNameGrammar.hpp"

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
  Expression(const std::string& expression,
             const std::vector<std::string>& names,
             const std::vector<std::pair<std::string, uint64_t>>& params);

  /**
   * @brief Evaluates the expression.
   * @param vals The values of the inputs.
   * @return The result of the evaluation.
   */
  uint64_t Eval(std::vector<uint64_t> vals) const;

  // private:
  std::vector<Clause> clauses_;  ///< The clauses of the expression. Will be
                                 ///< evaluated sequentially.
};