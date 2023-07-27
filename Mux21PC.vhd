library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux21PC is
    Port (
        sel_PC : in STD_LOGIC;                          -- Sinal de sel_PCeção (0 ou 1)
        data0_PC : in STD_LOGIC_VECTOR(7 downto 0);    -- Dado de entrada 0 (32 bits)
        data1_PC : in STD_LOGIC_VECTOR(7 downto 0);    -- Dado de entrada 1 (32 bits)
        output_PC : out STD_LOGIC_VECTOR(7 downto 0)   -- Saída do multiplexador (32 bits)
    );
end Mux21PC;

architecture Behavioral of Mux21PC is
begin
    process(sel_PC, data0_PC, data1_PC)
    begin
        if sel_PC = '0' then
            output_PC <= data0_PC;   -- Saída é igual ao dado de entrada 0 quando sel_PC = 0
        else
            output_PC <= data1_PC;   -- Saída é igual ao dado de entrada 1 quando sel_PC = 1
        end if;
    end process;
end Behavioral;
