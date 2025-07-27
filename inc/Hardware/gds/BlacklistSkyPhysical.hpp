#pragma once
#include "Blacklist.hpp"

struct BlacklistSkyPhysical : public Blacklist {
  BlacklistSkyPhysical() : Blacklist({
    "sky130_fd_sc_hd__decap_3",
    "sky130_fd_sc_hd__decap_4",
    "sky130_fd_sc_hd__decap_6",
    "sky130_fd_sc_hd__decap_8",
    "sky130_ef_sc_hd__decap_12",
    "sky130_fd_sc_hd__fill_1",
    "sky130_fd_sc_hd__fill_2",
    "sky130_fd_sc_hd__fill_4",
    "sky130_fd_sc_hd__fill_8",
    "sky130_fd_sc_hd__tapvpwrvgnd_1",
    "sky130_fd_sc_hd__dlymetal6s2s_1",
    "sky130_fd_sc_hd__dlygate4sd3_1",
    "sky130_fd_sc_hd__diode_2"
  }) {}
};
