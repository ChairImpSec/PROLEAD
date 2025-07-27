#pragma once
#include "Blacklist.hpp"

struct BlacklistSkyBuffer : public Blacklist {
  BlacklistSkyBuffer() : Blacklist({
    "sky130_fd_sc_hd__buf_1",
    "sky130_fd_sc_hd__buf_2",
    "sky130_fd_sc_hd__buf_4",
    "sky130_fd_sc_hd__buf_6",
    "sky130_fd_sc_hd__buf_8",
    "sky130_fd_sc_hd__buf_12",
    "sky130_fd_sc_hd__bufinv_16",
    "sky130_fd_sc_hd__clkbuf_1",
    "sky130_fd_sc_hd__clkbuf_2",
    "sky130_fd_sc_hd__clkbuf_4",
    "sky130_fd_sc_hd__clkbuf_8",
    "sky130_fd_sc_hd__clkbuf_16"
  }) {}
};
