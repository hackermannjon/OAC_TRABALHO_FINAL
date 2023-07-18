library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity X_REG is
  generic (WSIZE : natural := 32);
  port (
    clk, wren : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(WSIZE-1 downto 0);
    ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
  );
end X_REG;

architecture main of X_REG is
  type RegArray is array (natural range <>) of std_logic_vector(WSIZE-1 downto 0);
  signal x_Regs : RegArray(0 to WSIZE-1) := (others => (others => '0'));
  signal rs1_index, rs2_index, rd_index, i : integer;

begin
  rs1_index <= to_integer(unsigned(rs1));
  rs2_index <= to_integer(unsigned(rs2));
  rd_index <= to_integer(unsigned(rd));
  i <= 0;

  process (clk)
  begin
    if rising_edge(clk) then
      ro1 <= x_Regs(rs1_index);
      ro2 <= x_Regs(rs2_index);

      if wren = '1' and rd_index /= 0 then
        x_Regs(rd_index) <= data;
      end if;
    end if;
  end process;
end main;
