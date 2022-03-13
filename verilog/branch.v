`include "opcodes.v"

module branch(
  input clk,
  input[31:0] x,
  input[31:0] y,
  input[2:0] operator,
  output reg taken
);

always @ (posedge clk) begin
  case (operator)
    `BEQ: taken <= x == y;
    `BNE: taken <= x != y;
    `BLT: taken <= x < y;
    `BLTU: taken <= $unsigned(x) < $unsigned(y);
    `BGE: taken <= x >= y;
    `BGEU: taken <= $unsigned(x) >= $unsigned(y);
  endcase
end

endmodule
