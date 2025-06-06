#include "Hardware/Library.hpp"

Library::Library(const boost::json::object& library_file, std::string name) {
  js::array libs = library_file.at("libraries").as_array();

  js::array::iterator it =
      std::find_if(libs.begin(), libs.end(), [&](const js::value& lib) {
        return js::value_to<std::string>(lib.at("name")) == name;
      });

  if (it != libs.end()) {
    std::cout << "Successfully read the library with name \"" << name << "\"."
              << std::endl;
  } else {
    throw std::runtime_error("Error while reading the library with name \"" +
                             name + "\". Library not found!");
  }

  js::array cells = it->at("cells").as_array();

  for (const js::value& cell : cells) {
    cells_.emplace_back(cell);
  }

  std::cout << "Successfully parsed " << cells_.size()
            << " cells from the library." << std::endl;

  buffer_ = std::nullopt;

  for (Cell& cell : cells_) {
    if (cell.GetType() == cell_t::buffer) {
      std::string id = cell.GetIdentifier(0);
      std::cout << "Successfully found buffer cell with identifier \"" + id +
                       "\" and others."
                << std::endl;
      buffer_ = &cell;
    }
  }
}

std::optional<const Cell*> Library::GetCellById(
    const std::string& id) const {
  for (const Cell& cell : cells_) {
    for (const std::string& identifier : cell.GetIdentifiers()) {
      if (identifier == id) {
        return &cell;
      }
    }
  }

  return std::nullopt;
}

std::optional<const Cell*> Library::GetBuffer() const { return buffer_; }