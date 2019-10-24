# STM32 Programming

The STM32 ARM chip can be programmed using native libraries and the gcc compiler or with the Arduino IDE.

Arduino is covered in the next section.

To use gcc and the native libraries, you need to build the arm cross-compiler toolchain. Instruction for that are in the [BlackIce Wiki][].

The easiest way to start a development project for the STM32 is to copy and modify the iceboot project. As most STM32 firmware replacement will need to have some way to configure the Ice40 FPGA, starting with iceboot is usually a good idea.

However, there are alternatives to the STM native libraries, such as libopencm3.

Once a binary to run on the STM32 has been produced, there are several ways to upload it to the STM32. One way is to use the dfu-util, and another is to use the SWDIO interface.

[BlackIce Wiki]:						https://github.com/mystorm-org/BlackIce-II/wiki/Compiling-STM32-firmware

## DFU-UTIL

There is a lot of information on using dfu-util in the BlackIce Wiki, including [DFU Operations on the BlackIce II][] and [Flashing an FPGA design to the BlackIce II][].

[DFU Operations on the BlackIce II]:	https://github.com/mystorm-org/BlackIce-II/wiki/DFU-operations-on-the-BlackIce-II
[Flashing an FPGA design to the BlackIce II]:	https://github.com/mystorm-org/BlackIce-II/wiki/Flashing-an-FPGA-Design-to-the-BlackIce-II

## Debugging STM32 Programs

Information on using an STLink dongle over the SWDIO interface to flash and debug STM32 programs is in the [Using an STLink Dongle and GDB with your BlackIce II][]. It describes how to run openOCD and the GNU debugger from a Linux machine using the STLink device connected to the SWDIO and SWCLK pins on the RPi header.

You can do the same thing from a Raspberry Pi connected via the RPi header without an STLink dongle as described in the RPi header section below.

[Using an STLink Dongle and GDB with your BlackIce II]:	https://github.com/mystorm-org/BlackIce-II/wiki/Using-an-STLink-Dongle-and-GDB-with-your-BlackIce-II
