OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  ram (rwx) : ORIGIN = 0x80200000, LENGTH = 0x80000
}

SECTIONS
{
  .kernel : {
    *(.text.init) *(.text .text.*)
    *(.rodata .rodata.*)
    *(.sdata .sdata.*) *(.data .data.*)
    *(.sbss .sbss.*) *(.bss .bss.*)
  } > ram

  .stack (NOLOAD) : {
    . = . + 0x10000;
    PROVIDE(_end_stack = .);
  } > ram

}
