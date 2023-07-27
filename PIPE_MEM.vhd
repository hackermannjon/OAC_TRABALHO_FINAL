library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_MEM is
    Port (
   ADDRRESULT, ULARESULT: in STD_LOGIC_VECTOR(31 downto 0);
	ro2_OUTMEM : in std_logic_vector(31 downto 0);
	clk,reset, zero, Branch, MemRead, MemWrite : in std_logic;
	ADDRRESULT_OUT, DATA_OUT  : out STD_LOGIC_VECTOR(31 downto 0);
	PC_SEL : OUT std_logic
	

    );
end PIPE_MEM;

architecture behavioral of PIPE_MEM is

component MD is
    Port (
        clk : in STD_LOGIC;                                  -- Sinal de clock
        reset : in STD_LOGIC;                                -- Sinal de reset
        addr_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Entrada do endereço para a memória de dados
        data_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Dados de entrada para a memória de dados
        data_md_out : out STD_LOGIC_VECTOR(31 downto 0);     -- Saída de dados da memória de dados
        MemRead : in STD_LOGIC;                              -- Sinal de controle MemRead
        MemWrite : in STD_LOGIC                              -- Sinal de controle MemWrite
    );
end component;



begin



MEM_MD : MD
Port MAP(
        clk      => clk        ,                  
        reset       => reset       ,             
        addr_md_in => ULARESULT,
        data_md_in    => ro2_OUTMEM,
        data_md_out => DATA_OUT,
        MemRead =>  MemRead,
        MemWrite => MemRead
    );
	 
	 
	 
	 
process(clk) begin

	if rising_edge(clk) then
	PC_SEL <= zero AND Branch;
	ADDRRESULT_OUT <= ADDRRESULT;
	
	
	end if;
	end process;

	
end behavioral;
