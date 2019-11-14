`default_nettype 	none

module	thruwire(i_sw, o_led);
	input	wire i_sw;
	output	wire o_led;

	assign	o_led=i_sw;
endmodule
