library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_DECODE is
    Port (
        clk, reset, RegWrite_in : in STD_LOGIC;  
        DATA, ADDR, INST : in STD_LOGIC_VECTOR(31 downto 0);  -- Source for updating PC (e.g., branch target, jump address)
        ADDR_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		  ro1, ro2 : out std_logic_vector(31 downto 0);
		  imm32 : out signed(31 downto 0);
		  RD_RESULT : IN STD_LOGIC_VECTOR(11 downto 7);
		  RD_OUT : OUT STD_LOGIC_VECTOR(11 downto 7);
		  ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic;
		  opcode_ula: out std_logic_vector(3 downto 0)


		  -- Output PC value
    );
end PIPE_DECODE;

architecture behavioral of PIPE_DECODE is

component X_REG is
  port (
    clk, wren  : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(31 downto 0);
    ro1, ro2 : out std_logic_vector(31 downto 0)
  );
end component;
SIGNAL 		  RD : STD_LOGIC_VECTOR(11 downto 7);

component Controle is
    port (
        instruction : in std_logic_vector(31 downto 0);
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

    

begin

DECODE_IMM32 : genImm32 
  port map (
    instr => INST,
    imm32 => imm32
  );
DECODE_CONTROLE : Controle
port map (
        instruction => INST,
		  opcode_ula => opcode_ula,
        ALUSrc => ALUSrc,
		  Branch => Branch,
		  MemRead => MemRead,
		  MemWrite =>  MemWrite,
		  RegWrite => RegWrite,
		  Mem2Reg => Mem2Reg
    );
DECODE_XREG : X_REG 
  port map(
    clk => clk,
	 wren  => RegWrite_in,
    rs1 => INST(19 downto 15),
	 rs2 => INST(24 downto 20),
	 rd => RD,
    data => DATA,
    ro1 => ro1,
	 ro2 => ro2
  );
	process(clk)
    begin
        if rising_edge(clk) then
				  ADDR_OUT <= ADDR;
				  RD <= RD_RESULT;
				  RD_OUT <= INST( 11 DOWNTO 7);

        end if;
    end process;
end behavioral;
