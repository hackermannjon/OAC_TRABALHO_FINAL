library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
  port (
    instruction_mi_in : in std_logic_vector(31 downto 0);
    imm32 : out signed(31 downto 0)
  );
end genImm32;
architecture a of genImm32 is
begin

  process (instruction_mi_in)
  begin
    case instruction_mi_in(6 downto 0) is
      when "0000011" => -- I-type
        imm32 <= resize(signed(instruction_mi_in(31 downto 20) & "000000000000"), 32);
      when "0100011" => -- S-type
        imm32 <= resize(signed(instruction_mi_in(31 downto 25) & instruction_mi_in(11 downto 7) & "00000"), 32);
      when "1100011" => -- SB-type
        imm32 <= resize(signed(instruction_mi_in(31) & instruction_mi_in(7) & instruction_mi_in(30 downto 25) & instruction_mi_in(11 downto 8) & "0"), 32);
      when "1101111" => -- UJ-type
        imm32 <= resize(signed(instruction_mi_in(31) & instruction_mi_in(19 downto 12) & instruction_mi_in(20) & instruction_mi_in(30 downto 21) & "0"), 32);
      when "0010111" | "0110111" => -- U-type
        imm32 <= resize(signed(instruction_mi_in(31 downto 12) & "000000000000"), 32);
      when others => -- R-type and invalid opcodes
        imm32 <= (others => '0');
    end case;
  end process;

end a;
