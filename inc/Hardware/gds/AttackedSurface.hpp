#pragma once

#include "GDSProbe.hpp"
#include "Gate.hpp"
#include <vector>

class AttackedSurface {


// TODO: use either pointer or references, do not mix it up
using Gates = std::vector<Gate>;

public:

  GDSProbe probe_;
  const Gates & gates_of_design_;
  std::vector<Gate const *> attacked_gates_;

  AttackedSurface(GDSProbe & probe, const Gates & gates_of_design);
  // AttackedSurface();


  void ComputeAttackedGatesAtProbePosition();

  // Overload the < operator
  bool operator<(const AttackedSurface & other) const;
  bool operator<(AttackedSurface & other) const;

  friend std::ostream& operator<<(std::ostream &out, AttackedSurface const& attacked_surface);
  // TODO: add const reference or const ptr to the set of all gates that is filtered for one
  // attacked surface
};
