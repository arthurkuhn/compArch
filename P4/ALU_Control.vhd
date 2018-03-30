LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ALU_control is
	port (
		ALUOp			: in std_logic_vector(2 downto 0); -- from main control
		funct 			: in std_logic_vector(5 downto 0); -- from instruction
		operation		: out std_logic_vector(3 downto 0); -- output to ALU
		writeLOHI		: out std_logic;
		readLOHI		: out std_logic_vector(1 downto 0)
	);
end ALU_control;

architecture behaviour of ALU_control is
	signal op_reg: std_logic_vector(3 downto 0);

    constant AND_OP : STD_LOGIC_VECTOR (4 downto 0) := "0000";
    constant OR_OP : STD_LOGIC_VECTOR (4 downto 0) := "0001";
    constant ADD_OP : STD_LOGIC_VECTOR (4 downto 0) := "0010";
    constant MULT_OP : STD_LOGIC_VECTOR (4 downto 0) := "0011";
    constant SUB_OP : STD_LOGIC_VECTOR (4 downto 0) := "0110";
    constant SET_LT : STD_LOGIC_VECTOR (4 downto 0) := "0111";
    constant SHIFT_LOGICAL_L : STD_LOGIC_VECTOR (4 downto 0) := "1000";
    constant SHIFT_LOGICAL_R : STD_LOGIC_VECTOR (4 downto 0) := "1001";
    constant SHIFT_R : STD_LOGIC_VECTOR (4 downto 0) := "1010";
    constant XOR_OP : STD_LOGIC_VECTOR (4 downto 0) := "1100";
    constant NOR_OP : STD_LOGIC_VECTOR (4 downto 0) := "1101";

begin


	reg_process: process (ALUOp, funct)
	begin
	writeLOHI <= '0';
	readLOHI <= "00";
	case ALUOp is
		-- load and store
		when "000" =>
			op_reg <= ADD_OP;
		-- branch equal
		when "001" =>
			op_reg <= SUB_OP;
		-- I-type
		-- slti
		when "100" =>
			op_reg <= SET_LT;
		-- andi
		when "101" =>
			op_reg <= AND_OP;
		-- ori
		when "110" =>
			op_reg <= OR_OP;
		-- xori
		when "111" =>
			op_reg <= XOR_OP;
		-- R-type
		when "010" =>
			case funct is
				-- AND
				when "100100"=>
					op_reg <= AND_OP;
				-- OR
				when "100101"=>
					op_reg <= OR_OP;
				-- add
				when "100000"=>
					op_reg <= ADD_OP;
				-- multiply
				when "011000"=>
					op_reg <= MULT_OP;
					writeLOHI <= '1';
				-- divide
				when "011010"=>
					op_reg <= DIV_OP;
					writeLOHI <= '1';
				-- subtract
				when "100010"=>
					op_reg <= SUB_OP;
				-- set on less than
				when "101010"=>
					op_reg <= SET_LT;
				-- shift left logical
				when "000000"=>
					op_reg <= SHIFT_LOGICAL_L
				-- shift right logical
				when "000010"=>
					op_reg <= SHIFT_LOGICAL_R
				-- shift right arithmetic
				when "000011"=>
					op_reg <= SHIFT_R;
				-- NOR
				when "100111"=>
					op_reg <= NOR_OP;
				-- XOR
				when "100110"=>
					op_reg <= XOR_OP;
				-- Move from LO
				when "010010"=>
					op_reg <= ADD_OP;
					readLOHI <= "11";
				-- Move from HI
				when "010000"=>
					op_reg <= ADD_OP;
					readLOHI <= "10";
				when others =>
					null;
			end case;
		when others =>
			null;
	end case;
	end process;

	operation <= op_reg;

end behaviour;