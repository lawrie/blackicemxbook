# Sensors

Sensors usually have an GPIO (digital), SPI, I2C, ADC or UART interface.

## Digital sensors

The simplest digital sensors are buttons and sliders which were covered in the built-in hardware chapter above.

### BlackSoC support for digital sensors

BlackSoC contains a module, mod_timer, that can be used to generate an interrupt on button presses.  It also support mod_pwm that can be used to generate PWM outputs on digital pins, including simple audio output.

Other digital sensors are supported by mod_gpio in BlackSoC, for example mechanical and capacitive button, led and buzzer Grove sensors:

![Assorted Digital Sensors][img1]

[img1]:									./AssortedDigitalSensors.jpg "Assorted Digital Sensors"

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

This is supported by mod_rotary in BlackSoC. See the [rotary][] example. See also the pong VGA output example in the Output devices chapter.

The encoders on encoder motors are also quadrature rotation sensors. See the Actuators and Robotics chapters.

[img3]:									./RotarySensor.jpg "Rotary Sensor"
[rotary]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/rotary

## I2C sensors

A lot of sensors use the I2C interface. 

Examples are the BME 280 temperature, atmospheric and humidity sensor, and the STM time of flight laser sensor.

These sensors can be driven in BlackSoC by the mod_i2c_master module.

### BME 280

![BME 280][img4]

The [BME 280][] example and the [Weather][] example in BlackSoC, use the BME 280 sensor.

[img4]:									./BME280.jpg "BME 280"
[BME 280]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/bme280
[Weather]:								https://github.com/lawrie/icotools/tree/master/icosoc/examples/weather


12.2.2 STM Time of Flight sensor

![Time of Flight Sensor][img5]

The [Time of Flight] example uses the STM time of flight sensor.

![Time of Flight Sensor in use][img6]

[img5]:									./TimeOfFlightSensor.jpg "Time of Flight Sensor"
[Time of Flight]:						https://github.com/lawrie/icotools/tree/master/icosoc/examples/timeofflight
[img6]:									./TimeOfFlightSensorInUse.jpg "Time of Flight Sensor in use"

### DS 1307 Real Time Clock

![DS1307 Real Time Clock][img7]

The [BlackSoC rtc example][] uses the DS1307 sensor.

[img7]:									./DS1307RTC.jpg "DS1307 Real Time Clock"
[BlackSoC rtc example]:					https://github.com/lawrie/icotools/tree/master/icosoc/examples/rtc

## SPI sensors

![ACL 2 Sensor][img8]

Some sensors, such as the Digilent ACL 2 Pmod acceleration sensor, use the SPI interface.

This is supported by mod_spi in BlackSoC. See the [acl2][] example.

Another SPI sensor is the Digilent AD 1 12-bit dual 1MSPS ADC sensor.  The [BlackSoC ad1 example][] uses that sensor.

[img8]:									./ACL2Sensor.jpg "ACL 2 Sensor"
[acl2]:									https://github.com/lawrie/icotools/tree/master/icosoc/examples/acl2
[BlackSoC ad1 example]:					https://github.com/lawrie/icotools/tree/master/icosoc/examples/ad1

## UART sensors

Some sensors use a UART interface, such as most of the LEGO Mindstorms EV3 sensors – see the chapter below.

These are supported by mod_rs232 in BlackSoC. Most of the devices in the Communication devices chapter use uart.

## Analog sensors

![Analogue Sensor][img9]

Some sensors use an analog interface, which requires and analog to digital converter (ADC) such as the Digilent AD1 described above. The [BlackSoC ad1 example][] can be used to show the values coming from the joystick.

[img9]:								./AnalogueSensor.jpg "Analogue Sensor"
[BlackSoC ad1 example]:					https://github.com/lawrie/icotools/tree/master/icosoc/examples/ad1