module baud_gen(
  input clk,
  input reset,
  input [10:0]dvsr,
  output tick
);

reg  [10:0] r_reg ;
wire [10:0] r_next;
always @(posedge clk)
begin
  if(reset)
  begin
    r_reg<=11'b0;
  end
  else
  begin
    r_reg <= r_next;
  end
end
assign r_next=(r_reg == dvsr)? 11'b0 : r_reg+1;
assign tick=(r_reg==11'b1)?1'b1 : 1'b0;
endmodule





