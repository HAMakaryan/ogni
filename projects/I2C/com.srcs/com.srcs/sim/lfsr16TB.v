`timescale 1fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 04:35:21 AM
// Design Name: 
// Module Name: lfsr16TB
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


module lfsr16TB;


    reg clk;
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
    
    always begin
       #1 clk <= ~clk; 
    end
    
    initial begin
        clk = 1'b0;
        #2000000 $finish;
    end
endmodule
