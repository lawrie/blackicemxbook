module vgabuff(
  input clk,
  input [14:0] raddr,
  input [14:0] waddr,
  input we,
  input [5:0] pixout,
  output reg  [5:0] pixin
);

  reg [5:0] mem [0:19199];

  always @(posedge clk) begin 
    if (we) begin
      mem[waddr] <= pixout;
    end
    pixin <= mem[raddr];
  end

endmodule

