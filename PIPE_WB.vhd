library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WB is
    Port (
        clk : in STD_LOGIC;                              -- Sinal de clock
        reset : in STD_LOGIC;                            -- Sinal de reset
        RegWrite : in STD_LOGIC;                         -- Sinal de escrita em registrador
        Mem2Reg : in STD_LOGIC;                           -- Sinal de escrita do resultado da memória em registrador
        alu_result : in STD_LOGIC_VECTOR(31 downto 0);   -- Entrada do resultado da ALU (32 bits)
        mem_data : in STD_LOGIC_VECTOR(31 downto 0);     -- Entrada dos dados lidos da memória (32 bits)
        reg_dest : in STD_LOGIC_VECTOR(4 downto 0);      -- Registrador de destino
        reg_out : out STD_LOGIC_VECTOR(31 downto 0)      -- Saída do registrador lido
    );
end WB;

architecture behavioral of WB is
    signal reg_file : std_logic_vector(31 downto 0);    -- Registrador de arquivos
	 
	 component X_REG is
    generic (WSIZE : natural := 32);
    port (
      clk, wren : in std_logic;
      rs1, rs2, rd : in std_logic_vector(4 downto 0);
      data : in std_logic_vector(WSIZE-1 downto 0);
      ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
    );
  end component;


begin

		X_REG_inst : X_REG
    generic map (
      WSIZE => 32
    )
    port map (
      clk => clk,
      wren => RegWrite,
      rs1 => rs1,
      rs2 => rs2,
      rd => red_dest,
      data => mem_data,
      ro1 => ro1,
      ro2 => ro2
    );

    process (clk, reset)
    begin
        if reset = '1' then
            reg_file <= (others => '0');
            reg_out <= (others => '0');
        elsif rising_edge(clk) then
            if RegWrite = '1' then
                if Mem2Reg = '1' then
                    reg_file(reg_dest) <= mem_data;
                else
                    reg_file(reg_dest) <= alu_result;
                end if;
            end if;

            reg_out <= reg_file(to_integer(unsigned(reg_dest)));
        end if;
    end process;

end behavioral;
