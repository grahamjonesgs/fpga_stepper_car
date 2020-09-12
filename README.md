# FPGA Stepper motor control

## Verilog Code
Code to control a stepper motor driven robot car using an FPGA. Built to use an Artix 7 based BASYS 3 or CMOD A7

Communicated through SPI bus to accept commands, based on 8 byte commands including a psudo CRC check. 

Separate control for four motors with individual direction and step control, plus outputs for three signal LEDs, with PWM baased pulsing. Variable speed control for either constant motion or for a fixed number of steps.

## Hardware tested
Tested to control stepper motors though TLP281 optical isolators driving CNC Shield V3 with DRV8825, driving NEMA 17 motors.

## Test code
Example Raspberry Pi based test harness, which could be used to base any car control system.

### Acknowledgements
SPI code based on SPI-slave code from [Nandland](https://github.com/nandland/spi-slave).

Raspberry Pi test harness code used [pigpio](http://abyz.me.uk/rpi/pigpio/).
