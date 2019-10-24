module chip(
  input clk,
  output [2:0] ca,
  output [7:0] seg,
  input  [3:0] d
);

 wire [11:0] val = 'h123;
 wire [3:0] dig = (ca == 'b011 ? d : ca == 'b101 ? val[7:4] : val[3:0]);
 assign seg[7] = 1;

 h27seg hex (
   .hex(dig),
   .s7(seg[6:0])
 );

 seven_seg_display seg7 (
   .clk(clk),
   .ca(ca)
 );

endmodule

