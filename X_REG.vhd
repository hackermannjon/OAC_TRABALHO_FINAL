library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity X_REG is
	generic	(WSIZE	:	natural	:=	32);
	
	port(
		clk, wren, reset	:	in std_logic;
		rs1, rs2, rd	:	in std_logic_vector(4 downto 0);
		data		:	in std_logic_vector(WSIZE-1 downto 0);
		ro1, ro2	:	out std_logic_vector(WSIZE-1 downto 0)
	);
end X_REG;

architecture main of X_REG is
	
	type 		regArray is array (0 to WSIZE-1) of std_logic_vector (WSIZE-1 downto 0);
	signal	bRegs: regArray := (others => (others => '0'));
	signal	rs1i, rs2i, rdi, i:	integer;
	
	begin
	rs1i	<=	to_integer(unsigned(rs1));
	rs2i	<=	to_integer(unsigned(rs2));
	rdi	<=	to_integer(unsigned(rd));
	i <= 0;
	
	process	(clk, reset)
	begin
		if	(reset = '1') then
			for i in 0 to WSIZE-1 loop
				bRegs(i)	<=	(bRegs(i)'range	=>	'0');
			end loop;
			ro1	<=	bRegs(0);
			ro2	<=	bRegs(0);
			
		elsif	rising_edge(clk) then
			ro1	<=	bRegs(rs1i);
			ro2	<=	bRegs(rs2i);
			if	(wren =  '1' and rdi /= 0) then
				bRegs(rdi)	<=	data;
			end if;
		end if;
		
	end process;	
end main;