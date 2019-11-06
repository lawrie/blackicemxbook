# SaxonSoc

SaxonSoc is a Risc-V System-on-a-Chip (Soc) based on the SpinalHDL VexRiscv 32-bit Risc-V implementation.

It is a scalable SoC that works on the smallest Lattice up5k ice40 boards, but scales up to run Linux with DDR memory on much larger boards.

It supports a wide range of memory options including BRAM, SDR and DDR SDRAM, SRAM, and Execute-in-place (XIP) from flash memory. It supports many peripherals, including UART, I2C and SPI, is extremely configurable, and has an API that makes it very easy to configure exactly which SoC you need for your projects. It supports generating Board Support Packages (BSPs) with generated C header files and Linux device trees. It allows FPGA pins to be shared by many peripherals.

## Installation

You first need to install SpinalHDL - see the SpinalHDL chapter.

You then need to install a Risc-V GNU toolchain - see the PicoSoC section for one possible version of the toolchain. Alternatively, ou can also follow the instructions to install the SiFive version of the toolchain in the SpinalHDL/Vexriscv repository.

Finally, you should install the dev branch of SaxonSoc by:

```sh
git clone -b dev https:/github.com/SpinalHDL/SaxonSoc
git submodule init
git submodule update
```

## Blackice Mx configurations

The SaxonSoc repository contains several Blackice Mx configurations:

- BlackiceMxMinimal
- BlackiceMxSocSdram
- BlackiceMxArduino
- BlackiceMxXip
- BlackiceMxZephyr

## Generating a SoC




