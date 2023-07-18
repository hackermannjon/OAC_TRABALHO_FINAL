library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Somador8bits is
    Port (
        asoma : in STD_LOGIC_VECTOR(7 downto 0);    -- Entrada A de 8 bits
        bsoma : in STD_LOGIC_VECTOR(7 downto 0);    -- Entrada B de 8 bits
        sum : out STD_LOGIC_VECTOR(7 downto 0)  -- Saída de soma de 8 bits
    );
end Somador8bits;

architecture Behavioral of Somador8bits is
begin
    process(asoma, bsoma)
        variable temp_sum : UNSIGNED(7 downto 0);
    begin
        temp_sum := UNSIGNED(asoma) + UNSIGNED(bsoma);   -- Soma as entradas
        sum <= STD_LOGIC_VECTOR(temp_sum);       -- Converte a soma para a saída
    end process;

end Behavioral;
