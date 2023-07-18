library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity MD is
    Port (
        clk : in STD_LOGIC;                                  -- Sinal de clock
        reset : in STD_LOGIC;                                -- Sinal de reset
        addr_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Entrada do endereço para a memória de dados
        data_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Dados de entrada para a memória de dados
        data_md_out : out STD_LOGIC_VECTOR(31 downto 0);     -- Saída de dados da memória de dados
        MemRead : in STD_LOGIC;                              -- Sinal de controle MeMRead
        MemWrite : in STD_LOGIC                              -- Sinal de controle MeMWrite
    );
end MD;

architecture Behavioral of MD is
    type data_memory is array (0 to 127) of STD_LOGIC_VECTOR(31 downto 0);  -- Memória de dados (128 palavras de 32 bits cada)
    signal data_mem : data_memory;                                           -- Registrador interno da memória de dados

begin
    process(clk, reset)
        file data_file : TEXT open READ_MODE is "data.bin";  -- Abre o arquivo "data.bin" em modo de leitura
        variable line_buf : line;
        variable word_buf : std_logic_vector(31 downto 0);
        variable n : integer := 0;
    begin
        if reset = '1' then
            data_mem <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if MemRead = '1' then  -- Leitura de dados
                data_md_out <= data_mem(to_integer(unsigned(addr_md_in)));
            elsif MemWrite = '1' then  -- Escrita de dados
                data_mem(to_integer(unsigned(addr_md_in))) <= data_md_in;
            end if;
        end if;
    end process;
end Behavioral;
