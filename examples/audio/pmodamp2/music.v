module music(clk, speaker, gain, shutdown);
input clk;
output speaker, gain, shutdown;
parameter clkdivider = 25000000/440/2;

assign shutdown = 1;
assign gain = 0;

reg [16:0] counter;
always @(posedge clk) if(counter==0) counter <= clkdivider-1; else counter <= counter-1;

reg speaker;
always @(posedge clk) if(counter==0) speaker <= ~speaker;
endmodule
