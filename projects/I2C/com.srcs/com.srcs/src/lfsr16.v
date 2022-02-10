`timescale 1fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 04:16:06 AM
// Design Name: 
// Module Name: lfsr16
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


module lfsr16(
    input clk,
    input en_clk,
    output reg out_data
    );
    
    reg [3:0] buff = 4'b1010;

    always @(en_clk) begin
        if(en_clk == 1'b1 & clk == 1'b0) begin
            out_data = buff[0];
            buff = buff >> 1;
            buff[3] = out_data ^~ buff[0];
        end
    end
endmodule
