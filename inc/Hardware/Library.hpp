/**
 * @file Library.hpp
 * @brief Declares the library class.
 *
 * @version 0.0.1
 * @date 2025-02-21
 *
 * @author Nicolai Müller
 * @author Simon Osterheider
 */
#pragma once

#include "Hardware/Cell.hpp"

class Library {
 public:
  /**
   * @brief Constructs a Library class object.
   * @param path The path to the library file. The library file is expected to
   * be in the JSON format.
   * @param name The name of the library.
   * @param is_relaxed If true, the RR d-probing model is used, otherwise the
   * robust d-probing model.
   * @return A Library object.
   * @throws std::runtime_error If the library file cannot be opened or the
   * library with the given name is not found.
   */
  Library(std::string path, std::string name, bool is_relaxed);

  /**
   * @brief Returns the cell with the given identifier.
   * @param id The identifier of the cell.
   * @return The cell with the given identifier or std::nullopt if the cell is
   * not defined.
   * @note The identifier should be unique for each cell in the library.
   */
  std::optional<const Cell*> GetCellByIdentifier(const std::string& id) const;

  /**
   * @brief Returns the buffer cell.
   * @return The buffer cell or std::nullopt if the buffer cell is not defined.
   */
  std::optional<const Cell*> GetBuffer() const;

 private:
  std::vector<Cell> cells_;  ///< The cells in the library.
  std::optional<const Cell*>
      buffer_;  ///< The index of the buffer cell in the library.

  /**
   * @brief Parses the cells from the library file.
   * @param it The iterator pointing to the library in the JSON file.
   * @param is_relaxed If true, the RR d-probing model is used, otherwise the
   * robust d-probing model.
   */
  void ParseCells(boost::json::array::iterator it, bool is_relaxed);
};