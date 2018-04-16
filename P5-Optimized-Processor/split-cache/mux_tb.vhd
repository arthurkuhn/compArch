LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY mux_tb IS
END mux_tb;

architecture mux_tb_arch of mux_tb is

component mux is 
port(clk : in std_logic;
	 input0 : in std_logic_vector(31 downto 0);
	 input1 : in std_logic_vector(31 downto 0);
	 select_in : in std_logic;
	 select_out : out std_logic_vector(31 downto 0)
	 );
end component;

    --Clock_Period Constant
	constant clk_period : time := 1 ns;

    --SIGNALS
	signal clk : std_logic := '0';
	signal mux_val1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal mux_val2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal mux_select : STD_LOGIC;
	
	signal mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
begin

muxFetch : mux 
	port map(
	 clk => clk,
	 input2 => mux_val2,
	 input1 => mux_val1,
	 select_in => mux_select,
	 select_out => mux_out
);

clkProc : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
end process;

testProc : process
    BEGIN
        wait for clk_period;
        report "SIMULATION IS STARTING \n";
		mux_val1 <= "11111111111111111111111111111111";
		mux_val2 <= "00000000000000000000000000000000";
		
		mux_select <= '1';
        
		wait for clk_period;
        
		mux_select <= '0';
        
		wait;
		
end process;

end mux_tb_arch;