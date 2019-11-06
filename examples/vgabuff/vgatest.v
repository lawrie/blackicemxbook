module vgatest(
  input clk25, 
  output vga_h_sync, 
  output vga_v_sync, 
  output [3:0] vga_R, 
  output [3:0] vga_G, 
  output [3:0] vga_B, 
  output [7:0] led,
  input vsync,
  input href,
  input p_clock,
  output x_clock,
  input [7:0] p_data,
  output frame_done
);

wire inDisplayArea;
wire [9:0] CounterX;
wire [8:0] CounterY;
wire clk = clk25;

localparam x_adjust = 32;
localparam y_adjust = 32;

/*
SB_PLL40_CORE #(
  .FEEDBACK_PATH("SIMPLE"),
  .DIVR(4'b0001),         // DIVR =  1
  .DIVF(7'b1010000),      // DIVF = 80
  .DIVQ(3'b101),          // DIVQ =  5
  .FILTER_RANGE(3'b001)   // FILTER_RANGE = 1
) uut (
  .RESETB(1'b1),
  .BYPASS(1'b0),
  .REFERENCECLK(clk25),
  .PLLOUTCORE(clk)
);
*/

hvsync_generator syncgen(.clk(clk), .vga_h_sync(vga_h_sync), 
                         .vga_v_sync(vga_v_sync), 
                         .inDisplayArea(inDisplayArea), 
                         .CounterX(CounterX), 
                         .CounterY(CounterY));

wire [5:0] pixin;
wire [3:0] G = {pixin[5:4], 2'b0};
wire [3:0] R = {pixin[3:2], 2'b0};
wire [3:0] B = {pixin[1:0], 2'b0};

wire [5:0] pixout;
wire [7:0] xout;
wire [6:0] yout;

reg we;

assign vga_R = inDisplayArea?R:0;
assign vga_G = inDisplayArea?G:0;
assign vga_B = inDisplayArea?B:0;

wire [7:0] xin = (inDisplayArea ? (CounterX[9:2]) : 0);
wire [6:0] yin = (inDisplayArea ? (CounterY[8:2]) : 0);

wire [14:0] raddr = (yin << 7) + (yin << 5) + xin;
wire [14:0] waddr = (yout << 7) + (yout << 5) + xout;

assign led = {vga_h_sync, vga_v_sync};

vgabuff vgab (.clk(clk), .raddr(raddr), .pixin(pixin),
        .we(we), .waddr(waddr), .pixout(pixout));

wire [15:0] pixel_data;
wire [9:0] row, col;

assign yout = row[8:2] - y_adjust;
assign xout = col[9:2] + x_adjust;
assign pixout = {pixel_data[13:12],pixel_data[9:8], pixel_data[3:2]};

camera_read cam (.clk(clk), .vsync(vsync), .href(href), .row(row), .col(col),
                 .p_clock(p_clock), .x_clock(x_clock),
                 .p_data(p_data), .frame_done(frame_done),
                 .pixel_valid(we), .pixel_data(pixel_data));

endmodule
