LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL; -- this library is used for file operations

ENTITY MainMemory IS
	GENERIC (
		 fileAddressRd		:	STRING  := "Init.dat";
		 fileAddressWr		:	STRING  := "MemCon.dat";
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
		rdReady				: 	OUT STD_LOGIC;
		init 				: 	IN STD_LOGIC;
		dump				:	IN STD_LOGIC;
		data				: 	INOUT STD_LOGIC_VECTOR((numBytesInWord*numBitsInByte)-1 downto 0);
		wrDone				:	OUT STD_LOGIC
	);

END MainMemory;

ARCHITECTURE behavioural of MainMemory IS

signal data0, data1, data2, data3 : STD_LOGIC_VECTOR(numBitsInByte-1 downto 0);
signal wrDone0, wrDone1, wrDone2, wrDone3 : STD_LOGIC;
signal rdReady0, rdReady1, rdReady2, rdReady3: STD_LOGIC;
signal re0, re1, re2, re3 : STD_LOGIC;
signal we0, we1, we2, we3 : STD_LOGIC;

signal byteOffset : INTEGER := 0;
signal wordPointer : INTEGER := 0;
signal blockMemInit : STD_LOGIC := '0';

component MemoryInByte
	GENERIC (
		fileAddressRd : STRING := "Init.dat";
		fileAddressWr : STRING := "MemCon.dat";
		memSize : INTEGER := 256;
		numBitsInByte : INTEGER := 8;
		rdDelay : INTEGER := 0;
		wrDelay : INTEGER := 0
	);

	PORT (
		clock : IN STD_LOGIC;
		address : IN INTEGER;
		we : IN STD_LOGIC;
		wrDone : OUT STD_LOGIC;
		re : IN STD_LOGIC;
		init : IN STD_LOGIC;
		dump : IN STD_LOGIC;
		data : INOUT STD_LOGIC_VECTOR(numBitsInByte-1 downto 0);
		rdReady : OUT STD_LOGIC
	);
END component;

BEGIN
	Block0: MemoryInByte
		GENERIC MAP (
			fileAddressRd => "Init0.dat",
			fileAddressWr => "MemCon0.dat",
			memSize => memSizeInWord,
			numBitsInByte => numBitsInByte,
			rdDelay => rdDelay,
			wrDelay => wrDelay
		)

		PORT MAP (
			clock => clock,
			address => (wordPointer),
			we => we0,
			wrDone => wrDone0,
			re => re0,
			rdReady => rdReady0,
			data => data0,
			init => blockMemInit,
			dump => dump
		);

	Block1: MemoryInByte
		GENERIC MAP (
			fileAddressRd => "Init1.dat",
			fileAddressWr => "MemCon1.dat",
			memSize => memSizeInWord,
			numBitsInByte => numBitsInByte,
			rdDelay => rdDelay,
			wrDelay => wrDelay
		)

		PORT MAP (
			clock => clock,
			address => (wordPointer),
			we => we1,
			wrDone => wrDone1,
			re => re1,
			rdReady => rdReady1,
			data => data1,
			init => blockMemInit,
			dump => dump
		);

	Block2: MemoryInByte
		GENERIC MAP (
			fileAddressRd => "Init2.dat",
			fileAddressWr => "MemCon2.dat",
			memSize => memSizeInWord,
			numBitsInByte => numBitsInByte,
			rdDelay => rdDelay,
			wrDelay => wrDelay
		)

		PORT MAP (
			clock => clock,
			address => (wordPointer),
			we => we2,
			wrDone => wrDone2,
			re => re2,
			rdReady => rdReady2,
			data => data2,
			init => blockMemInit,
			dump => dump
		);

	Block3: MemoryInByte
		GENERIC MAP (
			fileAddressRd => "Init3.dat",
			fileAddressWr => "MemCon3.dat",
			memSize => memSizeInWord,
			numBitsInByte => numBitsInByte,
			rdDelay => rdDelay,
			wrDelay => wrDelay
		)

		PORT MAP (
			clock => clock,
			address => (wordPointer),
			we => we3,
			wrDone => wrDone3,
			re => re3,
			rdReady => rdReady3,
			data => data3,
			init => blockMemInit,
			dump => dump
		);

byteOffset <= address mod 4;
wordPointer <= address/4;

we0 <= '1' when (we='1' AND wordByte='1') OR (we='1' AND wordByte='0' and byteOffset=0) else '0';
we1 <= '1' when (we='1' AND wordByte='1') OR (we='1' AND wordByte='0' and byteOffset=1) else '0';
we2 <= '1' when (we='1' AND wordByte='1') OR (we='1' AND wordByte='0' and byteOffset=2) else '0';
we3 <= '1' when (we='1' AND wordByte='1') OR (we='1' AND wordByte='0' and byteOffset=3) else '0';

data0 <= data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='1') else data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='0' AND byteOffset=0) else "ZZZZZZZZ";
data1 <= data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='1') else data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='0' AND byteOffset=1) else "ZZZZZZZZ";
data2 <= data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='1') else data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='0' AND byteOffset=2) else "ZZZZZZZZ";
data3 <= data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='1') else data(numBitsInByte*1-1 downto 0) when (we='1' AND wordByte='0' AND byteOffset=3) else "ZZZZZZZZ";

data(numBitsInByte*1-1 downto 0) <= data0 when (re='1' AND wordByte='1') 
	else data0 when(re='1' AND wordByte='0' and byteOffset=0) 
	else data1 when(re='1' AND wordByte='0' and byteOffset=1)
	else data2 when(re='1' AND wordByte='0' and byteOffset=2)
	else data3 when(re='1' AND wordByte='0' and byteOffset=3)
	else "ZZZZZZZZ";
data(numBitsInByte*2-1 downto numBitsInByte*1) <= data1 when (re='1' AND wordByte='1') else "ZZZZZZZZ";
data(numBitsInByte*3-1 downto numBitsInByte*2) <= data2 when (re='1' AND wordByte='1') else "ZZZZZZZZ";
data(numBitsInByte*4-1 downto numBitsInByte*3) <= data3 when (re='1' AND wordByte='1') else "ZZZZZZZZ";

re0 <= '1' when (re='1' AND wordByte='1') OR (re='1' AND wordByte='0' and byteOffset=0) else '0';
re1 <= '1' when (re='1' AND wordByte='1') OR (re='1' AND wordByte='0' and byteOffset=1) else '0';
re2 <= '1' when (re='1' AND wordByte='1') OR (re='1' AND wordByte='0' and byteOffset=2) else '0';
re3 <= '1' when (re='1' AND wordByte='1') OR (re='1' AND wordByte='0' and byteOffset=3) else '0';

rdReady <= '1' when rdReady0='1' OR rdReady1='1' OR rdReady2='1' OR rdReady3='1' else '0';
wrDone <= '1' when wrDone0='1' OR wrDone1='1' OR wrDone2='1' OR wrDone3='1' else '0';

	process (clock, init, dump)

			file filePointer : text;
			file fileWrPointer0, fileWrPointer1, fileWrPointer2, fileWrPointer3 : text;
			file fileRdPointer0, fileRdPointer1, fileRdPointer2, fileRdPointer3 : text;
			variable lineContent : string(1 to numBytesInWord*numBitsInByte);
			variable lineContentRd, lineContentRd0, lineContentRd1, lineContentRd2, lineContentRd3 : string(1 to numBitsInByte);
			variable lineNumRd, lineNumWr : line;
			variable i, j : INTEGER := 0;
			variable char : CHARACTER := '0';
			variable memAddress : INTEGER := 0;
			variable wordValue : STD_LOGIC_VECTOR(numBytesInWord*numBitsInByte-1 downto 0);
			variable byteValue : STD_LOGIC_VECTOR(numBitsInByte-1 downto 0);
			variable delayCount : INTEGER := 0;

	begin

		blockMemInit <= '0';

		-- initializes mem from a file
		if(init'event AND init='1') then
			--open file <read.txt> from specified location for rd mode
			file_open(filePointer, fileAddressRd, READ_MODE);
			file_open(fileWrPointer0, "Init0.dat", WRITE_MODE);
			file_open(fileWrPointer1, "Init1.dat", WRITE_MODE);
			file_open(fileWrPointer2, "Init2.dat", WRITE_MODE);
			file_open(fileWrPointer3, "Init3.dat", WRITE_MODE);

			while NOT endfile(filePointer) loop --keep looping till it reaches end of file
				readline(filePointer, lineNumRd); --read the entire line from file
				READ(lineNumRd, lineContent); -- read contents of line from file into a variable

				write(lineNumWr, lineContent(1 to numBitsInByte*1)); --write the line
				writeline(fileWrPointer3, lineNumWr); --write contents into the file
					write(lineNumWr, lineContent(numBitsInByte*1+1 to numBitsInByte*2));
				writeline(fileWrPointer2, lineNumWr); --write contents into the file
					write(lineNumWr, lineContent(numBitsInByte*2+1 to numBitsInByte*3));
				writeline(fileWrPointer1, lineNumWr); --write contents into the file
					write(lineNumWr, lineContent(numBitsInByte*3+1 to numBitsInByte*4));
				writeline(fileWrPointer0, lineNumWr); --write contents into the file

			end loop;

			file_close(filePointer); -- once all the lines are read, close file
			file_close(fileWrPointer0);
			file_close(fileWrPointer1);
			file_close(fileWrPointer2);
			file_close(fileWrPointer3);

			blockMemInit <= '1';

		-- Writes to the file

		elsif(dump'event AND dump='1') then
			--open file <write.txt> from specified location for WRITE MODE
			file_open(filePointer, fileAddressWr, WRITE_MODE);
			file_open(fileRdPointer0, "MemCon0.dat", READ_MODE);
			file_open(fileRdPointer1, "MemCon1.dat", READ_MODE);
			file_open(fileRdPointer2, "MemCon2.dat", READ_MODE);
			file_open(fileRdPointer3, "MemCon3.dat", READ_MODE);

			-- we must store binary values from 0000 to 1111 in the file

			for i in 0 to memSizeInWord-1 loop

				readline(fileRdPointer0, lineNumRd); --read the entire line from file
				READ(lineNumRd, lineContentRd0); -- read contents of line from file into a variable

				readline(fileRdPointer1, lineNumRd); --read the entire line from file
				READ(lineNumRd, lineContentRd1); -- read contents of line from file into a variable

				readline(fileRdPointer2, lineNumRd); --read the entire line from file
				READ(lineNumRd, lineContentRd2); -- read contents of line from file into a variable

				readline(fileRdPointer3, lineNumRd); --read the entire line from file
				READ(lineNumRd, lineContentRd3); -- read contents of line from file into a variable

				lineContent(1 to numBitsInByte) := lineContentRd3;
				lineContent(1*numBitsInByte+1 to 2*numBitsInByte) := lineContentRd2;
				lineContent(2*numBitsInByte+1 to 3*numBitsInByte) := lineContentRd1;
				lineContent(3*numBitsInByte+1 to 4*numBitsInByte) := lineContentRd0;

				write(lineNumWr, lineContent); --write the line
				writeline(filePointer, lineNumWr); --write the contents into file

			end loop;

			file_close(filePointer); --once all files are read, close them
			file_close(fileRdPointer0);
			file_close(fileRdPointer1);
			file_close(fileRdPointer2);
			file_close(fileRdPointer3);

		end if;

	end process;

end behavioural;


