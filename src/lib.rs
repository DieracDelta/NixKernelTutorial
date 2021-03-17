#![no_std]
#![no_main]
#![allow(dead_code)]
#![feature(lang_items)]

#[panic_handler]
fn my_panic(_info: &core::panic::PanicInfo) -> ! {
        loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
