
module memory(
  input clk,
  input rw,
  input sign_ext,
  input [2:0] width, // width in bytes
  input [31:0] addr,
  input [31:0] wdata,
  output reg [31:0] rdata
);
  reg[31:0] mem[0:(65536>>2)-1];
  wire[31:0] data;
  assign data = mem[addr[30:2]]; // continuous assignment to word
  
  initial begin
    string fname;
    if ($value$plusargs("MEM=%s", fname)) begin
      $display("Loading memory dump %s...", fname);
      $readmemh(fname, mem);
    end
  end

  always @ (posedge clk) begin
    //$display("width %b... data is %b", width, data);
    // just reads for now
    case (width)
      4: begin
        rdata <= data; // load word
      end
      2: begin
        rdata <= addr[1:0];// ? 0 : 16 mem[addr[30:2]] >> addr[1:0] ? 0 : 16; // load word
      end
      1: begin
        ;
      end
    endcase
  end
endmodule