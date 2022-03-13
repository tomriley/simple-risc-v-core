`include "decoder.v"
`include "alu.v"

module core(
  input clk,
  input reset,
  
  output reg [31:0] raddr, // read addr bus
  output reg rsel, // raise to say we want to read addr
  input din, // data is ready
  input[31:0] rdata // test idataruction at the moment
);
  reg[31:0] pc;
  reg[31:0] regs[0:31];
  reg[31:0] idata;
  reg[7:0] mem[65536];

  // 
  //reg[31:0] pc_was;
  reg[31:0] rs1_was;
  reg[31:0] rs2_was;

  // intermediate state
  reg write_rd;
  reg jump_to_result; // jump to ALU result
  reg[31:0] rd_val;
  reg[31:0] pending_pc;
  
  // alu inputs
  reg[31:0] lhs;
  reg[31:0] rhs;
  reg[2:0] func;
  reg alt;
  
  // decode results
  wire[31:0] imm;
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire[6:0] funct7;
  wire[4:0] rd;
  wire[31:0] result;

  // pipeline stage
  reg[4:0] pstage;

  decoder decoder(
    //.clk(clk),
    .inst(idata),
    .imm(imm),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .rd(rd)
  );

  alu alu(
    .clk(clk),
    .lhs(lhs),
    .rhs(rhs),
    .func(func),
    .alt(alt),
    .result(result)
  );

  initial begin
    $display("Loading rom...");
    $readmemh("rom_image.mem", mem);
  end
 
  always @ (posedge clk) begin
    
    if (reset) begin
      $display(" RESET");
      pc <= 0;
      regs[0] <= 0;
      pstage <= 1;
    end else begin
      // else advance stages
      pstage <= pstage << 1;
    end
    
    idata <= {mem[pc+3], mem[pc+2], mem[pc+1], mem[pc]};
    pending_pc <= pc + 4;
    
    alt <= 0; // alt arith flag  TODO
      
    rs1_was <= regs[decoder.rs1];
    rs2_was <= regs[decoder.rs2];

    write_rd <=
      opcode == `JAL ||
      opcode == `JALR ||
      opcode == `LOAD ||
      opcode == `OP ||
      opcode == `OP_IM ||
      opcode == `LUI ||
      opcode == `AUIPC;

    case (opcode)
      `LUI: begin
        rd_val <= imm;
      end
      `AUIPC: begin
        lhs <= pc;
        rhs <= imm;
        func <= `ADD;
        rd_val <= result;
      end
      `JAL: begin
        rd_val <= pending_pc;
        lhs <= pc;
        rhs <= imm;
        func <= `ADD;
        jump_to_result <= 1;
      end
      `JALR: begin
        rd_val <= pending_pc;
        lhs <= rs1_was;
        rhs <= imm;
        func <= `ADD;
        rd_val <= result;
      end
      `OP: begin
        lhs <= rs1_was;
        rhs <= rs2_was;
        func <= decoder.funct3;
        rd_val <= result;
      end
      `OP_IM: begin
        lhs <= rs1_was;
        rhs <= imm;
        rd_val <= result;
      end
    endcase
    
    if (pstage == 5'b10000) begin
      $display("WRITEBACK STAGE");

      $display("AUT result=%d", result);

      // update target reg
      if (write_rd && rd != 0) begin
        $display("writing %h into register %rd", rd_val, rd);
        regs[rd] <= rd_val;
      end
      
      // update PC
      if (jump_to_result) begin
        $display("writing result %h to PC", result);
        pc <= result;
      end else begin
        $display("writing pending_pc %h to PC", pending_pc);
        pc <= pending_pc;
      end
      
      pstage <= 5'b00001;
    end
  end
endmodule