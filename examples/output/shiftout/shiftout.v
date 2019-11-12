module shiftout (
  input  clk_25MHz,
  output shiftout_clock,
  output reg shiftout_latch,
  output shiftout_data);

reg [7:0] shift_reg = 0;

assign shiftout_data = shift_reg[7];

reg [1:0] divider;
wire clk = divider[1];

always @(posedge clk_25MHz) divider <= divider + 1;

assign shiftout_clock = clk;

reg [20:0] delay_counter;

reg [2:0] bit_counter = 0;
reg [7:0] data_out = 0;

always @(negedge clk) begin
    // When delay counter is zero shift out the data
    if (delay_counter == 0) begin
      shift_reg <= shift_reg << 1;
      bit_counter <= bit_counter + 1;
      if (bit_counter == 7) begin
        // Show the value and restart the delay counter
        shiftout_latch <= 1;
        delay_counter <= 1;
        // Increment data out to show increasing numbers
        data_out <= data_out + 1;
      end
    end else begin
      delay_counter <= delay_counter + 1;
      // When delay counter is maxed out, prepare to shift out next value
      if (&delay_counter) begin
        shiftout_latch <= 0;
        shift_reg <= data_out;
      end
    end
end
endmodule
