#include "Util/Grammars/BoolExprGrammar.hpp"

std::function<uint64_t(uint64_t, uint64_t)> Zero =
    [](uint64_t, uint64_t) { return 0; };

std::function<uint64_t(uint64_t, uint64_t)> One =
    [](uint64_t, uint64_t) { return 1; };

std::function<uint64_t(uint64_t, uint64_t)> Not =
    [](uint64_t lhs, uint64_t) { return ~lhs; };

std::function<uint64_t(uint64_t, uint64_t)> And =
    [](uint64_t lhs, uint64_t rhs) { return lhs & rhs; };

std::function<uint64_t(uint64_t, uint64_t)> Or =
    [](uint64_t lhs, uint64_t rhs) { return lhs | rhs; };

std::function<uint64_t(uint64_t, uint64_t)> Xor =
    [](uint64_t lhs, uint64_t rhs) { return lhs ^ rhs; };

Clause::Clause(uint64_t lhs_idx, uint64_t rhs_idx,
               const std::function<uint64_t(uint64_t, uint64_t)>* op)
    : lhs_idx_(lhs_idx), rhs_idx_(rhs_idx), op_(op) {}

bool Clause::operator==(const Clause& other) const {
  return lhs_idx_ == other.lhs_idx_ && rhs_idx_ == other.rhs_idx_ &&
         op_ == other.op_;
}

uint64_t Clause::Eval(const std::vector<uint64_t>& vals) const {
  return (*op_)(vals[lhs_idx_], vals[rhs_idx_]);
}

uint64_t BoolExprGrammar::SetClause(
    uint64_t lhs, uint64_t rhs,
    const std::function<uint64_t(uint64_t, uint64_t)>* op) {
  clauses_.emplace_back(lhs, rhs, op);
  return clauses_.size() + number_of_inputs_ - 1;
}

BoolExprGrammar::BoolExprGrammar() : BoolExprGrammar::base_type(or_term) {
  or_term = xor_term[qi::_val = qi::_1] >>
            *(qi::lit("|") >>
              xor_term[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this,
                                            qi::_val, qi::_1, &Or)]);
  xor_term = and_term[qi::_val = qi::_1] >>
             *(qi::lit("^") >>
               and_term[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this,
                                             qi::_val, qi::_1, &Xor)]);
  and_term = not_term[qi::_val = qi::_1] >>
             *(qi::lit("&") >>
               not_term[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this,
                                             qi::_val, qi::_1, &And)]);
  not_term = var[qi::_val = qi::_1] | zero | one |
             (qi::lit("~") >>
              not_term[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this,
                                            qi::_1, 0, &Not)]) |
             ('(' >> or_term >> ')')[qi::_val = qi::_1];
  var = qi::lit("i") >> qi::int_;
  zero = qi::lit("0")[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this, 0,
                                           0, &Zero)];
  one = qi::lit(
      "1")[qi::_val = phx::bind(&BoolExprGrammar::SetClause, this, 0, 0, &One)];
}

std::vector<Clause> BoolExprGrammar::Parse(
    const std::string& expr, const std::vector<std::string>& names) {
  std::string expr_copy = expr;
  std::unordered_map<std::string, std::string> new_names;
  std::vector<std::string> names_sorted_by_size = names;
  uint64_t idx = 0;
  number_of_inputs_ = names.size();
  clauses_.clear();

  std::vector<std::string> old_op = {"not", "and", "xor", "or"};
  std::vector<std::string> new_op = {"~", "&", "^", "|"};

  for (idx = 0; idx < 4; ++idx) {
    expr_copy = boost::replace_all_copy(expr_copy, old_op[idx], new_op[idx]);
  }
  idx = 0;

  for (const std::string& name : names) {
    new_names[name] = "i" + std::to_string(idx++);
  }

  std::sort(names_sorted_by_size.begin(), names_sorted_by_size.end(),
            [](const std::string& lhs, const std::string& rhs) {
              return lhs.size() > rhs.size();
            });

  for (const std::string& name : names_sorted_by_size) {
    expr_copy = boost::replace_all_copy(expr_copy, name, new_names[name]);
  }

  std::string::iterator begin = expr_copy.begin();
  std::string::iterator end = expr_copy.end();

  if (!qi::phrase_parse(begin, end, *this, qi::space, idx)) {
    throw std::invalid_argument(
        "Error while parsing the Boolean expression: \"" + expr +
        "\". Invalid syntax!");
  }

  return clauses_;
}