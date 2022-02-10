`timescale 1fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 09:17:32 AM
// Design Name: 
// Module Name: enGeneratorTB
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


module enGeneratorTB;

    reg clk;
    wire en_clk;
    
    enGenerator U_enGenerator(
        .clk(clk),
        .en_clk(en_clk)
    );
    
    initial begin
        clk = 1'b0;
        #2000000 $finish;
    end
    
    always begin
        #1 clk = ~clk;
    end
endmodule
