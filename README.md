# FPGA Stepper motor control

Code to control a stepper motor driven robot car using an FPGA. Built to use an Artix 7 based BASYS 3 or CMOD A7

Communicated through SPI bus to accept commands. Contains Raspberry Pi based test harness

Separate control for four motors with individual direction and step control, plus outputs for three signal LEDs. Variable speed control for either constant motion or for a fixed number of steps.

## Hardware tested
Tested to control stepper motors though TLP281 optical isolators driving CNC Shield V3 with DRV8825, driving NEMA 17 motors.

## Acknowledgements
SPI code based on SPI-slave code from [Nandland](https://github.com/nandland/spi-slave).
