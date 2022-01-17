module uart_tx #(
  parameter integer   DBIT        =  8,
  parameter integer   SB_TICK     = 16
) // parameters

(
  input               clk,
  input               reset,
  input               tx_start,
  input               s_tick,
  input       [7:0]   din,
  output reg          tx_done_tick,
  output              tx
);


localparam IDLE   = 2'b00;
localparam START  = 2'b01;
localparam DATA   = 2'b10;
localparam STOP   = 2'b11;

reg  [1:0]  state_next;
reg  [1:0]  state_reg;
reg  [4:0]  s_reg;
reg  [4:0]  s_next;
reg  [2:0]  n_reg;
reg  [2:0]  n_next;
reg  [7:0]  b_reg;
reg  [7:0]  b_next;
reg         tx_next;
reg         tx_reg;


assign tx = tx_reg;

always@(posedge clk, posedge reset)
begin
  if (reset == 1'b1)
  begin
    state_reg <= IDLE;
    s_reg     <= 5'b0;
    b_reg     <= 8'b0;
    n_reg     <= 3'b0;
    tx_reg    <= 1'b0;
  end else begin
    state_reg <= state_next;
    s_reg     <= s_next;
    b_reg     <= b_next;
    n_reg     <= n_next;
    tx_reg    <= tx_next;
  end
end // always

always@(*)
begin
  state_next    <= state_reg;
  s_next        <= s_reg;
  b_next        <= b_reg;
  n_next        <= n_reg;
  tx_next       <= tx_reg;
  tx_done_tick  <= 1'b0;
  case(state_reg)
    IDLE:
      begin
        tx_next <= 1'b1;
        if (tx_start == 1'b1)
        begin
          state_next  <= START;
          s_next      <= 5'b0;
          b_next      <= din;
        end
      end
    START:
      begin
        tx_next <= 1'b0;
        if (s_tick == 1'b1)
        begin
          if (s_reg == 5'd15)
          begin
            state_next <= DATA;
            s_next     <= 5'b0;
            n_next     <= 3'b0;
          end else
            s_next <= s_reg + 1;
          begin
          end
        end
      end
    DATA:
      begin
        tx_next <= b_reg[0];
        if (s_tick == 1'b1)
        begin
          if (s_reg == 5'd15)
          begin
            s_next <= 5'b0;
            b_next <= {1'b0, b_reg [7:1]};

            if (n_reg == DBIT-1)
            begin
              state_next <= STOP;
            end else
            begin
              n_next <= n_reg + 1;
            end
          end else
          begin
            s_next <= s_reg + 1;
          end
        end
      end
    STOP:
      begin
        tx_next <= 1'b1;
        if (s_tick == 1'b1)
        begin
          if (s_reg == SB_TICK-1)
          begin
            state_next    <= IDLE;
            tx_done_tick  <= 1'b1;
          end else
          begin
            s_next <= s_reg + 1;
          end
        end
      end
  endcase



end





endmodule


