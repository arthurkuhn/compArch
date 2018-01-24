LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behaviour OF fsm_tb IS

COMPONENT comments_fsm IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;
CONSTANT SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
CONSTANT STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
CONSTANT NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

BEGIN
dut: comments_fsm
PORT MAP(clk, s_reset, s_input, s_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS clk_process;
 
--TODO: Thoroughly test your FSM
stim_process: PROCESS
BEGIN 
	s_reset <= '1';
	WAIT FOR 1 * clk_period;
	s_reset <= '0';   
	REPORT "Example case, reading a meaningless character";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";


	REPORT "One line comment";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "At the first slash, should be 0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "After two slashes its the start of a comment but should still be 0" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Should stay high during comments" SEVERITY ERROR;
	s_input <= "01011101";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Should stay high during comments" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Should stay high after terminating character" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";

	REPORT "Fake start of comment";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "At the first slash, should be 0'" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Not a comment" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Still not a comment" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Now it is, should still be 0" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Should stay high after terminating character" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";

	REPORT "Multi-Line comment";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "At the first slash, should be 0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Start of comment (still 0)" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Still a comment" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Commment" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Will it be the end?" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "No" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Commment" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT " Still Commment" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";

	REPORT "All edges tested";
	WAIT;
END PROCESS stim_process;

END behaviour;