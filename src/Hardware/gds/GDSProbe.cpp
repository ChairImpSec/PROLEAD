#include "Hardware/gds/GDSProbe.hpp"

// We need this to store the probe in attacked surface
GDSProbe::GDSProbe(GDSRectangle &outer_border,
                     std::vector<GDSRectangle> &inner_non_effected_area,
                     Coordinate &step_size,
                     size_t number_of_probe_positions_x,
                     size_t number_of_probe_positions_y) :
  outer_border_(outer_border),
  inner_non_effected_area_(inner_non_effected_area),
  step_size_(step_size),
  number_of_probe_positions_x_(number_of_probe_positions_x),
  number_of_probe_positions_y_(number_of_probe_positions_y)
{}

// We need this for init probe
GDSProbe::GDSProbe(GDSRectangle outer_border,
                     std::vector<GDSRectangle> inner_non_effected_area,
                     Coordinate step_size,
                     size_t number_of_probe_positions_x,
                     size_t number_of_probe_positions_y) :
  outer_border_(outer_border),
  inner_non_effected_area_(inner_non_effected_area),
  step_size_(step_size),
  number_of_probe_positions_x_(number_of_probe_positions_x),
  number_of_probe_positions_y_(number_of_probe_positions_y)
{}

GDSProbe::GDSProbe() :
  outer_border_(Coordinate(0,0), Coordinate(0,0), Coordinate(0,0)),
  inner_non_effected_area_(std::vector<GDSRectangle>()),
  step_size_(Coordinate(0,0)),
  number_of_probe_positions_x_(0),
  number_of_probe_positions_y_(0)
{}


void GDSProbe::StepX(){
  MoveXBy(this->step_size_.x);
}

void GDSProbe::StepY(){
  MoveYBy(this->step_size_.y);
}

void GDSProbe::MoveXBy(const double delta_center_x) {
  this->outer_border_.MoveXBy(delta_center_x);
  for(auto& inner_area : this->inner_non_effected_area_){
    inner_area.MoveXBy(delta_center_x);
  }
}

void GDSProbe::MoveYBy(const double delta_center_y) {
  this->outer_border_.MoveYBy(delta_center_y);
  for(auto& inner_area : this->inner_non_effected_area_){
    inner_area.MoveYBy(delta_center_y);
  }
}

void GDSProbe::MoveBy(const Coordinate &delta_center) {
  this->outer_border_.MoveBy(delta_center);
  for(auto& inner_area : this->inner_non_effected_area_){
    inner_area.MoveBy(delta_center);
  }
}

void GDSProbe::MoveTo(const Coordinate &center) {
  this->outer_border_.MoveTo(center);
  for (auto& inner_area : this->inner_non_effected_area_) {
    inner_area.MoveTo(center);
  }
}

void GDSProbe::ResetX(){
  this->outer_border_.ResetX();
  for (auto& inner_area : this->inner_non_effected_area_){
    inner_area.ResetX();
  }
}

void GDSProbe::ResetY(){
  this->outer_border_.ResetY();
  for (auto& inner_area : this->inner_non_effected_area_){
    inner_area.ResetY();
  }
}

bool GDSProbe::IsGateHit(const Gate & gate){

  if(this->outer_border_.HasOverlap(gate)){
    // std::cout << "Overlap: " << gate << std::endl;

    for (const auto & area : inner_non_effected_area_) {
      if(area.FullyCoversGate(gate)){
        // std::cout << "But fully covered by center" <<std::endl;
        return false;
      }
    }
    return true;
  } else{
    return false;
  }
}

std::ostream& operator<<(std::ostream &out, GDSProbe const& probe) {
  out << "include: {" << probe.outer_border_ << "}";
  out <<  " exclude: {";
  for(const auto & area : probe.inner_non_effected_area_){
    out << area << ",";
  }
  out << "}";
  return out;
}

