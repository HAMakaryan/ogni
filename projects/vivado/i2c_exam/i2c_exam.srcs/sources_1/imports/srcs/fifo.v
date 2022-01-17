module fifo
#(
  parameter integer   ADDR_WIDTH  = 2,
  parameter integer   DATA_WIDTH  = 8
)
(
  input                     clk,
  input                     reset,
  input                     rd,
  input                     wr,
  input   [DATA_WIDTH-1:0]  w_data,
  output                    empty,
  output                    full,
  output  [DATA_WIDTH-1:0]  r_data
);

wire  wr_en;


wire  [ADDR_WIDTH-1:0]  w_addr;
wire  [ADDR_WIDTH-1:0]  r_addr;



assign wr_en = wr & !full;

fifo_ctrl #(
  .ADDR_WIDTH (ADDR_WIDTH)
) ctrl_unit (
  .clk    (clk),
  .reset  (reset),
  .rd     (rd),
  .wr     (wr),
  .empty  (empty),
  .full   (full),
  .w_addr (w_addr),
  .r_addr (r_addr)
);

reg_file #(
  .DATA_WIDTH (DATA_WIDTH),
  .ADDR_WIDTH (ADDR_WIDTH)
) reg_file_unit (
  .clk    (clk),
  .wr_en  (wr_en),
  .w_addr (w_addr),
  .r_addr (r_addr),
  .w_data (w_data),
  .r_data (r_data)
);

endmodule
