library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Tamanho das memórias de código e dados (ajuste conforme necessário)
constant CODE_MEM_SIZE : natural := 85;
constant DATA_MEM_SIZE : natural := 12429;

entity FETCH is
    Port (
        clk : in STD_LOGIC;               -- Sinal de clock
        reset : in STD_LOGIC;             -- Sinal de reset
        pc_in : in std_logic_vector(31 downto 0); -- entrada de endereço do PC
        pc_out : out STD_LOGIC_VECTOR(7 downto 0);  -- Saída do endereço do PC (8 bits)
        pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8)  -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
    );
end FETCH;

architecture behavioral of FETCH is
    signal pc_reg : STD_LOGIC_VECTOR(7 downto 0);             -- Registrador para armazenar o valor atual do PC

    -- Sinais intermediários
    signal pc_plus_4 : std_logic_vector(31 downto 0);
    signal pc_offset : std_logic_vector(31 downto 0);
    signal pc_mux_out : std_logic_vector(31 downto 0);
    signal mux_output : std_logic_vector(31 downto 0);

    -- Componentes internos
    component PC is
        Port (
            clk : in STD_LOGIC;               -- Sinal de clock
            reset : in STD_LOGIC;             -- Sinal de reset
            pc_in : in STD_LOGIC_VECTOR(31 downto 0); -- entrada do PC
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

    -- Componentes adicionais
    component MUX21 is
        Port (
            sel : in STD_LOGIC;
            data0 : in STD_LOGIC_VECTOR(31 downto 0);
            data1 : in STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component Somador32bits is
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            sum : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component genImm32 is
        Port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    -- Função auxiliar para ler arquivos binários e carregar na memória
    procedure load_memory(filename : string; mem : inout std_logic_vector) is
        file f : text open read_mode is filename;
        variable line : line;
        variable value : std_logic_vector(mem'length-1 downto 0);
    begin
        for i in mem'range loop
            readline(f, line);
            readline(line, value);
            mem(i) := value;
        end loop;
        file_close(f);
    end procedure;

begin
    -- Componentes instanciados
    PC_inst : PC
        port map (
            clk => clk,
            reset => reset,
            pc_in => pc_reg,
            pc_out => pc_out,
            pc_mem_out => pc_mem_out
        );

    MI_inst : MI
        port map (
            clk => clk,
            reset => reset,
            pc_mem_in => pc_mem_out,
            instruction_out => instruction
        );

    -- Sinais intermediários
    pc_plus_4 <= pc_reg + 4;
    pc_offset <= "000000000000000000000000" & instruction(31 downto 20);

    -- Componentes adicionais
    MUX_inst : MUX21
        port map (
            sel => zero AND Branch,
            data0 => pc_plus_4,
            data1 => pc_reg + pc_offset,
            output => mux_output
        );

    Somador_inst : Somador32bits
        port map (
            a => pc_reg,
            b => "00000000000000000000000000000100",  -- Valor decimal 4 (PC + 4)
            sum => pc_plus_4
        );

    -- Processo para carregar os arquivos binários na memória durante a fase de inicialização
    process
    begin
        if reset = '1' then
            -- Carregar código.bin na memória de instruções
            load_memory("code.bin", code_mem);
            -- Carregar data.bin na memória de dados
            load_memory("data.bin", data_mem);
        end if;
    end process;

    -- Processo para buscar a instrução na memória de instruções com base no valor atual do PC
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reinicializar o PC para 0
                pc_reg <= (others => '0');
            else
                -- Atualizar o PC para o próximo valor
                pc_reg <= pc_mux_out(7 downto 0);
            end if;
        end if;
    end process;

    -- Atribui o valor correto ao sinal pc_mux_out
    pc_mux_out <= mux_output when reset = '1' else pc_plus_4;

end behavioral;
