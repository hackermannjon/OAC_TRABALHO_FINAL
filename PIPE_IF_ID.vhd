library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPE_IF_ID is

    
port(
	clk : in std_logic;
	pc_in, instr_in : in std_logic_vector(31 downto 0);
	DECODE_ADDR, DECODE_INST : out std_logic_vector(31 downto 0)

);
end PIPE_IF_ID;

architecture arch of PIPE_IF_ID is

begin

process(clk) begin

	if rising_edge(clk) then
		DECODE_ADDR <= pc_in;
		DECODE_INST <= instr_in;
	end if;

end process;

end arch;