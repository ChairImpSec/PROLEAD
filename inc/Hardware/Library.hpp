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
#include <boost/log/trivial.hpp>

class Library {
 public:
  /**
   * @brief Constructs a Library class object.
   * @param path The path to the library file. The library file is expected to
   * be in the JSON format.
   * @param name The name of the library.
   * @return A Library object.
   * @throws std::runtime_error If the library file cannot be opened or the
   * library with the given name is not found.
   */
  Library(const boost::json::object& library_file, std::string name);

  /**
   * @brief Returns the cell with the given identifier.
   * @param id The identifier of the cell.
   * @return The cell with the given identifier or std::nullopt if the cell is
   * not defined.
   * @note The identifier should be unique for each cell in the library.
   */
  std::optional<const Cell*> GetCellById(const std::string& id) const;

  /**
   * @brief Returns the buffer cell.
   * @return The buffer cell or std::nullopt if the buffer cell is not defined.
   */
  std::optional<const Cell*> GetBuffer() const;

 private:
  std::vector<Cell> cells_;  ///< The cells in the library.
  std::optional<const Cell*>
      buffer_;  ///< The index of the buffer cell in the library.
};
