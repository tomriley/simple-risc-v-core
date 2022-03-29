#!/bin/bash
set -e
set -o pipefail

#rustc --target=riscv32i-unknown-none-elf  src/main.rs
riscv64-unknown-elf-objdump --disassemble-all --disassemble-zeroes main
