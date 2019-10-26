# Sensors

Sensors usually have an GPIO (digital), SPI, I2C, ADC or UART interface.

## Digital sensors

The simplest digital sensors are buttons and sliders which were covered in the built-in hardware chapter above.

### HC-SR04 ping sensor

![Ping Sensor][img2]

Other digital sensors measure a pulse. An HC-SR04 ultrasonic ping sensor is such a device. It uses an output (trigger) pin to request a range measurement and then measures the length of the pulse on an input (echo) pin.

This is supported in BlackSoC by mod_ping. See the [ping][] and [theremin][] examples. See also Robotics below, for another use of an HC-SR04 sensor.

[img2]:									./PingSensor.jpg "Ping Sensor"
[ping]:									https://github.com/lawrie/icotools/tree/master/icosoc/examples/ping
[theremin]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/theremin

### Rotary sensor

![Rotary Sensor][img3]

Other types of sensor use quadrature to count rotations. Two signals with a 90-degree phase difference allow the direction of rotation to be measured.

The encoders on encoder motors are also quadrature rotation sensors. See the Actuators and Robotics chapters.

[img3]:									./RotarySensor.jpg "Rotary Sensor"

|                        |                        |                        |
|------------------------|------------------------|------------------------|
|[Prev](../PicoSoC/PicoSoC.html)|[Up](..) |[Next](../StorageDevices/StorageDevices.html)|
