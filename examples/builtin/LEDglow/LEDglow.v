module LEDglow(clk, LED);
	input clk;
	output LED;
	
	reg [27:0] cnt;
	always @(posedge clk) cnt<=cnt+1;
	
	wire [3:0] PWM_input = cnt[27] ? cnt[26:23] : ~cnt[26:23];
	reg [4:0] PWM;
	always @(posedge clk) PWM <= PWM[3:0]+PWM_input;
	
	assign LED = ~PWM[4];
endmodule

