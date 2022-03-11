#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdbool.h>
#include "main.h"
#include "libelf/elf.h"

void panic(const char *fmt, ...);
void dump_all();

void update_pc(uint32_t value);

int32_t read_reg(int index);
void write_reg(int index, int32_t value);
int32_t read_csr(int index);
void write_csr(int index, int32_t value);

#define MEMORY_SIZE 65536
#define BASE_ADDR 0x80000000
#define REG_A0 10 // failing test number is loaded into here

#define LUI    0b0110111
#define AUIPC  0b0010111
#define OP_IM   0b0010011
    #define ADDI  0b000
    #define SLTI  0b010
    #define SLTIU 0b011
    #define XORI  0b100
    #define ORI   0b110
    #define ANDI  0b111
    #define SLLI  0b001
    #define SRLI_SRAI  0b101
#define OP     0b0110011
    #define ADD_SUB 0b000
    #define SLL 0b001
    #define SLT 0b010
    #define SLTU 0b011
    #define XOR 0b100
    #define SRL_SRA 0b101
    #define OR  0b110
    #define AND 0b111
#define JAL    0b1101111
#define JALR   0b1100111
#define LOAD   0b0000011
    #define LB  0b000
    #define LH  0b001
    #define LW  0b010
    #define LBU 0b100
    #define LHU 0b101
#define STORE  0b0100011
    #define SB  0b000
    #define SH  0b001
    #define SW  0b010
#define STORE  0b0100011
#define SYSTEM 0b1110011
    #define CSRRW 0b001
    #define CSRRS 0b010
    #define CSRRC 0b011
    #define CSRRWI 0b101
    #define ECALL_EBREAK 0b000
#define BRANCH 0b1100011
    #define BEQ 0b000
    #define BNE 0b001
    #define BLT 0b100
    #define BGE 0b101
    #define BLTU 0b110
    #define BGEU 0b111
#define FENCE  0b0001111

#define extract(value, start, end) ((value >> start) & ((0x1 << (end - start + 1)) - 1))
#define sign_extend(value, width) (((int32_t) value << (32 - width)) >> (32 - width))

int steps = 0;
int8_t* mem = NULL; // based at 0x80000000
uint32_t PC = 0;
int32_t _reg[32] = { 0 };
int32_t _csr[4096] = { 0 };

void update_pc(uint32_t value) {
    if (value & 0x3)
        panic("new PC value is unaligned address 0x%08x", value);
    PC = value;
}

int32_t read_reg(int index) {
    if (index == 0) return 0;
    return _reg[index];
}

void write_reg(int index, int32_t value) {
    if (index == 0) {
        printf(RED "attempt to write %d to x0\n" RESET, value);
        return;
    }
    if (index > 31) {
        panic("tried to write %d to register %d", value, index);
    }
    _reg[index] = value;
}

int32_t read_csr(int index) {
    //if (index == 0) return 0;

    //3860 is heartid?

    return _csr[index];
}

void write_csr(int index, int32_t value) {
    //if (index == 0) return;
    _csr[index] = value;
}

void write_mem(uint32_t addr, uint32_t value) {

}

int32_t read_mem_w(uint32_t addr) {
    addr -= BASE_ADDR;
    if (addr > MEMORY_SIZE-sizeof(uint32_t) || addr < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint32_t value = *(uint32_t*)(mem + addr);
    return value;
}

int16_t read_mem_h(uint32_t addr) {
    addr -= BASE_ADDR;
    if (addr > MEMORY_SIZE-sizeof(uint16_t) || addr < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint16_t value = *(uint16_t*) (mem + addr);
    return value;
}

int8_t read_mem_b(uint32_t addr) {
    addr -= BASE_ADDR;
    if (addr > MEMORY_SIZE-sizeof(uint8_t) || addr < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint8_t value = *(uint8_t*) (mem + addr);
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

void panic(const char *fmt, ...) {
    char str[2048];
    va_list args;
    va_start(args, fmt);
    vsnprintf(str, 2048, fmt, args);
    va_end(args);
    
    fprintf(stderr, BOLDRED "panic: %s\n" RESET, str);
    dump_all();
    exit(-1);
}

const char* as_binary_str(uint32_t value, int len) {
    static char bits[33];
    bits[len] = '\0';
    for (int i = 0; i < len; i++) {
        bits[len - 1 - i] = (value & 0x1) ? '1' : '0';
        value = value >> 1;
    }
    return bits;
}

void step() {
    // FETCH
    uint32_t inst = read_mem_w(PC);
    
    dump_all();
    printf("IFETCH: %s  0x%08x   PC: %08x\n", as_binary_str(inst, 32), inst, PC);

    // DECODE
    uint8_t opcode = extract(inst, 0, 6);
    uint8_t rd   = extract(inst, 7, 11);
    uint8_t funct3 = extract(inst, 12, 14);
    
    uint8_t rs1  = extract(inst, 15, 19);
    uint8_t rs2  = extract(inst, 20, 24);
    uint8_t shamt = rs2;
    // I-Type
    int32_t i_imm = extract(inst, 20, 31);
    int32_t i_simm = sign_extend(i_imm, 12);
    // R-Type
    //uint8_t r_imm = extract(inst, 25, 31);
    uint8_t funct7 = extract(inst, 25, 31);
    // B-Type
    uint32_t b_imm = \
        extract(inst, 8,  11) << 1 |
        extract(inst, 25, 30) << 5 |
        extract(inst, 7,  7)  << 11 |
        extract(inst, 31, 31) << 12;
    int32_t b_simm = sign_extend(b_imm, 13);
    // J-Type
    uint32_t j_imm = \
        extract(inst, 21, 30) << 1 |
        extract(inst, 20, 20) << 11 |
        extract(inst, 12, 19) << 19 |
        extract(inst, 31, 31) << 20;
    int32_t j_simm = sign_extend(j_imm, 21);
    // U-Type
    uint32_t u_imm = extract(inst, 12, 31);

    printf("opcode: %d rd: %d rs1: %d rs2: %d funct3: %d\n", opcode, rd, rs1, rs2, funct3);

    // preload register values
    int32_t rs1_was = read_reg(rs1);
    int32_t rs2_was = read_reg(rs2);
    int32_t pc_was = PC;

    // new values
    int32_t new_pc = PC + 4;
    int32_t rd_val = 0xdeadbeef;

    // flags
    bool write_rd = false;

    // EXECUTE
    switch (opcode) {
        case LOAD: {
            // I-type
            switch (funct3) {
                case LW:
                    printf("LW\n");
                    write_reg(rd, read_mem_w(rs1_was + i_simm));
                    break;
                
                case LH:
                    printf("LH\n");
                    write_reg(rd, read_mem_h(rs1_was + i_simm)); // will sign extend
                    break;

                case LB:
                    printf("LB\n");
                    write_reg(rd, read_mem_b(rs1_was + i_simm)); // will sign extend
                    break;
                
                case LHU:
                    write_reg(rd, (uint16_t) read_mem_h(rs1_was + i_simm)); // zero extend
                    break;
                
                case LBU:
                    write_reg(rd, (uint8_t) read_mem_b(rs1_was + i_simm)); // zero extend
                    break;
                
                default:
                    panic("unknown LOAD funct3");
            }
            break;
        }
        
        case STORE: {
            // S-type

            break;
        }

        case OP: {
            // R-Type operations
            write_rd = true;
            switch (funct3) {
                case ADD_SUB:
                    if (funct7 == 0b0100000)
                        rd_val = rs1_was - rs2_was;
                    else
                        rd_val = rs1_was + rs2_was;
                    break;
                case SLL:
                    rd_val = rs1_was << (rs2_was & 0x1F);
                    break;
                case SLT:
                    rd_val = rs1_was < rs2_was ? 1 : 0;
                    break;
                case SLTU:
                    rd_val = ((int32_t) rs1_was) < ((int32_t) rs2_was) ? 1 : 0;
                    break;
                case XOR:
                    rd_val = rs1_was ^ rs2_was;
                    break;
                case SRL_SRA:
                    if (funct7 == 0b0100000) {
                        rd_val = ((int32_t) rs1_was) >> (rs2_was & 0x1F); // arithmetic (signed) shift
                    } else {
                        rd_val = rs1_was >> (rs2_was & 0x1F);
                    }
                    break;
                case OR:
                    rd_val = rs1_was | rs2_was;
                    break;
                case AND:
                    rd_val = rs1_was & rs2_was;
                    break;
                
                default:
                    panic("unknown OP funct3");
            }
            break;
        }

        case OP_IM: {
            // I-type
            write_rd = true;
            switch (funct3) {
                case ADDI: {
                    // TODO/CHECK "Arithmetic overflow is ignored and the result
                    // is simply the low XLEN bits of the result
                    rd_val = rs1_was + i_simm;
                    break;
                }
                
                case SLTI:
                    rd_val = rs1_was < i_simm ? 1 : 0;
                    break;
                
                case SLTIU:
                    rd_val = ((uint32_t) rs1_was) < i_imm ? 1 : 0;
                    break;
                
                case XORI:
                    rd_val = rs1_was ^ i_simm;
                    break;
                
                case ORI:
                    rd_val = rs1_was | i_simm;
                    break;

                case ANDI:
                    rd_val = rs1_was & i_simm;
                    break;
                
                case SLLI:
                    rd_val = rs1_was << shamt;
                    break;
                
                case SRLI_SRAI:
                    if (i_imm & 0b010000000000)
                        rd_val = rs1_was >> shamt; // signed
                    else
                        rd_val = ((uint32_t) rs1_was) >> shamt;
                    break;
                
                default:
                    panic("Unknown OP_IM func");
            }
            break;
        }

        case LUI:
            // U-Type
            printf("LUI\n");
            write_rd = true;
            rd_val = u_imm << 12;
            break;

        case AUIPC:
            // U-Type
            printf("AUIPC u_imm is\n");
            write_rd = true;
            rd_val = pc_was + (u_imm << 12);
            break;

        case JALR: {
            printf("JALR\n");
            write_rd = true;
            // I-Type encoding
            rd_val = new_pc;
            new_pc = (rs1_was + i_simm) & (0xFFFFFFFF << 1);

            // TODO
            //
            // The JAL and JALR instructions will generate an instruction-address-misaligned exception if the target address is not aligned to a four-byte boundary.
            break;
        }

        case JAL: {
            printf("JAL\n");
            write_rd = true;
            rd_val = new_pc;
            new_pc = pc_was + j_simm;
            break;
        }

        case SYSTEM: {
            uint32_t imm = inst >> 20; // source/dest
            
            //printf("SYSTEM func %s\n", as_binary_str(func, 3));

            switch (funct3) {
                case CSRRW: {
                    printf("CSRRW csr: %d rs1: %d rd: %d\n", imm, rs1, rd);
                    if (rd != 0)
                        write_reg(rd, read_csr(imm));
                    write_csr(imm, read_reg(rs1));
                    break;
                }

                case CSRRS: {
                    printf("CSRRS csr: %d rs1: %d rd: %d\n", imm, rs1, rd);
                    write_reg(rd, read_csr(imm));
                    if (rs1 == 0) break; // avoid "side effects" of write
                    write_csr(imm, read_csr(imm) | read_reg(rs1));
                    break;
                }

                case CSRRC: {
                    printf("CSRRC csr: %d rs1: %d rd: %d\n", imm, rs1, rd);
                    if (rs1 == 0) break; // avoid "side effects" of write
                    // clear bits set is reg(rs1)
                    write_reg(rd, read_csr(imm) & ~read_reg(rs1));
                }

                case CSRRWI: {
                    printf("CSRRWI csr: %d rs1: %d rd: %d\n", imm, rs1, rd);
                    if (rd != 0)
                        write_reg(rd, read_csr(imm));
                    write_csr(imm, read_reg(rs1));
                    break;
                }

                case ECALL_EBREAK: {
                    uint32_t imm = ((int32_t) inst) >> 20;
                    
                    if (imm == 1) {
                        panic("EBREAK");
                    } else if (imm == 0) {
                        //printf("ECALL\n");
                        if (read_reg(REG_A0)) {
                            int failed_test_num = read_reg(REG_A0) >> 1;
                            dump_all();
                            fprintf(stderr, CYAN "  Test %d failed\n" RESET, failed_test_num);
                            exit(-1);
                        } else {
                            printf(GREEN "Tests Passed!\n" RESET);
                            exit(0);
                        }
                        
                    } else {
                        printf(RED "unknown ECALL_EBREAK func: %s\n" RESET, as_binary_str(funct3, 3) );
                    }
                    break;
                }

                default:
                    printf(RED "unknown SYSTEM func: %s" RESET, as_binary_str(funct3, 3) );
            }

            break;
        }
        
        case BRANCH: {
            // B-Type instruction
            bool jump = false;
            printf("BRANCH func %s offset is %d, s_offset is %d\n", as_binary_str(funct3, 3), b_imm, b_simm);

            switch (funct3) {
                case BEQ:
                    jump = rs1_was == rs2_was;
                    break;

                case BNE:
                    jump = rs1_was != rs2_was;
                    break;
                
                case BLT:
                    jump = rs1_was < rs2_was;
                    break;
                
                case BLTU:
                    jump = ((uint32_t) rs1_was) < ((uint32_t) rs2_was);
                    break;
                
                case BGE:
                    jump = rs1_was > rs2_was;
                    break;

                case BGEU:
                    jump = ((uint32_t) rs1_was) > ((uint32_t) rs2_was);
                    break;

                default:
                    panic("unknown BRANCH func3");
            }

            if (jump) {
                if (!b_simm) panic("jump offset zero");
                new_pc = pc_was + b_simm;
            }
            break;
        }

        case FENCE:
            break;

        default:
            panic("expected opcode %s\n", as_binary_str(opcode, 7));
            break;
    }

    // Update registers
    update_pc(new_pc);
    if (write_rd)
        write_reg(rd, rd_val);
}

int32_t main(int argc, char *argv[]) {
    Fhdr fhdr;
    char* name = argv[1];
    FILE* f = fopen(name, "r");
    uint64_t size = -1;

    setbuf(stdout, NULL);
    mem = malloc(MEMORY_SIZE);
    
    printf("Loading %s...\n", name);
    readelf(f, &fhdr);
    update_pc(fhdr.entry);
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

    while(true) step();
}
