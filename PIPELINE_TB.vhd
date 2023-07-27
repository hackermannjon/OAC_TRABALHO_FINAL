library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
entity PIPELINE_TB is
end PIPELINE_TB;

architecture behavior of PIPELINE_TB is
    signal clk : std_logic := '0';
    signal reset_flag : std_logic := '0';
    signal reset_tb : std_logic := '0';

    -- Sinais para acompanhar os valores dos registradores
    signal teste_rs1, teste_rs2, teste_rd : std_logic_vector(4 downto 0) ;
    signal SUM_TB, PC_OUT_TB, INST_TB : std_logic_vector(31 downto 0) ;
	 signal WB_TB, MEM_TB, EXECUTE_TB, DECODE_TB, FETCH_TB        :  STD_LOGIC ;
	 signal ADDR : std_logic_vector(31 downto 0) := "00000000000000000000000000000000" ;

    -- Component declaration for PIPELINE
    component PIPELINE is
Port (
      clk : in STD_LOGIC;               -- Sinal de clock
		reset : in STD_LOGIC ;         -- Sinal de reset
		teste_rs1,teste_rs2, teste_rd : out std_logic_vector(4 downto 0);
		SUM_TB, PC_OUT_TB, INST_TB: out std_logic_vector(31 downto 0);
		ADDR : in std_logic_vector(31 downto 0);
		WB_TB, MEM_TB, EXECUTE_TB, DECODE_TB, FETCH_TB        : out STD_LOGIC 


 

);
 
    end component;

begin
    U1: PIPELINE
    Port map(
        clk => clk,
        reset => reset_tb,
        teste_rs1 => teste_rs1,
        teste_rs2 => teste_rs2,
        teste_rd => teste_rd,
        SUM_TB => SUM_TB,
        PC_OUT_TB => PC_OUT_TB,
        INST_TB => INST_TB,
		  WB_TB => WB_TB,
		  ADDR => ADDR,
		  MEM_TB => MEM_TB,
		  EXECUTE_TB => EXECUTE_TB,
		  DECODE_TB => DECODE_TB,
		  FETCH_TB  =>   FETCH_TB    
    );

    -- Clock process
    process
    begin
        while now < 960 ns loop
            if reset_flag = '0' then
                reset_tb <= '1';
                reset_flag <= '1';
            elsif reset_flag = '1' then 
								ADDR <= std_logic_vector(unsigned(ADDR) + 4);

                reset_tb <= '0';
            end if;
				wait for 10 ns;

            clk <= not(clk);
				


            if reset_flag = '0' then
                reset_tb <= '1';
                reset_flag <= '1';
            elsif reset_flag = '1' then
                reset_tb <= '0';
            end if;
        end loop;
    end process;



end behavior;
