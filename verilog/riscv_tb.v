`include "riscv_core.v"

module riscv_tb;
  reg clk;
  reg[31:0] data;
  //reg[31:0] 
  //wire[31:0] dbus;

  riscv_core core(
      .clk(clk)
  );

  initial begin
    clk = 1'b0;
    forever begin
      #100 clk = ~clk;
    end
  end

  initial begin
    //a = 0;
    data = 32'h00208733;
    $dumpfile("riscv_tb_signals.vcd");
    $dumpvars(0, riscv_tb); // signals to dump
    #1000; // sim time
    $finish(); // now exit
  end
endmodule