LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ALU is
	PORT (
		CLK	: in  STD_LOGIC;
		DataA     : in  STD_LOGIC_VECTOR(31 downto 0);
        DataB     : in  STD_LOGIC_VECTOR(31 downto 0);
        Control : in  STD_LOGIC_VECTOR(3  downto 0);
        Shamt   : in  STD_LOGIC_VECTOR(4  downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        IsZero  : out STD_LOGIC;
        Hi      : out STD_LOGIC_VECTOR(31 downto 0);
        Lo      : out STD_LOGIC_VECTOR(31 downto 0)
	);
end ALU;

architecture Behavior of ALU is

    signal addResult, subResult, multResult, divResult, divRemainder : integer := 0; -- integer temporary results
    signal divOut, divRemainderOut, aluOut, sltOut : std_logic_vector(31 downto 0);  -- 32 bit integers
    signal multOut : std_logic_vector(63 downto 0);  -- 32 bit integers
    signal addSub : integer;

    constant AND_OP : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant OR_OP : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant ADD_OP : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant MULT_OP : STD_LOGIC_VECTOR (3 downto 0) := "0011";
    constant DIV_OP : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant SUB_OP : STD_LOGIC_VECTOR (3 downto 0) := "0110";
    constant SET_LT : STD_LOGIC_VECTOR (3 downto 0) := "0111";
    constant SHIFT_LOGICAL_L : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant SHIFT_LOGICAL_R : STD_LOGIC_VECTOR (3 downto 0) := "1001";
    constant SHIFT_R : STD_LOGIC_VECTOR (3 downto 0) := "1010";
    constant XOR_OP : STD_LOGIC_VECTOR (3 downto 0) := "1100";
    constant NOR_OP : STD_LOGIC_VECTOR (3 downto 0) := "1101";


begin

    -- The operations are synthesized first, a multiplexer is then used to select the correct output

    -- INTEGER OPERATIONS --
    addResult <= to_integer(signed(DataA)) + to_integer(signed(DataB));
    subResult <= to_integer(signed(DataA)) - to_integer(signed(DataB));
    multResult <= to_integer(signed(DataA)) * to_integer(signed(DataB));
    divResult	 <= to_integer(signed(DataA)) / to_integer(signed(DataB)) when to_integer(signed(DataB)) /= 0;
    divRemainder <= to_integer(signed(DataA)) mod to_integer(signed(DataB)) when to_integer(signed(DataB)) /= 0;

    -- CONVERSIONS --
    sltOut <= std_logic_vector(to_signed(subResult, 32)); -- MSB gives the output
    multOut <= std_logic_vector(to_signed(multResult, 64));
    divOut <= std_logic_vector(to_signed(divResult, 32));
    divRemainderOut <= std_logic_vector(to_signed(divRemainder, 32));

    -- Output Multiplexer
    with control select
        aluOut <=
            DataA AND DataB                                                             when AND_OP,
            DataA OR  DataB 		                                                    when OR_OP,
            std_logic_vector(to_signed(subResult, 32)) 		                        when SUB_OP,
            std_logic_vector(to_signed(addResult, 32)) 		                        when ADD_OP,
            std_logic_vector(unsigned(sltOut) srl 31) 	                        when SET_LT, -- The MSB is 1 if negative of 0 if positve
            DataA NOR DataB 								                            when NOR_OP,
            DataA XOR DataB 							                                when XOR_OP,
            std_logic_vector(unsigned(DataB) sll to_integer(unsigned(shamt)))	        when SHIFT_LOGICAL_L,
            std_logic_vector(unsigned(DataB) srl to_integer(unsigned(shamt)))	        when SHIFT_LOGICAL_R,
            to_stdlogicvector(to_bitvector(DataA) sra to_integer(unsigned(shamt)))	when SHIFT_R,
            std_logic_vector(to_signed(addResult, 32)) 					            when OTHERS;

    -- Slt Comparaison
    with subResult select
    	IsZero <=
    		'1'                                     when 0,
    		'0'                                     when OTHERS;

    -- High Output
    with control select
    	Hi <=
    		multOut(63 DOWNTO 32)		        when  MULT_OP,
    		divRemainderOut(31 DOWNTO 0)		        when  DIV_OP,
    		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	    when  OTHERS;

    -- Lo Output
    with control select
    	Lo <=
    	    multOut(31 DOWNTO 0) 		        when MULT_OP,
    		divOut				                when DIV_OP,
    		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"	    when OTHERS;

    result <= aluOut;

end Behavior;
