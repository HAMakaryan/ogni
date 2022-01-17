module fifo_ctrl
#(
  parameter integer   ADDR_WIDTH  = 4
)
(
  input                     clk,
  input                     reset,
  input                     rd,
  input                     wr,
  output                    empty,
  output                    full,
  output  [ADDR_WIDTH-1:0]  w_addr,
  output  [ADDR_WIDTH-1:0]  r_addr
);

reg  [ADDR_WIDTH-1:0] w_ptr_reg;
reg  [ADDR_WIDTH-1:0] w_ptr_next;
reg  [ADDR_WIDTH-1:0] r_ptr_reg;
reg  [ADDR_WIDTH-1:0] r_ptr_next;
reg                   full_reg;
reg                   full_next;
reg                   empty_reg;
reg                   empty_next;


wire [ADDR_WIDTH-1:0] w_ptr_succ;
wire [ADDR_WIDTH-1:0] r_ptr_succ;
wire [1:0]            wr_op;

always @(posedge clk, posedge reset)
begin
  if (reset == 1'b1)
  begin
    w_ptr_reg <= {ADDR_WIDTH{1'b0}};
    r_ptr_reg <= {ADDR_WIDTH{1'b0}};
    full_reg  <= 1'b0;
    empty_reg <= 1'b1;
  end else
  begin
    w_ptr_reg <= w_ptr_next;
    r_ptr_reg <= r_ptr_next;
    full_reg  <= full_next;
    empty_reg <= empty_next;
  end
end

always @(*)
begin
  w_ptr_next <= w_ptr_reg;
  r_ptr_next <= r_ptr_reg;
  full_next  <= full_reg;
  empty_next <= empty_reg;
  case(wr_op)
    2'b00:    // NO OP
    begin
    end
    2'b01:    // READ
    begin
      if (empty_reg != 1'b1)
      begin
        r_ptr_next  <= r_ptr_succ;
        full_next   <= 1'b0;
        if (r_ptr_succ == w_ptr_reg)
        begin
          empty_next <= 1'b1;
        end
      end
    end
    2'b10:    // WRITE
    begin
      if(full_reg != 1'b1)
      begin
        w_ptr_next <= w_ptr_succ;
        empty_next <= 1'b0;
        if (w_ptr_succ == r_ptr_reg)
        begin
          full_next <= 1'b1;
        end
      end
    end
    default:    // WRITE/READ
    begin
      w_ptr_next <= w_ptr_succ;
      r_ptr_next <= r_ptr_succ;
    end
  endcase
end

assign wr_op = {wr, rd};
assign w_addr = w_ptr_reg;
assign r_addr = r_ptr_reg;
assign full = full_reg;
assign empty = empty_reg;


assign w_ptr_succ = w_ptr_reg + 1;
assign r_ptr_succ = r_ptr_reg + 1;


endmodule
