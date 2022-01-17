`timescale 1 ns / 1 ps

module uart_top_tb;
reg           clk;
reg           reset;
reg           wr_uart;
reg   [10:0]  dvsr;
reg   [ 7:0]  w_data;
wire          uart_drv_tx;
wire          rd_uart;
wire          tx_full;
wire          rx_empty;
wire  [ 7:0]  r_data;
wire          top_tx;
uart_top top
(
  /* System Interface */
  .clk(clk),
  .rst(reset),
  /* UART Interface */
  .tx(top_tx),
  .rx(uart_drv_tx)
);
uart
#(
  .DBIT(8),
  .SB_TICK(16),
  .FIFO_W(4)
) uart_drv
(
  /* System Interface */
  .clk(clk),
  .reset(reset),
  .dvsr(dvsr),

  /* Tx Interface */
  .wr_uart(wr_uart),    //input
  .w_data(w_data),      //input   [ 7:0]
  .tx_full(tx_full),    //output

  /* Rx Interface */
  .rd_uart(rd_uart),     //input
  .r_data(r_data),       //output  [ 7:0]
  .rx_empty(rx_empty),   //output

  /* UART Interface */
  .rx(top_tx),           //input
  .tx(uart_drv_tx)       //output
);


assign rd_uart =  (rx_empty == 1'b0)? 1'b1 : 1'b0;




always
begin
  #5 clk = 1'b0;
  #5 clk = 1'b1;
end

initial
begin
  reset     = 1'b1;
  dvsr      = 15;
  wr_uart   = 1'b0;
  w_data    = 8'b01010101;

  #17 reset = 1'b0;
  repeat(4)@(posedge clk);
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;
  w_data    = 8'b10101010;
  repeat(4)@(posedge clk);
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;
  repeat(4)@(posedge clk);
  w_data    = 8'hA5;
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;
  repeat(4)@(posedge clk);
  w_data    = 8'h5A;
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;

  repeat(4)@(posedge clk);
  w_data    = 8'hF0;
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;
  repeat(4)@(posedge clk);
  w_data    = 8'h0F;
  wr_uart   = 1'b1;
  @(posedge clk);
  wr_uart   = 1'b0;
  while (uart_top_tb.top.uart_dev.tx_empty == 0)
  begin
    @(posedge clk);
  end

  #5000000;
  $stop;
end




endmodule
