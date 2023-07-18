library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPE_FETCH is
    Port (
        clk : in STD_LOGIC;               -- Sinal de clock
        reset : in STD_LOGIC;             -- Sinal de reset
        PIPE_FETCH_done : in STD_LOGIC;        -- Entrada PIPE_FETCH_done (0 ou 1)
        instruction : out STD_LOGIC_VECTOR(31 downto 0) -- Saída da instrução da memória de instruções

		  
    );
end PIPE_FETCH;

architecture behavioral of PIPE_FETCH is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0);             -- Registrador para armazenar o valor atual do PC
    signal pc_plus_4 : STD_LOGIC_VECTOR(31 downto 0);         -- Saída do Somador (PC + 4)
    signal pc_plus_offset : STD_LOGIC_VECTOR(31 downto 0);    -- Saída do Somador (PC + Deslocamento)
    signal pc_mux_out : STD_LOGIC_VECTOR(31 downto 0);        -- Saída do Mux21 (Seleção do PC)
    signal control_signal : std_logic;                        -- Sinal de controle para o Mux21
	 signal pc_out :  STD_LOGIC_VECTOR(7 downto 0);  -- Saída do endereço do PC (8 bits)
    signal pc_mem_out :  STD_LOGIC_VECTOR(31 downto 8);  -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
   
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
	 component PIPE_MEM is
    Port (
        clk, PIPE_MEM_done : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        addr_in : in STD_LOGIC_VECTOR(7 downto 0);           -- Entrada do endereço da memória de dados (8 bits)
        data_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada dos dados a serem escritos na memória de dados (32 bits)
        data_out : out STD_LOGIC_VECTOR(31 downto 0)         -- Saída dos dados lidos da memória de dados (32 bits)
    );
end component;


    component MI is
        Port (
            clk : in STD_LOGIC;                                 -- Sinal de clock
            reset : in STD_LOGIC;                               -- Sinal de reset
            pc_mem_in : in STD_LOGIC_VECTOR(31 downto 8);        -- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
            instruction_out : out STD_LOGIC_VECTOR(31 downto 0);
				FIM : out STD_LOGIC-- Saída da instrução da memória de instruções (32 bits)
        );
    end component;

    component MUX21 is
        Port (
            sel : in STD_LOGIC;
            data0 : in STD_LOGIC_VECTOR(31 downto 0);
            data1 : in STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component Somador8bits is
        Port (
            a : in STD_LOGIC_VECTOR(7 downto 0);
            b : in STD_LOGIC_VECTOR(7 downto 0);
            sum : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component ula is
        generic (WSIZE : natural := 32);
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(WSIZE-1 downto 0);
            Z : out std_logic_vector(WSIZE-1 downto 0);
            zero : out std_logic
        );
    end component;

    component Controle is 
        port (
            instr : in std_logic_vector(31 downto 0);
        ALUOp : out std_logic_vector(1 downto 0);
		  opcode_ula: out std_logic_vector(3 downto 0);
        ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic
        );
    end component;

    component genImm32 is
        Port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    signal branch_signal : std_logic;  -- Signal to hold the value of the Branch control signal from Controle
    signal zero_signal : std_logic;    -- Signal to hold the value of the zero signal from ula

    signal opcode_signal : std_logic_vector(3 downto 0);  -- Signal to hold the opcode from the instruction
    signal A_signal, B_signal : std_logic_vector(31 downto 0);  -- Signals to hold the operands for the ula

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

	 MEM_inst : PIPE_MEM
			port map (
				clk => clk,
            reset => reset,
				data
            addr_in => pc_mem_out
				PIPE_MEM_done => PIPE_MEM_done
			);	 
    MI_inst : MI
        port map (
            clk => clk,
            reset => reset,
            pc_mem_in => pc_mem_out,
            instruction_out => instruction
        );

    GenImm32_inst : genImm32
        port map (
            instr => instruction,
            imm32 => pc_plus_offset
        );

    SomadorPCPlus4_inst : Somador8bits
        port map (
            a => pc_out,
            b => "00000100",  -- Valor 4 em binário
            sum => pc_plus_4
        );

    SomadorPCPlusOffset_inst : Somador8bits
        port map (
            a => pc_out,
            b => std_logic_vector(resize(signed(pc_plus_offset), 8)),  -- Deslocamento de 8 bits
            sum => pc_plus_offset
        );

    MuxPC_inst : MUX21
        port map (
            sel => control_signal,
            data0 => pc_plus_4,
            data1 => pc_plus_offset,
            output => pc_mux_out
        );

    ula_inst : ula
        generic map (WSIZE => 32)
        port map (
            opcode => opcode_signal,
            A => A_signal,
            B => B_signal,
            Z => instruction,
            zero => zero_signal
        );

    Controle_inst : Controle
        port map (
            instr => instruction,
            Branch => branch_signal
       
        );

    process (clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
            control_signal <= '0';
        elsif rising_edge(clk) then
            if PIPE_FETCH_done = '1' then  -- Verifica se PIPE_FETCH_done é igual a 1
                if branch_signal = '1' and zero_signal = '1' then
                    control_signal <= '1';
                else
                    control_signal <= '0';
                end if;

                if control_signal = '1' then
                    pc_reg <= pc_mux_out;
                else
                    pc_reg <= pc_plus_4;
                end if;
            end if;
        end if;
    end process;

end behavioral;
