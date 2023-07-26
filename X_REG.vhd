library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity X_REG is
  port (
    clk, wren  : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(31 downto 0);
    ro1, ro2 : out std_logic_vector(31 downto 0)
  );
end X_REG;

architecture main of X_REG is
  type RegArray is array (0 to 31) of std_logic_vector(31 downto 0);
  signal x_Regs : RegArray := (others => (others => '0'));
  signal rs1_index, rs2_index, rd_index : integer range 0 to 31;
  signal all_regs : RegArray := (others => (others => '0'));
  signal write_enable : std_logic := '0';

  function to_string(data : std_logic_vector) return string is
    variable str : string(data'length downto 1) := (others => ' ');
  begin
    for i in data'range loop
      str(i) := character'VALUE(std_logic'image(data(i)));
    end loop;
    return str;
  end function;

begin
  rs1_index <= to_integer(unsigned(rs1));
  rs2_index <= to_integer(unsigned(rs2));
  rd_index <= to_integer(unsigned(rd));

  process (clk)
  begin
    if rising_edge(clk) then
      if write_enable = '1' and rd_index /= 0 then
        x_Regs(rd_index) <= data;
      end if;
      write_enable <= wren;

      ro1 <= x_Regs(rs1_index);
      ro2 <= x_Regs(rs2_index);

      -- Print register values after every clock edge
      for i in 0 to 31 loop
        report "Register " & integer'image(i) & ": " & to_string(x_Regs(i));
      end loop;
    end if;
  end process;
end main;

