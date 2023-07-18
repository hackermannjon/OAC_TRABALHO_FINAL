	library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

	entity PIPE_EXECUTE is
		 Port (
			  
			  clk,PIPE_EXECUTE_done : in STD_LOGIC;                              -- Sinal de clock
			  reset : in STD_LOGIC                         -- Sinal de reset                           
		 );
	end PIPE_EXECUTE;

	architecture behavioral of PIPE_EXECUTE is
		 -- Componentes internos
		 component PIPE_DECODE is
			Port (
			   PIPE_DECODE_done : in STD_LOGIC;
				clk : in STD_LOGIC;                                -- Sinal de clock
				reset : in STD_LOGIC;                              -- Sinal de reset
				instruction : in STD_LOGIC_VECTOR(31 downto 0);
				ro1, ro2 : out std_logic_vector(31 downto 0)	-- Instrução vinda do FETCH
			);
		 end component;
		 component ula is
			  port (
					opcode : in std_logic_vector(3 downto 0);
					A, B : in std_logic_vector(32 downto 0);
					Z : out std_logic_vector(32 downto 0);
					zero : out std_logic);
		 end component;
		 component Controle is
			port (
				instr : in std_logic_vector(31 downto 0);
        ALUOp : out std_logic_vector(1 downto 0);
		  opcode_ula: out std_logic_vector(3 downto 0);
        ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic);
		 end component;
		signal ro1, ro2 : std_logic_vector(31 downto 0);
		begin

		ula_inst: ula
			  port map(
					opcode => opcode_ula,
					A => ro1,
					B => ro2,
					Z => alu_result,
					zero => zero
					);
		 PIPE_DECODE_inst: PIPE_DECODE
		 Port map (
				clk  => clk,                  -- Sinal de clock
				reset => reset ,                    -- Sinal de reset
				ro1  => ro1,
				ro2 => ro2	-- Instrução vinda do FETCH
		 );
		 controle_inst : Controle
		 port map (
		  opcode_ula => opcode
		  );

	
		 -- Instanciação dos componentes internos,
		 

		 
	end behavioral;
