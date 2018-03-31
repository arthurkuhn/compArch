LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mainFunction is 

END mainFunction;

Architecture main_behavior of mainFunction is 

constant clockPeriod : time := 1 ns;
signal clockSig : std_logic := '0';
signal clockMemory : std_logic := '0';

component PC is
	PORT 
	(
	addressIn : in std_logic_vector(31 downto 0);
	addressOut : out std_logic_vector(31 downto 0);
	pcWrite : in std_logic;
	clock : in std_logic
	);
END component; 

component memory is
	GENERIC (
		 fileAddressRd		:	STRING  := "program.txt";
		 fileAddressWr		:	STRING  := "memory.txt";
		 memSizeInWord		:	INTEGER := 256;
		 numBytesInWord		:	INTEGER := 4;
		 numBitsInByte		:	INTEGER := 8;
		 rdDelay			:	INTEGER := 0;
		 wrDelay			:	INTEGER := 0	
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
		wrDone				:	OUT STD_LOGIC	
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
		addressOut		: OUT STD_LOGIC_VECTOR  (31 DOWNTO 0);
		IFFlush			: IN STD_LOGIC
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
		DataA     : in  STD_LOGIC_VECTOR(31 downto 0);
        DataB     : in  STD_LOGIC_VECTOR(31 downto 0);
        Control : in  STD_LOGIC_VECTOR(3  downto 0);
        Shamt   : in  STD_LOGIC_VECTOR(4  downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        IsZero  : out STD_LOGIC;
        Hi      : out STD_LOGIC_VECTOR(31 downto 0);
        Lo      : out STD_LOGIC_VECTOR(31 downto 0)
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
		Stall : out std_logic	
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
		EXMEMRegWrite : in std_logic
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
		EXMEMRegWrite : in std_logic
		
	);
END component;

component MEMWB IS
		PORT
		(
			clock			:	IN STD_LOGIC;

			-- Inputs
			RegWriteIn		:	IN STD_LOGIC;		
			MemtoRegIn		:	IN STD_LOGIC;

			zeroIn			: 	IN STD_LOGIC;
			resultIn		:	IN STD_LOGIC_VECTOR(31 downto 0);
			highIn			:	IN STD_LOGIC_VECTOR(31 downto 0);
			lowIn			:	IN STD_LOGIC_VECTOR(31 downto 0);

			wrDoneIn		:	IN STD_LOGIC;
			rdReadyIn		:	IN STD_LOGIC;
			dataIn			:	IN STD_LOGIC_VECTOR(31 downto 0);

			rdIn 			:	IN STD_LOGIC_VECTOR(4 downto 0);

			--Outputs
			RegWriteOut		:	OUT STD_LOGIC;
			MemtoRegOut		:	OUT STD_LOGIC;

			zeroOut			: 	OUT STD_LOGIC;
			resultOut		:	OUT STD_LOGIC_VECTOR(31 downto 0);
			highOut			: 	OUT STD_LOGIC_VECTOR(31 downto 0);
			lowOut			:	OUT STD_LOGIC_VECTOR(31 downto 0);

			wrDoneOut		: 	OUT STD_LOGIC;
			rdReadyOut		:	OUT STD_LOGIC;
			dataOut			:	OUT STD_LOGIC_VECTOR(31 downto 0);

			rdOut 			: 	OUT STD_LOGIC_VECTOR(4 downto 0)

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
END component;


--PC Signals

signal	addressIn : std_logic_vector(31 downto 0);
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
signal initInstMem : STD_LOGIC := '0';
signal dumpInstMem : STD_LOGIC := '0';
signal addressInstMem : STD_LOGIC_VECTOR(31 downto 0);
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
signal IFIDAddress : STD_LOGIC_VECTOR (31 downto 0);
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
signal aluControl : STD_LOGIC_VECTOR(3 downto 0);
signal writelohi : STD_LOGIC;
signal readlohi : STD_LOGIC_VECTOR(1 downto 0);
signal readlohimux : STD_LOGIC_VECTOR(31 downto 0);

-- ALU Signals
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
signal EXMEMResult : std_logic_vector(31 downto 0);
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
signal MEMWBResult : std_logic_vector(31 downto 0);
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

BEGIN

	-- clk process definitions
	clock_process : process
	begin 
		clockSig <= '0';
		wait for clockPeriod/2;
		clockSig <= '1';
		wait for clockPeriod/2;
	end process;

	-- mem clock process defs
	mem_clock_process : process
	begin
		clockMemory <= '0';
		wait for clockPeriod/8;
		clockMemory <= '1';
		wait for clockPeriod/8;
	end process;

	--map PC
	PCInst : PC PORT MAP
	(
		clock => clockSig,
		pcWrite => pcWrite,
		addressIn => JumpMuxOut,
		addressOut => pcAddress
	);

	-- Instruction Mem --
	addressInstMem <= to_integer(unsigned(pcAddress));
	InstMem: MainMemory
		GENERIC MAP(
			fileAddressRd => "Init.dat",
			fileAddressWr => "MemCon.dat",
			memSizeInWord => 2048,
			numBytesInWord => 4,
			numBitsInByte => 8,
			rdDelay => 0,
			wrDelay => 0
		) PORT MAP (
			clock => clockMemory,
			address => to_integer(addressInstMem),
			wordByte => wordByteInstMem,
			we => '0',
			re => reInstMem,
			rdReady => rdReadyInstMem,
			init => initInstMem,
			dump => dumpInstMem,
			data => dataInstMem
		);

	IFFlush <= (PCSrc or Jmp) AND NOT(stall);
	IFIDInst : IFID PORT MAP (
		clock => clockSig,
		IFIDWrite => IFIDWrite,
		addressIn => addressIn,
		addressOut => IFIDAddress,
		instructionIn => dataInstMem,
		instructionOut => IFIDInstruction
	);

	-- Main Control --
	ControlInst : controller PORT MAP (
		Clk => clockMemory,
		Inst => IFIDInstruction(31 downto 26),
		RegDst => RegDst,
		Jmp => Jmp,
		Bch => Bch,
		MemRead => MemRead,
		MemToReg => MemToReg,
		MemWrite => MemWrite,
		AluSrc => AluSrc,
		RegWrite => RegWrite,
		NotZero => NotZero,
		LUI => LUI,
		ALUOp => ALUOp
	);

	-- Registers --
	registerFile : registers PORT MAP (
		loin => Lo,
		hiin => Hi,
		loout => RegLo,
		hiout => RegHi,
		writelohi => writelohi,
		readdata1 => readdata1,
		readdata2 => readdata2,
		readReg1 => IFIDInstruction(25 downto 21),
		readReg2 => IFIDInstruction(20 downto 16),
		regwrite => MEMWBRegWrite,
		writeReg => MEMWBRegRd,
		writedata => MemtoRegMux,
		clock => clockSig,
		init => InitReg
	);

	-- MUX for Data A
	WITH BranchAforward SELECT
		BranchAData <= MemtoRegMux WHEN "01",
					   EXMEMResult WHEN "10",
					   readdata1   WHEN OTHERS;

	-- MUX for Data B
	WITH BranchBforward SELECT
		BranchBData <= MemtoRegMux WHEN "01",
					   EXMEMResult WHEN "10",
					   readdata2   WHEN OTHERS;

	WITH(BranchAData = BranchBData) SELECT
		IDZero <= '1' when TRUE, 
				  '0' when others;

	-- ALU Jump 
	ALU2ShiftDatabb <= signExtend(29 downto 0) & "00";
	AluJmp : ALU
	PORT MAP (
		DataA => IFIDAddress,
		DataB => ALU2ShiftDatabb,
		Control => "0010", --add
		Shamt => IFIDInstruction(10 downto 6),
		Result => BranchAddress,
		Clk => clockSig
	);

	PCSrc <= Bch AND (IDZero XOR NotZero); --used to select line for branch mux

	-- branch MUX 2-1 --
	with PCSrc SELECT
		muxPcSource <= BranchAddress when '1',
					   addressIn when others;

	JumpAddress <= IFIDAddress(31 downto 28) & IFIDInstruction(25 downto 0) & "00";

	-- jump mux 2-1 --
	with Jmp SELECT 
		JumpMuxOut <= JumpAddress when '1',
					  muxPcSource when others;

	-- sign extend --
	with LUI SELECT
		signExtend(15 downto 0) <= IFIDInstruction(15 downto 0) when '0',
		(others => '0') when '1',
		(others => 'X') when others;

	with LUI SELECT
		signExtend(31 downto 16) <= (others => IFIDInstruction(15)) when '0',
		IFIDInstruction(15 downto 0) when '1',
		(others => 'X') when others;

	rs <= IFIDInstruction(25 downto 21);
	rt <= IFIDInstruction(20 downto 16);
	rd <= IFIDInstruction(15 downto 11);

	-- hazard detection --
	HazardDetectionInst: detectHazard
	PORT MAP (
		IDEXMemRead => IDEXMemRead,
		Branch => Bch,
		IDEXRt => IDEXRt,
		IFIDRs => rs,
		IFIDWrite => IFIDWrite,
		PCWrite => pcWrite,
		Stall => stall
	);

	with stall SELECT
		hazardControl <= RegWrite & MemToReg & Bch & MemRead & MemWrite & ALUOp & RegDst & AluSrc when '0',
		"0000000000" when '1',
		(others => 'X') when others;

	IDEXInst: IDEX PORT MAP (
		clock => clockSig,
		RegWriteIn => hazardControl(9),
		MemtoRegIn => hazardControl(8),
		BranchIn => hazardControl(7),
		MemReadIn => hazardControl(6),
		MemWriteIn => hazardControl(5),
		ALUopIn => hazardControl(4 downto 2),
		RegDstIn => hazardControl(1),
		ALUsrcIn => hazardControl(0),
		addressIn => IFIDAddress,
		readdata1In => readdata1,
		readdata2In => readdata2,
		signextendIn => signExtend,
		RsIn => rs,
		RtIn => rt,
		RdIn => rd,
		RegWriteOut => IDEXRegWrite,
		MemtoRegOut => IDEXMemtoReg,
		BranchOut => IDEXBranch,
		MemReadOut => IDEXMemRead,
		MemWriteOut => IDEXMemWrite,
		ALUopOut => IDEXALUop,
		RegDstOut => IDEXRegDst,
		ALUsrcOut => IDEXALUsrc,
		addressOut => IDEXAddress,
		readdata1Out => IDEXreaddata1,
		readdata2Out => IDEXreaddata2,
		RsOut => IDEXRs,
		RtOut => IDEXRt,
		RdOut => IDEXRd
	);

	ALUControlInst: ALU_control PORT MAP (
		ALUOp => IDEXALUop,
		funct => IDEXsignextend(5 downto 0),
		operation => aluControl,
		writeLOHI => writelohi,
		readLOHI => readlohi
	);

	FwdUnitInst : ForwardingUnit PORT MAP (
		Aforward => Aforward,
		Bforward => Bforward,
		IDEXRegRs => IDEXRs,
		IDEXRegRt => IDEXRt,
		MEMWBRegWrite => MEMWBRegWrite,
		MEMWBRegRd => MEMWBRegRd,
		EXMEMRegWrite => EXMEMRegWrite,
		EXMEMRegRd => EXMEMRegRd
	);

	-- MUX for DataA
	with Aforward SELECT
		DataA <= IDEXreaddata1 when "00",
			   MemtoRegMux when "01",
			   EXMEMResult when "10",
			   "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

	 -- MUX for DataB
	with Bforward SELECT
		DataB <= IDEXreaddata2 when "00",
			   MemtoRegMux when "01",
			   EXMEMResult when "10",
			   "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

	with IDEXALUsrc SELECT
		ALUSrcMux <= DataB when '0',
					 IDEXsignextend when '1',
					 "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

	--MUX for IDEXRegRd
	with IDEXRegDst SELECT
		IDEXRegRead <= IDEXRt when '0',
					   IDEXRd when others;

	ALUInst: ALU PORT MAP (
		DataA => DataA,
		DataB => DataB,
		Control => aluControl,
		Shamt => IDEXsignextend(10 downto 6),
		Result => Result,
		Hi => Hi,
		Lo => Lo,
		IsZero => IsZero
	);

	-- WriteData MUX 2-1 --
	with readlohi SELECT
		readlohimux <= Result when "00",
					   RegHi when "10",
					   RegLo when "11",
					   (others => "X") when others;

	EXMEMInst: EXMEM PORT MAP (
		clock => clockSig,

		RegisterIn => IDEXRegWrite,
		MemoryRegisterIn => IDEXMemtoReg,
		BranchIn => IDEXBranch,
		MemoryReadIn => IDEXMemRead,
		MemoryWriteIn => IDEXMemWrite,
		ResultIn => readlohimux,
		HiIn => Hi,
		LowIn => Lo,
		ZeroIn => IsZero,
		DataBIn => DataB,
		AddressIn => BranchAddress,
		RdIn => IDEXRegRead,

		RegisterOut => EXMEMRegWrite,
		MemoryRegisterOut => EXMEMMemtoReg,
		BranchOut => EXMEMBranch,
		MemoryReadOut => EXMEMMemRd,
		MemoryWriteOut => EXMEMMemWrite,
		ResultOut => EXMEMResult,
		HiOut => EXMEMHi,
		LowOut => EXMEMLo,
		ZeroOut => EXMEMIsZero,
		DataBOut => EXMEMDataB,
		AddressOut => EXMEMAddress,
		RdOut => EXMEMRegRd
	);

	DataMemory: MainMemory
		GENERIC MAP (
			fileAddressRd => "Init.dat",
			fileAddressWr => "MemData.dat",
			memSizeInWord => 2048,
			numBytesInWord => 4,
			numBitsInByte => 8,
			rdDelay => 0,
			wrDelay => 0
		)

		PORT MAP (
			clock => clockMemory,
			address => addressDataMem,
			wordByte => wordByteDataMem,
			we => weDataMem,
			re => reDataMem,
			rdReady => rdReadyDataMem,
			wrDone => wrDoneDataMem,
			data => data,
			init => initDataMem,
			dump => dumpDataMem
		);

	MEMWBInst: MEMWB PORT MAP (
		clock => clockSig,
		
		RegWriteIn => EXMEMRegWrite,
		MemtoRegIn => EXMEMMemtoReg,
		wrDoneIn => wrDoneDataMem,
		rdReadyIn => rdReadyDataMem,
		dataIn => MDR,
		resultIn => EXMEMResult,
		highIn => EXMEMHi,
		lowIn => EXMEMLo,
		zeroIn => EXMEMIsZero,
		rdIn => EXMEMRegRd,

		RegWriteOut => MEMWBRegWrite,
		MemtoRegOut => MEMWBMemtoReg,
		wrDoneOut => MEMWBwrDone,
		rdReadyOut => MEMWBrdReady,
		dataOut => MEMWBData,
		resultOut => MEMWBResult,
		highOut => MEMWBHi,
		lowOut => MEMWBLo,
		zeroOut => MEMWBIsZero,
		rdOut => MEMWBRegRd
	);

	with MEMWBMemtoReg SELECT
		MemtoRegMux <= MEMWBData when '1',
					   MEMWBResult when '0',
					   (others => 'X') when others;

	-- Main processes
	InstructionProc: process(clockSig, clockMemory)
	begin
		if(clockMemory'event AND clockMemory='1') then
			case instState is
				when init => pcWrite <= '0';
							 initInstMem <= '1';
							 pcWrite <= '0';
							 instState <= rdInst1;
				when rdInst1 => pcWrite <= '1';
								reInstMem <= '1';
								initInstMem <= '0';

					if(rdReadyInstMem = '1') then
						addressIn <= std_logic_vector(to_unsigned(addressInstMem + 4, 32));
						instState <= rdInst2;
					end if;

				when others => 

			end case;
		end if;

		if(clockSig'event AND clockSig = '1' AND instState = rdInst2) then
			instState <= rdInst1;
		end if;

	end process;

	DataProcess: process (clockMemory, clockSig)
   
   	begin		
      if(clockMemory'event and clockMemory='1') then
			case dataState is
				when init =>
					initDataMem <= '1';
					dataState <= idle;
					InitReg  <='1';

				when idle =>
					InitReg <='0';
					data <= (others=>'Z');
					initDataMem <= '0'; 
					reDataMem<='0';
					weDataMem <='0';
					dumpDataMem  <= '0'; 

					if(EXMEMMemRd  = '1') then
						addressDataMem  <= to_integer(unsigned(EXMEMResult));
						weDataMem  <='0';
						reDataMem <='1';
						initDataMem <= '0';
						dumpDataMem  <= '0';
						dataState <= rdMem1;
					end if;

					if(EXMEMMemWrite  = '1') then
						addressDataMem  <= to_integer(unsigned(EXMEMResult));
						weDataMem  <='1';
						reDataMem <='0';
						initDataMem <= '0';
						dumpDataMem  <= '0';
						data <= EXMEMDataB ;
						dataState <= wrMem1;
					end if;

				when wrMem1 =>					
					if (wrDoneDataMem  = '1') then -- o/p is ready on the mem bus
						dataState <= dump; --write completed, go to the dump state 
					else
						dataState <= wrMem1; -- remain in this state till it sees rd_ready='1';
					end if;

				when fin =>
					initDataMem <= '0'; 
					reDataMem<='0';
					weDataMem <='0';
					dumpDataMem  <= '0'; 

				when others =>

			end case;
		end if;

		if(clockSig'event and clockSig = '1') then
			case dataState is
				when dump =>
					initDataMem <= '0'; 
					reDataMem<='0';
					weDataMem <='0';
					dumpDataMem  <= '1';
					dataState <= idle;

				when rdMem1 =>
				  	if (rdReadyDataMem = '1') then -- o/p is ready on mem bus
						MDR <= data;
						dataState <= idle; --read completes, go to test state write 
						reDataMem <='0';
					else
						dataState <= rdMem1; -- remain in this state till it sees rd_ready='1';
					end if;

				when others =>

			end case;
		end if;

   end process;

end main_behavior;
