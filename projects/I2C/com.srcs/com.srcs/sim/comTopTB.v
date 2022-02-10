`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 06:51:54 PM
// Design Name: 
// Module Name: comTopTB
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


module comTopTB;
    reg clk;
    wire [7:0] data_par;
    
    comTop U_comTop(
        .clk(clk),
        .data_par(data_par)
    );
    
    initial begin
        clk = 1'b0;
        
        #50000 $finish;
    end
    
    always begin
        #50 clk = ~clk;
    end
endmodule
