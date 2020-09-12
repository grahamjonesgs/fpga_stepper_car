`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2020 08:07:40 PM
// Design Name: 
// Module Name: SM_Output
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
 
        

module SM_Output(
    input               i_sysclk, // 100 Mhz clock source on Basys 3 FPGA
    input               i_reset, // reset
    input               i_data_DV,
    input               i_dir,
    input    [7:0]      i_speed,
    output   reg        o_dir_pin,
    output              o_step_pin,
    output   reg        o_step_counter
    );
    
    reg     [31:0]      r_timing_counter;
    reg     [31:0]      r_max_counter;
    reg                 r_step;
    
    
    
   /*ila_0  myila(.clk(i_sysclk),.probe0(r_timing_counter),.probe1(r_max_counter),.probe2(i_speed),.probe3(8'h0),
  .probe4(8'h0), .probe5(8'h0),.probe6(8'h0),.probe7(8'h0),
  .probe8(i_data_DV),.probe9(r_step),.probe10(i_reset),.probe11(1'b0),.probe12(1'b0),
  .probe13(1'b0),.probe14(1'b0),.probe15(1'b0),
  .probe16(1'b0),.probe17(1'b0),.probe18(1'b0),.probe19(1'b0));*/
    
    always @(posedge i_sysclk)
    begin 
        if(i_reset==1)
            begin
                r_timing_counter <= 0;
                r_max_counter <=0;
                o_step_counter<=1'b0;
                r_step <= 1'b0;
                o_dir_pin <=1'b0;
            end
            
        else
            r_timing_counter <= r_timing_counter + 1;
            if (r_timing_counter > r_max_counter)
            begin
                r_timing_counter<=0;
                if (r_step)
                begin
                    r_step<=1'b0;
                    o_step_counter<=1'b0;
                end // if r_step
                else
                begin
                    r_step<=1'b1;
                    o_step_counter<=1'b1;
                end // else if r_step
            end // if (r_timing_counter > r_max_counter)
            else //    
            begin
                o_step_counter<=1'b0;
            end // else if r_timing_counter > r_max_counter)
            if(i_data_DV)
            begin
                r_timing_counter <= 0;
                r_step <= 1;
                r_max_counter <= set_max(i_speed);
                o_dir_pin <= i_dir;
            end // if (i_data_DV)
    end 
    
    assign o_step_pin = (r_max_counter==0) ? 1'b0 : r_step; // No output if speed zero

function [31:0] set_max;
    input  [7:0] speed;
    `ifdef basys
    parameter set_fastest=146;   // fastest speed when set to 1 is 2/255 second, double this to half time. Motor only works on rising edge. est 275 for max of 35,000
    `else
    parameter set_fastest=1222;  // Approx for 12Mhx clock
    `endif
    begin
        case(speed)

        8'h01: set_max=32'h5F5E100/set_fastest;

        8'h02: set_max=32'h2FAF080/set_fastest;

        8'h03: set_max=32'h1FCA055/set_fastest;

        8'h04: set_max=32'h17D7840/set_fastest;

        8'h05: set_max=32'h1312D00/set_fastest;

        8'h06: set_max=32'hFE502B/set_fastest;

        8'h07: set_max=32'hD9FB92/set_fastest;

        8'h08: set_max=32'hBEBC20/set_fastest;

        8'h09: set_max=32'hA98AC7/set_fastest;

        8'h0A: set_max=32'h989680/set_fastest;

        8'h0B: set_max=32'h8AB75D/set_fastest;

        8'h0C: set_max=32'h7F2815/set_fastest;

        8'h0D: set_max=32'h756014/set_fastest;

        8'h0E: set_max=32'h6CFDC9/set_fastest;

        8'h0F: set_max=32'h65B9AB/set_fastest;

        8'h10: set_max=32'h5F5E10/set_fastest;

        8'h11: set_max=32'h59C1F1/set_fastest;

        8'h12: set_max=32'h54C564/set_fastest;

        8'h13: set_max=32'h504F36/set_fastest;

        8'h14: set_max=32'h4C4B40/set_fastest;

        8'h15: set_max=32'h48A931/set_fastest;

        8'h16: set_max=32'h455BAF/set_fastest;

        8'h17: set_max=32'h4257B2/set_fastest;

        8'h18: set_max=32'h3F940B/set_fastest;

        8'h19: set_max=32'h3D0900/set_fastest;

        8'h1A: set_max=32'h3AB00A/set_fastest;

        8'h1B: set_max=32'h388398/set_fastest;

        8'h1C: set_max=32'h367EE5/set_fastest;

        8'h1D: set_max=32'h349DD4/set_fastest;

        8'h1E: set_max=32'h32DCD5/set_fastest;

        8'h1F: set_max=32'h3138CE/set_fastest;

        8'h20: set_max=32'h2FAF08/set_fastest;

        8'h21: set_max=32'h2E3D1F/set_fastest;

        8'h22: set_max=32'h2CE0F8/set_fastest;

        8'h23: set_max=32'h2B98B7/set_fastest;

        8'h24: set_max=32'h2A62B2/set_fastest;

        8'h25: set_max=32'h293D6F/set_fastest;

        8'h26: set_max=32'h28279B/set_fastest;

        8'h27: set_max=32'h272007/set_fastest;

        8'h28: set_max=32'h2625A0/set_fastest;

        8'h29: set_max=32'h253770/set_fastest;

        8'h2A: set_max=32'h245498/set_fastest;

        8'h2B: set_max=32'h237C4D/set_fastest;

        8'h2C: set_max=32'h22ADD7/set_fastest;

        8'h2D: set_max=32'h21E88E/set_fastest;

        8'h2E: set_max=32'h212BD9/set_fastest;

        8'h2F: set_max=32'h20772C/set_fastest;

        8'h30: set_max=32'h1FCA05/set_fastest;

        8'h31: set_max=32'h1F23F0/set_fastest;

        8'h32: set_max=32'h1E8480/set_fastest;

        8'h33: set_max=32'h1DEB50/set_fastest;

        8'h34: set_max=32'h1D5805/set_fastest;

        8'h35: set_max=32'h1CCA48/set_fastest;

        8'h36: set_max=32'h1C41CC/set_fastest;

        8'h37: set_max=32'h1BBE46/set_fastest;

        8'h38: set_max=32'h1B3F72/set_fastest;

        8'h39: set_max=32'h1AC512/set_fastest;

        8'h3A: set_max=32'h1A4EEA/set_fastest;

        8'h3B: set_max=32'h19DCC3/set_fastest;

        8'h3C: set_max=32'h196E6B/set_fastest;

        8'h3D: set_max=32'h1903B0/set_fastest;

        8'h3E: set_max=32'h189C67/set_fastest;

        8'h3F: set_max=32'h183866/set_fastest;

        8'h40: set_max=32'h17D784/set_fastest;

        8'h41: set_max=32'h17799E/set_fastest;

        8'h42: set_max=32'h171E90/set_fastest;

        8'h43: set_max=32'h16C639/set_fastest;

        8'h44: set_max=32'h16707C/set_fastest;

        8'h45: set_max=32'h161D3B/set_fastest;

        8'h46: set_max=32'h15CC5B/set_fastest;

        8'h47: set_max=32'h157DC3/set_fastest;

        8'h48: set_max=32'h153159/set_fastest;

        8'h49: set_max=32'h14E707/set_fastest;

        8'h4A: set_max=32'h149EB7/set_fastest;

        8'h4B: set_max=32'h145855/set_fastest;

        8'h4C: set_max=32'h1413CD/set_fastest;

        8'h4D: set_max=32'h13D10D/set_fastest;

        8'h4E: set_max=32'h139003/set_fastest;

        8'h4F: set_max=32'h13509F/set_fastest;

        8'h50: set_max=32'h1312D0/set_fastest;

        8'h51: set_max=32'h12D688/set_fastest;

        8'h52: set_max=32'h129BB8/set_fastest;

        8'h53: set_max=32'h126253/set_fastest;

        8'h54: set_max=32'h122A4C/set_fastest;

        8'h55: set_max=32'h11F397/set_fastest;

        8'h56: set_max=32'h11BE27/set_fastest;

        8'h57: set_max=32'h1189F1/set_fastest;

        8'h58: set_max=32'h1156EC/set_fastest;

        8'h59: set_max=32'h11250C/set_fastest;

        8'h5A: set_max=32'h10F447/set_fastest;

        8'h5B: set_max=32'h10C495/set_fastest;

        8'h5C: set_max=32'h1095ED/set_fastest;

        8'h5D: set_max=32'h106845/set_fastest;

        8'h5E: set_max=32'h103B96/set_fastest;

        8'h5F: set_max=32'h100FD8/set_fastest;

        8'h60: set_max=32'hFE503/set_fastest;

        8'h61: set_max=32'hFBB10/set_fastest;

        8'h62: set_max=32'hF91F8/set_fastest;

        8'h63: set_max=32'hF69B5/set_fastest;

        8'h64: set_max=32'hF4240/set_fastest;

        8'h65: set_max=32'hF1B93/set_fastest;

        8'h66: set_max=32'hEF5A8/set_fastest;

        8'h67: set_max=32'hED07A/set_fastest;

        8'h68: set_max=32'hEAC02/set_fastest;

        8'h69: set_max=32'hE883D/set_fastest;

        8'h6A: set_max=32'hE6524/set_fastest;

        8'h6B: set_max=32'hE42B3/set_fastest;

        8'h6C: set_max=32'hE20E6/set_fastest;

        8'h6D: set_max=32'hDFFB7/set_fastest;

        8'h6E: set_max=32'hDDF23/set_fastest;

        8'h6F: set_max=32'hDBF25/set_fastest;

        8'h70: set_max=32'hD9FB9/set_fastest;

        8'h71: set_max=32'hD80DC/set_fastest;

        8'h72: set_max=32'hD6289/set_fastest;

        8'h73: set_max=32'hD44BD/set_fastest;

        8'h74: set_max=32'hD2775/set_fastest;

        8'h75: set_max=32'hD0AAD/set_fastest;

        8'h76: set_max=32'hCEE62/set_fastest;

        8'h77: set_max=32'hCD290/set_fastest;

        8'h78: set_max=32'hCB735/set_fastest;

        8'h79: set_max=32'hC9C4E/set_fastest;

        8'h7A: set_max=32'hC81D8/set_fastest;

        8'h7B: set_max=32'hC67D0/set_fastest;

        8'h7C: set_max=32'hC4E34/set_fastest;

        8'h7D: set_max=32'hC3500/set_fastest;

        8'h7E: set_max=32'hC1C33/set_fastest;

        8'h7F: set_max=32'hC03CA/set_fastest;

        8'h80: set_max=32'hBEBC2/set_fastest;

        8'h81: set_max=32'hBD41A/set_fastest;

        8'h82: set_max=32'hBBCCF/set_fastest;

        8'h83: set_max=32'hBA5DF/set_fastest;

        8'h84: set_max=32'hB8F48/set_fastest;

        8'h85: set_max=32'hB7908/set_fastest;

        8'h86: set_max=32'hB631D/set_fastest;

        8'h87: set_max=32'hB4D85/set_fastest;

        8'h88: set_max=32'hB383E/set_fastest;

        8'h89: set_max=32'hB2347/set_fastest;

        8'h8A: set_max=32'hB0E9E/set_fastest;

        8'h8B: set_max=32'hAFA40/set_fastest;

        8'h8C: set_max=32'hAE62E/set_fastest;

        8'h8D: set_max=32'hAD264/set_fastest;

        8'h8E: set_max=32'hABEE1/set_fastest;

        8'h8F: set_max=32'hAABA5/set_fastest;

        8'h90: set_max=32'hA98AC/set_fastest;

        8'h91: set_max=32'hA85F7/set_fastest;

        8'h92: set_max=32'hA7384/set_fastest;

        8'h93: set_max=32'hA6150/set_fastest;

        8'h94: set_max=32'hA4F5C/set_fastest;

        8'h95: set_max=32'hA3DA5/set_fastest;

        8'h96: set_max=32'hA2C2B/set_fastest;

        8'h97: set_max=32'hA1AEC/set_fastest;

        8'h98: set_max=32'hA09E7/set_fastest;

        8'h99: set_max=32'h9F91B/set_fastest;

        8'h9A: set_max=32'h9E887/set_fastest;

        8'h9B: set_max=32'h9D829/set_fastest;

        8'h9C: set_max=32'h9C802/set_fastest;

        8'h9D: set_max=32'h9B80F/set_fastest;

        8'h9E: set_max=32'h9A84F/set_fastest;

        8'h9F: set_max=32'h998C3/set_fastest;

        8'hA0: set_max=32'h98968/set_fastest;

        8'hA1: set_max=32'h97A3E/set_fastest;

        8'hA2: set_max=32'h96B44/set_fastest;

        8'hA3: set_max=32'h95C79/set_fastest;

        8'hA4: set_max=32'h94DDC/set_fastest;

        8'hA5: set_max=32'h93F6D/set_fastest;

        8'hA6: set_max=32'h9312A/set_fastest;

        8'hA7: set_max=32'h92312/set_fastest;

        8'hA8: set_max=32'h91526/set_fastest;

        8'hA9: set_max=32'h90764/set_fastest;

        8'hAA: set_max=32'h8F9CB/set_fastest;

        8'hAB: set_max=32'h8EC5B/set_fastest;

        8'hAC: set_max=32'h8DF13/set_fastest;

        8'hAD: set_max=32'h8D1F3/set_fastest;

        8'hAE: set_max=32'h8C4F9/set_fastest;

        8'hAF: set_max=32'h8B825/set_fastest;

        8'hB0: set_max=32'h8AB76/set_fastest;

        8'hB1: set_max=32'h89EEC/set_fastest;

        8'hB2: set_max=32'h89286/set_fastest;

        8'hB3: set_max=32'h88643/set_fastest;

        8'hB4: set_max=32'h87A24/set_fastest;

        8'hB5: set_max=32'h86E26/set_fastest;

        8'hB6: set_max=32'h8624B/set_fastest;

        8'hB7: set_max=32'h85690/set_fastest;

        8'hB8: set_max=32'h84AF6/set_fastest;

        8'hB9: set_max=32'h83F7D/set_fastest;

        8'hBA: set_max=32'h83422/set_fastest;

        8'hBB: set_max=32'h828E7/set_fastest;

        8'hBC: set_max=32'h81DCB/set_fastest;

        8'hBD: set_max=32'h812CD/set_fastest;

        8'hBE: set_max=32'h807EC/set_fastest;

        8'hBF: set_max=32'h7FD28/set_fastest;

        8'hC0: set_max=32'h7F281/set_fastest;

        8'hC1: set_max=32'h7E7F7/set_fastest;

        8'hC2: set_max=32'h7DD88/set_fastest;

        8'hC3: set_max=32'h7D335/set_fastest;

        8'hC4: set_max=32'h7C8FC/set_fastest;

        8'hC5: set_max=32'h7BEDE/set_fastest;

        8'hC6: set_max=32'h7B4DB/set_fastest;

        8'hC7: set_max=32'h7AAF1/set_fastest;

        8'hC8: set_max=32'h7A120/set_fastest;

        8'hC9: set_max=32'h79768/set_fastest;

        8'hCA: set_max=32'h78DCA/set_fastest;

        8'hCB: set_max=32'h78443/set_fastest;

        8'hCC: set_max=32'h77AD4/set_fastest;

        8'hCD: set_max=32'h7717D/set_fastest;

        8'hCE: set_max=32'h7683D/set_fastest;

        8'hCF: set_max=32'h75F14/set_fastest;

        8'hD0: set_max=32'h75601/set_fastest;

        8'hD1: set_max=32'h74D05/set_fastest;

        8'hD2: set_max=32'h7441E/set_fastest;

        8'hD3: set_max=32'h73B4E/set_fastest;

        8'hD4: set_max=32'h73292/set_fastest;

        8'hD5: set_max=32'h729EC/set_fastest;

        8'hD6: set_max=32'h7215A/set_fastest;

        8'hD7: set_max=32'h718DC/set_fastest;

        8'hD8: set_max=32'h71073/set_fastest;

        8'hD9: set_max=32'h7081D/set_fastest;

        8'hDA: set_max=32'h6FFDC/set_fastest;

        8'hDB: set_max=32'h6F7AD/set_fastest;

        8'hDC: set_max=32'h6EF91/set_fastest;

        8'hDD: set_max=32'h6E789/set_fastest;

        8'hDE: set_max=32'h6DF92/set_fastest;

        8'hDF: set_max=32'h6D7AE/set_fastest;

        8'hE0: set_max=32'h6CFDD/set_fastest;

        8'hE1: set_max=32'h6C81C/set_fastest;

        8'hE2: set_max=32'h6C06E/set_fastest;

        8'hE3: set_max=32'h6B8D1/set_fastest;

        8'hE4: set_max=32'h6B144/set_fastest;

        8'hE5: set_max=32'h6A9C9/set_fastest;

        8'hE6: set_max=32'h6A25F/set_fastest;

        8'hE7: set_max=32'h69B04/set_fastest;

        8'hE8: set_max=32'h693BA/set_fastest;

        8'hE9: set_max=32'h68C81/set_fastest;

        8'hEA: set_max=32'h68556/set_fastest;

        8'hEB: set_max=32'h67E3C/set_fastest;

        8'hEC: set_max=32'h67731/set_fastest;

        8'hED: set_max=32'h67035/set_fastest;

        8'hEE: set_max=32'h66948/set_fastest;

        8'hEF: set_max=32'h6626A/set_fastest;

        8'hF0: set_max=32'h65B9B/set_fastest;

        8'hF1: set_max=32'h654DA/set_fastest;

        8'hF2: set_max=32'h64E27/set_fastest;

        8'hF3: set_max=32'h64783/set_fastest;

        8'hF4: set_max=32'h640EC/set_fastest;

        8'hF5: set_max=32'h63A63/set_fastest;

        8'hF6: set_max=32'h633E8/set_fastest;

        8'hF7: set_max=32'h62D7A/set_fastest;

        8'hF8: set_max=32'h6271A/set_fastest;

        8'hF9: set_max=32'h620C6/set_fastest;

        8'hFA: set_max=32'h61A80/set_fastest;

        8'hFB: set_max=32'h61446/set_fastest;

        8'hFC: set_max=32'h60E19/set_fastest;

        8'hFD: set_max=32'h607F9/set_fastest;

        8'hFE: set_max=32'h601E5/set_fastest;

        8'hFF: set_max=32'h5FBDD/set_fastest;

        default: set_max=0;
        endcase
    end
endfunction

endmodule 
    