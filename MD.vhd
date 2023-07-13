library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MD is
    Port (
        clk : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        addr_in : in STD_LOGIC_VECTOR(7 downto 0);           -- Entrada do endereço da memória de dados (8 bits)
        data_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada dos dados a serem escritos na memória de dados (32 bits)
        read_en : in STD_LOGIC;                              -- Sinal de habilitação de leitura
        write_en : in STD_LOGIC;                             -- Sinal de habilitação de escrita
        data_out : out STD_LOGIC_VECTOR(31 downto 0)         -- Saída dos dados lidos da memória de dados (32 bits)
    );
end MD;

architecture Behavioral of MD is
    type data_memory is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);  -- Memória de dados (256 palavras de 32 bits cada)
    signal data_mem : data_memory;                                          -- Registrador interno da memória de dados

begin
    process(clk, reset)
    begin
        if reset = '1' then                          -- Verifica se o sinal de reset está ativo
            data_mem <= (others => (others => '0')); -- Reinicia a memória de dados para 0
        elsif rising_edge(clk) then                   -- Verifica se ocorreu uma borda de subida no sinal de clock
            if read_en = '1' then                     -- Verifica se a leitura está habilitada
                if addr_in >= "00000000" and addr_in <= "11111111" then  -- Verifica se o endereço está dentro do espaço de endereçamento (8 bits)
                    data_out <= data_mem(to_integer(unsigned(addr_in)));  -- Lê os dados correspondentes ao endereço
                else
                    data_out <= (others => '0');  -- Caso o endereço esteja fora do espaço de endereçamento, retorna 0
                end if;
            elsif write_en = '1' then                 -- Verifica se a escrita está habilitada
                if addr_in >= "00000000" and addr_in <= "11111111" then  -- Verifica se o endereço está dentro do espaço de endereçamento (8 bits)
                    data_mem(to_integer(unsigned(addr_in))) <= data_in;  -- Escreve os dados no endereço correspondente
                end if;
            end if;
        end if;
    end process;

end Behavioral;
