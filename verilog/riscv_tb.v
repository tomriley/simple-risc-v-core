`include "core.v"

module riscv_tb;
  reg clk;
  reg reset = 0;

  core core(
    .clk(clk),
    .reset(reset)
  );

  initial begin
    clk = 1'b0;
    forever begin
      #10
      clk = ~clk;
    end
  end

  always @ (posedge clk) begin
    if (core.pstage == 2'b10) // after decode
      $display("%b %h  PC: %h  pstage: %b", core.idata, core.idata, core.pc, core.pstage);
    //for (integer row = 0; row < 8; row++) begin
    //  $display("x%d: %h x%d: %h x%d: %h x%d: %h", row*4, core.regs[row*4], row*4+1, core.regs[row*4+1], row*4+2, core.regs[row*4+2], row*4+3, core.regs[row*4+3]);  
    //end
  end

  initial begin
    $dumpfile("riscv_tb_signals.vcd");
    $dumpvars(0, riscv_tb); // signals to dump

    reset = 1;
    #25 reset = 0;
    
    #2000; // sim time
    $finish(); // now exit
  end
endmodule
