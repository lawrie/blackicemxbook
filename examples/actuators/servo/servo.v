module servo(
  input clk,
  input [15:0] pulse_len,  // microseconds
  output reg control
);
	 
parameter CLK_F = 25; // CLK freq in MHz

reg [7:0] prescaler;
reg [14:0] count = 0;

always @(posedge clk) begin
  prescaler <= prescaler + 1;
  if (prescaler == CLK_F - 1) begin
    prescaler <= 0;
    count <= count + 1;
    control <= (count < pulse_len);
    
    if (count == 19999) count <= 0; // 20 milliseconds
  end
end

endmodule
