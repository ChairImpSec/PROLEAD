#include "Hardware/Cell.hpp"

#include <boost/json/src.hpp>
#include <fstream>
#include <iostream>

std::vector<std::string> ConvertJsonArrayToVector(
    const boost::json::array& json_array) {
  std::vector<std::string> result;
  for (auto& str : json_array) {
    result.push_back(boost::json::value_to<std::string>(str));
  }
  return result;
}

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

void Cell::SetType(const boost::json::value& value, bool is_relaxed) {
  boost::json::object value_object = value.as_object();
  std::string name = value.at("name").as_string().c_str();

  if (!value_object.contains("type")) {
    throw std::runtime_error("Error while reading the type of cell \"" + name + "\". Type not found!");
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
    throw std::runtime_error("Error while reading the type of cell \"" + name + "\". The type \"" + type + "\" is not valid!");
  }
}

void Cell::SetClkEdge(const boost::json::value& value) {
  boost::json::object value_object = value.as_object();
  std::string name = value.at("name").as_string().c_str();

  if (GetType() == cell_t::sequential) {
    if (!value_object.contains("timing")) {
      throw std::runtime_error("Error while reading the timing type of cell \"" + name + "\". Timing type not found!");
    }
    std::string timing = value.at("timing").as_string().c_str();

    if (timing == "rising_edge") {
      clk_edge_ = clk_edge_t::rising;
    } else if (timing == "falling_edge") {
      clk_edge_ = clk_edge_t::falling;
    } else if (timing == "both") {
      clk_edge_ = clk_edge_t::both;
    } else {
      throw std::runtime_error("Error while reading the timing of cell \"" + name + "\". The timing \"" + timing + "\" is invalid!");
    }
  } else {
    clk_edge_ = clk_edge_t::undef;
  }
}

void Cell::SetClock(const boost::json::value& value) {
  boost::json::object value_object = value.as_object();
  std::string name = value.at("name").as_string().c_str();
  uint64_t port_index;

  if (GetType() == cell_t::sequential) {
    if (!value_object.contains("clock")) {
      throw std::runtime_error("Error while reading clock of cell \"" + name + "\". Clock not found!");
    }
    std::string clock = value.at("clock").as_string().c_str();

    for (port_index = 0; port_index < inputs_.size(); port_index++) {
      if (GetInput(port_index) == clock) {
        break;
	    }
    }

    if (port_index >= inputs_.size()) {
      throw std::runtime_error("Error while reading clock of cell \"" + name + "\". Clock \"" + clock + "\" is invalid!");
    }

    clk_ = port_index;
  } else if (value_object.contains("clock")) {
      throw std::runtime_error("Error while reading clock of cell \"" + name + "\". Clock should not be defiend!");
  } else {
    clk_ = -1;
  }
}

void Cell::SetOperations(const std::vector<std::string>& expressions) {
  predefined_functions_found_ = false;

  std::vector<std::string> primary_signals;
  for (const std::vector<std::string>& input_port : inputs_) {
    primary_signals.insert(primary_signals.end(), input_port.begin(), input_port.end());
  }

  if ((type_ == cell_t::sequential) || (type_ == cell_t::latch)) {
    for (const std::vector<std::string>& output_port : outputs_) {
      primary_signals.insert(primary_signals.end(), output_port.begin(), output_port.end());
    }
  }

  for (const std::string& expression : expressions) {
    operations_.emplace_back(Operation<CustomOperation>(expression, primary_signals));

    if (type_ == cell_t::relaxed) {
      for (uint64_t index = 0; index < operation_library.size(); ++index) {
        if (operations_.back() == Operation<CustomOperation>(operation_library[index].first, operation_library[index].second)) {
          glitch_propagation_.emplace_back(Operation<CustomOperation>(glitch_propagation_library[index].first, glitch_propagation_library[index].second));
          probe_extension_.emplace_back(Operation<CustomOperation>(probe_extension_library[index].first, probe_extension_library[index].second));
          predefined_functions_found_ = true;
          break;
        }
      }

      if (!predefined_functions_found_) {
          GenerateRelaxedFunctions(operations_.back());
      }
    }
  }
}

TruthTable Cell::GenerateSmallEnablers(Operation<CustomOperation>& op) {
  // contains all rows of truth table that are not a transition, glitch or c != c'
  std::unordered_map<uint64_t, std::vector<std::vector<bool>>> valid_rows = {{0,{}}, {1,{}}}; 
  TruthTable truth_table(2*inputs_.size());
  uint64_t c, c_mod;

  IterateEnablers it(inputs_.size(), false);
  do {
    c = op.Evaluate(it.GetNormVectorNumb()) & 1;
    c_mod = op.Evaluate(it.GetModVectorNumb()) & 1;
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

void Cell::GenerateRelaxedFunctions(Operation<CustomOperation>& operation) {
  TruthTable small_table = GenerateSmallEnablers(operation);
  
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

  glitch_propagation_.push_back(table.OperationFromTruthTable(true));
  probe_extension_.push_back(table.OperationFromTruthTable(false));
}

Cell::Cell(const boost::json::value& value, bool is_relaxed) {
  boost::json::object value_object = value.as_object();
  std::vector<std::string> inputs, outputs, expressions;
  SignalNameGrammar grammar;
  std::string name;

  if (!value_object.contains("name")) {
    throw std::runtime_error("Error while reading a cell. Name not found!");
  } else {
    name = value.at("name").as_string().c_str();
  }

  identifiers_ = ConvertJsonArrayToVector(value.at("aliases").as_array());
  inputs = ConvertJsonArrayToVector(value.at("inputs").as_array());
  outputs = ConvertJsonArrayToVector(value.at("outputs").as_array());

  for (std::string& input : inputs) {
    inputs_.emplace_back(grammar.Parse(input));
  }

  for (std::string& output : outputs) {
    outputs_.emplace_back(grammar.Parse(output));
  }

  if (value_object.contains("equations")) {
    expressions = ConvertJsonArrayToVector(value.at("equations").as_array());
  }

  SetType(value, is_relaxed);
  SetClkEdge(value);
  SetClock(value);
  SetOperations(expressions);
}

Cell::Cell(cell_t type, std::vector<std::string> identifiers,
           std::vector<std::vector<std::string>> inputs, std::vector<std::vector<std::string>> outputs,
           std::vector<std::string> expressions)
    : type_(type), 
      identifiers_(identifiers),
      inputs_(inputs),
      outputs_(outputs) {
  SetOperations(expressions);
}

bool Cell::operator==(const Cell& other) const {
  return (identifiers_ == other.identifiers_) && (type_ == other.type_) &&
         (inputs_ == other.inputs_) && (outputs_ == other.outputs_) &&
         (operations_ == other.operations_);
}

uint64_t Cell::Evaluate(uint64_t output_index, std::vector<uint64_t>& input_values) const {
  return operations_[output_index].Evaluate(input_values);
}

uint64_t Cell::EvaluatePropagation(uint64_t function_index, std::vector<uint64_t>& input_values) const {
  return probe_extension_[function_index].Evaluate(input_values);
}

uint64_t Cell::EvaluateGlitch(uint64_t function_index, std::vector<uint64_t>& input_values) const {
  return glitch_propagation_[function_index].Evaluate(input_values);
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

bool Cell::DetectGlitches(Operation<CustomOperation>& op, std::vector<uint64_t> const& norm_input, std::vector<uint64_t> const& mod_input, bool transition_allowed) {
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
            if ((op.Evaluate(intermediate_input) & 1) != (op.Evaluate(norm_input) & 1)) {
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

int64_t Cell::GetClock() const { return clk_; }

const std::vector<std::string> Cell::GetIdentifiers() const { return identifiers_; }

uint64_t Cell::GetNumberOfIdentifiers() const { return identifiers_.size(); }

uint64_t Cell::GetNumberOfInputs() const { 
  uint64_t number_of_inputs = 0;

  for (const std::vector<std::string>& input_port : inputs_) {
    number_of_inputs += input_port.size();
  }

  return number_of_inputs; 
}

uint64_t Cell::GetNumberOfOutputs() const {
    uint64_t number_of_outputs = 0;

  for (const std::vector<std::string>& output_port : outputs_) {
    number_of_outputs += output_port.size();
  }

  return number_of_outputs; 
}

std::string Cell::GetIdentifier(uint64_t index) const { return identifiers_[index]; }

std::string Cell::GetInput(uint64_t index) const { 
  uint64_t bit_index, count = 0;

  for (uint64_t port_index = 0; port_index < inputs_.size(); ++port_index) {
    if (index < count + inputs_[port_index].size()) {
      bit_index = index - count;
      return inputs_[port_index][bit_index];
    }
    count += inputs_[port_index].size();
  }

  throw std::out_of_range("Error while getting the input of a cell. Index out of range!");
}

std::string Cell::GetOutput(uint64_t index) const { 
  uint64_t bit_index, count = 0;

  for (uint64_t port_index = 0; port_index < outputs_.size(); ++port_index) {
    if (index < count + outputs_[port_index].size()) {
      bit_index = index - count;
      return outputs_[port_index][bit_index];
    }
    count += outputs_[port_index].size();
  }

  throw std::out_of_range("Error while getting the output of a cell. Index out of range!");
}