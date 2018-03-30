LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ForwardingUnit IS
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
END ForwardingUnit;

ARCHITECTURE ARCH OF ForwardingUnit IS
signal MEMWBRegRdNotEqualZero : boolean;
signal MEMWBRegWriteEqualOne : boolean;

BEGIN


Forward: process (EXMEMRegWrite,EXMEMRegRd,IDEXRegRs,IDEXRegRt,MEMWBRegWrite,MEMWBRegRd)
begin
	Aforward <= "00";
	Bforward <= "00";
	
	-- EX Hazard
	if((EXMEMRegWrite = '1')
		and(EXMEMRegRd = IDEXRegRs)
		and(EXMEMRegRd /= "00000")) then
			Aforward <= "10";
	end if;
	if((EXMEMRegWrite = '1')
		and (EXMEMRegRd = IDEXRegRt)
		and(EXMEMRegRd /= "00000")) then
			Bforward <= "10";
	end if;
	
	MEMWBRegWriteEqualOne <= (not((EXMEMRegRd /= "00000") and (EXMEMRegWrite = '1')));
	MEMWBRegRdNotEqualZero  <= (EXMEMRegRd /= IDEXRegRs);
	
	-- MEM Hazard
	if((MEMWBRegWrite = '1')
	    and (MEMWBRegRd /= "00000") 
		and (MEMWBRegRd = IDEXRegRs)
	    and (not(EXMEMRegWrite = '1' and (EXMEMRegRd = IDEXRegRs) and (EXMEMRegRd /= "00000")))) 
		  then
			     Aforward <= "01";
	end if;
	if((MEMWBRegWrite = '1')
		and (MEMWBRegRd = IDEXRegRt)
		and(MEMWBRegRd /= "00000")
		and(not(EXMEMRegWrite = '1' and (EXMEMRegRd /= "00000")		and (EXMEMRegRd = IDEXRegRt)))) 
		then
			Bforward <= "01";
	end if;
		
end process;
	
	
END ARCH;