#pragma once
#include "Blacklist.hpp"

struct BlacklistSkySequential : public Blacklist {
  BlacklistSkySequential() : Blacklist({
    "sky130_fd_sc_hd__dfxtp_1",
    "sky130_fd_sc_hd__dfxtp_2",
    "sky130_fd_sc_hd__dfxtp_4",
  }) {}
};
