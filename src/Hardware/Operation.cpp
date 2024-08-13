#include "Hardware/Operation.hpp"

namespace Hardware {

std::vector<std::pair<std::string, std::vector<std::string>>> operation_library = {
    {"A1 and A2", {"A1", "A2"}},
    {"not (A1 and A2)", {"A1", "A2"}},
    {"A1 or A2", {"A1", "A2"}},
    {"not (A1 or A2)", {"A1", "A2"}},
    {"A xor B", {"A", "B"}},
    {"not (A xor B)", {"A", "B"}},
    {"A1 and A2 and A3", {"A1", "A2", "A3"}},
    {"not (A1 and A2 and A3)", {"A1", "A2", "A3"}},
    {"A1 or A2 or A3", {"A1", "A2", "A3"}},
    {"not (A1 or A2 or A3)", {"A1", "A2", "A3"}},
    {"A xor B xor C", {"A", "B", "C"}},
    {"not (A xor B xor C)", {"A", "B", "C"}},
    {"A1 and A2 and A3 and A4", {"A1", "A2", "A3", "A4"}},
    {"not (A1 and A2 and A3 and A4)", {"A1", "A2", "A3", "A4"}},
    {"A1 or A2 or A3 or A4", {"A1", "A2", "A3", "A4"}},
    {"not (A1 or A2 or A3 or A4)", {"A1", "A2", "A3", "A4"}},
    {"A xor B xor C xor D", {"A", "B", "C", "D"}},
    {"not (A xor B xor C xor B)", {"A", "B", "C", "D"}},
    {"not A", {"A"}},
    {"not (not A)", {"A"}}
};

std::vector<std::pair<std::string, std::vector<std::string>>> glitch_propagation_library = {
    {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' and (not B1)) or (g_A1 and (B1' or B1 or g_B1)) or (g_B1 and (A1' or A1 or g_A1))", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' and (not B1)) or (g_A1 and (B1' or B1 or g_B1)) or (g_B1 and (A1' or A1 or g_A1))", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' and (not B1)) or (g_A1 and ((not B1') or (not B1) or g_B1)) or (g_B1 and ((not A1') or (not A1) or g_A1))", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' and (not B1)) or (g_A1 and ((not B1') or (not B1) or g_B1)) or (g_B1 and ((not A1') or (not A1) or g_A1))", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"((A' xor A) and (B' xor B)) or g_A or g_B", {"A'", "A", "g_A", "B'", "B", "g_B"}},
    {"((A' xor A) and (B' xor B)) or g_A or g_B", {"A'", "A", "g_A", "B'", "B", "g_B"}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and (A3' or A3 or g_A3) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and (A2' or A2 or g_A2) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) or g_A3 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and (A3' or A3 or g_A3) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and (A2' or A2 or g_A2) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) or g_A3 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and ((not A3') or (not A3) or g_A3) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or (not A2) or g_A2) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) or g_A1 and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or g_A3 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and ((not A3') or (not A3) or g_A3) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or (not A2) or g_A2) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) or g_A1 and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or g_A3 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
    {"((A' xor A) and (B' xor B)) or ((A' xor A) and (C' xor C)) or ((B' xor B) and (C' xor C)) or g_A or g_B or g_C", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
    {"((A' xor A) and (B' xor B)) or ((A' xor A) and (C' xor C)) or ((B' xor B) and (C' xor C)) or g_A or g_B or g_C", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not A4))) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) and (A4' or A4 or g_A4) or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and A4' and (not A4))) and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or g_A3 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) or g_A4 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'", "A4", "g_A4"}}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not A4))) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) and (A4' or A4 or g_A4) or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and A4' and (not A4))) and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) or g_A3 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) or g_A4 and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3)", {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'", "A4", "g_A4"}}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or (not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not A4))) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) and ((not A4') or (not A4) or g_A4) or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) or g_A1 and((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A3 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or g_A4 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3)", {"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'", "A4", "g_A4"}},
    {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and A2' and (not A2))) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or (not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not A4))) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) and ((not A4') or (not A4) or g_A4) or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) or g_A1 and((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A3 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or g_A4 and ((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) or g_A3)", {"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'", "A4", "g_A4"}},
    {"((A1' xor A1) and (A2' xor A2)) or ((A' xor A) and (C' xor C)) or ((A' xor A) and (D' xor D)) or ((B' xor B) and (C' xor C)) or ((B' xor B) and (D' xor D)) or ((C' xor C) and (D' xor D)) or g_A or g_B or g_C or g_D", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D", "g_D"}},
    {"((A1' xor A1) and (A2' xor A2)) or ((A' xor A) and (C' xor C)) or ((A' xor A) and (D' xor D)) or ((B' xor B) and (C' xor C)) or ((B' xor B) and (D' xor D)) or ((C' xor C) and (D' xor D)) or g_A or g_B or g_C or g_D", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D", "g_D"}},    
    {"1", {}},
    {"1", {}}
};

std::vector<std::pair<std::string, std::vector<std::string>>> probe_extension_library = {
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B)", {"A'", "A", "g_A", "B'", "B", "g_B"}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B)", {"A'", "A", "g_A", "B'", "B", "g_B"}},
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1)", {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}},
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1)", {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) and ((not C1') or (not C1) or g_C1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) and ((not C1') or (not C1) or g_C1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C)", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C)", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1) and (D1' or D1 or g_D1)", {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'", "D1", "g_D1"}},
    {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1) and (D1' or D1 or g_D1)", {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'", "D1", "g_D1"}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) and ((not C1') or (not C1) or g_C1) and ((not D1') or (not D1) or g_D1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'", "D1", "g_D1"}}},
    {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) and ((not C1') or (not C1) or g_C1) and ((not D1') or (not D1) or g_D1)", {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'", "D1", "g_D1"}}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C) or ((D' xor D) or g_D)", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D", "g_D"}},
    {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C) or ((D' xor D) or g_D)", {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D", "g_D"}},
    {"1", {}},
    {"1", {}}
};

ExpressionTree::ExpressionTree(OperationType op, const ExpressionTree& clause)
    : operation(op), subclauses({clause}) {}

ExpressionTree::ExpressionTree(OperationType op, const ExpressionTree& left,
                               const ExpressionTree& right)
    : operation(op), subclauses({left, right}) {}

ExpressionTree::ExpressionTree(unsigned int variable)
    : operation(OperationType::None), variables({variable}) {}

ExpressionTree::ExpressionTree(OperationType op) : operation(op) {}

CustomOperation::CustomOperation(ExpressionTree& tree,
                                 size_t number_of_inputs) {
  ExpressionTree *node, *leaf;

  while (tree.subclauses.size()) {
    node = &tree;

    while (!node->subclauses.empty()) {
      leaf = &node->subclauses.back();

      if (leaf->subclauses.empty()) {
        if (leaf->operation == Hardware::OperationType::None) {
          node->variables.push_back(leaf->variables[0]);
        } else {
          SetClause(leaf->operation, leaf->variables);
          node->variables.push_back(number_of_inputs++);
        }

        node->subclauses.pop_back();
      } else {
        node = leaf;
      }
    }
  }

  SetClause(tree.operation, tree.variables);
}

CustomOperation::CustomOperation(OperationType operation_type,
                                 std::vector<unsigned int> input_signals) {
  operation_of_clause_.push_back(operation_type);
  operands_in_clause_.push_back(input_signals);
}

size_t CustomOperation::GetNumberOfClauses() const {
  return operation_of_clause_.size();
}

unsigned int CustomOperation::GetNumberOfOperandsInClause(
    unsigned int clause_index) const {
  return operands_in_clause_[clause_index].size();
}

void CustomOperation::SetClause(OperationType operation,
                                std::vector<unsigned int>& operands) {
  std::sort(operands.begin(), operands.end());
  operation_of_clause_.push_back(operation);
  operands_in_clause_.push_back(operands);
}

OperationType CustomOperation::GetOperationInClause(unsigned int clause_index) const {
  return operation_of_clause_[clause_index];
}

unsigned int CustomOperation::GetOperandInClause(unsigned int clause_index,
                                                 unsigned int input_index) const {
  return operands_in_clause_[clause_index][input_index];
}

bool CustomOperation::operator==(const CustomOperation& other) const {
  return (operation_of_clause_ == other.operation_of_clause_) &&
         (operands_in_clause_ == other.operands_in_clause_);
}

BooleanExpressionGrammar::BooleanExpressionGrammar()
    : BooleanExpressionGrammar::base_type(or_term) {
  or_term =
      xor_term[qi::_val = qi::_1] >>
      *(qi::lit("or") >> xor_term[qi::_val = phx::construct<ExpressionTree>(
                                      OperationType::Or, qi::_val, qi::_1)]);
  xor_term =
      and_term[qi::_val = qi::_1] >>
      *(qi::lit("xor") >> and_term[qi::_val = phx::construct<ExpressionTree>(
                                       OperationType::Xor, qi::_val, qi::_1)]);
  and_term =
      not_term[qi::_val = qi::_1] >>
      *(qi::lit("and") >> not_term[qi::_val = phx::construct<ExpressionTree>(
                                       OperationType::And, qi::_val, qi::_1)]);
  not_term =
      variable[qi::_val = qi::_1] | const_zero[qi::_val = qi::_1] |
      const_one[qi::_val = qi::_1] |
      (qi::lit("not") >> not_term[qi::_val = phx::construct<ExpressionTree>(
                                      OperationType::Not, qi::_1)]) |
      ('(' >> or_term[qi::_val = qi::_1] >> ')');

  variable = 'i' >> qi::int_[qi::_val = phx::construct<ExpressionTree>(qi::_1)];

  const_zero = qi::lit("0")[qi::_val = phx::construct<ExpressionTree>(
                                OperationType::Constant_zero)];

  const_one = qi::lit("1")[qi::_val = phx::construct<ExpressionTree>(
                               OperationType::Constant_one)];
}

template <>
Operation<CustomOperation>::Operation() {}

template <>
Operation<CustomOperation>::Operation(std::string expression,
                                      std::vector<std::string> input_names) {
  std::string name, expression_copy = expression;
  size_t index, pos;
  amount_of_inputs_ = input_names.size();
  uint64_t input_index;

  std::vector<std::string> sorted_input_names = input_names;
  std::sort(sorted_input_names.begin(), sorted_input_names.end(), [](const std::string &a, const std::string &b) {
    return a.size() > b.size();
  }); 

  for (index = 0; index < sorted_input_names.size(); ++index) {
    pos = expression.find(sorted_input_names[index]);

    while (pos != std::string::npos) {
      for (input_index = 0; input_index < input_names.size(); ++input_index) {
        if (input_names[input_index] == sorted_input_names[index]) {
          break;
        }
      }

      name = "i" + std::to_string(input_index);
      expression.replace(pos, sorted_input_names[index].length(), name);
      pos = expression.find(sorted_input_names[index], pos + name.length() + 1);
    }
  }

  std::string::iterator start = expression.begin(), end = expression.end();
  ExpressionTree tree;
  BooleanExpressionGrammar parser;
  bool parsed = qi::phrase_parse(start, end, parser, qi::space, tree);

  if (!parsed || (start != end)) {
    std::string error_message =
        "Parsing of library operation \"" + expression_copy + "\" failed!";
    throw std::runtime_error(error_message);
  } else {
    operation_ = CustomOperation(tree, input_names.size());
  }
}

template <>
Operation<CustomOperation>::Operation(
    OperationType operation_type, std::vector<unsigned int>& input_signals) {
  operation_ = CustomOperation(operation_type, input_signals);
}

template <>
uint64_t Operation<CustomOperation>::Evaluate(
    std::vector<uint64_t> input_values) const {
  uint64_t result = 0;

  size_t index, number_of_inputs = input_values.size();
  input_values.resize(number_of_inputs + operation_.GetNumberOfClauses());

  for (index = 0; index < operation_.GetNumberOfClauses(); ++index) {
    if (operation_.GetNumberOfOperandsInClause(index)) {
      result = input_values[operation_.GetOperandInClause(index, 0)];
    }

    switch (operation_.GetOperationInClause(index)) {
      case OperationType::None:
        throw std::runtime_error(
            "Tried to evaluate a unset operation! It seems that you found a "
            "bug in PROLEAD. Please get in touch with me "
            "(nicolai.mueller@rub.de) so that we can fix this issue!");
        break;
      case OperationType::And:
        result &= input_values[operation_.GetOperandInClause(index, 1)];
        break;
      case OperationType::Or:
        result |= input_values[operation_.GetOperandInClause(index, 1)];
        break;
      case OperationType::Xor:
        result ^= input_values[operation_.GetOperandInClause(index, 1)];
        break;
      case OperationType::Not:
        result = ~result;
        break;
      case OperationType::Constant_zero:
        result = 0;
        break;
      case OperationType::Constant_one:
        result = 0xffffffffffffffff;
        break;
      default:
        throw std::runtime_error("Unknown operation detected!");
    }

    input_values[number_of_inputs + index] = result;
  }

  return result;
}

template<>
size_t Operation<CustomOperation>::GetAmountInputs() { return amount_of_inputs_; }

template <>
bool Operation<CustomOperation>::IsEquivalentTo(Operation<CustomOperation>& other) {
  if (amount_of_inputs_ != other.GetAmountInputs()) {
    throw std::runtime_error("Can't compare two operations with diffrent amounts of inputs");
  }
  std::vector<uint64_t> input_vector(amount_of_inputs_);
  for (uint64_t input = 0; input < (1ULL << amount_of_inputs_); ++input) {
    BitVectorFromNumber(input_vector, input);
    if ((Evaluate(input_vector) & 1) != (other.Evaluate(input_vector) & 1)) {
      return false;
    }
  }
  return true;
}

template <>
bool Operation<CustomOperation>::operator==(
    const Operation<CustomOperation>& other) const {
  return operation_ == other.operation_;
}

}  // namespace Hardware
