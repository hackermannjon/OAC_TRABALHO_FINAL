library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPELINE_CLK_TB is
end PIPELINE_CLK_TB;

architecture behavior of PIPELINE_CLK_TB is
  signal clk : std_logic := '0';

begin
  -- Clock process
  process
  begin
    wait for 5 ns;
    clk <= not clk;
    if now > 5000 ns then  -- Stop the simulation after 200 ns
      wait;
    end if;
  end process;

end behavior;
