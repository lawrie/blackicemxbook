module baby(
	input clk25,
	input button,
	output [2:0] led,
	output [7:0] led2
);

	reg [31:0] a, d;
	reg [4:0] ci, addr;
	reg [2:0] f;
	reg [2:0] state = WAITING;
	reg we, re;

	reg [1:0] counter;
	always @(posedge clk25) counter <= counter + 1;

	wire clk =  clk25;

	localparam WAITING = 0, SCAN1 = 1, ACTION1 = 2, 
		SCAN2 = 3, SCAN3 = 4,  ACTION2 = 5, 
		ACTION3 = 6, STOPPED = 7;

	line_ram ram (.clk(clk), .addr(addr), .din(a), 
		.we(we), .re(re), .dout(d));

	always @(posedge clk)
	  begin
		case (state)
			WAITING: if (~button) state = SCAN1; // Doesn't work after pressing reset
			SCAN1: begin re <= 1; ci <= ci + 1; addr <= ci + 1; state <= ACTION1; end
			ACTION1: begin; re <= 0; state <= SCAN2; end // delay for BRAM
			SCAN2:
			  begin 
				addr <= d[31:27]; 
				f <= d[18:16]; 
				state <= ACTION2;
				if (d[18:16]  == 3) we <= 1; 
				else if (d[18:16] < 6) re <= 1;
			  end
			ACTION2: begin re <= 0; we <= 0; state <= ACTION3; end
			ACTION3:
			  begin
				state <= SCAN1;
				case (f)
					0: ci <= d;				// JMP
					1: ci <= ci + d;			// JRP
					2: a <= -d;				// LDN
					4, 5: a <= a - d;			// SUB
					6: if ($signed(a) < 0) ci <= ci + 1;	// CMP
					7: state <= STOPPED;			// STOP
				endcase
			  end
	   endcase
	  end

	assign led = ~{2'b00, state == STOPPED}; 
	assign led2 = a; // Show accumular at end of program
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

	always @(posedge clk)
	  begin 
		if (we) ram[addr] <= din;
		else if (re) dout <= ram[addr]; 
	  end 

endmodule

