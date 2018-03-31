LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MEMWB IS
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
END MEMWB;

ARCHITECTURE arch OF MEMWB IS

signal RegWriteTmp		:	STD_LOGIC;
signal MemToRegTmp		: 	STD_LOGIC;

signal wrDoneTmp		:	STD_LOGIC;
signal rdReadyTmp		:	STD_LOGIC;
signal dataTmp			: 	STD_LOGIC_VECTOR(31 downto 0);

signal zeroTmp			:	STD_LOGIC;
signal resultTmp		: 	STD_LOGIC_VECTOR(31 downto 0);
signal highTmp			:	STD_LOGIC_VECTOR(31 downto 0);
signal lowTmp			:	STD_LOGIC_VECTOR(31 downto 0);

signal rdTmp 			:	STD_LOGIC_VECTOR(4 downto 0);

BEGIN

	RegWriteTmp <=	RegWriteIn;
	MemToRegTmp <=	MemtoRegIn;

	zeroTmp <=	zeroIn;
	resultTmp <= resultIn;
	highTmp <= highIn;
	lowTmp <= lowIn;

	wrDoneTmp <= wrDoneIn;
	rdReadyTmp <= rdReadyIn;

	rdTmp <= rdIn;


data_buffer: process(dataIn)

begin
	if(dataIn /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then
		dataTmp <= dataIn;
	end if;

end process;

IDIF: process(clock)

begin 
	if(clock'event AND clock = '1') then

		RegWriteOut <= RegWriteTmp;
		MemtoRegOut <= MemToRegTmp;

		zeroOut <= zeroTmp;
		resultOut <= resultTmp;
		highOut <= highTmp;
		lowOut <= lowTmp;

		wrDoneOut <= wrDoneTmp;
		rdReadyOut <= rdReadyTmp;
		dataOut <= dataTmp;

		rdOut <= rdTmp;

	end if;

end process;

END arch;
