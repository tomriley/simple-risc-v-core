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

  reg[31:0] rs1v;
  reg[31:0] rs2v;

  // intermediate state
  // flags
  reg write_pending;
  reg write_alu_result;
  reg alu_result_is_new_pc;
  // data
  reg[31:0] pending;
  reg[31:0] pc_was;
  reg[31:0] pending_pc;
  
  // alu inputs
  reg[31:0] lhs;
  reg[31:0] rhs;
  reg[2:0] oper;
  reg alt;
  
  // decode results
  wire[31:0] imm;
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire[6:0] funct7;
  wire[4:0] rd;
  
  // alu output
  wire[31:0] alu_result;

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
    .func(oper),
    .alt(alt),
    .result(alu_result)
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
    
    alt <= funct7 == 7'b0100000 && (
        opcode == `OP && funct3 == `SUB ||
        opcode == `OP && funct3 == `SRA ||
        opcode == `OP_IM && funct3 == `SRAI
    );
    
    rs1v <= regs[decoder.rs1];
    rs2v <= regs[decoder.rs2];

    // values that will be written back to regs
    pending_pc <= pc + 4;
    pending <= 32'hdeadbeef;
    pc_was <= pc;
    
    // flags
    write_pending <= // pending should be written back to rd
        opcode == `JAL ||
        opcode == `JALR;
    write_alu_result <= // result of apu should be written back to rd
        opcode == `LOAD ||
        opcode == `OP ||
        opcode == `OP_IM ||
        opcode == `LUI ||
        opcode == `AUIPC; 
    alu_result_is_new_pc <=
        opcode == `JAL ||
        opcode == `JALR;

    lhs <= rs1v;
    rhs <= opcode == `OP ? rs2v : imm;
    oper <= funct3;


    // for the following 3:
    //      rhs is always imm
    //      oper always ADD
    if (opcode == 'LUI) begin
      lhs <= 0;
      rhs <= imm;
      oper <= 'ADD;
    end
    
    if (opcode == `AUIPC) begin
        lhs <= pc_was;
        rhs <= imm;
        oper <= `ADD;
    end

    if (opcode == `JALR) begin
        pending <= pending_pc; // old target pc
        lhs <= rs1v;
        rhs <= imm;
        oper <= `ADD;
    end

    if (opcode == `JAL) begin
        pending <= pending_pc; // old target pc
        lhs <=  pc_was;
        rhs <= imm;
        oper <= `ADD;
    end

    // memory access stage TODO

    // SYSTEM opcodes TODO
    
    if (pstage == 5'b10000) begin
      // Update PC
      if (alu_result_is_new_pc)
          pc <= alu_result;
      else
          pc <= pending_pc;

      // Update target register
      if ((write_pending || write_alu_result) && rd != 0)
        if (write_alu_result)
          regs[rd] = alu_result;
        else
          regs[rd] = pending;
      
      pstage <= 5'b00001;
    end
  end
endmodule