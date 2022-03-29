OUTPUT_ARCH( "riscv" )
ENTRY(_start)
PROVIDE(_stack_start = ORIGIN(RAM) + LENGTH(RAM));

MEMORY
{
  RAM : ORIGIN = 0x80200000, LENGTH = 2M
  FLASH : ORIGIN = 0x80000000, LENGTH = 1M
}

SECTIONS
{
  . = ORIGIN(FLASH);
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : {
    *(.stack)
    *(.text)
  }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .bss : { *(.bss) }
  _end = .;
}

