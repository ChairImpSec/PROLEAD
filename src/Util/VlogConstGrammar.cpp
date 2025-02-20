#include "Util/VlogConstGrammar.hpp"

std::vector<vlog_bit_t> VlogConstGrammar::Invert(
    std::vector<vlog_bit_t>& value) {
  std::vector<vlog_bit_t> parsed;
  parsed.reserve(value.size());

  std::transform(value.begin(), value.end(), std::back_inserter(parsed),
                 [](vlog_bit_t vlog_bit) {
                   return (vlog_bit == vlog_bit_t::zero)  ? vlog_bit_t::one
                          : (vlog_bit == vlog_bit_t::one) ? vlog_bit_t::zero
                                                          : vlog_bit;
                 });
  return parsed;
}

std::vector<vlog_bit_t> VlogConstGrammar::Repeat(
    uint64_t number_of_reps, std::vector<vlog_bit_t>& value) {
  std::vector<vlog_bit_t> repetition;

  if (number_of_reps) {
    for (uint64_t idx = 0; idx < number_of_reps; ++idx) {
      repetition.insert(repetition.end(), value.begin(), value.end());
    }
  } else {
    throw std::invalid_argument(
        "Error while parsing a repetition: Repetition count cannot be zero!");
  }

  return repetition;
}

std::vector<vlog_bit_t> VlogConstGrammar::Append(
    std::vector<std::vector<vlog_bit_t>>& values) {
  std::vector<vlog_bit_t> concatenation;

  for (std::vector<vlog_bit_t>& value : values) {
    concatenation.insert(concatenation.end(), value.begin(), value.end());
  }

  return concatenation;
}

uint64_t VlogConstGrammar::ParseRepCount(uint64_t width_in_bits,
                                         uint64_t value) {
  uint64_t width_of_value_in_bits =
      (value == 0) ? 1 : static_cast<uint64_t>(std::log2(value)) + 1;

  if (width_of_value_in_bits != width_in_bits) {
    throw std::invalid_argument(
        "Error while parsing a repitition count: Length mismatch: Expected " +
        std::to_string(width_in_bits) + " bits, got " +
        std::to_string(width_of_value_in_bits) + " bits!");
  }

  return value;
}

std::vector<vlog_bit_t> VlogConstGrammar::ParseBin(uint64_t width_in_bits,
                                                   std::string value) {
  std::vector<vlog_bit_t> parsed;
  value.erase(std::remove(value.begin(), value.end(), '_'), value.end());

  if (value.size() != width_in_bits) {
    throw std::invalid_argument(
        "Error while parsing a binary value: Length mismatch: Expected " +
        std::to_string(width_in_bits) + " bits, got " +
        std::to_string(value.size()) + " bits!");
  }

  parsed.reserve(value.size());

  for (unsigned char vlog_bit : value) {
    if (vlog_bit == '0') {
      parsed.push_back(vlog_bit_t::zero);
    } else if ((vlog_bit == '1')) {
      parsed.push_back(vlog_bit_t::one);
    } else if (vlog_bit == 'x' || vlog_bit == 'X') {
      parsed.push_back(vlog_bit_t::unknown);
    } else if (vlog_bit == 'z' || vlog_bit == 'Z') {
      parsed.push_back(vlog_bit_t::high_impedance);
    } else if (vlog_bit == '$') {
      parsed.push_back(vlog_bit_t::random);
    } else {
      throw std::invalid_argument(
          "Error while parsing a binary value: Invalid character: \"" +
          std::to_string(vlog_bit) + "\"!");
    }
  }

  return parsed;
}

std::vector<vlog_bit_t> VlogConstGrammar::ParseDec(uint64_t width_in_bits,
                                                   uint64_t value) {
  std::vector<vlog_bit_t> parsed(width_in_bits);

  for (int64_t idx = width_in_bits - 1; idx >= 0; --idx) {
    parsed[idx] = (value & 1) ? vlog_bit_t::one : vlog_bit_t::zero;
    value >>= 1;
  }

  if (value) {
    throw std::invalid_argument(
        "Error while parsing a decimal constant: Length mismatch!");
  } else {
    return parsed;
  }
}

std::vector<vlog_bit_t> VlogConstGrammar::ParseHex(uint64_t width_in_bits,
                                                   std::string value) {
  uint64_t decoded_hex_val, char_width_in_bits;
  std::vector<vlog_bit_t> parsed;

  for (unsigned char hex_char : value) {
    char_width_in_bits = (width_in_bits & 0b11) ? (width_in_bits & 0b11) : 4;

    if (hex_char == 'x' || hex_char == 'X') {
      for (uint64_t idx = 0; idx < char_width_in_bits; ++idx) {
        parsed.push_back(vlog_bit_t::unknown);
      }
    } else if (hex_char == 'z' || hex_char == 'Z') {
      for (uint64_t idx = 0; idx < char_width_in_bits; ++idx) {
        parsed.push_back(vlog_bit_t::high_impedance);
      }
    } else if (hex_char == '$') {
      for (uint64_t idx = 0; idx < char_width_in_bits; ++idx) {
        parsed.push_back(vlog_bit_t::random);
      }
    } else {
      if (hex_char >= '0' && hex_char <= '9') {
        decoded_hex_val = hex_char - '0';
      } else if (hex_char >= 'a' && hex_char <= 'f') {
        decoded_hex_val = 10 + (hex_char - 'a');
      } else if (hex_char >= 'A' && hex_char <= 'F') {
        decoded_hex_val = 10 + (hex_char - 'A');
      } else {
        throw std::invalid_argument(
            "Error while converting a hexdecimal character to its binary "
            "representation: Invalid character: \"" +
            std::to_string(hex_char) + "\"!");
      }

      parsed.resize(parsed.size() + char_width_in_bits);
      for (uint64_t idx = 0; idx < char_width_in_bits; ++idx) {
        parsed[parsed.size() - 1 - idx] =
            (decoded_hex_val & 1) ? vlog_bit_t::one : vlog_bit_t::zero;
        decoded_hex_val >>= 1;
      }
    }

    width_in_bits -= char_width_in_bits;
    if (decoded_hex_val) {
      throw std::invalid_argument(
          "Error while parsing a hexadecimal constant: Length mismatch!");
    }
  }

  return parsed;
}

VlogConstGrammar::VlogConstGrammar() : VlogConstGrammar::base_type(expr) {
  width = qi::uint_;
  bin_val = +qi::char_("01$xXzZ_");
  dec_val = qi::uint_;
  hex_val = +qi::char_("0-9a-fA-F$xXzZ_");
  bin_nr = (width >> (qi::lit("'b") | qi::lit("'B")) >>
            qi::bin)[qi::_val = phx::bind(&VlogConstGrammar::ParseRepCount,
                                          this, qi::_1, qi::_2)];
  dec_nr = (width >> (qi::lit("'d") | qi::lit("'D")) >>
            qi::uint_)[qi::_val = phx::bind(&VlogConstGrammar::ParseRepCount,
                                            this, qi::_1, qi::_2)];
  hex_nr = (width >> (qi::lit("'h") | qi::lit("'H")) >>
            qi::hex)[qi::_val = phx::bind(&VlogConstGrammar::ParseRepCount,
                                          this, qi::_1, qi::_2)];
  rep_nr = bin_nr | dec_nr | hex_nr;

  bin = (width >> (qi::lit("'b") | qi::lit("'B")) >>
         bin_val)[qi::_val = phx::bind(&VlogConstGrammar::ParseBin, this,
                                       qi::_1, qi::_2)];
  dec = (width >> (qi::lit("'d") | qi::lit("'D")) >>
         dec_val)[qi::_val = phx::bind(&VlogConstGrammar::ParseDec, this,
                                       qi::_1, qi::_2)];
  hex = (width >> (qi::lit("'h") | qi::lit("'H")) >>
         hex_val)[qi::_val = phx::bind(&VlogConstGrammar::ParseHex, this,
                                       qi::_1, qi::_2)];
  reg = bin | dec | hex;
  inv = (qi::lit("~") >>
         reg)[qi::_val = phx::bind(&VlogConstGrammar::Invert, this, qi::_1)];

  rep = (qi::lit("{") >> rep_nr >> qi::lit("{") >> expr >>
         qi::lit("}}"))[qi::_val = phx::bind(&VlogConstGrammar::Repeat, this,
                                             qi::_1, qi::_2)];
  concat =
      (qi::lit("{") >> (expr % qi::lit(",")) >>
       qi::lit(
           "}"))[qi::_val = phx::bind(&VlogConstGrammar::Append, this, qi::_1)];
  expr = inv | reg | rep | concat;
}

std::vector<vlog_bit_t> VlogConstGrammar::Parse(std::string& vlog_const) {
  std::string::iterator begin = vlog_const.begin();
  std::string::iterator end = vlog_const.end();
  std::vector<vlog_bit_t> parsed;

  if (!qi::phrase_parse(begin, end, *this, qi::space, parsed)) {
    throw std::invalid_argument("Error while parsing the Verilog constant: \"" +
                                vlog_const + "\". Invalid syntax!");
  }

  std::reverse(parsed.begin(), parsed.end());
  return parsed;
}