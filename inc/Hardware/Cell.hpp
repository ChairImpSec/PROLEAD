#pragma once

#include <boost/json.hpp>
#include <memory>
#include <optional>  // for std::optional

#include "Hardware/Expression.hpp"
#include "Hardware/TruthTable.hpp"
#include "Util/FileParsing.hpp"
#include "Util/Types.hpp"

namespace js = boost::json;

class IterateEnablers {
  /**
   * For easier iteration over the entire truthtable.
   * Increases glitch indexes first, then modified, then normal inputs.
   * Results in truthtable rows g_a g_b..., a' b' ... a b ...
   * Only the underlying numbers storing each type of input(norm/mod/glitch) are
   * increased. Vectors are calculated using the number
   * @author Simon Osterheider
   */
 public:
  /**
   * @brief Construct a new Iterator
   * @param amount_of_inputs Specifies the amount of inputs.
   * For each input there will be a normal, mod, and glitch(if with_glitches is
   * set) input in the resulting truth table
   * @param with_glitches if true glitch index is also iterated, otherwise just
   * normal and modified inputs
   * @author Simon Osterheider
   */
  IterateEnablers(uint64_t amount_of_inputs, bool with_glitches);
  /**
   * @brief Iterates through all possible values. Increases glitch_index first
   * (if with_glitches), the modified, then normal
   *
   * @return true Iterated through all possible values
   * @return false Hasn't gone through all possible values
   * @author Simon Osterheider
   */
  bool Iterate();
  /**
   * @brief Returns normal inputs as bool vector
   */
  std::vector<bool> GetNormVectorBool() const;
  /**
   * @brief Returns normal inputs as uint64_t vector
   */
  std::vector<uint64_t> GetNormVectorNumb() const;
  /**
   * @brief Returns modified inputs as bool vector
   */
  std::vector<bool> GetModVectorBool() const;
  /**
   * @brief Returns modified inputs as uint64_t vector
   */
  std::vector<uint64_t> GetModVectorNumb() const;
  /**
   * @brief Returns glitch inputs as bool vector
   */
  std::vector<bool> GetGlitchVectorBool() const;
  /**
   * @brief Returns the glitch number which stores the glitch inputs, each bit
   * of it is one input
   */
  uint64_t GetGlitchNumber() const;
  /**
   * @brief Returns normal, modified inputs concatinated
   */
  std::vector<bool> GetIndexVectorSmall() const;
  /**
   * @brief Returns normal, modified, glitch inputs concatinated
   */
  std::vector<bool> GetIndexVector() const;

 private:
  /**
   * @brief Updates all bool and uint64_t vectors with the values of
   * corresponding the numbers
   */
  void UpdateVectors();
  /**
   * @brief stores weather iteration over glitch inputs required
   */
  bool with_glitches_;
  /**
   * number storing normal inputs
   */
  uint64_t norm_number_;
  /**
   * number storing modified inputs
   */
  uint64_t mod_number_;
  /**
   * number storing glitch inputs
   */
  uint64_t glitch_number_;
  /**
   * @brief stores the amount of rows in the truthtable
   *
   */
  uint64_t amount_rows_;
  uint64_t amount_inputs_;
  std::vector<bool> norm_vector_bool_, mod_vector_bool_, glitch_vector_bool_,
      index_vector_small_, index_vector_;
  std::vector<uint64_t> norm_vector_num_, mod_vector_num_;
};

enum class cell_t {
  undef,
  buffer,
  combinational,
  latch,
  relaxed,
  sequential,
  lut
};

/*
 * This class specifies a single cell.
 */
class Cell {
 public:
  /**
   * @brief Construct a new Cell object from the information inside the
   * json::value
   * @author Simon Osterheider
   */
  Cell(const js::value& value);

  void ChangeType(cell_t type) { type_ = type; };

  bool IsRegister() const { return type_ == cell_t::sequential; }

  bool IsLatch() const { return type_ == cell_t::latch; }

  uint64_t GetInputPortWidth(uint64_t idx) const {
    return input_port_widths_[idx];
  }

  cell_t GetType() const;
  clk_edge_t GetClkEdge() const;
  std::optional<uint64_t> GetClock() const;

  const std::vector<std::string> GetIdentifiers() const;

  const std::vector<std::pair<std::string, std::vector<vlog_bit_t>>>&
  GetParams() const {
    return params_;
  }

  uint64_t GetNumberOfIdentifiers() const;
  uint64_t GetNumberOfInputs() const;
  uint64_t GetNumberOfOutputs() const;
  uint64_t GetNumberOfMids() const;
  std::string GetIdentifier(uint64_t index) const;
  std::string GetInput(uint64_t index) const;
  std::string GetOutput(uint64_t index) const;
  std::string GetMid(uint64_t index) const;

  const std::vector<std::string>& GetExpr() const { return expr_; }

  const std::vector<std::string>& GetExprMids() const { return expr_mids_; }

 private:
  std::optional<uint64_t> clk_;
  cell_t type_;
  clk_edge_t clk_edge_;
  std::vector<std::pair<std::string, std::vector<vlog_bit_t>>> params_;
  std::vector<std::string> ids_;
  std::vector<std::string> inputs_;
  std::vector<uint64_t> input_port_widths_;
  std::vector<std::string> outputs_;
  std::vector<std::string> mids_;
  std::vector<std::string> expr_;
  std::vector<std::string> expr_mids_;
};
