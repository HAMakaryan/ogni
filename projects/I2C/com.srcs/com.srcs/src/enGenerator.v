`timescale 1fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 09:15:49 AM
// Design Name: 
// Module Name: enGenerator
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


module enGenerator(
    input clk,
    output reg en_clk
    );
    
    integer count_clk = 0;
    always @(negedge clk) begin
        if(count_clk == 99999) begin
            en_clk = 1'b1;
            count_clk = count_clk + 1;
        end else if(count_clk == 100000) begin
            en_clk <= 1'b0;
            count_clk <= 0;
        end else begin
            count_clk = count_clk + 1;
            $display(count_clk);
        end
        
    end
endmodule
