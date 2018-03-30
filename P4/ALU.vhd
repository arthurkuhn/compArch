LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ALU is
	Port (
		CLK	: in  STD_LOGIC;
		InA     : in  STD_LOGIC_VECTOR(31 downto 0);
        InB     : in  STD_LOGIC_VECTOR(31 downto 0);
        Control : in  STD_LOGIC_VECTOR(3  downto 0);
        Shamt   : in  STD_LOGIC_VECTOR(4  downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        IsZero  : out STD_LOGIC;
        Hi      : out STD_LOGIC_VECTOR(31 downto 0);
        Lo      : out STD_LOGIC_VECTOR(31 downto 0);
	);
end ALU;

architecture Behavior of ALU is

    signal addResult, subResult, multResult, divResult, divRemainder : integer := 0; -- integer temporary results
    signal divOut, divRemainderOut, aluOut, sltOut : std_logic_vector(31 downto 0);  -- 32 bit integers
    signal addSub : integer;

    constant AND_OP : STD_LOGIC_VECTOR (4 downto 0) := "0000";
    constant OR_OP : STD_LOGIC_VECTOR (4 downto 0) := "0001";
    constant ADD_OP : STD_LOGIC_VECTOR (4 downto 0) := "0010";
    constant MULT_OP : STD_LOGIC_VECTOR (4 downto 0) := "0011";
    constant DIV_OP : STD_LOGIC_VECTOR (4 downto 0) "= "0100";
    constant SUB_OP : STD_LOGIC_VECTOR (4 downto 0) := "0110";
    constant SET_LT : STD_LOGIC_VECTOR (4 downto 0) := "0111";
    constant SHIFT_LOGICAL_L : STD_LOGIC_VECTOR (4 downto 0) := "1000";
    constant SHIFT_LOGICAL_R : STD_LOGIC_VECTOR (4 downto 0) := "1001";
    constant SHIFT_R : STD_LOGIC_VECTOR (4 downto 0) := "1010";
    constant XOR_OP : STD_LOGIC_VECTOR (4 downto 0) := "1100";
    constant NOR_OP : STD_LOGIC_VECTOR (4 downto 0) := "1101";


begin

    -- The operations are synthesized first, a multiplexer is then used to select the correct output

    -- INTEGER OPERATIONS --
    addResult <= to_integer(signed(InA)) + to_integer(signed(InB));
    subResult <= to_integer(signed(InA)) - to_integer(signed(InB));
    multiplierResult <= to_integer(signed(InA)) * to_integer(signed(InB));
    dividerResult	 <= to_integer(signed(InA)) / to_integer(signed(InB)) when to_integer(signed(InB)) /= 0;
    dividerRemainder <= to_integer(signed(InA)) mod to_integer(signed(InB)) when to_integer(signed(InB)) /= 0;

    -- CONVERSIONS --
    sltOut <= std_logic_vector(to_signed(subResult, 32)); -- MSB gives the output
    multOut <= std_logic_vector(to_signed(multiplierResult, 64));
    divOut <= std_logic_vector(to_signed(dividerResult, 32));
    divRemainderOut <= std_logic_vector(to_signed(dividerRemainder, 32));

    -- Output Multiplexer
    with control select
        aluOut <=
            InA AND InB                                                             when AND_OP,
            InA OR  InB 		                                                    when OR_OP,
            std_logic_vector(to_signed(subResult, 32)) 		                        when SUB_OP,
            std_logic_vector(to_signed(addResult, 32)) 		                        when ADD_OP,
            std_logic_vector(unsigned(sltResult) srl 31) 	                        when SET_LT, -- The MSB is 1 if negative of 0 if positve
            InA NOR InB 								                            when NOR_OP,
            InA XOR InB 							                                when XOR_OP,
            std_logic_vector(unsigned(InB) sll to_integer(unsigned(shamt)))	        when SHIFT_LOGICAL_LEFT,
            std_logic_vector(unsigned(InB) srl to_integer(unsigned(shamt)))	        when SHIFT_LOGICAL_RIGHT,
            to_stdlogicvector(to_bitvector(InA) sra to_integer(unsigned(shamt)))	when SHIFT,
            std_logic_vector(to_signed(addResult, 32)) 					            when OTHERS;

    -- Slt Comparaison
    with subResult select
    	IsZero <=
    		'1'                                     when 0,
    		'0'                                     when OTHERS;

    -- High Output
    with control select
    	Hi <=
    		multResult(63 DOWNTO 32)		        when  MULT_OP,
    		divRemainder(31 DOWNTO 0)		        when  DIV_OP,
    		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	    when  OTHERS;

    -- Lo Output
    with control select
    	Lo <=
    	    multResult(31 DOWNTO 0) 		        when MULT_OP,
    		divResult				                when DIV_OP,
    		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	    when OTHERS;

    result <= aluResult;

end Behavioral;
