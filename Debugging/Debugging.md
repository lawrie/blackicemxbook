|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Soft_Processors/Soft_Processors.html)|[Up](..) |[Next](../Simulation/Simulation.html)|

# Debugging

Debugging hardware components is difficult. You can't step through your code with a debugger or add debugging print statements as you can with software.

## Simulation

The closest you can get to the is to run your Verilog code in a simulator such as iVerilog or Verilator. When you use this in conjucntion with a wave file viewer such as gtkwave, you can see the history of how each variable (wire or register) in your design changes each clock cycle. This is very useful for checking that your logic is working as you expect and for finding bugs. It does, however, take quite a bit of work to set up test scripts and to write simulated versions of components, so that you can narrow in on the portion of your design that you are interested in. For more detail on simulation, see the Simulation chapter.

## Formal methods

Even better than simulation is to use formal methods to mathematically prove that your design is correct. However, setting this up can be complex, so it is probably not for beginners. 

There is a very good series of articles by Dan Gisselquist starting with his [blog post](https://zipcpu.com/blog/2017/10/19/formal-intro.html) on how he started with formal methods. And the instructions for setting up the Formal methods tools are [here](https://symbiyosys.readthedocs.io/en/latest/quickstart.html).

## Diagnostic outputs

Another useful technique is to have your components produce diagnostic outputs. This is a set of signals that you can examine to see if your component is working correctly. You can pass these diagnostic outputs up through a chain of components, so that they are available at the top level, where they can be examined in a variety of ways.

## Test points

You can connect test points to Pmods and Mixmods to make it easier to examine diagnostic outputs with an oscilloscope or a logic analyser.

Digilent sell a [double Pmod test point](https://store.digilentinc.com/pmod-tph2-12-pin-test-point-header/) and you can buy Mixmod test points with your Blackice Mx from the Tindie store. Note however, that the wiring for the Mixmod test point is [currently incorrect](https://forum.mystorm.uk/t/test-mixmod-pinout/620).

## Oscilloscopes

You can use an oscilloscope with a test point to examine an output signal. It is particularly useful to check if the frequency and duty cycle of a sqare wave output such as vertical or horizontal sunc signals for video output, or for PWM outputs.

## Logic analysers

For digital circuits logic analysers are usually more useful than oscilloscopes. You can buy a commercial logic analyser to examine diagnostic signals using test points, or you can build a logic analyser using another Blackice Mx - see the Logic Analysers chapter.

The host software for logic analysers, such as Pulseview, have decoders for common protocols like UART, I2C and SPI, and give you a high level view of the data being transferred.

## LEDs

One of the simplest techniques for debugging is to use LEDs to show the value of individual pins, or to use a bank of LEDs to show multi-bit items. Note that the user LEDS on the Blackice Mx on on when the signal is low, so you might have to negate signals.

LEDs only works in simple cases and a logic analyser is usually preferable.

You can use a single LED to see if a specific path through your Verilog code is being reached. You can display slow-changing values on LEDs, but may need to slow down your component with delay counters to make this feasible. You can also display the final value of variables on leds, to check it is as expected.

## 7-segment displays

7-segment LED displsays are also useful for displaying diagnostic values, either in decimal of hex.

## UART 

The UART is useful for sending debugging messages to. [Here][] is an example of a debug module being used to show the key codes coming from a PS/2 keyboard.

[Here]:									https://github.com/lawrie/blackicemxbook/tree/master/examples/input/ps2

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../Soft_Processors/Soft_Processors.html)|[Up](..) |[Next](../Simulation/Simulation.html)|
