library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY adder is
port(
	 plus_four : IN INTEGER;
	 counter_out : IN STD_LOGIC_VECTOR(31 downto 0);
	 adder_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	 );
end adder;

architecture arch of adder is

signal add : INTEGER;

begin

	add <= plus_four + to_integer(unsigned(counter_out));
	adder_out <= std_logic_vector(to_unsigned(add, adder_out'length));
	
end arch;
