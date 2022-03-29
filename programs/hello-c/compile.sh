#!/bin/bash
set -e
set -o pipefail

NAME=hello

riscv64-unknown-elf-gcc \
  -Wno-builtin-declaration-mismatch \
  -march=rv32g \
  -mabi=ilp32 \
  -static \
  -mcmodel=medany \
  -fvisibility=hidden \
  -nostdlib \
  -nostartfiles \
  -Tlink.ld \
  $NAME.c runtime.c -o $NAME

riscv64-unknown-elf-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup \
  --section=.text.init --section=.data $NAME > $NAME.dump
