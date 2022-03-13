#!/bin/bash
set -e
set -o pipefail

iverilog -g2005-sv riscv_tb.v
vvp a.out
