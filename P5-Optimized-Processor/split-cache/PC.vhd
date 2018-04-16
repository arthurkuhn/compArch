library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY pc is
PORT(clk : in std_logic;
	 reset : in std_logic;
	 counter_out : out std_logic_vector(31 downto 0);
	 counter_in : in std_logic_vector(31 downto 0) := x"00000000"
	 );
end pc;

architecture arch of pc is

begin

process (clk,reset)
begin

	if (reset = '1') then
		counter_out <= x"00000000";
	elsif (clk'event and clk = '1') then
		counter_out <= counter_in;

	end if;

	end process;

end arch;
