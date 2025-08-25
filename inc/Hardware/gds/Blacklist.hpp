
#pragma once

#include <set>
#include <string>
#include "Gate.hpp"
#include <iostream>
#include <vector>
#include <gdstk/library.hpp>
#include <gdstk/cell.hpp>
#include <boost/log/trivial.hpp>

using Gates = std::vector<Gate>;
/**
 * @brief The Blacklist class represents a collection of gate names that are blacklisted.
 */
struct Blacklist {
  std::set<std::string> elements;

  Blacklist(std::initializer_list<std::string>);
  Blacklist();

  bool IsInBlacklist(const std::string &name) const;

  Gates FilterGates(const gdstk::Library &lib, const std::string & top_level_name) const;

  Blacklist& operator+=(Blacklist & rhs)&;

  friend Blacklist operator+(Blacklist lhs, Blacklist & rhs);
  friend std::ostream& operator<<(std::ostream &out, Blacklist const& blacklist);
};

