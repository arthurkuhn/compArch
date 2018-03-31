LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exmem IS
	PORT
	(
		clock : IN STD_LOGIC;
		RegisterIn : IN STD_LOGIC;
		MemoryRegisterIn: IN STD_LOGIC;
		BranchIn : IN STD_LOGIC;
		MemoryReadIn : IN STD_LOGIC;
		MemoryWriteIn : IN STD_LOGIC;
		
-- For the ALU
		ResultIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		HiIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		LowIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		ZeroIn : IN STD_LOGIC;
		DataBIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		AddressIn: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RdIn : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

-- for the WriteBack
		RegisterOut : OUT STD_LOGIC;
		MemoryRegisterOut : OUT STD_LOGIC;
-- for the Mem
		BranchOut : OUT STD_LOGIC;
		MemoryReadOut : OUT STD_LOGIC;
		MemoryWriteOut : OUT STD_LOGIC;
-- for the ALU
		ResultOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		HiOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		LowOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		ZeroOut : OUT STD_LOGIC;
		DataBOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    		AddressOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RdOut : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END EXMEM;	

ARCHITECTURE Arch of EXMEM Is



signal tempReg : STD_LOGIC;
signal tempMemoryRegister : STD_LOGIC;
signal tempBranch : STD_LOGIC;
signal tempMemoryRead : STD_LOGIC;
signal tempMemoryWrite : STD_LOGIC;
signal tempResult : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal tempHi : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal tempLow : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal tempZero : STD_LOGIC;
signal tempDataB : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal tempAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal tempRd : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

tempReg <= RegisterIn;
tempMemoryRegister <= MemoryRegisterIn;
tempBranch <= BranchIn;
tempMemoryRead <= MemoryReadIn;
tempMemoryWrite <= MemoryWriteIn;
tempResult <= ResultIn;
tempHi <= HiIn;
tempLow <= LowIn;
tempZero <= ZeroIn;
tempAddress <= AddressIn;
tempRD <= RdIn;
tempDataB <= DataBIn;


IFID : process (clock)

begin

		if (clock 'event AND clock = '1') then
		RegisterOut <= tempReg;
		MemoryRegisterOut <= tempMemoryRegister;
		BranchOut <= tempBranch;
		MemoryReadOut <= tempMemoryRead;		
		MemoryWriteOut <= tempMemoryWrite;
		ResultOut <= tempResult;
		HiOut <= tempHi;
		LowOut <= tempLow;
		ZeroOut <= tempZero;
		DataBOut <= tempDataB;
		AddressOut <= tempAddress;
		RdOut <= tempRd;
	end if;
end process;
	
	
END Arch;
