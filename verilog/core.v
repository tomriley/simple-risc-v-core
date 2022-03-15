`include "decoder.v"
`include "alu.v"
`include "branch.v"
`include "memory.v"

module core(
  input clk,
  input rst
);
  // CPU state
  reg[31:0] pc;
  reg[31:0] regs[31];

  // prefetched register values
  reg[31:0] rs1v;
  reg[31:0] rs2v;

  // execution/control state
  // flags
  reg write_pending;
  reg write_alu_result;
  reg alu_result_is_new_pc;
  // data
  reg[31:0] pending;
  reg[31:0] pc_was;
  reg[31:0] pending_pc;
  
  // current instruction data
  reg[31:0] idata;

  // memory
  reg[2:0] width;
  wire[31:0] rdata;
  
  // decoder output
  wire[31:0] imm;
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire[6:0] funct7;
  wire[4:0] rd;

  // ALU input data
  reg[31:0] lhs;
  reg[31:0] rhs;
  reg[2:0] oper;
  reg alt;
  
  // ALU output
  wire[31:0] alu_result;

  // branch output
  wire branch_result;

  // pipeline stage
  reg[4:0] pstage;

  memory m(
    .clk(clk),
    .width(width),
    .addr(imm + rs1v),
    .rdata(rdata)
  );

  decoder decoder(
    .clk(clk),
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

  branch branch(
    .clk(clk),
    .x(rs1v),
    .y(rs2v),
    .operator(funct3),
    .taken(branch_result)
  );
 
  always @ (posedge clk) begin
    
    if (rst) begin
      $display("rst pin is high");
      pc <= 32'h80000000;
      regs[0] <= 0;
      pstage <= 1;
    end else begin
      pstage <= pstage << 1;
    end
    
    idata <= m.mem[pc[30:2]]; // subtracting base addr and divide by 4
    
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
        opcode == `LOAD ||
        opcode == `JAL ||
        opcode == `JALR;
    write_alu_result <= // result of apu should be written back to rd
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
    if (opcode == `LUI) begin
      lhs <= 0;
      rhs <= imm;
      oper <= `ADD;
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

    case (opcode)
      `LOAD: begin
        case (funct3)
          `LW: begin
            width <= 4;
          end
        endcase
      end

      `FENCE: ;
      `BRANCH: begin
        if (branch_result) 
          pending_pc = pc_was + imm;
      end
      
      `SYSTEM: begin
        case (funct3)
          `ECALL: begin
            case (imm)
              1'b1: begin
                $display("panic: EBREAK");
                $stop();
              end
              1'b0: begin
                $display("ECALL finishing");
                if (regs[10]) begin
                  $display("  Test %d failed", regs[10] >> 1);
                  $stop();
                end else begin
                  $display("Success!");
                  $finish();
                end
              end
              //default: $display("unexpected ECALL/EBREAK immediate %b", imm);
            endcase
          end
        endcase
      end
    endcase
  
    if (pstage == 5'b01000) begin
      if (opcode == `LOAD) begin
        $display("rdata is %h", rdata);
        pending <= rdata;
      end
    end

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