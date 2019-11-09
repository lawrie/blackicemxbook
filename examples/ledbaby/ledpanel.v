// Description of the LED panel:
// http://bikerglen.com/projects/lighting/led-panel-1up/#The_LED_Panel
//
// panel_[abcd] ... select rows (in pairs from top and bottom half)
// panel_oe ....... display the selected rows (active low)
// panel_clk ...... serial clock for color data
// panel_stb ...... latch shifted data (active high)
// panel_[rgb]0 ... color channel for top half
// panel_[rgb]1 ... color channel for bottom half
//
// Example config with Trenz Adapter on PMOD1 and PMOD2:
//
// mod ledpanel panel
//   address 1
//   connect panel_r0  pmod1_1
//   connect panel_b0  pmod1_2
//   connect panel_g1  pmod1_3
//   connect panel_a   pmod1_4
//   connect panel_g0  pmod1_7
//   connect panel_r1  pmod1_8
//   connect panel_b1  pmod1_9
//   connect panel_b   pmod1_10
//   connect panel_c   pmod2_1
//   connect panel_clk pmod2_2
//   connect panel_oe  pmod2_3
//   connect panel_d   pmod2_7
//   connect panel_stb pmod2_8

module ledpanel (
	input clk,
	input resetn,

	input [3:0] ctrl_wr,
	input ctrl_rd,
	input [15:0] ctrl_addr,
	input [31:0] ctrl_wdat,
	output reg [31:0] ctrl_rdat,
	output reg ctrl_done,

	output reg panel_r0, panel_g0, panel_b0, panel_r1, panel_g1, panel_b1,
	output reg panel_a, panel_b, panel_c, panel_d, panel_clk, panel_stb, panel_oe
);
	parameter integer BITS_PER_CHANNEL = 4;
	parameter integer CLOCK_FREQ_HZ = 6000000;
	parameter integer SIZE = 1;
	parameter integer EXTRA_BLANKING = 0;

	localparam integer SIZE_BITS = $clog2(SIZE);

	reg [BITS_PER_CHANNEL-1:0] video_mem_r [0:SIZE*1024-1];
	reg [BITS_PER_CHANNEL-1:0] video_mem_g [0:SIZE*1024-1];
	reg [BITS_PER_CHANNEL-1:0] video_mem_b [0:SIZE*1024-1];

`ifdef TESTBENCH
	initial begin:video_mem_init
		integer i;
		for (i = 0; i < SIZE*1024; i = i+1) begin
			video_mem_r[i] = 15;
			video_mem_g[i] = ((i >> 5) % 32 == 0) ? 5 : 4;
			video_mem_b[i] = ((i >> 5) % 32 == 31) ? 3 : 2;
		end
	end
`endif

	always @(posedge clk) begin
		ctrl_done <= (|ctrl_wr || ctrl_rd) && !ctrl_done;
		ctrl_rdat <= 'bx;

		if (ctrl_done && ctrl_wr[2]) video_mem_r[ctrl_addr >> 2] <= ctrl_wdat[23:16] >> (8-BITS_PER_CHANNEL);
		if (ctrl_done && ctrl_wr[1]) video_mem_g[ctrl_addr >> 2] <= ctrl_wdat[15: 8] >> (8-BITS_PER_CHANNEL);
		if (ctrl_done && ctrl_wr[0]) video_mem_b[ctrl_addr >> 2] <= ctrl_wdat[ 7: 0] >> (8-BITS_PER_CHANNEL);
	end

	reg [8+SIZE_BITS:0] cnt_x = 0;
	reg [3:0] cnt_y = 0;
	reg [1:0] cnt_z = 0;
	reg state = 0;

	reg [4+SIZE_BITS:0] addr_x;
	reg [4:0] addr_y;
	reg [2:0] addr_z;
	reg [2:0] data_rgb;
	reg [2:0] data_rgb_q;
	reg [8+SIZE_BITS:0] max_cnt_x;

	always @(posedge clk) begin
		case (cnt_z)
			0: max_cnt_x <= 32*SIZE+8;
			1: max_cnt_x <= 64*SIZE;
			2: max_cnt_x <= 128*SIZE;
			3: max_cnt_x <= 256*SIZE;
		endcase
	end

	always @(posedge clk) begin
		state <= !state;
		if (!state) begin
			if (cnt_x > max_cnt_x) begin
				cnt_x <= 0;
				cnt_z <= cnt_z + 1;
				if (cnt_z == BITS_PER_CHANNEL-1) begin
					cnt_y <= cnt_y + 1;
					cnt_z <= 0;
				end
			end else begin
				cnt_x <= cnt_x + 1;
			end
		end
	end

	always @(posedge clk) begin
		panel_oe <= 32*SIZE-8-EXTRA_BLANKING < cnt_x && cnt_x < 32*SIZE+8;
		if (state) begin
			panel_clk <= 1 < cnt_x && cnt_x < 32*SIZE+2;
			panel_stb <= cnt_x == 32*SIZE+2;
		end else begin
			panel_clk <= 0;
			panel_stb <= 0;
		end
	end

	always @(posedge clk) begin
		addr_x <= cnt_x;
		addr_y <= cnt_y + 16*(!state);
		addr_z <= cnt_z;
	end

	always @(posedge clk) begin
		data_rgb[2] <= video_mem_r[{addr_x, addr_y}][addr_z];
		data_rgb[1] <= video_mem_g[{addr_x, addr_y}][addr_z];
		data_rgb[0] <= video_mem_b[{addr_x, addr_y}][addr_z];
	end

	always @(posedge clk) begin
		data_rgb_q <= data_rgb;
		if (!state) begin
			if (0 < cnt_x && cnt_x < 32*SIZE+1) begin
				{panel_r1, panel_r0} <= {data_rgb[2], data_rgb_q[2]};
				{panel_g1, panel_g0} <= {data_rgb[1], data_rgb_q[1]};
				{panel_b1, panel_b0} <= {data_rgb[0], data_rgb_q[0]};
			end else begin
				{panel_r1, panel_r0} <= 0;
				{panel_g1, panel_g0} <= 0;
				{panel_b1, panel_b0} <= 0;
			end
		end else
		if (cnt_x == 32*SIZE - EXTRA_BLANKING/2) begin
			{panel_d, panel_c, panel_b, panel_a} <= cnt_y;
		end
	end
endmodule

