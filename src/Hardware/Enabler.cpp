#include "Hardware/Enabler.hpp"

Enabler::Enabler(Expression const* glitch_expr, Expression const* propagation_expr,
  const std::vector<uint64_t*>& inputs, 
  uint64_t* glitch_output, uint64_t* propagation_output) 
  : glitch_expr_(glitch_expr), propagation_expr_(propagation_expr), inputs_(inputs), 
    glitch_output_(glitch_output), propagation_output_(propagation_output) {}

void Enabler::EvalGlitch(uint64_t step_idx) {
  if (glitch_expr_ == nullptr) {
    glitch_output_[step_idx] = UINT64_MAX;
  } else {
    std::vector<uint64_t> inputs;
    inputs.reserve(inputs_.size());
    for (const uint64_t* input : inputs_) {
      inputs.push_back(input[step_idx]);
    }

    glitch_output_[step_idx] = glitch_expr_->Eval(inputs);
  }
}

void Enabler::EvalPropagation(uint64_t step_idx) {
  if (propagation_expr_ == nullptr) {
    propagation_output_[step_idx] = UINT64_MAX;
  } else {
    std::vector<uint64_t> inputs;
    inputs.reserve(inputs_.size());
    for (const uint64_t* input : inputs_) {
      inputs.push_back(input[step_idx]);
    }

    propagation_output_[step_idx] = propagation_expr_->Eval(inputs);
  }
}

uint64_t Enabler::GetPropagationValue(uint64_t step_idx) const {
  assert(propagation_output_ != nullptr && "Error in Enabler::GetPropagationValue(): Propagation output is NULL!");
  return propagation_output_[step_idx];
}