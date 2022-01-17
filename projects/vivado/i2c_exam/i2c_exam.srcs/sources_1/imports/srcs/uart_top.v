module uart_top
(
  /* System Interface */
  input           clk,
  input           rstn,
  /* UART Interface */
  output          tx,
  input           rx
);


wire wr_rd_uart;
wire tx_full;
wire [7:0]data;
wire [7:0]wdata;
wire rx_empty;
wire clk_out1;
wire locked;
wire reset = ~locked;

assign wdata = (data > 8'h63)? {data[7:6], 1'b0, data[4:0]} : data;

uart
#(
  .DBIT    (8 ),
  .SB_TICK (16),
  .FIFO_W  (4)
) uart_dev (
  .clk       (clk_out1),
  .reset     (reset),
  .dvsr      (11'd650),
  .wr_uart   (wr_rd_uart),
  .w_data    (wdata),
  .tx_full   (tx_full),
  .rd_uart   (wr_rd_uart),
  .r_data    (data),
  .rx_empty  (rx_empty),
  .rx        (rx),
  .tx        (tx)
);

nor (wr_rd_uart,tx_full,rx_empty);
//assign clk_out1=clk;
//assign locked=~rst;
 clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    // Status and control signals
    .resetn(rstn), // input resetn
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1



endmodule

