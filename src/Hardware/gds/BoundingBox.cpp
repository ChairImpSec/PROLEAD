#include "Hardware/gds/BoundingBox.hpp"

/**
 * @brief Constructor for BoundingBox.
 */
BoundingBox::BoundingBox(Coordinate min, Coordinate max) : min(min), max(max) {}
BoundingBox::BoundingBox(){}


Coordinate BoundingBox::get_size(){
  return this->max - this->min;
}

/**
 * @brief Operator << for BoundingBox.
 */
std::ostream& operator<<(std::ostream &out, BoundingBox const& bbox) {
    out << "(" << bbox.min << ", " << bbox.max << ")";
    return out;
}

