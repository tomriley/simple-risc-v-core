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
#define IMM_OP   0b0010011
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

int steps = 0;
int8_t* mem = NULL; // based at 0x80000000
uint32_t PC = 0;
int32_t _reg[32] = { 0 };
int32_t _csr[4096] = { 0 };

void update_pc(uint32_t value) {
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

uint32_t write_mem(uint32_t addr, uint32_t value) {

}

uint32_t read_mem_w(uint32_t addr) {
    addr -= BASE_ADDR;
    if (addr > MEMORY_SIZE-sizeof(uint32_t) || addr < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint32_t value = *(uint32_t*)(mem + addr);
    return value;
}

uint16_t read_mem_h(uint32_t addr) {
    if (addr - BASE_ADDR > MEMORY_SIZE-sizeof(uint16_t) || addr - BASE_ADDR < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint16_t value = *(uint16_t*) (mem + addr - BASE_ADDR);
    return value;
}

uint8_t read_mem_b(uint32_t addr) {
    if (addr - BASE_ADDR > MEMORY_SIZE-sizeof(uint8_t) || addr - BASE_ADDR < 0) {
        panic("memory address 0x%08x out of bounds", addr);
    }
    uint8_t value = *(uint8_t*) (mem + addr - BASE_ADDR);
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
            if (i == -1) {
                printf(GREEN "[  PC]" RESET);
            } else {
                printf("[ x%02d]", i);
            }
            if (read_reg(i))
                printf(BOLDRED " %08x " RESET, read_reg(i));
            else
                printf(RED " %08x " RESET, read_reg(i));
            printf(BLUE " (%d) " RESET, read_reg(i));
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
    bool jumped = false;
    
    dump_all();
    printf("IFETCH: %s  0x%08x   PC: %08x\n", as_binary_str(inst, 32), inst, PC);

    // DECODE
    uint8_t opcode = inst & 0x7F;
    uint8_t rd   = inst >> 7  & 0x1F;
    uint8_t func = inst >> 12 & 0x7;
    uint8_t rs1  = inst >> 15 & 0x1F;
    uint8_t rs2  = inst >> 20 & 0x1F;
    
    printf("opcode: %d rs1: %d rs2: %d\n", opcode, rs1, rs2);

    // EXECUTE
    switch (opcode) {
        case LOAD: {
            // I-type
            int32_t offset = ((int32_t) inst) >> 20;
            printf("LOAD offset is %d\n", offset);
            uint32_t addr = read_reg(rs1) + offset;
            
            switch (func) {
                case LW:
                    printf("LW\n");
                    write_reg(rd, read_mem_w(addr));
                    break;
                
                case LH:
                    printf("LH\n");
                    // must cast *from* signed int for sign extension
                    write_reg(rd, (int16_t) read_mem_h(addr));
                    break;

                case LB:
                    printf("LB\n");
                    write_reg(rd, (int8_t) read_mem_b(addr));
                    break;
            }
            break;
        }
        
        case STORE: {
            // S-type

            break;
        }

        case OP: {
            //printf("OP\n");
            // R-Type operations
            uint8_t func7 = inst >> 25 & 0x7F;

            switch (func7) {
                case ADD_SUB:
                    if (func7 == 0b0100000)
                        write_reg(rd, read_reg(rs1) - read_reg(rs2));
                    else
                        write_reg(rd, read_reg(rs1) + read_reg(rs2));
                    break;
                case SLL:
                    panic("tbi");
                    break;
                case SLT:
                    panic("tbi");
                    break;
                case SLTU:
                    panic("tbi");
                    break;
                case XOR:
                    panic("tbi");
                    break;
                case SRL_SRA:
                    panic("tbi");
                    if (func7 == 0b0100000) {
                        // sra
                    }
                    break;
                
                case OR:
                    panic("tbi");
                    break;
                case AND:
                    panic("tbi");
                    break;
                
                default:
                    panic("unknown OP func7");
            }
            break;
        }

        case IMM_OP: {
            //printf("IMM_OP (func %s)\n", as_binary_str(func, 3));
            int32_t imm = ((int32_t) inst) >> 20;
            switch (func) {
                case ADDI: {
                    // TODO/CHECK "Arithmetic overflow is ignored and the result
                    // is simply the low XLEN bits of the result
                    int64_t temp = read_reg(rs1);
                    temp += imm;
                    write_reg(rd, temp);
                    break;
                }
                
                case SLTI:
                    write_reg(rd, read_reg(rs1) < imm ? 1 : 0);
                    break;
                
                case SLTIU:
                    write_reg(rd, ((uint32_t) read_reg(rs1)) < ((uint32_t) imm) ? 1 : 0);
                    break;
                
                case XORI:
                    write_reg(rd, read_reg(rs1) ^ imm);
                    break;
                
                case ORI:
                    write_reg(rd, read_reg(rs1) | imm);
                    break;

                case ANDI:
                    write_reg(rd, read_reg(rs1) & imm);
                    break;
                
                case SLLI:
                    write_reg(rd, read_reg(rs1) << (imm & 0x1F));
                    break;
                
                case SRLI_SRAI:
                    if (imm & 0x800) {
                        write_reg(rd, read_reg(rs1) >> (imm & 0x1F));
                    } else {
                        write_reg(rd, ((uint32_t) read_reg(rs1)) >> (imm & 0x1F));
                    }
                    break;
                
                default:
                    panic("Unknown IMM_OP func");
            }
            break;
        }

        case LUI: {
            printf("LUI\n");
            uint32_t imm = inst & 0xFFFFF000;
            printf("imm 0x%05x\n", imm);
            write_reg(rd, imm);
            break;
        }

        case AUIPC: {
            int32_t imm = inst & 0xFFFFF000;
            write_reg(rd, PC + imm);
            break;
        }

        case JALR: {
            printf("JALR\n");
            // I-Type encoding
            uint32_t imm = ((int32_t) inst) >> 20;
            uint32_t target = (read_reg(rs1) + imm) & (0xFFFFFFFF << 1);
            
            // FIXME not sure if value in this rg is supposed to be updated
            //read_reg(rs1) = target;
            write_reg(rd, PC + 4);
            update_pc(target);

            // TODO
            //
            // The JAL and JALR instructions will generate an instruction-address-misaligned exception if the target address is not aligned to a four-byte boundary.
            break;
        }

        case JAL: {
            printf("JAL\n");

            // imm[ 20 |   10:1 | 11 |  19:12 ]  [other 12 bits of instr]
            //     1bit  10bits  1bit   8bits   = 20 bits
            uint32_t imm = ((int32_t) inst) >> 12; // sign extended shift
            
            // FIXME deal with sign extending
            int32_t offset = // cast to signed for final offset
                (imm & 0xFFF80000) | // most significant bits unchanged
                ((imm >> 9)  & 0x3FF) << 0  | // 10:1
                ((imm >> 8)  & 0x001) << 10 | // 11
                ((imm >> 0)  & 0x0FF) << 11;   // 19:12

            offset = offset << 1; // see above, starts at bit 1 (multiple of 2 bytes)

            printf("\timm was 0x%08x, decoded to 0x%08x\n", imm, offset);

            write_reg(rd, PC + 4);
            update_pc(PC + offset);
            jumped = true;

            break;
        }

        case SYSTEM: {
            uint32_t imm = inst >> 20; // source/dest
            
            //printf("SYSTEM func %s\n", as_binary_str(func, 3));

            switch (func) {
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
                        printf("ECALL\n");
                        if (read_reg(REG_A0)) {
                            int failed_test_num = read_reg(REG_A0) >> 1;
                            fprintf(stderr, CYAN "  Test %d failed\n" RESET, failed_test_num);
                            exit(-1);
                        } else {
                            printf(GREEN "Tests Passed!" RESET);
                            exit(0);
                        }
                        
                    } else {
                        printf(RED "unknown ECALL_EBREAK func: %s\n" RESET, as_binary_str(func, 3) );
                    }
                    break;
                }

                default:
                    printf(RED "unknown SYSTEM func: %s" RESET, as_binary_str(func, 3) );
            }

            break;
        }
        
        case BRANCH: {
            // B-Type instruction
            bool jump = false;
            uint32_t offset =
                ((inst >> 8)  & 0xF) << 1  |
                ((inst >> 25) & 0x3F) << 5 |
                ((inst >> 7)  & 0x1) << 11 |
                ((inst >> 31) & 0x1) << 12;
            // sign extend 13 value
            int32_t s_offset = ((int32_t) offset << (32-13)) >> (32-13);
            printf("BRANCH func %s offset is %d, s_offset is %d\n", as_binary_str(func, 3), offset, s_offset);

            switch (func) {
                case BEQ:
                    jump = read_reg(rs1) == read_reg(rs2);
                    break;

                case BNE:
                    jump = read_reg(rs1) != read_reg(rs2);
                    break;
                
                case BLT:
                    jump = read_reg(rs1) < read_reg(rs2);
                    break;
                
                case BLTU:
                    jump = ((uint32_t) read_reg(rs1)) < ((uint32_t) read_reg(rs2));
                    break;
                
                case BGE:
                    jump = read_reg(rs1) > read_reg(rs2);
                    break;

                case BGEU:
                    jump = ((uint32_t) read_reg(rs1)) > ((uint32_t) read_reg(rs2));
                    break;

                default:
                    panic("unknown BRANCH func3");
            }

            if (jump) {
                //printf("   -> Branching with offset %d\n", s_offset);
                if (!s_offset) panic("jump offset zero");
                update_pc(PC + s_offset);
                jumped = true;
            }
            break;
        }

        case FENCE: {
            printf("FENCE\n");
            break;;
        }

        default:
            panic("unknown opcode %s\n", as_binary_str(opcode, 7));
            break;
    }

    if (!jumped) {
        update_pc(PC + 4); // 32 bits
    }
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

    while(1) step();
}
