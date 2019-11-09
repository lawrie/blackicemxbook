module baby(
  input clk25,
  input resetn,
  input button,
  output [1:0] led,
  output [7:0] led2,
  output reg panel_r0, panel_g0, panel_b0, panel_r1, panel_g1, panel_b1,
  output reg panel_a, panel_b, panel_c, panel_d, panel_clk, panel_stb, panel_oe);

reg [31:0] a, d;
reg [4:0] ci, addr;
reg [2:0] f;
reg [3:0] state;
reg we, re;

localparam SPEED = 18, COLOR = 'h00ff00, CI_COLOR = 'hff0000,
           R_COLOR = 'h0000ff, W_COLOR = 'hffff00;

reg [3:0] ctrl_wr = 0;
wire ctrl_rd;
reg [15:0] ctrl_addr;
reg [31:0] ctrl_wdat;
reg [31:0] ctrl_rdat;
reg ctrl_done;

reg [5:0] ci_line, r_line, w_line;

assign ctrl_rd = 0;

reg[21:0] speed_counter;
always @(posedge clk25) speed_counter <= speed_counter + 1;

task write_led_line;
  input [4:0] line_number;
  input [31:0] value;
  input [23:0] color;
begin
  led_line <= line_number;
  led_color <= color;
  led_value <= value;
  write_leds <= 1;
end
endtask

reg [4:0] led_counter;
reg [4:0] led_line;
reg [31:0] led_value;
reg [23:0] led_color;
reg write_leds, write_done;
reg new_write;

always @(posedge clk) begin
  write_done <= 0;
  new_write <= 0;
  if (write_leds) begin
    led_counter <= 0;
    new_write <= 1;
  end
  if (ctrl_done) begin
    ctrl_wr[2:0] <= 3'b000;
    if (&led_counter) write_done <= 1;
    else begin
      new_write <= 1;
      led_counter <= led_counter + 1;
    end
  end
  if (new_write) begin  
    ctrl_addr <= (((led_counter) << 5) + 31 - led_line) << 2;
    ctrl_wdat <= led_value[led_counter] ? led_color : 0;
    ctrl_wr[2:0] <= 3'b111;
  end
end
  
ledpanel #(.CLOCK_FREQ_HZ(25000000)) panel (.clk(clk25), .resetn(resetn),
           .ctrl_wr(ctrl_wr), .ctrl_rd(ctrl_rd), .ctrl_addr(ctrl_addr),
           .ctrl_wdat(ctrl_wdat), .ctrl_rdat(ctrl_rdat), .ctrl_done(ctrl_done),
           .panel_r0(panel_r0), .panel_g0(panel_g0), .panel_b0(panel_b0),
           .panel_r1(panel_r1), .panel_g1(panel_g1), .panel_b1(panel_b1),
           .panel_a(panel_a), .panel_b(panel_b), .panel_c(panel_c),
           .panel_d(panel_d), .panel_clk(panel_clk), .panel_stb(panel_stb),
           .panel_oe(panel_oe));

wire clk =  clk25; 

localparam STARTING0 = 12, WAITING  = 8, SCAN1 = 1, ACTION1 = 2, 
           SCAN2 = 3, SCAN3 = 4,  ACTION2 = 5, SCAN0 = 14, 
           ACTION3 = 6, STOPPED = 7, STARTING1 = 9, SCAN3a = 15,
           STARTING2 = 10, STARTING3 = 11, STARTING = 0, SCAN2a = 13;

line_ram ram (.clk(clk), .addr(addr), .din(a), 
              .we(we), .re(re), .dout(d));

reg [4:0] start_counter = 0;
reg [7:0] delay_counter;
reg [4:0] old_addr;
reg [0:31] old_d;
reg [7:0] r;

always @(posedge clk) begin
  delay_counter <= delay_counter + 1;
  write_leds <= 0;
  if (!resetn) begin state <= WAITING; ci <= 0; end
  case (state)
    STARTING: if (&delay_counter) state <= STARTING0; 
    STARTING0: begin; addr <= 0; re <= 1; state <= STARTING2; end
    STARTING1: begin
                  if (write_done) begin 
                     if (&start_counter) state <= WAITING;
                     else begin
                         start_counter <= start_counter + 1;
                         addr <= start_counter + 1;
                         re <= 1;
                         state <= STARTING2;
                     end
                  end
               end
    STARTING2: begin re <= 0; state <= STARTING3; end
    STARTING3: begin write_led_line(start_counter, d , COLOR); state <= STARTING1; end
    WAITING: if (~button) state = SCAN1; // Doesn't work after pressing reset
    SCAN0: if (&speed_counter) state <= SCAN1;
    SCAN1: begin re <= 1; ci <= ci + 1; addr <= ci + 1; state <= ACTION1; end
    ACTION1: begin; re <= 0; state <= SCAN2; end // delay for BRAM
    SCAN2: begin 
             write_led_line(ci, d, CI_COLOR);
             old_addr <= addr;
             old_d <= d;
             state <= SCAN2a;
           end
    SCAN2a:
             if (&speed_counter) state <= SCAN3;
    SCAN3: 
           begin
             if (state != STOPPED) write_led_line(old_addr, old_d, COLOR);
             addr <= d[31:27]; 
             f <= d[18:16]; 
             state <= SCAN3a;
             if (d[18:16]  == 3) begin we <= 1; end
             else if (d[18:16] < 6) begin re <= 1; end
           end
    SCAN3a: if (&speed_counter) state <= ACTION2;
    ACTION2: begin re <= 0; we <= 0; state <= ACTION3; end
    ACTION3:
      begin
        state <= SCAN0;
        if (f == 3) write_led_line(addr, a, W_COLOR);
	else if (f < 6) write_led_line(addr, d, R_COLOR);
        case (f)
          0: ci <= d;                               // JMP
          1: ci <= ci + d;                          // JRP
          2: a <= -d;                               // LDN
          4, 5: a <= a - d;                         // SUB
          6: if ($signed(a) < 0) ci <= ci + 1;      // CMP
          7: begin state <= STOPPED;                      // STOP
             write_led_line(ci, d, CI_COLOR);end
        endcase
      end
   endcase
end

assign led = {1'b0, state == STOPPED}; 
assign led2 = state;

endmodule

module line_ram(
  input clk,
  input [4:0] addr, 
  output reg [31:0] dout,
  input [31:0] din,
  input we,
  input re 
);

reg [31:0] ram [0:31]; 

initial $readmemh("lines.hex", ram); 

always @(posedge clk) begin 
  if (we) ram[addr] <= din;
  else if (re) dout <= ram[addr]; 
end 

endmodule
