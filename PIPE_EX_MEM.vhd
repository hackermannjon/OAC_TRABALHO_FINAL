--	Registradores de interface do RISC-V
-- Thiago Cardoso e Thiago Gomes


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPE_EX_MEM is

generic(WSIZE : natural := 32);      
    
port(
	clk : in std_logic;
	ADDRRESULT, ULARESULT : in STD_LOGIC_VECTOR(31 downto 0);
	ro2 : in std_logic_vector(31 downto 0);
	zero, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : in std_logic;
	RD_EXECUTE: in std_logic_vector(11 downto 7);
	
	ADDRRESULT_OUTMEM, ULARESULT_OUTMEM : out STD_LOGIC_VECTOR(31 downto 0);
	ro2_OUTMEM : out std_logic_vector(31 downto 0);
	zero_OUTMEM, Branch_OUTMEM, MemRead_OUTMEM, MemWrite_OUTMEM, RegWrite_OUTMEM, Mem2Reg_OUTMEM : out std_logic;
	RD_MEM: OUT std_logic_vector(11 downto 7)
	

	
);
end PIPE_EX_MEM;

architecture main of PIPE_EX_MEM is

begin

process(clk) begin

	if rising_edge(clk) then
		
	ADDRRESULT_OUTMEM <=			ADDRRESULT;
	ULARESULT_OUTMEM	<=		ULARESULT;
	ro2_OUTMEM	<=		ro2;
	zero_OUTMEM	<=		zero;
	Branch_OUTMEM		<=	Branch;
	MemRead_OUTMEM		<=	MemRead;
	MemWrite_OUTMEM	<=		MemWrite;
	RegWrite_OUTMEM	<=		RegWrite;
	Mem2Reg_OUTMEM		<=	Mem2Reg ;
	RD_MEM	<=		RD_EXECUTE;
		
		
	
	
	end if;
	end process;


end main;