library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Add the numeric_std library for signed type
use std.textio.all;
use IEEE.std_logic_textio.all;


entity PIPELINE is
Port (
      clk : in STD_LOGIC;               -- Sinal de clock
		reset : in STD_LOGIC ;         -- Sinal de reset
		teste_rs1,teste_rs2, teste_rd : out std_logic_vector(4 downto 0);
		SUM_TB, PC_OUT_TB, INST_TB: out std_logic_vector(31 downto 0);
		ADDR : in std_logic_vector(31 downto 0);
		WB_TB, MEM_TB, EXECUTE_TB, DECODE_TB, FETCH_TB        : out STD_LOGIC 


 

);
end PIPELINE;

architecture behavioral of PIPELINE is


component PC is
     Port (
        clk, reset : in STD_LOGIC;                            -- Clock signal
        pc_in : in STD_LOGIC_VECTOR(31 downto 0) ;  -- Source for updating PC (e.g., branch target, jump address)
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)     -- Output PC value
    );
end component;


component X_REG is
	
	port(
		clk, wren, reset	:	in std_logic;
		rs1, rs2, rd	:	in std_logic_vector(4 downto 0);
		data		:	in std_logic_vector(31 downto 0);
		ro1, ro2	:	out std_logic_vector(31 downto 0)
		);
end component;



component MI is
   port (
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
    instruction_mi_in : in std_logic_vector(31 downto 0);
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
SIGNAL teste_rs1s,teste_rs2s, teste_rds :  std_logic_vector(4 downto 0);
SIGNAL	SUM_TBs, PC_OUT_TBs, INST_TBs:  std_logic_vector(31 downto 0);


signal 		MemRead_md, MemWrite_md,
				 zero, wren,wren_WB,
				ALUSrc_E, Branch_E,MemRead_E, MemWrite_E, RegWrite_E, Mem2Reg_E, -- Pipeline do execute
				ALUSrc_M, Branch_M, MemRead_M, MemWrite_M, RegWrite_M, Mem2Reg_M, -- Pipeline da memoria
				ALUSrc_WB, Branch_WB, MemRead_WB, MemWrite_WB, RegWrite_WB, Mem2Reg_WB, -- Pipeline do write back
				sel,sel2,sel3, FIM , resetpc: STD_LOGIC; 
signal 				DECODE, EXECUTE, MEM, WB: STD_LOGIC := '0';
signal          FETCH : STD_LOGIC := '0';

signal InitiPC : STD_LOGIC := '0';				
signal opcode, opcode_ula_E, opcode_ula_M, opcode_ula_WB : std_logic_vector(3 downto 0);		 
signal  DATA1_E,ro2MEM, Zwb, pc_mem_in, Z, A, B,ro1, ro2,data, addr_md_in,data_md_in,data_md_out, instruction_mi_ctrl_in, data02, data12, output2,data03, data13, output3, instruction_mi_out,instruction_mi_in : std_logic_vector(31 downto 0);
signal pc_out, pc_in : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal  data0, data1, output,pc_initial,pc_out_D,pc_out_E, asoma, bsoma, sum, asoma1, bsoma1, sum1 : STD_LOGIC_VECTOR(31 downto 0);
signal imm7 : STD_LOGIC_VECTOR(6 downto 0); 
signal rs1, rs2, rd_D,rd_E,rd_M, rd_WB ,rd_XREG:  std_logic_vector(4 downto 0);
signal imm32: signed(31 downto 0);

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
        reset => resetpc ,           -- Sinal de reset
		  pc_in => pc_in ,-- entrada de endereço do PC
        pc_out => pc_out
    );
MI_inst : MI
port map   (
        clk => clk,         						-- Sinal de clock
        addr => pc_mem_in  ,      				-- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        data_out => instruction_mi_out -- Saída da instrução da memória de instruções (32 bits)
    );
SUM11_inst : Somador8bits 
port map (
        asoma => asoma1,    -- Entrada A de 8 bits
        bsoma => bsoma1,    -- Entrada B de 8 bits
        sum => sum1  -- Saída de soma de 8 bits
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
    instruction_mi_in => instruction_mi_in,
    imm32 => imm32
  );

 X_REG_inst : X_REG 
  port map (
    clk => clk,
	 reset => reset,
	 wren => wren,
    rs1 => rs1,
	 rs2 => rs2,
	 rd => rd_XREG,
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


 process(clk)
  begin
	 

  
	 if rising_edge(clk) then
	 
	
	 
	 
	 
	 if WB ='1' then
	 
			
		data03 <= Zwb;
		data13 <= data_md_out;
		rd_XREG <= rd_wb;
		sel3 <= Mem2Reg_WB;
      data <= output3;
				 	report "data" & integer'image(to_integer(unsigned(data)));

		wren <= wren_WB;
		end if ;

		
			
			
	 if MEM = '1' then
	 	sel <= Branch_M and zero;
		data1 <= DATA1_E;

		addr_md_in <= Z;
				Zwb <= Z;


		data_md_in <= ro2MEM;
		memRead_md <= MemRead_M;
		MemWrite_md <= MemWrite_M;
		
		
		ALUSrc_WB <= ALUSrc_M;
		Branch_WB <= Branch_M;
		MemRead_WB <= MemRead_M;
		MemWrite_WB <= MemWrite_M;
		wren_WB <= RegWrite_M;
		Mem2Reg_WB <= Mem2Reg_M;
		opcode_ula_WB <= opcode_ula_M;
		rd_wb <= rd_M;
		WB <= '1';
		report "ULA" & integer'image(to_integer(unsigned(Z)));


						end if;


	 if EXECUTE = '1' then
	--	asoma1 <= std_logic_vector(shift_left(unsigned(imm32), 1));
	--	bsoma1 <= std_logic_vector(pc_out_E);
		DATA1_E <= std_logic_vector(shift_left(unsigned(imm32), 1) + unsigned(pc_out_E));
		data02 <= ro2;
		data12 <= std_logic_vector(unsigned(imm32));
		sel2 <= ALUSrc_E;
		opcode <= opcode_ula_E;
		B <= output2;
		A <= ro1;
		
		
		report "opcode" & integer'image(to_integer(unsigned(opcode)));

		
		
	--	teste_rs1 <= rs1;
	--	teste_rs2 <= rs2;
	--	teste_rd  <= rd_E;

		
		
		ro2MEM <= ro2;
		ALUSrc_M <= ALUSrc_E;
		Branch_M <= Branch_E;
		MemRead_M <= MemRead_E;
		MemWrite_M <= MemWrite_E;
		RegWrite_M <= RegWrite_E;
		Mem2Reg_M <= Mem2Reg_E;
		opcode_ula_M <= opcode_ula_E;
		rd_M <= rd_E;
		MEM <= '1';
				end if;


		
		 if DECODE = '1' then
		 
			instruction_mi_ctrl_in <= instruction_mi_out;
			instruction_mi_in <= instruction_mi_out;
			pc_out_E <= pc_out_D;
			rd_D <= instruction_mi_out (11 downto 7);
			rs1 <= instruction_mi_out (19 downto 15);
			rs2 <= instruction_mi_out (24 downto 20);
			rd_E <= rd_D;
			EXECUTE <= '1';
			
			
			
				teste_rs1s <= rs1;
				teste_rs2s <= rs2;
				teste_rds <= rd_D;
		 INST_TBs <= instruction_mi_out;
		 	report "instruction_mi_in" & integer'image(to_integer(unsigned(instruction_mi_in)));


 
						end if;


		 
			if FETCH = '1' then	
				 if rising_edge(clk) then
 
			 
			 if MEM = '0' then
			 pc_in <= ADDR;
			 else
						
							data0 <=  std_logic_vector(unsigned(ADDR) + 4);
							pc_in <= output;

			end if;
							pc_mem_in <= pc_out;
							pc_out_D <= pc_out;
							DECODE <= '1';
							SUM_TBs <= sum;
							PC_OUT_TBs <= pc_out;
							
							
							
							
							
											report "pc_out" & integer'image(to_integer(unsigned(bsoma)));

											  report "pc_out_D " & integer'image(to_integer(unsigned(pc_out_D)));
											  
												report "fetch_soma" & integer'image(to_integer(unsigned(sum)));

							-- PC + 4, PC + Imm, PC --> MI
							
							
							
							
							end if;
						  end if;
							   	
			
			if FETCH = '0' then	
				 if rising_edge(clk) then
 
			 
			 if MEM = '0' then
			 pc_in <= ADDR;
			 else
							data0 <= std_logic_vector(unsigned(ADDR) + 4);
							pc_in <= output;

			end if;
							pc_mem_in <= pc_out;
							pc_out_D <= pc_out;
							FETCH <= '1';
							SUM_TBs <= sum;
							PC_OUT_TBs <= pc_out;
							
							
							
							
							
											report "pc_out" & integer'image(to_integer(unsigned(bsoma)));

											  report "pc_out_D " & integer'image(to_integer(unsigned(pc_out_D)));
											  
												report "fetch_soma" & integer'image(to_integer(unsigned(sum)));

							-- PC + 4, PC + Imm, PC --> MI
							
							
							
							
							end if;
						  end if;
							
			
		
		
		
		
		
	end if;
	
	  
WB_TB <= WB;
MEM_TB <= MEM;
EXECUTE_TB <= EXECUTE;
DECODE_TB <= DECODE;
FETCH_TB  <=  FETCH;
  
  
teste_rs1 <= teste_rs1s;
teste_rs2 <=  teste_rs2s;
teste_rd <=  teste_rds;
SUM_TB <= SUM_TBs;
PC_OUT_TB <= PC_OUT_TBs;
INST_TB <= INST_TBs;
 
		
		
  end process;
  


  

end behavioral;
