# Introduction
##	Field Programmable Gate Arrays
Field Programmable Gate Arrays (FPGAs) are extremely flexible devices that allow you to implement hardware components by configuring an array of logic gates, RAM and other resources via software.

All the components run independently and in parallel and talk to the outside world via the large set of pins.

One (or more) of the components can be a soft processor that can implement any Instruction Set Architecture (ISA) that you desire.

The FPGA can therefore implement a CPU and associated peripherals, which is known as a System on a Chip (SoC).

An FPGA SoC is slower than a dedicated hardware SoC, as used, for example, for mobile phones. But it is much more flexible.

##	Open Source Fpgas
FPGAs have always, until very recently, used large proprietary, complex suites of software to program them. That changed when Clifford Wolf and others produced the [icestorm][] open source toolset in 2016. Icestorm ushered in the era of Open Source FPGA programming.

[icestorm]:		http://www.clifford.at/icestorm/

##	This Book
This ebook gives practical examples on how to use [Lattice Ice40][] FPGAs to drive a variety of hardware, and to implement a variety of projects.

It uses the open source icestorm toolchain and assumes you are using a Linux development machine. It is fairly simple to convert the examples to use the apio tools, which can run on Microsoft Windows. The examples will work with minimal changes on MAC OSX.

The examples have all been run on the myStorm BlackIce II board but will work with some modification for other Ice40 boards.

All the examples are in [Verilog][]. This book is not a tutorial on Verilog. A working knowledge of Verilog is assumed.
The source of the examples in this book is available in a [Github repository][]. 

[Lattice Ice40]:		http://www.latticesemi.com/Products/FPGAandCPLD/iCE40
[Verilog]:				https://en.wikipedia.org/wiki/Verilog
[Github repository]:	https://github.com/lawrie/verilog_examples/tree/master/ebook
