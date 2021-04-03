# FPGA Stepper motor control

Build to control stepper motors, with smooth rotation and ability to count steps exactly.

## Verilog Code
Code to control a stepper motor driven robot car using an FPGA. Built to use an Artix 7 based BASYS 3 or CMOD A7. 
Tested with Vivaldo 2020.1. To build, open with Vivado, activate the appropriate contraint file by right clicking and selecting "Make Actve...". Update file "defines.v" to define the Macro for the chosen board.

## Functionality
Communicates through SPI bus to accept commands, and give status, based on 8 byte command/status message, with start message type byte and one checksum byte. SPI message definition given in top module, with example of calling given in the *spi_test.c* test file.

Allows separate control for four motors with individual direction and step control, plus outputs for three signal LEDs, with PWM based pulsing. Variable speed control for either constant motion or for a fixed number of steps. 

## Hardware tested
Tested to control stepper motors though TLP281 optical isolators driving CNC Shield V3 with DRV8825, driving NEMA 17 motors.

## Test code
Example Raspberry Pi based test harness, which could be used to base any car control system.

## Wiring
### SPI Bus to Pi
``              CMOD A7.       PI Zero``

``o_SPI_Gnd     U3 Pin 44      GPIO -- Pin 25`` 

``o_SPI_MISO    U7 Pin 45      GPIO 09 Pin 21``

``i_SPI_CS      W7 Pin 46      GPIO 08 Pin 24``

``i_SPI_Clk     U8 Pin 47      GPIO 11 Pin 23``

``i_SPI_MOSI    V8 Pin 48      GPIO 10 Pin 19``




### Acknowledgements
SPI code based on SPI-slave code from [Nandland](https://github.com/nandland/spi-slave).

Raspberry Pi test harness code uses [pigpio](http://abyz.me.uk/rpi/pigpio/).


