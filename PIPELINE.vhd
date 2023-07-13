library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPELINE is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        -- Declare outros sinais de entrada/saída conforme necessário
    );
end PIPELINE;

architecture Behavioral of PIPELINE is

    -- Declaração dos componentes
    component PC is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            pc_out : out STD_LOGIC_VECTOR(7 downto 0);
            pc_mem_out : out STD_LOGIC_VECTOR(31 downto 8)
        );
    end component PC;

    component MI is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            pc_mem_in : in STD_LOGIC_VECTOR(31 downto 8);
            instruction_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component MI;

    component MD is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            addr_in : in STD_LOGIC_VECTOR(7 downto 0);
            data_in : in STD_LOGIC_VECTOR(31 downto 0);
            read_en : in STD_LOGIC;
            write_en : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component MD;

    component ula is
        generic (WSIZE : natural := 32);
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(WSIZE-1 downto 0);
            Z : out std_logic_vector(WSIZE-1 downto 0);
            zero : out std_logic
        );
    end component ula;

    component Mux21 is
        Port (
            sel : in STD_LOGIC;
            data0 : in STD_LOGIC_VECTOR(31 downto 0);
            data1 : in STD_LOGIC_VECTOR(31 downto 0);
            output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component Mux21;

    component Somador32bits is
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            sum : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component Somador32bits;

    component X_REG is
        generic (WSIZE : natural := 32);
        port (
            clk, wren : in std_logic;
            rs1, rs2, rd : in std_logic_vector(4 downto 0);
            data : in std_logic_vector(WSIZE-1 downto 0);
            ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
        );
    end component X_REG;

    -- Declaração dos sinais internos
    signal pc_out : STD_LOGIC_VECTOR(7 downto 0);
    signal pc_mem_out : STD_LOGIC_VECTOR(31 downto 8);
    signal instruction_out : STD_LOGIC_VECTOR(31 downto 0);
    signal addr_in : STD_LOGIC_VECTOR(7 downto 0);
    signal data_in : STD_LOGIC_VECTOR(31 downto 0);
    signal read_en : STD_LOGIC;
    signal write_en : STD_LOGIC;
    signal data_out : STD_LOGIC_VECTOR(31 downto 0);
    -- Declare outros sinais internos conforme necessário

begin

    -- Instanciação dos componentes
    PC_inst : PC
        Port Map (
            clk => clk,
            reset => reset,
            pc_out => pc_out,
            pc_mem_out => pc_mem_out
        );

    MI_inst : MI
        Port Map (
            clk => clk,
            reset => reset,
            pc_mem_in => pc_mem_out,
            instruction_out => instruction_out
        );

    MD_inst : MD
        Port Map (
            clk => clk,
            reset => reset,
            addr_in => addr_in,
            data_in => data_in,
            read_en => read_en,
            write_en => write_en,
            data_out => data_out
        );

    -- Instancie os outros componentes conforme necessário

    -- Lógica do pipeline
    -- Implemente o pipeline RISCV aqui usando os componentes instanciados

end Behavioral;
