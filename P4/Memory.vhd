LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use STD.textio.all; 
use ieee.std_logic_textio.all;

ENTITY memory IS
	GENERIC(
    	fileAddressRd		:	STRING  := "program.txt";
    	fileAddressWr		:	STRING  := "dump.txt";
		ram_size            :   INTEGER := 8192;
		mem_delay           :   time := 1 ns;
		clock_period        :   time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		init: 	IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address:  IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		dump : IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END memory;

ARCHITECTURE rtl OF memory IS

	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg:  STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_data_sig:  STD_LOGIC_VECTOR (31 DOWNTO 0);
	
BEGIN
	
	--short_address <= address(12 downto 0);
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			For i in 0 to ram_size-1 LOOP
				ram_block(i) <= std_logic_vector(to_unsigned(0,32));
			END LOOP;
		end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(to_integer(signed(address))) <= writedata;
			ELSIF (memread = '1') THEN 
				read_data_sig <= ram_block(to_integer(signed(address)));
			END IF;
		read_address_reg <= address;
		END IF;
	END PROCESS;
	
    readdata <= ram_block(to_integer(signed(read_address_reg)));

	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			readdata <= ram_block(to_integer(signed(address)));
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;
	
	final_write : process(dump)
	variable reg_line : integer := 0;
	variable line_to_write : line;
	file reg_file : TEXT open WRITE_MODE is fileAddressWr;
	begin
		if(dump = '1') then
			while (reg_line /= ram_size) loop
				write(line_to_write, ram_block(reg_line), right, 32);
				writeline(reg_file, line_to_write);
				reg_line := reg_line + 1;
			end loop;
		end if;
	end process final_write;


END rtl;