# BlackSoC

Another [picorv32][] based Risc-V SoC that is available on Blackice Mx is [BlackSoC][] which is derived from Clifford Wolf's [icoSoC][].

BlackSoC differs from PicoSoC in that it is a SoC generator, using a python program to generate the top-level Verilog file, and all the other files needed to generate the hardware and software.

BlackSoC (and icoSoc on which it is based) consist of a picorv32 Risc-V CPU plus a set of Verilog modules with a standardised interface that can be used by Risc-V programs written in C (or another language).

The modules are accessed via a memory-mapped API. Corresponding to each Verilog module is some simple standardised python code that generates the C API code for accessing the module. Most of the modules implement protocols such as I2C, SPI or UART, or specific peripheral such as LED panels.

All the user needs to write to generate the hardware is a simple configuration file (icosoc.cfg) that specifies what modules are required, which pins they are connected to and any necessary parameters for them. 

BlackSoC is rather easier to use than PicoSoc if you just want to use existing modules and it is not hard to define new modules. It is not as fast or configurable as the SpinalHDL SaxonSoC, which is introduced later in this book.

The version of BlackSoC on Blackice Mx uses a small bootloader in BRAM to load the user program over the UART (dev/ttyACM0). The program is loaded into SDRAM and executed from there. Flash memory is not currently used. The SDRAM controller used was written by Dan Gisselquist.

[BlackSoC]:					https://github.com/lawrie/icotools/tree/master/icosoc
[icoSoC]:					https://github.com/cliffordwolf/icotools/tree/master/icosoc
[picorv32]:					https://github.com/cliffordwolf/picorv32

## BlackSoC modules

BlackSoC currently has the following modules:

| Module         | Description                                                                             |
| ------         |:-----------                                                                             |
| mod_ad1        |: Access to the Digilent AD 1 dual 12-bit, 1MSPS ADC Pmod. This is a variant of mod_spi. |
| mod_adc        |: Support for the Al;inx AN108 AD/DA device.                                             |
| mod_audio      |: 8-bit audio uses PWM                                                                   |
| mod_extirq     |: Timer and external interrupt support                                                   |
| mod_gpio       |: Access to GPIO pins for input and output.                                              |
| mod_i2c_master |: Access to i2c devices.                                                                 |
| mod_ledpanel   |: Access to 32x32 and similar LED panels                                                 |
| mod_mixmodssd  |: Access to the myStorm 7-segment Mixmod                                                 |
| mod_ping       |: Access to HC-SR04 ultrasonic sensors                                                   |
| mod_pmodssd    |: Access to 7-segment displays                                                           |
| mod_ps2        |: Accessing PS/2 keyboards                                                               |
| mod_pullup     |: A version of mod_gpio with pullup resistors on                                         |
| mod_pwm        |: Setting frequency and duty cycles for Pulse Width Modulation signals                   |
| mod_rotary     |: Access to rotary sensors. Also usable for encoder motors.                              |
| mod_rs232      |: Access to uarts                                                                        |
| mod_spi        |: SPI master                                                                             |
| mod_spi_oled   |: A version of mod_spi for Oled displays                                                 |
| mod_ttexture   |: For tile and texture based VGA output                                                  |
| mod_tone       |: Generating audio tones                                                                 |
| mod_vga_text   |: Support for text on VGA monitors                                                       |

## BlackSoC examples

For each user program including the BlackSoC example programs, there is a configuration file, [icosoc.cfg][], that defines what modules the program uses, what pins they are connected to and other parameters.

There is a python program, icosoc.py, that generates all the run time files including the top-level Verilog file, the pcf file, C header files, a hex image file for the C program, and an include file for the Makefile.

The icosoc.py python program processes the configuration file and uses the python program associated with each module to generates C programs and headers for the API for that module.

There is also main.c program that defines the top-level C program to be run. The C program uses the APIs defined by the <module>.py files. You can also use extra C filesc and herader files.

If modules exist for all the hardware you wish to use, then all you need to do to write is an icosoc.cfg file and a main.c file.

If you need to access new hardware, you need to write a new Verilog module file and a corresponding python API file.

[icosoc.cfg]:				https://github.com/lawrie/icotools/blob/master/icosoc/examples/grove/icosoc.cfg

Here are the current BlackSoC examples:

| Example      | Description |
| -------      |:----------- |
| acl2         | Tests the Digilent ACL 2 acceleration sensors using SPI
| ad1          | Tests the Digilent AD 1 dual 120-bit 1MSPS ADC using SPI
| adc          | Tests the Alinx an108 AD/DA
| bme280       | Tests the BME280 pressure, humidity and temperature sensor in i2c mode
| esp01        | Serial communication with an ESP01 ESP8266 board for Wifi access
| ev3          | Serial communication with a LEGO Mindstorms EV3 UART sensor (broken)
| fat32        | Reading a file from a FAT32 SD card using mod_sdcard
| gamepad      | Use of the non-analog controls on a PC gamepad
| grove        | Test of some simple Grove sensors
| grovelcd     | Test of a Grove RGB-backlit i2c text LCD display
| hanoi        | Towers of Hanoi on a 32x32 LED panel
| hello        | Test of uart etc.
| iconoid      | Not tested on BlackSoC
| ioshim       | Not tested on BlackSoC
| led          | Simplest test just using leds
| ledpanel     | Test of LED panel
| life         | Conway’s Game of Life on an LED panel
| memtest      | Memory access test
| mixmod-ssd   | Test of myStorm 7-segment Mixmod
| motor        | Test of an encoder gear motor using Digilent dual H-bridge Pmod
| otl_demo     | Test of 7-segment display using the Digilent Pmod
| ping         | Test of an HC-SR04 ultrasonic sensor
| ps2          | Test of scan codes from a PS/2 keyboard using the Digilent Pmod
| rotary       | Test of a rotary sensor or the encoder on a motor
| rtc          | Test of DS1307 i2c real time clock module
| scales       | Not tested on BlackSoC
| sdcard       | Test of SD card access
| servo        | Test of servo motors
| seg8         | Test of an SPI 8 digit 7-segment display
| spi1306      | Test of an SPI ssd1306 Oled display
| ssd1306      | Test of an i2c ssd1306 Oled display
| ssd1331      | Test of ssd1331 RGB SPI Oled display
| ssd1335      | Test of ssd1335 RGB SPI Oled display
| theremin     | Uses ping sensor with tone generation for simple theremin
| timeofflight | Test of STM time-of-flight sensor
| timer        | Timers and external interrupts
| tone         | Generation of audio toners
| vga_text     | Simple demo of 80 x 30 VGA text screen
| wavplay      | Read 8-bit WAV file from SD card and play it using mod_audio
| weather      | Uses a bme280 sensor with an ssd1335 Oled display to show weather

## Running BlackSoC programs

More information on BlackSoC is available in the [README][] file. Before you can run BlackSoC programs, you need to install the picorv32 toolchain which is needed to build the C programs. BlackSoC examples only use the basic picorv32i version of the toolchain, not all 4 variants. But they will use the variants if the configuration file requires them.

[README]:					https://github.com/lawrie/blacksoc/blob/master/README

To run one of the examples, first do:

	git clone https://github.com/lawrie/blacksoc

Then connect your Blackice Mx and in one terminal do:

	stty -F /dev/ttyACM0 raw -ecjo
	cat /dev/ttyACM0

In a second terminal do:

	cd blacksoc/examples/<example-directory>
	make run

You will see the BlackSoC bootloader messages in the first terminal, followed by any messages from the example program. If the example program requires console input, you can connect a serial terminal program to /dev/ttyACM0.

If you edit main.c without touching any of the other files (like icosoc.cfg) and do “make run” again, the bitstream will not change so the program should rebuild quickly. Your will see bootloader messages on /dev/ttyUSB0 again as a new appimage.hex file is sent to the BlackSoC bootloader.

To write your own application, follow the conventions of the example programs. You can write new modules and they will be used automatically providing they follow all the rules sand are in the correct directory. Each module used must have an entry in icosoc.cfg, specifying the pins it uses, and other parameters.
