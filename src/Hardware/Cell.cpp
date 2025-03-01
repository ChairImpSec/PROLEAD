#include "Hardware/Cell.hpp"

#include <boost/json/src.hpp>
#include <fstream>
#include <iostream>

IterateEnablers::IterateEnablers(size_t amount_inputs, bool with_glitches)
    : norm_vector_bool_(amount_inputs, 0),
    mod_vector_bool_(amount_inputs, 0), glitch_vector_bool_(amount_inputs, 0), 
    index_vector_small_(amount_inputs * 2, 0), index_vector_(amount_inputs * 3, 0), 
    norm_vector_num_(amount_inputs, 0), mod_vector_num_(amount_inputs, 0) {
  if (amount_inputs > 64) throw std::runtime_error("IterateEnablers doesn't support more than 63 inputs");
  amount_inputs_ = amount_inputs;
  amount_rows_ = 1 << amount_inputs_;
  norm_number_ = 0;
  mod_number_ = 0;
  glitch_number_ = 0;
  with_glitches_ = with_glitches;
}

bool IterateEnablers::Iterate() {
  if (with_glitches_) {
    glitch_number_ += 1;
    if (glitch_number_ < amount_rows_){
      UpdateVectors();
      return true;
    }
    glitch_number_ = 0;
  }
  mod_number_ += 1;
  if (mod_number_ < amount_rows_){
    UpdateVectors();
    return true;
  }
  mod_number_ = 0;
  norm_number_ += 1;
  if (norm_number_ < amount_rows_){
    UpdateVectors();
    return true;
  }
  norm_number_ = 0;
  UpdateVectors();
  return false;
}

void IterateEnablers::UpdateVectors() {
  BitVectorFromNumber(norm_vector_num_, norm_number_);
  BitVectorFromNumber(mod_vector_num_, mod_number_);
  BoolVectorFromNumber(norm_vector_bool_, norm_number_);
  BoolVectorFromNumber(mod_vector_bool_, mod_number_);
  BoolVectorFromNumber(glitch_vector_bool_, glitch_number_);
  index_vector_small_ = ConcatBoolVectors2(norm_vector_bool_, mod_vector_bool_);
  index_vector_ = ConcatBoolVectors3(norm_vector_bool_, mod_vector_bool_, glitch_vector_bool_);
}

std::vector<bool> IterateEnablers::GetNormVectorBool() const {
  return norm_vector_bool_;
}

std::vector<uint64_t> IterateEnablers::GetNormVectorNumb() const {
  return norm_vector_num_;
}

std::vector<bool> IterateEnablers::GetModVectorBool() const {
  return mod_vector_bool_;
}

std::vector<uint64_t> IterateEnablers::GetModVectorNumb() const {
  return mod_vector_num_;
}

std::vector<bool> IterateEnablers::GetGlitchVectorBool() const {
  return glitch_vector_bool_;
}

uint64_t IterateEnablers::GetGlitchNumber() const {
  return glitch_number_;
}

std::vector<bool> IterateEnablers::GetIndexVectorSmall() const {
  return index_vector_small_;
}
std::vector<bool> IterateEnablers::GetIndexVector() const {
  if (!with_glitches_) throw std::runtime_error("Normal index vector requires glitch inputs");
  return index_vector_;
}

void Cell::SetOperations(const std::vector<std::string>& expressions) {  
  std::vector<std::string> primary_signals = inputs_;
  if ((type_ == cell_t::sequential) || (type_ == cell_t::latch)) {
    primary_signals.insert(primary_signals.end(), outputs_.begin(), outputs_.end());
  }

  for (const std::string& expression : expressions) {
    expr_.emplace_back(expression, primary_signals);

    if (type_ == cell_t::relaxed) {
      bool found = false;
      for (uint64_t idx = 0; idx < expr_lib.size(); ++idx) {
        if (expr_.back() == Expression(expr_lib[idx].first, expr_lib[idx].second)) {
          expr_glitch_ext_.emplace_back(expr_glitch_ext_lib[idx].first, expr_glitch_ext_lib[idx].second);
          expr_probe_prop_.emplace_back(expr_probe_prop_lib[idx].first, expr_probe_prop_lib[idx].second);
          found = true;
          break;
        }
      }

      if (!found) {
          GenerateRelaxedFunctions(expr_.back());
      }
    }
  }
}

TruthTable Cell::GenerateSmallEnablers(const Expression& op) {
  // contains all rows of truth table that are not a transition, glitch or c != c'
  std::unordered_map<uint64_t, std::vector<std::vector<bool>>> valid_rows = {{0,{}}, {1,{}}}; 
  TruthTable truth_table(2*inputs_.size());
  uint64_t c, c_mod;

  IterateEnablers it(inputs_.size(), false);
  do {
    c = op.Eval(it.GetNormVectorNumb()) & 1;
    c_mod = op.Eval(it.GetModVectorNumb()) & 1;
    if (c != c_mod) {
      truth_table.SetF(it.GetIndexVectorSmall(), true);
      if (DetectGlitches(op, it.GetNormVectorNumb(), it.GetModVectorNumb(), true)) {
        truth_table.SetG(it.GetIndexVectorSmall(), true);
      }
      continue;  // transition
    }
    if (DetectGlitches(op,it.GetNormVectorNumb(), it.GetModVectorNumb(), false)) {
      truth_table.SetF(it.GetIndexVectorSmall(), true);
      truth_table.SetG(it.GetIndexVectorSmall(), true);
      continue;  
    }
    truth_table.SetF(it.GetIndexVectorSmall(),false);  // if it was the only instance set to true later   
    truth_table.SetG(it.GetIndexVectorSmall(), false);
    valid_rows[c].push_back(it.GetIndexVectorSmall());
  } while(it.Iterate());

  for (auto valid_row : valid_rows) {
      if(valid_row.second.size() == 1) { 
          truth_table.SetF(valid_row.second[0], true);  // set F to false if output is distinguishable
      }
  }
  return truth_table;
}

void Cell::GenerateRelaxedFunctions(const Expression& expr) {
  TruthTable small_table = GenerateSmallEnablers(expr);
  
  TruthTable table(3*inputs_.size());
  IterateEnablers it(inputs_.size(), true);
  do {
    if (it.GetGlitchNumber() == 0) { // no glitches
      table.SetF(it.GetIndexVector(), small_table.GetF(it.GetIndexVectorSmall()));
      table.SetG(it.GetIndexVector(), small_table.GetG(it.GetIndexVectorSmall()));
      continue;
    }
    // If glitch happens without glitchy inputs it will continue to do so with them
    if (small_table.GetG(it.GetIndexVectorSmall())) {
      table.SetF(it.GetIndexVector(), 1);
      table.SetG(it.GetIndexVector(), 1);
      continue;
    }
    // If toggle happens without glitchy inputs it will continue to do so with them
    if (small_table.GetF(it.GetIndexVectorSmall())) table.SetF(it.GetIndexVector(), 1);
    LookupGlitchesSmallTable(table, small_table, it);
  } while (it.Iterate());

  expr_glitch_ext_.push_back(table.OperationFromTruthTable(true));
  expr_probe_prop_.push_back(table.OperationFromTruthTable(false));
}

Cell::Cell(const js::value& value, bool is_relaxed) {
  std::string err_msg = "Error while reading cell ";
  js::object obj = value.as_object();
  std::vector<std::string>  expressions, parsed;
  SignalNameGrammar grammar;
  std::string name;
  clk_ = std::nullopt;

  if (!obj.contains("name")) {
    throw std::runtime_error(err_msg + ". Name not found!");
  } else {
    name = value.at("name").as_string().c_str();
  }

  if (obj.contains("aliases") && obj["aliases"].is_array()) {
    for (const auto& alias : obj["aliases"].as_array()) {
      identifiers_.push_back(js::value_to<std::string>(alias));
    }
  } else {
    throw std::runtime_error(err_msg + name + ". Invalid or missing aliasses!");
  }

  if (obj.contains("inputs") && obj["inputs"].is_array()) {
    for (const auto& input : obj["inputs"].as_array()) {
      std::string input_str = js::value_to<std::string>(input);
      parsed = grammar.Parse(input_str);
      inputs_.insert(inputs_.end(), parsed.begin(), parsed.end());
    }
  } else {
    throw std::runtime_error(err_msg + name + ". Invalid or missing inputs!");
  }

  if (obj.contains("intermediates")) {
    if (obj["intermediates"].is_array()) {
      std::vector<std::string> mids;
      std::vector<std::vector<std::string>> mids_expr;
      for (const auto& lvl : obj["intermediates"].as_array()) {
        js::object lvl_obj = lvl.as_object();

        if (!lvl_obj.contains("names") || !lvl_obj["names"].is_array()) {
          throw std::runtime_error(err_msg + name + ". Invalid or missing \"names\" in \"intermediates\"!");
        } else if (!lvl_obj.contains("equations") || !lvl_obj["equations"].is_array()){
          throw std::runtime_error(err_msg + name + ". Invalid or missing \"equaitons\" in \"intermediates\"!");
        } else {
          for (const auto& ids : lvl_obj["names"].as_array()) {
            std::string ids_str = js::value_to<std::string>(ids);
            parsed = grammar.Parse(ids_str);
            mids.insert(mids.end(), parsed.begin(), parsed.end());
            parsed.clear();
          }

          mids_.push_back(mids);
          mids.clear();

          for (const auto& eqs : lvl_obj["equations"].as_array()) {
            parsed.push_back(js::value_to<std::string>(eqs));
          }

          mids_expr.push_back(parsed);
          parsed.clear();
        }
      }
    } else {
      throw std::runtime_error(err_msg + name + ". Invalid or missing intermediates!");
    }
  }

  if (obj.contains("outputs") && obj["outputs"].is_array()) {
    for (const auto& output : obj["outputs"].as_array()) {
      std::string output_str = js::value_to<std::string>(output);
      parsed = grammar.Parse(output_str);
      outputs_.insert(outputs_.end(), parsed.begin(), parsed.end());
    }
  } else {
    throw std::runtime_error(err_msg + name + ". Invalid or missing outputs!");
  }

  if (!obj.contains("type")) {
    throw std::runtime_error(err_msg + name + ". Type not found!");
  }

  std::string type = value.at("type").as_string().c_str();

  if (type == "gate" || type == "conservative_gate") {
    type_ = cell_t::combinational;
  } else if (type == "buffer") {
    type_ = cell_t::buffer;
  } else if (type == "relaxed_gate") {
    if (is_relaxed && GetNumberOfOutputs() == 1) {
      type_ = cell_t::relaxed;
    } else{
      type_ = cell_t::combinational;
    }
  } else if (type == "register") {
    type_ = cell_t::sequential;
  } else if (type == "latch") {
    type_ = cell_t::latch;
  } else {
    throw std::runtime_error(err_msg + name + ". Invalid type \"" + type + "\"!");
  }

  if (obj.contains("equations") && obj["equations"].is_array()) {
    for (const auto& expr : obj["equations"].as_array()) {
      expressions.push_back(js::value_to<std::string>(expr));
    }
  } else {
    throw std::runtime_error(err_msg + name + ". Invalid or missing equation!");
  }

  if (GetType() == cell_t::sequential) {
    if (!obj.contains("timing")) {
      throw std::runtime_error(err_msg + name + ". \"timing\" not found!");
    }
    std::string timing = value.at("timing").as_string().c_str();

    if (timing == "rising_edge") {
      clk_edge_ = clk_edge_t::rising;
    } else if (timing == "falling_edge") {
      clk_edge_ = clk_edge_t::falling;
    } else if (timing == "both") {
      clk_edge_ = clk_edge_t::both;
    } else {
      throw std::runtime_error(err_msg + name + ". Invalid timing \"" + timing + "\"!");
    }
  } else {
    clk_edge_ = clk_edge_t::undef;
  }

  if (GetType() == cell_t::sequential) {
    if (!obj.contains("clock")) {
      throw std::runtime_error(err_msg + name + "\". \"clock\" not found!");
    }

    std::string clk = value.at("clock").as_string().c_str();
    std::vector<std::string>::iterator it = std::find(inputs_.begin(), inputs_.end(), clk);

    if (it == inputs_.end()) {
      throw std::runtime_error(err_msg + name + ". Invalid clock \"" + clk + "\"!");
    } else {
      clk_ = std::distance(inputs_.begin(), it);
    }
  } else if (obj.contains("clock")) {
      throw std::runtime_error(err_msg + name + ". Clock should not be defiend!");
  }

  SetOperations(expressions);
}

uint64_t Cell::Eval(uint64_t idx, const std::vector<uint64_t>& vals) const {
  return expr_[idx].Eval(vals);
}

uint64_t Cell::EvalGlitch(uint64_t idx, const std::vector<uint64_t>& vals) const {
  return expr_glitch_ext_[idx].Eval(vals);
}

uint64_t Cell::EvalProp(uint64_t idx, const std::vector<uint64_t>& vals) const {
  return expr_probe_prop_[idx].Eval(vals);
}

void Cell::LookupGlitchesSmallTable(TruthTable& table, TruthTable& small_table, IterateEnablers& it) {
  std::vector<size_t> indexes;
  bool include_same_vector = false;
  for (size_t glitch_index = 0; glitch_index < inputs_.size(); ++glitch_index) {    
    if ((it.GetNormVectorBool()[glitch_index] == it.GetModVectorBool()[glitch_index]) && it.GetGlitchVectorBool()[glitch_index]) {
      indexes.push_back(glitch_index);
    } else {  //glitch happening during transition
      include_same_vector = true;
    }
  } 
  bool f = small_table.GetF(it.GetIndexVectorSmall()), glitch = 0;
  // go through all subsets of indexes
  std::vector<bool> flipped_mod_vector;
  for (uint64_t bitmask = 0; bitmask < (1ULL << (indexes.size())); ++bitmask) {
    flipped_mod_vector = it.GetModVectorBool();
    for (size_t i = 0; i < indexes.size(); ++i) {
      if (bitmask & (1 << i))flipped_mod_vector[indexes[i]] = !flipped_mod_vector[indexes[i]];
    }
    f |= small_table.GetF(ConcatBoolVectors2(it.GetNormVectorBool(), flipped_mod_vector));
    glitch |= small_table.GetF(ConcatBoolVectors2(it.GetNormVectorBool(), flipped_mod_vector));
  }
  if (include_same_vector) glitch |= small_table.GetF(it.GetIndexVectorSmall());
  table.SetF(it.GetIndexVector(), f);
  table.SetG(it.GetIndexVector(), glitch);
}

bool Cell::DetectGlitches(const Expression& op, std::vector<uint64_t> const& norm_input, std::vector<uint64_t> const& mod_input, bool transition_allowed) {
  std::vector<size_t> flipped_indexes;
    for (size_t i = 0; i < norm_input.size(); ++i) {
        if (norm_input[i] != mod_input[i]) {
            flipped_indexes.push_back(i);
        } 
    }
    bool value_changed;
    std::vector<uint64_t> intermediate_input;
    // perform transition between inputs in different orders
    do {
        intermediate_input = norm_input;
        value_changed = false;
        for (auto flipped_index : flipped_indexes) {
            intermediate_input[flipped_index] = intermediate_input[flipped_index] ^ 1;
            if ((op.Eval(intermediate_input) & 1) != (op.Eval(norm_input) & 1)) {
              if (transition_allowed) {
                value_changed = true;
              } else {
                return true;
              }
                
            } else if (value_changed) {
              if (value_changed && transition_allowed) return true;
            }
        }
    } while(std::next_permutation(flipped_indexes.begin(), flipped_indexes.end()));   // we start with the indexes sorted => it goes through all permutations
    return false;
}

cell_t Cell::GetType() const { return type_; }

clk_edge_t Cell::GetClkEdge() const { return clk_edge_; }

std::optional<uint64_t> Cell::GetClock() const { return clk_; }

const std::vector<std::string> Cell::GetIdentifiers() const { return identifiers_; }

uint64_t Cell::GetNumberOfIdentifiers() const { return identifiers_.size(); }

uint64_t Cell::GetNumberOfInputs() const { 
  return inputs_.size(); 
}

uint64_t Cell::GetNumberOfOutputs() const {
  return outputs_.size(); 
}

std::string Cell::GetIdentifier(uint64_t index) const { return identifiers_[index]; }

std::string Cell::GetInput(uint64_t index) const { 
  assert(index < inputs_.size() && "Error in Cell::GetInput: Index out of bounds!");
  return inputs_[index];
}

std::string Cell::GetOutput(uint64_t index) const { 
  assert(index < outputs_.size() && "Error in Cell::GetOutput: Index out of bounds!");
  return outputs_[index];
}