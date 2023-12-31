library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux21 is
    Port (
        sel : in STD_LOGIC;                          -- Sinal de seleção (0 ou 1)
        data0 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 0 (32 bits)
        data1 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 1 (32 bits)
        output : out STD_LOGIC_VECTOR(31 downto 0)   -- Saída do multiplexador (32 bits)
    );
end Mux21;

architecture Behavioral of Mux21 is
begin
    process(sel, data0, data1)
    begin
        if sel = '0' then
            output <= data0;   -- Saída é igual ao dado de entrada 0 quando sel = 0
        else
            output <= data1;   -- Saída é igual ao dado de entrada 1 quando sel = 1
        end if;
    end process;
end Behavioral;
