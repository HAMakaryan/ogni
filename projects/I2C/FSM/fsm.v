`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/14/2022 03:06:25 PM
// Design Name:
// Module Name: step1
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




module fsm(
    input clk,
    input reset,
    input din,
    input cmd,
    input dvsr,
    input wr_i2c,

    output reg scl,
    output reg sda,
    output reg ready,
    output reg done_tick,
    output reg ack,
    output reg dout
    );

    localparam STATE_IDLE = 0;
    localparam STATE_START1 = 1;
    localparam STATE_START2 = 2;
    localparam STATE_HOLD = 3;
    localparam STATE_DATA1 = 4;
    localparam STATE_DATA2 = 5;
    localparam STATE_DATA3 = 6;
    localparam STATE_DATA4 = 7;
    localparam STATE_STOP1 = 8;
    localparam STATE_STOP2 = 9;

    localparam START_CMD = 0;
    localparam RESTART_CMD = 1;
    localparam STOP_CMD = 2;
    localparam RD_CMD = 3;
    localparam WR_CMD = 4;

    reg [7:0] state;
    //reg [7:0] tx_reg;



    always begin
        if(reset == 1) begin
            state <= STATE_IDLE;
//            sda <= 1;
//            scl <= 1;
        end else begin
            case(state)
                STATE_IDLE: begin
                    if(cmd == START_CMD) begin
//                        sda <= 0;
                        state <= STATE_START1;
                    end
                end

                STATE_START1: begin
//                    scl <= 0;
                    state <= STATE_START2;
                end

                STATE_START2: begin
                    state <= STATE_HOLD;
                end

                STATE_HOLD: begin
                    if(cmd == RESTART_CMD) begin
                        state <= STATE_START1;
                    end else if(cmd == STOP_CMD) begin
                        state <= STATE_STOP1;
                    end else if(cmd == WR_CMD || cmd == RD_CMD) begin
                        state <= STATE_DATA1;
                    end
                end

                STATE_STOP1: begin
//                    scl <= 1;
                    state <= STATE_STOP2;
                end

                STATE_STOP2: begin
//                    sda <= 1;
                    state <= STATE_IDLE;
                end

                STATE_DATA1: begin
//                    sda = tx_reg[8];
//                    tx_reg = tx_reg << 1;
                    state <= STATE_DATA2;
                end

                STATE_DATA2: begin
                    state <= STATE_DATA3;
                end

                STATE_DATA3: begin
                    state <= STATE_DATA4;
                end

                STATE_DATA4: begin
                    state <= STATE_HOLD;
                end


            endcase
        end

    end
endmodule
