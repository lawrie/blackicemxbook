module led(
  input clk,
  input button1,
  output reg red_led
);

  always @(posedge clk) red_led <= button1;

endmodule

