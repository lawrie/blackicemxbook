|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../SpinalHDL/SpinalHDL.html)|[Up](..) |[Next](../Resources/Resources.html)|

# SaxonSoc

SaxonSoc is a Risc-V System-on-a-Chip (Soc) generator based on the SpinalHDL VexRiscv 32-bit Risc-V implementation.

It is a scalable SoC platform that works on the smallest Lattice up5k ice40 boards, but scales up to run Linux with DDR memory on much larger boards.

It supports a wide range of memory options including BRAM, SDR and DDR SDRAM, SRAM, and Execute-in-place (XIP) from flash memory. It supports many peripherals, including UART, I2C and SPI, is extremely configurable, and has an API that makes it very easy to configure exactly which SoC you need for your project. It supports generating Board Support Packages (BSPs) with generated C header files and Linux device trees. It allows FPGA pins to be shared by multiple peripherals.

## Installation

You first need to install SpinalHDL - see the SpinalHDL chapter.

You then need to install a Risc-V GNU toolchain - see the PicoSoC section for one possible version of the toolchain. Alternatively, ou can also follow the instructions to install the SiFive version of the toolchain in the [SpinalHDL/Vexriscv repository](https://github.com/SpinalHDL/Vexriscv) - see the "Build the RISC-V GCC" section.

Finally, you should install the dev branch of SaxonSoc by:

```sh
git clone -b dev https:/github.com/SpinalHDL/SaxonSoc
git submodule init
git submodule update
```

## Creating a SoC

SaxonSoc uses a new way in SpinalHDL of generating the HDL, called generators, which delay generation to allow all the cross-dependencies between components to be specified.

Note that this example omits the package statement and imports needed at the top of the SpinalHDL source file, but is otherwise defines a complete working SoC. It differs slightly from the version of BlackiceMxMinimal in the SaxonSoc repository, as I have omittted the two SPI peripherals, which that version of the SoC uses.

In the SaxonSoc repository, the source for a SoC for a specific board is in the hardware/scala/saxon/board/<board-name> directory.

To define a new SoC, you create a class for the system, which specifies the memory and peripherals you require and which addresses they use.

```scala
class BlackiceMxMinimalSystem extends BmbApbVexRiscvGenerator{
  //Add components
  val ramA = BmbOnChipRamGenerator(0x80000000l)
  val uartA = Apb3UartGenerator(0x10000)
  val gpioA = Apb3GpioGenerator(0x00000)
  
  //Interconnect specification
  interconnect.addConnection(
    cpu.iBus -> List(ramA.bmb),
    cpu.dBus -> List(ramA.bmb, peripheralBridge.input)
  )
}
```

You then define a top-level class which specifies the clock frequency and how the clock and reset signals are created. It is here that you would use a PLL to create the clock, if necessary.

```scala
class BlackiceMxMinimal extends Generator{
  val clockCtrl = ClockDomainGenerator()
  clockCtrl.resetHoldDuration.load(255)
  clockCtrl.powerOnReset.load(true)
  clockCtrl.clkFrequency.load(25 MHz)

  val system = new BlackiceMxMinimalSystem
  system.onClockDomain(clockCtrl.clockDomain)

  val clocking = add task new Area{
    val clk_25M = in Bool()

    clockCtrl.clock.load(clk_25M)
  }
}
```

You then configure the memory and peripherals using the companion object of the system class. You can define multiple different configurations here. This example just creates one called default. It specifies the VexRiscv configuration you require and the size of the BRAM memory. It specifies the uart parameters including the size of receive and transmit fifos. It specifies how many GPIO pins you wish to use.

If you are executing code from BRAM, you can load the code from a hex file.

```scala
object BlackiceMxMinimalSystem{
  def default(g : BlackiceMxMinimalSystem, clockCtrl : ClockDomainGenerator) = g {
    import g._

    cpu.config.load(VexRiscvConfigs.minimal)
    cpu.enableJtag(clockCtrl)

    ramA.dataWidth.load(32)
    ramA.size.load(8 KiB)
    ramA.hexInit.load("software/standalone/blinkAndEcho/build/blinkAndEcho.hex")

    uartA.parameter load UartCtrlMemoryMappedConfig(
      baudrate = 115200,
      txFifoDepth = 32,
      rxFifoDepth = 32
    )
    
    gpioA.parameter load Gpio.Parameter(width = 8)

    g
  }
}
```

Finally you generate the Verilog and the BSP in a companion object to the top level class:

```scala
object BlackiceMxMinimal {
  //Function used to configure the SoC
  def default(g : BlackiceMxMinimal) = g{
    import g._
    BlackiceMxMinimalSystem.default(system, clockCtrl)
    clockCtrl.resetSensitivity load(ResetSensitivity.NONE)
    g
  }

  //Generate the SoC
  def main(args: Array[String]): Unit = {
    val report = SpinalRtlConfig.generateVerilog(IceStormInOutWrapper(default(new BlackiceMxMinimal()).toComponent()))
    BspGenerator("BlackiceMxMinimal", report.toplevel.generator, report.toplevel.generator.system.cpu.dBus)
  }
}
```

The pcf file is not generated for you, but the report does list all the top-level port names, which makes creating the pcf file easier.

## Generating the SoC

In the SaxonSoc repository, the synthesis files for a specific board are in the hardware/synthesis/<board-name> directory and the verilog is generated in the hardware/netlist directory.
  
To generate a BlackiceMxMinimal Soc, you do, with your board plugged in:

```sh
cd hardware/synthesis/blackicemx
cp makefile.minimal makefile
make generate
make prog
```

and your SoC starts running.

If your SoC runs code from flash memory, you will first need to load the software binary into flash memory at the address specified in the SoC configuration and the linker script. On Blackice Mx, you can do that with the writeFlash utility (described below), but it will soon be supported by the STM32 firmware.

Another way of running software is to use a bootloader in BRAM and load code over the uart into SDRAM. That is what the BlackiceMxArduino system does.

## Building the Risc-V software

Standalone software examples are in the software/standalone directory of the the SaxonSoc directory.

To build them you need RISCV_BIN set to your Risc-V toolchain. For example:

```sh
export RISCV_BIN=/opt/riscv32i/bin/riscv32-unknown-elf-
```

Then you do:

```sh
cd software/standalone/blinkAndEcho
make BSP=BlackiceMxMinimal
```

Note that the BSP used here is in the bsp directory in the SaxonSoC directory. Most of the BSP is created when generate your SoC, but you do have to set up include/soc.mk and include/default.ld. You can often copy these from another BSP that uses similar options. The soc.mk  specifies which Risc-V options you are using (compressed and/or multiply/divide hardware support).

Note that there is a cross dependency between the hardware and software in that the BSP is not generated until you build the SoC, but you need the BSP to compile the software. This means that if you uses hexInit to load the software binary, you must first set it null, 
generate the SoC, then build the software with the BSP, and then set hexInit to the software binary and regenerate the SoC.

## Blackice Mx configurations

The SaxonSoc repository contains several Blackice Mx configurations:

- BlackiceMxMinimal - as described above but with SPI peripheral for accessing the flash memory and the SD card.
- BlackiceMxSocSdram - similar to Minimal but adds SDRAM memory. Used by the writeFlash utility.
- BlackiceMxArduino - supports the SaxonArduino system. Uses a boot loader to load the software over uart into SDRAM.
- BlackiceMxXip - executes code in place (XIP) from dflash memory
- BlackiceMxZephyr - a version of Xip for running the Zephyr OS. Uses SDRAM for the RAM.

## Using the writeFlash utility

There is a software example in software/standalone/writeFlash that can be used to write a software binary to flash memory.

It requires the BlackiceMxSdram configuration as it reads the software binary from the uart into SDRAM, and then writes it to the flash memory. The software binary needs to prefixed with the address to write it to and its length. There is a createPrefix.py python script that will create such a prefix.

So to use the utility, you first build the software:

```sh
cd software/standalone/writeFlash
make BSP=BlackiceMxSdram
```

Then with your Blackice Mx plugged in, i another terminal do:

```sh
stty -F /dev/ttyACM0 raw -echo
cat /dev/ttyACM0
```

and then edit createPrefix.py to set the addr and length your require and do:

```sh
cd hardware/synthesis/blackicemx
cp makefile.sdram makefile
python createprefix.py
cat prefix.bin <software binary> >temp.bin
make prog
cat temp.bin >/dev/tytyACM0
```

You should then see diagnostics in the second terminal and the software binary will be written to the specified address in flash memory.

There is a [prebuilt version of writeFlash](https://github.com/lawrie/blackicemx_examples/tree/master/writeflash) you can use instead.

## Zephyr OS

You can build the philosophers demo of the Zephyr OS by:

```sh
git clone https://github.com/lawrieL/zephyr.git -b vexriscv

cd zephyr 
unset ZEPHYR_GCC_VARIANT 
unset ZEPHYR_SDK_INSTALL_DIR 
export CROSS_COMPILE="/opt/riscv32i/bin/riscv32-unknown-elf-" 
export ZEPHYR_TOOLCHAIN_VARIANT="cross-compile" 
export ZEPHYR_GCC_VARIANT="cross-compile" 
source zephyr-env.sh

cd samples/philosophers 
mkdir build 
cd build

cmake -DBOARD=vexriscv_saxon_up5k_evn .. make -j${nproc}
```

If you then write the generated software binary to address 0x50000 in flash memory using writeFlash, as described above, and then run the BlackiceMxZephyr SoC it will run the philosophers demo and you should see the output on /dev/tyyACM0.

Unfortunately it does not currently seem to work with /dev/ttyACM0, but if you connect a USB to UART device to the TX pin on the Blackice Mx RPi header, you should see the output on /dev/ttyUSB0.

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../SpinalHDL/SpinalHDL.html)|[Up](..) |[Next](../Resources/Resources.html)|
