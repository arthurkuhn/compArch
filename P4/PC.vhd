LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PC IS
	PORT(
	addressIn : in std_logic_vector(31 downto 0);
	addressOut : out std_logic_vector(31 downto 0);
	pcWrite : in std_logic;
	clock : in std_logic
);
END PC;

ARCHITECTURE A of PC is

signal temp_address : std_logic_vector(31 downto 0);

BEGIN

temp_address <= addressIn;

PC: process(clock)
begin
	if(clock'event AND clock = '1') then			
		if (pcWrite = '1') then
			addressOut <= temp_address;
		end if;
	end if;
end process;
END A;  
