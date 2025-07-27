
#pragma once

#include "Coordinate.hpp"
#include "Gate.hpp"

/**
 * @brief The GDSRectangle class represents a rectangle for GDS probing with a center and radius.
 */
class GDSRectangle {
public:
  // GDSRectangle(double center_x, double center_y, double radius_x, double radius_y);
  GDSRectangle(Coordinate center, Coordinate radius, Coordinate offset);

  bool HasOverlap(const Gate &gate) const;
  bool FullyCoversGate(const Gate &gate) const;

  void MoveXBy(const double delta_center_x);
  void MoveYBy(const double delta_center_y);
  void MoveBy(const Coordinate &delta_center);
  void MoveTo(const Coordinate &center);
  void ResetX();
  void ResetY();

  friend std::ostream& operator<<(std::ostream &out, GDSRectangle const& emfi_probe);

private:
  Coordinate init_position_;
  Coordinate center_;
  Coordinate radius_;
  Coordinate offset_;
  BoundingBox square_;
};
