module uart
#(
  parameter integer   DBIT    = 8,
  parameter integer   SB_TICK = 16,
  parameter integer   FIFO_W  = 4
)
(
  /* System Interface */
  input           clk,
  input           reset,
  input   [10:0]  dvsr,
  /* Tx Interface */
  input           wr_uart,
  input   [ 7:0]  w_data,
  output          tx_full,
  /* Rx Interface */
  input           rd_uart,
  output  [ 7:0]  r_data,
  output          rx_empty,
  /* UART Interface */
  input           rx,
  output          tx
);

wire            tick;
wire            rx_done_tick;
wire  [ 7:0]    tx_fifo_out;
wire  [ 7:0]    rx_data_out;
wire            tx_empty;
wire            tx_fifo_not_empty;
wire            tx_done_tick;


baud_gen #(
)
baud_gen_unit
(
  .clk   (clk),
  .reset (reset),
  .dvsr  (dvsr),
  .tick  (tick)
);

uart_rx #(
  .DBIT    (DBIT),
  .SB_TICK (SB_TICK)
) uart_rx_unit (
  .clk           (clk),
  .reset         (reset),
  .rx            (rx),
  .s_tick        (tick),
  .rx_done_tick  (rx_done_tick),
  .dout          (rx_data_out)

);

uart_tx #(
  .DBIT    (DBIT),
  .SB_TICK (SB_TICK)
) uart_tx_unit (
  .clk           (clk),
  .reset         (reset),
  .tx_start      (tx_fifo_not_empty),
  .s_tick        (tick),
  .din           (tx_fifo_out),
  .tx_done_tick  (tx_done_tick),
  .tx            (tx)
);

fifo #(
  .DATA_WIDTH   (DBIT),
  .ADDR_WIDTH   (FIFO_W)
) fifo_rx_unit (
  .clk          (clk),
  .reset        (reset),
  .rd           (rd_uart),
  .wr           (rx_done_tick),
  .w_data       (rx_data_out),
  .empty        (rx_empty),
  .full         (),
  .r_data       (r_data)
);

fifo #(
  .DATA_WIDTH   (DBIT),
  .ADDR_WIDTH   (FIFO_W)
) fifo_tx_unit (
  .clk     (clk),
  .reset   (reset),
  .rd      (tx_done_tick),
  .wr      (wr_uart),
  .w_data  (w_data),
  .empty   (tx_empty),
  .full    (tx_full),
  .r_data  (tx_fifo_out)
);

//clk_wiz_0 instance_name
//   (
//    // Clock out ports
//    .clk_out1(clk_out1),     // output clk_out1
//    // Status and control signals
//    .resetn(resetn), // input resetn
//    .locked(locked),       // output locked
//   // Clock in ports
//    .clk_in1(clk_in1));      // input clk_in1

assign tx_fifo_not_empty = !tx_empty;



endmodule