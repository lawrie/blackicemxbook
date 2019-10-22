# The Hardware

##	The MyStorm BlackIce II Development Board

![myStorm BlackIce II][img1]

The [myStorm BlackIce II][] is a development board with:
*	a Lattice HX4K TQFP144 Ice40 FPGA with 16KB of block RAM
*	an STM32L433 processor with 256KB of flash memory and 64KB or RAM
*	A full capability USB port attached to the STM32
*	A USB UART switchable between the STM32 and the FPGA
*	6 double and 2 single Pmods
*	512KB of external SRAM
*	An SD card reader available to both the FPGA and STM32
*	Arduino Uno headers (with 4 extra pins on Digital3)
*	a short Raspberry Pi header.
*	a reset button for the STM32
*	two buttons available to the FPGA
*	4 dip switches available to the FPGA
*	A power LED
*	An LED that indicates when the FPGA has been configured (DONE)
*	An LED available to the STM32 (DEBUG)
*	4 LEDs available to the FPGA

The design of the board is slightly unusual as flash memory is not directly available to the FPGA, so configuration of the FPGA must be done via the STM32 processor (or via the Raspberry Pi header).

Another oddity is that although the Ice40 chip is an HX4K, it is really an HX8K whose resources have been limited by the Lattice software. As we are using the icestorm tools, we get the full resources of an HX8K.

The standard [iceboot][] STM32 firmware supports configuring the FPGA by copying the bit stream to the cdc-acm USB port (/dev/ttyACM0 on Linux) or by copying it from a fixed address in the STM32 flash memory.

However, it is possible to write custom firmware that can provide extra functions but must provide some way to configure the FPGA.

The board also includes a Mux that allows some of the components to be switched. The STM32 can switch the Ice40 SPI slave used for configuration between itself and the RPi header.  When the SPI slave is switched to the RPi header the 4 LEDs are not available to the Ice40.

As the icestorm tools treat the HX4K device as an HX8K device, the specs of the HX8K are most relevant to BlackIce II.

[img1]:					./MyStormBlackIceII.jpg "MyStorm BlackIce II Development Board"
[myStorm BlackIce II]:	https://www.tindie.com/products/Folknology/blackice-ii/
[iceboot]:				https://github.com/mystorm-org/BlackIce-II/tree/master/firmware/iceboot

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

##	Normal/DFU Mode Jumper
The STM32 has a built-in bootloader that boots into DFU mode by default. In DFU mode the device accepts DFU commands from dfu-util. This allows program and data to be uploaded into the STM32 flash memory. This is useful for replacing the firmware on the STM32 or for writing Ice40 bitstreams into STM32 flash memory (at address 0x0801f000) from where the iceboot firmware will read them and configure the Ice40 at start up.

If the jumper switch shown in the diagram above is in position, the BOOT pin on the STM32 is brought low which causes the STM32 to boot into normal mode and run the iceboot firmware.

When running most of the examples in this book, the board should be in normal mode.

It needs to be in DFU mode when using the Arduino IDE as that environment use dfu-util to configure the device.

It also needs to be in DFU mode in to flash some software such as the retro computer applications, as these write custom firmware and an Ice40 bitstream to the STM32 flash memory.

If the Rpi header is in use, the jumper needs to be removed and the Raspberry Pi will then control whether the STM32 is in normal or DFU mode.

##	Reset Button
When the reset button is pressed the STM32 resets. If the board is in DFU mode it goes into its DFU bootloader. If the board is in normal mode, it starts the iceboot firmware or any custom firmware that has replaced iceboot, such as an Arduino application, or the custom firmware that comes with the retro computer applications.

If the iceboot firmware is running it will look for an Ice40 bitstream in flash memory (address 0x0801f000) and if found will configure the FPGA. If no such bitstream is found, the Ice40 will be unaffected and will continue to run its existing bitstream. Iceboot will then wait fort bitstreams on its USB port.

##	PMODS
Most of the hardware is connected via [Pmod][] connectors.

The Pmod standard was introduced by Digilent and they sell a large variety of Pmods.

There is [a kit][] for producing your own Pmods that can optionally be bought with the BlackIce II.

There are also Pmods available on open source hardware sites such as OSH Park, for example those produced by the myStorm designer [Folknology][] and by [BlackMesaLabs][] and [BikerGlen][].

Here is a collection of Digilent, home-made and OSH Park Pmods:
![Collection of Pmods][img2]
 
There are 6 double and 2 single Pmods available on the BlackIce II.

They are called Pmod1 – Pmod14 as shown in this picture from the BlackIce II Wiki at the start of this chapter.

Pmod shares 3 of its pins with the USB2 UART, which limits its uses if your application uses the UART.

The pins on a Pmod are numbered 1-6 from the right. For a double Pmod the top pins are 1-6 and the bottom ones 7-12. Pines 5 and 11 are connected to GND. Pins 6 and 12 are connected to +3.3v.

BlackSoC (see below) numbers its Pmods differently. It only number the double Pmods and PMOD 1 / 2 is not used because of the conflict with the UART which is used by BlackSoC. So BlackSoC has 5 double Pmods called Pmod1 – Pmod5, corresponding to PMOD 3 / 4, PMOD 5 / 6, PMOD 7 /8, PMOD 9 / 10, and PMOD 11 / 12.

The pins on Pmods 13 and 14 and reused in multiple ways and so great care must be taken if you use those Pmods.

Pmod13 is shared with the slider switches which have 10k pull-up resistors to 3.3v. In the ON position the sliders are hard-wired to GND. They are also available as pins DIG16- 19 on the Arduino Digital3 header. Those pins are not present on most Arduino shields. The pins are also used for the SD card. So, it is only safe to use Pmod13 for input if the sliders are in the OFF position and even then, you must take into account that they have a 10k pullup resistor. Similarly, the SD card can only be used when the sliders are in the OFF position.

Pmod14 is shared with the Leds.

You can plug a huge array of hardware into the Ice40 FPGA using single row and double row Pmods. And using double or even triple Pmods.
  |  
If your device needs a 5v supply, it can get it from the VIN pin on the Arduino header.

[Pmod]:				https://en.wikipedia.org/wiki/Pmod_Interface
[a kit]:			https://www.tindie.com/products/Folknology/the-mystorm-hackers-pmod-kit/
[Folknology]:		https://www.oshpark.com/profiles/Folknology
[BlackMesaLabs]:	https://www.oshpark.com/profiles/BlackMesaLabs
[BikerGlen]:		https://oshpark.com/profiles/bikerglen
[img2]:				./Pmods.jpg "A Collection of Pmods"

## Pins and Signals

### Pmod pins

The pin numbers for Pmods are as follows:

| Pmod |     | 10  |  9  |  8  |  7  |  4  |  3  |  2  |  1  |
| ---- |:--- |:--- |:--- |:--- |:--- |:--- |:--- |:--- |:--- |
| 1/2  |     | 87  | 90  | 93  | 95  | 85  | 88  | 91  | 94  |
| 3/4  |     | 106 | 98  | 101 | 104 | 97  | 99  | 102 | 105 |
| 4/5  |     | 106 | 110 | 113 | 144 | 107 | 112 | 114 | 143 |
| 7/8  |     |  3  |  4  |  7  |  8  |  1  |  2  |  9  | 10  |
| 9/10 |     | 11  | 12  | 17  | 18  | 15  | 16  | 19  | 20  |
|11/12 |     | 25  | 26  | 31  | 32  | 21  | 22  | 33  | 34  |
|  13  |     |     |     |     |     | 41  | 39  | 38  | 37  |
|  14  |     |     |     |     |     | 70  | 67  | 68  | 71  |

### SRAM Pins

The pins numbers used for the SRAM are:

| Address Bit | Pin |     | Data Bit | Pin |
| ----------- |:--- |:--- |:-------- |:--- |
|     0       | 137 |     |    0     | 136 |
|     1       | 138 |     |    1     | 135 |
|     2       | 139 |     |    2     | 134 |
|     3       | 141 |     |    3     | 130 |
|     4       | 142 |     |    4     | 125 |
|     5       | 42  |     |    5     | 124 |
|     6       | 43  |     |    6     | 122 |
|     7       | 44  |     |    7     | 121 |
|     8       | 73  |     |    8     | 62  |
|     9       | 74  |     |    9     | 61  |
|     10      | 75  |     |    10    | 60  |
|     11      | 76  |     |    11    | 56  |
|     12      | 115 |     |    12    | 55  |
|     13      | 116 |     |    13    | 48  |
|     14      | 117 |     |    14    | 47  |
|     15      | 118 |     |    15    | 45  |
|     16      | 119 |     | 
|     17      | 78  |     | 

The pins used for SRAM control are:

|  Name  | Pin |
|  ----  |:--- |
| RAM_OE | 29  |
| RAM_WE | 120 |
| RAM_CS | 23  |
| RAM_UB | 28  |
| RAM_LB | 24  |
 

### QSPI pins

|     Name     | Pin |
|     ----     |:--- |
|   QPSI_CSN   | 81  |
|   QPSI_CK    | 82  |
| QPISI_IDQ[0] | 83  |
| QPISI_IDQ[1] | 84  |
| QPISI_IDQ[2] | 79  |
| QPISI_IDQ[3] | 80  |


### Other pins

|  Name   | Pin |
|  ----   |:--- |
|   clk   | 129 |
| greset  | 128 |
|  DONE   | 52  |
|  DBG1   | 49  |
| Button1 | 63  |
| Button2 | 64  |


### Pin shared between the Ice40 and the STM32

There is an article on this in the [BlackIce Wiki][].

QSPI is a boot way to transfer data at fast rates between the STM32 and the Ice40.

There are also multiple sets of SPI and UART pins.


[BlackIce Wiki]:	https://github.com/mystorm-org/BlackIce-II/wiki/Connections-between-the-STM32-and-the-iCE40

### DIG16- 19 pins

There are 4 extra pins on Arduino digital3 header, called DIG16, DIG17, DIG18 and DIG19. They correspond to Ice40 pins 41, 39, 38 and 37. They are also shared with Pmod13 and the 4 sliders. They are pulled up to 3.3v by a 10k resistor.

In addition, the pins are used for SD card access.

There are various consequences of the reuse of these pins. If you are doing SD card access, the sliders must be in the pull-up or OFF position (away from the outside of the board).

When the sliders are in the ON position (towards the outside of the board) they are hard-connected to GND. If you connect a 3.3v source to Pmod 1q3 or the DIG16-19 Arduino pins when the switches are in that position, you will cause a short-circuit and the board will reboot. You may damage the board doing that.

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

## USB UART (USB 2)

The BlackIce2 has a UART from the FPGA to USB connector 2, which can also be switched to go to the Raspberry Pi header and to the STM32. It also has two extra hardware serial connectors from the STM32 to the Ice40 FPGA.

The USB2 connector has a reset pin (greset) connected to it that can send a signal to the FPGA when a serial connection is started.

This example uses the USB2 connector to send data from a Linux host computer to the FPGA.

Such a connection can send commands to and get responses from, the FPGA. It is also useful for debugging.

The UART uses a cheap CH340 device to provide a serial connection of up to 115200 baud. It is /dev/ttyUSB0 on Linux, unless you are using it via the RPi header when it is /dev/ttyAMA0. RX, RX and RTS signals are connected to the STM32, the Ice40, the RPi header and the USB2 port via the CH340. Anything that is not using the connection should tri-state the pins (i.e. set the pin mode to input) so that they do not interfere with the other devices.

The iceboot software initially sends boot messages to the device, but after the FPGA has been configured, it tristate its pins so that the uart is available to the Ice40. The Ice40 can then transfer data to and from the USB2 port or the RPi header or Pmod 1. It should be possible to use the uart to communicate between the STM32 and the Ice40, but that does not seem to work, and there are other serial ports available between those devices, as well as SPI and QSPI.

## Arduino headers

The pins on the Arduino headers are only available to the STM32, apart from DIG16 – 19, which are available to both, but see above for potential pitfalls in using those pins.

An Arduino board package is available for programming the STM32 using the Arduino IDE and can use Arduino Uno shields, but preferably ones that work at 3.3v. Some limited use of 5v shields is possible but care should be taken with them. The analog pins, for example, are not 5v tolerant.

The VIN and 5v pins on the digital3 Arduino header and useful for powering hardware that needs 5v.

FPGA (Verilog) applications cannot get direct access to the Arduino headers, they must talk to the STM32 (e.g. via SPI or QSPI), and the STM32 applications (for example an Arduino one) can then talk to the hardware plugged in to the Arduino headers. This is a way to to use Analog devices or screens such as the Gameduino 3.

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
