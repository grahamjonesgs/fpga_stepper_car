`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2020 11:06:44 AM
// Design Name: 
// Module Name: LED_Control
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
//  Drive signal LED with vaiour modes
// Modes LSN
// X0 Off
// X1 On
// X2 Flash
// X3 Pulse
// Speed MSN // only for flash and pulse
// 0x0X Pulse Slow
// 0x1X Pulse Medium
// 0x2X Pulse Fast

module LED_Control(
    input               i_sysclk, // 100 Mhz clock source on Basys 3 FPGA
    input               i_reset, // reset
    input   [7:0]       i_mode,  
    
    output   reg        o_LED_pin   
    );
    
`ifdef basys
  parameter  SLOW_TIMER_INC = 3; //  Just fater than on change per second
  parameter  MEDIUM_TIMER_INC = 9; // Twice slow speed
  parameter  FAST_TIMER_INC = 32 ; // 5 times slow speed
  `else
  parameter  SLOW_TIMER_INC = 2; //  Just fater than on change per second
  parameter  MEDIUM_TIMER_INC = 4; // Twice slow speed
  parameter  FAST_TIMER_INC = 16 ; // 5 times slow speed
  `endif
  
  `ifdef basys
  parameter  COUNTER_MAX = 28'hFFFFFFF; // Top of counter, don't want it to wrap 
  `else
  parameter  COUNTER_MAX = 28'hFFFFFF; // Top of counter, don't want it to wrap one 16th for 12Mhz clock (ends up twice as fast)
  `endif
  
  
  reg   [27:0]      flash_timer;  // Count up to 268,435,455, 2.6 seconds for slow
  reg               count_down;    // Zero for increment
  
  
  /* ila_0  myila(.clk(i_sysclk),.probe0(flash_timer),.probe1(32'h0),.probe2(i_mode),.probe3(8'b0),
  .probe4(8'b0), .probe5(8'b0),.probe6(8'b0),.probe7(8'b0),
  .probe8(count_down),.probe9(1'b0),.probe10(1'b0),.probe11(1'b0),.probe12(1'b0),
  .probe13(1'b0),.probe14(1'b0),.probe15(1'b0),
  .probe16(1'b0),.probe17(1'b0),.probe18(1'b0),.probe19(1'b0)); */
    
always @(posedge i_sysclk)
    begin
     if (i_reset==1)                
        begin
            o_LED_pin<=1'b0;  
            flash_timer<=28'h0; 
            count_down=1'b0;
        end //if reset
        else // else if reset
        begin
        if ((flash_timer<=FAST_TIMER_INC)&&count_down)
            count_down=1'b0;
        if ((COUNTER_MAX-flash_timer<=FAST_TIMER_INC)&&~count_down)
            count_down=1'b1;
        case(i_mode[7:4])
            0: flash_timer<=count_down ? flash_timer-SLOW_TIMER_INC : flash_timer+SLOW_TIMER_INC ;
            1: flash_timer<=count_down ? flash_timer-MEDIUM_TIMER_INC : flash_timer+MEDIUM_TIMER_INC ;
            2: flash_timer<=count_down ? flash_timer-FAST_TIMER_INC : flash_timer+FAST_TIMER_INC;
            default: flash_timer<=count_down ? flash_timer-SLOW_TIMER_INC : flash_timer-SLOW_TIMER_INC ;
        endcase //(i_mode[7:4])
        case (i_mode[3:0])
            0: o_LED_pin<=1'b0;  // Always off
            1: o_LED_pin<=1'b1;  // Always on
            2: o_LED_pin<=count_down;  // Blink
            3:                         // Fade
            begin
                `ifdef basys
                if (flash_timer[27:20] > flash_timer[19:12]) 
                `else
                if (flash_timer[23:16] > flash_timer[15:8]) 
                `endif
                begin
                    o_LED_pin<=1'b1;
                end // if (flash_timer[27:26] > flash_timer[3:2])
                else
                begin
                    o_LED_pin<=1'b0;
                end // else if (flash_timer[27:26] > flash_timer[3:2])
            end // case 3:
            default: o_LED_pin<=1'b0;
        endcase   
        end // else if reset
     end //always @(posedge i_sysclk)
endmodule