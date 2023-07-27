--	Registradores de interface do RISC-V
-- Thiago Cardoso e Thiago Gomes


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPE_ID_EX is

generic(WSIZE : natural := 32);      
    
port(
	clk : in std_logic;
	ADDR : in STD_LOGIC_VECTOR(31 downto 0);
	ro1, ro2 : in std_logic_vector(31 downto 0);
	imm32 : in signed(31 downto 0);

	ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : in std_logic;
	opcode_ula: in std_logic_vector(3 downto 0);
	RD_DECODE: in std_logic_vector(11 downto 7);
	RD_EXECUTE: OUT std_logic_vector(11 downto 7);
	
	ADDR_out : out STD_LOGIC_VECTOR(31 downto 0);
	ro1_out, ro2_out : out std_logic_vector(31 downto 0);
	imm32_out : out std_logic_vector(31 downto 0);

	ALUSrc_out, Branch_out, MemRead_out, MemWrite_out, RegWrite_out, Mem2Reg_out : out std_logic;
	opcode_ula_out: out std_logic_vector(3 downto 0)
	

	
);
end PIPE_ID_EX;

architecture main of PIPE_ID_EX is

begin

process(clk) begin

	if rising_edge(clk) then
		
		ADDR_out <=  ADDR ;
		ro1_out <=  ro1 ;
		ro2_out <=  ro2 ;
		imm32_out <= std_logic_vector(imm32);
		ALUSrc_out <= ALUSrc;
		Branch_out <= Branch;
		MemRead_out <= MemRead;
		MemWrite_out <= MemWrite;
		Mem2Reg_out <= Mem2Reg;
		opcode_ula_out <= opcode_ula;
		
		
	
	
	end if;
	end process;


end main;