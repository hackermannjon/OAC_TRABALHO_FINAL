library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity PIPE_MEM is
    Port (
        clk,PIPE_MEM_done : in STD_LOGIC;                                 -- Sinal de clock
        reset : in STD_LOGIC;                               -- Sinal de reset
        addr_in : in STD_LOGIC_VECTOR(7 downto 0);           -- Entrada do endereço da memória de dados (8 bits)
        data_in : in STD_LOGIC_VECTOR(31 downto 0);          -- Entrada dos dados a serem escritos na memória de dados (32 bits)
        data_out : out STD_LOGIC_VECTOR(31 downto 0)         -- Saída dos dados lidos da memória de dados (32 bits)
    );
end PIPE_MEM;

architecture Behavioral of PIPE_MEM is
component X_REG is
  generic (WSIZE : natural := 32);
  port (
    clk, wren, decode_done : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(WSIZE-1 downto 0);
    ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
  );
end component;

component ula is
	generic (WSIZE : natural := 32);
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		zero : out std_logic);
end component;
component Controle is
    port (
        instr : in std_logic_vector(31 downto 0);
        ALUOp : out std_logic_vector(1 downto 0);
		  opcode_ula: out std_logic_vector(3 downto 0);
        ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic
    );
end component;

    type memory_array is array (natural range <>) of std_logic_vector(31 downto 0);
    constant MEM_SIZE: integer := 2048;  -- Tamanho da memória (endereço final - endereço inicial + 1)
    constant FILENAME: string := "data.bin";  -- Nome do arquivo binário
    file mem_file: text open read_mode is FILENAME;
    variable mem_data: memory_array(0 to MEM_SIZE - 1);
    variable file_line: line;
    variable read_addr: integer := 0;
	 signal MemRead,MemWrite : std_logic;
begin
	ula_inst : ula
	Port map (
			z => data_in
	);
	Controle_inst : Controle
	Port map 
	( 	 MemRead => MemRead,
		 MemWrite => MemWrite
	);
	xreg_inst : X_REG
	Port map (
	data => data_out
	
	);


    process(clk, reset)
    begin
	 if PIPE_MEM_done = 1 then
        if reset = '1' then
            -- Reinicializar a variável de leitura do arquivo
            read_addr := 0;
        elsif rising_edge(clk) then
            -- Leitura do arquivo de dados
            if read_en = '1' then
                if read_addr < MEM_SIZE then
                    readline(mem_file, file_line);
                    read(file_line, mem_data(read_addr));
                    read_addr := read_addr + 1;
                end if;
            end if;
            
            -- Escrita na memória de dados
            if write_en = '1' then
                mem_data(to_integer(unsigned(addr_in))) := data_in;
            end if;
        end if;
	 end if ;
    end process;
    
    -- Saída dos dados lidos da memória de dados
    data_out <= mem_data(to_integer(unsigned(addr_in)));
end Behavioral;
