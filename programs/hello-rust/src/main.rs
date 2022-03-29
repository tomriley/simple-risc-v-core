#![no_std]
#![no_main]

extern crate panic_halt;
extern crate riscv_rt;

use riscv_rt::entry;

#[entry]
fn main() -> ! {
    println("hello from Rust");
    loop {}
}

fn println(line: &str) {
  for char in line.chars() {
    putc(char);
  }
}

fn putc(c: char) {
  let io_addr: *mut char = 0x80100000 as *mut char;
  unsafe { *io_addr = c; }
}

