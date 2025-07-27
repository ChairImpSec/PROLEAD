#include "Hardware/gds/GDSRectangle.hpp"

GDSRectangle::GDSRectangle(Coordinate center, Coordinate radius, Coordinate offset) :
  init_position_(center),
  center_(init_position_),
  radius_(radius),
  offset_(offset),
  square_((center_- radius_ + offset_), (center_+ radius_ + offset_)){}


bool GDSRectangle::HasOverlap(const Gate &gate) const {
    bool gate_is_left_of_emfi_rect = gate.bbox.max.x < this->square_.min.x;
    bool gate_is_above_of_emfi_rect = gate.bbox.max.y < this->square_.min.y;
    bool gate_is_right_of_emfi_rect = this->square_.max.x < gate.bbox.min.x;
    bool gate_is_below_of_emfi_rect = this->square_.max.y < gate.bbox.min.y;

    bool no_overlap = gate_is_left_of_emfi_rect || gate_is_right_of_emfi_rect ||
                      gate_is_above_of_emfi_rect || gate_is_below_of_emfi_rect;

    return !no_overlap;
}

bool GDSRectangle::FullyCoversGate(const Gate &gate) const {
  bool left  = this->square_.min.x < gate.bbox.min.x;
  bool right = gate.bbox.max.x < this->square_.max.x;
  bool bottom = this->square_.min.y < gate.bbox.min.y;
  bool top = gate.bbox.max.y < this->square_.max.y;

  bool gate_is_fully_covered = left && right && bottom && top;

  return gate_is_fully_covered;
}


void GDSRectangle::MoveXBy(const double delta_center_x) {
    this->center_ += Coordinate(delta_center_x, 0);
    this->square_.min += Coordinate(delta_center_x, 0);
    this->square_.max += Coordinate(delta_center_x, 0);
}

void GDSRectangle::MoveYBy(const double delta_center_y) {
    this->center_ += Coordinate(0, delta_center_y);
    this->square_.min += Coordinate(0, delta_center_y);
    this->square_.max += Coordinate(0, delta_center_y);
}

void GDSRectangle::MoveBy(const Coordinate &delta_center) {
    this->center_ += delta_center;
    this->square_.min += delta_center;
    this->square_.max += delta_center;
}

void GDSRectangle::MoveTo(const Coordinate &center) {
    this->center_ = center + this->offset_;
    this->square_.min = center_- radius_ + this->offset_;
    this->square_.max = center_+ radius_ + this->offset_;
}

void GDSRectangle::ResetX(){
  GDSRectangle::MoveTo(
    (this->init_position_ + this->offset_)* Coordinate(1,0) +
    (this->center_ + this->offset_) * Coordinate(0,1)
  );
}

void GDSRectangle::ResetY(){
  GDSRectangle::MoveTo(
    (this->init_position_ + this->offset_) * Coordinate(0,1) +
    (this->center_ + this->offset_) * Coordinate(1,0));
}

std::ostream& operator<<(std::ostream &out, GDSRectangle const& emfi_probe) {
    out << "(" << emfi_probe.center_ << ", " << emfi_probe.square_ << ")";
    return out;
}
