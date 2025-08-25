#pragma once

#include <memory>

#include "Hardware/Circuit.hpp"
#include "Hardware/Expression.hpp"
#include "Hardware/Library.hpp"

class Enabler {
 public:
  Enabler(Expression const* glitch_expr, Expression const* propagation_expr,
          const std::vector<uint64_t*>& inputs, 
          uint64_t* glitch_output, uint64_t* propagation_output);

  void EvalGlitch(uint64_t step_idx);
  void EvalPropagation(uint64_t step_idx);
  uint64_t GetPropagationValue(uint64_t step_idx) const;

 private:
  Expression const* glitch_expr_;
  Expression const* propagation_expr_;
  std::vector<uint64_t*> inputs_;
  uint64_t* glitch_output_;
  uint64_t* propagation_output_;
};
