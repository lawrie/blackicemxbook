# Getting Started

## The Blackice Mx device

Your BlackIce Mx device comes in two pieces. The BlackIce Mx carrier board and the IceCore board that contains all the electronics. They are joined together by 2 BlackEdge connectors, which together allow 100 pin connections between the carrier board and the IceCore board.

The BlackIce Mx carrier board is used to connect hardware peripherals using Mixmods or Pmods. Pmods are a widely used standard devised by Digilent. Mixmods are a myStorm extension to the Pmod standard, which allow the connection of two double Pmods, and use of the middle pins for analog signals from 0 to 3.3v.

There are two USB connectors on the IceCore board. You should ignore the one in the middle as it is not used. The device is powered by the USB connector in the corner near the buttons, furthest from the HDMI connecor. It is labelled PRG (if your eyesight is good).

This PRG USB connector powers the device, is used to program it with ice40 bitstreams and other data, and is used as a USB to UART device. Reminder: the other USB connector is not currently used for anything at all.

The LEDs closest to the PRG USB connector are system ones used mainly by the firmware. The LEDs closest to the HDMI connector are user LEDs which you can use from Verilog in your FPGA Designs (although the green and blue ones are shared with the two user buttons).

To power the device connector a USB cable from your computer to the USB PRG connector. When you do this the blue power LED (in the corner by the HDMI connector) will come on.

The green status system LED should come on. The other LEDs will probably be off, unless your device came with a bitstream programmed  in flash memory.

You should see a comms device on your PC. On Windows in will be a COM device, on Linux probable /dev/ttyACM0.

Warning: You should not use the HDMI connector at the moment as it is wired incorrectly.

## Setting up the software

Most of the chapters in this book assume you will be using Linux from the command line, but there are lots of other options.

If you are a MAC OSX user, the differences from Linux are slight: mainly a different name for the USB comms port.

If you are a Windows user, you could install Windows Subsystem for Linux (WSL) and then use the Linux instructions with again only minor differences, mainly in the name of the comms port.

Alternatively you could set up a VM such as a VirtalBox VM and run Linux from your Windows (or Mac) box. In that case, you should be able to follow the instructions in this book exactly as if you were running native Linux.

The main other option is to use the apio tool. Apio has a simple command interface, is written in python, and runs the same of Windows, Linux and MAC OSX. Unfortunately it currently uses an old place-and-route tool (arachne-pnr) rather than the latest nextpnr-ice40, and is has limited options, which means it it is not suitable for more complex projects.

If you are a Windows user, you might want to start with apio, and move on to one of the other options later.

This book assumes that you will be programming in Verilog, but then might want to move on to a higher level Hardware Description Language (HDL) like SpinalHDL on migen. 

If you don't want to use a programming language at all, and prefer to design digital circuits with a visual editor, then this book is not for you. But there is an open source tool called icestudio that you might like.

Finally, if you don't want to use the command line, but prefer to use an Integrated Development Environment (IDE), then there are chapters in this book on setting up a couple of different IDEs.

With all this in mind, you should follow the [Getting started](https://github.com/folknology/IceCore/wiki/IceCore-Getting-Started) instructions in the IceCore Wiki to set up the software on your PC.

## Updating the firmware

This book assumes your are using the latest myStorm firmware, so it is a good idea to start by updating the firmware.

You need dfu-util to update the firmware.

To put the device in DFU mode you keep the mode button pressed when powering up the device.

When you are in dfu mode, you can do `dfu-util -l` and see the device listed.

The latest firmware, which supports the USB to UART and writing bitstreams to flash memory (by first pressing the mode button) is in the USB-CDC-issue3 branch.

To update the firmware to this version, do:

```sh
git clone https://github.com/folknology/IceCore/tree/USB-CDC-issue-3
cd IceCore/firmware/myStorm/output
dfu-util -s 0x08000000:leave -a 0 -D mystorm.raw -t 1024
```

Updating the firmware is safe as DFU is in ROM and cannot be corrupted, so you can always revert to a working version.

You may have to use `sudo dfu-util` if you don't have udev rules for dfu on your system.

## Your first projects

Once you have the software set up and the firmware updated, you can start programming the ice40 FPGA.

You can start with the examples in the IceCore repository. The FPGA equivalent of a Hello World program is in blinky. The examples have two different blinkies: blink and trail. Running those will check that you have everything set up correctly and your Blackice Mx device is working. 

There are two ways to upload a design with Blackice Mx (if you have the latest firmware). If you copy a bitstream in raw mode to the USB PRG comms device (e.g. /dev/ttyACM0) it will immediately program the ice40 and start running your design. 

If you first press the Mode button (the one closeset to the USB connector), the yellow system Mode LED will come on and if you now copy a bitstream to the USB PRG comms device, if will be written to address 0 of the flash memory and the ice40 will then be rest and will boot into your design.

If you use the first of these methods the design is transient and disappears when you remove power. If you use the second method the design will be persistent in flash memory (until you replace it with another one) and will start running when your power up the device.

There is another example in the IceCore repository Examples directory: line-echo. You can use this to check that the USB to UART is working on your device (which needs the latest firmware). You will be able to copy a line of text to the USB comms port and see it echoed back.

When you are sure you know how your device working and the examples are working, you can move on to the first simple Verilog projects in the Programming the Built-in Hardware chapter.

## Troubleshooting

If uploading firmware fails, you will usually see the red CDONE (D) LED on, and the green STATUS (S) LED off or flashing. Sometimes the cat statement may hang and you need to unplug your device and plug.

One thing that calls modemmanager. If you have this on your system, you may want to uninstall it, disable it, stop its service, or, better, set up udev rules so that it ignores /dev/ttyACM0.

Another common cause of bitstreams failing to configure is that the comms device (e.g. /dev/ttyACM0) is not in raw mode. Make sure that you have done `stty -F /dev/ttyACM0 raw -echo`. This will normally be executed from a make file.

You can also look at the /dev/ttyACM0 output in another terminal, by doing@

```sh
stty -F /dev/ttyACM0 raw -echo
cat /dev/ttyACM0
```

You should see a version number message on power-up and messages that say when a config is successful or when it ails.

Unfortunately, you often muss the power-up message as the `cat /dev/ttyACM0` is not done in time, and the other messages may take a while not appear due to buffering.


|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../The_Hardware/The_Hardware.html)|[Up](..) |[Next](../Programming_the_Built-in_Hardware/Programming_the_Built-in_Hardware.html)|










