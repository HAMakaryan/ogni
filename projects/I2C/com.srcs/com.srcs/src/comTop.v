`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 09:25:57 AM
// Design Name: 
// Module Name: comTop
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


module comTop(
    input clk,
    output [7:0] data_par
    );
    
    wire en_clk;
    wire data;
    
    enGenerator U_enGenerator(
        .clk(clk),
        .en_clk(en_clk)
    );
    
    lfsr16 U_lfsr16(
        .clk(clk),
        .en_clk(en_clk),
        .out_data(data)
    );
    
//    dataAssemb U_daraAssemb(
//        .clk(clk_local),
//        .data(data),
//        .out_data(data_par)
//    );
    
    
endmodule
