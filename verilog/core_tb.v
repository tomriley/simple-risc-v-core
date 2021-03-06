`include "core.v"

module core_tb;
  reg clk;
  reg rst = 0;

  core core(
    .clk(clk),
    .rst(rst)
  );

  initial begin
    clk = 1'b0;
    forever begin
      #10
      clk = ~clk;
    end
  end

  always @ (posedge clk) begin
    if (core.pstage == 2'b10) begin // after decode
      for (integer row = 0; row < 8; row++) begin
        $display("%d: %h %d: %h %d: %h %d: %h", row*4, core.regs[row*4], row*4+1, core.regs[row*4+1], row*4+2, core.regs[row*4+2], row*4+3, core.regs[row*4+3]);  
      end
      $display("PC: %h %h %b %b", core.pc, core.idata, core.idata, core.opcode);
    end
  end

  initial begin
    $dumpfile("core_tb_signals.vcd");
    $dumpvars(0, core_tb); // signals to dump

    rst = 1;
    #25 rst = 0;
    
    #200000; // sim time
    $display("Simulation time finished");
    $finish(); // now exit
  end
endmodule
