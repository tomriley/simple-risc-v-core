#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdbool.h>
#include "main.h"
#include "utils.h"
#include "libelf/elf.h"

int8_t*  mem = NULL;
uint32_t pc = 0;
int32_t  _regfile[32] = { 0 };

void dump_regs();
void panic(const char *fmt, ...);

int32_t sign_extend(uint32_t value, const int width) {
    if (value & (0x1 << (width - 1))) {
        return value | (INT32_MIN >> (32 - width));
    } else {
        return value;
    }
}

void write_pc(uint32_t value) {
    if (value & 0x3)
        panic("new PC value is unaligned address 0x%08x", value);
    pc = value;
}

int32_t read_reg(int index) {
    if (index == 0) return 0;
    return _regfile[index];
}

void write_reg(int index, int32_t value) {
    if (index == 0)
        return;
    if (index > 31)
        panic("tried to write %d to invalid register number %d", value, index);
    _regfile[index] = value;
}

#if EMULATE_CSR
int32_t _csr[4096] = { 0 };

int32_t read_csr(int index) {
    return _csr[index];
}

void write_csr(int index, int32_t value) {
    _csr[index] = value;
}
#endif

#define MEM_BOUNDS_CHECK(addr, type) \
     if (addr > MEMORY_SIZE - sizeof(type) || addr < 0) \
        panic("memory address 0x%08x out of bounds for type " #type, addr);

// Define memory store methods
#define STORE_MEM_FUNC(type) \
    void mem_store_##type(uint32_t addr, type data) { \
        addr -= BASE_ADDR; \
        MEM_BOUNDS_CHECK(addr, type); \
        *(type*)(mem + addr) = data; \
    }
STORE_MEM_FUNC(int8_t);
STORE_MEM_FUNC(int16_t);
STORE_MEM_FUNC(int32_t);

// Define memory load methods
#define READ_MEM_FUNC(type) \
    type mem_load_##type(uint32_t addr) { \
        addr -= BASE_ADDR; \
        MEM_BOUNDS_CHECK(addr, type); \
        return *(type*)(mem + addr); \
    }
READ_MEM_FUNC(int32_t);
READ_MEM_FUNC(int16_t);
READ_MEM_FUNC(int8_t);

bool branch(int32_t x, int32_t y, int32_t operator) {
    switch (operator) {
        case BEQ: return x == y;
        case BNE: return x != y;
        case BLT: return x < y;
        case BLTU: return ((uint32_t) x) < ((uint32_t) y);
        case BGE: return x >= y;
        case BGEU: return ((uint32_t) x) >= ((uint32_t) y);
        default: return false;
    }
}

int32_t alu(int32_t x, int32_t y, uint32_t operator, bool alt) {
    switch (operator) {
        case ADD: return alt ? x - y : x + y;
        case SLL: return ((uint32_t) x) << (y & 0x1F);
        case SLT: return x < y ? 1 : 0;
        case SLTU: return ((uint32_t) x) < ((uint32_t) y) ? 1 : 0;
        case XOR: return x ^ y;
        case SRL: return alt ? x >> (y & 0x1F) : ((uint32_t) x) >> (y & 0x1F);
        case OR: return x | y;
        case AND: return x & y;
        default: panic("unknown arith operator %d", operator); return 0;
    }
}

//
// RISC-V instruction pipeline
//
bool step() {
    // FETCH
    uint32_t idata = mem_load_int32_t(pc);
    
    dump_regs();
    printf("idata: %s  0x%08x  " GREEN "PC: %08x\n" RESET, as_binary_str(idata, 32), idata, pc);

    // DECODE
    uint8_t opcode = BITS(idata, 0, 6);
    uint8_t funct3 = BITS(idata, 12, 14);
    uint8_t rd = BITS(idata, 7, 11);
    uint8_t rs1 = BITS(idata, 15, 19);
    uint8_t rs2 = BITS(idata, 20, 24);
    // R-Type
    uint8_t funct7 = BITS(idata, 25, 31);
    // I-Type
    int32_t i_imm = sign_extend(BITS(idata, 20, 31), 12);
    // S-Type
    int32_t s_imm = sign_extend(
        BITS(idata, 7, 11) |
        BITS(idata, 25, 31) << 5,
        12
    );
    // U-Type (LUI AND AIUPC)
    int32_t u_imm = BITS(idata, 12, 31) << 12;
    // B-Type
    int32_t b_imm = sign_extend(
        BITS(idata, 8,  11) << 1 |
        BITS(idata, 25, 30) << 5 |
        BITS(idata, 7,  7)  << 11 |
        BITS(idata, 31, 31) << 12,
        13
    );

    // J-Type
    int32_t j_imm = sign_extend(
        BITS(idata, 21, 30) << 1 |
        BITS(idata, 20, 20) << 11 |
        BITS(idata, 12, 19) << 19 |
        BITS(idata, 31, 31) << 20,
        21
    );
    
    // flags
    bool alt = funct7 == 0b0100000 && (
        opcode == OP && funct3 == SUB ||
        opcode == OP && funct3 == SRA ||
        opcode == OP_IM && funct3 == SRAI
    );

    // preload register values
    int32_t rs1v = read_reg(rs1);
    int32_t rs2v = read_reg(rs2);
    int32_t pc_was = pc;

    printf("opcode: %s rd: %d rs1: %d (v %d) rs2: %d (v %d) funct3: %d  u_imm: 0x%08x\n", as_binary_str(opcode, 7), rd, rs1, rs1v, rs2, rs2v, funct3, u_imm);

    // values that will be written back to regs
    int32_t pending_pc = pc + 4;
    int32_t pending = 0xdeadbeef; // pending rd value

    // flags
    bool write_back = // write back pending to rd
        opcode == JAL ||
        opcode == JALR;
    bool write_alu_result = // write the API result back to rd
        opcode == LOAD ||
        opcode == OP ||
        opcode == OP_IM ||
        opcode == LUI ||
        opcode == AUIPC; 
    bool alu_result_is_new_pc =
        opcode == JAL ||
        opcode == JALR;
    
    int32_t lhs = rs1v;
    int32_t rhs = opcode == OP ? rs2v : i_imm;
    int32_t oper = funct3;

    // for the following 3:
    //      rhs is always imm
    //      oper always ADD
    
    if (opcode == LUI) {
        rhs = u_imm;
        lhs = 0;
        oper = ADD;
    }

    if (opcode == AUIPC) {
        lhs = pc_was;
        rhs = u_imm;
        oper = ADD;
    }

    if (opcode == JALR) {
        pending = pending_pc; // old target pc
        lhs = rs1v;
        rhs = i_imm;
        oper = ADD;
    }

    if (opcode == JAL) { // J-Type
        pending = pending_pc; // old target pc
        lhs =  pc_was;
        rhs = j_imm;
        oper = ADD;
    }

    bool branch_result = branch(rs1v, rs2v, funct3);
    int32_t alu_result = alu(lhs, rhs, oper, alt);
    
    // Memory load/store
    switch (opcode) {
        case LOAD: {
            // I-type
            switch (funct3) {
                case LW:
                    pending = mem_load_int32_t(rs1v + i_imm);
                    break;
                case LH:
                    pending = mem_load_int16_t(rs1v + i_imm); // will sign extend
                    break;
                case LB:
                    pending = mem_load_int8_t(rs1v + i_imm); // will sign extend
                    break;
                case LHU:
                    pending = (uint16_t) mem_load_int16_t(rs1v + i_imm); // zero extend
                    break;
                case LBU:
                    pending = (uint8_t) mem_load_int8_t(rs1v + i_imm); // zero extend
                    break;
            }
            break;
        }
        case STORE: {
            // S-type
            switch (funct3) {
                case SB:
                    mem_store_int8_t(rs1v + s_imm, rs2v);
                    break;
                case SH:
                    mem_store_int16_t(rs1v + s_imm, rs2v);
                    break;
                case SW:
                    mem_store_int32_t(rs1v + s_imm, rs2v);
                    break;
            }
            break;
        }
    }

    switch (opcode) {
        case SYSTEM: // I-type
            switch (funct3) {
                #if EMULATE_CSR
                case CSRRW:
                    if (rd != 0) {
                        write_pending = true;
                        pending = read_csr(i_imm);
                    }
                    write_csr(i_imm, read_reg(rs1));
                    break;
                case CSRRS:
                    write_pending = true;
                    pending = read_csr(i_imm);
                    if (rs1 != 0) // avoid "side effects" of write
                        write_csr(i_imm, read_csr(i_imm) | rs1v);
                    break;
                case CSRRC:
                    write_pending = true;
                    if (rs1 != 0) // clear bits set is reg(rs1)
                        pending = read_csr(i_imm) & ~rs1v;
                    break;
                case CSRRWI:
                    if (rd != 0) {
                        write_pending = true;
                        pending = read_csr(i_imm);
                    }
                    write_csr(i_imm, rs1v);
                    break;
                #endif
                case ECALL: // EBREAK
                    switch (i_imm) {
                        case 1:
                            panic("EBREAK");
                        case 0:
                            return false; // signal ECALL
                        default:
                            fprintf(stdout, RED "unexpected ECALL/EBREAK immediate: %s\n" RESET, as_binary_str(i_imm, 12));
                    }
                    break;
                default:
                    fprintf(stdout, RED "unknown SYSTEM func: %s\n" RESET, as_binary_str(funct3, 3));
            }
            break;

        case FENCE:
            break;

        case BRANCH:
            if (branch_result) {
                // assume branching has it's own adder unit
                pending_pc = pc_was + b_imm;
            }
            break;
    }

    // Update PC
    if (alu_result_is_new_pc)
        write_pc(alu_result);
    else
        write_pc(pending_pc);
    
    // Update target register
    if ((write_back || write_alu_result) && rd != 0) {
        printf("abut to write %08x to register %d\n", write_alu_result ? alu_result : pending, rd);
        if (write_alu_result)
            write_reg(rd, alu_result);
        else
            write_reg(rd, pending);
    }

    
    return true;
}

//
// Load the ELF file specified as the sole commenad argument, set PC to entry
// point then run our simulation pipeline until an ECALL instruction causes step()
// to return false.
// 
int32_t main(int argc, char *argv[]) {
    Fhdr fhdr;
    char* name = argv[1];
    FILE* f = fopen(name, "r");
    uint64_t size = -1;

    setbuf(stdout, NULL);
    setbuf(stderr, NULL);
    mem = malloc(MEMORY_SIZE);

    printf("Loading ELF file %s...\n", name);
    readelf(f, &fhdr);
    write_pc(fhdr.entry);
    char* section_name = NULL;

    // Load allocatable sections into memory
    for (int i = 0; i < fhdr.shnum; i++) {
        uint8_t* data = readelfsectioni(f, i, &section_name, &size, &fhdr);
        if (data == NULL) continue;
        if (fhdr.flags & 0x2) { // SHF_ALLOC
            printf("\tSection \"%s\" loaded (%llu bytes to 0x%08x)\n", section_name, size, (uint32_t) fhdr.addr);
            memcpy(mem + fhdr.addr - 0x80000000, data, fhdr.size);
        }
    }
    printf("ELF loading finished\n\n");

    printf("Dumping memory...\n");
    FILE* rom_file = fopen("rom_image.mem", "w");
    for (int i=0; i<MEMORY_SIZE; i++) {
        fprintf(rom_file, "%02x\n", (uint8_t) mem[i]);
    }
    fclose(rom_file);
    printf("Done\n");

    while (true) {
        if (!step()) {
            // ECALL signals end of test
            if (read_reg(10)) {
                int test_num = read_reg(10) >> 1;
                dump_regs();
                fprintf(stderr, CYAN "  Test %d failed\n" RESET, test_num);
                exit(-1);
            } else {
                printf(GREEN "Success!\n" RESET);
                exit(0);
            }
        }
    }
}

// Dump entire register file to stdout for debugging
void dump_regs() {
    for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 4; col++) {
            int i = 4*row+col;
            printf(" x%02d:", i);
            if (read_reg(i))
                printf(BOLDRED " %08x " RESET, read_reg(i));
            else
                printf(RED " %08x " RESET, read_reg(i));
            printf(BLUE "%-11d " RESET, read_reg(i));
        }
        printf("\n");
    }
}

// Bailing out with an error message
void panic(const char *fmt, ...) {
    char str[2048];
    va_list args;
    va_start(args, fmt);
    vsnprintf(str, 2048, fmt, args);
    va_end(args);
    
    fprintf(stderr, BOLDRED "panic: %s\n" RESET, str);
    dump_regs();
    exit(-1);
}