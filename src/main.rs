#![no_std]
#![no_main]
#![feature(asm)]
#![feature(naked_functions)]

use core::panic::PanicInfo;

extern "C" {
    static _end_stack: usize;
}

#[naked]
#[no_mangle]
pub extern "C" fn _start() -> ! {
    unsafe {
        asm!(
            "
                la sp, {end_stack}
                j main
            ",
            end_stack = sym _end_stack,
            options(noreturn)
        );
    }
}

#[no_mangle]
pub extern "C" fn main() -> ! {
    unsafe {
        "Hello World from a nixified rust kernel :D\n"
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
