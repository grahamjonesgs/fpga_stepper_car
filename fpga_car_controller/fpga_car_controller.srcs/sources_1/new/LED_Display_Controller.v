`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/17/2020 10:31:08 PM
// Design Name: 
// Module Name: LED_SPI
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
//  0X for hex
//  1X for decimal number with decimal point
//  20 for V char
//  21 for dash

module Seven_seg_LED_Display_Controller(
    input               i_sysclk, // 100 Mhz clock source on Basys 3 FPGA
    input               i_reset, // reset
    input       [31:0]  i_displayed_number, // Number to display
    output reg  [3:0]   o_Anode_Activate, // anode signals of the 7-segment LED display
    output reg  [7:0]   o_LED_cathode// cathode patterns of the 7-segment LED display
    );
    
    
    reg     [7:0]   r_LED_Bytes;
    reg     [19:0]  r_refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire    [1:0]   r_LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat
     
    always @(posedge i_sysclk or posedge i_reset)
    begin 
        if(i_reset==1)
            r_refresh_counter <= 0;
        else
            r_refresh_counter <= r_refresh_counter + 1;
    end 
    assign r_LED_activating_counter = r_refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(r_LED_activating_counter)
        2'b00: begin
            o_Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            //LED_BCD = i_displayed_number/4096;
            r_LED_Bytes = i_displayed_number[31:24];
            // the first digit of the 16-bit number
              end
        2'b01: begin
            o_Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            //LED_BCD = (i_displayed_number % 4096)/256;
            r_LED_Bytes = i_displayed_number[23:16];
            // the second digit of the 16-bit number
              end
        2'b10: begin
            o_Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            //LED_BCD = ((i_displayed_number % 4096)%256)/16;
            r_LED_Bytes = i_displayed_number[15:8];
            // the third digit of the 16-bit number
                end
        2'b11: begin
            o_Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            //LED_BCD = ((i_displayed_number % 4096)%256)%16;
            r_LED_Bytes = i_displayed_number[7:0];
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display. MSB codes for decimal point
    always @(*)
    begin
        case(r_LED_Bytes)
        8'h00: o_LED_cathode = 8'b10000001; // "0"     
        8'h01: o_LED_cathode = 8'b11001111; // "1" 
        8'h02: o_LED_cathode = 8'b10010010; // "2" 
        8'h03: o_LED_cathode = 8'b10000110; // "3" 
        8'h04: o_LED_cathode = 8'b11001100; // "4" 
        8'h05: o_LED_cathode = 8'b10100100; // "5" 
        8'h06: o_LED_cathode = 8'b10100000; // "6" 
        8'h07: o_LED_cathode = 8'b10001111; // "7" 
        8'h08: o_LED_cathode = 8'b10000000; // "8"     
        8'h09: o_LED_cathode = 8'b10000100; // "9" 
        8'h0A: o_LED_cathode = 8'b10001000; // "A" 
        8'h0B: o_LED_cathode = 8'b00000000; // "B" 
        8'h0C: o_LED_cathode = 8'b10110001; // "C" 
        8'h0D: o_LED_cathode = 8'b00000001; // "D" 
        8'h0E: o_LED_cathode = 8'b10110000; // "E" 
        8'h0F: o_LED_cathode = 8'b10111000; // "F" 
        8'h10: o_LED_cathode = 8'b00000001; // "0."     
        8'h11: o_LED_cathode = 8'b01001111; // "1." 
        8'h12: o_LED_cathode = 8'b00010010; // "2." 
        8'h13: o_LED_cathode = 8'b00000110; // "3." 
        8'h14: o_LED_cathode = 8'b01001100; // "4." 
        8'h15: o_LED_cathode = 8'b00100100; // "5." 
        8'h16: o_LED_cathode = 8'b00100000; // "6." 
        8'h17: o_LED_cathode = 8'b00001111; // "7." 
        8'h18: o_LED_cathode = 8'b00000000; // "8."     
        8'h19: o_LED_cathode = 8'b00000100; // "9." 
        8'h20: o_LED_cathode = 8'b11000001; // "V" 
        8'h21: o_LED_cathode = 8'b11111110; // "-" 
        
       
        default:o_LED_cathode = 8'b11111110; // "-" 
        endcase
    end
 endmodule