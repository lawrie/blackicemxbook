module quad_test (
  input clk,
  input quadA,
  input quadB,
  output [7:0] seg,
  output [2:0] ca
);

  reg [11:0] pos;
  reg [2:0] quadAr, quadBr;
  always @(posedge clk) quadAr <= {quadAr[1:0], quadA};
  always @(posedge clk) quadBr <= {quadBr[1:0], quadB};

  always @(posedge clk)
    if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
      begin
        if(quadAr[2] ^ quadBr[1])
        begin
          if (~&pos) // make sure the value doesn't overflow
            pos <= pos + 1;
        end
        else
        begin
          if (|pos)  // make sure the value doesn't underflow
            pos <= pos - 1;
        end
  end

 wire [3:0] dig = (ca == 'b011 ? pos[11:8] : 
	           ca == 'b101 ? pos[7:4] : pos[3:0]);
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
