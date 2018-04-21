-- Data arbiter for P5 Implementation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY dataArbiter is
GENERIC(
	ram_size : INTEGER := 8192
);
PORT(
	-- Avalon interface --
	sAddrData : in std_logic_vector (31 downto 0);
	sReadData : in std_logic;
	sReaddataData : out std_logic_vector (31 downto 0);
	sWriteData : in std_logic;
	sWritedataData : in std_logic_vector (31 downto 0);
	sWaitrequestData : out std_logic:= '1';
	
	sAddrInstruct : in std_logic_vector (31 downto 0);
	sReadInstruct : in std_logic;
	sReaddataInstruct : out std_logic_vector (31 downto 0);
	sWriteInstruct : in std_logic;
	sWritedataInstruct : in std_logic_vector (31 downto 0);
	sWaitrequestInstruct : out std_logic:='1';

	mAddr : out std_logic_vector (31 downto 0);
	mRead : out std_logic;
	mReaddata : in std_logic_vector (31 downto 0);
	mWrite : out std_logic;
	mWritedata : out std_logic_vector (31 downto 0);
	mWaitrequest : in std_logic;
	
	controlOut : out std_logic
	
);
END dataArbiter;

ARCHITECTURE arch_arbiter of arbiter is

	signal control: std_logic := '1';
	signal inUse: std_logic := '1';
begin
	
	controlOut <= control;
	
process (mWaitrequest)
begin
	if inUse = '1' then
		if control <= '0' then
			sWaitrequestData <= mWaitrequest;
			sWaitrequestInstruct <= '1';
		elsif control <= '1' then
			sWaitrequestInstruct <= mWaitrequest;
			sWaitrequestData <= '1';
		end if;
	end if;
end process;

process (sWriteData, sWriteInstruct, sReadData, sReadInstruct, mWaitrequest)

begin
	if mWaitrequest = '1' and inUse = '0' then
		if sWriteData = '1' or sReadData = '1' then
			control <= '0';
			inUse <= '1';
		elsif sWritInstruct = '1' or sReadInstruct = '1' then
			control <= '1';
			inUse <= '1';
		end if;
	end if;
	
	if mWaitrequest'event and mWaitrequest = '1' then
		if (sWriteData = '1' or sReadData = '1') and control = '1' then
			control <= '0';
			inUse <= '1';
		elsif (sWriteInstruct = '1' or sReadInstruct = '1')and control = '0' then
			control <= '1';
			inUse <= '1';
		else
			inUse <= '0';
		end if;
	end if;
		
end process;

process (sWriteData, sWriteInstruct, sReadData, sReadInstruct, inUse, control, mWaitrequest)
begin
	if inUse = '1' then
		if control = '0' then
			mWrite <= sWriteData;
			mRead <= sReadData;
			mAddr <= std_logic_vector(to_unsigned(to_integer(unsigned(sAddrData)) +1024, mAddr'length)); --+1024
			sReaddataData <= mReaddata;
			mWritedata <= sWritedataData;
		elsif control = '1' then
			mWrite <= sWriteInstruct;
			mRead <= sReadInstruct;
			--mAddr <= "00" & sAddrInstruct(31 downto 2); --/4
			mAddr <=  sAddrInstruct;
			sReaddataInstruct <= mReaddata;
			mWritedata <= sWritedataInstruct;
		end if;
	end if;
	
	if mWaitrequest'event and mWaitrequest = '1' then
		mRead <= '0';
		mWrite <= '0';
	end if;
	
end process;


end arch_arbiter;
