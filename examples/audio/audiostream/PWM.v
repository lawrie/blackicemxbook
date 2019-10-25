module PWM(input clk, input RxD, output PWM_out, output gain, output shutdown);

assign gain = 0;
assign shutdown = 1;

wire RxD_data_ready;
wire [7:0] RxD_data;
async_receiver deserializer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data)); 

reg [7:0] RxD_data_reg;
always @(posedge clk) if(RxD_data_ready) RxD_data_reg <= RxD_data;
////////////////////////////////////////////////////////////////////////////
reg [8:0] PWM_accumulator;
always @(posedge clk) PWM_accumulator <= PWM_accumulator[7:0] + RxD_data_reg;

assign PWM_out = PWM_accumulator[8];
endmodule
