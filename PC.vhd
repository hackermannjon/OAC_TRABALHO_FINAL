library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        clk, reset : in STD_LOGIC;                            -- Clock signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0) ;  -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);     -- PC register

begin
   -- process(clk, reset)
   -- begin
		  
	-- Initialize PC register to all zeros when reset is active
	--	 if rising_edge(clk) then
	--		if reset = '1' then
     --       pc_reg <= "00000000000000000000000000000000";
	--				  pc_out <= pc_reg;
	--		else
            pc_out <= pc_in; 
	--			end if;-- Update PC with pc_in if there is a rising edge of the clock
  --    end if;
		  
   -- end process;
                                 -- Output the current value of the PC
end Behavioral;
