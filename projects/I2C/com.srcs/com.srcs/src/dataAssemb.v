`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2022 08:18:14 PM
// Design Name: 
// Module Name: dataAssemb
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


module dataAssemb(
    input clk,
    input data,
    output reg [7:0] out_data
    );
    
    reg [7:0] buff;
    
    integer count = 0;
    always @(negedge clk) begin
        buff[count] = data;
        
        if(count == 7) begin
            out_data <= buff;
            count <= 0;
        end else begin
            count = count + 1;
        end
    end
endmodule
