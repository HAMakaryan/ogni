Արարատ Հովհաննիսյան, [2/18/2022 5:39 PM]
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/14/2022 10:22:42 AM
// Design Name:
// Module Name: fsmTB
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


module fsmTB;
    reg reset;
    reg [4:0] cmd;

    localparam START_CMD = 0;
    localparam RESTART_CMD = 1;
    localparam STOP_CMD = 2;
    localparam RD_CMD = 3;
    localparam WR_CMD = 4;

    fsm U_fsm(
        .reset(reset),
        .cmd(cmd)
    );


    initial begin
        #5 reset = 1;
        #5 reset = 0;
        #5 cmd = START_CMD;
        #5 cmd = WR_CMD;
        #20 cmd = STOP_CMD;

        #10 $finish;
    end

endmodule




