#pragma once

#include <inttypes.h>

namespace mulator
{

    #define UNUSED(x) (void)(x);

    using u8 = uint8_t;
    using u16 = uint16_t;
    using u32 = uint32_t;
    using u64 = uint64_t;

    using i8 = int8_t;
    using i16 = int16_t;
    using i32 = int32_t;
    using i64 = int64_t;

    #define _1BIT(x) ((x) & 0x1)
    #define _2BIT(x) ((x) & 0x3)
    #define _3BIT(x) ((x) & 0x7)
    #define _4BIT(x) ((x) & 0xF)
    #define _5BIT(x) ((x) & 0x1F)
    #define _6BIT(x) ((x) & 0x3F)
    #define _7BIT(x) ((x) & 0x7F)
    #define _8BIT(x) ((x) & 0xFF)
    #define _9BIT(x) ((x) & 0x1FF)
    #define _10BIT(x) ((x) & 0x3FF)
    #define _11BIT(x) ((x) & 0x7FF)
    #define _12BIT(x) ((x) & 0xFFF)
    #define _13BIT(x) ((x) & 0x1FFF)
    #define _14BIT(x) ((x) & 0x3FFF)
    #define _15BIT(x) ((x) & 0x7FFF)

}
