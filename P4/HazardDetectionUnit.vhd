LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY HazardDetectionUnit IS
	PORT
	(
		PCWrite : out std_logic;
		stall : out std_logic
		
		IFIDWrite : out std_logic;
		IFIDRegRt : in std_logic_vector(4 downto 0);
		IFIDRegRs : in std_logic_vector(4 downto 0);
		
		IDEXMemRead : in std_logic;
		IDEXRegRt : in std_logic_vector(4 downto 0);
	);
END HazardDetectionUnit;

ARCHITECTURE ARCH OF HazardDetectionUnit IS

BEGIN

Hazard: process (IDEXMemRead,IDEXRegRt,IFIDRegRs,IFIDRegRt)
begin
	IFIDWrite <= '1';
	PCWrite <= '1';
	stall <= '0';

	if(IDEXMemRead = '1' and
		((IDEXRegRt = IFIDRegRs) or
		 (IDEXRegRt = IFIDRegRt))) then
			IFIDWrite <= '0';
			PCWrite <= '0';
			stall <= '1';
	end if;
		
end process;
	
	
END ARCH;