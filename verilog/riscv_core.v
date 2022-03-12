`define CONSTANT_MACRO 1
`define LUI     1'b0110111
`define AUIPC   1'b0010111
`define OP_IM   1'b0010011
    `define ADDI  1'b000
    `define SLTI  1'b010
    `define SLTIU 1'b011
    `define XORI  1'b100
    `define ORI   1'b110
    `define ANDI  1'b111
    `define SLLI  1'b001
    `define SRLI_SRAI  1'b101
`define OP       1'b0110011
    `define ADD_SUB 1'b000
    `define SLL     1'b001
    `define SLT     1'b010
    `define SLTU    1'b011
    `define XOR     1'b100
    `define SRL_SRA 1'b101
    `define OR      1'b110
    `define AND     1'b111
`define JAL    1'b1101111
`define JALR   1'b1100111
`define LOAD   1'b0000011
    `define LB  1'b000
    `define LH  1'b001
    `define LW  1'b010
    `define LBU 1'b100
    `define LHU 1'b101
`define STORE  1'b0100011
    `define SB  1'b000
    `define SH  1'b001
    `define SW  1'b010
`define STORE  1'b0100011
`define SYSTEM 1'b1110011
    `define CSRRW  1'b001
    `define CSRRS  1'b010
    `define CSRRC  1'b011
    `define CSRRWI 1'b101
    `define ECALL  1'b000
    `define EBREAK 1'b000
`define BRANCH 1'b1100011
    `define BEQ  1'b000
    `define BNE  1'b001
    `define BLT  1'b100
    `define BGE  1'b101
    `define BLTU 1'b110
    `define BGEU 1'b111
`define FENCE  1'b0001111


module decoder(
  input clk,
  input[31:0] inst,  // 32 bit instruction
  output[6:0] opcode,
  output[31:0] imm,  // immediate
  output[31:0] simm, // sign extended immediate
  output[4:0] rs1,
  output[4:0] rs2,
  output[4:0] rd,
  output[2:0] funct3,
  output[6:0] funct7
);

reg[6:0] opcode;
reg[31:0] i_imm;
reg signed[31:0] i_simm;
reg[4:0] rs1;
reg[4:0] rs2;
reg[4:0] rd;
reg[2:0] funct3;
reg[6:0] funct7;

always @ (posedge clk) begin
  /*reg[7:0] opcode, funct3, funct7, rd, rs1, rs2;
  reg[31:0] i_imm, b_imm, j_imm, s_imm, u_imm;
  reg signed[31:0] i_simm;
  reg signed[31:0] rs1_was, rs2_was;
  reg[31:0] pc_was;
  reg[31:0] new_pc;*/

  opcode <= inst[6:0];
  funct3 <= inst[14:12];
  rd <= inst[11:7];
  rs1 <= inst[19:15];
  rs2 <= inst[24:20];
  
  // immediates
  i_imm = inst[31:20];
  i_simm = sign_extend(i_imm, 12);
  funct7 = inst[31:25];
  b_imm = inst[11:8] << 1 | inst[30:25] << 5 | inst[7:7] << 11 | inst[31:31] << 12;
  //b_simm = sign_extend(b_imm, 13);
  j_imm = inst[30:21] << 1 | inst[20:20] << 11 | inst[19:12] << 19 | inst[31:31] << 20;
  //j_simm = sign_extend(j_imm, 21);
  u_imm = inst[31:12];
  s_imm = inst[11:7] | inst[31:25] << 5;
  //s_simm = sign_extend(s_imm, 12);
  
  // preload register values
  rs1_was = regs[rs1];
  rs2_was = regs[rs2];
  pc_was = pc;

  // values that will be written back to regs
  new_pc = pc + 4;
  //rd_val = 0xdeadbeef;*/

  $display("decoded opcode: %b rd: %d rs1: %d rs2: %d funct3: %d\n", opcode, rd, rs1, rs2, funct3);
end

endmodule


module riscv_core(
  input clk
);
  reg[31:0] pc;
  reg[31:0] regs[0:31];
  reg[31:0] inst;

  // FIXME almost certainly shouldn't use shifts do sign extension in hardware.
  // Should simple OR the state into the upper 32-width upper bits.
  function [31:0] sign_extend;
    input [31:0] value;
    input [7:0] width;
    begin
      sign_extend = $signed(value << (32 - width)) >>> (32 - width);
    end
  endfunction
 
  always @ (posedge clk) begin : decode
    reg[7:0] opcode, funct3, funct7, rd, rs1, rs2;
    reg[31:0] i_imm, b_imm, j_imm, s_imm, u_imm;
    reg signed[31:0] i_simm;
    reg signed[31:0] rs1_was, rs2_was;
    reg[31:0] pc_was;
    reg[31:0] new_pc;
    // fetch

    // decode
    opcode = inst[6:0];
    funct3 = inst[14:12];
    rd = inst[11:7];
    rs1  = inst[19:15];
    rs2  = inst[24:20];
    
    // immediates
    i_imm = inst[31:20];
    i_simm = sign_extend(i_imm, 12);
    funct7 = inst[31:25];
    b_imm = inst[11:8] << 1 | inst[30:25] << 5 | inst[7:7] << 11 | inst[31:31] << 12;
    //b_simm = sign_extend(b_imm, 13);
    j_imm = inst[30:21] << 1 | inst[20:20] << 11 | inst[19:12] << 19 | inst[31:31] << 20;
    //j_simm = sign_extend(j_imm, 21);
    u_imm = inst[31:12];
    s_imm = inst[11:7] | inst[31:25] << 5;
    //s_simm = sign_extend(s_imm, 12);
    
    // preload register values
    rs1_was = regs[rs1];
    rs2_was = regs[rs2];
    pc_was = pc;

    // values that will be written back to regs
    new_pc = pc + 4;
    //rd_val = 0xdeadbeef;

    $display("decoded opcode: %b rd: %d rs1: %d rs2: %d funct3: %d\n", opcode, rd, rs1, rs2, funct3);
    
    // execute


    // write back
  end
endmodule