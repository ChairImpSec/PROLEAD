#include "Util/FileParsing.hpp"
#include <boost/log/trivial.hpp>

JsonSchema::JsonSchema(const std::string& key, const std::string& type)
    : key_(key), type_(type) {}

JsonSchema::JsonSchema(const std::string& key, const std::string& type,
                       const std::vector<JsonSchema>& children)
    : key_(key), type_(type), children_(children) {}

void JsonSchema::Validate(const boost::json::object& json_object) {
  std::string error_context = "Error while validating JSON: ";
  std::string key, type;

  for (const auto& pair : json_object) {
    key = pair.key_c_str();

    assert(std::is_sorted(children_.begin(), children_.end(),
                          [](const JsonSchema& a, const JsonSchema& b) {
                            return a.key_ < b.key_;
                          }) &&
           "Error while parsing the JSON object: Children are not sorted!");

    auto child = std::find_if(
        children_.begin(), children_.end(),
        [&key](const JsonSchema& scheme) { return scheme.key_ == key; });

    if (child != children_.end()) {
      type = child->type_;
      BOOST_LOG_TRIVIAL(trace) << "Found child with key: " << key << " and type: " << type;
      if (child->children_.empty()) {
        // TODO: Add validation of settings with multiple data types.
        if ((key != "number_of_clock_cycles") && (key != "hold_for_cycles")) {
          if (type == "int") {
            uint64_t variable;
            SetValue(json_object, key, variable);
          } else if (type == "double") {
            double variable;
            SetValue(json_object, key, variable);
          } else if (type == "string") {
            std::string variable;
            SetValue(json_object, key, variable);
          } else if (type == "bool") {
            bool variable;
            SetValue(json_object, key, variable);
          } else if (type == "array") {
            boost::json::array variable;
            SetValue(json_object, key, variable);
          } else {
            throw std::invalid_argument(error_context + "Unknown data type \"" +
                                        type + "\" for key \"" + key +
                                        "\" in JSON scheme!");
          }
        }
      } else {
        if (type == "array") {
          boost::json::array json_array;
          SetValue(json_object, key, json_array);
          for (const auto& array_element : json_array) {
            child->children_[0].Validate(array_element.as_object());
          }
        } else if (type == "object") {
          boost::json::object variable;
          SetValue(json_object, key, variable);
          child->Validate(variable);
        } else {
          throw std::invalid_argument(error_context + "Unknown data type \"" +
                                      type_ + "\" in JSON scheme!");
        }
      }
    } else {
      throw std::invalid_argument(error_context + "Key \"" + key +
                                  "\" not found!");
    }
  }
}

InputAssignmentGrammar::InputAssignmentGrammar()
    : InputAssignmentGrammar::base_type(value) {
  value = shared_value | (constant_value[([&](std::string& verilog_bitstring) {
            VlogConstGrammar verilog_grammar;
            result_.signal_values_ = verilog_grammar.Parse(verilog_bitstring);
          })]);

  shared_value =
      -(qi::lit("~")[([&]() { result_.is_inverted_ = true; })]) >>
      qi::lit("group_in") >>
      qi::uint_[([&](uint64_t idx) { result_.share_index_ = idx; })] >>
      (range | index);

  range = qi::lit('[') >> qi::int_[([&](int64_t idx) { left_index_ = idx; })] >>
          qi::lit(':') >>
          qi::int_[([&](int64_t idx) { right_index_ = idx; })] >>
          qi::lit(']') >> qi::eps[([&]() {
            if (left_index_ >= right_index_) {
              for (int64_t i = right_index_; i <= left_index_; ++i) {
                result_.group_indices_.push_back(i);
              }
            } else {
              for (int64_t i = right_index_; i >= left_index_; --i) {
                result_.group_indices_.push_back(i);
              }
            }
          })];

  index = qi::raw[qi::lit('[') >> qi::uint_[([&](uint64_t idx) {
                    result_.group_indices_ = {idx};
                  })] >>
                  qi::lit(']')];

  constant_value =
      qi::raw[-qi::lit("~") >> qi::uint_ >> (bin_value | hex_value)];
  bin_value = qi::lit("'b") >> +qi::char_("01$");
  hex_value = qi::lit("'h") >> +qi::char_("0-9a-fA-F$");
}

InputAssignment InputAssignmentGrammar::Parse(
    std::string& input_assignment_string) {
  std::string::iterator begin, end;
  begin = input_assignment_string.begin();
  end = input_assignment_string.end();

  left_index_ = 0;
  right_index_ = 0;
  result_.is_inverted_ = false;
  result_.share_index_ = 0;
  result_.group_indices_.clear();
  result_.signal_names_.clear();
  result_.signal_values_.clear();

  if (!qi::phrase_parse(begin, end, *this, qi::space)) {
    std::string error_message = "Error while parsing the input assignment: \"" +
                                input_assignment_string + "\". Invalid syntax!";
    throw std::invalid_argument(error_message);
  }

  return result_;
}

IrreduciblePolynomialGrammar::IrreduciblePolynomialGrammar()
    : IrreduciblePolynomialGrammar::grammar::base_type(polynomial_) {
  exponent_ %= qi::lit('^') >> qi::uint_;
  base_ %= qi::lit('x') >> (exponent_ | qi::eps[qi::_val = 1]);
  monomial_ =
      qi::eps[qi::_val = std::pair<uint64_t, uint64_t>()] >>
      (qi::uint_[phx::bind(&std::pair<uint64_t, uint64_t>::first, qi::_val) =
                     qi::_1] |
       qi::eps[phx::bind(&std::pair<uint64_t, uint64_t>::first, qi::_val) =
                   1]) >>
      -base_[phx::bind(&std::pair<uint64_t, uint64_t>::second, qi::_val) =
                 qi::_1];
  polynomial_ =
      qi::eps[qi::_val = std::vector<std::pair<uint64_t, uint64_t>>()] >>
      monomial_[phx::push_back(qi::_val, qi::_1)] >>
      *(qi::lit('+') >> monomial_[phx::push_back(qi::_val, qi::_1)]);
}

std::vector<uint64_t> IrreduciblePolynomialGrammar::Parse(
    std::string& polynomial_string, uint64_t base, uint64_t exponent) {
  std::string error_context =
      "Error while parsing the polynomial: " + polynomial_string + ". ";
  std::string galois_field =
      "GF(" + std::to_string(base) + "^" + std::to_string(exponent) + ")";
  std::string::iterator begin, end;
  std::vector<uint64_t> coefficients;
  std::vector<std::pair<uint64_t, uint64_t>> monomials;
  begin = polynomial_string.begin();
  end = polynomial_string.end();

  if (!qi::phrase_parse(begin, end, *this, qi::space, monomials)) {
    throw std::invalid_argument(error_context + "Invalid syntax!");
  }

  for (uint64_t index = 0; index <= exponent; ++index) {
    monomials.push_back(std::make_pair(0, index));
  }

  std::sort(monomials.begin(), monomials.end(),
            [](const std::pair<uint64_t, uint64_t>& lhs,
               const std::pair<uint64_t, uint64_t>& rhs) {
              return lhs.second > rhs.second;
            });

  auto it = std::unique(monomials.begin(), monomials.end(),
                        [](std::pair<uint64_t, uint64_t>& lhs,
                           std::pair<uint64_t, uint64_t>& rhs) {
                          if (lhs.second == rhs.second) {
                            lhs.first += rhs.first;
                            return true;
                          }
                          return false;
                        });

  monomials.erase(it, monomials.end());

  for (const std::pair<uint64_t, uint64_t>& monomial : monomials) {
    if (monomial.first >= base) {
      throw std::invalid_argument(error_context + "Invalid coefficient: \"" +
                                  std::to_string(monomial.first) + "x^" +
                                  std::to_string(monomial.second) + "\" in " +
                                  galois_field + "!");
    } else if (monomial.second > exponent) {
      throw std::invalid_argument(error_context + "Invalid coefficient: \"" +
                                  std::to_string(monomial.first) + "x^" +
                                  std::to_string(monomial.second) + "\" in " +
                                  galois_field + "!");
    } else {
      coefficients.push_back(monomial.first);
    }
  }

  std::reverse(coefficients.begin(), coefficients.end());
  return coefficients;
}

std::ifstream OpenFile(const std::filesystem::path& path) {
  std::ifstream stream(path);

  if (!stream.is_open()) {
    std::string error_message =
        "Error while opening the file located at path \"" + path.string() +
        "\": ";
    throw std::runtime_error(error_message + "File not found!");
  }

  return stream;
}

js::object ParseJsonFile(const std::filesystem::path& path) {
  std::ifstream stream = OpenFile(path);
  js::object json_object;
  std::string data{std::istreambuf_iterator<char>(stream),
                   std::istreambuf_iterator<char>()};
  js::parse_options opt;
  opt.allow_comments = true;

  try {
    js::value json_data = js::parse(
        data, js::make_shared_resource<js::monotonic_resource>(), opt);
    return json_data.as_object();
  } catch (const boost::system::system_error& e) {
    std::string error_message =
        "Error while parsing the JSON file located at path \"" + path.string() +
        "\": ";
    throw std::runtime_error(error_message + e.what());
  }
}

void WriteJsonFile(const std::filesystem::path& path, const boost::property_tree::ptree& content) {
  try {
    boost::property_tree::write_json(path, content);
    BOOST_LOG_TRIVIAL(trace) << "JSON file written successfully to: " << path.string();
  } catch (std::exception &e) {
    throw std::runtime_error("Error while writing to the JSON file located at path: "
      "\"" + path.string() + "\": " + e.what());
  }
}

void CheckValueType(const js::object& json_object, const std::string& key,
                    js::kind expected_type) {
  if (json_object.at(key).kind() != expected_type) {
    std::string error_message =
        "Error while checking the value type of the key \"" + key + "\": ";
    throw std::runtime_error(error_message +
                             "Value type does not match the "
                             "expected type.");
  }
}

template <typename T>
bool SetValue(const js::object& json_object, const std::string& key,
              T& variable) {
  std::string error_message;

  if (json_object.contains(key)) {
    if constexpr (std::is_same_v<T, uint64_t>) {
      CheckValueType(json_object, key, js::kind::int64);
      if (json_object.at(key).as_int64() >= 0) {
        variable = (uint64_t)json_object.at(key).as_int64();
      } else {
        error_message = "Error while parsing the value of the key \"" + key +
                        "\": Value is negative.";
        throw std::runtime_error(error_message);
      }
    } else if constexpr (std::is_same_v<T, double>) {
      CheckValueType(json_object, key, js::kind::double_);
      variable = json_object.at(key).as_double();
    } else if constexpr (std::is_same_v<T, std::string>) {
      CheckValueType(json_object, key, js::kind::string);
      variable = json_object.at(key).as_string().c_str();
    } else if constexpr (std::is_same_v<T, bool>) {
      CheckValueType(json_object, key, js::kind::bool_);
      variable = json_object.at(key).as_bool();
    } else if constexpr (std::is_same_v<T, js::array>) {
      CheckValueType(json_object, key, js::kind::array);
      variable = json_object.at(key).as_array();
    } else if constexpr (std::is_same_v<T, js::object>) {
      CheckValueType(json_object, key, js::kind::object);
      variable = json_object.at(key).as_object();
    } else {
      error_message = "Error while parsing the value of the key \"" + key +
                      "\": Unsupported data type.";
      throw std::runtime_error(error_message);
    }
    return true;
  } else {
    return false;
  }
}

template bool SetValue<uint64_t>(const js::object& json_object,
                                 const std::string& key, uint64_t& variable);
template bool SetValue<double>(const js::object& json_object,
                               const std::string& key, double& variable);
template bool SetValue<std::string>(const js::object& json_object,
                                    const std::string& key,
                                    std::string& variable);
template bool SetValue<bool>(const js::object& json_object,
                             const std::string& key, bool& variable);
template bool SetValue<js::array>(const js::object& json_object,
                                  const std::string& key, js::array& variable);
template bool SetValue<js::object>(const js::object& json_object,
                                   const std::string& key,
                                   js::object& variable);
