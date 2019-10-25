# Directives

## SB_IO

Pins can be defined as input or output in a PCF, but not as IO. If a Pin is set as IO in the top level Verilog module, then it might be possible for synthesis and routing tools to deduce that the pin should be IO.

However, the open source tools are not currently very good at deducing the usage of pins that are used for both input and output. To cope with this an SB_IO directive needs to be used in the Verilog source.

Here is an example of its use:

```verilog
SB_IO #(
	.PIN_TYPE(6'b 1010_01),
	.PULLUP(1'b 0)
) ios [IO_LENGTH-1:0] (
	.PACKAGE_PIN(IO),
	.OUTPUT_ENABLE(io_dir),
	.D_OUT_0(io_out),
	.D_IN_0(io_in)
);
```

This example is from icosoc’s mod_gpio. IO is (slightly confusingly) the name of the pin here and corresponds to an array of pins whose length is defined by the parameter IO_LENGTH IO_LENGTH.

When one of the IO pins is required to be used as input, the corresponding entry in io_dir should be set to zero and the value in the io_in array used. When it is required to be output io_dir should be set to 1 and io_out should be used. SB_IO can also be used to set a pullup resistor on an input pin.

## PLL

When slower clock speeds than the 25 MHz of the built in clock on pin 60 are needed, they can sometimes be created using pre-scalers if they are a simple factor of 25. If faster clocks are needed, or if the clock required is not a simple factor of 25, then Phase Locked Loops must be used.

One example is to produce a clock of 31.5 MHz for VGA from the 100 MHz built-in clock.

```verilog
SB_PLL40_CORE #(
	.FEEDBACK_PATH("SIMPLE"),
	.DIVR(4'b1000),         // DIVR =  4
	.DIVF(7'b1010000),      // DIVF = 80
	.DIVQ(3'b101),          // DIVQ =  5
	.FILTER_RANGE(3'b001)   // FILTER_RANGE = 1
) uut (
	.RESETB(1'b1),
	.BYPASS(1'b0),
	.REFERENCECLK(clk25),
	.PLLOUTCORE(clk)
);
```

There is a lot of information on how to use PLLs in the [BlackIce Wiki][].

[BlackIce Wiki]:			https://github.com/mystorm-org/BlackIce-II/wiki/PLLs

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Previous](../Programming_the_Built-in_Hardware/Programming_the_Built-in_Hardware.html)|[Up](..) |[Next](../Memory_Access/Memory_Access.html)|
