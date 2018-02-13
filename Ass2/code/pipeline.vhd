-- Arthur Kuhn
-- 260565829

library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
end pipeline;

architecture behavioral of pipeline is

	signal temp1,temp2, temp3, temp4, temp5 : integer := 0;

	begin
	-- todo: complete this
	process (clk)
	begin
		if(rising_edge(clk)) then
			for i in 0 to 2 loop
				case i is
					when 0 =>
						temp1 <= a+b;
						temp3 <= c*d;
						temp4 <= a-e;
						op1 <= temp1;
						op3 <= temp3;
						op4 <= temp4;
					when 1 =>
						temp2 <= 42*temp1;
						temp5 <= temp3*temp4;
						op2 <= temp2;
						op5 <= temp5;
					when 2 =>
						final_output <= temp2-temp5;
					when others => null;
				end case;
			end loop;
		end if;
	end process;

end behavioral;