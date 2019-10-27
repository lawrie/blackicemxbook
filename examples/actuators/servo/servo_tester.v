module servo_tester(
    input clk,
    input button_up,
    input button_dn,
    output control
    );

parameter INC = 100;

wire b_up, b_dn;

debouncer d1(.clk (clk), .button_input (~button_up), .trans_up (b_up));
debouncer d2(.clk (clk), .button_input (~button_dn), .trans_up (b_dn));

reg [15:0] pulse_len = 500; // microseconds

servo #(25) servo1 (.clk(clk), .pulse_len (pulse_len), .control (control));

always @(posedge clk) begin
  if (b_up) pulse_len <= pulse_len + INC;
  if (b_dn) pulse_len <= pulse_len - INC;
end

endmodule
