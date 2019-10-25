# Memory Access

The internal memory in the Ice40 FPGA is known as Block RAM or BRAM. There is 16KB of it in 32 banks of 512 bytes.

Yosys deduces when BRAM can be used. Memory blocks are typically defined like:

	reg [7:0] mem [0:MAX_INDEX];

But it does not need to be in bytes, the 7 can be replaced by other maximum indexes for the number of bits in each unit. Not all declarations of this sort are mapped to BRAM. It depends on how it is accessed.

There are a few design patterns that are frequently used, that will be reliably mapped to BRAM.

## ROMs

A read only memory in BRAM can be programmed as:

	module rom myrom (
		output reg [7:0] dout,
		input[12:0] address, 
		input clk);

		parameter MEM_INIT_FILE = "rom.hex";

		reg [7:0] rom [0:8191];

		initial
		if (MEM_INIT_FILE != "")
			$readmemh(MEM_INIT_FILE, rom);

		always @(posedge clk)
		dout <= rom[address];

	endmodule

Sometimes instead of initialising the ROM from a hex or binary file, a switch statement is used to explicitly define the values at each address.

## Dual-ported RAM

Dual ported RAM used for video memory or other uses, can be programmed as:

	module vid_ram (
		// Port A
		input            clk_a,
		input            we_a,
		input [12:0]     addr_a,
		input [7:0]      din_a,
		// Port B
		input            clk_b,
		input [12:0]     addr_b,
		output reg [7:0] dout_b            
	);

		parameter MEM_INIT_FILE = "vid_ram.mem";

		reg [7:0]                     ram [0:6143];

		initial
		if (MEM_INIT_FILE != "")
			$readmemh(MEM_INIT_FILE, ram);

		always @(posedge clk_a)
		  begin
			if (we_a)
				ram[addr_a] <= din_a;
		  end

		always @(posedge clk_b)
		  begin
			dout_b <= ram[addr_b];
		  end

	endmodule

Sometimes the clock used for reading and writing the memory is the same and a single clock parameter can be used.

## SDRAM

In addition to BRAM, the BlackIce Mx has 2MB of external single data rate SDRAM. This must be accessed explicitly using a set of dedicated address, data and control pins.

## Flash memory

The Blackice Mx board also has 512KB of external flash memory. This can be used to implement read-only memory (ROM) for soft CPUs using Execute-in-plce (XIP).

## Memory mapping

SoCs and soft processors typically access hardware by memory mapping. So when the soft processor issues a memory access, a Verilog module examines the address and decides whether to map it to SDRAM or BRAM or flash memory, or to interpret it as a read or write to other hardware. In the latter case it will usually pass the address and data (in the case of writes) to another module to access the required hardware. A flag from that module will normally indicate when the access is complete or when an asynchronous access has been started and the soft processor memory access can then complete. It may take several clock cycles.

A standard Bus such as a Wishbone bus, or an AXI bus, on an APB bus, or some combination of these may be used for such accesses.

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Directives/Directives.html)|[Up](..) |[Next](../Soft_Processors/Soft_Processors.html)|
