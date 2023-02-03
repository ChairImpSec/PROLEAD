

_estack = 0x20020000;


_Min_Heap_Size = 0;
_Min_Stack_Size = 0x400;


MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K

  RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 128K
  RAM2 (xrw): ORIGIN = 0x10000200, LENGTH = 64K

  MB1 (rx) : ORIGIN = 0x60000000, LENGTH = 0
}
