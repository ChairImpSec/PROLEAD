#pragma once

#include <boost/json.hpp>
#include <memory>

#include "Hardware/Operation.hpp"
#include "Hardware/TruthTable.hpp"
#include "Hardware/LibHelper.hpp"
#include "Util/FileParsing.hpp"
#include "Util/Types.hpp"

namespace Hardware {

class IterateEnablers {
  /**
   * For easier iteration over the entire truthtable.
   * Increases glitch indexes first, then modified, then normal inputs.
   * Results in truthtable rows g_a g_b..., a' b' ... a b ...
   * Only the underlying numbers storing each type of input(norm/mod/glitch) are increased. 
   * Vectors are calculated using the number
   * @author Simon Osterheider
   */
  public:
  /**
   * @brief Construct a new Iterator
   * @param amount_of_inputs Specifies the amount of inputs.
   * For each input there will be a normal, mod, and glitch(if with_glitches is set) input in the resulting truth table
   * @param with_glitches if true glitch index is also iterated, otherwise just normal and modified inputs
   * @author Simon Osterheider
   */
  IterateEnablers(size_t amount_of_inputs, bool with_glitches);
  /**
   * @brief Iterates through all possible values. Increases glitch_index first (if with_glitches), the modified, then normal
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
   * @brief Returns the glitch number which stores the glitch inputs, each bit of it is one input
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
   * @brief Updates all bool and uint64_t vectors with the values of corresponding the numbers
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
  std::vector<bool> norm_vector_bool_, mod_vector_bool_, glitch_vector_bool_, index_vector_small_, index_vector_;
  std::vector<uint64_t> norm_vector_num_, mod_vector_num_;
};




enum class cell_t {undef, combinational, latch, relaxed, sequential};

/*
 * This class specifies a single cell.
 */
class Cell {
 public:
  /**
   * @brief Construct a new Cell object from the information inside the json::value
   * @author Simon Osterheider
   */
  Cell(const boost::json::value& value, bool is_relaxed);

  Cell( cell_t type, std::vector<std::string> identifiers,
       std::vector<std::vector<std::string>> inputs, std::vector<std::vector<std::string>> outputs,
       std::vector<std::string> expressions);

  bool operator==(const Cell& other) const;

  /**
   * @brief Returns the output value for each output of the cell
   * @param operands in order a' a g_a b' b g_b ...
   */
  uint64_t Evaluate(uint64_t output_index, std::vector<uint64_t>& input_values) const;
  /**
   * @brief Returns the output of all propagation functions
   * @param operands in order a' a g_a b' b g_b ...
   */
  uint64_t EvaluatePropagation(uint64_t function_index, std::vector<uint64_t>& input_values) const; 
  /**
   * @brief Returns the output of all glitch functions
   * @param operands in order a' a g_a b' b g_b ...
   */
  uint64_t EvaluateGlitch(uint64_t function_index, std::vector<uint64_t>& input_values) const; 

  cell_t GetCellType() const;
  clk_edge_t GetClkEdge() const;
  int64_t GetClock() const;

  const std::vector<std::string> GetIdentifiers() const;

  uint64_t GetNumberOfProbeExtensions() const {
    return probe_extension_.size();
  }

  bool HasPredefinedFunctions() const {
    return predefined_functions_found_;
  }

  uint64_t GetNumberOfIdentifiers() const;
  uint64_t GetNumberOfInputs() const;
  uint64_t GetNumberOfOutputs() const;
  std::string GetIdentifier(uint64_t index) const;
  std::string GetInput(uint64_t index) const;
  std::string GetOutput(uint64_t index) const;

 private:
  int64_t clk_;
  cell_t type_;
  clk_edge_t clk_edge_;
  std::vector<std::string> identifiers_;
  std::vector<std::vector<std::string>> inputs_;
  std::vector<std::vector<std::string>> outputs_;
  std::vector<Operation<CustomOperation>> operations_;
  std::vector<Operation<CustomOperation>> probe_extension_;
  std::vector<Operation<CustomOperation>> glitch_propagation_;
  bool predefined_functions_found_;

  void SetType(const boost::json::value& value, bool is_relaxed);
  void SetClock(const boost::json::value& value);
  void SetClkEdge(const boost::json::value& value);
  void SetOperations(const std::vector<std::string>& expressions);

  /**
   * @brief Generates propagation functions and glitch functions for a operation
   * @param op Operation the function are generated for
   * @author Simon Osterheider
   */
  void GenerateRelaxedFunctions(Operation<CustomOperation>& operation);
  /**
   * @brief generates truth table with no glitchy inputs
   * @return TruthTable for F (toggle) output and G (glitch)
   * @author Simon Osterheider
   */
  TruthTable GenerateSmallEnablers(Operation<CustomOperation>& op);
  /**
   * @brief Detects if for the given normal and modifed inputs
   * a glitch can occur in the gate represented by the operation.
   * @param op Operation representing the gate
   * @param norm_input normal input
   * @param mod_input modified input
   * @param transition_allowed If the transition from the normal input to the modified input results in a toggle in the output, one transition is allowed
   * and a glitch is detected when at least two toggles happen, otherwise one toggle when switching values is enough to detect a glitch
   * @return true A glitch can occur at the gate for the given input transitions
   * @return false A glitch can't occur at the gate for the given input transitions
   * @author Simon Osterheider
   */
  static bool DetectGlitches(Operation<CustomOperation>& op, std::vector<uint64_t> const& norm_input, std::vector<uint64_t> const& mod_input, bool transition_allowed);
  /**
   * @brief Set the Propagation Function for the operation represented by the truthtable
   * Internally checks if the operation of the toggle output (f) from the table is the same for every input,
   * as for one function in the propagation_expression_library
   * @param table table representing the propagation and glitch function of the currently processed operation
   * @author Simon Osterheider
   */
  void SetPropagationFunction(TruthTable const& table);
  /**
   * @brief Set the Glitch Function for the operation represented by the truthtable
   * Internally checks if the operation of the glitch output (g) from the table is the same for every input,
   * as for one function in the glitch_expression_library
   * @param table table representing the propagation and glitch function of the currently processed operation
   * @author Simon Osterheider
   */
  void SetGlitchFunction(TruthTable const& table);

  //void SetFunction(TruthTable const& table, bool for_glitch);
  
  /**
   * @brief 
   * @param table big table that will be filled at concat(norm, mod, glitch)
   * @param small_table small table that assumes non glitchy inputs, already filled
   * @param norm_vector vector inputs at the beginning
   * @param mod_vector vector inputs at the end, after transiton
   * @param glitch_vector vector that says if an input glitches or not
   * @param gltch_flipped_inputs 
   * @author Simon Osterheider
   */
  void LookupGlitchesSmallTable(TruthTable& table, TruthTable& small_table, IterateEnablers& it); 
};

class Library {
 public:
  /**
   * @brief Constructs a new Library object.
   * @param path The path to the library file. The library file is expected to be in the JSON format.
   * @param name The name of the library.
   * @param is_relaxed If true, the RR d-probing model is used, otherwise the robust d-probing model.
   * @return A new Library object.
   */
  Library(std::string path, std::string name, bool is_relaxed);

  /**
   * @brief Returns the number of defined cells in the library.
   * @return The number of cells in the library.
   */
  uint64_t GetNumberOfCells() const;

  /**
   * @brief Checks is a cell is a sequential gate.
   * @param index The index of the cell.
   * @return True if the cell is a sequential gate, otherwise false.
   */
  bool IsCellRegister(uint64_t index) const;

  /**
   * @brief Checks is a cell is a latch.
   * @param index The index of the cell.
   * @return True if the cell is a latch, otherwise false.
   */
  bool IsCellLatch(uint64_t index) const;


  /** 
  * @brief Returns a particular cell of the library.
  * @param index The index of the cell.
  * @return The cell.
  */
  Cell GetCell(uint64_t index) const;

  /**
   * @brief Returns the index of the buffer cell in the library.
   * @return The index of the buffer cell or -1 if the buffer cell is not defined.
   */
  int64_t GetBufferIndex() const;

  /**
   * @brief Returns the number of different identifiers of a particular cell.
   * @param index The index of the cell.
   * @return The number of identifiers of the cell.
   */
  uint64_t GetNumberOfIdentifiers(uint64_t index) const;

  /**
   * @brief Returns the number of inputs of a particular cell.
   * @param index The index of the cell.
   * @return The number of inputs of the cell.
   */
  uint64_t GetNumberOfInputs(uint64_t index) const;

  /**
   * @brief Returns the number of outputs of a particular cell.
   * @param index The index of the cell.
   * @return The number of outputs of the cell.
   */
  uint64_t GetNumberOfOutputs(uint64_t index) const;

  /**
   * @brief Returns a particular identifier of a particular cell.
   * @param index The index of the cell.
   * @param identifier_index The index of the identifier.
   * @return The identifier of the cell.
   */
  std::string GetIdentifier(uint64_t index, uint64_t identifier_index) const;

  /**
   * @brief Returns a particular input signal name of a particular cell.
   * @param index The index of the cell.
   * @param input_index The index of the input signal.
   * @return The name of the input signal.
   */
  std::string GetInput(uint64_t index, uint64_t input_index) const;

  /**
   * @brief Returns a particular output signal name of a particular cell.
   * @param index The index of the cell.
   * @param output_index The index of the output signal.
   * @return The name of the output signal.
   */
  std::string GetOutput(uint64_t index, uint64_t output_index) const;

  /**
   * @brief Evaluates a particular output function of a particular cell based on the given input values.
   * @details The input values are provided in a bitsliced fashion. Every input values represents a single bit of 64 different inputs.
   * @param cell_index The index of the cell.
   * @param output_index The index of the output function.
   * @param input_values The (bitsliced) input values for the cell.
   * @return The (bitsliced) output value of the output function.
   */
  uint64_t Evaluate(uint64_t cell_index, uint64_t output_index, std::vector<uint64_t>& input_values) const;

  /**
   * @brief Returns timing type of a particular cell.
   * @param index The index of the cell.
   * @return The timing type the cell.
   */
  clk_edge_t GetClkEdge(uint64_t index) const;

  /**
   * @brief Returns a particular clock port index of a particular cell.
   * @param index The index of the cell.
   * @return The port index of the input clock.
   */
  int64_t GetClock(uint64_t index) const;

 private:
  std::vector<Cell> cells_; ///< The cells in the library.
  int64_t buffer_index_; ///< The index of the buffer cell in the library.

  void ParseCells(boost::json::array::iterator it, bool is_relaxed);
}; 

std::vector<std::string> ConvertJsonArrayToVector(const boost::json::array& json_array);

}  // namespace Hardware
