library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_EXECUTE is
    Port (
        zero : out STD_LOGIC;  
        ADDR : in STD_LOGIC_VECTOR(31 downto 0);  -- Source for updating PC (e.g., branch target, jump address)
		  ro1, ro2 : in std_logic_vector(31 downto 0);
		  imm32 : in std_logic_vector(31 downto 0);

		  ALUSrc : in std_logic;
		  opcode_ula: in std_logic_vector(3 downto 0);
		  ro2_execute, RESULT_ULA,RESULT_ADDR: out std_logic_vector(31 downto 0)

		  -- Output PC value
    );
end PIPE_EXECUTE;

architecture behavioral of PIPE_EXECUTE is
signal  output :  STD_LOGIC_VECTOR(31 downto 0);   -- Saída do multiplexador (32 bits)
signal imm32left : STD_LOGIC_VECTOR(31 downto 0);

component Mux21 is
    Port (
        sel : in STD_LOGIC;                          -- Sinal de seleção (0 ou 1)
        data0 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 0 (32 bits)
        data1 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 1 (32 bits)
        output : out STD_LOGIC_VECTOR(31 downto 0)   -- Saída do multiplexador (32 bits)
    );
end component;


component ULA is
	generic (WSIZE : natural := 32);
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end component;

begin


EXECUTE_MUX: Mux21 
    Port MAP(
        sel => ALUSrc,           -- Sinal de seleção (0 ou 1)
        data0   =>  ro2, -- Dado de entrada 0 (32 bits)
        data1     => imm32,-- Dado de entrada 1 (32 bits)
        output   => output-- Saída do multiplexador (32 bits)
    );


EXECUTE_ULA : ULA 
	port map(
		opcode => opcode_ula,
		A => ro1,
		B => output,
		Z => RESULT_ULA,
		zero => zero
);



RESULT_ADDR <= std_logic_vector(shift_left(unsigned(imm32), 1) + unsigned(ADDR));
ro2_execute <= ro2;



	
end behavioral;
