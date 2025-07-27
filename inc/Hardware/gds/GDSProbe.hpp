#pragma once
#include "GDSRectangle.hpp"
#include <vector>

class GDSProbe{
  public:
  GDSRectangle outer_border_;
  std::vector<GDSRectangle> inner_non_effected_area_;
  // TODO: make following 3 const.
  Coordinate step_size_;
  size_t number_of_probe_positions_x_;
  size_t number_of_probe_positions_y_;

  GDSProbe (GDSRectangle &outer_border,
             std::vector<GDSRectangle> &inner_non_effected_area,
             Coordinate &step_size,
             size_t number_of_probe_positions_x,
             size_t number_of_probe_positions_y);

  GDSProbe (GDSRectangle outer_border,
             std::vector<GDSRectangle> inner_non_effected_area,
             Coordinate step_size,
             size_t number_of_probe_positions_x,
             size_t number_of_probe_positions_y);

  GDSProbe ();

  void StepX();
  void StepY();
  void MoveXBy(const double delta_center_x);
  void MoveYBy(const double delta_center_y);
  void MoveBy(const Coordinate &delta_center);
  void MoveTo(const Coordinate &center);
  void ResetX();
  void ResetY();
  bool IsGateHit(const Gate & gate);

  friend std::ostream& operator<<(std::ostream &out, GDSProbe const& probe);

};
