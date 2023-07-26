library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        clk : in STD_LOGIC;                            -- Clock signal
        reset : in STD_LOGIC;                          -- Reset signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0);     -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);     -- PC register

begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');                 -- Reset PC to zero
        elsif rising_edge(clk) then
            if pc_write = '1' then
                pc_reg <= pc_in;                      -- Update PC with pc_src if pc_write is enabled
            end if;
        end if;
    end process;

    pc_out <= pc_reg;                                 -- Output the current value of the PC
end Behavioral;
