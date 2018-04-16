library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY mux is
PORT(
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 select_in : in std_logic;
	 select_out : out std_logic_vector(31 downto 0)
	 );
	 
end mux;

architecture arch of mux is

begin

	select_out <= input1 when (select_in = '1') else input0 ;
	
end arch;
