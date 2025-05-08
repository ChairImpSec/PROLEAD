MEMORY
{
    flash (rx) : ORIGIN = 0x00008000, LENGTH = 32K /* FLASH area */
    ram (xrw):   ORIGIN = 0x00020000, LENGTH = 192K /* RAM area */
}


SECTIONS
{
    .text : /* collect all code related sections */
    {
        KEEP(*(.vectors .vectors.*))
        . = ALIGN(4);
        *(.text) /* all .text sections (code) */
        *(.rodata) /* all .rodata sections (constants,…) */
        _etext = .; /* define a global symbol _etext */
        _exit = .;
    } >flash /* put all the above into flash */

    .randomness : 
    {
        . = ALIGN(4);
        _random = .;
        _erandom = .;
    } >ram

    .data : /* all .data sections to RAM */
    {
        . = ALIGN(4);
        _data = .; /* symbol marking the .data start */
        *(.data) /* all .data sections */
        _edata = .; /* symbol marking the .data end */
    } >ram AT >flash /* .data will reside in RAM, but it is
    stored in the flash */

    .bss (NOLOAD) : /* .bss sections to RAM */
    {
        . = ALIGN(4);
        __bss_start__ = .; /*.bss section start*/
        *(.bss) /* all .bss sections */
        *(COMMON)
        __bss_end__ = . ; /* .bss end symbol */
    } >ram /* put all the above in RAM */

    _end = . ;

}
