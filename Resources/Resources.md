|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../LogicAnalysers/LogicAnalysers.html)|[Up](..) |[Next](..)|

# Resources

## Learning Verilog

### Books

Simon Monk's book : [Programming FPGAs: Getting Started with Verilog](https://www.amazon.co.uk/Programming-FPGAs-Getting-Started-Verilog-ebook/dp/B01M0F1L5G) is good for beginners and explains how to program in Verilog and drive simple hardware.

Its examples are for commercial FPGAs, so need some conversion to run on Blackice Mx.

Steven Hugg's book [Designing Video Game Hardware in Verilog](https://www.amazon.co.uk/Designing-Video-Game-Hardware-Verilog-ebook/dp/B07LD48CTV) is good if you are interested in retro computing. 

It has an [interesting companion web site](https://8bitworkshop.com/v3.4.2/?platform=verilog) with an online editor and simulator for Verilog.

### Web sites

The [fpga4fun](https://www.fpga4fun.com/) web site is very good, and the source of some of the examples in this ebook.

The [fpga4student](https://fpga4student.com) also has some interesting projects.

The [FPGA Wars](https://github.com/Obijuan/open-fpga-verilog-tutorial/wiki/Home_EN) community have a Verilog tutorial.

The [ZipCPU blog](http://zipcpu.com/) is a bit more advanced, but is very good on topics such as formal verification and using industry-standard buses such as Wishbone and AXI.

### Online courses

[Udemy](https://www.udemy.com/topic/fpga/) has some FPGA and Verilog courses.

## Tools

[Project Icestorm](http://www.clifford.at/icestorm/)

Verilog Simulator: [iVerilog](http://iverilog.icarus.com/) 

Signal viewer: [GTKWave](http://gtkwave.sourceforge.net/)

A fast Cerilog Simulator: [Verilator](https://www.veripool.org/wiki/verilator)

[apio](https://github.com/FPGAwars/apio)

[icestudio](https://github.com/FPGAwars/icestudio)

## IDEs

[Atom](https://atom.io)

[VSCode](https://code.visualstudio.com/)

## Risc V cores

There is a list of [RISC-V cores and SoC platforms](https://github.com/riscv/riscv-cores-list) on github, but it is not complete.

Some of the RISC-V cores that run on ice40 devices include:

[picorv32](https://github.com/cliffordwolf/picorv32/tree/master/picosoc)

[icicle](https://github.com/grahamedgecombe/icicle)

[Vexriscv](https://github.com/SpinalHDL/VexRiscv)

## SoC generators

### Verilog 

[PicoSoc](https://github.com/cliffordwolf/picorv32/tree/master/picosoc)

[IcoSoC](https://github.com/cliffordwolf/icotools/tree/master/icosoc)

[BlackSoc](https://github.com/lawrie/icotools/tree/master/icosoc) - only works on Blackice II

[icicle](https://github.com/grahamedgecombe/icicle)

[FuseSoC}(https://github.com/olofk/fusesoc)

### SpinalHDL

[Murax](https://github.com/SpinalHDL/VexRiscv/blob/master/src/main/scala/vexriscv/demo/Murax.scala)

[Briey](https://github.com/SpinalHDL/VexRiscv/blob/master/src/main/scala/vexriscv/demo/Briey.scala)

[SaxonSoc](https://github.com/SpinalHDL/SaxonSoc/tree/dev)

### migen

[LiteX](https://github.com/enjoy-digital/litex)

## Other Hardware Description Languages

[SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) is the Scala-based language that VexRiscv and SaxonSoc is written in. Its author is Charles Papn (Dolu1990). There is [online documentation](https://spinalhdl.github.io/SpinalDoc-RTD/).

[migen](https://github.com/m-labs/migen) is a python based language used by Litex.

[nmigen](https://github.com/m-labs/nmigen) is a newer version of migen.

[Chisel](https://github.com/freechipsproject/chisel3) is another Scala-based language used by the Sifive Risc-V implementations.

[clash](https://clash-lang.org/) is a Haskell-based functional HDL.

## Other open source boards

There are a lot of open source FPGA board. Here are some of the current popular ones:

[TinyFPGA BX](https://www.amazon.co.uk/TinyFPGA-MMP-0319-BX-Without-Pins/dp/B07HCXTNFX)

[iCEBreaker](https://www.crowdsupply.com/1bitsquared/icebreaker-fpga)

[Fomu](https://www.crowdsupply.com/sutajio-kosagi/fomu)

[Alhambra](https://alhambrabits.com/alhambra/)

[ULX3S ECP5 board](https://radiona.org/ulx3s/)

## Retro computer resources

The [Mist](https://github.com/mist-devel/mist-board/wiki) and [Mister](https://github.com/MiSTer-devel/Main_MiSTer/wiki) projects are good sources of Retro Computing FPGA implementations, but many are in VHDL and need converting to Verilog. Most need some conversion to use the Blackice Mx SDRAM.

### 6502 CPU implementsations

There are several goof 6502 CPU implementations in Verilog. 

A commonly used one in [Arlet](https://github.com/Arlet/verilog-6502), which is used in the Acorn Atom project. One problem with this for some rettro computers is that it is not cycle-accurate.

The NES implementation has a [cycle-accurate microcode implementation](https://github.com/lawrie/up5k-demos/blob/master/nesmx/cpu.v).

### Z80 CPU implementations

There is a good Verilog microcoded Z80 implementation in [David Banks's CP/M Z80 implementation](https://github.com/hoglet67/Ice40CPMZ80/tree/master/src/Components/Z80).

## Other forums

There are other forums for ice40 FPGA boards. 

Some popular ones are:

[TinyFPGA](https://discourse.tinyfpga.com/)

[iCEBreaker](https://forum.icebreaker-fpga.com/)

## Chat Servers

### Freenode

Channels:

#mystorm

#yosys

##openfpga

###  Discord

1BitSquared #icebreaker

### Gitter

SpinalHDL/SpinalHDL

SpinalHDL/VexRiscv

## Twitter

Some Open FPGA twitter accounts:

@folknology Alan Wood

@oe1cxw Clofford Wolf

@fpga_dave Dave Shah

@ico_TC

@esden Piotr Esden-Tempski, creator of the iCEBreaker board

@zipcpu Dan Gisselquist

@TinyFPGA Luke Valenty

@mithro Tim Ansell, creator of the Fomu board

@RadionaOrg Creators of the ULX3S ECP5 board

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../LogicAnalysers/LogicAnalysers.html)|[Up](..) |[Next](..)|
