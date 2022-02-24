LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY i2c_master IS
PORT
  (
    clk       : IN    STD_LOGIC;  -- 100 MHz
    reset     : IN    STD_LOGIC;
    din       : IN    STD_LOGIC_VECTOR ( 7 DOWNTO 0);
    cmd       : IN    STD_LOGIC_VECTOR ( 2 DOWNTO 0);
    dvsr      : IN    STD_LOGIC_VECTOR (15 DOWNTO 0);
    wr_i2c    : IN    STD_LOGIC;
    scl       : OUT   STD_LOGIC;  -- 10 kHz
    sda_i     : IN    STD_LOGIC;
    sda_en    : OUT   STD_LOGIC;
    ready     : OUT   STD_LOGIC;
    done_tick : OUT   STD_LOGIC;
    ack       : OUT   STD_LOGIC;
    dout      : OUT   STD_LOGIC_VECTOR ( 7 DOWNTO 0)
);
END i2c_master;


ARCHITECTURE arch OF i2c_master IS
CONSTANT START_CMD    : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
CONSTANT WR_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
CONSTANT RD_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
CONSTANT STOP_CMD     : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
CONSTANT RESTART_CMD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";
TYPE statetype IS ( idle, hold, start1, start2, data1, data2,
                    data3, data4, data_end, restart, stop1, stop2
);

SIGNAL state_reg          : statetype;
SIGNAL state_next         : statetype;
SIGNAL c_reg, c_next      : UNSIGNED          (15 DOWNTO 0);
SIGNAL qutr, half         : UNSIGNED          (15 DOWNTO 0);
SIGNAL tx_reg, tx_next    : STD_LOGIC_VECTOR  ( 8 DOWNTO 0);
SIGNAL rx_reg, rx_next    : STD_LOGIC_VECTOR  ( 8 DOWNTO 0);
SIGNAL cmd_reg, cmd_next  : STD_LOGIC_VECTOR  ( 2 DOWNTO 0);
SIGNAL bit_reg, bit_next  : UNSIGNED          ( 3 DOWNTO 0);
SIGNAL sda_out, scl_out   : STD_LOGIC;
SIGNAL sda_reg, scl_reg   : STD_LOGIC;
SIGNAL into               : STD_LOGIC;
SIGNAL nack               : STD_LOGIC;
SIGNAL data_phase         : STD_LOGIC;
BEGIN

----**********************************************
----        output control logic
----**********************************************
----    buffer for sda_i and scl lines

PROCESS(clk, reset )
BEGIN
  IF reset = '1' THEN
    sda_reg <= '1';
    scl_reg <= '1';
  ELSIF (clk'EVENT AND clk = '1') THEN
    sda_reg <= sda_out;
    scl_reg <= scl_out;
  END IF;
END PROCESS;
-- only master drives scl line
scl <= 'Z' WHEN scl_reg = '1' ELSE '0';

into <= '1' WHEN (data_phase = '1' AND cmd_reg = RD_CMD AND bit_reg < 8) OR
                 (data_phase = '1' AND cmd_reg = WR_CMD AND bit_reg = 8)
            ELSE '0';

sda_en  <= '1' WHEN into = '1' OR sda_reg = '1'
            ELSE '0';

--  output
dout  <= rx_reg (8 downto 1);
ack   <= rx_reg (0);  --  o tained from slave in write operation
nack  <= din(0);      --  used by master in read operation

----**********************************************
--  fsmd
----**********************************************
--  registers
PROCESS(clk, reset )
BEGIN
  IF reset = '1' THEN
    state_reg <= idle;
    c_reg     <= (OTHERS => '0');
    bit_reg   <= (OTHERS => '0');
    cmd_reg   <= (OTHERS => '0');
    tx_reg    <= (OTHERS => '0');
    rx_reg    <= (OTHERS => '0');
  ELSIF (clk'event AND clk = '1') THEN
    state_reg <= state_next;
    c_reg     <= c_next;
    bit_reg   <= bit_next;
    cmd_reg   <= cmd_next;
    tx_reg    <= tx_next;
    rx_reg    <= rx_next;
  END IF;
END PROCESS;

--    intervals
qutr <= unsigned (dvsr);
half <= qutr (14 DOWNTO 0) & '0'; -- half = 2*qutr

--  next state logic
PROCESS(state_reg, bit_reg, tx_reg, c_reg, rx_reg, cmd_reg,
        cmd, din, wr_i2c, sda_i, nack, qutr, half)
BEGIN
  state_next  <= state_reg;
  c_next      <= c_reg + 1; --  timer counts continuously
  bit_next    <= bit_reg;
  tx_next     <= tx_reg;
  rx_next     <= rx_reg;
  cmd_next    <= cmd_reg;
  done_tick   <= '0';
  ready       <= '0';
  scl_out     <= '1';
  sda_out     <= '1';
  data_phase  <= '0';
  CASE state_reg IS
    WHEN idle =>
      ready   <= '1';
      IF wr_i2c = '1' AND cmd = START_CMD THEN --start
        state_next  <= start1;
        c_next      <= (others => '0');
      END IF;
    WHEN start1 => --start condition
      sda_out <= '0';
      IF c_reg = half THEN
        c_next      <= (OTHERS => '0');
        state_next  <= start2;
      END IF;
    WHEN start2 =>
      sda_out <= '0';
      scl_out <= '0';
      IF c_reg = qutr THEN
        c_next      <= (OTHERS => '0');
        state_next  <= hold;
      END if;
    WHEN hold => -- in progress; prepare for the next op
      ready     <= '1';
      sda_out   <= '0';
      scl_out   <= '0';
      IF wr_i2c = '1' THEN
        cmd_next  <= cmd;
        c_next    <= (OTHERS => '0');
      CASE cmd IS
        WHEN RESTART_CMD | START_CMD =>
          state_next  <= restart;
        WHEN STOP_CMD =>
          state_next  <= stop1;
        WHEN OTHERS => -- read / write abyte
          bit_next    <= (OTHERS => '0');
          state_next  <= data1;
          tx_next     <= din & nack; -- used in read
      END CASE;
      END IF;
    WHEN data1 =>
    sda_out     <= tx_reg (8);
    scl_out     <= '0';
    data_phase  <= '1';
    IF  c_reg = qutr THEN
      c_next      <= (OTHERS => '0');
      state_next  <= data2;
    END IF;
    WHEN data2 =>
      sda_out <= tx_reg (8);
      data_phase <= '1';
      IF c_reg = QUTR THEN
        c_next <= (OTHERS => '0');
        state_next <= data3;
        rx_next <= rx_reg (7 DOWNTO 0) & sda_i;
      END IF;
    WHEN data3 =>
      sda_out <= tx_reg (8);
      data_phase <= '1';
      IF c_reg = qutr THEN
        c_next <= (OTHERS => '0');
        state_next <= data4;
      END IF;
    WHEN data4 =>
      sda_out <= tx_reg (8);
      scl_out <= '0';
      data_phase <= '1';
      IF c_reg = qutr THEN
        c_next <= (OTHERS => '0');
        IF bit_reg = 8 THEN --done with 8 data bits + 1 ack
          state_next  <= data_end;
          done_tick   <= '1';
        ELSE
          tx_next     <= tx_reg (7 DOWNTO 0) & '0';
          bit_next    <= bit_reg + 1;
          state_next  <= data1;
        END IF;
      END IF;
    WHEN data_end =>
      sda_out <= '0';
      scl_out <= '0';
      IF c_reg = qutr THEN
        c_next <= (OTHERS => '0');
        state_next <= hold;
      END IF;
    WHEN restart => --generate idle condition
      if c_reg = half THEN
        c_next <= (OTHERS => '0');
        state_next <= start1;
      END IF;
      WHEN stop1 => --  stop condition
      sda_out <= '0';
      IF c_reg = half THEN
        c_next <= (others => '0');
        state_next <= stop2;
      END IF;
    WHEN STOP2 => -- TURNAROUND TIME
      IF c_reg = half THEN
        state_next <= idle;
      END IF;
  END CASE;
END PROCESS;

END arch;
