LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IDEX IS
	PORT
	(
		clock			: IN STD_LOGIC;
		
		--Ex
		ALUopIn		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RegDstIn		: IN STD_LOGIC;
		ALUsrcIn		: IN STD_LOGIC;
		--Mem
		BranchIn		: IN STD_LOGIC;
		MemReadIn		: IN STD_LOGIC;
		MemWriteIn		: IN STD_LOGIC;
		--WB
		RegWriteIn		: IN STD_LOGIC;
		MemtoRegIn		: IN STD_LOGIC;

		RsIn			: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RtIn			: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RdIn			: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	
   		addressIn: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		readdata1In	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		readdata2In	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		signextendIn	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		--Ex
		ALUopOut	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		RegDstOut	: OUT STD_LOGIC;
		ALUsrcOut	: OUT STD_LOGIC;
		--Mem
		BranchOut	: OUT STD_LOGIC;
		MemReadOut	: OUT STD_LOGIC;
		MemWriteOut	: OUT STD_LOGIC;
		--WB
		RegWriteOut	: OUT STD_LOGIC;
		MemtoRegOut	: OUT STD_LOGIC;

		
		addressOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		readdata1Out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		readdata2Out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		signextendOut	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RsOut			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		RtOut			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		RdOut			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END IDEX;

ARCHITECTURE ARCH OF IDEX IS

--Ex
signal ALUopTmp		: STD_LOGIC_VECTOR(2 DOWNTO 0);
signal RegDstTmp		: STD_LOGIC;
signal ALUsrcTmp		: STD_LOGIC;
--Mem
signal BranchTmp		: STD_LOGIC;
signal MemReadTmp		: STD_LOGIC;
signal MemWriteTmp		: STD_LOGIC;
--WB
signal RegWriteTmp		: STD_LOGIC;
signal MemtoRegTmp		: STD_LOGIC;

signal addressTmp: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal readdata1Tmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal readdata2Tmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal signextendTmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal RsTmp			: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal RtTmp			: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal RdTmp			: STD_LOGIC_VECTOR(4 DOWNTO 0);


BEGIN
	--WB
	RegWriteTmp <= RegWriteIn;
	MemtoRegTmp <= MemtoRegIn;
	--Mem
	BranchTmp <= BranchIn;
	MemReadTmp <= MemReadIn;		
	MemWriteTmp <= MemWriteIn;		
	--Ex
	ALUopTmp <= ALUopIn;		
	RegDstTmp <= RegDstIn;		
	ALUsrcTmp <= ALUsrcIn;		
	
	addressTmp <= addressIn;
	readdata1Tmp <= readdata1In;	
	readdata2Tmp <= readdata2In;	
	signextendTmp <= signextendIn;	
	RsTmp <= RsIn;	
	RtTmp <= RtIn;
	RdTmp <= RdIn;
		
IDEX: process (clock)
begin
	if (clock'event AND clock = '1') then
		--WB
		RegWriteOut <= RegWriteTmp;
		MemtoRegOut <= MemtoRegTmp;
		--Mem
		BranchOut <= BranchTmp;
		MemReadOut <= MemReadTmp;		
		MemWriteOut <= MemWriteTmp;		
		--Ex
		ALUopOut <= ALUopTmp;		
		RegDstOut <= RegDstTmp;		
		ALUsrcOut <= ALUsrcTmp;		
		
		addressOut <= addressTmp;
		readdata1Out <= readdata1Tmp;	
		readdata2Out <= readdata2Tmp;	
		signextendOut <= signextendTmp;
		RsOut <= RsTmp;	
		RtOut <= RtTmp;
		RdOut <= RdTmp;
	end if;
end process;
	
	
END ARCH;