entity MEM is
    Port (
        clk : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        addr_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada do endereço da memória de dados (32 bits)
        data_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada dos dados a serem escritos na memória de dados (32 bits)
        read_en : in STD_LOGIC;                              -- Sinal de habilitação de leitura
        write_en : in STD_LOGIC;                             -- Sinal de habilitação de escrita
        data_out : out STD_LOGIC_VECTOR(31 downto 0)         -- Saída dos dados lidos da memória de dados (32 bits)
    );
end MEM;

architecture behavioral of MEM is
    type memory is array (natural range <>) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem_data : memory(0 to 2**32 - 1);  -- Exemplo: memória com 4 GB (2^32 bytes)

begin
    process(clk, reset)
    begin
        if reset = '1' then
            mem_data <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if read_en = '1' then
                data_out <= mem_data(to_integer(unsigned(addr_in)));
            end if;
            
            if write_en = '1' then
                mem_data(to_integer(unsigned(addr_in))) <= data_in;
            end if;
        end if;
    end process;
end behavioral;
