library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity PIPE_FETCH is
    Port (
        clk, reset, ALUSRC : in STD_LOGIC;  
		  IN_MUX		: in STD_LOGIC_VECTOR(31 downto 0);
        FETCH_DATA : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  -- Source for updating PC (e.g., branch target, jump address)
        FETCH_ADDR : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end PIPE_FETCH;

architecture behavioral of PIPE_FETCH is

    signal updated_pc : STD_LOGIC_VECTOR(31 downto 0);

    component PC is
        Port (
            clk, reset : in STD_LOGIC;
            pc_in : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
            pc_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component Mux21 is
        Port (
            sel : in STD_LOGIC;
            data0 : in STD_LOGIC_VECTOR(31 downto 0);
            data1 : in STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component MI is
        port (
            clk      : in    std_logic;
            addr     : in    std_logic_vector(31 downto 0);
            data_out : out   std_logic_vector(31 downto 0)
        );
    end component;

    signal data0, data1, output, pc_initial, pc_mem_in, pc_out, pc_out_E, asoma, bsoma, sum : STD_LOGIC_VECTOR(31 downto 0);

begin


    MUX_FETCH : Mux21 
    port map (
        sel => ALUSRC,
        data0 => data0,
        data1 => IN_MUX,
        output => output
    );

    PC_FETCH : PC
    port map  (
        clk => clk,
        reset => reset,
        pc_in => output,
        pc_out => updated_pc
    );

    MI_FETCH : MI
    port map   (
        clk => clk,
        addr => pc_out,
        data_out => FETCH_DATA
    );

    process(clk)
    begin
	 data1  <= std_logic_vector(unsigned(updated_pc) + 4);
        if rising_edge(clk) then
				data0 <= data1; 
            pc_out <= updated_pc;
        end if;
    end process;

    FETCH_ADDR <= pc_out;

end behavioral;
