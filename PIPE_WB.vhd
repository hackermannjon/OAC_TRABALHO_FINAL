entity WB is
    Port (
        clk : in STD_LOGIC;                             -- Sinal de clock
        reset : in STD_LOGIC;                           -- Sinal de reset
        rd : in STD_LOGIC_VECTOR(4 downto 0);           -- Entrada do registrador de destino (5 bits)
        alu_result : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada do resultado da ALU (32 bits)
        mem_data : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada dos dados lidos da memória (32 bits)
        mem_to_reg : in STD_LOGIC;                      -- Sinal de controle para seleção dos dados a serem escritos no registrador
        reg_data : out STD_LOGIC_VECTOR(31 downto 0)    -- Saída dos dados a serem escritos no registrador (32 bits)
    );
end WB;

architecture behavioral of WB is
    signal reg_data_reg : STD_LOGIC_VECTOR(31 downto 0);  -- Registrador para armazenar os dados a serem escritos no registrador

begin
    -- Saída dos dados a serem escritos no registrador
    reg_data <= reg_data_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            reg_data_reg <= (others => '0');
        elsif rising_edge(clk) then
            if mem_to_reg = '1' then
                reg_data_reg <= mem_data;
            else
                reg_data_reg <= alu_result;
            end if;
        end if;
    end process;
end behavioral;
