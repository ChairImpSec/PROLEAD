/**
 * @file SignalNameGrammar.hpp
 * @brief A grammar for parsing signal names.
 *
 * @version 0.0.1
 * @date 2025-03-08
 *
 * @author Nicolai Müller
 */
#pragma once

#include <boost/phoenix/phoenix.hpp>    // For e.g. _val
#include <boost/spirit/include/qi.hpp>  // For e.g. lit
#include <cinttypes>                    // For uint64_t
#include <vector>                       // For std::vector

namespace qi = boost::spirit::qi;
namespace phx = boost::phoenix;

/**
 * @brief A grammar for parsing a signal name.
 * @details The grammar is used to parse a signal name or the composition of
 * multiple signal names in the form of "signale_name", "signal_name[0:9]", or
 * "{signal_name1,signal_name2,signal_name[0:9]}". It returns a vector of
 * strings, where each string represents a signal name. The signal name can be a
 * single signal name or a signal name with an index in the form of
 * "signal_name[0]" or "signal_name[1]".
 */
class SignalNameGrammar
    : public qi::grammar<std::string::iterator, std::vector<std::string>(),
                         qi::space_type> {
 public:
  SignalNameGrammar();
  std::vector<std::string> Parse(const std::string& signal);

 private:
  qi::rule<std::string::iterator, std::vector<std::string>(), qi::space_type> value,vector_name, signal_name;
  qi::rule<std::string::iterator, std::tuple<uint64_t, uint64_t, bool>(), qi::space_type> range, index;
  qi::rule<std::string::iterator, std::string(), qi::space_type> identifier;
  std::vector<std::string> Append(std::vector<std::string> lhs, std::vector<std::string> rhs);
  std::tuple<uint64_t, uint64_t, bool> SetBounds(uint64_t lhs, uint64_t rhs, bool is_range);
  std::vector<std::string> SetSignalNames(std::string id, std::vector<std::tuple<uint64_t, uint64_t, bool>> bounds);
};