library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY alu is
PORT (in_A : in STD_LOGIC_VECTOR (31 downto 0);
 in_B : in STD_LOGIC_VECTOR (31 downto 0);
 SEL : in STD_LOGIC_VECTOR (4 downto 0);
 alu_out : out STD_LOGIC_VECTOR(31 downto 0));
end alu;
 
architecture alu_arch of alu is

signal HILO_buf: std_logic_vector(63 downto 0);

begin
process(in_A, in_B, SEL)
begin
case SEL is
 
 when "00000" =>
 alu_out<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)), alu_out'length)) ; --ADD
 
 when "00001" => 
 alu_out<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) -   to_integer (unsigned(in_B)), alu_out'length)); --SUB
 
 when "00010" => 
  alu_out<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)), alu_out'length)) ; --ADDI
 
 when "00011" => 
 HILO_buf<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) *   to_integer (unsigned(in_B)), HILO_buf'length)); --MULT
 
 when "00100" =>
 HILO_buf (31 downto 0) <= std_logic_vector((signed(in_A)/signed(in_B)));   --DIV
 HILO_buf (63 downto 32) <= std_logic_vector((signed(in_A) mod signed(in_B)));

 when "00101" =>  
 if (unsigned(in_A) < unsigned(in_B)) then  --SLT
	alu_out <= x"00000001";
	else
	alu_out <= x"00000000";
 end if;
 
 when "00110" => 
  if (unsigned(in_A) < unsigned(in_B)) then  --SLTI
	alu_out <= x"00000001";
	else
	alu_out <= x"00000000";
 end if;
 
 when "00111" => 
 alu_out<= in_A and in_B; --AND

 when "01000" =>
 alu_out<= in_A or in_B; --OR

 when "01001" => 
 alu_out<= in_A nor in_B; --NOR
 
 when "01010" =>
 alu_out<= in_A xor in_B; --XOR

 when "01011" =>
 alu_out<= in_A and in_B; --ANDI
 
 when "01100" =>
 alu_out<= in_A or in_B; --ORI

 when "01101" => 
 alu_out<= in_A xor in_B; --xORI
 
 when "01110" => --MOVE FROM HIGH
 alu_out<= hi;

 when "01111" => -- MOVE FROM LOW
 alu_out<= lo;
 
 when "10000" => -- LUI
	alu_out <= in_B (15 downto 0)  & std_logic_vector(to_unsigned(0, 16));
 
 when "10001" => --sll
	alu_out <= in_A ((31 - to_integer(unsigned(in_B(10 downto 6)))) downto 0)  & std_logic_vector(to_unsigned(0, to_integer(unsigned(input_b(10 downto 6)))));

 
 when "10010" => --srl
	alu_out <= std_logic_vector(to_unsigned(0, to_integer(unsigned(in_B(10 downto 6))))) & in_A (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	
 when "10011" => -- sra
	if in_A(31) = '0' then
		alu_out <= std_logic_vector(to_unsigned(0, to_integer(unsigned(in_B(10 downto 6))))) & in_A (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	else
		alu_out <= std_logic_vector(to_unsigned(1, to_integer(unsigned(in_B(10 downto 6))))) & in_A (31 downto (0 + to_integer(unsigned(input_b(10 downto 6)))));
	end if;	
 
 when "10100" => -- lw
 alu_out<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)), alu_out'length)) ;
 when "10101" => -- sw
	alu_out<= std_logic_vector(to_unsigned(to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)), alu_out'length)) ;
 
 when "10110" => -- beq
 alu_out<= std_logic_vector(to_unsigned((to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)) * 4), alu_out'length));
 
 when "10111" => -- bne
 alu_out<= std_logic_vector(to_unsigned((to_integer (unsigned(in_A)) +   to_integer (unsigned(in_B)) * 4), alu_out'length));
 
 when "11000" => -- j ASSUME input b is lower 26 bits 0 padded
	alu_out<= in_A(31 downto 28) & in_B(25 downto 0) & "00";
 when "11001" => -- jr
	alu_out <= in_A;
 when "11010" => -- jal
	alu_out<= in_A(31 downto 28) & in_B(25 downto 0) & "00";
 when others =>
  NULL;
end case; 
  
end process; 
 
end alu_arch;