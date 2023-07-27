library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PIPELINE_TB is
end PIPELINE_TB;

architecture behavior of PIPELINE_TB is
    signal clk, reset_flag : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '1';

    -- Sinais para acompanhar os valores dos registradores
    signal ENDERECO_tb, INSTRUCAO_tb : STD_LOGIC_VECTOR(31 downto 0);
    signal RS1_tb, RS2_tb, RD_tb : STD_LOGIC_VECTOR(11 downto 7);

    -- Component declaration for PIPELINE
    component PIPELINE is
        Port (
            clk, reset : in STD_LOGIC;               -- Sinal de clock e reset
            RS1, RS2, ENDERECO, INSTRUCAO : out STD_LOGIC_VECTOR(31 downto 0);
            RD_out : out STD_LOGIC_VECTOR(11 downto 7)
        );
    end component;

begin
    U1: PIPELINE
    Port map(
        clk => clk,
        reset => reset_tb,
        ENDERECO => ENDERECO_tb,
        INSTRUCAO => INSTRUCAO_tb,
        RS1 => RS1_tb,
        RS2 => RS2_tb,
        RD_out => RD_tb
    );

    -- Clock process
    process
    begin
        while now < 960 ns loop
            clk <= '0';
            wait for 100 ns;
            if reset_flag = '0' then
                reset_tb <= '1';
                reset_flag <= '1';
            elsif reset_flag = '1' then 
                reset_tb <= '0';
            end if;
            clk <= '1';
            wait for 100 ns;
            if reset_flag = '0' then
                reset_tb <= '1';
                reset_flag <= '1';
            elsif reset_flag = '1' then
                reset_tb <= '0';
            end if;
        end loop;
    end process;

    -- Print the values of the pipeline outputs


end behavior;
