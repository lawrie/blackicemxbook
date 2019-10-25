module LCDmodule(clk, RxD, LCD_RS, LCD_E, LCD_DataBus);
input clk, RxD;
output LCD_RS, LCD_E;
output [7:0] LCD_DataBus;

wire RxD_data_ready;
wire [7:0] RxD_data;
async_receiver deserialer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));

assign LCD_DataBus = RxD_data;

wire Received_Escape = RxD_data_ready & (RxD_data==0);
wire Received_Data = RxD_data_ready & (RxD_data!=0);

reg [2:0] count;
always @(posedge clk) if(Received_Data | (count!=0)) count <= count + 1;

// activate LCD_E for 6 clocks, so at 25MHz, that's 6x40ns=240ns
reg LCD_E;
always @(posedge clk)
if(LCD_E==0)
  LCD_E <= Received_Data;
else
  LCD_E <= (count!=6);

reg LCD_instruction;
always @(posedge clk)
if(LCD_instruction==0)
  LCD_instruction <= Received_Escape;
else
  LCD_instruction <= (count!=7);

assign LCD_RS = ~LCD_instruction;

endmodule

