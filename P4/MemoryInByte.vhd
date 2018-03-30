LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL;

ENTITY MemoryInByte IS
	GENERIC (
		 fileAddressRd		:	STRING  := "program.txt";
		 fileAddressWr		:	STRING  := "MemCon.dat";
		 memSize			:	INTEGER := 256;
		 numBitsInByte		:	INTEGER := 8;
		 rdDelay			:	INTEGER := 0;
		 wrDelay			:	INTEGER := 0
	);

	PORT (
		clock				:	IN STD_LOGIC;
		address 			:	IN INTEGER;
		we 					:	IN STD_LOGIC;
		re 					: 	IN STD_LOGIC;
		rdReady				: 	OUT STD_LOGIC;
		init 				: 	IN STD_LOGIC;
		dump				:	IN STD_LOGIC;
		data				: 	INOUT STD_LOGIC_VECTOR(numBitsInByte-1 downto 0);
		wrDone				:	OUT STD_LOGIC
	);

END MemoryInByte;

ARCHITECTURE arch of MemoryInByte IS

	type memType is array (0 to memSize-1) of std_logic_vector(numBitsInByte-1 downto 0);
	signal memory: memType;

BEGIN

	process(clock, init, dump)
		file filePointer : text;
		variable lineContent : string(1 to numBitsInByte);
		variable lineNum : line;
		variable i, j : INTEGER := 0;
		variable char : CHARACTER := '0';
		variable memAddress : INTEGER := 0;
		variable binVal : STD_LOGIC_VECTOR(numBitsInByte-1 downto 0);
		variable delayCount : INTEGER := 0;

	begin

		--	initializes the memory from a file
		if(init'event AND init='1') then
			--open file read.txt from specified location for READ MODE
			file_open(filePointer, fileAddressRd, READ_MODE);

			while NOT endfile(filePointer) loop -- keep looping till it reaches end of file
				readline(filePointer, lineNum); --read entire line from file
				READ(lineNum, lineContent); -- read contents of line from file into variable

				--for each character in line, convert to binary, then store in signal binVal
				for j in 1 to numBitsInByte loop
					char := lineContent(j);
					if(char = '0') then
						binVal(numBitsInByte-j) := '0';
					else 
						binVal(numBitsInByte-j) := '1';
					end if;
				end loop;

				memory(memAddress) <= binVal;
				memAddress := memAddress + 1;

			end loop;

			file_close(filePointer);


		-- writing to file
		elsif(dump'event AND dump='1') then
			--open file write.txt from specified location for WRITE MODE
			file_open(filePointer, fileAddressWr, WRITE_MODE);

			-- store binary values from 0000 to 1111 in the file
			for i in 0 to memSize-1 loop
				binVal := memory(i);

				--convert each bit val to character for writing to file
				for j in 0 to numBitsInByte-1 loop
					if(binVal(j) = '0') then
						lineContent(numBitsInByte-j) := '0';
					elsif(binVal(j) = '1') then
						lineContent(numBitsInByte-j) := '1';
					elsif(binVal(j) = 'U') then
						lineContent(numBitsInByte-j) := 'U';
					elsif(binVal(j) = 'X') then
						lineContent(numBitsInByte-j) := 'X';
					elsif(binVal(j) = 'Z') then
						lineContent(numBitsInByte-j) := 'Z';
					end if;
				end loop;

				write(lineNum, lineContent); --writes the line
				writeline(filePointer, lineNum); --writes contents into file

			end loop;
			file_close(filePointer); -- after writing is done, close file

		-- use clock if not initializing and dumping
		elsif(clock'event AND clock='1') then
			data <= (others => 'Z'); --since data port is an INOUT

			if(re='1' AND we='0') then
				if(delayCount >= rdDelay) then --wait till rdDelay is done
					data <= memory(address);
					delayCount := 0;
					wrDone <= '0';
					rdReady <= '1';
				else
					data <= (others => 'U');
					delayCount := delayCount + 1;
					wrDone <= '0';
					rdReady <= '0';
				end if;

			elsif(re='0' AND we='1') then
				if(delayCount >= wrDelay) then --wait till wrDelay is done
					memory(address) <= data;
					delayCount := 0;
					wrDone <= '1';
					rdReady <= '0';
				else
					memory(address) <= (others => 'U');
					delayCount := delayCount + 1;
					wrDone <= '0';
					rdReady <= '0';
				end if;

			else
				data <= (others => 'Z'); -- in case rd & wr enables get activated at same time
				wrDone <= '0';
				rdReady <= '0';

			end if;

		end if;

	end process;

end arch;







