`include "opcodes.v"

module branch(
  input clk,
  input signed[31:0] x,
  input signed[31:0] y,
  input[2:0] operator,
  output reg taken
);

always @ (x, y, operator) begin
  case (operator)
    `BEQ: taken = x === y;
    `BNE: taken = x !== y;
    `BLT: taken = x < y;
    `BLTU: taken = $unsigned(x) < $unsigned(y);
    `BGE: taken = x >= y;
    `BGEU: taken = $unsigned(x) >= $unsigned(y);
  endcase
  // $display("branch: %d %b %d = %b", x, operator, y, taken);
end

endmodule
