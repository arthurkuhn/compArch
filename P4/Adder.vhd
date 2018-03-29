library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C : in  STD_LOGIC;
           sum : out  STD_LOGIC;
			  Cout : out std_logic);
end Adder;

architecture Behavioral of Adder is

begin
process(A,B,C)
begin
sum <= A xor B xor C;
Cout <= (A and B) or (B and C) or (C and A);
end process;
end Behavioral;