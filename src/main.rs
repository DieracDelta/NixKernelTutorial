#![no_std]
#![no_main]
#![feature(asm, llvm_asm)]
#![feature(naked_functions)]

use core::panic::PanicInfo;

extern "C" {
    static __global_pointer: usize;
    static _end_stack: usize;
}

#[naked]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    unsafe {
        asm!(
            "
                li sp, 0x80290000
                j main
            ",
            //end_stack = const 0x80290000 as i64,
            options(noreturn)
        );
    }
}

#[no_mangle]
pub extern "C" fn main() -> ! {
    unsafe {
        "hello world from a nixified rust kernel :D\n"
            .chars()
            .for_each(|c| write_char(c as u8));
    }
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

unsafe fn write_char(ch: u8) {
    // just use opensbi
    asm!(
    "
    li a7, 0x1
    lw a0, 0({0})
    ecall
    " , in(reg) (&ch), out("a0") _, out("a7") _
    );
}
