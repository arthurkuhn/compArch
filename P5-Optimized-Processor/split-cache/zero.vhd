library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY zero is
PORT (in_A : IN std_logic_vector (31 downto 0);
	in_B : IN std_logic_vector (31 downto 0);
	op_type : IN std_logic_vector (4 downto 0);
	result: OUT std_logic := '0'
  );
END zero;

ARCHITECTURE arch of zero is

begin
process (in_A, in_B, op_type)
begin
	case op_type is
		when "10110" => -- beq
			if unsigned(in_A) = unsigned(in_B) then
				result <= '1';
			else
				result <= '0';
			end if;
		when "10111" => -- bne
			if unsigned(in_A) = unsigned(in_B) then
				result <= '0';
			else
				result <= '1';
			end if;
		when "11000" => -- j
			result <= '1';

		when "11001" => -- jr
			result <= '1';

		when "11010" => -- jal
			result <= '1';
		when others =>
			result <= '0';
	end case;
end process;

end arch;
