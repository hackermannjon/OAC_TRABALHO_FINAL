library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity MD is
    Port (
        clk : in STD_LOGIC;                                  -- Sinal de clock
        reset : in STD_LOGIC;                                -- Sinal de reset
        addr_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Entrada do endereço para a memória de dados
        data_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Dados de entrada para a memória de dados
        data_md_out : out STD_LOGIC_VECTOR(31 downto 0);     -- Saída de dados da memória de dados
        MemRead : in STD_LOGIC;                              -- Sinal de controle MemRead
        MemWrite : in STD_LOGIC                              -- Sinal de controle MemWrite
    );
end MD;

architecture RTL of MD is
    type mem_type is array (0 to (2**16)-1) of std_logic_vector(31 downto 0); -- Data size is 32 bits now
    signal read_addr: integer range 0 to (2**16)-1;

    impure function init_mem return mem_type is
        file text_file    :   text open read_mode is "D:/projects/MI/code"; -- Mudar diretório
        variable text_line    :   line;
        variable text_word    :   std_logic_vector(31 downto 0); -- Data size is 32 bits now
        variable memoria    :   mem_type;
        variable n        :   integer;
    begin
        n := 0;
        while not endfile(text_file) loop
            if n <= 54 then
                readline(text_file, text_line);
                read(text_line, text_word); -- Use 'read' instead of 'hread' to read binary data
                memoria(n) := text_word;
                n := n + 1;
            else
                exit; -- Exit the loop after reading up to 54 words
            end if;
        end loop;

        return memoria;
    end;

    signal mem: mem_type := init_mem;

begin
    read_addr <= to_integer(unsigned(addr_md_in)) / 4;

    process(clk)
    begin
        if rising_edge(clk) then
				if MemRead = 1 then
					data_md_out <= mem(read_addr);
				elsif MemWrite = 1 then
					mem(read_addr) <= data_md_in;
        end if;
    end process;
end architecture;