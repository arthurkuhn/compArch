LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mainFunction is 

END mainFunction;

Architecture func of mainFunction is 

constant clockPeriod : time := 1 ns;
signal clockSig : std_logic := '0';
signal clockMemory : std_logic := '0';

component PC is
	PORT 
	(
	addressI : in std_logic_vector(31 downto 0)
	addressO : out std_logic_vector(31 downto 0)
	pcWrite : in std_logic
	clock : in std_logic
	);
END component; 

component MainMemory is
	GENERIC (
		 fileAddressRd		:	STRING  := "program.txt";
		 fileAddressWr		:	STRING  := "MemCon.dat";
		 memSizeInWord		:	INTEGER := 256;
		 numBytesInWord		:	INTEGER := 4;
		 numBitsInByte		:	INTEGER := 8;
		 rdDelay			:	INTEGER := 0;
		 wrDelay			:	INTEGER := 0;		
	);

	PORT (
		clock				:	IN STD_LOGIC;
		address 			:	IN INTEGER;
		wordByte			:	IN STD_LOGIC;
		we 					:	IN STD_LOGIC;
		re 					: 	IN STD_LOGIC;
		rdReady				: 	IN STD_LOGIC;
		init 				: 	IN STD_LOGIC;
		dump				:	IN STD_LOGIC;
		data				: 	INOUT STD_LOGIC_VECTOR((numBytesInWord*numBitsInByte)-1 downto 0);
		wrDone				:	OUT STD_LOGIC;	
	);

END component;

component registers is

	port (

		loin		: in std_logic_vector(31 downto 0);
		hiin		: in std_logic_vector(31 downto 0);
		loout		: out std_logic_vector(31 downto 0);
		hiout		: out std_logic_vector(31 downto 0);
		writelohi	: in std_logic;
		readdata1	: out std_logic_vector(31 downto 0);
		readdata2	: out std_logic_vector(31 downto 0);
		readReg1	: in std_logic_vector(4 downto 0);
		readReg2	: in std_logic_vector(4 downto 0);
		regwrite	: in std_logic;
		writeReg	: in std_logic_vector(4 downto 0);
		writedata	: in std_logic_vector(31 downto 0);
		clock		: in std_logic;
		init 		: in std_logic
	);
end component;

component IFID is
	PORT
	(
		clock			: IN STD_LOGIC;
		IFIDWrite		: IN STD_LOGIC;
		instructionIn	: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
		instructionOut	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		addressIn		: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
		addressOut		: OUT STD_LOGIC_VECTOR  (31 DOWNTO 0)
	);
END component;

component controller is
	port (
		Clk		    : in std_logic;
		Inst	    : in std_logic_vector(31 downto 26);
		RegDst		: out std_logic;
		Jmp		    : out std_logic;
		Bch		    : out std_logic;
		MemRead		: out std_logic;
		MemToReg	: out std_logic;
		MemWrite	: out std_logic;
		AluSrc		: out std_logic;
		RegWrite	: out std_logic;
		NotZero		: out std_logic;
		LUI		    : out std_logic;
		ALUOp		: out std_logic_vector(2 downto 0)
	);
end component;


component ALU is
	Port (
		CLK	: in  STD_LOGIC;
		InA     : in  STD_LOGIC_VECTOR(31 downto 0);
        InB     : in  STD_LOGIC_VECTOR(31 downto 0);
        Control : in  STD_LOGIC_VECTOR(3  downto 0);
        Shamt   : in  STD_LOGIC_VECTOR(4  downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        IsZero  : out STD_LOGIC;
        Hi      : out STD_LOGIC_VECTOR(31 downto 0);
        Lo      : out STD_LOGIC_VECTOR(31 downto 0);
	);
end component;

component ALU_control is
	port (
		ALUOp			: in std_logic_vector(2 downto 0); -- from main control
		funct 			: in std_logic_vector(5 downto 0); -- from instruction
		operation		: out std_logic_vector(3 downto 0); -- output to ALU
		writeLOHI		: out std_logic;
		readLOHI		: out std_logic_vector(1 downto 0)
	);
end component;

component detectHazard IS
	PORT
	(
		IDEXMemRead : in std_logic;
		Branch: in std_logic;
		IDEXRt : in std_logic_vector(4 downto 0);
		IFIDRt : in std_logic_vector(4 downto 0);
		IFIDRs : in std_logic_vector (4 downto 0);
		IFIDWrite: out std_logic;
		PCWrite : out std_logic;
		pause : out std_logic	

	);
END component;

component IDEX IS
	PORT
	(
		clock			: IN STD_LOGIC;
		
		--Ex
		ALUopIn			: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
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
END component;

component ForwardingUnit IS
	PORT
	(
		Aforward : out std_logic_vector(1 downto 0);
		Bforward : out std_logic_vector(1 downto 0);
		IDEXRegRs : std_logic_vector(4 downto 0);
		IDEXRegRt : std_logic_vector(4 downto 0);
		MEMWBRegRd : std_logic_vector(4 downto 0);
		MEMWBRegWrite : in std_logic;
		EXMEMRegRd : std_logic_vector(4 downto 0);
		EXMEMRegWrite : in std_logic;
	);
END component;


component BranchForwardingUnit IS
	PORT
	(
		BranchAforward : out std_logic_vector(1 downto 0);
		BranchBforward : out std_logic_vector(1 downto 0);
		Branch : in std_logic;
		IFIDRegRt : in std_logic_vector(4 downto 0);
		IFIDRegRs : in std_logic_vector(4 downto 0);
		MEMWBRegRd : in std_logic_vector(4 downto 0);
		MEMWBRegWrite : in std_logic;
		EXMEMRegRd : in std_logic_vector(4 downto 0);
		EXMEMRegWrite : in std_logic;
		
	);
END component;

component MEMWB IS
		PORT
		(
			clock			:	IN STD_LOGIC;

			-- Inputs
			RegWriteIn		:	IN STD_LOGIC;		
			MemToRegIn		:	IN STD_LOGIC;

			zeroIn			: 	IN STD_LOGIC;
			resultIn		:	IN STD_LOGIC_VECTOR(31 downto 0);
			highIn			:	IN STD_LOGIC_VECTOR(31 downto 0);
			lowIn			:	IN STD_LOGIC_VECTOR(31 downto 0);

			wrDoneIn		:	IN STD_LOGIC;
			rdReadyIn		:	IN STD_LOGIC;
			DataIn			:	IN STD_LOGIC_VECTOR(31 downto 0);

			rdIn 			:	IN STD_LOGIC_VECTOR(4 downto 0);

			--Outputs
			RegWriteOut		:	OUT STD_LOGIC;
			MemToRegOut		:	OUT STD_LOGIC;

			zeroOut			: 	OUT STD_LOGIC;
			resultOut		:	OUT STD_LOGIC_VECTOR(31 downto 0);
			highOut			: 	OUT STD_LOGIC_VECTOR(31 downto 0);
			lowOut			:	OUT STD_LOGIC_VECTOR(31 downto 0);

			wrDoneOut		: 	OUT STD_LOGIC;
			rdReadyOut		:	OUT STD_LOGIC;
			dataOut			:	OUT STD_LOGIC_VECTOR(31 downto 0);

			rdOut 			: 	OUT STD_LOGIC_VECTOR(4 downto 0);

		);
END component;	

component EXMEM IS
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
		DatabaseIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
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
		DatabaseOut : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    		AddressOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RdOut : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END component;


--PC Signals

signal	addressI : std_logic_vector(31 downto 0);
signal	pcWrite : std_logic := '0';
signal muxPcSource : std_logic_vector(31 downto 0);
signal pcAddress  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal stall : std_logic := '0';

--Instruction Mem Signals

type instStateType is (init, rdInst1, rdInst2);
signal instState : instStateType := init;
signal wordByteInstMem : STD_LOGIC := '1';
signal reInstMem : STD_LOGIC := '0';
signal rdReadyInstMem : STD_LOGIC := '0';
signal dumpInstMem : STD_LOGIC := '0';
signal addressInstMem : STD_LOGIC := '0';
signal dataInstMem : STD_LOGIC_VECTOR(31 downto 0);

--Data Mem Signals

type dataStateType is (init, idle, rdMem1, rdMem2, wrMem1, wrMem2, dump, fin);
signal dataState : dataStateType := init;
signal data : STD_LOGIC_VECTOR(31 downto 0) := (others => 'Z');
signal MDR : STD_LOGIC_VECTOR(31 downto 0);
signal wordByteDataMem : STD_LOGIC := '1';
signal reDataMem : STD_LOGIC := '0';
signal rdReadyDataMem : STD_LOGIC := '0';
signal weDataMem : STD_LOGIC;
signal wrDoneDataMem : STD_LOGIC;
signal dataDataMem : STD_LOGIC_VECTOR(31 downto 0);
signal initDataMem : STD_LOGIC := '0';
signal dumpDataMem : STD_LOGIC := '0';
signal addressDataMem : INTEGER := 0;

signal InitReg : STD_LOGIC := '0';
signal Bch : STD_LOGIC;
signal MemToReg	: STD_LOGIC;
signal MemRead : STD_LOGIC;
signal MemWrite	: STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);
signal AluSrc : STD_LOGIC;
signal RegDst : STD_LOGIC;
signal Jmp : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal NotZero : STD_LOGIC;
signal IDZero : STD_LOGIC;
signal LUI : STD_LOGIC;

signal readdata1 : std_logic_vector(31 downto 0);
signal readdata2 : std_logic_vector(31 downto 0);
signal signExtend : std_logic_vector(31 downto 0);
signal rs : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal rd : std_logic_vector(4 downto 0);

signal IFFlush : STD_LOGIC;
signal IFIDWrite : STD_LOGIC;
signal IFIDAddress : STD_LOGIC;
signal IFIDInstruction : STD_LOGIC_VECTOR (31 downto 0);

signal IDEXRegWrite	: STD_LOGIC;
signal IDEXMemtoReg : STD_LOGIC;
signal IDEXBranch : STD_LOGIC;
signal IDEXMemRead : STD_LOGIC;
signal IDEXMemWrite : STD_LOGIC;
signal IDEXALUop : STD_LOGIC_VECTOR(2 downto 0);
signal IDEXRegDst : STD_LOGIC;
signal IDEXALUsrc : STD_LOGIC;
signal IDEXAddress : STD_LOGIC_VECTOR(31 downto 0);
signal IDEXreaddata1 : STD_LOGIC_VECTOR(31 downto 0);
signal IDEXreaddata2 : STD_LOGIC_VECTOR(31 downto 0);
signal IDEXsignextend : STD_LOGIC_VECTOR(31 downto 0);
signal IDEXRs : STD_LOGIC_VECTOR(4 downto 0);
signal IDEXRd : STD_LOGIC_VECTOR(4 downto 0);
signal IDEXRt : STD_LOGIC_VECTOR(4 downto 0);
signal IDEXRegRead : STD_LOGIC_VECTOR(4 downto 0);

-- ALU Control Signals
signal DataA : std_logic_vector(31 downto 0);
signal DataB : std_logic_vector(31 downto 0);
signal ALUSrcMux : std_logic_vector(31 downto 0);
signal Shamt : std_logic_vector(4 downto 0);
signal Result : std_logic_vector(31 downto 0);
signal Hi : std_logic_vector(31 downto 0);
signal Lo : std_logic_vector(31 downto 0);
signal IsZero : std_logic;

-- Forwarding Unit Signals
signal Aforward : std_logic_vector(1 downto 0);
signal Bforward : std_logic_vector(1 downto 0);

-- Branch Jump Signals
signal ALU2ShiftDatabb : std_logic_vector(31 downto 0);
signal BranchAddress : std_logic_vector(31 downto 0);
signal JumpAddress : std_logic_vector(31 downto 0);
signal PCSrc : std_logic;
signal JumpMuxOut : std_logic_vector(31 downto 0);

signal EXMEMRegWrite : std_logic;
signal EXMEMMemtoReg : std_logic;
signal EXMEMBranch : std_logic;
signal EXMEMMemRd : std_logic;
signal EXMEMMemWrite : std_logic;
signal EXMEMResult : std_logic(31 downto 0);
signal EXMEMHi : std_logic_vector(31 downto 0);
signal EXMEMLo : std_logic_vector(31 downto 0);
signal EXMEMIsZero : std_logic;
signal EXMEMDataB : std_logic_vector(31 downto 0);
signal EXMEMAddress : std_logic_vector(31 downto 0);
signal EXMEMRegRd : std_logic_vector(4 downto 0);

signal MEMWBRegWrite : std_logic;
signal MEMWBMemtoReg : std_logic;
signal MEMWBwrDone : std_logic;
signal MEMWBrdReady : std_logic;
signal MEMWBResult : std_logic(31 downto 0);
signal MEMWBHi : std_logic_vector(31 downto 0);
signal MEMWBLo : std_logic_vector(31 downto 0);
signal MEMWBIsZero : std_logic;
signal MEMWBData: std_logic_vector(31 downto 0);
signal MEMWBRegRd : std_logic_vector(4 downto 0);

--Other signals
signal wrDataMux : STD_LOGIC_VECTOR(31 downto 0);
signal MemtoRegMux : STD_LOGIC_VECTOR(31 downto 0);
signal ALULo : STD_LOGIC_VECTOR(31 downto 0);
signal ALUHi : STD_LOGIC_VECTOR(31 downto 0);
signal RegLo : STD_LOGIC_VECTOR(31 downto 0);
signal RegHi : STD_LOGIC_VECTOR(31 downto 0);
signal hazardControl : STD_LOGIC_VECTOR(9 downto 0);

signal BranchAforward : STD_LOGIC_VECTOR(1 downto 0);
signal BranchBforward : STD_LOGIC_VECTOR(1 downto 0);
signal BranchAData : STD_LOGIC_VECTOR(31 downto 0);
signal BranchBData : STD_LOGIC_VECTOR(31 downto 0);












































end func;
