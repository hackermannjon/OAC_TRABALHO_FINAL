library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity MI is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        pc_mem_in : in STD_LOGIC_VECTOR(7 downto 0);
        instruction_mi_out : out STD_LOGIC_VECTOR(31 downto 0);
        pc_initial : out STD_LOGIC_VECTOR(7 downto 0);
        FIM : out STD_LOGIC  -- Sinal de saída para indicar o fim do programa
    );
end MI;

architecture Behavioral of MI is
    constant MEM_SIZE : integer := 256;
    type INSTRUCTION_MEM_ARRAY is array (0 to MEM_SIZE - 1) of STD_LOGIC_VECTOR(31 downto 0);
    signal instruction_mem : INSTRUCTION_MEM_ARRAY;
    signal read_addr : STD_LOGIC_VECTOR(7 downto 0);
    file code_file : TEXT open read_mode is "code.bin";
begin
    process(clk, reset)
        variable initial_addr : STD_LOGIC_VECTOR(7 downto 0) := "00000000";  -- Variável para armazenar o endereço inicial da primeira instrução
        variable line_buf : LINE;  -- Declaração da variável line_buf dentro do processo
        variable word_buf : STD_LOGIC_VECTOR(31 downto 0);
        variable end_of_file : BOOLEAN := FALSE;  -- Declaração da variável end_of_file dentro do processo
    begin
        if reset = '1' then
            read_addr <= (others => '0');
            FIM <= '0';  -- Reinicia o sinal FIM no reset
        elsif rising_edge(clk) then
            read_addr <= pc_mem_in;

            if end_of_file then
                FIM <= '1';  -- Define o sinal FIM como '1' quando chegar ao fim do arquivo
            else
                FIM <= '0';  -- Mantém o sinal FIM como '0' se ainda não chegou ao fim do arquivo
            end if;
        end if;

        if reset = '1' then
            file_close(code_file);
            file_open(code_file, "code.bin", READ_MODE);
            end_of_file := FALSE;
            initial_addr := "00000000";  -- Reinicia o endereço inicial para o valor do primeiro endereço de instrução
        else
            if not end_of_file then
                if not endfile(code_file) then
                    for i in 0 to MEM_SIZE - 1 loop
                        if to_integer(unsigned(read_addr)) = i then
                            if initial_addr = "00000000" then  -- Verifica se o endereço inicial ainda não foi atribuído
                                initial_addr := read_addr;  -- Atribui o endereço inicial da primeira instrução
                            end if;
                            readline(code_file, line_buf);
                            read(line_buf, word_buf);
                            instruction_mem(i) <= word_buf;
                            exit;
                        end if;
                    end loop;
                else
                    end_of_file := TRUE;
                    file_close(code_file);
                end if;
            end if;
        end if;
    end process;

    instruction_mi_out <= instruction_mem(to_integer(unsigned(read_addr)));
end Behavioral;
