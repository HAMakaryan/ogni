LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fifo IS
GENERIC(
  ADDR_WIDTH : integer := 2;
  DATA_WIDTH : integer := 8
);
PORT(
  clk     : IN STD_LOGIC;
  reset   : IN STD_LOGIC;
  rd      : IN STD_LOGIC;
  wr      : IN STD_LOGIC;
  w_data  : IN STD_LOGIC_VECTOR ( DATA_WIDTH - 1 DOWNTO 0);
  empty   : OUT STD_LOGIC;
  full    : OUT STD_LOGIC;
  r_data  : OUT STD_LOGIC_VECTOR ( DATA_WIDTH - 1 DOWNTO 0)
);
END fifo;

ARCHITECTURE reg_file_arch OF fifo IS

SIGNAL full_tmp : STD_LOGIC;
SIGNAL wr_en    : STD_LOGIC;
SIGNAL w_addr   : STD_LOGIC_VECTOR ( ADDR_WIDTH - 1 DOWNTO 0);
SIGNAL r_addr   : STD_LOGIC_VECTOR ( ADDR_WIDTH - 1 DOWNTO 0);

BEGIN
--write enabled only when FIFO is not full
wr_en <= wr AND (NOT full_tmp);
full  <= full_tmp;

--instantiate fifo control unit
ctrl_unit : ENTITY work.fifo_ctrl(arch)
GENERIC MAP(
  ADDR_WIDTH => ADDR_WIDTH
)
PORT MAP(
  clk     => clk,
  reset   => reset,
  rd      => rd,
  wr      => wr,
  empty   => empty,
  full    => full_tmp,
  w_addr  => w_addr,
  r_addr  => r_addr
);

--instantiate register file
reg_file_unit : ENTITY work.reg_file(arch)
GENERIC MAP(
  DATA_WIDTH => DATA_WIDTH,
  ADDR_WIDTH => ADDR_WIDTH
)
PORT MAP(
  clk     => clk,
  w_addr  => w_addr,
  r_addr  => r_addr,
  w_data  => w_data,
  r_data  => r_data,
  wr_en   => wr_en
);

END reg_file_arch;

