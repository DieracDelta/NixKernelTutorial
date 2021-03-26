pushd clib
bash build.sh
popd
RUSTFLAGS='--emit=llvm-ir' cargo build --target riscv64gc-unknown-none-elf --lib 
