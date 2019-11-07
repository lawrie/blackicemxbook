`timescale 1ns/100ps

module tb();
	initial begin
		$dumpfile("waves.vcd");
		$dumpvars(0);
	end
	
	reg clk;

	initial begin
		clk = 1'b0;
	end

	always begin
		#20 clk = !clk;
	end

	reg       i_wr;
	wire      o_busy;
	reg [7:0] i_data;
	wire      o_uart_tx;

	txuart #(.CLOCKS_PER_BAUD(217)) u_txuart (
		.i_clk (clk),
		.i_wr(i_wr),
		.i_data(i_data),
		.o_busy(o_busy),
		.o_uart_tx(o_uart_tx)
	);

	initial begin
		i_wr 		= 1'b0;
		repeat(10) @(posedge clk);

		@(posedge clk);
		i_wr	 	= 1'b1;
		i_data 	= "H";

		@(negedge o_busy);
		@(posedge clk);

		i_data 		= "e";

		@(negedge o_busy);
		@(posedge clk);
		i_wr 	 	= 1'b0;

		repeat(10) @(posedge clk);

		$finish;
	end
endmodule

