# The Hardware

##	The MyStorm BlackIce Mx Development Board

![myStorm BlackIce Mx][img1]

The [myStorm BlackIce Mx][] is a development board with:
*	a Lattice HX4K TQFP144 Ice40 FPGA with 16KB of block RAM
*	an Stm32F730 processor with 256KB of flash memory and 64KB or RAM
*	A full capability USB port attached to the STM32 used for programming and as a UART to the ice40
* A second USB port attached to the STM32, currently unused
*	3 Mixmods which correspond to 6 double Pmods but also have analog signalks
* 2MB of external SDRAM
* 512KB of flash memory 
*	An SD card reader available to the ice40
*	A short Raspberry Pi header.
*	Two buttons available to the FPGA
*	A power LED
*	A red (D) LED that indicates when the FPGA has been configured (CDONE)
*	A green (S) LED available to the STM32 (STATUS)
* A yellow (M) LED that indicates the programming mode (MODE)
*	4 LEDs (B, G, Y, R) available to the FPGA, but two shared with the buttons

The Ice40 chip is an HX4K, which is really an HX8K whose resources have been limited by the Lattice software. As we are using the icestorm tools, we get the full resources of an HX8K.

The standard [mystorm][] STM32 firmware supports configuring the FPGA by copying the bit stream to the cdc-acm USB port (/dev/ttyACM0 on Linux). It also supports writing bitstreams to the flash memory, which the ice40 then boots to.

It is possible to write custom firmware that can provide extra functions but must provide some way to configure the FPGA.

As the icestorm tools treat the HX4K device as an HX8K device, the specs of the HX8K are most relevant to BlackIceMx.

[img1]:					https://cdn.tindiemedia.com/images/resize/kRnwcslzIExDv1SM6Nmc1doFpqI=/p/fit-in/774x516/filters:fill(fff)/i/7474/products/2019-07-03T14%3A53%3A37.320Z-BlackIceMx.jpg
[myStorm BlackIce Mx]:	https://www.tindie.com/products/Folknology/blackice-mx/
[mystorm]:				https://github.com/folknology/IceCore/tree/USB-CDC-issue-3/firmware/myStorm

##	The Lattice ICE40 HX4K FPGA
As the device is effectively an HX8K when programmed with the icestorm tools, the specs for that device are most relevant. It comes in a TQFP144 144 pin package.  There are 56 pins available via the Pmod connectors, and a total of 107 pins used (PIOs).

There are two PLL (but the 2nd one may not work) and 960 Programmable Logic Blocks (PLLs) which each consist of a 4 input look-up table (4-LUT) and a 1-bit D flip-flop. There are 32 blocks, each of 512 bytes, giving a total of 16kb of BRAM.

Verilog written for other devices, provided it does not use directives specific to Xilinx or Altera or other manufacturers, will normally work on the Ice40, as long as it does not use too many resources. The icestorm tools report on all resources used.

There are some differences due to use of the icestorm tools. It is not usually possible to deduce the usage of pins marked as inout in module interfaces, and there is limited support for tri-state logic. For this reason, the SB_IO directive (see the Directives chapter below) needs to be used for inout pins and the should be tri-stated by setting the direction to input.

Although all the examples in this book are in Verilog, it is possible to program the device using the icestorm tools, in VHDL. See the Languages chapter below.

##	STM32 Processor
The STM32L433 is a 32-bit ARM device that is connected to the Arduino headers and shares some pins with the Ice40 and with the Rpi header.

The STM32L433 uses a 12Mhz crystal, but a PLL multiplies this by 9, so the clock speed is 108Mhz.

The main ways of programming the STM32 processor are:
-	The arm-none-eabi gnu toolchain with STM drivers and libraries
-	The Arduino IDE

The first of these ways is usually done by copying and modifying the iceboot firmware.  This is described in the STM32 Programming chapter below.

How to use the Arduino IDE is in the Arduino chapter of this book.

##	PMODS
![pinout][img2]

[img1]: ./pinout.png "pinout"


### The Clock

Pin 129 is the external clock, connected to a 100 Mhz oscillator.  This clock, or clocks derived from it, is used to co-ordinate all sequential logic.

Clocks of other frequencies can be derived from this clock pin by use of pre-scalers or Phase Lock Loops (PLLs). PLLS are described in the Directives chapter.

Pre-scalers are mainly use for clocks that are a factor of 100, such as 33.3Mhz, 25Mhz, or 20Mhz.

### gReset pin

This pin is connected to the CH340 UART device and is brought high when a connection to the USB2 UART is made. It is not associated with reset button or the Ice40 reset pin.

If you need an external reset signal you should use buttons 1 or 2.

### User buttons

Button1 and button2 correspond to Ice40 pins 63 and 64, They are pulled up to 3.3v by a 10k resistor, so they are pulled low when pressed.

These pins are also used to access the SD card, so don’t press them when the SD card is in use.

### LEDs

The LEDS correspond to pins 71, 68, 67 and 70, which are shared with Pmod 14.

There is a Mux which is controllable from the STM32 that switches these pins between use as SPI pins and the LEDs. SPI is used to configure the Ice40, and when that is finished, iceboot switches the Mux so the LEDs can be used. 

If you are using SPI from the STM32 (e.g. in an Arduino program), or via the Rpi header from a Raspberry Pi, then the LEDs are not available and will be off.


## USB Port (USB 1)

The USB port USB1 is connected to the STM32 processor which can support full USB capability. The iceboot software uses it as a cdc-acm serial communication port that runs at full speed and is available as /dev/ttyACM0 on Linux. You do not need to set a baud rate fort this port as it runs at full speed, but you should set it to raw by “stty -F /dev/ttyACM0 raw” for the iceboot bitstream configuration to work correctly in binary (raw) mode.

Custom firmware on the STM32 can use this port in any way that it wants.

## RPi header

The Rpi header allows the Ice40 and the STM32 to talk to a Raspberry Pi using a ribbon cable or directly to a Raspberry Pi Zero plugged in to the headed via a female header on the underside of the Pi Zero.

| WiringPi | GPIO   | Usage  | Phys | Pin# | Usage | GPIO   | WiringPi |
| -------- |:----   |:-----  |:---- |:---- |:----- |:----   |:-------- |
|          |        |  NC    |  1   |  2   |  5V   |        |          |
|    8     | GPIO2  |  SDA   |  3   |  4   |  5V   |        |          |
|    9     | GPIO3  |  SCL   |  5   |  6   |  GND  |        |          |
|    7     | GPIO4  | SWCLK  |  7   |  8   |  RX   | GPIO14 |    15    |
|          |        |  GND   |  9   |  10  |  TX   | GPIO15 |    16    |
|    0     | GPIO17 | SWDIO  |  11  |  12  |   S   | GPIO18 |    1     |
|    2     | GPIO27 | nRESET |  13  |  14  |  GND  |        |          |
|    3     | GPIO22 |   OE   |  15  |  16  | BOOT  | GPIO23 |    4     |
|          |        |   NC   |  17  |  18  | RESET | GPIO24 |    5     |
|    12    | GPIO10 |  EMOSI |  19  |  20  |  GND  |        |          |
|    13    | GPIO9  |  EMISO |  21  |  22  | DONE  | GPIO25 |    6     |
|    14    | GPIO11 |  ESCK  |  23  |  24  |  ESS  | GPIO8  |    10    |
|          |        |  GND   |  25  |  26  |  NC   | GPIO7  |    11    |


## Schematic

![Schematic][img3]

[img3]:				./Schematic.jpg "Schematic"
