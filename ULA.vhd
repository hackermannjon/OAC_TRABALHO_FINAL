library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
	generic (WSIZE : natural := 32);
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end ULA;

architecture ULA_arch of ULA is
	signal result : std_logic_vector(WSIZE-1 downto 0);
	signal auxzero : std_logic;

begin

	Z <= result;

	proc_ULA: process(A, B, opcode, result)
	begin
	
		case opcode is
			when "0000" => result <= std_logic_vector(unsigned(A) + unsigned(B));
			when "0001" => result <= std_logic_vector(unsigned(A) - unsigned(B));
			when "0010" => result <= std_logic_vector(A and B);
			when "0011" => result <= std_logic_vector(A or B);
			when "0100" => result <= std_logic_vector(A xor B);
			when "0101" => result <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
			when "0110" => result <= std_logic_vector(shift_left(signed(A), to_integer(unsigned(B))));
			when "0111" => result <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			when "1000" => result <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
			when "1001" => if (signed(A) < signed(B)) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when "1010" => if (unsigned(A) < unsigned(B)) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when "1011" => if (signed(A) >= signed(B)) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when "1100" => if (unsigned(A) >= unsigned(B)) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when "1101" => if (A = B) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when "1110" => if (A /= B) then
												result <= std_logic_vector(to_unsigned(1, WSIZE));
											else
												result <= std_logic_vector(to_unsigned(0, WSIZE));
											end if;
			when others => result <= std_logic_vector(A);
		end case;
		
		if result = std_logic_vector(to_unsigned(0, WSIZE)) then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end process;
end ULA_arch;
