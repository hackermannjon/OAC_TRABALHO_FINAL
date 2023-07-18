library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;
entity MI is
    Port (
        clk : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        pc_mem_in : in STD_LOGIC_VECTOR(31 downto 8);        -- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        instruction_mi_out : out STD_LOGIC_VECTOR(31 downto 0);  -- Saída da instrução da memória de instruções (32 bits)
        FIM : out STD_LOGIC;
        pc_initial : out STD_LOGIC_VECTOR(31 downto 0)       -- Saída do valor inicial de pc_in
    );
end MI;

architecture Behavioral of MI is
    type instruction_memory is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);  -- Memória de instruções (256 palavras de 32 bits cada)
    signal inst_mem : instruction_memory;                                          -- Registrador interno da memória de instruções

begin
    process(clk, reset)
        file code_file : TEXT open READ_MODE is "code.bin";  -- Abre o arquivo "code.bin" em modo de leitura
        variable line_buf : line;
        variable word_buf : std_logic_vector(31 downto 0);
        variable n : integer := 0;
        variable pc_init : std_logic_vector(31 downto 0);    -- Variável local para armazenar o valor inicial de pc_in
    begin
        if reset = '1' then
            inst_mem <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if pc_mem_in >= "00000000" and pc_mem_in <= "11111111" then
                if not endfile(code_file) then
                    readline(code_file, line_buf);
                    read(line_buf, word_buf);
                    inst_mem(n) <= word_buf;
                    n := n + 1;
                    FIM <= '0';
                else
                    FIM <= '1';
                end if;
                instruction_mi_out <= inst_mem(to_integer(unsigned(pc_mem_in)));
                
                -- Armazena o valor de pc_in no ciclo inicial
                if n = 0 then
                    pc_init := pc_mem_in;
                end if;
            end if;
        end if;
        
        -- Atribui o valor de pc_init ao sinal de saída pc_initial
        pc_initial <= pc_init;
    end process;
end Behavioral;
