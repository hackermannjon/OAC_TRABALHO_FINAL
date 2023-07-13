entity DECODE is
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
end DECODE;

architecture behavioral of DECODE is
    signal rs1_reg : STD_LOGIC_VECTOR(4 downto 0);             -- Registrador para armazenar o valor do registrador de origem 1
    signal rs2_reg : STD_LOGIC_VECTOR(4 downto 0);             -- Registrador para armazenar o valor do registrador de origem 2
    signal rd_reg : STD_LOGIC_VECTOR(4 downto 0);              -- Registrador para armazenar o valor do registrador de destino
    signal imm32_reg : signed(31 downto 0);                    -- Registrador para armazenar o valor imediato de 32 bits
    signal ALUOp_reg : STD_LOGIC_VECTOR(1 downto 0);           -- Registrador para armazenar o sinal de controle da ALU

    -- Componentes internos
    component genImm32 is
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    component ALUControl is
        port (
            opcode : in std_logic_vector(7 downto 0);
            funct3 : in std_logic_vector(2 downto 0);
            ALUOp : out std_logic_vector(1 downto 0)
        );
    end component;

begin
    -- Instanciação dos componentes internos
    genImm32_inst: genImm32
    port map(
        instr => instruction_in,
        imm32 => imm32_reg
    );

    ALUControl_inst: ALUControl
    port map(
        opcode => instruction_in(31 downto 25),
        funct3 => instruction_in(14 downto 12),
        ALUOp => ALUOp_reg
    );

    -- Saída dos registradores de origem 1, origem 2, destino, valor imediato e sinal de controle da ALU
    rs1 <= rs1_reg;
    rs2 <= rs2_reg;
    rd <= rd_reg;
    imm32 <= imm32_reg;
    ALUOp <= ALUOp_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            rs1_reg <= (others => '0');
            rs2_reg <= (others => '0');
            rd_reg <= (others => '0');
        elsif rising_edge(clk) then
            rs1_reg <= instruction_in(19 downto 15);
            rs2_reg <= instruction_in(24 downto 20);
            rd_reg <= instruction_in(11 downto 7);
        end if;
    end process;
end behavioral;
