#![no_std]
#![no_main]
#![feature(asm)]
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
                lui  gp, %hi({gp})
                addi gp, gp, %lo({gp})
                lui  sp, %hi({end_stack})
                addi sp, sp, %lo({end_stack})
                j main
            ",
            gp = const 0x80000000 as u64,
            end_stack = const 0x80200000 as u64,
            options(noreturn)
        );
    }
}

#[no_mangle]
pub extern "C" fn main() -> ! {
    unsafe {
        *(0x10010008 as *const u8 as *mut u8) = 1;
        *(0x1001000C as *const u8 as *mut u8) = 1;
        *(0x10010010 as *const u8 as *mut u8) = 0;
        write_char('h' as u8);
        write_char('i' as u8);
        write_char('\n' as u8);
    }
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
//"
////li a7, 0x1
////lb a0, $0
//ecall
//",

unsafe fn write_char(ch: u8) {
    while *(0x10010000 as *const u8 as *mut u8) <= 0 {}
    *(0x10010000 as *const u8 as *mut u8) = ch;
    //llvm_asm!(
    //"
    //li a7, 0x1
    //lb a0, $0
    //ecall
    //" :: "r"(ch):
    //);
}
