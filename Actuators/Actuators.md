|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../StorageDevices/StorageDevices.html)|[Up](..) |[Next](../STM32Programming/STM32Programming.html)|

# Actuators

## Servos

![Servos][img1]

Servos are motors that are used to position things. They do not turn continuously, but can be set to a specific angle, in a range, typically, of between 180 and 270 degrees.

The angle is determined by the duty cycle of a PWM signal.

Servos cannot normally be driven by the BlackIce II power supply but require a separate power supply of at least 5 volts.

A servo has three connections: Vcc, Gnd and the PWM signal.

You can connect servos to BlackIce using a [Digilent CON3 R/C Servo Pmod][], or just using breadboard wires.

Here is a [BlackSoC servo example][] using BlackSoC’s mod_pwm.

[img1]:									./Servos.jpg "Servos"
[Digilent CON3 R/C Servo Pmod]:			https://store.digilentinc.com/pmod-con3-r-c-servo-connectors/
[BlackSoC servo example]:				https://github.com/lawrie/icotools/tree/master/icosoc/examples/servo

## Gear Motors

Gear motors are DC motors that turn continuously and have internal gears that determine how fast they turn in revs per minute (RPM). The speed of the motors is either quoted as the maximum RPM or the gear ratio used.

They usually have a + and a – connection and the voltage difference between these determines the direction of the motor and its speed. A PWM signal is usually applied at full positive or negative voltage rather than using an analog voltage.

Gear motors need a motor driver such as an H-bridge to handle the power going to the motor. The [Digilent DHB1 Dual H-bridge Pmod][] is suitable for this. It uses two pins to drive the motor: one digital signal to specify the direction and a PWM signal to specify the power.

[Digilent DHB1 Dual H-bridge Pmod]:		https://store.digilentinc.com/pmod-dhb1-dual-h-bridge/

![Dual H-Brige Pmod][img2]

[img2]:									./DualHBridgePmod.jpg "Dual H-Brige Pmod"

## Encoder Motors

Encoder motors are gear motors with encoders attached which measure the speed of rotation of the motor. The encoders can be optical or can use hall effect magnetic sensors. Two hall effect sensors are used at 90 degrees to each which count the turns of the DC motor before its gearing, so with high precision. The two sensors at 90 degrees allow the direction of the motor to be determined using a quadrature signal over two wires: quadA and quadB.

The encoder has its own (typically 3.3v power connection) and so has 4 wires. There are therefore 6 wires going to an encoder motor.

The Digilent DBH1 Pmod handles two encoder motors. If you use Digilent’s own motors, you can use the 6-pin JST connectors.

![Encoder Motors][img3]
 
The [BlackSoC motor example][] can be used to test encoder motors. See also the Robotics section below.

[img3]:									./EncoderMotors.jpg "Encoder Motors"
[BlackSoC motor example]:				https://github.com/lawrie/icotools/tree/master/icosoc/examples/motor

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../StorageDevices/StorageDevices.html)|[Up](..) |[Next](../STM32Programming/STM32Programming.html)|
