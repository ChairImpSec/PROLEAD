#include "Hardware/Cell.hpp"

#include <boost/json/src.hpp>
#include <fstream>
#include <iostream>

IterateEnablers::IterateEnablers(uint64_t amount_inputs, bool with_glitches)
    : norm_vector_bool_(amount_inputs, 0),
      mod_vector_bool_(amount_inputs, 0),
      glitch_vector_bool_(amount_inputs, 0),
      index_vector_small_(amount_inputs * 2, 0),
      index_vector_(amount_inputs * 3, 0),
      norm_vector_num_(amount_inputs, 0),
      mod_vector_num_(amount_inputs, 0) {
  if (amount_inputs > 64)
    throw std::runtime_error(
        "IterateEnablers doesn't support more than 63 inputs");
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
    if (glitch_number_ < amount_rows_) {
      UpdateVectors();
      return true;
    }
    glitch_number_ = 0;
  }
  mod_number_ += 1;
  if (mod_number_ < amount_rows_) {
    UpdateVectors();
    return true;
  }
  mod_number_ = 0;
  norm_number_ += 1;
  if (norm_number_ < amount_rows_) {
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
  index_vector_ = ConcatBoolVectors3(norm_vector_bool_, mod_vector_bool_,
                                     glitch_vector_bool_);
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

uint64_t IterateEnablers::GetGlitchNumber() const { return glitch_number_; }

std::vector<bool> IterateEnablers::GetIndexVectorSmall() const {
  return index_vector_small_;
}
std::vector<bool> IterateEnablers::GetIndexVector() const {
  if (!with_glitches_)
    throw std::runtime_error("Normal index vector requires glitch inputs");
  return index_vector_;
}

Cell::Cell(const js::value& value) {
  std::string err_msg = "Error while reading cell ";
  js::object js_obj = value.as_object();
  SignalNameGrammar grammar;
  std::string name;
  clk_ = std::nullopt;

  std::function<void(js::object&, const std::string&, std::vector<std::string>&,
                     bool)>
      ParseStrings = [&](js::object& obj, const std::string& key,
                         std::vector<std::string>& names, bool necessary) {
        if (obj.contains(key) && obj[key].is_array()) {
          for (const auto& str : obj[key].as_array()) {
            names.push_back(js::value_to<std::string>(str));
          }
        } else {
          if (obj.contains(key) && !obj[key].is_array()) {
            throw std::runtime_error(err_msg + name + ". \"" + key +
                                     "\" is not an array!");
          } else {
            if (necessary) {
              throw std::runtime_error(err_msg + name + ". \"" + key +
                                       "\" not found!");
            }
          }
        }
      };

  std::function<void(js::object&, const std::string&, std::vector<std::string>&,
                     bool)>
      ParseSignalNames = [&](js::object& obj, const std::string& key,
                             std::vector<std::string>& names, bool necessary) {
        std::vector<std::string> parsed, read;

        ParseStrings(obj, key, read, necessary);

        for (std::string& str : read) {
          parsed = grammar.Parse(str);
          names.insert(names.end(), parsed.begin(), parsed.end());
        }
      };

  if (!js_obj.contains("name")) {
    throw std::runtime_error(err_msg + ". Name not found!");
  } else {
    name = value.at("name").as_string().c_str();
  }

  ParseStrings(js_obj, "aliases", ids_, true);

  if (js_obj.contains("parameter")) {
    if (js_obj["parameter"].is_array()) {
      VlogConstGrammar vlog_const_grammar;
      for (const auto& pm : js_obj["parameter"].as_array()) {
        js::object pm_obj = pm.as_object();
        if (pm_obj.contains("name") && pm_obj["name"].is_string()) {
          if (pm_obj.contains("default") && pm_obj["default"].is_string()) {
            std::string pm_name = pm_obj["name"].as_string().c_str();
            std::string pm_default = pm_obj["default"].as_string().c_str();
            params_.push_back({pm_name, vlog_const_grammar.Parse(pm_default)});
          } else if (!pm_obj.contains("default")) {
            throw std::runtime_error(err_msg + name +
                                     ". \"default\" not found!");
          } else {
            throw std::runtime_error(err_msg + name +
                                     ". \"default\" is not a string!");
          }

        } else if (!pm_obj.contains("name")) {
          throw std::runtime_error(err_msg + name + ". \"name\" not found!");
        } else {
          throw std::runtime_error(err_msg + name +
                                   ". \"name\" is not a string!");
        }
      }
    } else {
      throw std::runtime_error(err_msg + name +
                               ". \"parameter\" is not an array!");
    }
  }

  ParseSignalNames(js_obj, "inputs", inputs_, false);
  ParseSignalNames(js_obj, "outputs", outputs_, true);

  std::vector<std::string> inputs, parsed;
  ParseStrings(js_obj, "inputs", inputs, false);

  for (std::string& str : inputs) {
    parsed = grammar.Parse(str);
    input_port_widths_.push_back(parsed.size());
  }

  if (js_obj.contains("intermediates")) {
    if (js_obj["intermediates"].is_array()) {
      for (const auto& lvl : js_obj["intermediates"].as_array()) {
        js::object lvl_obj = lvl.as_object();
        ParseSignalNames(lvl_obj, "names", mids_, true);
        ParseStrings(lvl_obj, "equations", expr_mids_, true);
      }
    } else {
      throw std::runtime_error(err_msg + name +
                               ". Invalid or missing intermediates!");
    }
  }

  if (!js_obj.contains("type")) {
    throw std::runtime_error(err_msg + name + ". \"type\" not found!");
  } else {
    std::string type = value.at("type").as_string().c_str();
    if (type == "gate" || type == "conservative_gate") {
      type_ = cell_t::combinational;
    } else if (type == "lut") {
      type_ = cell_t::lut;
    } else if (type == "buffer") {
      type_ = cell_t::buffer;
    } else if (type == "relaxed_gate") {
      type_ = cell_t::relaxed;
    } else if (type == "register") {
      type_ = cell_t::sequential;
    } else if (type == "latch") {
      type_ = cell_t::latch;
    } else {
      throw std::runtime_error(err_msg + name + ". Invalid value \"" + type +
                               "\" for \"type\"!");
    }
  }

  ParseStrings(js_obj, "equations", expr_, true);

  if (type_ == cell_t::sequential) {
    if (!js_obj.contains("timing")) {
      clk_edge_ = clk_edge_t::rising;
    } else {
      if (value.at("timing").is_string()) {
        std::string clk_edge = value.at("timing").as_string().c_str();

        if (clk_edge == "rising_edge") {
          clk_edge_ = clk_edge_t::rising;
        } else if (clk_edge == "falling_edge") {
          clk_edge_ = clk_edge_t::falling;
        } else if (clk_edge == "both") {
          clk_edge_ = clk_edge_t::both;
        } else {
          throw std::runtime_error(err_msg + name + ". Invalid value \"" +
                                   clk_edge + "\" for \"timing\"!");
        }
      } else {
        throw std::runtime_error(err_msg + name +
                                 ". \"timing\" is not a string!");
      }
    }

    if (!js_obj.contains("clock")) {
      throw std::runtime_error(err_msg + name + "\". \"clock\" not found!");
    } else {
      std::string clk = value.at("clock").as_string().c_str();
      std::vector<std::string>::iterator it =
          std::find(inputs_.begin(), inputs_.end(), clk);

      if (it == inputs_.end()) {
        throw std::runtime_error(err_msg + name + ". Invalid clock \"" + clk +
                                 "\"!");
      } else {
        clk_ = std::distance(inputs_.begin(), it);
      }
    }
  } else if (js_obj.contains("clock")) {
    throw std::runtime_error(err_msg + name + ". Invalid key \"clock\"!");
  }
}

cell_t Cell::GetType() const { return type_; }

clk_edge_t Cell::GetClkEdge() const { return clk_edge_; }

std::optional<uint64_t> Cell::GetClock() const { return clk_; }

const std::vector<std::string> Cell::GetIdentifiers() const { return ids_; }

uint64_t Cell::GetNumberOfIdentifiers() const { return ids_.size(); }

uint64_t Cell::GetNumberOfInputs() const { return inputs_.size(); }

uint64_t Cell::GetNumberOfOutputs() const { return outputs_.size(); }

uint64_t Cell::GetNumberOfMids() const { return mids_.size(); }

std::string Cell::GetIdentifier(uint64_t index) const { return ids_[index]; }

std::string Cell::GetInput(uint64_t index) const {
  assert(index < inputs_.size() &&
         "Error in Cell::GetInput: Index out of bounds!");
  return inputs_[index];
}

std::string Cell::GetOutput(uint64_t index) const {
  assert(index < outputs_.size() &&
         "Error in Cell::GetOutput: Index out of bounds!");
  return outputs_[index];
}

std::string Cell::GetMid(uint64_t index) const {
  assert(index < mids_.size() && "Error in Cell::GetMid: Index out of bounds!");
  return mids_[index];
}