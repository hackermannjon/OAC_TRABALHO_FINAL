library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_FETCH is
    Port (
        clk, reset, ALUSRC, IN_MUX : in STD_LOGIC;                            -- Clock signal
        FETCH_DATA : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  -- Source for updating PC (e.g., branch target, jump address)
        FETCH_ADDR : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end PIPE_FETCH;

architecture behavioral of PIPE_FETCH is

component PC is
    Port (
        clk, reset : in STD_LOGIC;                            -- Clock signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end component;


component Mux21 is
    Port (
        sel : in STD_LOGIC;                          -- Sinal de seleção (0 ou 1)
        data0 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 0 (32 bits)
        data1 : in STD_LOGIC_VECTOR(31 downto 0);    -- Dado de entrada 1 (32 bits)
        output : out STD_LOGIC_VECTOR(31 downto 0)   -- Saída do multiplexador (32 bits)
    );
end component;


component MI is
    port (
        clk      : in    std_logic;
        addr     : in    std_logic_vector(31 downto 0);
        data_out : out   std_logic_vector(31 downto 0)
    );
end component;

component Somador8bits is
   Port (
        asoma : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada A de 8 bits
        bsoma : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada B de 8 bits
        sum : out STD_LOGIC_VECTOR(31 downto 0)  -- Saída de soma de 8 bits
    );
end component;



begin
signal  data0, data1, output,pc_initial, pc_mem_in, pc_out,pc_out_D,pc_out_E, asoma, bsoma, sum : STD_LOGIC_VECTOR(31 downto 0);

SUM_FETCH : Somador8bits 
port map (
        asoma => pc_out,    -- Entrada A de 8 bits
        bsoma => std_logic_vector(4),    -- Entrada B de 8 bits
        sum => sum  -- Saída de soma de 8 bits
    );


MUX_FETCH : Mux21 
port map (
        sel => ALUSRC       ,                  -- Sinal de seleção (0 ou 1)
        data0 => sum    ,-- Dado de entrada 0 (32 bits)
        data1 => IN_MUX    ,-- Dado de entrada 1 (32 bits)
        output => output   -- Saída do multiplexador (32 bits)
);
PC_FETCH : PC
port map  (
        clk => clk     ,         -- Sinal de clock
        reset => reset ,           -- Sinal de reset
		  pc_in => output ,-- entrada de endereço do PC
        pc_out => pc_out
    );
MI_FETCH : MI
port map   (
        clk => clk     ,         						-- Sinal de clock
        addr => pc_out  ,      				-- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        data_out => FETCH_DATA  -- Saída da instrução da memória de instruções (32 bits)
    );

end behavioral;