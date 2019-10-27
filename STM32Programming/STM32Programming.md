|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Actuators/Actuators.html)|[Up](..) |[Next](../MakingPmods/MakingPmods.html)|

# STM32 Programming

The STM32 ARM chip can be programmed using and the gcc compiler and the STM32 HAL libraries.

Arduino is covered in the next section.

To use gcc and the native libraries, you need to build the latest [GNU ARM Embedded Toochain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

The easiest way to start a development project for the STM32 is to copy and modify the [myStorm firmware](https://github.com/folknology/IceCore/tree/USB-CDC-issue-3/firmware) project. As most STM32 firmware replacement will need to have some way to configure the Ice40 FPGA, starting with the myStorm firmware is usually a good idea.

However, there are alternatives to the STM HAL libraries, such as libopencm3.

You will need to modify the Makefile in the MyStorm directory to change GCCPATH to the directory where you installed the ARM toochain.

To build the firmware you do `make raw` in the myStorm directory and the new firmware is in `myStorm/output/mystorm.raw`.

## dfu-util

You will need to install [dfu-util](https://github.com/mystorm-org/dfu-util) to flash new firmware.

The command to install new firmware is:

`dfu-util -s 0x08000000:leave -a 0 -D mystorm.raw -t 1024`

## Debugging STM32 Programs

Information on using an STLink dongle over the SWDIO interface to flash and debug STM32 programs is in the [Using an STLink Dongle and GDB with your BlackIce II][]. It describes how to run openOCD and the GNU debugger from a Linux machine using the STLink device connected to the SWDIO and SWCLK pins on the RPi header. The should be the same for the Blackice Mx, except that the stlink.cfg has changed and should be:

```
source [find interface/stlink-v2.cfg]
source [find target/stm32f7x.cfg]
reset_config none separate
```

[Using an STLink Dongle and GDB with your BlackIce II]:	https://github.com/mystorm-org/BlackIce-II/wiki/Using-an-STLink-Dongle-and-GDB-with-your-BlackIce-II

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Actuators/Actuators.html)|[Up](..) |[Next](../MakingPmods/MakingPmods.html)|
