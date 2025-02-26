#include "Hardware/Library.hpp"

Library::Library(std::string path, std::string name, bool is_relaxed) {
  std::ifstream file(path);
  if (file.fail()) {
    throw std::runtime_error("Error while opening the library file at \"" +
                             path + "\". File not found!");
  } else {
    std::cout << "Successfully opened the library file at \"" << path << "\"."
              << std::endl;
  }

  std::string data{std::istreambuf_iterator<char>(file),
                   std::istreambuf_iterator<char>()};
  boost::json::parse_options opt;
  opt.allow_comments = true;
  boost::json::monotonic_resource mr;
  boost::json::storage_ptr sp(&mr);
  boost::json::value json_data = boost::json::parse(data, sp, opt);
  boost::json::array cells, rams;
  boost::json::array libraries = json_data.at("libraries").as_array();

  boost::json::array::iterator it = std::find_if(
      libraries.begin(), libraries.end(),
      [&](const boost::json::value& library) {
        return boost::json::value_to<std::string>(library.at("name")) == name;
      });

  if (it != libraries.end()) {
    std::cout << "Successfully read the library with name \"" << name << "\"."
              << std::endl;
  } else {
    throw std::runtime_error("Error while reading the library with name \"" +
                             name + "\". Library not found!");
  }

  ParseCells(it, is_relaxed);
  std::cout << "Successfully parsed " << cells_.size()
            << " cells from the library." << std::endl;
}

std::optional<const Cell*> Library::GetCellByIdentifier(
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

void Library::ParseCells(boost::json::array::iterator it, bool is_relaxed) {
  boost::json::array cells = it->at("cells").as_array();

  for (const boost::json::value& cell : cells) {
    cells_.emplace_back(cell, is_relaxed);
  }

  buffer_ = std::nullopt;

  for (Cell& cell : cells_) {
    if (cell.GetType() == cell_t::buffer) {
      cell.ChangeType(cell_t::combinational);
      std::string name = cell.GetIdentifier(0);
      std::cout << "Successfully found buffer cell with identifier \"" + name +
                       "\" and others."
                << std::endl;
      buffer_ = &cell;
    }
  }
}