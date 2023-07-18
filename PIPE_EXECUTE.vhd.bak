entity EXECUTE is
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
end EXECUTE;

architecture behavioral of EXECUTE is
    signal alu_result_reg : STD_LOGIC_VECTOR(31 downto 0);  -- Registrador para armazenar o resultado da ALU
    signal zero_reg : STD_LOGIC;                            -- Registrador para armazenar o sinal de zero da ALU

    -- Componentes internos
    component ula is
        generic (WSIZE : natural := 32);
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(WSIZE-1 downto 0);
            Z : out std_logic_vector(WSIZE-1 downto 0);
            zero : out std_logic);
    end ula;

begin
    -- Instanciação dos componentes internos
    ula_inst: ula
    generic map(
        WSIZE => 32
    )
    port map(
        opcode => ALUOp,
        A => rs1_data,
        B => rs2_data,
        Z => alu_result_reg,
        zero => zero_reg
    );

    -- Saída do resultado da ALU e sinal de zero
    alu_result <= alu_result_reg;
    zero <= zero_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            alu_result_reg <= (others => '0');
            zero_reg <= '0';
        elsif rising_edge(clk) then
            alu_result_reg <= std_logic_vector( signed(rs1_data) + signed(imm32) );
            zero_reg <= '1' when alu_result_reg = (others => '0') else '0';
        end if;
    end process;
end behavioral;
