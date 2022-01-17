`timescale 1ns/10ps

module baud_gen_tb;
reg clk;
reg reset;
reg [10:0]dvsr;
wire tick;

baud_gen DUT
(
  .clk(clk),
  .reset(reset),
  .dvsr (dvsr),
  .tick(tick)
);

initial
begin
    reset=1;
    clk=0;
    dvsr=650;
    #38 reset =0;
end

always
begin
  clk <= !clk;
  #5;
end
endmodule
