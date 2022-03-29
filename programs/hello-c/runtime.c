extern void main();

void putc(char c) {
  char* io_addr = (char*) 0x80100000;
  *io_addr = c;
}

void println(const char* line) {
  int i = 0;
  char c;
  while ((c = line[i++]) != '\0') {
    putc(c);
  }
  putc('\n');
}

extern unsigned _stack_start;
__attribute__((section(".stack"), used)) unsigned *__stack_init = &_stack_start;

__attribute__((naked)) int _start() {
  __asm__("la sp, _stack_start");
  main();
}
