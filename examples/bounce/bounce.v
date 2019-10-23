module bounce(
  input button,
  output [2:0] leds
);

  reg [2:0] led_counter;
  assign leds = ~led_counter;
	  
  always @(negedge button) led_counter <= led_counter + 1;

endmodule

