LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BranchForwardingUnit IS
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
END BranchForwardingUnit;

ARCHITECTURE ARCH OF BranchForwardingUnit IS
signal MEMWBRegWriteEqualOne : boolean;
signal MEMWBERegRdNotEqualZero : boolean;

BEGIN


Forward: process (EXMEMRegWrite,EXMEMRegRd,IFIDRegRs,IFIDRegRt,MEMWBRegWrite,MEMWBRegRd)
begin
	BranchAforward <= "00";
	BranchBforward <= "00";
	
	if(Branch = '1') then
		-- EX Hazard
		if(EXMEMRegWrite = '1' 
			and (EXMEMRegRd = IFIDRegRs)
			and(EXMEMRegRd /= "00000")) then
				BranchAforward <= "10";
		end if;
		if(EXMEMRegWrite = '1' 
			and (EXMEMRegRd = IFIDRegRt)
			and(EXMEMRegRd /= "00000")) then
				BranchBforward <= "10";
		end if;
		
		-- MEM Hazard
		if(     (MEMWBRegWrite = '1')
			and (MEMWBRegRd = IFIDRegRs)
		    and (MEMWBRegRd /= "00000") 
		    and (not(EXMEMRegWrite = '1' and (EXMEMRegRd = IFIDRegRs) and (EXMEMRegRd /= "00000")))) 
			  then
				     BranchAforward <= "01";
		end if;
		if(MEMWBRegWrite = '1'
			and (MEMWBRegRd = IFIDRegRt)
			and(MEMWBRegRd /= "00000")
			and(not(EXMEMRegWrite = '1' and (EXMEMRegRd = IFIDRegRt) and (EXMEMRegRd /= "00000")))) 
			then
				BranchBforward <= "01";
		end if;
	end if;
		
end process;
	
	
END ARCH;