module debouncer(
    input clk,
    input button_input,
    output reg state,
    output trans_up,
    output trans_dn
    );

// Synchronize the button input to the clock
reg sync_0, sync_1;

always @(posedge clk) sync_0 = button_input;
always @(posedge clk) sync_1 = sync_0;

// Debounce the button
reg [14:0] count;
wire idle = (state == sync_1);
wire finished = &count;

always @(posedge clk) begin
  if (idle) count <= 0;
  else begin
    count <= count + 1;  
    if (finished) state <= ~state;
  end
end

assign trans_dn = ~idle & finished & ~state;
assign trans_up = ~idle & finished & state;

endmodule
