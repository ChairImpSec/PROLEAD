#pragma once
#include "Blacklist.hpp"

struct BlacklistSkyClkBuffer : public Blacklist {
  BlacklistSkyClkBuffer() : Blacklist({
    "sky130_fd_sc_hd__clkinv_2",
    "sky130_fd_sc_hd__clkinv_4",
    "sky130_fd_sc_hd__clkinvlp_4"
  }) {}
};
