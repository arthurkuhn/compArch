LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity registers is
	generic(
		clockperiod : time := 1 ns
	);
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
				regs(0) <= x"00000000";
			end if;
			if(writelohi = '1') then
				regs(32) <= loin;
				regs(33) <= hiin;
			end if;
		end if;
	end process;
	
	readdata1 <= regs(to_integer(unsigned(readReg1)));
	readdata2 <= regs(to_integer(unsigned(readReg2)));
	
	loout <= regs(32);
	hiout <= regs(33);
	
end behaviour;