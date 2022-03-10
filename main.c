#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "main.h"
#include "libelf/elf.h"

#define MEMORY_SIZE 65536

uint8_t* mem = NULL; // based at 0x80000000
int PC = 31;
uint32_t reg[32] = { 0 };

uint32_t memr(uint32_t addr) {
    addr -= 0x80000000;
    uint32_t value = *(uint32_t*) (mem + addr);
    //printf("memr[0x%08x] -> 0x%08x\n", addr, value);
    return value;
}

const char* dump(uint32_t opcode) {
    static char str[20];
    sprintf(str, "0x%08x", opcode);
    return str;
}

void dump_all() {
    for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 4; col++) {
            int i = 4*row+col;
            if (i == PC) {
                printf("\033[0;32m[ PC]\033[0m");
            } else {
                printf("[r%02d]", i);
            }
            if (reg[i])
                printf(BOLDRED " %08x " RESET, reg[i]);
            else
                printf(RED " %08x " RESET, reg[i]);
        }
        printf("\n");
    }
}

const char* as_binary_str(uint32_t value) {
    static char bits[33];
    bits[32] = '\0';
    for (int i = 0; i < 32; i++) {
        bits[31 - i] = (value & 0x1) ? '1' : '0';
        value = value >> 1;
    }
    return bits;
}

void step() {
    // FETCH
    uint32_t instr = memr(reg[PC]);
    uint32_t low2 = instr & 0x3;

    printf("next instr: %s\n", as_binary_str(instr));
    dump_all();

    // DECODE
    // EXECUTE

    exit(-1);
}

int32_t main() {
    const char* name = "riscv-tests/isa/rv32ui-p-add";
    Fhdr fhdr;
    FILE* f = fopen(name, "r");
    uint64_t size = -1;

    mem = malloc(MEMORY_SIZE);

    printf("Loading %s...\n", name);
    readelf(f, &fhdr);
    reg[PC] = fhdr.entry;
    char* section_name = NULL;

    // Load allocatable sections into memory
    for (int i = 0; i < fhdr.shnum; i++) {
        uint8_t* data = readelfsectioni(f, i, &section_name, &size, &fhdr);
        if (data == NULL) continue;
        if (fhdr.flags & 0x2) { // SHF_ALLOC
            printf("\t%s loaded (%llu bytes)  vaddr:0x%08x\n", section_name, size, (uint32_t) fhdr.addr);
            memcpy(mem + fhdr.addr - 0x80000000, data, fhdr.size);
        }
    }

    while(1) step();
}
