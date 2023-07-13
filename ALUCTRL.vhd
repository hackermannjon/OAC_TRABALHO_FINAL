library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is
    port (
        opcode : in std_logic_vector(7 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        ALUOp : out std_logic_vector(1 downto 0)
    );
end ALUControl;

architecture behavioral of ALUControl is
begin
    process (opcode, funct3)
    begin
        case opcode is
            when x"33" =>
                ALUOp <= "10";

            when x"03" | x"13" | x"67" =>
                ALUOp <= "00";

            when x"23" =>
                ALUOp <= "00";

            when x"63" =>
                ALUOp <= "01";

            when others =>
                ALUOp <= "00";
        end case;
    end process;
end;
