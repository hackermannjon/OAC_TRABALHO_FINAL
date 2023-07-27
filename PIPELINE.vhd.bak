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

component PC is
    Port (
        clk : in STD_LOGIC;                            -- Clock signal
        reset : in STD_LOGIC;                          -- Reset signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0);     -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end component;


component X_REG is
  port (
    clk, wren  : in std_logic;
    rs1, rs2, rd : in std_logic_vector(4 downto 0);
    data : in std_logic_vector(31 downto 0);
    ro1, ro2 : out std_logic_vector(31 downto 0)
  );
end component;



component MI is
    Port (
       clk      : in    std_logic;
       addr     : in    std_logic_vector(31 downto 0);
       data_out : out   std_logic_vector(31 downto 0)
    );
end component;




component ULA is
	port (
		opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(31 downto 0);
		Z : out std_logic_vector(31 downto 0);
		zero : out std_logic);
end component;

component Somador8bits is
   Port (
        asoma : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada A de 8 bits
        bsoma : in STD_LOGIC_VECTOR(31 downto 0);    -- Entrada B de 8 bits
        sum : out STD_LOGIC_VECTOR(31 downto 0)  -- Saída de soma de 8 bits
    );
end component;


component genImm32 is
  port (
    instr : in std_logic_vector(31 downto 0);
    imm32 : out signed(31 downto 0)
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

component Mux21PC is
    Port (
        sel_PC : in STD_LOGIC;                          -- Sinal de sel_PCeção (0 ou 1)
        data0_PC : in STD_LOGIC_VECTOR(7 downto 0);    -- Dado de entrada 0 (32 bits)
        data1_PC : in STD_LOGIC_VECTOR(7 downto 0);    -- Dado de entrada 1 (32 bits)
        output_PC : out STD_LOGIC_VECTOR(7 downto 0)   -- Saída do multiplexador (32 bits)
    );
end component;



component Controle is
    port (
        instruction : in std_logic_vector(31 downto 0);
		  opcode_ula: out std_logic_vector(3 downto 0);
        ALUSrc, Branch, MemRead, MemWrite, RegWrite, Mem2Reg : out std_logic
    );
end component;

component MD is
    Port (
        clk : in STD_LOGIC;                                  -- Sinal de clock
        reset : in STD_LOGIC;                                -- Sinal de reset
        addr_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Entrada do endereço para a memória de dados
        data_md_in : in STD_LOGIC_VECTOR(31 downto 0);       -- Dados de entrada para a memória de dados
        data_md_out : out STD_LOGIC_VECTOR(31 downto 0);     -- Saída de dados da memória de dados
        MemRead : in STD_LOGIC;                              -- Sinal de controle MeMRead
        MemWrite : in STD_LOGIC                              -- Sinal de controle MeMWrite
    );
end component;


signal 		MemRead_md, MemWrite_md,
				 zero, wren,
				ALUSrc_E, Branch_E,MemRead_E, MemWrite_E, RegWrite_E, Mem2Reg_E, -- Pipeline do execute
				ALUSrc_M, Branch_M, MemRead_M, MemWrite_M, RegWrite_M, Mem2Reg_M, -- Pipeline da memoria
				ALUSrc_WB, Branch_WB, MemRead_WB, MemWrite_WB, RegWrite_WB, Mem2Reg_WB, -- Pipeline do write back
				sel,sel2,sel3, FIM,  
				DECODE, EXECUTE, MEM, WB: STD_LOGIC := '0';
signal				FETCH : STD_LOGIC := '1';
signal InitiPC : STD_LOGIC := '0';				
signal opcode, opcode_ula_E, opcode_ula_M, opcode_ula_WB : std_logic_vector(3 downto 0);	
signal imm32 : signed(31 downto 0)	 ;
signal Z, A, B,data, addr_md_in,data_md_in,data_md_out, instruction_mi_ctrl_in, data02, data12, output2,data03, data13, output3, instruction_mi_out,instruction_mi_in : std_logic_vector(31 downto 0);
signal  data0, data1, output,pc_initial, pc_mem_in, pc_out,pc_out_D,pc_out_E, asoma, bsoma, sum : STD_LOGIC_VECTOR(31 downto 0);
signal pc_in :  STD_LOGIC_VECTOR(31 downto 0) :=  	  "00000000000000000000000000000000";

signal imm7 : STD_LOGIC_VECTOR(6 downto 0); 
signal rs1, rs2, rd_D,rd_E,rd_M, rd_WB :  std_logic_vector(4 downto 0);
signal ro1, ro2 : std_logic_vector(31 downto 0) := (others => '0');


begin
Controle_inst : Controle
port map (
        instruction => instruction_mi_ctrl_in,
		  opcode_ula => opcode_ula_E,
        ALUSrc => ALUSrc_E,
		  Branch => Branch_E,
		  MemRead => MemRead_E,
		  MemWrite => MemWrite_E, 
		  RegWrite => RegWrite_E,
		  Mem2Reg => Mem2Reg_E
);
PC_inst : PC
port map  (
        clk => clk     ,         -- Sinal de clock
        reset => reset ,           -- Sinal de reset
		  pc_in => pc_in ,-- entrada de endereço do PC
        pc_out => pc_out
    );
MI_inst : MI
port map   (
        clk => clk     ,         						-- Sinal de clock
        addr => pc_mem_in  ,      				-- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        data_out => instruction_mi_out  -- Saída da instrução da memória de instruções (32 bits)
    );
SUM1_inst : Somador8bits 
port map (
        asoma => asoma,    -- Entrada A de 8 bits
        bsoma => bsoma,    -- Entrada B de 8 bits
        sum => sum  -- Saída de soma de 8 bits
    );
MUX1_inst : Mux21 
port map (
        sel => sel       ,                  -- Sinal de seleção (0 ou 1)
        data0 => data0    ,-- Dado de entrada 0 (32 bits)
        data1 => data1    ,-- Dado de entrada 1 (32 bits)
        output => output   -- Saída do multiplexador (32 bits)
);


MUX2_inst : Mux21 
port map (
        sel => sel2       ,                  -- Sinal de seleção (0 ou 1)
        data0 => data02    ,-- Dado de entrada 0 (32 bits)
        data1 => data12    ,-- Dado de entrada 1 (32 bits)
        output => output2   -- Saída do multiplexador (32 bits)
);
MUX3_inst : Mux21 
port map (
        sel => sel3      ,                  -- Sinal de seleção (0 ou 1)
        data0 => data03    ,-- Dado de entrada 0 (32 bits)
        data1 => data13    ,-- Dado de entrada 1 (32 bits)
        output => output3   -- Saída do multiplexador (32 bits)
);

ULA_inst : ULA 
	port map (
		opcode => opcode,
		A=> A, 
		B => B,
		Z => Z,
		zero => zero
		);
IMM_inst : genImm32
  port map (
    instr => instruction_mi_in,
    imm32 => imm32
  );

 X_REG_inst : X_REG 
  port map (
    clk => clk,
	 wren => wren,
    rs1 => rs1,
	 rs2 => rs2,
	 rd => rd_WB,
    data => data,
    ro1 => ro1,
	 ro2 => ro2
  );
MD_inst : MD 
   Port map(
        clk => clk,                                  -- Sinal de clock
        reset => reset,                              -- Sinal de reset
        addr_md_in => addr_md_in,       -- Entrada do endereço para a memória de dados
        data_md_in => data_md_in,       -- Dados de entrada para a memória de dados
        data_md_out => data_md_out,     -- Saída de dados da memória de dados
        MemRead => MemRead_M,                              -- Sinal de controle MeMRead
        MemWrite => MemWrite_M                              -- Sinal de controle MeMWrite
    );

  
  
 

  

end behavioral;
