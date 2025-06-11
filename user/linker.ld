OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
  . = 0x40000;
  .text : {
    *(.text.entry) /* Entry point */
    *(.text*)
  }
  .rodata : {
    *(.rodata*)
  }
  .data : {
    *(.data*)
  }
  .bss : {
    *(.bss*)
  }
}

