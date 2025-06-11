OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
  . = 0x80200000; /* OpenSBI loads at this address */

  .text : {
    *(.text.entry) /* Entry point */
    *(.text)
    *(.text.*)
  }

  .rodata : {
    . = ALIGN(8);
    *(.rodata)
    *(.rodata.*)
  }

  .data : {
    . = ALIGN(8);
    *(.data)
    *(.data.*)
  }

  .bss : {
    . = ALIGN(8);
    *(.bss)
    *(.bss.*)
  }

  _kernel_end = .;
}
