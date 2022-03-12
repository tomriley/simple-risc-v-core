module registers(
  input clk,
  input w,
  input [3:0] addr, // 4 bit register number
  input [31:0] wdata, // write data
  output [31:0] rdata
);

reg[15:0] file[0:31];

always @ (posedge clk) begin
  if (w & sel)
    file[addr] <= wdata;
  //else
  //  file[addr] <= file[addr];
end

assign rdata = ~w ? file[addr] : 0;

endmodule