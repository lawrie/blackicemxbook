module camera(
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

assign vga_h_sync = href;
assign vga_v_sync = ~vsync;

assign led = {vga_h_sync, vga_v_sync};

wire clk;

localparam y_adjust = 32;
localparam y_adjust = 32;

SB_PLL40_CORE #(
  .FEEDBACK_PATH("SIMPLE"),
  .DIVR(0),         // DIVR =  1
  .DIVF(31),      // DIVF = 80
  .DIVQ(4),          // DIVQ =  5
  .FILTER_RANGE(2)   // FILTER_RANGE = 1
) uut (
  .RESETB(1'b1),
  .BYPASS(1'b0),
  .REFERENCECLK(clk25),
  .PLLOUTCORE(clk)
);

wire [3:0] vga_G = pixel_data[9:6];
wire [3:0] vga_R = pixel_data[15:12];
wire [3:0] vga_B = pixel_data[5:2];

wire [9:0] row, col;
wire pixel_valid;
wire [15:0] pixel_dat;
reg [15:0] pixel_data;

always @(posedge clk) if (pixel_valid) pixel_data <= pixel_dat;

camera_read cam (.clk(clk), .vsync(vsync), .href(href), .row(row), .col(col),
                 .p_clock(p_clock), .x_clock(x_clock),
                 .p_data(p_data), .frame_done(frame_done),
                 .pixel_valid(pixel_valid), .pixel_data(pixel_dat));

endmodule
