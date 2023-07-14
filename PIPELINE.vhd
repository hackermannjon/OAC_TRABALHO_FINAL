library IEEE;
use IEEE.std_logic_1164.all;

entity PIPELINE is
    Port (
        clk : in STD_LOGIC;                                    -- Sinal de clock
        reset : in STD_LOGIC;                                  -- Sinal de reset
        pc_out : out STD_LOGIC_VECTOR(7 downto 0);             -- Saída do endereço do PC (8 bits)
        pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8);        -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0);    -- Saída da instrução da memória de instruções (32 bits)
        rs1 : out STD_LOGIC_VECTOR(4 downto 0);                -- Saída do registrador de origem 1 (5 bits)
        rs2 : out STD_LOGIC_VECTOR(4 downto 0);                -- Saída do registrador de origem 2 (5 bits)
        rd : out STD_LOGIC_VECTOR(4 downto 0);                 -- Saída do registrador de destino (5 bits)
        imm32 : out signed(31 downto 0);                       -- Saída do valor imediato de 32 bits (signed)
        ALUOp : out STD_LOGIC_VECTOR(1 downto 0);               -- Saída do sinal de controle da ALU (2 bits)
        alu_result : out STD_LOGIC_VECTOR(31 downto 0);         -- Saída do resultado da ALU (32 bits)
        zero : out STD_LOGIC                                  -- Saída do sinal de zero da ALU
    );
end PIPELINE;

architecture behavioral of PIPELINE is
    signal pc_reg : STD_LOGIC_VECTOR(7 downto 0);             -- Registrador para armazenar o valor atual do PC
    signal pc_mem_out_reg : STD_LOGIC_VECTOR(31 downto 8);    -- Registrador para armazenar o valor do endereço do PC para a memória de instruções (24 bits ignorados)
    signal instruction_out_reg : STD_LOGIC_VECTOR(31 downto 0);  -- Registrador para armazenar o valor da instrução da memória de instruções (32 bits)
    signal rs1_reg : STD_LOGIC_VECTOR(4 downto 0);             -- Registrador para armazenar o valor do registrador de origem 1
    signal rs2_reg : STD_LOGIC_VECTOR(4 downto 0);             -- Registrador para armazenar o valor do registrador de origem 2
    signal rd_reg : STD_LOGIC_VECTOR(4 downto 0);              -- Registrador para armazenar o valor do registrador de destino
    signal imm32_reg : signed(31 downto 0);                    -- Registrador para armazenar o valor imediato de 32 bits
    signal ALUOp_reg : STD_LOGIC_VECTOR(1 downto 0);           -- Registrador para armazenar o sinal de controle da ALU
    signal alu_result_reg : STD_LOGIC_VECTOR(31 downto 0);     -- Registrador para armazenar o resultado da ALU
    signal zero_reg : STD_LOGIC;                               -- Registrador para armazenar o sinal de zero da ALU

    -- Componentes internos
    component FETCH is
        Port (
            clk : in STD_LOGIC;                                    -- Sinal de clock
            reset : in STD_LOGIC;                                  -- Sinal de reset
            pc_out : out STD_LOGIC_VECTOR(7 downto 0);             -- Saída do endereço do PC (8 bits)
            pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8);        -- Saída do endereço do PC para a memória de instruções (24 bits ignorados)
            instruction_out : out STD_LOGIC_VECTOR(31 downto 0)    -- Saída da instrução da memória de instruções (32 bits)
        );
    end component;

    component DECODE is
        Port (
            clk : in STD_LOGIC;                                    -- Sinal de clock
            reset : in STD_LOGIC;                                  -- Sinal de reset
            instruction_in : in STD_LOGIC_VECTOR(31 downto 0);     -- Entrada da instrução do estágio Fetch (32 bits)
            rs1 : out STD_LOGIC_VECTOR(4 downto 0);                -- Saída do registrador de origem 1 (5 bits)
            rs2 : out STD_LOGIC_VECTOR(4 downto 0);                -- Saída do registrador de origem 2 (5 bits)
            rd : out STD_LOGIC_VECTOR(4 downto 0);                 -- Saída do registrador de destino (5 bits)
            imm32 : out signed(31 downto 0);                       -- Saída do valor imediato de 32 bits (signed)
            ALUOp : out STD_LOGIC_VECTOR(1 downto 0)               -- Saída do sinal de controle da ALU (2 bits)
        );
    end component;

    component EXECUTE is
        Port (
            clk : in STD_LOGIC;                              -- Sinal de clock
            reset : in STD_LOGIC;                            -- Sinal de reset
            ALUOp : in STD_LOGIC_VECTOR(1 downto 0);         -- Entrada do sinal de controle da ALU (2 bits)
            rs1_data : in STD_LOGIC_VECTOR(31 downto 0);     -- Entrada dos dados do registrador de origem 1 (32 bits)
            rs2_data : in STD_LOGIC_VECTOR(31 downto 0);     -- Entrada dos dados do registrador de origem 2 (32 bits)
            imm32 : in signed(31 downto 0);                  -- Entrada do valor imediato de 32 bits (signed)
            alu_result : out STD_LOGIC_VECTOR(31 downto 0);  -- Saída do resultado da ALU (32 bits)
            zero : out STD_LOGIC                             -- Saída do sinal de zero da ALU
        );
    end component;

    component MEM is
        Port (
            clk : in STD_LOGIC;                                 -- Sinal de clock
            reset : in STD_LOGIC;                               -- Sinal de reset
            addr_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada do endereço da memória de dados (32 bits)
            data_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada dos dados a serem escritos na memória de dados (32 bits)
            read_en : in STD_LOGIC;                              -- Sinal de habilitação de leitura
            write_en : in STD_LOGIC;                             -- Sinal de habilitação de escrita
            data_out : out STD_LOGIC_VECTOR(31 downto 0)         -- Saída dos dados lidos da memória de dados (32 bits)
        );
    end component;

    component WB is
        Port (
            clk : in STD_LOGIC;                             -- Sinal de clock
            reset : in STD_LOGIC;                           -- Sinal de reset
            rd : in STD_LOGIC_VECTOR(4 downto 0);           -- Entrada do registrador de destino (5 bits)
            alu_result : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada do resultado da ALU (32 bits)
            mem_data : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada dos dados lidos da memória (32 bits)
            mem_to_reg : in STD_LOGIC;                      -- Sinal de controle para seleção dos dados a serem escritos no registrador
            reg_data : out STD_LOGIC_VECTOR(31 downto 0)    -- Saída dos dados a serem escritos no registrador (32 bits)
        );
    end component;

    -- Instanciação dos componentes internos
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

    signal rs1_data_reg : STD_LOGIC_VECTOR(31 downto 0);     -- Registrador para armazenar o valor dos dados do registrador de origem 1
    signal rs2_data_reg : STD_LOGIC_VECTOR(31 downto 0);     -- Registrador para armazenar o valor dos dados do registrador de origem 2
    signal addr_in_reg : STD_LOGIC_VECTOR(31 downto 0);      -- Registrador para armazenar o valor do endereço da memória de dados (32 bits)
    signal data_in_reg : STD_LOGIC_VECTOR(31 downto 0);      -- Registrador para armazenar o valor dos dados a serem escritos na memória de dados (32 bits)
    signal read_en_reg : STD_LOGIC;                          -- Registrador para armazenar o sinal de habilitação de leitura
    signal write_en_reg : STD_LOGIC;                         -- Registrador para armazenar o sinal de habilitação de escrita
    signal data_out_reg : STD_LOGIC_VECTOR(31 downto 0);     -- Registrador para armazenar o valor dos dados lidos da memória de dados (32 bits)
    signal mem_to_reg_reg : STD_LOGIC;                       -- Registrador para armazenar o sinal de controle para seleção dos dados a serem escritos no registrador
	 signal fetch_done, decode_done, execute_done,mem_done,wb_done : STD_LOGIC; -- sinais de controle pipelines
    -- Instanciação dos componentes internos
   FETCH_inst: FETCH
    port map(
        clk => clk,
        reset => reset,
        pc_out => pc_reg,
        pc_mem_out => pc_mem_out_reg,
        instruction_out => instruction_out_reg
    );

    DECODE_inst: DECODE
    port map(
        clk => clk,
        reset => reset,
        instruction_in => instruction_out_reg,
        rs1 => rs1_reg,
        rs2 => rs2_reg,
        rd => rd_reg,
        imm32 => imm32_reg,
        ALUOp => ALUOp_reg
    );

    EXECUTE_inst: EXECUTE
    port map(
        clk => clk,
        reset => reset,
        ALUOp => ALUOp_reg,
        rs1_data => rs1_data_reg,
        rs2_data => rs2_data_reg,
        imm32 => imm32_reg,
        alu_result => alu_result_reg,
        zero => zero_reg
    );

    MEM_inst: MEM
    port map(
        clk => clk,
        reset => reset,
        addr_in => addr_in_reg,
        data_in => data_in_reg,
        read_en => read_en_reg,
        write_en => write_en_reg,
        data_out => data_out_reg
    );

    WB_inst: WB
    port map(
        clk => clk,
        reset => reset,
        rd => rd_reg,
        alu_result => alu_result_reg,
        mem_data => data_out_reg,
        mem_to_reg => mem_to_reg_reg,
        reg_data => rs1_data_reg
    );

    -- Saída dos sinais de controle para o estágio de memória
    read_en <= read_en_reg;
    write_en <= write_en_reg;

    -- Saída dos registradores de estágio
    pc_out <= pc_reg;
    instruction_out <= instruction_out_reg;
    rs1 <= rs1_reg;
    rs2 <= rs2_reg;
    rd <= rd_reg;
    imm32 <= imm32_reg;
    ALUOp <= ALUOp_reg;
    alu_result <= alu_result_reg;
    zero <= zero_reg;

    process (clk, reset)
begin

  if reset = '1' then
    -- Sinais de reset para cada estágio
    fetch_done <= '0';
    decode_done <= '0';
    execute_done <= '0';
    mem_done <= '0';
  elsif rising_edge(clk) then
    -- Ativação dos estágios sequenciais
    if fetch_done = '0' then
      fetch_done <= '1';
    elsif decode_done = '0' and fetch_done = '1' then
      decode_done <= '1';
    elsif execute_done = '0' and decode_done = '1' then
      execute_done <= '1';
    elsif mem_done = '0' and execute_done = '1' then
      mem_done <= '1';
    end if;
  end if;
end process;

-- Processo para o estágio FETCH
process (clk, fetch_done)
begin
  if fetch_done = '1' then
			 wait until rising_edge(clk);
			 -- logica do fetch
  end if;
end process;

-- Processo para o estágio DECODE
process (clk, decode_done)
begin
  if decode_done = '1' then
			 wait until rising_edge(clk);
			 -- logica do decode
  end if;
end process;

-- Processo para o estágio EXECUTE
process (clk, execute_done)
begin
  if execute_done = '1' then
			 wait until rising_edge(clk);
			 -- logica do execute
  end if;
end process;
-- Processo para o estágio MEM
process (clk, mem_done)
begin
  if mem_done = '1' then
			 wait until rising_edge(clk);
			 -- logica do mem
  end if;
end process;

-- Processo para o estágio WB
process (clk, wb_done)
begin
  if wb_done = '1' then
			 wait until rising_edge(clk);
			 -- logica do wb
  end if;
end process;

end behavioral;
