# Retro Computing

The BlackIce Mx with its SDRAM, Flash memory, SD card reader, and plentiful Mixmod/Pmod sockets is particularly suited to emulating older computers.

Some of the implementations currently available on BlackIce Mx are:

* Nintendo Entertainment System (NES)
* Acorn Atom
* Jupiter Ace
* Apple One

All these implementations use the Digital VGA Pmod and a VGA monitor, plus (apart from NES) a Digilent PS/2 keyboard Pmod and a PS/2 keyboard. NES requires a 7-pin original Nintendo controller or a 9-pin clone controller.

Some of them require an SD card created for them to stores games and other programs.

## Nintendo Entertainment System

The [NES implementation](https://github.com/lawrie/up5k-demos/tree/master/nesmx) is based on the up5k-demos version by David Shah, which is based on the Mist version, which was based on the original fpganes version by Ludwig Strigeus.

It uses a non-standard (512 x 480) VGA mode that does not work on all monitors or most TVs.

![Mario](https://forum.mystorm.uk/uploads/default/optimized/1X/970a9bb39cb8261948b0c90bf9450ca2200412df_1_690x408.jpg)

![NES](https://forum.mystorm.uk/uploads/default/original/1X/b359124c09434f0abbc4e0a9a41a39cbdcd551ef.jpg)

## Acorn Atom

![Acorn Atom](https://forum.mystorm.uk/uploads/default/optimized/1X/4a8e2a5815e4faf3c1adf6371f8898c58312b0e8_1_690x477.jpg)

The [Acorn Atom implementation](https://github.com/lawrie/Ice40Atom/tree/master/blackicemx) is based of David Bank’s Ice40Atom. 
It is built by build.sh.

It needs the [software archive](https://github.com/hoglet67/AtomSoftwareArchive/releases/download/V10/AtomSoftwareArchive_20180225_1154_V10_SDDOS2.zip) for the SD card.

You need to write this as a raw image to ad SD card by:

`dd if=archive.img of=/dev/sdxxx`

where sdxxx is SD card drive.

## Jupiter ACE

![Jupiter Ace](https://forum.mystorm.uk/uploads/default/optimized/1X/e07f9482fefe563c5dfb304d3df3cc85cd0683d5_1_690x454.jpg)

Another David Banks port.

The Jupiter Ace was a Forth machine.

[This port](https://github.com/lawrie/Ice40JupiterAce/tree/master/blackicemx) is a simpler one that does not require custom firmware. It can be build using the build.sh file.

## Apple One

![Apple One](https://forum.mystorm.uk/uploads/default/optimized/1X/220279feaf92e8afd8e1d918f9a72b4b722f680f_1_690x423.jpg)

This implementation of the [Apple One](https://github.com/lawrie/apple-one) is by Alan Garfield.

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Input_Devices/Input_Devices.html)|[Up](..) |[Next](../PicoSoc/PicoSoc.html)|

