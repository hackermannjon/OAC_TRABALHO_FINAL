library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Somador32bits is
    Port (
        a : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada A de 32 bits
        b : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada B de 32 bits
        sum : out STD_LOGIC_VECTOR(31 downto 0)  -- Saída de soma de 32 bits
    );
end Somador32bits;

architecture Behavioral of Somador32bits is
begin
    process(a, b)
        variable temp_sum : UNSIGNED(31 downto 0);
    begin
        temp_sum := UNSIGNED(a) + UNSIGNED(b);  -- Soma as entradas
        sum <= STD_LOGIC_VECTOR(temp_sum);      -- Converte a soma para a saída
    end process;

end Behavioral;

entity SomadorEnderecos is
    Port (
        endereco_a : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada do endereço A de 32 bits
        endereco_b : in STD_LOGIC_VECTOR(31 downto 0);  -- Entrada do endereço B de 32 bits
        resultado : out STD_LOGIC_VECTOR(31 downto 0)   -- Saída do resultado da soma de endereços de 32 bits
    );
end SomadorEnderecos;

architecture Behavioral of SomadorEnderecos is
    component Somador32bits is
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            sum : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal soma : STD_LOGIC_VECTOR(31 downto 0);  -- Sinal intermediário para a soma de endereços

begin
    SomadorA: Somador32bits port map(endereco_a, endereco_b, soma);  -- Primeiro somador para a soma dos endereços

    resultado <= soma;  -- Saída do resultado da soma de endereços

end Behavioral;
