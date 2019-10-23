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

The NES implementation is based on the up5k-demos version by David Shah, which is based on the Mist version, which was based on the original fpganes version by Ludwig Strigeus.

See https://github.com/lawrie/up5k-demos/tree/master/nesmx

![Mario](https://forum.mystorm.uk/uploads/default/optimized/1X/970a9bb39cb8261948b0c90bf9450ca2200412df_1_690x408.jpg)

![NES](https://forum.mystorm.uk/uploads/default/original/1X/b359124c09434f0abbc4e0a9a41a39cbdcd551ef.jpg)

## Acorn Atom

![Acorn Atom](./AcornAtom.jpg "Acorn Atom")

The Acorn Atom implementation is based of David Bank’s Ice40Atom. 

The software archive is available at <https://github.com/hoglet67/AtomSoftwareArchive/releases/download/V10/AtomSoftwareArchive_20180225_1154_V10_SDDOS2.zip>

You need to write this as a raw image to ad SD card by:

`dd if=archive.img of=/dev/sdxxx`

where sdxxx is SD card drive.


## Jupiter ACE

![Jupiter Ace](https://forum.mystorm.uk/uploads/default/optimized/1X/e07f9482fefe563c5dfb304d3df3cc85cd0683d5_1_690x454.jpg)

Another David Banks port.

The Jupiter Ace was a Forth machine.

This port is a simpler one that does not require custom firmware It can be build using the build.sh file at <https://github.com/lawrie/Ice40JupiterAce/tree/master/blackicemx>.

## Apple One

![Apple One](AppleOne.jpg "Apple One")

This implementation of the Apple One is by Alan Garfield.

It is available at <https://github.com/lawrie/apple-one>.
