library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Add the numeric_std library for signed type

entity PIPELINE is
Port (
        clk : in STD_LOGIC;               -- Sinal de clock
		  reset : in STD_LOGIC          -- Sinal de reset
		--  teste_rs1,teste_rs2, teste_rd : out std_logic_vector(4 downto 0)
 

);
end PIPELINE;

architecture behavioral of PIPELINE is

component PIPE_FETCH is
    Port (
        clk, reset, ALUSRC : in STD_LOGIC;  
		  IN_MUX	:	in STD_LOGIC_VECTOR(31 downto 0);
        FETCH_DATA : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  -- Source for updating PC (e.g., branch target, jump address)
        FETCH_ADDR : out STD_LOGIC_VECTOR(31 downto 0)        -- Output PC value
    );
end component;
signal FETCH_ADDR,FETCH_DATA : STD_LOGIC_VECTOR(31 downto 0);


component PIPE_IF_ID is
 
	port(
	clk : in std_logic;
	pc_in, instr_in : in std_logic_vector(31 downto 0);
	DECODE_ADDR, DECODE_INST : out std_logic_vector(31 downto 0)

);
end component;
signal DATA, DECODE_ADDR,DECODE_INST, DECODE_ADDR_OUT : STD_LOGIC_VECTOR(31 downto 0);
signal ro1, ro2 :  std_logic_vector(31 downto 0);
  signal  imm32 : signed(31 downto 0);

signal ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg :  std_logic;
signal opcode_ula : std_logic_vector(3 downto 0);

signal ADDR_out , DATA_OUT , ADDRRESULT_OUT   : STD_LOGIC_VECTOR(31 downto 0);
    signal ro1_out      : STD_LOGIC_VECTOR(31 downto 0);
    signal ro2_execute, ro2_out      : STD_LOGIC_VECTOR(31 downto 0);
    signal RESULT_ULA,RESULT_ADDR_OUT,imm32_out    : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUSrc_out   : std_logic;
    signal Branch_out   : std_logic;
    signal MemRead_out  : std_logic;
    signal MemWrite_out : std_logic;
    signal RegWrite_out : std_logic;
    signal zero, Mem2Reg_out  : std_logic;
    signal opcode_ula_out : std_logic_vector(3 downto 0);
	 signal RD_RESULT, RD_OUT, RD_OUT2 : STD_LOGIC_VECTOR(11 downto 7);
	 signal ADDRRESULT_OUTMEM_s : STD_LOGIC_VECTOR(31 downto 0);
    signal ULARESULT_OUTMEM_s  : STD_LOGIC_VECTOR(31 downto 0);
    signal ro2_OUTMEM_s        : STD_LOGIC_VECTOR(31 downto 0);
    signal zero_OUTMEM_s       : std_logic;
    signal Branch_OUTMEM_s     : std_logic;
    signal MemRead_OUTMEM_s    : std_logic;
    signal MemWrite_OUTMEM_s   : std_logic;
    signal RegWrite_OUTMEM_s   : std_logic;
    signal PC_SEL, Mem2Reg_OUTMEM_s    : std_logic;
    signal RD_MEM_s            : std_logic_vector(11 downto 7);
signal WRITE_DATA_s : STD_LOGIC_VECTOR(31 downto 0);
    signal RD_LAST_s    : std_logic_vector(11 downto 7);
    signal regw_s       : std_logic;
    signal m2r_s        : std_logic;


component PIPE_DECODE is
    Port (
        clk, reset, RegWrite_in : in STD_LOGIC;  
        DATA, ADDR, INST : in STD_LOGIC_VECTOR(31 downto 0);  -- Source for updating PC (e.g., branch target, jump address)
        ADDR_OUT : out STD_LOGIC_VECTOR(31 downto 0);
		  ro1, ro2 : out std_logic_vector(31 downto 0);
		  imm32 : out signed(31 downto 0);

		  ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic;
		  opcode_ula: out std_logic_vector(3 downto 0);
RD_RESULT : IN STD_LOGIC_VECTOR(11 downto 7);
		  RD_OUT : OUT STD_LOGIC_VECTOR(11 downto 7)

		  -- Output PC value
    );
end component;
component PIPE_ID_EX is    
port(
	clk : in std_logic;
	ADDR : in STD_LOGIC_VECTOR(31 downto 0);
	imm32 : in signed(31 downto 0);

	ro1, ro2 : in std_logic_vector(31 downto 0);
	ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : in std_logic;
	opcode_ula: in std_logic_vector(3 downto 0);
	
		
	ADDR_out : out STD_LOGIC_VECTOR(31 downto 0);
	ro1_out, ro2_out : out std_logic_vector(31 downto 0);
	imm32_out : out std_logic_vector(31 downto 0);

	ALUSrc_out, Branch_out, MemRead_out, MemWrite_out, RegWrite_out, Mem2Reg_out : out std_logic;
	opcode_ula_out: out std_logic_vector(3 downto 0);
	
	RD_DECODE: in std_logic_vector(11 downto 7);
	RD_EXECUTE: OUT std_logic_vector(11 downto 7)
	
);
end component;

component PIPE_EXECUTE is
    Port (
   zero : out STD_LOGIC;  
        ADDR : in STD_LOGIC_VECTOR(31 downto 0);  -- Source for updating PC (e.g., branch target, jump address)
		  ro1, ro2 : in std_logic_vector(31 downto 0);
		  imm32 : in std_logic_vector(31 downto 0);

		  ALUSrc : in std_logic;
		  opcode_ula: in std_logic_vector(3 downto 0);
		  ro2_execute, RESULT_ULA,RESULT_ADDR: out std_logic_vector(31 downto 0)

		  -- Output PC value
    );
end component;


component PIPE_EX_MEM is
    
port(
	clk : in std_logic;
	ADDRRESULT, ULARESULT : in STD_LOGIC_VECTOR(31 downto 0);
	ro2 : in std_logic_vector(31 downto 0);
	zero, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : in std_logic;
	RD_EXECUTE: in std_logic_vector(11 downto 7);
	
	ADDRRESULT_OUTMEM, ULARESULT_OUTMEM : out STD_LOGIC_VECTOR(31 downto 0);
	ro2_OUTMEM : out std_logic_vector(31 downto 0);
	zero_OUTMEM, Branch_OUTMEM, MemRead_OUTMEM, MemWrite_OUTMEM, RegWrite_OUTMEM, Mem2Reg_OUTMEM : out std_logic;
	RD_MEM: OUT std_logic_vector(11 downto 7)
	

	
);
end component;


component PIPE_MEM is
    Port (
   ADDRRESULT, ULARESULT: in STD_LOGIC_VECTOR(31 downto 0);
	ro2_OUTMEM : in std_logic_vector(31 downto 0);
	clk,reset, zero, Branch, MemRead, MemWrite : in std_logic;
	ADDRRESULT_OUT, DATA_OUT  : out STD_LOGIC_VECTOR(31 downto 0);
	PC_SEL : OUT std_logic
	

    );
end component;

component PIPE_WB is
    Port (
	 
	 
	clk : in std_logic;
	ULA_RESULT, DATA : in STD_LOGIC_VECTOR(31 downto 0);
	RegWrite, Mem2Reg : in std_logic;
	RD: in std_logic_vector(11 downto 7);
	WRITE_DATA : out STD_LOGIC_VECTOR(31 downto 0);
	RD_LAST: out std_logic_vector(11 downto 7);
	regw, m2r : out std_logic


    );
end component;


begin 


INST_FETCH : PIPE_FETCH
Port map (

				clk => clk,
				reset => reset,
				ALUSRC => PC_SEL,
				IN_MUX => ADDRRESULT_OUT,
				FETCH_DATA => FETCH_DATA,
				FETCH_ADDR => FETCH_ADDR
);

INST_IFID: PIPE_IF_ID
port map (
		clk => clk,
		pc_in => FETCH_DATA,
		instr_in => FETCH_ADDR,
		DECODE_ADDR => DECODE_ADDR,
		DECODE_INST => DECODE_INST

);


INST_DECODE : PIPE_DECODE
Port map(
        clk => clk,
		  reset => reset,
		  RegWrite_in => regw_s,
        DATA => WRITE_DATA_s,
		  INST => DECODE_INST,
        ADDR => DECODE_ADDR,
		  ADDR_OUT  => DECODE_ADDR_OUT,
		  imm32 => imm32,
		  ro1 => ro1,
		  ro2  => ro2,
		  ALUSrc => ALUSrc,
		  Branch => Branch,
		  MemRead => MemRead,
		  MemWrite => MemWrite,
		  RegWrite => RegWrite,
		  Mem2Reg  => Mem2Reg,
		  opcode_ula => opcode_ula,
		  RD_RESULT => RD_LAST_s,
		  RD_OUT => RD_OUT

		  -- Output PC value
    );
	 


INST_IDEX : PIPE_ID_EX 
port map(
	clk => clk,
	ADDR => DECODE_ADDR_OUT,
	imm32  => imm32,
	ro1 => ro1,
	ro2 => ro2,
	ALUSrc => ALUSrc,
	Branch => Branch,
	MemRead => MemRead,
	MemWrite => MemWrite,
	RegWrite => RegWrite,
	Mem2Reg => Mem2Reg,
	opcode_ula => opcode_ula,
	ADDR_out => ADDR_out,
	imm32_out => imm32_out,
	ro1_out => ro1_out,
	ro2_out => ro2_out,
	ALUSrc_out => ALUSrc_out,
	Branch_out => Branch_out,
	MemRead_out =>  MemRead_out,
	MemWrite_out => MemWrite_out,
	RegWrite_out => RegWrite_out,
	Mem2Reg_out => Mem2Reg_out,
	opcode_ula_out => opcode_ula_out,
	RD_DECODE => RD_OUT,
	RD_EXECUTE => RD_OUT2
	
);


INST_EXECUTE : PIPE_EXECUTE 
Port map(
        zero =>  zero,
        ADDR => ADDR_out,
		  ro1 => ro1_out,
		  ro2  => ro2_out,
		  imm32 => imm32_out,
		  ALUSrc => ALUSrc_out,
		  opcode_ula => opcode_ula_out,
		  RESULT_ULA => RESULT_ULA,
		  RESULT_ADDR => RESULT_ADDR_OUT,
		  ro2_execute => ro2_execute
		  
		  

		  -- Output PC value
    );
INST_EXMEM : PIPE_EX_MEM 
    
port MAP(
	clk => CLK,
	ADDRRESULT => RESULT_ADDR_OUT,
	ULARESULT => RESULT_ULA,
	ro2 => ro2_execute,
	zero => zero,
	Branch => Branch_out,
	MemRead => MemRead_out,
	MemWrite => MemWrite_out,
	RegWrite => RegWrite_out,
	Mem2Reg => Mem2Reg_out,
	RD_EXECUTE => RD_OUT2,
	
	ADDRRESULT_OUTMEM => ADDRRESULT_OUTMEM_s,
	ULARESULT_OUTMEM  => ULARESULT_OUTMEM_s,
	ro2_OUTMEM  => ro2_OUTMEM_s,
	zero_OUTMEM => zero_OUTMEM_s,
	Branch_OUTMEM => Branch_OUTMEM_s,
	MemRead_OUTMEM => MemRead_OUTMEM_s,
	MemWrite_OUTMEM => MemWrite_OUTMEM_s,
	RegWrite_OUTMEM => RegWrite_OUTMEM_s,
	Mem2Reg_OUTMEM  => Mem2Reg_OUTMEM_s,
	RD_MEM => RD_MEM_s
);
  
  
INST_MEM : PIPE_MEM 
    Port map(
   ADDRRESULT =>  ADDRRESULT_OUTMEM_s,
	ULARESULT => ULARESULT_OUTMEM_s,
	ro2_OUTMEM  => ro2_OUTMEM_s,
	PC_SEL  => PC_SEL,
	clk => clk,
	reset => reset,
	zero => zero_OUTMEM_s,
	Branch => Branch_OUTMEM_s,
	MemRead => MemRead_OUTMEM_s,
	MemWrite => MemWrite_OUTMEM_s,
	ADDRRESULT_OUT  => ADDRRESULT_OUT,
	DATA_OUT => DATA_OUT
	

    );
	 
	 
INST_WB : PIPE_WB 
    Port MAP(
	clk => clk,
	ULA_RESULT => ULARESULT_OUTMEM_s,
	DATA => DATA_OUT,
	RegWrite => RegWrite_OUTMEM_s,
	Mem2Reg => Mem2Reg_OUTMEM_s,
	RD => RD_MEM_s,
	
	WRITE_DATA  => WRITE_DATA_s,
	RD_LAST => RD_LAST_s,
	regw => regw_s,
	m2r => m2r_s


    );


  
  

end behavioral;
