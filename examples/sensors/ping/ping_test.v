module ping_test (
  input clk,
  input echo,
  output trig,
  output [7:0] seg,
  output [2:0] ca,
  output [3:0] led);

reg [22:0] counter = 1;
reg req = 0, done;
reg [3:0] cm_units;
reg [3:0] cm_tens;
reg [3:0] cm_hundreds;

ping p1 (.clk(clk), .led(led), .echo(echo), .trig(trig), .req(req), 
         .cm_digits(cm_units), .cm_tens(cm_tens), .cm_hundreds(cm_hundreds),
         .done(done));

always @(posedge clk) begin
  if (done) req <= 0;
  if (counter == 0) req <= 1;
  counter <= counter + 1;
end

 wire [11:0] val = 'h123;
 wire [3:0] dig = (ca == 'b011 ? cm_hundreds : 
	           ca == 'b101 ? cm_tens : cm_units);
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
