#pragma once
#include "Coordinate.hpp"
#include <gdstk/cell.hpp>
#include <gdstk/library.hpp>

/**
 * @brief The BoundingBox class represents a bounding box with minimum and maximum coordinates.
 */
struct BoundingBox {
  Coordinate min;
  Coordinate max;

  BoundingBox(Coordinate min, Coordinate max);
  BoundingBox();
  // static BoundingBox extract_top_module_bounding_box(const gdstk::Library &lib, const std::string &top_level_name);

  static BoundingBox extract_top_module_bounding_box(const gdstk::Library &lib, const std::string &top_level_name) {
    gdstk::Cell *top_module = lib.get_cell(top_level_name.c_str());
    gdstk::Vec2 min;
    gdstk::Vec2 max;
    top_module->bounding_box(min, max);
    return BoundingBox(Coordinate(min.x, min.y), Coordinate(max.x, max.y));
  };

  Coordinate get_size();

  friend std::ostream& operator<<(std::ostream &out, BoundingBox const& bbox);
};
