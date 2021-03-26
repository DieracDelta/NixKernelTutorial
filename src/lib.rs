#![no_std]
#![no_main]
#![allow(dead_code)]
#![feature(lang_items)]

#[panic_handler]
fn my_panic(_info: &core::panic::PanicInfo) -> ! {
        let a: f64 = 9.876543;
        loop {
            unsafe {
                example_fn(5, a);
            }
        }
}

//#[no_mangle]
//extern "C" fn example_fn(mut a: f64) -> ! {
//    loop {
//        a = 2.0*a; 
//    }
//}

#[no_mangle]
extern "C" {
    fn example_fn(a: i8, ...) -> f64;
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {}
