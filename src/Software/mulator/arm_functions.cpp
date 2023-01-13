#include "Software/mulator/arm_functions.h"

namespace mulator::arm_functions
{
    std::tuple<bool, u32> shift(u32 value, ShiftType type, u8 amount, u8 carry_in)
    {
        auto [a, b, c] = shift_c(value, type, amount, carry_in);
        UNUSED(c);
        return {a, b};
    }

    std::tuple<bool, u32, u8> shift_c(u32 value, ShiftType type, u8 amount, u8 carry_in)
    {
        if (type == ShiftType::RRX && amount != 1)
        {
            return {false, 0, 0};
        }

        if (amount == 0)
        {
            return {true, value, carry_in};
        }

        switch (type)
        {
            case ShiftType::LSL: return LSL_C(value, amount);
            case ShiftType::LSR: return LSR_C(value, amount);
            case ShiftType::ASR: return ASR_C(value, amount);
            case ShiftType::ROR: return ROR_C(value, amount);
            case ShiftType::RRX: return RRX_C(value, carry_in);
        }

        return {false, 0, 0};
    }

    std::tuple<bool, u32, u8> LSL_C(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {false, 0, 0};
        }
        u32 result = 0;
        if (shift <= 32) result = x << (shift - 1);
        u8 carry = (result >> 31) & 1;
        if (shift <= 32) result <<= 1;
        return {true, result, carry};
    }
    std::tuple<bool, u32> LSL(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {true, x};
        }
        auto [a, b, c] = LSL_C(x, shift);
        UNUSED(c);
        return {a, b};
    }

    std::tuple<bool, u32, u8> LSR_C(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {false, 0, 0};
        }
        u32 result = 0;
        if (shift <= 32) result = x >> (shift - 1);
        u8 carry = result & 1;
        if (shift <= 32) result >>= 1;
        return {true, result, carry};
    }
    std::tuple<bool, u32> LSR(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {true, x};
        }
        auto [a, b, c] = LSR_C(x, shift);
        UNUSED(c);
        return {a, b};
    }

    std::tuple<bool, u32, u8> ASR_C(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {false, 0, 0};
        }
        u64 sign_extended = (u64)((i64)((i32)x));
        u64 result = 0xFFFFFFFF * (sign_extended >> 31) & 1;
        if (shift <= 32) result = sign_extended >> (shift - 1);
        u8 carry = result & 1;
        if (shift <= 32) result >>= 1;
        return {true, (u32)result, carry};
    }
    std::tuple<bool, u32> ASR(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {true, x};
        }
        auto [a, b, c] = ASR_C(x, shift);
        UNUSED(c);
        return {a, b};
    }

    std::tuple<bool, u32, u8> ROR_C(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {false, 0, 0};
        }
        u32 m = shift % 32;
        auto [b1, lsr] = LSR(x, m);
        auto [b2, lsl] = LSL(x, 32 - m);
        u32 result = lsr | lsl;
        return {b1 & b2, result, result >> 31};
    }
    std::tuple<bool, u32> ROR(u32 x, u32 shift)
    {
        if (shift == 0)
        {
            return {true, x};
        }
        auto [a, b, c] = ROR_C(x, shift);
        UNUSED(c);
        return {a, b};
    }

    std::tuple<bool, u32, u8> RRX_C(u32 x, u8 carry_in)
    {
        return {true, ((u32)carry_in << 31) | (x >> 1), x & 1};
    }
    std::tuple<bool, u32> RRX(u32 x, u8 carry_in)
    {
        return {true, ((u32)carry_in << 31) | (x >> 1)};
    }


    std::tuple<u32, u8, u8> add_with_carry(u32 x, u32 y, u8 carry_in)
    {
        u64 unsigned_sum = (u64)carry_in + (u64)x + (u64)y;
        i64 signed_sum = (i64)carry_in + (i32)x + (i32)y;
        u32 result = (u32)unsigned_sum;
        u8 carry_out = (result == unsigned_sum) ? 0 : 1;
        u8 overflow = ((i64)((i32)result) == signed_sum) ? 0 : 1;
        return {result, carry_out, overflow};
    }


    u32 align(u32 address, u32 alignment)
    {
        if (alignment == 1)
        {
            return address;
        }
        else if (alignment == 2)
        {
            return address & 0xFFFFFFFE;
        }
        else if (alignment == 4)
        {
            return address & 0xFFFFFFFC;
        }
        return 0;
    }


    std::tuple<ShiftType, u32> decode_imm_shift(u8 type, u32 imm5)
    {
        switch (type)
        {
            case 0b00:
                return {ShiftType::LSL, imm5};
            case 0b01:
                return {ShiftType::LSR, (imm5 == 0) ? 32 : imm5};
            case 0b10:
                return {ShiftType::ASR, (imm5 == 0) ? 32 : imm5};
            case 0b11:
            {
                if (imm5 == 0)
                {
                    return {ShiftType::RRX, 1};
                }
                else
                {
                    return {ShiftType::ROR, imm5};
                }
            }
        }
        return {ShiftType::LSL, 0}; // never reached
    }

    ShiftType decode_reg_shift(u8 type)
    {
        switch (type)
        {
            case 0b00: return ShiftType::LSL;
            case 0b01: return ShiftType::LSR;
            case 0b10: return ShiftType::ASR;
            case 0b11: return ShiftType::ROR;
        }
        return ShiftType::LSL; // never reached
    }

    u32 sign_extend(u32 value, u32 num_bits)
    {
        u8 sign = (value >> (num_bits - 1)) & 1;
        u32 mask = sign * (0xFFFFFFFF << num_bits);
        return mask | value;
    }

    u32 bit_count(u32 value)
    {
        u32 cnt = 0;
        while (value != 0)
        {
            cnt += (value & 1);
            value >>= 1;
        }
        return cnt;
    }

    u32 lowest_set_bit(u32 value)
    {
        for (u32 i = 0; i < 32; ++i)
        {
            if ((value >> i) & 1)
            {
                return i;
            }
        }
        return 32;
    }


    /*std::tuple<u32, bool> signed_sat_Q(i32 i, u32 n)
    {
        i32 sat = 1 << (n - 1);
        if (i > sat - 1)
        {
            return {(u32)(sat - 1), true};
        }
        else if (i < -sat)
        {
            return {(u32)(-sat), true};
        }
        return {(u32)i, false};
    }*/

    std::tuple<u32, bool> signed_sat_Q(i64 i, u32 n)
    {
        int32_t sat = 1 << (n - 1);
        if (i > static_cast<int64_t>(sat - 1))
        {
            return {(uint32_t)(sat - 1), true};
        }
        else if (i < static_cast<int64_t>(-sat))
        {
            return {(uint32_t)(-sat), true};
        }
        return {(uint32_t)i, false};
    }

    std::tuple<u32, bool> unsigned_sat_Q(i32 i, u32 n)
    {
        i32 sat = 1 << n;
        if (i > sat - 1)
        {
            return {(u32)(sat - 1), true};
        }
        else if (i < 0)
        {
            return {0, true};
        }
        return {(u32)i, false};
    }

    u32 signed_sat(i32 i, u32 n)
    {
        return std::get<0>(signed_sat_Q(i, n));
    }

    u32 unsigned_sat(i32 i, u32 n)
    {
        return std::get<0>(unsigned_sat_Q(i, n));
    }

    std::tuple<u32, bool> sat_Q(i32 i, u32 n, bool unsigned_sat)
    {
        if (unsigned_sat)
        {
            return unsigned_sat_Q(i, n);
        }
        return signed_sat_Q(i, n);
    }

    u32 sat(i32 i, u32 n, bool unsigned_sat)
    {
        return std::get<0>(sat_Q(i, n, unsigned_sat));
    }

    std::tuple<bool, u32, u8> thumb_expand_imm_C(u32 imm, u8 carry_in)
    {
        u32 res;
        u8 carry_out;
        if (_2BIT(imm >> 10) == 0b00)
        {
            u8 tmp = _2BIT(imm >> 8);
            u32 byte = _8BIT(imm);
            if (tmp == 0b00)
            {
                res = byte;
            }
            else if (tmp == 0b01)
            {
                if (byte == 0)
                {
                    return {false, 0, 0};
                }
                res = (byte << 16) | byte;
            }
            else if (tmp == 0b10)
            {
                if (byte == 0)
                {
                    return {false, 0, 0};
                }
                res = (byte << 24) | (byte << 8);
            }
            else // if (tmp == 0b11)
            {
                if (byte == 0)
                {
                    return {false, 0, 0};
                }
                res = (byte << 24) | (byte << 16) | (byte << 8) | byte;
            }
            carry_out = carry_in;
        }
        else
        {
            u32 tmp = (1 << 7) | _7BIT(imm);
            auto [b, rot, c] = ROR_C(tmp, _5BIT(imm >> 7));
            if (!b) return {false, 0, 0};
            res = rot;
            carry_out = c;
        }
        return {true, res, carry_out};
    }

    std::tuple<bool, u32> thumb_expand_imm(u32 imm)
    {
        auto [a, b, c] = thumb_expand_imm_C(imm, 0);
        UNUSED(c);
        return {a, b};
    }
}
