library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_WB is
    Port (
	 
	 
	clk : in std_logic;
	ULA_RESULT, DATA : in STD_LOGIC_VECTOR(31 downto 0);
	RegWrite, Mem2Reg : in std_logic;
	RD: in std_logic_vector(11 downto 7);
	WRITE_DATA : out STD_LOGIC_VECTOR(31 downto 0);
	RD_LAST: out std_logic_vector(11 downto 7);
	regw, m2r : out std_logic


    );
end PIPE_WB;

architecture behavioral of PIPE_WB is
signal m2r_s  : std_logic;
signal	WRITE_DATA_s :  STD_LOGIC_VECTOR(31 downto 0);


component Mux21 is
    Port (
        sel : in STD_LOGIC;                          -- Sinal de seleção (0 ou 1)
        data0 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 0 (32 bits)
        data1 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 1 (32 bits)
        output : out STD_LOGIC_VECTOR(31 downto 0)   -- Saída do multiplexador (32 bits)
    );
end component;




begin



WB_MUX : Mux21 
 Port MAP(
        sel     =>    m2r_s ,      -- Sinal de seleção (0 ou 1)
        data0   => ULA_RESULT ,      -- Dado de entrada 0 (32 bits)
        data1   => DATA  ,  -- Dado de entrada 1 (32 bits)
        output  =>   WRITE_DATA_s-- Saída do multiplexador (32 bits)
    );



process(clk) begin

	if rising_edge(clk) then
	
	
		WRITE_DATA <= WRITE_DATA_s;
	
		m2r_s <= Mem2Reg;
		
		
		RD_LAST <= RD;
		
		regw <= RegWrite;
	
	
	end if;
	end process;







	
end behavioral;
