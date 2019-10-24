module led(
  input clk,
  output reg blue_led
);

  always @(posedge clk) blue_led = 0;

endmodule

