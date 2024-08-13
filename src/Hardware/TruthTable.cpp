#include "Hardware/TruthTable.hpp"

namespace Hardware {
TruthTable::TruthTable(size_t amount_of_inputs) {
  amount_of_inputs_ = amount_of_inputs;
  table_ = std::vector<std::vector<bool>>(1 << amount_of_inputs, std::vector<bool>(2));
}

template <typename T>
std::vector<T> TruthTable::MutateVectorOrder(std::vector<T> const& inputs) {
  if (inputs.size() % 3 != 0) {
    throw std::runtime_error("propagation library expression has amount of inputs not divisible by 3 : ");
  }
  std::vector<T> mutated_inputs(inputs.size());
  // To turn into the structure a' a g_a ...
  std::vector<uint8_t> type_order{1,0,2};
  uint64_t mutated_index = 0;
  for (uint8_t input_index = 0; input_index < (inputs.size() / 3); ++input_index) {
    for (auto type_index : type_order) {
      mutated_inputs[mutated_index] = inputs[type_index * (inputs.size() / 3) + input_index];
      ++mutated_index;
    }
  }
  return mutated_inputs;
}

template std::vector<uint64_t> TruthTable::MutateVectorOrder<uint64_t>(std::vector<uint64_t> const& inputs);
template std::vector<std::string> TruthTable::MutateVectorOrder<std::string>(std::vector<std::string> const& inputs);

bool TruthTable::IsEquivalentToOperation(Operation<CustomOperation>& op, bool for_glitch) const {
  if (amount_of_inputs_ != op.GetAmountInputs()) {
    throw std::runtime_error("Truthtable and Operation have diffrent amount of inputs");
  }

  std::vector<bool> input_vector_bool(amount_of_inputs_);
  std::vector<uint64_t> input_vector_num(amount_of_inputs_);
  bool table_output, op_output;
  for (uint64_t input_number = 0; input_number < (1ULL << amount_of_inputs_); ++input_number) {
    BoolVectorFromNumber(input_vector_bool, input_number);
    if (for_glitch) {
      table_output = GetG(input_vector_bool);
    } else {
      table_output = GetF(input_vector_bool);
    }
    BitVectorFromNumber(input_vector_num, input_number);
    op_output = op.Evaluate(MutateVectorOrder(input_vector_num)) & 1;
    if (table_output != op_output) {
      return false;
    }
  }
  return true;
}

bool TruthTable::IsEquivalentToFunction(std::function<uint64_t(std::vector<uint64_t>&)> func, bool for_glitch, std::vector<uint64_t> dont_care_indexes) const {
  std::vector<bool> input_vector_bool(amount_of_inputs_);
  std::vector<uint64_t> input_vector_num(amount_of_inputs_);
  bool table_output, function_output, skip_this_row;
  for (uint64_t input_number = 0; input_number < (1ULL << amount_of_inputs_); ++input_number) {
    skip_this_row = false;
    BoolVectorFromNumber(input_vector_bool, input_number);
    BitVectorFromNumber(input_vector_num, input_number);
    std::vector<uint64_t> function_input = MutateVectorOrder(input_vector_num);
    for (uint64_t i = 0; i < input_vector_bool.size(); ++i) {
      if (function_input[i] == 0) continue;
      for (uint64_t j = 0; j < dont_care_indexes.size(); ++j) {
        if (i == dont_care_indexes[j]) skip_this_row = true;
      }
      if (skip_this_row) break;
    }
    if (skip_this_row) continue;
    if (for_glitch) {
      table_output = GetG(input_vector_bool);
    } else {
      table_output = GetF(input_vector_bool);
    }
    
    std::sort(dont_care_indexes.begin(), dont_care_indexes.end(), std::greater<uint64_t>());
    for (auto dont_care_index : dont_care_indexes) {
      function_input.erase(function_input.begin() + dont_care_index);
    }
    
    function_output = func(function_input) & 1;
    if (table_output != function_output) {
      return false;
    }
  }
  return true;
}

Operation<CustomOperation> TruthTable::OperationFromTruthTable(bool for_glitch) const {
  if (GetAmountOfInputs() > 26) throw std::runtime_error("Truthtable doesn't support more than the alhpabet");
  std::vector<std::string> inputs(GetAmountOfInputs());
  char character;
  for (size_t i = 0; i < GetAmountOfInputs(); ++i) {
    character = 65+i;
    inputs[i] = character;
  }
  std::vector<std::string> and_terms;
  std::vector<std::string> or_terms;
  std::vector<bool> input_set_vector(GetAmountOfInputs());
  for (uint64_t i = 0; i < (1ULL << GetAmountOfInputs()); ++i) {
    and_terms = {};
    BoolVectorFromNumber(input_set_vector, i);
    bool value;
    if (for_glitch) {
      value = GetG(input_set_vector);
    } else {
      value = GetF(input_set_vector);
    }
    if (!value) continue;
    for (size_t input_index = 0; input_index < inputs.size(); ++ input_index) {
      if (input_set_vector[input_index]) {
        and_terms.push_back(inputs[input_index]);
      } else {
        and_terms.push_back("(not " + inputs[input_index] + ")");
      }
    }
    or_terms.push_back(TruthTable::ConstructExpression("and", and_terms));
  }
  std::string cnf_expr = TruthTable::ConstructExpression("or", or_terms);
  return Operation<CustomOperation>(cnf_expr, MutateVectorOrder(inputs));
}

std::string TruthTable::ConstructExpression(std::string op, std::vector<std::string> operands) {
  if (operands.size() == 0) {
      return "";
  }
  std::string result = "(" + operands[0];
  for (size_t i = 1; i < operands.size(); ++i) {
      result += " " + op + " " + operands[i];
  }
  result += ")";
  return result;
}

void TruthTable::PrintTable() const {
  for (uint row_index = 0; row_index < (1U << amount_of_inputs_); ++row_index) {
    for (uint input_index = 0; input_index < amount_of_inputs_; ++input_index) {
      uint8_t input_value = (row_index & (1 << (input_index))) != 0;
      std::cout << std::to_string(input_value) << " ";
    }
    std::cout << ": " << std::to_string(static_cast<uint8_t>(table_[row_index][0])) << " " << std::to_string(static_cast<uint8_t>(table_[row_index][1])) << "\n";
  }
}

std::vector<bool>& TruthTable::GetRowReference(std::vector<bool> index) {
  size_t row_index = 0;
  for (size_t i = 0; i < index.size(); ++i) {
    row_index += (1 << i) * index[i];
  }
  return table_[row_index];
}

std::vector<bool> const& TruthTable::GetConstRowReference(std::vector<bool> index) const {
  size_t row_index = 0;
  for (size_t i = 0; i < index.size(); ++i) {
    row_index += (1 << i) * index[i];
  }
  return table_[row_index];
}

void TruthTable::SetF(std::vector<bool> index, bool value) {
  std::vector<bool>& row = GetRowReference(index);
  row[0] = value;
}

void TruthTable::SetG(std::vector<bool> index, bool value) {
  std::vector<bool>& row = GetRowReference(index);
  row[1] = value;
}

bool TruthTable::GetF(std::vector<bool> index) const {
  return GetConstRowReference(index)[0];
}

bool TruthTable::GetG(std::vector<bool> index) const {
  return GetConstRowReference(index)[1];
}

size_t TruthTable::GetAmountOfInputs() const {
  return amount_of_inputs_;
}

} // namespace Hardware
