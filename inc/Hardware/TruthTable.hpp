#pragma once

#include "Hardware/Expression.hpp"

/**
   * Represents a truth table with a variable amount of input columns
   * and 2 output values F(Toggle), G(Glitch)
   * @author Simon Osterheider
  */
  class TruthTable {
  public:
  /**
   * @brief Construct a new Truth Table object
   * @param amount_of_inputs amount of inputs for the truth table
   * @author Simon Osterheider
   */
    TruthTable(uint64_t amount_of_inputs);
    TruthTable(const std::vector<bool>& init);

    /**
     * @brief Prints every row of the truth table. Counting upwards in binary but left bit is lsb
     * @author Simon Osterheider
    */
    void PrintTable() const;
    /**
     * @brief Sets the value of F to value in row specified by the index
     * @param index The values for the inputs
     * @param value Value that F gets set to
     * @author Simon Osterheider
    */
    void SetF(std::vector<bool> index, bool value);
    /**
     * @brief Sets the value of G to value in row specified by the index
     * @param index The values for the inputs
     * @param value Value that G gets set to
     * @author Simon Osterheider
    */
    void SetG(std::vector<bool> index, bool value);
    /**
     * @brief Gets value of F in row specified by the index
     * @param index The values for the inputs
     * @author Simon Osterheider
    */
    bool GetF(std::vector<bool> index) const;
    /**
     * @brief Gets value of G in row specified by the index
     * @param index The values for the inputs
     * @author Simon Osterheider
    */
    bool GetG(std::vector<bool> index) const;
    /**
     * @brief Returns the amount of inputs of the truth table, i.e. amount of input columns
     * @author Simon Osterheider
    */
    uint64_t GetAmountOfInputs() const;
    /**
     * @brief Constructs an Operation by first turning it into a cnf string
     * Before Turning into an Operation the order of inputs is mutated.
     * The table uses order: a b c ... a' b' c' ... g_a g_b g_c ..
     * While Operation uses a' a g_a b' b g_b ...
     * @param for_glitch if true will create function for G, else for F
     * @author Simon Osterheider
    */
    Expression OperationFromTruthTable(bool for_glitch) const;

  private:
    /**
     * @brief returns a mutable reference to the row specified by the index
     * @param index The values for the inputs
     * @author Simon Osterheider
    */
    std::vector<bool>& GetRowReference(std::vector<bool> index);
    /**
     * @brief returns a const reference to the row specified by the index
     * @param index The values for the inputs
     * @author Simon Osterheider
    */
    std::vector<bool> const& GetConstRowReference(std::vector<bool> index) const;
    /**
     * @brief constructs a string from an operation and a variable amount of inputs.
     * For example operands: A,B,C and op = and => A and B and C
     * @param op a binary operation that concatinates the operands
     * @param operands a list of operands
     * @author Simon Osterheider
    */
    static std::string ConstructExpression(std::string op, std::vector<std::string> operands);
    /**
     * @brief Mutates input order and returns it. Does not change parameter
     * From this order: a b c ... a' b' c' ... g_a g_b g_c ..
     * To this order: a' a g_a b' b g_b ...
     * @param inputs input, which order needs to be mutated
     * @return std::vector<std::string> mutated vector
     * @author Simon Osterheider
     */
    template <typename T>
    static std::vector<T> MutateVectorOrder(std::vector<T> const& inputs);
    std::vector<uint64_t> RemoveGlitchInputs(std::vector<uint64_t> inputs, std::vector<uint64_t> indexes_to_remove) const;
    void RemoveTransitionInputs(std::vector<uint64_t>& inputs) const;
    /**
     * The vector containing all rows of the truth table.
     * First row is index 0 0 0..., second 1 0 0.., third 0 1 0...
     * So binary with LSB on the left
    */
    std::vector<std::vector<bool>> table_;
    /**
     * amount of input columns for the truth table
    */
    uint64_t amount_of_inputs_;
  };
