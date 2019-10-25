# Input devices

## PS/2 Keyboards

![Keyboard][img1]

It is not possible to use USB keyboards with BlackIce but PS/2 keyboards work as long as they are OK with 3.3v logic. Microsoft wireless keyboards work (as shown above), as do most HP ones. The Microsoft Wireless receiver needs more power than the Blacice Mx board can provide, and probably needs %v. So I am using a battery pack connected to the power input header on the PS/2 Pmod to supply %v.

[Here][] is an example based on code on code by David Banks (@hoglet67).

It reads the key and writes the scan codes received in hex to  the uart (dev/ttyACM0). The can codes need to be converted to ascii for most uses.

[img1]:									./Keyboard.jpg "Keyboard"
[Here]:									https://github.com/lawrie/blackicemxbook/tree/master/examples/input/ps2

## DIP switches

![DIP Switches][img3]

Dip switches can  be useful for configuration. Here is [a very simple example of using the DIP switches][] or a homemade Pmod to set LEDs on a Digilent 8 LED strip. There are 4 dip switches on the myStorm 7-segment display Pmod.

[img3]:									                            ./DIPSwitches.jpg "DIP Switches"
[a very simple example of using the DIP switches]:	https://github.com/lawrie/verilog_examples/tree/master/ebook/input/switches8

## Keypads

Digilent make a keypad Pmod, but it is easy to make your own. 

![Keypad][img4]

There is an output pin for each column of the keypad, and an input with a pull-up resistor for each row. 3 columns and 4 rows in this case. You need to apply a voltage to the columns in turn and then read the input pins. This needs to be done repeatedly to read the input key in a timely way.

Here is [an example][] that reads the keys and displays the latest key pressed on the leds. The value is represented in 4 bits with 0-9 taking their naturals values and & being 10, and #, 11.


Numeric keypads are useful for some applications where a full keyboard is overkill.

[img4]:									./Keypad.jpg "Keypad"
[an example]:							https://github.com/lawrie/verilog_examples/tree/master/fpga/keypad

## Mice

PS/2 mice can be connected to the BlackIce II using the same Digilent PS/2 Pmos that is used for keyboards.
