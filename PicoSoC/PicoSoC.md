|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../RetroComputing/RetroComputing.html)|[Up](..) |[Next](../BlackSoC/BlackSoC.html)|

# PicoSoc

PicoSoC is a simple 32-bit Risc-V  System-on-a-Chip based on the PicoRV32 Risc-V system. Both PicoRV32 and PicoSoC were written by Clifford Wolf, the author of the icestorm tools.

## PicoRV32

PicoRV32 is a small 32-bit Risc-V implementation. It is not the smallest, fastest, or most configurable Risc-V implementation, but it has been formally verified, used in a wide variety of projects,  and is an excellent starting point to learn about Risc-V processors and SoCs.

The CPU is implemented in a single file, [picorv32.v](https://github.com/cliffordwolf/picorv32/blob/master/picorv32.v).

That file contains the CPU, optional multiply and divide implementations, and optional interfaces to the Wishbone and AXI4 Lite buses.

The picorv32 module has a set of parameters, that can be used to configure the processor:

```verilog
parameter [ 0:0] ENABLE_COUNTERS = 1,
parameter [ 0:0] ENABLE_COUNTERS64 = 1,
parameter [ 0:0] ENABLE_REGS_16_31 = 1,
parameter [ 0:0] ENABLE_REGS_DUALPORT = 1,
parameter [ 0:0] LATCHED_MEM_RDATA = 0,
parameter [ 0:0] TWO_STAGE_SHIFT = 1,
parameter [ 0:0] BARREL_SHIFTER = 0,
parameter [ 0:0] TWO_CYCLE_COMPARE = 0,
parameter [ 0:0] TWO_CYCLE_ALU = 0,
parameter [ 0:0] COMPRESSED_ISA = 0,
parameter [ 0:0] CATCH_MISALIGN = 1,
parameter [ 0:0] CATCH_ILLINSN = 1,
parameter [ 0:0] ENABLE_PCPI = 0,
parameter [ 0:0] ENABLE_MUL = 0,
parameter [ 0:0] ENABLE_FAST_MUL = 0,
parameter [ 0:0] ENABLE_DIV = 0,
parameter [ 0:0] ENABLE_IRQ = 0,
parameter [ 0:0] ENABLE_IRQ_QREGS = 1,
parameter [ 0:0] ENABLE_IRQ_TIMER = 1,
parameter [ 0:0] ENABLE_TRACE = 0,
parameter [ 0:0] REGS_INIT_ZERO = 0,
parameter [31:0] MASKED_IRQ = 32'h 0000_0000,
parameter [31:0] LATCHED_IRQ = 32'h ffff_ffff,
parameter [31:0] PROGADDR_RESET = 32'h 0000_0000,
parameter [31:0] PROGADDR_IRQ = 32'h 0000_0010,
parameter [31:0] STACKADDR = 32'h ffff_ffff
```
  
The native memory interface of the picorv32 CPU has the following ports:
  
```verilog
output reg        mem_valid,
output reg        mem_instr,
input             mem_ready,

output reg [31:0] mem_addr,
output reg [31:0] mem_wdata,
output reg [ 3:0] mem_wstrb,
input      [31:0] mem_rdata,
```
  
| Port | Direction | Description |
|------|-----------|------------ |
|mem_addr|output| The memory_address to read from or write to|
|mem_valid|output| Set to 1 when mem_addr is valid, which requests a memory access|
|mem_wstrb|output| Specified which bytes of mem_wdata should be written.If zero, this is a read access|
|mem_wdata|output| The 32-bit data to be writren, when wstrb is not zero|
|mem_instr|output| Specifies if this is an instruction fetch|
|mem_rdata|input| The 32-bit data read, valid when mem_ready is set|
|mem_ready|input| Set when the data access is complete, and if a read, that mem_rdata is valid|
  
## PicoSoC

PicoSoc uses the picorv32 CPU and adds memory and peripheral access.

The default implementation is [picosoc.v](https://github.com/cliffordwolf/picorv32/blob/master/picosoc/picosoc.v), but custom implementations can modify this and add more peripherals or more memory types.

A uart peripheral is nearly always used and the implementation is [simpleuart.v](https://github.com/cliffordwolf/picorv32/blob/master/picosoc/simpleuart.v).

There must be some memory, at least BRAM, and optionally SPI flash memory implemented by [spiomemio.v](https://github.com/cliffordwolf/picorv32/blob/master/picosoc/spimemio.v) for executing code from.

The picorv32 register file is usually implemented in BRAM by the picosoc_regs module and CPU RAM by the picosoc_ram module.

## Pico RAM SoC

I will descibe a simple BRAM implementation of PicoSoC for the BlackIce Mx, which only uses BRAM, but adds some extra peripherals.

The [picosoc.v](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/picosoc.v) implementation is cut down and just uses simpleuart but not spimemio. It uses the default implementation of the register file in picov32, so has no picosoc_regs module. It uses the default picosoc_mem module which lets you configure the number of 32-bit words of memory that are used.

A top level module is needed to configure the picosoc module.

For PICO RAM SoC a set of defines are used to specify which peripheral are required, see [top.v](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/top.v).

Each peripheral has its own Verilog module:

| Peripheral | Module | Description |
|------------|--------|-------------|
|gpio|[gpio](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/gpio/gpio.v)| GPIO for buttons, LEDs etc.|
|audio|[audio](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/audio/audio.v) | Single pin PDM audio|
|i2c master|[i2c](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/i2c/i2c.v) | For driving i2c peripherals|
|flash memory|[flash](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/flash_write/flash_write.v)| Read and write flash memory, no execute|
|spi master|[spi](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/spi_master/spi_master.v) | For driving SPI peripherals |
|sd card|[sdcard](https://github.com/lawrie/pico_ram_soc/blob/master/hdl/picosoc/sdcard/sdcard.v) | SD card access||

There are also modules for driving Oled and Tft LCD displays.

Pico RAM SoC has a simple firmware implementation that runs user code that is loaded into the BRAM from a hex file.

There is no use of the C run time library, and instead there are a set of Arduino-style libraries for driving the various peripherals.

The examples directory contains different configurations of Pico RAM SoC with different peripheral support and a specific application writtnn in C. The only example that currently works on Blackice Mx is the simple one.


## Running Pico RAM SoC

To run Pico RAM SoC, you will need to install a pure RV32I gcc toochain in /opt/riscv32i. See the "Building a pure RV32I Toolchain" section in the [PicoRV32 README](https://github.com/cliffordwolf/picorv32).

Once this is installed, and you have the icestorm tools installed, you can do:

```sh
git clone https://github.com/lawrie/pico_ram_soc
cd pico_ram_soc/examples/simple
make upload
```

If in another terminal you do:

```
stty -F /dev/ttyACM0 raw -echo 115200
cat /dev/ttyACM0
```

You should see `Hello World!¬.

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../RetroComputing/RetroComputing.html)|[Up](..) |[Next](../BlackSoC/BlackSoC.html)|

