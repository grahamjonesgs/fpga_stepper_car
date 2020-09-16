set_property SRC_FILE_INFO {cfile:{/home/graham/Documents/fpga_stepper_car/fpga_car_controller/fpga_car_controller.srcs/CMOD/imports/new/Constraint CMOD.xdc} rfile:{../../../fpga_car_controller.srcs/CMOD/imports/new/Constraint CMOD.xdc} id:1} [current_design]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { i_sysclk }]; #IO_L12P_T1_MRCC_14 Sch=gclk
set_property src_info {type:XDC file:1 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports o_Enable_LED]; #IO_L12N_T1_MRCC_16 Sch=led[1]
set_property src_info {type:XDC file:1 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports  i_reset]; #IO_L19N_T3_VREF_16 Sch=btn[0]
set_property src_info {type:XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports o_Left_Front_Dir ]; #IO_L5N_T0_D07_14 Sch=ja[1]
set_property src_info {type:XDC file:1 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports o_Left_Back_Dir]; #IO_L4N_T0_D05_14 Sch=ja[2]
set_property src_info {type:XDC file:1 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports o_Right_Front_Dir]; #IO_L9P_T1_DQS_14 Sch=ja[3]
set_property src_info {type:XDC file:1 line:27 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports o_Right_Back_Dir]; #IO_L8P_T1_D11_14 Sch=ja[4]
set_property src_info {type:XDC file:1 line:28 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports o_Left_Front_Step]; #IO_L5P_T0_D06_14 Sch=ja[7]
set_property src_info {type:XDC file:1 line:29 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports o_Left_Back_Step]; #IO_L4P_T0_D04_14 Sch=ja[8]
set_property src_info {type:XDC file:1 line:30 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports o_Right_Front_Step]; #IO_L6N_T0_D08_VREF_14 Sch=ja[9]
set_property src_info {type:XDC file:1 line:31 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports o_Right_Back_Step]; #IO_L8N_T1_D12_14 Sch=ja[10]
set_property src_info {type:XDC file:1 line:76 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports o_Aux_Gnd]; #IO_L16N_T2_34 Sch=pio[39]
set_property src_info {type:XDC file:1 line:77 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W4    IOSTANDARD LVCMOS33 } [get_ports o_Enable]; #IO_L12N_T1_MRCC_34 Sch=pio[40]
set_property src_info {type:XDC file:1 line:78 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports o_Green_led]; #IO_L16P_T2_34 Sch=pio[41]
set_property src_info {type:XDC file:1 line:79 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U2    IOSTANDARD LVCMOS33 } [get_ports o_Blue_led]; #IO_L9N_T1_DQS_34 Sch=pio[42]
set_property src_info {type:XDC file:1 line:80 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports o_Red_led]; #IO_L13N_T2_MRCC_34 Sch=pio[43]
set_property src_info {type:XDC file:1 line:81 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports o_SPI_Gnd]; #IO_L9P_T1_DQS_34 Sch=pio[44]
set_property src_info {type:XDC file:1 line:82 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports o_SPI_MISO]; #IO_L19P_T3_34 Sch=pio[45]
set_property src_info {type:XDC file:1 line:83 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports i_SPI_CS]; #IO_L13P_T2_MRCC_34 Sch=pio[46]
set_property src_info {type:XDC file:1 line:84 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports i_SPI_Clk]; #IO_L14P_T2_SRCC_34 Sch=pio[47]
set_property src_info {type:XDC file:1 line:85 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports i_SPI_MOSI]; #IO_L14N_T2_SRCC_34 Sch=pio[48]
