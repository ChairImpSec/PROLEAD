
MEMORY
{
 ram (rwx) : ORIGIN = 0x20000000, LENGTH = 112K
 ram2 (rwx) : ORIGIN = 0x2001c000, LENGTH = 16K
 flash (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
 ccm (rwx) : ORIGIN = 0x10000000, LENGTH = 64K
}
SECTIONS
{
 .text : {
  *(.vectors)
  *(.text*)
  . = ALIGN(4);
  *(.rodata*)
  . = ALIGN(4);
 } >flash
 .preinit_array : {
  . = ALIGN(4);
  __preinit_array_start = .;
  KEEP (*(.preinit_array))
  __preinit_array_end = .;
 } >flash
 .init_array : {
  . = ALIGN(4);
  __init_array_start = .;
  KEEP (*(SORT(.init_array.*)))
  KEEP (*(.init_array))
  __init_array_end = .;
 } >flash
 .fini_array : {
  . = ALIGN(4);
  __fini_array_start = .;
  KEEP (*(.fini_array))
  KEEP (*(SORT(.fini_array.*)))
  __fini_array_end = .;
 } >flash
 .ARM.extab : {
  *(.ARM.extab*)
 } >flash
 .ARM.exidx : {
  __exidx_start = .;
  *(.ARM.exidx*)
  __exidx_end = .;
 } >flash
 . = ALIGN(4);
 _etext = .;
 .data : {
  _data = .;
  *(.data*)
  . = ALIGN(4);
  _edata = .;
 } >ram AT >flash
 _data_loadaddr = LOADADDR(.data);
 .bss : {
  *(.bss*)
  *(COMMON)
  . = ALIGN(4);
  _ebss = .;
 } >ram
 .randomness : 
 {
     . = ALIGN(4);
     _random = .;
     _erandom = .;
 } >ram
 .ram2 : {
  *(.ram2*)
  . = ALIGN(4);
 } >ram2
 .ccm : {
  *(.ccmram*)
  . = ALIGN(4);
 } >ccm
 /DISCARD/ : { *(.eh_frame) }
 . = ALIGN(4);
 end = .;
}
/*PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));*/
