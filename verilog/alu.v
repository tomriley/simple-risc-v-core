
module alu(
  input clk,
  input signed [31:0] lhs,
  input signed [31:0] rhs,
  input[2:0] func,
  input alt,
  output reg[31:0] result
);
  always @ (/*lhs or rhs or func or alt*/ posedge clk) begin
    case (func)
      `ADD: result <= alt ? lhs - rhs : lhs + rhs; // need to deal with subtracting alt case
      `SLL: result <= $unsigned(lhs) << (rhs & 5'b11111);
      `SLT: result <= (lhs < rhs ? 1 : 0); // signed
      `SLTU: result <= $unsigned(lhs) < $unsigned(rhs) ? 1 : 0;
      `XOR: result <= lhs ^ rhs;
      `SRL: begin
        if (alt)
          result <= lhs >>> (rhs & 5'b11111); // arithmetic (signed) shift
        else
          result <= lhs >> (rhs & 5'b11111);
      end
      `OR: result <= lhs | rhs;
      `AND: result <= lhs & rhs;
    endcase
  end

endmodule