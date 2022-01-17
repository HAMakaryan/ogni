`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   10:27:17 09/05/2021
// Design Name:   uart_rx
// Module Name:   D:/VerilogLessons/Uart/Uart_rx_tb.v
// Project Name:  Uart
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: uart_rx
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module Uart_rx_tb;

	// Inputs
	reg clk;
	reg reset;
	reg rx;
	reg s_tick;

	// Outputs
	wire rx_done_tick;
	wire [7:0] dout;

	// Instantiate the Unit Under Test (UUT)
	uart_rx uut (
		.clk(clk),
		.reset(reset),
		.rx(rx),
		.s_tick(s_tick),
		.rx_done_tick(rx_done_tick),
		.dout(dout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		rx = 1;
		s_tick = 0;

		// Wait 100 ns for global reset to finish
		#10 reset=1;

      #100 reset=0;
       #200 rx=0;
       #2000 rx=1;
		 #5000 rx=0;
      #100000  $stop;
	end
  always
	 begin
	 clk<=!clk;
	 #2;
	 end
always
begin
  repeat(64) @(posedge clk);
  s_tick <= 1;
  @(posedge clk);
  s_tick <= 0;
end

endmodule

