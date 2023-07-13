library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MI is
    Port (
        clk : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        pc_mem_in : in STD_LOGIC_VECTOR(31 downto 8);        -- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0)  -- Saída da instrução da memória de instruções (32 bits)
    );
end MI;

architecture Behavioral of MI is
    type instruction_memory is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);  -- Memória de instruções (256 palavras de 32 bits cada)
    signal inst_mem : instruction_memory;                                          -- Registrador interno da memória de instruções

begin
    process(clk, reset)
    begin
        if reset = '1' then                          -- Verifica se o sinal de reset está ativo
            inst_mem <= (others => (others => '0')); -- Reinicia a memória de instruções para 0
        elsif rising_edge(clk) then                   -- Verifica se ocorreu uma borda de subida no sinal de clock
            if pc_mem_in >= "00000000" and pc_mem_in <= "11111111" then  -- Verifica se o endereço está dentro do espaço de endereçamento (8 bits)
                instruction_out <= inst_mem(to_integer(unsigned(pc_mem_in)));  -- Lê a instrução correspondente ao endereço
            else
                instruction_out <= (others => '0');  -- Caso o endereço esteja fora do espaço de endereçamento, retorna 0
            end if;
        end if;
    end process;

end Behavioral;
