LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IFID IS
	PORT
	(
		clock			: IN STD_LOGIC;
		IFIDWrite		: IN STD_LOGIC;
		instructionIn	: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
		instructionOut	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		addressIn		: IN STD_LOGIC_VECTOR  (31 DOWNTO 0);
		addressOut		: OUT STD_LOGIC_VECTOR  (31 DOWNTO 0)
	);
END IFID;

ARCHITECTURE ARCH OF IFID IS

signal addressTmp : std_logic_vector(31 downto 0);
signal instructionTmp : std_logic_vector(31 downto 0);

BEGIN
addressTmp <= address_in;
instructionBuffer: process(instruction_in)
begin
	if(instructionIn /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") then
		instructionTmp <= instructionIn;
	end if;
end process;


IDIF: process (clock)
begin
	if (clock'event AND clock = '1') then
		if(IFIDWrite = '1') then

			addressOut <= addressTmp;
			instructionOut <= instructionTmp;			
		end if;
	end if;
end process;
	
	
END ARCH;