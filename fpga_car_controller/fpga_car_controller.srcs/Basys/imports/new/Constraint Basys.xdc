# Clock signal
set_property PACKAGE_PIN W5 [get_ports i_sysclk]
set_property IOSTANDARD LVCMOS33 [get_ports i_sysclk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports i_sysclk]

set_property PACKAGE_PIN U18 [get_ports i_reset]
set_property IOSTANDARD LVCMOS33 [get_ports i_reset]
#seven-segment LED display
set_property PACKAGE_PIN V7 [get_ports {o_LED_cathode[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[7]}]
set_property PACKAGE_PIN W7 [get_ports {o_LED_cathode[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[6]}]
set_property PACKAGE_PIN W6 [get_ports {o_LED_cathode[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[5]}]
set_property PACKAGE_PIN U8 [get_ports {o_LED_cathode[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[4]}]
set_property PACKAGE_PIN V8 [get_ports {o_LED_cathode[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[3]}]
set_property PACKAGE_PIN U5 [get_ports {o_LED_cathode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[2]}]
set_property PACKAGE_PIN V5 [get_ports {o_LED_cathode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[1]}]
set_property PACKAGE_PIN U7 [get_ports {o_LED_cathode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_LED_cathode[0]}]
set_property PACKAGE_PIN U2 [get_ports {o_Anode_Activate[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Anode_Activate[0]}]
set_property PACKAGE_PIN U4 [get_ports {o_Anode_Activate[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Anode_Activate[1]}]
set_property PACKAGE_PIN V4 [get_ports {o_Anode_Activate[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Anode_Activate[2]}]
set_property PACKAGE_PIN W4 [get_ports {o_Anode_Activate[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Anode_Activate[3]}]


set_property PACKAGE_PIN U16 [get_ports {o_Right_Front_Dir_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Front_Dir_LED}]
set_property PACKAGE_PIN E19 [get_ports {o_Right_Back_Dir_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Back_Dir_LED}]
set_property PACKAGE_PIN U19 [get_ports {o_Left_Front_Dir_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Front_Dir_LED}]
set_property PACKAGE_PIN V19 [get_ports {o_Left_Back_Dir_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Back_Dir_LED}]
set_property PACKAGE_PIN W18 [get_ports {o_Right_Front_Step_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Front_Step_LED}]
set_property PACKAGE_PIN U15 [get_ports {o_Right_Back_Step_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Back_Step_LED}]
set_property PACKAGE_PIN U14 [get_ports {o_Left_Front_Step_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Front_Step_LED}]
set_property PACKAGE_PIN V14 [get_ports {o_Left_Back_Step_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Back_Step_LED}]
#set_property PACKAGE_PIN V13 [get_ports {o_led[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {o_led[8]}]
#set_property PACKAGE_PIN V3 [get_ports {o_led[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {o_led[9]}]
#set_property PACKAGE_PIN W3 [get_ports {o_led[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {o_led[10]}]
#set_property PACKAGE_PIN U3 [get_ports {o_led[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {o_led[11]}]
set_property PACKAGE_PIN P3 [get_ports {o_Red_led_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Red_led_LED}]
set_property PACKAGE_PIN N3 [get_ports {o_Blue_led_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Blue_led_LED}]
set_property PACKAGE_PIN P1 [get_ports {o_Green_led_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Green_led_LED}]
set_property PACKAGE_PIN L1 [get_ports {o_Enable_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Enable_LED}]

#set_property PACKAGE_PIN V17 [get_ports {i_switch[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[0]}]
#set_property PACKAGE_PIN V16 [get_ports {i_switch[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[1]}]
#set_property PACKAGE_PIN W16 [get_ports {i_switch[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[2]}]
#set_property PACKAGE_PIN W17 [get_ports {i_switch[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[3]}]
#set_property PACKAGE_PIN W15 [get_ports {i_switch[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[4]}]
#set_property PACKAGE_PIN V15 [get_ports {i_switch[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[5]}]
#set_property PACKAGE_PIN W14 [get_ports {i_switch[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[6]}]
#set_property PACKAGE_PIN W13 [get_ports {i_switch[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[7]}]
#set_property PACKAGE_PIN V2 [get_ports {i_switch[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[8]}]
#set_property PACKAGE_PIN T3 [get_ports {i_switch[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[9]}]
#set_property PACKAGE_PIN T2 [get_ports {i_switch[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[10]}]
#set_property PACKAGE_PIN R3 [get_ports {i_switch[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[11]}]
#set_property PACKAGE_PIN W2 [get_ports {i_switch[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[12]}]
#set_property PACKAGE_PIN U1 [get_ports {i_switch[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[13]}]
#set_property PACKAGE_PIN T1 [get_ports {i_switch[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[14]}]
#set_property PACKAGE_PIN R2 [get_ports {i_switch[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {i_switch[15]}]

##Pmod Header JA Enable and direction pins
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {o_Left_Front_Dir}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Front_Dir}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {o_Left_Back_Dir}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Back_Dir}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {o_Right_Front_Dir}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Front_Dir}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {o_Right_Back_Dir}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Back_Dir}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {o_Left_Front_Step}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Front_Step}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {o_Left_Back_Step}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Left_Back_Step}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {o_Right_Front_Step}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Front_Step}]
##Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {o_Right_Back_Step}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_Right_Back_Step}]

##Pmod Header JB - Control lines and signals
##Sch name = JB1
#set_property PACKAGE_PIN A14 [get_ports {o_Enable}]
#set_property IOSTANDARD LVCMOS33 [get_ports {o_Enable}]
##Sch name = JB2
#set_property PACKAGE_PIN A16 [get_ports {o_Red_led}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {o_Red_led}]
##Sch name = JB3
#set_property PACKAGE_PIN B15 [get_ports {o_Blue_led}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {o_Blue_led}]
##Sch name = JB4
#set_property PACKAGE_PIN B16 [get_ports {o_Green_led}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {o_Green_led}]
##Sch name = JB7
#set_property PACKAGE_PIN A15 [get_ports {JB[4]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Sch name = JB8
#set_property PACKAGE_PIN A17 [get_ports {JB[5]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Sch name = JB9
#set_property PACKAGE_PIN C15 [get_ports {JB[6]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Sch name = JB10
#set_property PACKAGE_PIN C16 [get_ports {JB[7]}]
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]


##Pmod Header JC - SPI Control
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports i_SPI_MOSI]
set_property IOSTANDARD LVCMOS33 [get_ports i_SPI_MOSI]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports i_SPI_Clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_SPI_Clk]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports i_SPI_CS]
set_property IOSTANDARD LVCMOS33 [get_ports i_SPI_CS]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports o_SPI_MISO]
set_property IOSTANDARD LVCMOS33 [get_ports o_SPI_MISO]



##Pmod Header JXADC
##Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {o_Enable}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {o_Enable}]
##Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports {o_Red_led}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {o_Red_led}]
##Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {o_Blue_led}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {o_Blue_led}]
##Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {o_Green_led}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {o_Green_led}]
##Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
##Sch name = XA2_N
#set_property PACKAGE_PIN M3 [get_ports {JXADC[5]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[5]}]
##Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {JXADC[6]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
##Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {JXADC[7]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]


set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]