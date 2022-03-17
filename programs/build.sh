#!/bin/bash
set -e
set -o pipefail

NAME=simple

riscv64-unknown-elf-gcc \
  -march=rv32g -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
  -T../riscv-tests/env/p/link.ld \
  $NAME.c -o $NAME

riscv64-unknown-elf-objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup \
  --section=.text.init --section=.data $NAME > $NAME.dump
