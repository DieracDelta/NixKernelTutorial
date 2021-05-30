OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  ram   (rwx) : ORIGIN = 0x80000000, LENGTH = 2M
  stack (rwx) : ORIGIN = 0x80200000, LENGTH = 2M
}

SECTIONS
{
  .text : {
    PROVIDE(_text_start = .);
    *(.text.init) *(.text .text.*)
    PROVIDE(_text_end = .);
  } >ram


  .stack (NOLOAD) : {
    . = ALIGN(8);
    PROVIDE(_start_stack = .);
    . = . + 0x10000;
    PROVIDE(_end_stack = .);
  } >stack

  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >ram

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
  } >ram

  .bss :{
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
  } >ram


  PROVIDE(_memory_start = ORIGIN(ram));
  PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));
}
