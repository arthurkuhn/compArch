LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY signextender IS
PORT (
        immediateIn: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        immediateOut: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END signextender;

ARCHITECTURE arch OF signextender IS

BEGIN

process (immediateIn)
begin
	--Only Sign extend at the moment
	if immediateIn(15) = '1' then
		immediateOut(31 downto 16) <= "1000000000000000";
	else
		immediateOut(31 downto 16) <= "0000000000000000";
	end if;
	immediateOut(15 downto 0) <= immediateIn;
end process;

END arch;
