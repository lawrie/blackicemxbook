module debounce(
	input clk,
	input button,
	output [2:0] leds
);

	reg PB_state, PB_down, PB_up;

	PushButton_Debouncer pdb (
		.clk(clk),.PB(button), .PB_state(PB_state),
		.PB_down(PB_down), .PB_up(PB_up)
	);
	
	reg [2:0] led_count;
	assign leds = ~led_count;

	always @(posedge clk) if (PB_down) led_count <= led_count + 1;

endmodule

