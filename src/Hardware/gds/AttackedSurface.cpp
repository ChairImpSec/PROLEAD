#include "Hardware/gds/AttackedSurface.hpp"


AttackedSurface::AttackedSurface(GDSProbe &probe, const Gates & gates_of_design) :
  probe_(probe),
  gates_of_design_(gates_of_design)
{
  AttackedSurface::ComputeAttackedGatesAtProbePosition();
}


void AttackedSurface::ComputeAttackedGatesAtProbePosition(){

  for (const auto & gate : this->gates_of_design_) {
    if(this->probe_.IsGateHit(gate)){
      this->attacked_gates_.push_back(&gate);
    }
  }
}


// AttackedSurface::AttackedSurface() : probe_(GDSProbe()) {}

bool AttackedSurface::operator<(const AttackedSurface & other) const {
  // Forward the comparison to the vector's operator<
  return attacked_gates_ < other.attacked_gates_;
}

bool AttackedSurface::operator<(AttackedSurface & other) const {
  // Forward the comparison to the vector's operator<
  return attacked_gates_ < other.attacked_gates_;
}

std::ostream& operator<<(std::ostream &out, AttackedSurface const& attacked_surface) {
  out << attacked_surface.probe_;
  out << "}: {\n";
  for (const auto & effected_gate : attacked_surface.attacked_gates_) {
    out << "\t" << *effected_gate << "\n";
  }
  std::cout << "}" << std::endl;

  return out;
}
