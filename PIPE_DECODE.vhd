library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPE_DECODE is
  Port (
	 PIPE_DECODE_done : in STD_LOGIC;
    clk : in STD_LOGIC;                                -- Sinal de clock
    reset : in STD_LOGIC;                              -- Sinal de reset
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
	 ro1, ro2out : out std_logic_vector(31 downto 0)	-- Instrução vinda do PIPE_FETCH
  );
end PIPE_DECODE;

architecture behavioral of PIPE_DECODE is
-- Componentes internos

	component Controle is
    port (
        instr : in std_logic_vector(31 downto 0);
        ALUOp : out std_logic_vector(1 downto 0);
		  opcode_ula: out std_logic_vector(3 downto 0);
        ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic
    );
end component;

component genImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out signed(31 downto 0)
  );
 end component;

    component PIPE_FETCH is
        Port (
        clk : in STD_LOGIC;               -- Sinal de clock
        reset : in STD_LOGIC;             -- Sinal de reset
        PIPE_FETCH_done : in STD_LOGIC;        -- Entrada PIPE_FETCH_done (0 ou 1)
        instruction : out STD_LOGIC_VECTOR(31 downto 0) -- Saída da instrução da memória de instruções
        );
    end component;
  -- Componente X_REG para escrita de registradores
  component X_REG is
    port (
      clk, wren : in std_logic;
      rs1, rs2, rd : in std_logic_vector(4 downto 0);
      data : in std_logic_vector(31 downto 0);
      ro1, ro2 : out std_logic_vector(31 downto 0)
    );
  end component;
     signal ALUOp :  std_logic_vector(1 downto 0);
   signal ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg :  std_logic;
	signal imm32 : signed(31 downto 0);
	signal ro2xreg : std_logic_vector(31 downto 0);
  
  
begin
PIPE_FETCH_inst : PIPE_FETCH
		port map (
        clk => clk,
        reset => reset,
        instruction => instruction
        );
		  gen_inst : genImm32
		port map (
			instr => instruction,
			imm32 => imm32
	);
	 Controle_inst : Controle
        port map (
            instr 	=> instruction,
				ALUSrc 	=>	ALUSrc,
				Branch	=>	Branch,
				MemRead	=>	MemRead,
				MemWrite =>	MemWrite,
				RegWrite	=>	RegWrite,
				Mem2Reg	=>	Mem2Reg 
        );
		  XREG_inst : X_REG

		port map(
      clk => clk,
		wren => RegWrite,
      rs1 => rs1,
		rs2 => rs2,
		rd => rd,
      ro1 => ro1,
		ro2 => ro2xreg 
    );
  process (PIPE_DECODE_done, clk, reset)
 begin
	
	if PIPE_DECODE_done = 1 then
		
		
	
		
		  
		rd <= instruction(11 downto 7);
			rs1 <= instruction(24 downto 20);
	rs2 <= instruction(19 downto 15);

		
	 
	 if ALUSRC = 0 then
	 ro2out <= ro2xreg;
	 else 
	 ro2out <= imm32;
	 end if;
	 
	 
end if;
end process;

end behavioral;
