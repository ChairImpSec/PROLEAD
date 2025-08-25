#include "Hardware/gds/BoundingBox.hpp"

/**
 * @brief Constructor for BoundingBox.
 */
BoundingBox::BoundingBox(Coordinate min, Coordinate max) : min_(min), max_(max) {}
BoundingBox::BoundingBox(){}


Coordinate BoundingBox::get_size(){
  return this->max_ - this->min_;
}

/**
 * @brief Operator << for BoundingBox.
 */
std::ostream& operator<<(std::ostream &out, BoundingBox const& bbox) {
    out << "(" << bbox.min_ << ", " << bbox.max_ << ")";
    return out;
}

