
module uart_rx
(
input  clk,
input  reset,
input  rx,
input  s_tick,
output  reg rx_done_tick,
output  [7:0] dout
);

parameter DBIT    =   8;  // # data bits
parameter SB_TICK =  16; // # ticks for stop bits


localparam idle=2'b00;
localparam start=2'b01;
localparam data=2'b10;
localparam stop=2'b11;


reg [1:0] state_reg;
reg [1:0] state_next;
reg [4:0] s_reg , s_next;
reg [2:0] n_reg , n_next;
reg [7:0] b_reg , b_next;
reg sync1_reg;
reg sync2_reg;
wire sync_rx;

// synchronizati on for rx
always @(posedge clk)
begin
  sync1_reg <= rx;
  sync2_reg <= sync1_reg;
end

assign sync_rx = sync2_reg;

// FSMD state & data registers
always @(posedge clk, posedge reset)
begin
  if (reset == 1'b1)
  begin
    state_reg <= idle;
    s_reg     <= 5'b0;
    n_reg     <= 3'b0;
    b_reg     <= 8'b0;
  end
  else
  begin
    state_reg <= state_next;
    s_reg     <= s_next;
    n_reg     <= n_next;
    b_reg     <= b_next;
  end
end

// next-state logic & data path
always @(*)
begin
  state_next    <= state_reg;
  s_next        <= s_reg;
  n_next        <= n_reg;
  b_next        <= b_reg;
  rx_done_tick  <= 1'b0;

  case (state_reg)
     idle:
      if (sync_rx == 1'b0)
       begin
        state_next <= start;
        s_next <= 5'b0;
      end
    start:
    if (s_tick == 1'b1)
      begin
      if (s_reg == 5'd7)  // center of the start
      begin
        state_next <= data;
        s_next <= 5'b0;
        n_next <= 3'b0;
      end
      else
      begin
        s_next <= s_reg + 1;
      end
    end
    data:
      if (s_tick == 1'b1)
      begin
        if (s_reg == 5'd15)
        begin
          s_next <= 5'b0;
          b_next <= {sync_rx,  b_reg[7:1]};
          if (n_reg == (DBIT - 1))
          begin
              state_next <= stop;
          end
          else
          begin
            n_next <= n_reg + 1;
          end
        end
        else
        begin
          s_next <= s_reg + 1;
        end
      end

    stop:
      if (s_tick == 1'b1)
      begin
        if (s_reg == (SB_TICK - 1))
        begin
          state_next    <= idle;
          rx_done_tick  <= 1;
        end
        else
        begin
          s_next <= s_reg + 1;
        end
      end
 endcase
end

assign dout = b_reg;

endmodule



