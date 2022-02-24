library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY fifo_ctrl IS
GENERIC (ADDR_WIDTH : NATURAL := 4);
PORT(
  clk     : IN  STD_LOGIC;
  reset   : IN  STD_LOGIC;
  rd      : IN  STD_LOGIC;
  wr      : IN  STD_LOGIC;
  empty   : OUT STD_LOGIC;
  full    : OUT STD_LOGIC;
  w_addr  : OUT STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
  r_addr  : OUT STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0)
);
END fifo_ctrl;

ARCHITECTURE arch OF fifo_ctrl IS

SIGNAL w_ptr_reg    : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL w_ptr_next   : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL w_ptr_succ   : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL r_ptr_reg    : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL r_ptr_next   : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL r_ptr_succ   : STD_LOGIC_VECTOR (ADDR_WIDTH -1 DOWNTO 0);
SIGNAL full_reg     : STD_LOGIC;
SIGNAL full_next    : STD_LOGIC;
SIGNAL empty_reg    : STD_LOGIC;
SIGNAL empty_next   : STD_LOGIC;
SIGNAL wr_op        : STD_LOGIC_VECTOR (1 DOWNTO 0);
BEGIN
--  Register for read AND write pointers
PROCESS(clk, reset)
begin
  IF (reset = '1') THEN
    w_ptr_reg <= (OTHERS => '0');
    r_ptr_reg <= (OTHERS => '0');
    full_reg  <= '0';
    empty_reg <= '1';
  ELSIF (clk'event AND clk = '1') THEN
    w_ptr_reg <= w_ptr_next;
    r_ptr_reg <= r_ptr_next;
    full_reg  <= full_next;
    empty_reg <= empty_next;
  END IF;
END PROCESS;

--  successive pointer values
w_ptr_succ <= std_logic_vector (unsigned (w_ptr_reg) + 1);
r_ptr_succ <= std_logic_vector (unsigned (r_ptr_reg) + 1);

--  next-state logic for read AND write pointers
wr_op <= wr & rd;

PROCESS(w_ptr_reg,  w_ptr_succ, r_ptr_reg, r_ptr_succ,
        wr_op,      empty_reg,  full_reg)
BEGIN
  w_ptr_next  <= w_ptr_reg;
  r_ptr_next  <= r_ptr_reg;
  full_next   <= full_reg;
  empty_next  <= empty_reg;
  CASE wr_op IS
    WHEN "00" => --  no op
    WHEN "01" => --  read
      IF (empty_reg /= '1') THEN --  not empty
        r_ptr_next <= r_ptr_succ;
        full_next <= '0';
        IF (r_ptr_succ = w_ptr_reg) THEN
          empty_next <= '1';
        END IF;
      END IF;
    WHEN "10" => --  write
    IF (full_reg /= '1') THEN --  not full
      w_ptr_next <= w_ptr_succ;
      empty_next <= '0';
      IF (w_ptr_succ = r_ptr_reg) THEN
        full_next <= '1';
      END IF;
    END IF;
    WHEN OTHERS => --  write/read;
      w_ptr_next <= w_ptr_succ;
      r_ptr_next <= r_ptr_succ;
  END CASE;
END PROCESS;

--  output
w_addr <= w_ptr_reg;
r_addr <= r_ptr_reg;
full <= full_reg;
empty <= empty_reg;

END arch;


