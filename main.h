
#define MEMORY_SIZE 65536
#define BASE_ADDR 0x80000000

#define LUI     0b0110111
#define AUIPC   0b0010111
#define BRANCH 0b1100011
    #define BEQ  0b000
    #define BNE  0b001
    #define BLT  0b100
    #define BGE  0b101
    #define BLTU 0b110
    #define BGEU 0b111
#define OP_IM   0b0010011
    #define ADDI  0b000
    #define SLTI  0b010
    #define SLTIU 0b011
    #define XORI  0b100
    #define ORI   0b110
    #define ANDI  0b111
    #define SLLI  0b001
    #define SRLI  0b101
    #define SRAI  0b101 // with alt flag
#define OP       0b0110011
    #define ADD   0b000
    #define SUB   0b000 // with alt flag
    #define SLL     0b001
    #define SLT     0b010
    #define SLTU    0b011
    #define XOR     0b100
    #define SRL     0b101
    #define SRA     0b101 // with alt flag
    #define OR      0b110
    #define AND     0b111
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
    #if EMULATE_CSR
    #define CSRRW  0b001
    #define CSRRS  0b010
    #define CSRRC  0b011
    #define CSRRWI 0b101
    #endif
    #define ECALL  0b000
    #define EBREAK 0b000

#define FENCE  0b0001111


