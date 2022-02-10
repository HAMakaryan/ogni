`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2022 08:24:53 PM
// Design Name: 
// Module Name: dataAssembTB
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


module dataAssembTB;

    reg clk;
    reg data;
    wire [7:0] out_data;
    
    dataAssemb U_dataAssemb(
        .clk(clk),
        .data(data),
        .out_data(out_data)
    );
    
    initial begin
        clk = 1'b0;
        
        data = 1'b0;
        #10 data = 1'b1;
        #10 data = 1'b1;
        #10 data = 1'b1;
        #10 data = 1'b0;
        #10 data = 1'b1;
        #10 data = 1'b0;
        #10 data = 1'b0;
        #10 data = 1'b1;
        #10 data = 1'b0;
        
        #150 $finish;
    end
    
    always begin
        #5 clk <= ~clk;
    end
    
    
endmodule
