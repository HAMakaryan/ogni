module reg_file
#(
  parameter integer   ADDR_WIDTH  = 2,
  parameter integer   DATA_WIDTH  = 8
)
(
  input                   clk,
  input                   wr_en,
  input [ADDR_WIDTH-1:0]  w_addr,
  input [ADDR_WIDTH-1:0]  r_addr,
  input [DATA_WIDTH-1:0]  w_data,
  output[DATA_WIDTH-1:0]  r_data
);

reg [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];

always@(posedge clk)
begin
  if (wr_en == 1'b1)
  begin
    array_reg[w_addr] <= w_data;
  end
end

assign r_data = array_reg[r_addr];

endmodule