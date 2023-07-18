library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        clk : in STD_LOGIC;               -- Sinal de clock
        reset : in STD_LOGIC;             -- Sinal de reset
		  pc_in : in std_logic_vector(7 downto 0); -- entrada de endereço do PC
        pc_out : out STD_LOGIC_VECTOR(7 downto 0)  -- Saída do endereço do PC (8 bits)
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : STD_LOGIC_VECTOR(7 downto 0);  -- Registrador interno do PC

begin
    process(clk, reset)
    begin
        if reset = '1' then                -- Verifica se o sinal de reset está ativo
            pc_reg <= (others => '0');     -- Reinicia o contador de programa para 0
        elsif rising_edge(clk) then         -- Verifica se ocorreu uma borda de subida no sinal de clock
            pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);   -- Incrementa o contador de programa em 1
        end if;
    end process;

    pc_out <= pc_reg(7 downto 0);                  -- Apenas os 8 bits menos significativos são enviados como saída
end Behavioral;
