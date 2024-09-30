#include "Hardware/Library.hpp"

#include <boost/json/src.hpp>
#include <fstream>
#include <iostream>

namespace Hardware {

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

  if (type == "gate" || type == "conservative_gate" || type == "buffer") {
    type_ = CellType::conservative_gate;
  } else if (type == "relaxed_gate") {
    if (is_relaxed) {
      type_ = CellType::relaxed_gate;
    } else{
      type_ = CellType::conservative_gate;
    }
  } else if (type == "register") {
    type_ = CellType::sequential_gate;
  } else {
    throw std::runtime_error("Error while reading the type of cell \"" + name + "\". The type \"" + type + "\" is not valid!");
  }
}

std::vector<std::string> Cell::ConvertJsonArrayToVector(
    const boost::json::array& json_array) const {
  std::vector<std::string> result;
  for (auto& str : json_array) {
    result.push_back(boost::json::value_to<std::string>(str));
  }
  return result;
}

void Cell::SetOperations(std::vector<std::string>& expressions) {
  std::vector<std::string> primary_signals;
  predefined_functions_found_ = false;

  for (std::string& expression : expressions) {
    primary_signals = inputs_;

    if (type_ == CellType::sequential_gate) {
      primary_signals.insert(primary_signals.end(), outputs_.begin(), outputs_.end());
    }

    operations_.emplace_back(Operation<CustomOperation>(expression, primary_signals));

    if (type_ == CellType::relaxed_gate) {
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

  if (!value_object.contains("name")) {
    throw std::runtime_error("Error while reading a cell. Name not found!");
  }

  SetType(value, is_relaxed);

  identifiers_ = ConvertJsonArrayToVector(value.at("aliases").as_array());
  inputs_ = ConvertJsonArrayToVector(value.at("inputs").as_array());
  outputs_ = ConvertJsonArrayToVector(value.at("outputs").as_array());
  std::vector<std::string> expressions = ConvertJsonArrayToVector(value.at("equations").as_array());
  SetOperations(expressions);
}
















Cell::Cell(CellType type, std::vector<std::string> identifiers,
           std::vector<std::string> inputs, std::vector<std::string> outputs,
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

CellType Cell::GetCellType() const { return type_; }

const std::vector<std::string> Cell::GetIdentifiers() const { return identifiers_; }

const std::vector<std::string> Cell::GetInputs() const { return inputs_; }

const std::vector<std::string> Cell::GetOutputs() const { return outputs_; }

Library::Library(std::string path, std::string name, bool is_relaxed) {
  std::string predefined_cells, generated_cells;
  uint64_t number_of_predifined_cells = 0;
  uint64_t number_of_generated_cells = 0;
  std::ifstream file(path);
  if (file.fail()) {
    throw std::runtime_error("Error while opening the library file at \"" +
                             path + "\". File not found!");
  } else {
    std::cout << "Successfully opened the library file at \"" << path << "\"."
              << std::endl;
  }

  buffer_index_ = -1;
  std::string data{std::istreambuf_iterator<char>(file),
                   std::istreambuf_iterator<char>()};
  boost::json::parse_options opt;
  opt.allow_comments = true;
  boost::json::monotonic_resource mr;
  boost::json::storage_ptr sp(&mr);
  boost::json::value json_data = boost::json::parse(data, sp, opt);
  boost::json::array cells;
  boost::json::array libraries = json_data.at("libraries").as_array();

  auto it = std::find_if(
      libraries.begin(), libraries.end(),
      [&](const boost::json::value& library) {
        return boost::json::value_to<std::string>(library.at("name")) == name;
      });

  if (it != libraries.end()) {
    cells = it->at("cells").as_array();
    std::cout << "Successfully read the library with name \"" << name << "\"."
              << std::endl;
  } else {
    throw std::runtime_error("Error while reading the library with name \"" +
                             name + "\". Library not found!");
  }

  for (const boost::json::value& cell : cells) {
    cells_.emplace_back(cell, is_relaxed);
    if (cell.at("type") == "buffer") {
      std::string buffer_name = cell.at("name").as_string().c_str();
      std::cout << "Successfully found buffer cell with name \"" + buffer_name +
                       "\"."
                << std::endl;
      buffer_index_ = cells_.size() - 1;
    }

    if (cells_.back().GetCellType() == CellType::relaxed_gate) {
      if (cells_.back().HasPredefinedFunctions()) {
        predefined_cells +=
            std::string(cell.at("name").as_string().c_str()) + ", ";
        ++number_of_predifined_cells;
      } else {
        generated_cells +=
            std::string(cell.at("name").as_string().c_str()) + ", ";
        ++number_of_generated_cells;
      }
    }
  }

  if (is_relaxed) {
    if (predefined_cells.length() > 2) {
      predefined_cells.erase(predefined_cells.length() - 2);
    }

    if (generated_cells.length() > 2) {
      generated_cells.erase(generated_cells.length() - 2);
    }

    std::cout << "Successfully found " << number_of_predifined_cells
              << " relaxed cells with predefined functions [" + predefined_cells +
                    "]."
              << std::endl;
    std::cout << "Successfully found " << number_of_generated_cells
              << " relaxed cells without predefined functions [" +
                    generated_cells + "]."
              << std::endl;
  }
  std::cout << "Successfully parsed " << cells_.size()
            << " cells from the library." << std::endl;
}

Cell Library::GetCell(uint64_t index) const { 
  return cells_[index]; 
}

size_t Library::GetNumberOfCells() const {return cells_.size();}

bool Library::IsCellRegister(unsigned int index) const {
  return cells_[index].GetCellType() == CellType::sequential_gate;
}

size_t Library::GetNumberOfCellIdentifiers(unsigned int index) const {
  return cells_[index].GetIdentifiers().size();
}

std::string Library::GetCellIdentifier(unsigned int cell_index, unsigned int identifier_index) const{
  return cells_[cell_index].GetIdentifiers()[identifier_index];
}

size_t Library::GetNumberOfCellInputs(unsigned int index)const {
  return cells_[index].GetInputs().size();
}

size_t Library::GetNumberOfCellOutputs(unsigned int index) const {
  return cells_[index].GetOutputs().size();
}

std::string Library::GetCellInput(unsigned int cell_index, unsigned int input_index) const {
  return cells_[cell_index].GetInputs()[input_index];
}

std::string Library::GetCellOutput(unsigned int cell_index, unsigned int output_index) const {
  return cells_[cell_index].GetOutputs()[output_index];
}

int Library::GetBufferIndex() const {
  return buffer_index_;
}

uint64_t Library::Evaluate(unsigned int cell_index, unsigned int output_index, std::vector<uint64_t>& input_values) const{
  return cells_[cell_index].Evaluate(output_index, input_values);
}

}  // namespace Hardware
