#pragma once

#include "Software/mulator/types.h"
#include "Software/mulator/shift_types.h"

#include <tuple>

namespace mulator::arm_functions
{
    // armv6m
    std::tuple<bool, u32, u8> shift_c(u32 value, ShiftType type, u8 amount, u8 carry_in);
    std::tuple<bool, u32> shift(u32 value, ShiftType type, u8 amount, u8 carry_in);

    std::tuple<bool, u32, u8> LSL_C(u32 x, u32 shift);
    std::tuple<bool, u32> LSL(u32 x, u32 shift);

    std::tuple<bool, u32, u8> LSR_C(u32 x, u32 shift);
    std::tuple<bool, u32> LSR(u32 x, u32 shift);

    std::tuple<bool, u32, u8> ASR_C(u32 x, u32 shift);
    std::tuple<bool, u32> ASR(u32 x, u32 shift);

    std::tuple<bool, u32, u8> ROR_C(u32 x, u32 shift);
    std::tuple<bool, u32> ROR(u32 x, u32 shift);

    std::tuple<bool, u32, u8> RRX_C(u32 x, u8 carry_in);
    std::tuple<bool, u32> RRX(u32 x, u8 carry_in);

    std::tuple<u32, u8, u8> add_with_carry(u32 x, u32 y, u8 carry_in);

    u32 align(u32 address, u32 alignment);

    std::tuple<ShiftType, u32> decode_imm_shift(u8 type, u32 imm5);
    ShiftType decode_reg_shift(u8 type);

    u32 sign_extend(u32 value, u32 num_bits);
    u32 bit_count(u32 value);
    u32 lowest_set_bit(u32 value);

    // armv7m
    //std::tuple<u32, bool> signed_sat_Q(i32 i, u32 n);
    std::tuple<u32, bool> signed_sat_Q(i64 i, u32 n);

    std::tuple<u32, bool> unsigned_sat_Q(i32 i, u32 n);

    u32 signed_sat(i32 i, u32 n);

    u32 unsigned_sat(i32 i, u32 n);

    std::tuple<u32, bool> sat_Q(i32 i, u32 n, bool unsigned_sat);

    u32 sat(i32 i, u32 n, bool unsigned_sat);

    std::tuple<bool, u32, u8> thumb_expand_imm_C(u32 imm, u8 carry_in);
    std::tuple<bool, u32> thumb_expand_imm(u32 imm);
}
