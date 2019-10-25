module keypad_test(
  input clk,
  input [3:0] row,
  inout [2:0] col,
  output [3:0] led
);
  
  wire [2:0] col_in;
  reg [2:0] col_out, col_dir;
  reg [3:0] key;

  assign led = key;

  SB_IO #(
    .PIN_TYPE(6'b 1010_01),
    .PULLUP(1'b 0)
  ) col_io [2:0] (
      .PACKAGE_PIN(col),
      .OUTPUT_ENABLE(col_dir),
      .D_OUT_0(col_out),
      .D_IN_0(col_in)
  );

  wire [3:0] row_in;

  SB_IO #(
    .PIN_TYPE(6'b 0000_01),
    .PULLUP(1'b 1)
  ) row_in [3:0] (
    .PACKAGE_PIN(row),
    .D_IN_0(row_in)
  );

  reg [20:0] count; // Number of bits determines scan frequency

  initial begin
    col_dir[0] <= 0;
    col_dir[1] <= 0;
    col_dir[2] <= 0;
    col_out[0] <= 0;
    col_out[1] <= 0;
    col_out[2] <= 0;
  end

  always @(posedge clk) begin
    count <= count + 1;

    if (count == 0) begin
      col_dir[0] <= 1; // Give column 0 a pulse
    end else if (count == 3) begin // Leave two clock cycles to stabilise
      if (~row_in[0]) key <= 1;
      else if (~row_in[1]) key <= 4;
      else if (~row_in[2]) key <= 7;
      else if (~row_in[3]) key <= 'ha; // *
      col_dir[0] <= 0;
      col_dir[1] <= 1;
    end else if (count == 500) begin // Wait of more than 200 seems necessary
      if (~row_in[0]) key <= 2;
      else if (~row_in[1]) key <= 5;
      else if (~row_in[2]) key <= 8;
      else if (~row_in[3]) key <= 0;
      col_dir[1] <= 0;
      col_dir[2] <= 1;
    end else if (count == 1000) begin
      if (~row_in[0]) key <= 3;
      else if (~row_in[1]) key <= 6;
      else if (~row_in[2]) key <= 9;
      else if (~row_in[3]) key <= 'hb; // #
      col_dir[2] <= 0;
    end
  end        
endmodule
