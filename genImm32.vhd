library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out signed(31 downto 0)
  );
end genImm32;
architecture a of genImm32 is
begin

  process (instr)
  begin
    case instr(6 downto 0) is
      when "0000011" => -- I-type
        imm32 <= resize(signed(instr(31 downto 20) & "000000000000"), 32);
      when "0100011" => -- S-type
        imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7) & "00000"), 32);
      when "1100011" => -- SB-type
        imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32);
      when "1101111" => -- UJ-type
        imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & "0"), 32);
      when "0010111" | "0110111" => -- U-type
        imm32 <= resize(signed(instr(31 downto 12) & "000000000000"), 32);
      when others => -- R-type and invalid opcodes
        imm32 <= (others => '0');
    end case;
  end process;

end a;
