# Storage Devices

## SD Cards

There is a built-in SD card reader on the BlackIce that can be accessed from the STM32 or from the Ice40.

It shares pins with the dip switches and button 1, so they cannot be used when using the SD card reader and the dip switches must be in the OFF position.

BlackSoC contains a module, mod_sdcard, for accessing the SD card reader and an [sd card reader example][].

The myStorm Arduino board package supports using SD cards from the STM32.

Most of the retro computer implementations use SD cards.

It is possible to access several different file systems on SD card including FAT32 and SDDOS (used by Acorn Atom).

The BlackSoC [fat32 example][] reads a file from a FAT32 SD card.

[sd card reader example]:				https://github.com/lawrie/icotools/tree/master/icosoc/examples/sdcard
[fat32 example]:						https://github.com/lawrie/icotools/blob/master/icosoc/examples/fat32

## Flash Memory

There is no flash memory chip on the BlackIce II, but there are several ways to access the flash memory on the STM32.

If flash memory storage is required by an Ice40 application, there are several Digilent Pmods that can supply it. Alternatively, the STM32 flash memory can be used by SPI communication between the STM32 and the Ice40. That requires custom firmware.
