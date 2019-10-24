module leds(
  input clk,
  output reg [7:0] leds
);

  reg [19:0] counter;
  
  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 0) leds <= leds + 1;
  end
 
endmodule

