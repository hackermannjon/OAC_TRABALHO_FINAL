library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        clk, reset : in STD_LOGIC;                            -- Clock signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);     -- PC register

begin
    process(clk, reset)
    begin

        if rising_edge(clk) then
		  			report "PC  " & integer'image(to_integer(unsigned(pc_in)));

                pc_out <= pc_in;                      -- Update PC with pc_src if pc_write is enabled
            
        end if;
    end process;
                                 -- Output the current value of the PC
end Behavioral;
