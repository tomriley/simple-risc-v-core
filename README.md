A RISC-V core written in C and then in Verilog. The aim of this project is to progressively learn more about the RISC-V ISA, learn Verilog and HDL in general, and more about how CPUs are implemented in hardware.

Dependencies
------------

In the project root, download and compile the riscv-test:

    $ git clone https://github.com/riscv/riscv-tests
    $ cd riscv-tests
    $ git submodule update --init --recursive
    $ autoconf
    $ ./configure
    $ make

Compile & run tests
-------------------

    $ make
    $ make test

Run a single test
-----------------

    $ ./riscv-core riscv-tests/isa/rv32ui-p-add

Compile & run tests (Verilog)
----------------------------

    $ cd verilog
    $ make
    $ make test

Running a single test (Verilog)
------------------------------

    $ cd verilog
    $ vvp -n core_tb +ROM=tests/rv32ui-p-add.hex

Output will look similar to the C version. The -n flag will cause vvp to exit with a non-zero exit code if the test fails (rather than drop into the interactive mode).

To-do
-----

* Finish implementing memory interface in Verilog

Example output
--------------
<img src="docs/run-single.png" width="600" />


Reference
---------

* [RISC-V ISA](https://riscv.org/technical/specifications/)
* https://en.wikipedia.org/wiki/Executable_and_Linkable_Format

Dependencies
------------

* RISC-V tests: https://github.com/riscv-software-src/riscv-tests
* Simple ELF loading library: https://github.com/0intro/libelf ([forked](https://github.com/tomriley/libelf))
