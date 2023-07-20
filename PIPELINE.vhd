library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Add the numeric_std library for signed type

entity PIPELINE is
Port (
        clk : in STD_LOGIC;               -- Sinal de clock
		  reset : in STD_LOGIC            -- Sinal de reset
);
end PIPELINE;

architecture behavioral of PIPELINE is
component PC is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;             -- Sinal de reset
		  -- Sinal de clock
		  pc_in : in std_logic_vector(7 downto 0); -- entrada de endereço do PC
        pc_out : out STD_LOGIC_VECTOR(7 downto 0)  -- Saída do endereço do PC (8 bits)
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
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        pc_mem_in : in STD_LOGIC_VECTOR(7 downto 0);
        instruction_mi_out : out STD_LOGIC_VECTOR(31 downto 0);
        pc_initial : out STD_LOGIC_VECTOR(7 downto 0);
        FIM : out STD_LOGIC  -- Sinal de saída para indicar o fim do programa
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
        asoma : in STD_LOGIC_VECTOR(7 downto 0);    -- Entrada A de 8 bits
        bsoma : in STD_LOGIC_VECTOR(7 downto 0);    -- Entrada B de 8 bits
        sum : out STD_LOGIC_VECTOR(7 downto 0)  -- Saída de soma de 8 bits
    );
end component;


component genImm32 is
  port (
    instruction_mi_in : in std_logic_vector(31 downto 0);
    imm32 : out std_logic_vector(31 downto 0)
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
				FETCH, DECODE, EXECUTE, MEM, WB: STD_LOGIC;
signal InitiPC : STD_LOGIC := '0';				
signal opcode, opcode_ula_E, opcode_ula_M, opcode_ula_WB : std_logic_vector(3 downto 0);		 
signal Z, A, B,ro1, ro2,data, addr_md_in,data_md_in,data_md_out, imm32, instruction_mi_ctrl_in, data02, data12, output2,data03, data13, output3, instruction_mi_out,instruction_mi_in : std_logic_vector(31 downto 0);
signal  data0, data1, output,pc_initial, pc_reg, pc_mem_in, pc_out,pc_out_D,pc_out_E, asoma, bsoma, sum : STD_LOGIC_VECTOR(7 downto 0);
signal imm7 : STD_LOGIC_VECTOR(6 downto 0); 
signal rs1, rs2, rd_D,rd_E,rd_M, rd_WB :  std_logic_vector(4 downto 0);


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
		  pc_in => pc_reg ,-- entrada de endereço do PC
        pc_out => pc_out
    );
MI_inst : MI
port map   (
        clk => clk     ,         						-- Sinal de clock
        reset => reset ,           						-- Sinal de reset
        pc_mem_in => pc_mem_in  ,      				-- Entrada do endereço do PC para a memória de instruções (24 bits ignorados)
        instruction_mi_out => instruction_mi_out,  -- Saída da instrução da memória de instruções (32 bits)
        FIM => FIM,
        pc_initial => pc_initial      					-- Saída do valor inicial de pc_in
    );
SUM1_inst : Somador8bits 
port map (
        asoma => asoma,    -- Entrada A de 8 bits
        bsoma => bsoma,    -- Entrada B de 8 bits
        sum => sum  -- Saída de soma de 8 bits
    );
MUX1_inst : Mux21PC 
port map (
        sel_PC => sel       ,                  -- Sinal de seleção (0 ou 1)
        data0_PC => data0    ,-- Dado de entrada 0 (32 bits)
        data1_PC => data1    ,-- Dado de entrada 1 (32 bits)
        output_PC => output   -- Saída do multiplexador (32 bits)
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


 process(clk, reset, FIM)
  begin
  	 pc_reg <= "00000000";

    
	 if rising_edge(clk) then
	
	 
	 
	 
	 if WB ='1' then
	 
			
		data03 <= Z;
		data13 <= data_md_out;
		rd_WB <= rd_M;
		sel3 <= Mem2Reg_WB;

		wren <= wren;
		end if ;

		
			
			
	 if MEM = '1' then
	 	sel <= Branch_M and zero;
		data1 <= sum;
		addr_md_in <= Z;

		data_md_in <= ro2;
		memRead_md <= MemRead_M;
		MemWrite_md <= MemWrite_M;
		
		
		ALUSrc_WB <= ALUSrc_M;
		Branch_WB <= Branch_M;
		MemRead_WB <= MemRead_M;
		MemWrite_WB <= MemWrite_M;
		wren <= RegWrite_M;
		Mem2Reg_WB <= Mem2Reg_M;
		opcode_ula_WB <= opcode_ula_M;
		rd_wb <= rd_M;
						end if;


	 if EXECUTE = '1' then
		asoma <= '0' & imm7(6 downto 0);
		bsoma <= pc_out_E;
		
		data02 <= ro2;
		data12 <= imm32;		sel2 <= ALUSrc_E;
		A <= ro1;
		B <= output2;
		opcode <= opcode_ula_E;

		
		
		
		ALUSrc_M <= ALUSrc_E;
		Branch_M <= Branch_E;
		MemRead_M <= MemRead_E;
		MemWrite_M <= MemWrite_E;
		RegWrite_M <= RegWrite_E;
		Mem2Reg_M <= Mem2Reg_E;
		opcode_ula_M <= opcode_ula_E;
		rd_M <= rd_E;
		mem <= '1';
				end if;


		
		 if DECODE = '1' then
		 
			instruction_mi_ctrl_in <= instruction_mi_out;
			instruction_mi_in <= instruction_mi_out;
			imm7 <= imm32( 6 downto 0);
			pc_out_E <= pc_out_D;
			
			rd_D <= instruction_mi_out (11 downto 7);
			rs1 <= instruction_mi_out (19 downto 15);
			rs2 <= instruction_mi_out (24 downto 20);
			rd_E <= rd_D;
			EXECUTE <= '1';
						end if;


		 
			if FETCH = '1' then	
			 if InitiPC = '0' then
			 pc_reg <= "00000000";
			 InitiPC <= '1';
			 end if;
							asoma <= "00000100";
							bsoma <= pc_out;
							data0 <= sum;	
							pc_mem_in <= pc_out;
							pc_out_D <= pc_out;
							pc_reg <= output;
							DECODE <= '1';
							
							
							-- PC + 4, PC + Imm, PC --> MI
							
						  end if;
							
			
		
		
		
		
		
		
		
	end if;
		
		
  end process;
  
  

  
  
  
 

  

end behavioral;
