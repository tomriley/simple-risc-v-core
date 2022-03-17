`include "opcodes.v"

module decoder(
  input clk,
  input[31:0] inst,
  output reg [6:0] opcode,
  output reg [31:0] imm,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [4:0] rd,
  output reg [2:0] funct3,
  output reg [6:0] funct7
);
  assign opcode = inst[6:0];
  assign funct3 = inst[14:12];
  assign rd = inst[11:7];
  assign rs1 = inst[19:15];
  assign rs2 = inst[24:20];
  assign funct7 = inst[31:25];

  wire[31:0] i_imm = { {20{inst[31]}}, inst[31:20] };
  wire[31:0] b_imm = { {19{inst[31]}}, inst[31], inst[7:7], inst[30:25], inst[11:8], 1'b0 };
  wire[31:0] j_imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
  wire[31:0] u_imm = { inst[31:12], {12{1'b0}} };
  wire[31:0] s_imm = { {20{inst[31]}}, inst[31:25], inst[11:7] };
  
  always @ (posedge clk) begin
    if (opcode == `LOAD || opcode == `OP || opcode == `OP_IM || opcode == `JALR || opcode == `SYSTEM)
      imm = i_imm;
    else if (opcode == `BRANCH)
      imm = b_imm;
    else if (opcode == `JAL)
      imm = j_imm;
    else if (opcode == `LUI || opcode == `AUIPC)
      imm = u_imm;
    else if (opcode == `STORE)
      imm = s_imm;
    
    //$display("decoded opcode: %b rd: %d rs1: %d rs2: %d funct3: %d j_imm: %b", opcode, rd, rs1, rs2, funct3, j_imm);
  end

endmodule