library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity comments_fsm is
port (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
end comments_fsm;

architecture behavioral of comments_fsm is

-- The ASCII value for the '/', '*' and end-of-line characters
constant SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
constant STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
constant NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

type state_type is (s0, s1, s2pre, s2, s3pre, s3, s4, s5);
signal current_s, next_s: state_type;

begin

-- Insert your processes here
process (clk, reset)
begin
  if (reset = '1') then
    current_s <= s0;
  elsif (rising_edge(clk)) then
    current_s <= next_s;
  end if;
end process;


--state machine process.
process (current_s,input)
begin
  case current_s is
    when s0 =>        --when current state is "s0"
      if(input = SLASH_CHARACTER) then
        output <= '0';
        next_s <= s1;
      else
        output <= '0';
        next_s <= s0;
      end if;   

    when s1 =>        --when current state is "s1"
      if(input = SLASH_CHARACTER) then
        output <= '0';
        next_s <= s2pre;
      elsif (input = STAR_CHARACTER) then
        output <= '0';
        next_s <= s3pre;
      else
        output <= '0';
        next_s <= s0;
      end if;

    when s2pre =>       --when current state is "s2"
      if(input = NEW_LINE_CHARACTER) then
        output <= '0';
        next_s <= s5;
      else
        output <= '0';
        next_s <= s2;
    end if;

    when s2 =>       --when current state is "s2"
      if(input = NEW_LINE_CHARACTER) then
        output <= '1';
        next_s <= s5;
      else
        output <= '1';
        next_s <= s2;
    end if;

  when s3pre =>         --when current state is "s3"
      if(input = STAR_CHARACTER) then
        output <= '0';
        next_s <= s4;
      else
        output <= '0';
        next_s <= s3;
      end if;
    
    when s3 =>         --when current state is "s3"
      if(input = STAR_CHARACTER) then
        output <= '1';
        next_s <= s4;
      else
        output <= '1';
        next_s <= s3;
      end if;

    when s4 =>         --when current state is "s4"
      if(input = SLASH_CHARACTER) then
        output <= '1';
        next_s <= s5;
      else
        output <= '1';
        next_s <= s3;
      end if;

    when s5 =>         --when current state is "s5"
      output <= '1';
      next_s <= s0;

  end case;
end process;



end behavioral;