 module ps2_test (
             // Main clock, 100MHz
             input CLK,
             input PS2_CLK,
             input PS2_DATA,
             output UART_TX,
             output [3:0] LED);

   wire clk25 = CLK;

   wire  reset_n = &reset_counter;
   reg [9:0] reset_counter = 0;

   // reset_n will be held low for 1ms, then stay high
   always @(posedge clk25)
     begin
       if (!reset_n) 
         begin
           reset_counter = reset_counter + 1;
         end
     end

   // ===============================================================
   // PS/2 keyboard interface
   // ===============================================================

   wire [7:0]       keyb_data;
   wire             keyb_valid;
   wire             keyb_error;

   ps2_intf ps2
     (
      .CLK    (clk25),
      .nRESET (reset_n),
      .PS2_CLK  (PS2_CLK),
      .PS2_DATA (PS2_DATA),
      .DATA  (keyb_data),
      .VALID (keyb_valid),
      .error (keyb_error),
      .LED(LED)
      );

   assign LED = ~{keyb_valid, keyb_error, keyb_data[1:0]};

   wire [7:0] hex1, hex2; // Ascii hex chars to print

   // Convert ascii code tp hex
   byte_to_hex h1(keyb_data[3:0], hex1);
   byte_to_hex h2(keyb_data[7:4], hex2);

   // Send the key to the UART
   wire [15:0] text = {hex2, hex1};
   reg text_req, text_done;

   debug #(.text_len(2)) db (
     .clk(clk25), .reset(~reset_n), .text_req(text_req), .text_done(text_done),
     .debug_text(text), .UART_TX(UART_TX));

   always @(posedge clk25) begin
     if (text_done) text_req = 1'b0;
     if (keyb_valid) text_req = 1'b1;
   end


endmodule
