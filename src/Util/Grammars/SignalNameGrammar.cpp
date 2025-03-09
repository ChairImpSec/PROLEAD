#include "Util/Grammars/SignalNameGrammar.hpp"

std::vector<std::string> SignalNameGrammar::Append(
    std::vector<std::string> lhs, std::vector<std::string> rhs) {
  lhs.insert(lhs.begin(), rhs.begin(), rhs.end());
  return lhs;
}

std::tuple<uint64_t, uint64_t, bool> SignalNameGrammar::SetBounds(
    uint64_t lhs, uint64_t rhs, bool is_range) {
  return std::make_tuple(lhs, rhs, is_range);
}

std::vector<std::string> SignalNameGrammar::SetSignalNames(
    std::string id, std::vector<std::tuple<uint64_t, uint64_t, bool>> bounds) {
  std::vector<std::string> signal_names;

  if (!bounds.empty()) {
    for (uint64_t idx = 0; idx < bounds.size() - 1; ++idx) {
      if (std::get<2>(bounds[idx])) {
        id += "[" + std::to_string(std::get<0>(bounds[idx])) + ":" +
              std::to_string(std::get<1>(bounds[idx])) + "]";
      } else {
        id += "[" + std::to_string(std::get<0>(bounds[idx])) + "]";
      }
    }

    uint64_t lhs = std::get<0>(bounds.back());
    uint64_t rhs = std::get<1>(bounds.back());
    uint64_t max = std::max(lhs, rhs);
    uint64_t min = std::min(lhs, rhs);

    for (uint64_t idx = min; idx <= max; ++idx) {
      signal_names.push_back(id + "[" + std::to_string(idx) + "]");
    }

    if (lhs < rhs) {
      std::reverse(signal_names.begin(), signal_names.end());
    }
  } else {
    signal_names.push_back(id);
  }

  return signal_names;
}

SignalNameGrammar::SignalNameGrammar() : SignalNameGrammar::base_type(value) {
  value = signal_name | vector_name;

  vector_name = qi::lit('{') >>
                (signal_name[qi::_val = phx::bind(&SignalNameGrammar::Append,
                                                  this, qi::_val, qi::_1)] %
                 ',') >>
                qi::lit('}');
  signal_name =
      (identifier >>
       *(range |
         index))[qi::_val = phx::bind(&SignalNameGrammar::SetSignalNames, this,
                                      qi::_1, qi::_2)];
  range = ('[' >> qi::uint_ >> ':' >> qi::uint_ >>
           ']')[qi::_val = phx::bind(&SignalNameGrammar::SetBounds, this,
                                     qi::_1, qi::_2, true)];
  index = ('[' >> qi::uint_ >>
           ']')[qi::_val = phx::bind(&SignalNameGrammar::SetBounds, this,
                                     qi::_1, qi::_1, false)];
  identifier =
      qi::lexeme[+(qi::char_("\\a-zA-Z_") >> *qi::char_("a-zA-Z0-9_"))];
}

std::vector<std::string> SignalNameGrammar::Parse(const std::string& signal) {
  std::string signal_copy = signal;
  std::string::iterator begin = signal_copy.begin();
  std::string::iterator end = signal_copy.end();
  std::vector<std::string> parsed;

  bool success = qi::phrase_parse(begin, end, *this, qi::space, parsed);

  if (!success || (begin != end)) {
    std::string error_message = "Error while parsing signal name: \"" +
                                signal_copy + "\". Invalid syntax!";
    throw std::invalid_argument(error_message);
  }

  return parsed;
}