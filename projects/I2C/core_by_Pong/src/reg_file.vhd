LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_file IS
GENERIC (
  ADDR_WIDTH : integer := 2;
  DATA_WIDTH : integer := 8
);
PORT(
  clk     : in  STD_LOGIC;
  wr_en   : in  STD_LOGIC;
  w_addr  : in  STD_LOGIC_VECTOR ( ADDR_WIDTH -1 DOWNTO 0);
  r_addr  : in  STD_LOGIC_VECTOR ( ADDR_WIDTH -1 DOWNTO 0);
  w_data  : in  STD_LOGIC_VECTOR ( DATA_WIDTH -1 DOWNTO 0);
  r_data  : out STD_LOGIC_VECTOR ( DATA_WIDTH -1 DOWNTO 0)
);
END reg_file;

ARCHITECTURE arch OF reg_file IS
type mem_2d_type IS ARRAY (0 to 2**ADDR_WIDTH-1) OF
      std_logic_vector ( DATA_WIDTH -1 DOWNTO 0);

SIGNAL array_reg:mem_2d_type;

BEGIN

PROCESS(clk )
BEGIN
  IF (clk'EVENT AND clk = '1') THEN
    IF wr_en = '1' THEN
      array_reg (to_integer(unsigned(w_addr))) <= w_data;
    END IF;
  END IF;
END PROCESs;
-- read port
r_data <= array_reg (to_integer(unsigned(r_addr)));

END arch;

