library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port (
        clk : in STD_LOGIC;               -- Sinal de clock
        reset : in STD_LOGIC;             -- Sinal de reset
        pc_out : out STD_LOGIC_VECTOR(7 downto 0);  -- Saída do endereço do PC (8 bits)
        pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8)  -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
    );
end PC;

architecture Behavioral of PC is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);  -- Registrador interno do PC

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
    pc_mem_out <= pc_reg(31 downto 8);             -- Apenas os 24 bits mais significativos são enviados como saída para a memória de instruções
end Behavioral;
