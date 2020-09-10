`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2020 10:33:34 PM
// Design Name: 
// Module Name: SM_Outout_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
/*
 8 byte car comtrol message
    Byte 0: Message type, 
        0x01 - Motor control
        0x02 - Enable control
        0x03 - LED control
        0x04 - Status Request
        
 Motor Control
   Byte 1 - directions (bytes 8-15)
        bit 0 - left dir
        bit 1 - right dir
        bit 2 - mode, 0 for ever, 1 count
        bit 3 - 0 count left, 1 count right
   Byte 2 - Left speed (bytes 16-23)
   Btye 3 - Right speed (bytes 24-31)
   Byte 4/5/6 - Max number of step  (bytes 32-55)
   
   Enable Control
   Byte 1, bit 0 - enable
   
   LED control
   Byte 0 Red
   Byte 1 Blue
   Byte 2 Green
 */ 
 


 
module Car_Control_SPI(
    input               i_sysclk, // 100 Mhz clock source on Basys 3 FPGA / 12 for DIP board
    input               i_reset, // reset
    
    // SPI
    input               i_SPI_Clk,
    input               i_SPI_MOSI,
    input               i_SPI_CS,
    output              o_SPI_MISO,
    
    // Step and dir pins
    output              o_Left_Front_Dir,
    output              o_Left_Back_Dir,
    output              o_Right_Front_Dir,
    output              o_Right_Back_Dir,
    output              o_Left_Front_Step,
    output              o_Left_Back_Step,
    output              o_Right_Front_Step,
    output              o_Right_Back_Step,
    
    // Control pins
    output  reg         o_Enable,
    
    // LED's for outpuf
    output              o_Enable_LED,
  

`ifdef basys      
    // Follow LED's all on BASYS board for debug
    output              o_Left_Front_Dir_LED,
    output              o_Left_Back_Dir_LED,
    output              o_Right_Front_Dir_LED,
    output              o_Right_Back_Dir_LED,
    output              o_Left_Front_Step_LED,
    output              o_Left_Back_Step_LED,
    output              o_Right_Front_Step_LED,
    output              o_Right_Back_Step_LED,
    output              o_Red_led_LED,
    output              o_Blue_led_LED,
    output              o_Green_led_LED,
    
   
    output      [3:0]   o_Anode_Activate, // anode signals of the 7-segment LED display
    output      [7:0]   o_LED_cathode,// cathode patterns of the 7-segment LED display
 `else
    output      reg     o_SPI_Gnd,
    output      reg     o_Aux_Gnd,
 `endif
 
    output              o_Red_led,
    output              o_Blue_led,
    output              o_Green_led
    );
    
    // reg to control the SM controller
    reg                 o_data_DV;
    reg                 o_dir_L;  
    reg     [7:0]       o_speed_L; 
    reg                 o_dir_R;  
    reg     [7:0]       o_speed_R;
    
    wire                i_step_count_L;
    wire                i_step_count_R;
    
     // For SPI data received / for sending
    wire    [63:0]      i_rec_data_array;  
    wire                i_rec_data_DV;  
    reg     [63:0]      o_send_data_array;
    wire    [3:0]       i_send_message_type;
    wire                i_send_data_request;
    
    // For step counting
    reg     [31:0]      step_counter; 
    reg     [31:0]      max_steps;  
    reg                 left_right_count;  // which motor to count
    wire                counting_pin;
    reg                 counting; // if we are coutning steps 
    
    // For controlling the output LED's
    reg     [7:0]       o_Red_led_status;
    reg     [7:0]       o_Blue_led_status;
    reg     [7:0]       o_Green_led_status;

     // For &-seg display
    reg     [31:0]      o_displayed_number; // number to be displayed
    
    parameter VERSION_STRING = 32'h20_10_00_06;  // V0.06
    
    parameter MSG_TYPE_MOTOR=8'h01, MSG_TYPE_ENABLE=8'h02, MSG_TYPE_LED=8'h03, MSG_TYPE_STATUS=8'h04;
    
    parameter SEND_NOTHING=4'h0, SEND_VERSION=4'h1, SEND_MOTOR_STATUS=4'h2;  // Message subtype for status message. Send_nothing means no request.
    
    SM_Output SM_Output_L(.i_sysclk(i_sysclk),.i_reset(i_reset),.i_data_DV(o_data_DV),
    .i_dir(o_dir_L),.i_speed(o_speed_L),.o_dir_pin(o_Left_Front_Dir),.o_step_pin(o_Left_Front_Step),.o_step_counter(i_step_count_L));
    
    SM_Output SM_Output_R(.i_sysclk(i_sysclk),.i_reset(i_reset),.i_data_DV(o_data_DV),
    .i_dir(o_dir_R),.i_speed(o_speed_R),.o_dir_pin(o_Right_Front_Dir),.o_step_pin(o_Right_Front_Step),.o_step_counter(i_step_count_R));
    
    SPI_Coms SPI_Coms1(.i_sysclk(i_sysclk),.i_reset(i_reset),.i_SPI_Clk(i_SPI_Clk),
   .i_SPI_MOSI(i_SPI_MOSI),.i_SPI_CS(i_SPI_CS),.o_SPI_MISO(o_SPI_MISO),.o_rec_data_DV(i_rec_data_DV),
   .o_rec_data_array(i_rec_data_array),.i_send_data_array(o_send_data_array),.o_send_message_type(i_send_message_type),
   .o_send_data_request(i_send_data_request));
`ifdef basys
    LED_Display_Controller led_display1 (.i_reset(i_reset), .i_sysclk(i_sysclk),
    . i_displayed_number(o_displayed_number),.o_Anode_Activate(o_Anode_Activate),.o_LED_cathode(o_LED_cathode));
 `endif   
    LED_Control red_led (.i_reset(i_reset), .i_sysclk(i_sysclk),.i_mode(o_Red_led_status),.o_LED_pin(o_Red_led)); 
    LED_Control blue_led (.i_reset(i_reset), .i_sysclk(i_sysclk),.i_mode(o_Blue_led_status),.o_LED_pin(o_Blue_led)); 
    LED_Control green_led (.i_reset(i_reset), .i_sysclk(i_sysclk),.i_mode(o_Green_led_status),.o_LED_pin(o_Green_led)); 
    
   /*ila_0  myila(.clk(i_sysclk),.probe0(step_counter),.probe1(max_steps),.probe2(o_speed_L),.probe3(o_speed_R),
  .probe4(8'h0), .probe5(8'h0),.probe6(8'h0),.probe7(8'h0),
  .probe8(left_right_count),.probe9(o_data_DV),.probe10(o_data_DV),.probe11(1'b0),.probe12(1'b0),
  .probe13(1'b0),.probe14(1'b0),.probe15(1'b0),
  .probe16(1'b0),.probe17(1'b0),.probe18(1'b0),.probe19(1'b0));
   */
    // Map back to be same as front
    
    
    assign o_Left_Back_Dir=o_Left_Front_Dir;
    assign o_Right_Back_Dir=o_Right_Front_Dir;
    assign o_Left_Back_Step=o_Left_Front_Step;
    assign o_Right_Back_Step=o_Right_Front_Step;
`ifdef basys    
    //  Set up follow LEDs
    assign o_Left_Front_Dir_LED=o_Left_Front_Dir;
    assign o_Left_Back_Dir_LED=o_Left_Back_Dir;
    assign o_Right_Front_Dir_LED=o_Right_Front_Dir;
    assign o_Right_Back_Dir_LED=o_Right_Back_Dir;
    assign o_Left_Front_Step_LED=o_Left_Front_Step;
    assign o_Left_Back_Step_LED=o_Left_Back_Step;
    assign o_Right_Front_Step_LED=o_Right_Front_Step;
    assign o_Right_Back_Step_LED=o_Right_Back_Step;
    assign o_Red_led_LED=o_Red_led;
    assign o_Blue_led_LED=o_Blue_led;
    assign o_Green_led_LED=o_Green_led;
`endif    
    assign o_Enable_LED=o_Enable;
    initial
    begin
        o_dir_L=1'b0;
        o_dir_R=1'b0;
        o_displayed_number=VERSION_STRING;
        o_Enable=1'b0;
        o_send_data_array=64'h0;
        o_Red_led_status=8'h0;
        o_Blue_led_status=8'h0;
        o_Green_led_status=8'h0;
        step_counter=32'h0;
        `ifndef basys
        o_SPI_Gnd=1'b0;    // Ground SPI pin
        o_Aux_Gnd=1'b0;    // Gound aux outputs
        `endif
    end // Init block
    
    always @(posedge i_sysclk)
    begin
     if (i_reset==1)                
        begin
            o_displayed_number<=VERSION_STRING;
            o_speed_L<=8'h0; 
            o_speed_R<=8'h0; 
            o_dir_L=1'b0;
            o_dir_R=1'b0;  
            o_Red_led_status=8'h0;
            o_Blue_led_status=8'h0;
            o_Green_led_status=8'h0;
        end //if reset
        else // if reset
        begin
            if(i_send_data_request)
            begin
                case(i_send_message_type)
                SEND_VERSION:
                begin
                   o_send_data_array<={32'h0,VERSION_STRING};
                end
                SEND_MOTOR_STATUS:
                begin
                   o_send_data_array<=64'hFF_EE_DD_CC_BB_AA_99_88; 
                end
                default: o_send_data_array<=64'h0;
                endcase // i_send_message_type
            end //  if(i_send_message_type!=0)
            if (i_rec_data_DV==1)
            begin           
                case (i_rec_data_array[7:0])           
                MSG_TYPE_ENABLE:
                begin
                    o_Enable<=i_rec_data_array[8];
                end // case MSG_TYPE_ENABLE
                
                MSG_TYPE_LED: // set LED output values
                begin
                    o_Red_led_status=i_rec_data_array[15:8];
                    o_Blue_led_status=i_rec_data_array[23:16];
                    o_Green_led_status=i_rec_data_array[31:24];
                end // case MSG_TYPE_LED
              
                MSG_TYPE_MOTOR:
                begin
                    step_counter<=32'h0;
                    if(i_rec_data_array[10]==0)
                    begin
                        max_steps<=1'b0;
                        counting<=1'b0;
                    end
                    else
                    begin
                        max_steps<=i_rec_data_array[55:32];
                        left_right_count<=i_rec_data_array[11];
                        counting<=1'b1;
                    end           
                    // Output the two speeds to the 7 seg
                    o_displayed_number[3:0]<=i_rec_data_array[29:24]; // Right 1 29:24
                    o_displayed_number[7:4]<=4'b0;
                    o_displayed_number[11:8]<=i_rec_data_array[31:28]; // Right 2 31:28
                    o_displayed_number[15:12]<=4'b0;
                    o_displayed_number[19:16]<=i_rec_data_array[19:16]; // Left 1 19:16
                    o_displayed_number[23:20]<=4'b0;
                    o_displayed_number[27:24]<=i_rec_data_array[23:20]; // Left 2 23:20
                    o_displayed_number[31:28]<=4'b0;
                    // Set speed and direction from data
                    o_speed_L<=i_rec_data_array[23:16];
                    o_speed_R<=i_rec_data_array[31:24];
                    o_dir_L<=i_rec_data_array[8];
                    o_dir_R<=i_rec_data_array[9];
                    // Pulse to motor controller
                    o_data_DV<=1'b1; 
                end // case MSG_TYPE_MOTOR
                default: ; //Ignore and do nothing
                endcase // i_rec_data_array[7:0]
            end
            else // if (i_rec_data_DV==1)
            begin
                if (counting_pin&&counting)
                begin
                    step_counter<=step_counter+1;
                    if (step_counter>=max_steps)
                    begin
                        // stop motors!!
                        o_speed_L<=8'h0;
                        o_speed_R<=8'h0;
                        o_data_DV<=1'b1;
                        counting<=1'b0;
                    end // if (step_counter>max_steps)
                    else
                    begin
                        o_data_DV<=1'b0;
                    end // else if step_counter>max_steps)
                end // if counting_pin&&counting
                else
                    o_data_DV<=1'b0;
                begin
                end // else f counting_pin&&counting 
            end  // else if (i_rec_data_DV==1)
        end // if not reset
    end //always
    
    assign counting_pin = left_right_count ? i_step_count_R :i_step_count_L;   // select which side to count
     
endmodule