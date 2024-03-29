LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY detectHazard IS
	PORT
	(
		IDEXMemRead : in std_logic;
		Branch: in std_logic;
		IDEXRt : in std_logic_vector(4 downto 0);
		IFIDRt : in std_logic_vector(4 downto 0);
		IFIDRs : in std_logic_vector (4 downto 0);
		IFIDWrite: out std_logic;
		PCWrite : out std_logic;
		Stall : out std_logic	

	);
END detectHazard;

ARCHITECTURE A OF detectHazard IS

BEGIN

Hazard : process(IDEXMemRead, Branch, IDEXRt, IFIDRs, IFIDRt)
begin
IFIDWrite <= '1';
PCWrite <= '1';
Stall <= '0';

if((IDEXMemRead = '1' or Branch = '1') and
	((IDEXRt = IFIDRs) or
	(IDEXRt = IFIDRt))) and 
(IDEXRt /= "00000") then
IFIDWrite <= '0';
PCWrite <= '0';
Stall <= '1';

end if;
end process;
END A;