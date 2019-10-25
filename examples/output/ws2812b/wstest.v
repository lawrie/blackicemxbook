
`timescale 10ns/1ns

module wstest(clk,reset,DO);
   input clk;
   input reset;
   output DO;

   wire [2:0] address;
   wire [7:0]  red;
   wire [7:0]  green;
   wire [7:0]  blue;
   
   reg [31:0] count;

   always @(posedge clk) count <= count + 1;

   assign red = count[25:18];
   assign green = count[28:21]; 
   assign blue = count[31:24];
   
   ws2811
     #(
       .NUM_LEDS(8),
       .SYSTEM_CLOCK(25000000)
       ) driver
       (
        .clk(clk),
        .reset(~reset),
        
        .address(address),
        .red_in(red),
        .green_in(green),
        .blue_in(blue),
        
        .DO(DO)
      );
   
endmodule
