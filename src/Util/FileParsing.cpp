#include "Util/FileParsing.hpp"

IntegerRangeGrammar::IntegerRangeGrammar(uint64_t maximum_value)
    : IntegerRangeGrammar::base_type(range_) {
  range_ =
      (qi::int_ >> '-' >> qi::int_)
          [phx::if_(qi::_1 <= qi::_2 && qi::_1 >= 0 && qi::_2 >= 0 &&
                    qi::_1 <= maximum_value &&
                    qi::_2 <= maximum_value)[qi::_val = phx::construct<
                                                 std::pair<uint64_t, uint64_t>>(
                                                 qi::_1, qi::_2)]
               .else_[phx::throw_(std::invalid_argument(
                   "Error while parsing the integer range: Invalid range"))]] |
      qi::int_
          [phx::if_(qi::_1 >= 0 &&
                    qi::_1 <= maximum_value)[qi::_val = phx::construct<
                                                 std::pair<uint64_t, uint64_t>>(
                                                 qi::_1, qi::_1)]
               .else_[phx::throw_(std::invalid_argument(
                   "Error while parsing the integer range: Invalid range"))]];
}

std::pair<uint64_t, uint64_t> IntegerRangeGrammar::Parse(
    std::string& integer_range_string) {
  std::pair<uint64_t, uint64_t> range;
  std::string::iterator begin, end;
  begin = integer_range_string.begin();
  end = integer_range_string.end();
  bool success = qi::phrase_parse(begin, end, *this, qi::space, range);

  if (!success || (begin != end)) {
    throw std::invalid_argument(
        "Error while parsing the integer range: Parsing failed");
  }

  return range;
}

std::vector<TriStateBit> VerilogBitstringGrammar::ConvertHexCharsToBinary(
    const char& hex_char) {
  int hex_int;
  if (hex_char >= '0' && hex_char <= '9') {
    hex_int = hex_char - '0';
  } else if (hex_char >= 'a' && hex_char <= 'f') {
    hex_int = 10 + (hex_char - 'a');
  } else if (hex_char >= 'A' && hex_char <= 'F') {
    hex_int = 10 + (hex_char - 'A');
  } else if (hex_char == 'x' || hex_char == 'X') {
    return std::vector<TriStateBit>(4, TriStateBit::undefined_value);
  } else if (hex_char == '$') {
    return std::vector<TriStateBit>(4, TriStateBit::random_value);
  } else {
    throw std::invalid_argument(
        "Error while converting a hexdecimal character to binary: Invalid "
        "character");
  }

  std::vector<TriStateBit> hex_bin(4);
  for (size_t i = 0; i < 4; ++i) {
    if (is_inverted) {
      hex_bin[3 - i] = (hex_int & (1 << i)) ? TriStateBit::zero_value
                                            : TriStateBit::one_value;
    } else {
      hex_bin[3 - i] = (hex_int & (1 << i)) ? TriStateBit::one_value
                                            : TriStateBit::zero_value;
    }
  }
  return hex_bin;
}

VerilogBitstringGrammar::VerilogBitstringGrammar()
    : VerilogBitstringGrammar::base_type(value) {
  bin_value = qi::lit("'b") >> +qi::char_("01$xX");
  hex_value = qi::lit("'h") >> +qi::char_("0-9a-fA-F$xX");

  value = -(qi::lit("~")[([&]() { is_inverted = true; })]) >>
          qi::uint_[([&](uint64_t number) { number_of_bits = number; })] >>
          (bin_value[([&](const std::string& tri_state_bit_string) {
             if (tri_state_bit_string.size() != number_of_bits) {
               throw std::invalid_argument(
                   "Error while parsing the binary string \"" + input_string_ +
                   "\": Length mismatch!");
             }
             for (char tri_state_bit : tri_state_bit_string) {
               if ((tri_state_bit == '0' && !is_inverted) ||
                   (tri_state_bit == '1' && is_inverted)) {
                 result.push_back(TriStateBit::zero_value);
               } else if ((tri_state_bit == '1' && !is_inverted) ||
                          (tri_state_bit == '0' && is_inverted)) {
                 result.push_back(TriStateBit::one_value);
               } else if (tri_state_bit == 'x' || tri_state_bit == 'X') {
                 result.push_back(TriStateBit::undefined_value);
               } else if (tri_state_bit == '$') {
                 result.push_back(TriStateBit::random_value);
               } else {
                 throw std::invalid_argument(
                     "Error while parsing the binary string \"" +
                     input_string_ + ": Invalid character!\"");
               }
             }
           })] |
           hex_value[([&](const std::string& tri_state_hex_string) {
             if (tri_state_hex_string.size() != (number_of_bits + 3) / 4) {
               throw std::invalid_argument(
                   "Error while parsing the hexadecimal string" + input_string_ +
                   ": Length mismatch");
             }
             for (char tri_state_hex_char : tri_state_hex_string) {
               std::vector<TriStateBit> tri_state_bits =
                   ConvertHexCharsToBinary(tri_state_hex_char);
               result.insert(result.end(), tri_state_bits.begin(),
                             tri_state_bits.end());
             }
           })]);
}

std::vector<TriStateBit> VerilogBitstringGrammar::Parse(
    std::string& tri_state_string) {
  std::string::iterator begin, end;
  input_string_ = tri_state_string;
  begin = tri_state_string.begin();
  end = tri_state_string.end();
  result.clear();

  is_inverted = false;

  if (!qi::phrase_parse(begin, end, *this, qi::space)) {
    throw std::invalid_argument(
        "Error while parsing the Verilog bitstring: Parsing failed");
  }

  std::reverse(result.begin(), result.end());
  return result;
}

InputAssignmentGrammar::InputAssignmentGrammar()
    : InputAssignmentGrammar::base_type(value) {
  value = shared_value | (constant_value[([&](std::string& verilog_bitstring) {
            VerilogBitstringGrammar verilog_grammar;
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
    throw std::invalid_argument(
        "Error while parsing an input assignment: Parsing failed");
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
  std::string error_context = "Error while parsing an irreducible polynomial: ";
  std::string galois_field =
      "GF(" + std::to_string(base) + "^" + std::to_string(exponent) + ")";
  std::string::iterator begin, end;
  std::vector<uint64_t> coefficients;
  std::vector<std::pair<uint64_t, uint64_t>> monomials;
  begin = polynomial_string.begin();
  end = polynomial_string.end();

  if (!qi::phrase_parse(begin, end, *this, qi::space, monomials)) {
    throw std::invalid_argument(error_context + "Parsing failed!");
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
      throw std::invalid_argument(error_context + "Coefficient of term \"" +
                                  std::to_string(monomial.first) + "x^" +
                                  std::to_string(monomial.second) +
                                  "\" is not allowed in " + galois_field + "!");
    } else if (monomial.second > exponent) {
      throw std::invalid_argument(error_context + "Exponent of term \"" +
                                  std::to_string(monomial.first) + "x^" +
                                  std::to_string(monomial.second) +
                                  "\" is not allowed in " + galois_field + "!");
    } else {
      coefficients.push_back(monomial.first);
    }
  }

  std::reverse(coefficients.begin(), coefficients.end());
  return coefficients;
}

SignalNameGrammar::SignalNameGrammar() : SignalNameGrammar::base_type(value) {
  value = (vector_name | signal_name);
  vector_name = qi::lit('{') >> (signal_name % ',') >> qi::lit('}');
  signal_name =
      signal_with_range | signal_with_index | signal_without_index_or_range;
  signal_with_range =
      identifier[([&](std::string id) { current_identifier = id; })] >>
      qi::lit('[') >> qi::uint_[([&](uint64_t idx) { left_index = idx; })] >>
      ':' >> qi::uint_[([&](uint64_t right_index) {
        std::vector<std::string> tmp;

        if (left_index > right_index) {
          for (int64_t i = right_index; i <= (int64_t)left_index; ++i) {
            tmp.push_back(current_identifier + "[" + std::to_string(i) + "]");
          }
        } else {
          if (left_index < right_index) {
            for (int64_t i = right_index; i >= (int64_t)left_index; --i) {
              tmp.push_back(current_identifier + "[" + std::to_string(i) + "]");
            }
          } else {
            tmp.push_back(current_identifier + "[" +
                          std::to_string(left_index) + "]");
          }
        }
        result.insert(result.begin(), tmp.begin(), tmp.end());
      })] >>
      qi::lit(']');
  signal_with_index = index[([&](std::string id) {
    std::vector<std::string> tmp = {id};
    result.insert(result.begin(), tmp.begin(), tmp.end());
  })];

  signal_without_index_or_range = identifier[([&](std::string id) {
    std::vector<std::string> tmp = {id};
    result.insert(result.begin(), tmp.begin(), tmp.end());
  })];

  index = qi::raw[identifier >> qi::lit('[') >> qi::uint_ >> qi::lit(']')];
  identifier = qi::lexeme[+(qi::char_("a-zA-Z_") >> *qi::char_("a-zA-Z0-9_"))];
}

std::vector<std::string> SignalNameGrammar::Parse(
    std::string& signal_name_string) {
  std::string::iterator begin, end;
  begin = signal_name_string.begin();
  end = signal_name_string.end();
  result.clear();

  bool success = qi::phrase_parse(begin, end, *this, qi::space);

  if (!success || (begin != end)) {
    throw std::invalid_argument(
        "Error while parsing the signal names: Parsing failed");
  }

  return result;
}

std::ifstream OpenFile(const std::filesystem::path& path) {
  std::ifstream stream(path);

  if (!stream.is_open()) {
    std::string error_message =
        "Error while opening the file located at path \"" + path.string() +
        "\": ";
    throw std::runtime_error(error_message + "File not found.");
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
        error_message = "Error while copying the value of the key \"" + key +
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
      error_message = "Error while copying the value of the key \"" + key +
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
