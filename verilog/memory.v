
module memory(
  input clk,
  input rw,
  input [2:0] func, // width in bytes
  input [31:0] addr,
  input [31:0] wdata,
  output reg [31:0] rdata
);
  // memory of 32 bit words
  reg[31:0] mem[0:32'h00400000>>2];
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
    // just reads for now
    if (rw) begin
      // STORE
      case (func[1:0])
        2'b10: begin // word
          mem[addr[30:2]] <= wdata;
        end
        2'b01: begin // half
          $display("STORING HALF func: %b mem[%b] = %b", func, addr, wdata);
          case (addr[1])
            1'b0: mem[addr[30:2]][15:0] <= wdata[15:0];
            1'b1: mem[addr[30:2]][31:16] <= wdata[15:0];
          endcase
        end
        2'b00: begin // byte
          case (addr[1:0])
            2'b00: mem[addr[30:2]][7:0] <= wdata[7:0];
            2'b01: mem[addr[30:2]][15:8] <= wdata[7:0];
            2'b10: mem[addr[30:2]][23:16] <= wdata[7:0];
            2'b11: mem[addr[30:2]][31:24] <= wdata[7:0];
          endcase
        end
      endcase
    end else begin
      // LOAD
      case (func[1:0])
        2'b10: begin // word
          rdata <= data;
        end
        2'b01: begin // half
          case (addr[1])
            1'b0: rdata <= {{16{func[2] ? 1'b0 : data[15]}}, data[15:0]};
            1'b1: rdata <= {{16{func[2] ? 1'b0 : data[31]}}, data[31:16]};
          endcase
        end
        3'b00: begin // byte
          case (addr[1:0])
            2'b00: rdata <= {{24{func[2] ? 1'b0 : data[7]}}, data[7:0]};
            2'b01: rdata <= {{24{func[2] ? 1'b0 : data[15]}}, data[15:8]};
            2'b10: rdata <= {{24{func[2] ? 1'b0 : data[23]}}, data[23:16]};
            2'b11: rdata <= {{24{func[2] ? 1'b0 : data[31]}}, data[31:24]};
          endcase
        end
      endcase
    end
  end
endmodule