library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
entity PIPELINE_TB is
end PIPELINE_TB;

architecture behavior of PIPELINE_TB is
  signal clk,reset : std_logic := '0';

  -- Sinais para acompanhar os valores dos registradores
  signal teste_rs1, teste_rs2, teste_rd : std_logic_vector(4 downto 0) := (others => '0');
  -- Função para exibir os valores dos sinais no console


  -- Sinais para acompanhar os valores dos registradores
  component PIPELINE is
    Port (
      clk : in STD_LOGIC;          -- Sinal de clock
      reset : in STD_LOGIC        -- Sinal de reset
   --   teste_rs1,teste_rs2, teste_rd : out std_logic_vector(4 downto 0)
    );
  end component;

begin
  U1: PIPELINE
  Port map(
    clk => clk,
    reset => reset
   -- teste_rs1 => teste_rs1,
  --  teste_rs2 => teste_rs2,
  --  teste_rd => teste_rd
  );

  -- Clock process
  process
	begin
  while now < 960 ns loop
	 reset <= '1';
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end loop;
end process;
end behavior;
