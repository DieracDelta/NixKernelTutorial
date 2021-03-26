use std::env;

fn main() {
    //println!("cargo:rustc-link-search=/home/jqr0316/projectx/reproducible/projects/camkes/../..//build/libsel4/");
    match env::var("PWD") {
        Ok(val) => 
            println!("cargo:rustc-link-search={}/clib/", val),
        Err(_e) => println!("Variable CWD not set.  Build will fail."),
    }
    println!("cargo:rustc-link-lib=static=lib");
}
