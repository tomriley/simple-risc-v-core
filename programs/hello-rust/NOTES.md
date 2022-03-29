cargo install cargo-generate
cargo install cargo-binutils
rustup component add llvm-tools-preview

Rust RISCV runtime crate:
https://github.com/rust-embedded/riscv-rt

# show FUNC symbols, demangling names
riscv64-unknown-elf-readelf -CWs <path> | grep FUNC
