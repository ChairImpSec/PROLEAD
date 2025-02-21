#include "Util/RangeGrammar.hpp"

std::pair<double, double> RangeGrammar::Construct(double lhs, double rhs) {
  double first = std::min(lhs, rhs);
  double second = std::max(lhs, rhs);

  if (first >= 0) {
    return std::make_pair(first, second);
  } else {
    if (first == second) {
      throw std::invalid_argument("Error while parsing the range \"" +
                                  std::to_string(second) +
                                  "\": Negative numbers are invalid!");
    } else {
      throw std::invalid_argument(
          "Error while parsing the range \"" + std::to_string(first) + "-" +
          std::to_string(second) + "\": Negative numbers are invalid!");
    }
  }
}

RangeGrammar::RangeGrammar() : RangeGrammar::base_type(range_) {
  number_ = qi::double_;
  range_ =
      (number_ >> '-' >> number_)[qi::_val = phx::bind(&RangeGrammar::Construct,
                                                       this, qi::_1, qi::_2)] |
      number_[qi::_val =
                  phx::bind(&RangeGrammar::Construct, this, qi::_1, qi::_1)];
}

std::pair<double, double> RangeGrammar::Parse(std::string& range) {
  std::string::iterator begin = range.begin();
  std::string::iterator end = range.end();
  std::pair<double, double> parsed;

  if (!qi::phrase_parse(begin, end, *this, qi::space, parsed)) {
    throw std::invalid_argument("Error while parsing the number range: \"" +
                                range + "\". Invalid syntax!");
  }

  return parsed;
}