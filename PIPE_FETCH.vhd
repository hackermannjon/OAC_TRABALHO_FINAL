library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity FETCH is
    Port (
        clk : in STD_LOGIC;                                    -- Sinal de clock
        reset : in STD_LOGIC;                                  -- Sinal de reset
        pc_out : out STD_LOGIC_VECTOR(7 downto 0);             -- Saída do endereço do PC (8 bits)
        pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8);        -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0)    -- Saída da instrução da memória de instruções (32 bits)
    );
end FETCH;

architecture behavioral of FETCH is
    signal pc_reg : STD_LOGIC_VECTOR(7 downto 0);             -- Registrador para armazenar o valor atual do PC
    
    -- Componentes internos
    component PC is
        Port (
            clk : in STD_LOGIC;               -- Sinal de clock
            reset : in STD_LOGIC;             -- Sinal de reset
            pc_out : out STD_LOGIC_VECTOR(7 downto 0);  -- Saída do endereço do PC (8 bits)
            pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8)  -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
        );
    end component;

    component MI is
        Port (
            clk : in STD_LOGIC;                                 -- Sinal de clock
            reset : in STD_LOGIC;                               -- Sinal de reset
            pc_mem_in : in STD_LOGIC_VECTOR(31 downto 8);        -- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
            instruction_out : out STD_LOGIC_VECTOR(31 downto 0)  -- Saída da instrução da memória de instruções (32 bits)
        );
    end component;

begin
    -- Instanciação dos componentes internos
    PC_inst: PC
    port map(
        clk => clk,
        reset => reset,
        pc_out => pc_reg,
        pc_mem_out => pc_mem_out
    );

    MI_inst: MI
    port map(
        clk => clk,
        reset => reset,
        pc_mem_in => pc_mem_out,
        instruction_out => instruction_out
    );

    -- Saída do endereço do PC
    pc_out <= pc_reg;
end behavioral;
