#pragma once

#include "Software/mulator/types.h"

namespace mulator
{

    struct MemoryRegion
    {
        u32 offset;
        u32 size;
        u8* bytes;
        struct
        {
            bool read;
            bool write;
            bool execute;
        } access;

        bool contains(u32 address, u32 len) const
        {
            return (address >= offset) && ((u64)(address - offset) + len <= (u64)size);
        }

        u8* get(u32 address) const
        {
            return bytes + (address - offset);
        }
    };

}
