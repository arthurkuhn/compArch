LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY instructionFetchStage IS

port(
	clk : in std_logic;
	global_clk : in std_logic;
	mux_in0 : in std_logic_vector(31 downto 0);
	select_ins : in std_logic;
	four : in INTEGER;
	structural_stall : IN STD_LOGIC := '0';
	pc_stall : IN STD_LOGIC := '0';

	select_out : out std_logic_vector(31 downto 0);
	instruction_mem_out : out std_logic_vector(31 downto 0);

	wait_req: out std_logic;

	-- CACHE port
	C_addr : out integer range 0 to 1024-1;
	C_read : out std_logic;
	C_readdata : in std_logic_vector (31 downto 0);
	C_write : out std_logic;
	C_writedata : out std_logic_vector (31 downto 0);
	C_waitrequest : in std_logic

);

END instructionFetchStage;

architecture IF_arch of instructionFetchStage is

--CACHE

component cache is

generic(
	ram_size : INTEGER := 8192
);
port(

	clock : in std_logic;
	reset : in std_logic;

	-- Avalon interface --
	s_addr : in std_logic_vector (31 downto 0);
	s_read : in std_logic;
	s_readdata : out std_logic_vector (31 downto 0);
	s_write : in std_logic;
	s_writedata : in std_logic_vector (31 downto 0);
	s_waitrequest : out std_logic;

	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (31 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (31 downto 0);
	m_waitrequest : in std_logic
);
end component;

--PC

component pc is
port(clk : in std_logic;
	 reset : in std_logic;
	 counter_out : out std_logic_vector(31 downto 0);
	 counter_in : in std_logic_vector(31 downto 0)
	 );
end component;

--MUX

component mux is
port(
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 select_in : in std_logic;
	 select_out : out std_logic_vector(31 downto 0)
	 );

end component;

--ADDER

component adder is
port(
	 plus_four : IN INTEGER;
     counter_out : IN STD_LOGIC_VECTOR(31 downto 0);
     adder_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	 );
end component;

-- SET SIGNALS 
	signal rst : std_logic := '0';
    signal writedata: std_logic_vector(31 downto 0);
    signal address: INTEGER;

    signal wait_req_sig: STD_LOGIC;
	signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC;
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
	
	signal pcOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal internalSelectOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal addOutput : STD_LOGIC_VECTOR(31 DOWNTO 0);
		
	--SIGNAL FOR STALLS 
	signal stallValue : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000100000";
	signal memoryValue : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal pcInput : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin

select_out <= internalSelectOut;
--address <= to_integer(unsigned(addOutput(9 downto 0)))/4;


pcCounter : pc 
port map(
	clk => clk,
	reset => rst,
	counter_out => pcOutput,
	counter_in => pcInput
);

add : adder
port map(
	 
	 plus_four => four,
	 counter_out => pcOutput,
	 adder_out => addOutput
);

fetchMux : mux 
port map(
	 input0 => addOutput,
	 input1 => mux_in0,
	 select_in => select_ins,
	 select_out => internalSelectOut
	 );
	 
structuralMux : mux 
port map (
input0 => memoryValue,
input1 => stallValue,
select_in => structural_stall,
select_out => instruction_mem_out
);

pcMux : mux 
port map (
input0 => internalSelectOut,
input1 => pcOutput,
select_in => pc_stall,
select_out => pcInput
);
	 
memCache : cache
port map(
	clock => global_clk,
	reset => rst,

	s_addr => pcOutput,
	s_read => memread,
	s_readdata => memoryValue,
	s_write => memwrite,
	s_writedata => writedata,
	s_waitrequest => wait_req_sig,

	m_addr =>address,
	m_read =>C_read,
	m_readdata => C_readdata,
	m_write => C_write,
	m_writedata => C_writedata,
	m_waitrequest => C_waitrequest
);

process (wait_req_sig,clk)
begin

	if (wait_req_sig'event and wait_req_sig = '1') then
		memread <= '0';
	end if;

	if (clk'event and clk = '1') then
		memread <= '1';
	end if;

end process;

process (address)
begin
	if address >= 1024 then
		C_addr <= 0;
	else
		C_addr <= address;
	end if;
end process;

wait_req <= wait_req_sig;

end IF_arch;
