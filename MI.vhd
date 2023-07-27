library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity MI is
    port (
        clk      : in    std_logic;
        addr     : in    std_logic_vector(31 downto 0);
        data_out : out   std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of MI is
    type mem_type is array (0 to (2**8)-1) of std_logic_vector(31 downto 0); -- Data size is 32 bits now
    signal read_addr: integer range 0 to (2**8)-1;

    impure function init_mem return mem_type is
        file text_file    :   text open read_mode is "D:/projects/Pipeline/code"; -- Mudar diretório
        variable text_line    :   line;
        variable text_word    :   std_logic_vector(31 downto 0); -- Data size is 32 bits now
        variable memoria    :   mem_type;
        variable n        :   integer;
    begin
        n := 0;
        while not endfile(text_file) loop
            if n <= 255 then
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
    read_addr <= to_integer(unsigned(addr)) / 4;

    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= mem(read_addr);
        end if;
    end process;
end architecture;