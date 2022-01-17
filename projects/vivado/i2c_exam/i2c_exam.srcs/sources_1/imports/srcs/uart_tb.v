`timescale 1ns/10ps

module uart_tb();

reg           clk;
reg           reset;
reg           wr_uart;
reg   [10:0]  dvsr;
reg   [ 7:0]  w_data;
wire          rx;
wire          rd_uart;
wire          tx_full;
wire          rx_empty;
wire  [ 7:0]  r_data;
wire          tx;


assign rd_uart =  (rx_empty == 1'b0)? 1'b1 : 1'b0;

assign rx = tx;


always
begin
  #5 clk = 1'b0;
  #5 clk = 1'b1;
end


initial
begin
  reset     = 1'b1;
  dvsr      = 650;
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
  while (uart_tb.DUT.tx_empty == 0)
  begin
    @(posedge clk);
  end

  #500;
  $stop;
end



uart
#(
  .DBIT    (8),
  .SB_TICK (16),
  .FIFO_W  (4)
)
DUT
(
  .clk          (clk),
  .reset        (reset),
  .rd_uart      (rd_uart),
  .wr_uart      (wr_uart),
  .dvsr         (dvsr),
  .rx           (rx),
  .w_data       (w_data),
  .tx_full      (tx_full),
  .rx_empty     (rx_empty),
  .r_data       (r_data),
  .tx           (tx)
);

endmodule