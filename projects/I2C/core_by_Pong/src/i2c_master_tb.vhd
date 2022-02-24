LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY i2c_master_tb IS

END i2c_master_tb;

ARCHITECTURE bhv OF i2c_master_tb IS

COMPONENT i2c_master IS
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
END COMPONENT;

SIGNAL clk       : STD_LOGIC;  -- 100 MHz
SIGNAL reset     : STD_LOGIC;
SIGNAL din       : STD_LOGIC_VECTOR ( 7 DOWNTO 0);
SIGNAL cmd       : STD_LOGIC_VECTOR ( 2 DOWNTO 0);
SIGNAL dvsr      : STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL wr_i2c    : STD_LOGIC;
SIGNAL scl       : STD_LOGIC;  -- 10 kHz
SIGNAL sda       : STD_LOGIC;
SIGNAL sda_i     : STD_LOGIC;
SIGNAL sda_en    : STD_LOGIC;
SIGNAL ready     : STD_LOGIC;
SIGNAL done_tick : STD_LOGIC;
SIGNAL ack       : STD_LOGIC;
SIGNAL dout      : STD_LOGIC_VECTOR ( 7 DOWNTO 0);

SIGNAL end_of_test    : STD_LOGIC;

CONSTANT START_CMD    : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
CONSTANT WR_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "001";
CONSTANT RD_CMD       : STD_LOGIC_VECTOR (2 DOWNTO 0) := "010";
CONSTANT STOP_CMD     : STD_LOGIC_VECTOR (2 DOWNTO 0) := "011";
CONSTANT RESTART_CMD  : STD_LOGIC_VECTOR (2 DOWNTO 0) := "100";

BEGIN

scl <= 'H';

sda_i <= sda;
sda   <= '0' WHEN sda_en = '0' ELSE
          'H';

clk <= '0' WHEN clk = 'U' OR end_of_test = '1'
          ELSE  NOT clk AFTER 5 ns;

reset <= '1' , '0' AFTER 36 ns;

PROCESS
BEGIN
  end_of_test <= '0';
  wr_i2c      <= '0';
  dvsr <= STD_LOGIC_VECTOR(TO_UNSIGNED (249, 16));
  cmd  <= START_CMD;
  WAIT UNTIL reset = '0';
  WAIT UNTIL clk = '1';
  WAIT UNTIL clk = '1';
  WAIT UNTIL clk = '1';

  FOR i IN 1 to 10 LOOP
    WAIT UNTIL clk = '1';
  END LOOP;

  WAIT UNTIL rising_edge(clk);

  WHILE (ready = '0') LOOP
    WAIT UNTIL rising_edge(clk);
  END LOOP;
  WAIT UNTIL rising_edge(clk);
  WAIT UNTIL rising_edge(clk);

  din <= "01100110";
  WAIT UNTIL rising_edge(clk);
  wr_i2c  <= '1';
  WAIT UNTIL ready = '0';
  wr_i2c  <= '0';
  WAIT UNTIL ready = '1';
  cmd  <= WR_CMD;
  wr_i2c  <= '1';
  WAIT UNTIL ready = '0';
  wr_i2c  <= '0';
  WAIT UNTIL done_tick = '1';
  WAIT UNTIL ready = '1';
  cmd  <= RD_CMD;
  wr_i2c  <= '1';
  WAIT UNTIL ready = '0';
  wr_i2c  <= '0';
  din <= "01100111";
  WAIT UNTIL done_tick = '1';
  WAIT UNTIL ready = '1';
  cmd  <= RD_CMD;
  wr_i2c  <= '1';
  WAIT UNTIL ready = '0';
  wr_i2c  <= '0';
  WAIT UNTIL done_tick = '1';
  WAIT UNTIL ready = '1';
  cmd  <= STOP_CMD;
  wr_i2c  <= '1';
  WAIT UNTIL ready = '0';
  wr_i2c  <= '0';
  WAIT FOR 2 us;
  end_of_test <= '1';
  WAIT;
END PROCESS;

DUT : i2c_master
PORT MAP
  (
    clk       => clk,
    reset     => reset,
    din       => din,
    cmd       => cmd,
    dvsr      => dvsr,
    wr_i2c    => wr_i2c,
    scl       => scl,
    sda_i     => sda_i,
    sda_en    => sda_en,
    ready     => ready,
    done_tick => done_tick ,
    ack       => ack,
    dout      => dout
);


END ARCHITECTURE bhv;



