-- Arthur Kuhn
-- 260565829

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behaviour OF pipeline_tb IS

COMPONENT pipeline IS
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk: STD_LOGIC := '0';
SIGNAL s_a, s_b, s_c, s_d, s_e : INTEGER := 0;
SIGNAL s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output : INTEGER := 0;

CONSTANT clk_period : time := 1 ns;

BEGIN
dut: pipeline
PORT MAP(clk, s_a, s_b, s_c, s_d, s_e, s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '1';
	WAIT FOR clk_period/2;
	clk <= '0';
	WAIT FOR clk_period/2;
END PROCESS;
 

stim_process: PROCESS
BEGIN   
	-- Here, we test the different stages of the life of the pipeline: as it fills, when full and as it empties.
	-- All results are asserted below. Delays of half a clock cycle are added to ensure that the signal is not 
	-- sampled on the clock's rising edge
	REPORT "Starting test";
	s_a <= 1;
	s_b <= 1;
	s_c <= 1;
	s_d <= 1;
	s_e <= 1;
	WAIT FOR 1 * clk_period;
	s_a <= 2;
	s_b <= 2;
	s_c <= 2;
	s_d <= 2;
	s_e <= 2;
	WAIT FOR 0.5 * clk_period;
	ASSERT (s_op1 = 2) REPORT "Op 1 result" SEVERITY ERROR;
	ASSERT (s_op3 = 1) REPORT "Op 3 result" SEVERITY ERROR; 
	ASSERT (s_op4 = 0) REPORT "Op 4 result" SEVERITY ERROR; 
	WAIT FOR 0.5 * clk_period;
	s_a <= 3;
	s_b <= 3;
	s_c <= 3;
	s_d <= 3;
	s_e <= 3;
	WAIT FOR 0.5 * clk_period;
	ASSERT (s_op1 = 4) REPORT "Op 1 resultb" SEVERITY ERROR;
	ASSERT (s_op2 = 84) REPORT "Op 2 result" SEVERITY ERROR;
	ASSERT (s_op3 = 4) REPORT "Op 3 result" SEVERITY ERROR; 
	ASSERT (s_op4 = 0) REPORT "Op 4 result" SEVERITY ERROR; 
	ASSERT (s_op5 = 0) REPORT "Op 5 result" SEVERITY ERROR; 
	ASSERT (s_final_output = 84) REPORT "final_output A" SEVERITY ERROR;
	WAIT FOR 0.5 * clk_period;
	s_a <= 4;
	s_b <= 4;
	s_c <= 4;
	s_d <= 4;
	s_e <= 4;
	WAIT FOR 0.5 * clk_period;
	ASSERT (s_op1 = 6) REPORT "Op 3 resultc" SEVERITY ERROR; 
	ASSERT (s_op2 = 168) REPORT "Op 2 result" SEVERITY ERROR;
	ASSERT (s_op3 = 9) REPORT "Op 3 result" SEVERITY ERROR; 
	ASSERT (s_op4 = 0) REPORT "Op 4 result" SEVERITY ERROR; 
	ASSERT (s_op5 = 0) REPORT "Op 5 result" SEVERITY ERROR;
	ASSERT (s_final_output = 168) REPORT "final_output" SEVERITY ERROR;
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 8) REPORT "Op 1 resultd" SEVERITY ERROR;
	ASSERT (s_op2 = 252) REPORT "Op 2 result" SEVERITY ERROR;
	ASSERT (s_op3 = 16) REPORT "Op 3 result" SEVERITY ERROR; 
	ASSERT (s_op4 = 0) REPORT "Op 4 result" SEVERITY ERROR; 
	ASSERT (s_op5 = 0) REPORT "Op 5 result" SEVERITY ERROR; 
	ASSERT (s_final_output = 252) REPORT "final_output" SEVERITY ERROR;

	REPORT "DONE";    
	WAIT;
END PROCESS stim_process;
END;
