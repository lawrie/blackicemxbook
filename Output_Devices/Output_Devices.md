# Output Devices

## LEDs

If you need more LEDs than the 4 built-in ones, you can buy an LED Pmod. The [Digilent Pmod8LD][] has 8 leds, or you can make your own. An 8-LED Pmod is useful for simple diagnostics, displaying the value of a byte as a bit pattern.

[Digilent Pmod8LD]:		https://store.digilentinc.com/pmod-8ld-eight-high-brightness-leds/

![LEDs][img1]

[img1]:				./LEDs.jpg "LEDs"

Here is an example with the Pmod connected to Pmod 3 / 4.

Make a directory called leds8 and add:

leds.pcf

```
set_io clk 60

set_io leds[0] 34
set_io leds[1] 33
set_io leds[2] 29
set_io leds[3] 28
set_io leds[4] 38
set_io leds[5] 37
set_io leds[6] 32
set_io leds[7] 31
```

leds.v

```verilog
module leds(
  input clk,
  output reg [7:0] leds
);

  reg [19:0] counter;
  
  always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 0) leds <= leds + 1;
  end
 
endmodule
```

Makefile

```make
VERILOG_FILES = leds.v 
PCF_FILE = leds.pcf

include ../blackicemx.mk
```

## RGB LEDs

![RGB LEDs][img2]

RGB LEDS have three connections for red, green and blue, and can display combination of those colours, such as cyan, tallow and magenta.

A simple program to set the RGB according to three slider switches is as follows.
Connect an RGB LED to pins 1, 2 and 3 of Pmod 11 (top row). A breadboard adapter from the myStorm Pmod hackers kit can be used to do this. You need resistors on each of the RGB pins to limit the current.

[img2]:									./RGBLEDs.jpg "RGB LEDs"

Create a directory called rgbled and add:

rgbled.pcf:

	set_io rgb[0] 34
	set_io rgb[1] 33
	set_io rgb[2] 22
	
	set_io switch[0] 37
	set_io switch[1] 38
	set_io switch[2] 39

rgbled.v:

	module rgbled(
		input [2:0] switch,
		output [2:0] rgb
	);
	
		assign rgb = switch;
	
	endmodule

Makefile:

	VERILOG_FILES = rgbled.v
	PCF_FILE = rgbled.pcf

	Include ../blackice.mk

You can then use the first three dip switches on the board to set the colour of the RGB LED.

## Seven segment displays

### 2-Digit Digilent Pmod

![Dual 7 Segment LEDs][img3]

Digilent make the [PmodSSD][], a two-digit 7-segment display Pmod.

Seven segment displays are useful for diagnostics and as a simple user interface. They can display decimal or hex numbers.

Seven segment displays usually have a pin for each segment and another for the dot that optionally separates digits. The digits themselves are usually multiplexed, with a selector pin for each digit. Each digit must be selected, and its segments activated about one thousand times a second.

Here is an example of using a 7-segment display to 2-digit hex number. The example uses Pmod 7 and 9 (top row).

Note the code in this example is modified from that in Simon Monk’s Programming FPGAs book.

[img3]:									./7Segment.jpeg "Dual 7 Segment LEDs"
[PmodSSD]:								https://store.digilentinc.com/pmod-ssd-seven-segment-display/

Create a directory called hex7seg and add:

decoder_7_seg_hex.v:

	module decoder_7_seg_hex(
		input clk,
		input [3:0] d,
		output reg [6:0] seg
	);

		always @(posedge clk) 
		begin
			case(d)
				4'd0: seg <= 7'b1111110;
				4'd1: seg <= 7'b0110000; 
				4'd2: seg <= 7'b1101101;
				4'd3: seg <= 7'b1111001;
				4'd4: seg <= 7'b0110011;
				4'd5: seg <= 7'b1011011;
				4'd6: seg <= 7'b1011111;
				4'd7: seg <= 7'b1110000;
				4'd8: seg <= 7'b1111111;
				4'd9: seg <= 7'b1111011;
				4'hA: seg <= 7'b1110111;
				4'hB: seg <= 7'b0011111;
				4'hC: seg <= 7'b1001110;
				4'hD: seg <= 7'b0111101;
				4'hE: seg <= 7'b1001111;
				4'hF: seg <= 7'b1000111;
			endcase
		end

	endmodule

Add the multiplexer, display_7_seg_hex.v

	module display_7_seg_hex(
		input clk,
		input [7:0] n,
		output [6:0] seg,
		output reg digit
	);
		
		reg [3:0] digit_data;
		reg digit_posn;
		reg [23:0] prescaler;

		decoder_7_seg_hex decoder(.clk (clk), .seg(seg), .d(digit_data));   

		always @(posedge clk)
		begin
			prescaler <= prescaler + 24'd1;
			if (prescaler == 24'd50000) // 1 kHz
			begin
				prescaler <= 0;
				digit_posn <= digit_posn + 2'd1;
				if (digit_posn == 0)
				begin
					digit_data <= n[3:0];
					digit <= 4'b0;
				end
				if (digit_posn == 2'd1)
				begin
					digit_data <= n[7:4];
					digit <= 4'b1;
				end
			end
		end

	endmodule

Add seg_test.v

	module seg_test(
		input clk,
		output [6:0] seg,
		output digit
	);	
		
		display_7_seg_hex seghex (.clk(clk), .n(8'hfb), .seg(seg), .digit(digit));
	
	endmodule

And seg_test.pcf:

	set_io clk 129

	set_io digit  1

	set_io seg[0] 2
	set_io seg[1] 9
	set_io seg[2] 10
	set_io seg[3] 15
	set_io seg[4] 16
	set_io seg[5] 19
	set_io seg[6] 20

Add a Makefile:

	VERILOG_FILES = seg_test.v decoder_7_seg_hex.v display_7_seg_hex.v
	PCF_FILE = seg_test.pcf

	include ../blackice.mk

When you run this, you should see “fb”  appear on the display.

Seven segment displays are also supported by the BlackSoC mod_pmodssd module. See the [BlackSoC otl-demo example][].

[BlackSoC otl-demo example]:			https://github.com/lawrie/icotools/tree/master/icosoc/examples/otl-demo

### 8-digit SPI device

There are also 7-segment modules that use an SPI interface. They typically have multiple digits, such as this 8-digit version.

Here is a [BlackSoC example][] that displays a number on such a device.

![8 Digit SPI Device][img4]

[BlackSoC example]:						https://github.com/lawrie/icotools/tree/master/icosoc/examples/seg8
[img4]:									./8DigitSPIDevice.jpg "8 Digit SPI Device"

## LED Panels

You can use BlackSoC to drive an LED Panel. The [Towers of Hanoi][] example, which comes from icoSoC, uses the module mod_ledpanel to drive the panel.

![Towers Of Hanoi][img5]
![Towers Of Hanoi PCBs][img6]

The panel is an [Adafruit 32x32 one][]. It needs a 4A 12v power supply. The PCB for the Pmod comes from [bikerglen at OSHPark][].
There are other BlackSoC examples that use the LED panel including [Conway’s Game of Life][].

[Towers Of Hanoi]:						https://github.com/lawrie/icotools/tree/master/icosoc/examples/hanoi
[img5]:									./TowersOfHanoi.jpg "Towers Of Hanoi"
[img6]:									./TowersOfHanoiPCBs.jpg "Towers Of Hanoi PCBs"
[Adafruit 32x32 one]:					https://learn.adafruit.com/32x16-32x32-rgb-led-matrix/
[bikerglen at OSHPark]:					https://oshpark.com/shared_projects/pjxHdBL0
[Conway’s Game of Life]:				https://github.com/lawrie/icotools/tree/master/icosoc/examples/life

## VGA output

![VGA Output][img7]

Driving a VGA monitor required a Pmod such as the [Digilent PmodVGA][]. It uses 4-bits for each of the red, green and blue colours.

We will concentrate on supporting the standard 640 x 480 pixel resolution, but it is possible to support higher frequencies.

A clock for 640 x 480 VGA can be produced in a few different ways. Using a pre-scaler to divide the 100 Mhz clock by 3 to produce a 33.3Mhz clock works, but is slightly out of spec. Using a pre-scaler to produce a 25Mhz clock works, but not all VGA monitors support that frequency. Using a PLL to produce a 31.5 Mhz clock is the most accurate way.

We will use the pong example from the fpgafun web site to demonstrate VGA output. The only change to the code from the fpgafun.com is the addition of the 31.5Mhz clock using a PLL. This means that we are not using the full 4-bit VGA output. Instead we map the single R, G and B signals used by the code to the pin corresponding to the most significant bit of the 4-bits used by the Digilent Pmod.

This example needs a Digilent VGA Pmod in Pmods 7/8/9/10 and a rotary encoder for moving the paddle in Pmod3, pins 1 and 2 (top row). Rotary sensors are explained in the Sensors chapter below.

[img7]:									./VGAOutput.jpg "VGA Output"
[Digilent PmodVGA]:						https://store.digilentinc.com/pmod-vga-video-graphics-array/

Make a directory called pong, and add:

pong.v

	// Pong VGA game
	// (c) fpga4fun.com

	module pong(clk100, vga_h_sync, vga_v_sync, vga_R, vga_G, vga_B, quadA, quadB);
	input clk100;
	output vga_h_sync, vga_v_sync, vga_R, vga_G, vga_B;
	input quadA, quadB;

	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [8:0] CounterY;
	wire clk;

	SB_PLL40_CORE #(
		 .FEEDBACK_PATH("SIMPLE"),
		 .DIVR(4'b1001),         // DIVR =  9
		 .DIVF(7'b1100100),      // DIVF = 100
		 .DIVQ(3'b101),          // DIVQ =  5
		 .FILTER_RANGE(3'b001)   // FILTER_RANGE = 1
	) uut (
		 .RESETB(1'b1),
		 .BYPASS(1'b0),
		 .REFERENCECLK(clk100),
		 .PLLOUTCORE(clk)
	);

	hvsync_generator syncgen(.clk(clk), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), 
		.inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));

	/////////////////////////////////////////////////////////////////
	reg [8:0] PaddlePosition;
	reg [2:0] quadAr, quadBr;
	always @(posedge clk) quadAr <= {quadAr[1:0], quadA};
	always @(posedge clk) quadBr <= {quadBr[1:0], quadB};

	always @(posedge clk)
	if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
	begin
		if(quadAr[2] ^ quadBr[1])
		begin
			if(~&PaddlePosition)        // make sure the value doesn't overflow
				PaddlePosition <= PaddlePosition + 1;
		end
		else
		begin
			if(|PaddlePosition)        // make sure the value doesn't underflow
				PaddlePosition <= PaddlePosition - 1;
		end
	end

	/////////////////////////////////////////////////////////////////
	reg [9:0] ballX;
	reg [8:0] ballY;
	reg ball_inX, ball_inY;

	always @(posedge clk)
	if(ball_inX==0) ball_inX <= (CounterX==ballX) & ball_inY; else ball_inX <= !(CounterX==ballX+16);

	always @(posedge clk)
	if(ball_inY==0) ball_inY <= (CounterY==ballY); else ball_inY <= !(CounterY==ballY+16);

	wire ball = ball_inX & ball_inY;

	/////////////////////////////////////////////////////////////////
	wire border = (CounterX[9:3]==0) || (CounterX[9:3]==79) || (CounterY[8:3]==0) || (CounterY[8:3]==59);
	wire paddle = (CounterX>=PaddlePosition+8) && (CounterX<=PaddlePosition+120) && (CounterY[8:4]==27);
	wire BouncingObject = border | paddle; // active if the border or paddle is redrawing itself

	reg ResetCollision;
	always @(posedge clk) ResetCollision <= (CounterY==500) & (CounterX==0);  // active only once for every video frame

	reg CollisionX1, CollisionX2, CollisionY1, CollisionY2;
	always @(posedge clk) if(ResetCollision) CollisionX1<=0; else if(BouncingObject & (CounterX==ballX   ) & (CounterY==ballY+ 8)) CollisionX1<=1;
	always @(posedge clk) if(ResetCollision) CollisionX2<=0; else if(BouncingObject & (CounterX==ballX+16) & (CounterY==ballY+ 8)) CollisionX2<=1;
	always @(posedge clk) if(ResetCollision) CollisionY1<=0; else if(BouncingObject & (CounterX==ballX+ 8) & (CounterY==ballY   )) CollisionY1<=1;
	always @(posedge clk) if(ResetCollision) CollisionY2<=0; else if(BouncingObject & (CounterX==ballX+ 8) & (CounterY==ballY+16)) CollisionY2<=1;

	/////////////////////////////////////////////////////////////////
	wire UpdateBallPosition = ResetCollision;  // update the ball position at the same time that we reset the collision detectors

	reg ball_dirX, ball_dirY;
	always @(posedge clk)
	if(UpdateBallPosition)
	begin
		if(~(CollisionX1 & CollisionX2))        // if collision on both X-sides, don't move in the X direction
		begin
			ballX <= ballX + (ball_dirX ? -1 : 1);
			if(CollisionX2) ball_dirX <= 1; else if(CollisionX1) ball_dirX <= 0;
		end

		if(~(CollisionY1 & CollisionY2))        // if collision on both Y-sides, don't move in the Y direction
		begin
			ballY <= ballY + (ball_dirY ? -1 : 1);
			if(CollisionY2) ball_dirY <= 1; else if(CollisionY1) ball_dirY <= 0;
		end
	end 

	/////////////////////////////////////////////////////////////////
	wire R = BouncingObject | ball | (CounterX[3] ^ CounterY[3]);
	wire G = BouncingObject | ball;
	wire B = BouncingObject | ball;

	reg vga_R, vga_G, vga_B;
	always @(posedge clk)
	begin
		vga_R <= R & inDisplayArea;
		vga_G <= G & inDisplayArea;
		vga_B <= B & inDisplayArea;
	end

	endmodule
	
Get [hvsync_generator.v][] from the fpga.fun site.

[hvsync_generator.v]:					https://www.fpga4fun.com/files/hvsync_generator.zip

pong.pcf

	set_io   clk100   129
	set_io   vga_h_sync  8
	set_io   vga_v_sync   7
	set_io   vga_R      15
	set_io   vga_G     1
	set_io   vga_B      11
	set_io   quadA     105
	set_io   quadB     102

And a Makefile:

	VERILOG_FILES = pong.v hsync_generator.v
	PCF_FILE = pong.pcf

	include ../blackice.mk

Use the rotary encoder to move the paddle.

## VGA Text

![VGA Text][img8]

BlackSoC contains a module for writing text to a VGA monitor with 30 rows of 80 column text. There is an [example program][] for it, which reads text from /dev/ttyUSB0 and writes it to the screen.

[img8]:									./VGAText.jpg "VGA Text"
[example program]:						https://github.com/lawrie/icotools/tree/master/icosoc/examples/vga_text

## Neopixels

![Neopixels][img9]

WS2811, WS2812 and WS2812B neopixel strips use PWM signals over a single wire to switch and set the colour of each pixel in a strip. Longer strips need a separate power supply.

Here is [an example][] of driving a short 8 neopixel strip.

[img9]:									./NeoPixels.jpg "Neopixels"
[an example]:							https://github.com/lawrie/verilog_examples/tree/master/fpga/ws2812b

## OLED displays

### I2C OLED displays

![I2C Display][img10]
![I2C Display][img11]

Some of the cheaper OLED displays are driven by I2C. There are cheap 4-pin modules available on edbay and elsewhere that can be plugged in to a Pmod header via a simple homemade adapter or even directly into the Pmod header (or via a connecting cable) if VCC and GND are in the correct position. An I2C master module, mod_i2c_master, has been added to BlackSoC, with an [example program][]. The module in the picture uses two colours, but they are fixed and not variable by software. The top lines of that display use yellow text and the other lines blue.

It is harder to access i2c oled displays and other i2c devices without a soft processor as they have complex sequences of commands for initialisation and writing data. However it is not too hard to set up a ROM with the appropriate initialisation commands.

[img10]:								./I2CDisplay.jpg "I2C Display"
[img11]:								./I2CDisplay2.jpg "I2C Display"
[example program]:						https://github.com/lawrie/icotools/tree/master/icosoc/examples/ssd1306

### SPI OLED displays

![SPI OLED Displays][img12]

OLED displays such sssd1306, ssd1351 etc. Are driven either by the SPI or I2C protocol.

Icosoc has an implementation of an SPI master in mod_spi which is also in BlackSoC.

The OLED displays use a variant of SPI that is output only and so has no MISO pin, and which has an extra pin (DC) to distinguish between commands and data. They also have a reset pin. To cope with this a new BlackSoC module, mod_spi_oled has been produced.

There are BlackSoC examples for a variety of monochrome and RGB SPI OLED displays: the [ssd1306 or sh1106][], the [ssd1331][] and the [ssd1335][].

[img12]:								./SPIOLEDDisplay.jpg "SPI OLED Displays"
[ssd1306 or sh1106]:					https://github.com/lawrie/icotools/tree/master/icosoc/examples/spi1306
[ssd1331]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/ssd1331
[ssd1335]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/ssd1335

## LCD Displays

### LCD Text Displays

There are a lot of different types of LCD display. A common one is a two-line character LCD. The one in the picture is a Grove I2C RGB-backlit two-line character LCD.

There are two types of these 2-line text LCDs : serial-connected or parallel connected.

#### Serial-connected text LCDs

![Serial Connected Text LCD][img13]

There are separate I2C devices for the backlight and the character display. The character display needs a 5v supply, which can be taken from the Arduino header on the BlackIce II.

The i2c_master module in BlackSoC can be used to drive both devices, as in the BlackSoC [grovelcd example][].

[img13]:								./SerialConnectedTextLCD.jpg "Serial Connected Text LCD"
[grovelcd example]:						https://github.com/lawrie/icotools/blob/master/icosoc/examples/grovelcd/main.c

#### Parallel-connected text LCDs

![Parallel Connected Text LCD][img14]

The [fpgafun site][] shows how to drive these displays, and [here][] is the example, modified to run on the BlackIce II. You can send command to it from the command line e.g.

echo -n -e “\x00\x01” >/dev/ttyUSB0

to reset it.

[img14]:								./ParallelConnectedTextLCD.jpg "Parallel Connected Text LCD"
[fpgafun site]:							https://www.fpga4fun.com/TextLCDmodule.html
[here]:									https://github.com/lawrie/verilog_examples/blob/master/fpgafun/textlcd/

### Graphics LCDs

To be supplied.
