# Simulation with Icarus Verilog (apt install iverilog). Run "make" to run all tests.
# Builds for the CMOD (12 Mhz) as set in defines.v.

SRC_DIR = ../fpga_car_controller/fpga_car_controller.srcs/sources_1/new
SRCS = $(SRC_DIR)/defines.v $(SRC_DIR)/SM_Output.v $(SRC_DIR)/SPI_Slave.v $(SRC_DIR)/SPI_Coms.v \
       $(SRC_DIR)/LED_Control.v $(SRC_DIR)/LED_Display_Controller.v $(SRC_DIR)/Car_Control_SPI.v
IVERILOG = iverilog -g2005

all: tb_SM_Output tb_Car_Control_SPI

tb_SM_Output: tb_SM_Output.vvp
	vvp -n $<

tb_Car_Control_SPI: tb_Car_Control_SPI.vvp
	vvp -n $<

tb_SM_Output.vvp: tb_SM_Output.v $(SRCS)
	$(IVERILOG) -o $@ $(SRC_DIR)/defines.v $(SRC_DIR)/SM_Output.v $<

tb_Car_Control_SPI.vvp: tb_Car_Control_SPI.v $(SRCS)
	$(IVERILOG) -o $@ $(SRCS) $<

clean:
	rm -f *.vvp *.vcd

.PHONY: all clean tb_SM_Output tb_Car_Control_SPI
