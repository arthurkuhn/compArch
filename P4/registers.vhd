LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity registers is
	generic(
		clockperiod : time := 1 ns;
		fileAddressWr		:	STRING  := "memory.txt"
	);
	port (
        dump        : in std_logic := '0';
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
end registers;

architecture behaviour of registers is

	constant	dataWidth	: integer := 32;
	constant	regWidth	: integer := 32;

	type memory is array(regWidth+1 downto 0) OF std_logic_vector(dataWidth-1 downto 0);
	signal regs: memory;
	-- Register 0 : connected to ground
	-- Register 31: return address
	-- Register 32: LO
	-- Register 33: HI
begin
	regRrocess: process (clock)
	begin
        if (clock'event AND clock = '1') then
		
			if (init = '1') then
				for i in 0 to regWidth-1 loop 
					regs(i) <= (others => 'Z');
				end loop;
			elsif(regwrite = '1') then
				regs(to_integer(unsigned(writeReg))) <= writedata;
			end if;
			if(writelohi = '1') then
				regs(32) <= loin;
				regs(33) <= hiin;
			end if;

			regs(0) <= "00000000000000000000000000000000";
		end if;
	end process;
	
	readdata1 <= regs(to_integer(unsigned(readReg1)));
	readdata2 <= regs(to_integer(unsigned(readReg2)));
	
	loout <= regs(32);
	hiout <= regs(33);

	final_write : process(dump)
    	variable reg_line : integer := 0;
    	variable line_to_write : line;
    	file reg_file : TEXT open WRITE_MODE is fileAddressWr;
    	begin
    		if(dump = '1') then
    			while (reg_line /= regWidth) loop
    				write(line_to_write, regs(reg_line), right, 32);
    				writeline(reg_file, line_to_write);
    				reg_line := reg_line + 1;
    			end loop;
    		end if;
    	end process final_write;

end behaviour;