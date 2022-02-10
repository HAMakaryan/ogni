`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 12:43:20 PM
// Design Name: 
// Module Name: testTB
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


module testTB;

    reg clk;
    
    test U_test(.clk(clk));
    
    initial begin
        clk = 1'b0;
        #10000000 $finish;
    end
    
    always begin
        #1 clk = ~clk;
    end
endmodule
