# SpinalHDL

SpinalHDL is an alternative Hardware Description Language (HDL). It is Domain Specific Language (DSL) based on the Scala language, and is much more powerful for generating hardware than Verilog.

I will show how it can be used on Blackice Mx to generate the same examples that were implemented in Verilog.

## Installation

Scala is a Java VM based language, so needs Java installed. It has a build system called SBT (Scala Build Tool) which allows Scala program to be compiled and executed from the command line, so that too must be installed.

The installation instructions are in the [SpinalTemplateSbt](https://github.com/SpinalHDL/SpinalTemplateSbt) project.

Once that is installed, clone my [SpinalBlackiceMx](https://github.com/lawrie/SpinalBlackiceMx) project.

## First example - LEDs

Here is how simple Blue LED example is written in SpinalHDL:

```scala
package mylib

import spinal.core._

class BlueLed extends Component {
  val io = new Bundle {
    val blueLed = out Bool
  }

  io.blueLed := ~True // LED is on when low
}

object BlueLed {
  def main(args: Array[String]) {
    BlackIceSpinalConfig.generateVerilog(new BlueLed)
  }
}
```

SpinalHDL programs are divided into packages, and import statements are used to import classes and objects from other packages. The spinal.core package contains the core of the SPINALHDL system, and spinal.lib is a library with many useful components.

Component is the equivalent of a Verilog Module.

The ports of a module are contained in a Bundle, which is conventionally called io.

A main method is required to generate the Verilog. I am using an object called BlackiceSpinalConfig to generate the verilog so that there is no top level reset signal.

The scala source files are in the src/scala/main/mylib directory. 

To generate the Verilog do:

```
cd SpinalBlackiceMx
sbt "runMain mylib.BlueLed"
```

This generates BlueLed.v:

```verilog
// Generator : SpinalHDL v1.3.5    git head : f0505d24810c8661a24530409359554b7cfa271a
// Date      : 06/11/2019, 16:39:57
// Component : BlueLed


module BlueLed (
      output  io_blueLed);
  assign io_blueLed = (! 1'b1);
endmodule
```

This simple example does not show the power of SpinalHDL.

To build and upload the example, do:

```
make VERILOG=BluedLed.v PCF=leds.pcf prog
```

and the blue LED should be on.

If you change the line:

```scala
    val blueLed = out Bool
```

to

```scala
    val blueLed = out(Reg(Bool))
```

Then the register version with a clock will be generated:

```verilog
module BlueLed (
      output reg  io_blueLed,
      input   clk);
  always @ (posedge clk) begin
    io_blueLed <= (! 1'b1);
  end

endmodule
```

Note that you do not need to change the assignment statement. The `:=` operator can be used whether a signal is declared as a register on not. For a register it will generate a non-blocking Verilog assignment using the `<=` operator.

Note also that you do not mention `clk`. Clock domains are dealt with implicitly by SpinalHDL.

If you want to set all 4 LEDs on,you could change:

```scala
    val blueLed = out Bool
```

to

```scala
    val leds = out Bits(4 bits)
```

and change the assignment to:

```scala 
    io.leds := 0 // LEDS are on when low
```
