module display_7_seg(
    input CLK,
    input [3:0] units, tens,
    output [6:0] SEG,
    output reg DIGIT
    );
	 
reg [3:0] digit_data;
reg digit_posn;
reg [23:0] prescaler;
	 
decoder_7_seg decoder(.CLK (CLK), .SEG	(SEG), .D (digit_data));   
   
always @(posedge CLK)
begin
  prescaler <= prescaler + 24'd1;
  if (prescaler == 24'd50000) // 1 kHz
  begin
    prescaler <= 0;
    digit_posn <= digit_posn + 2'd1;
    if (digit_posn == 0)
    begin
      digit_data <= units;
      DIGIT <= 4'b0;
    end
    if (digit_posn == 2'd1)
    begin
      digit_data <= tens;
      DIGIT <= 4'b1;
    end
  end
end

endmodule
