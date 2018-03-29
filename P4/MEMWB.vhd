LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MEMWB IS
		PORT
		(
			clock			:	IN STD_LOGIC;

			-- Inputs
			-- For WB
			inp_RegWrite		:	IN STD_LOGIC;		
			inp_MemToReg		:	IN STD_LOGIC;

			-- For ALU
			inp_zero			: 	IN STD_LOGIC;
			inp_result			:	IN STD_LOGIC_VECTOR(31 downto 0);
			inp_HIGH			:	IN STD_LOGIC_VECTOR(31 downto 0);
			inp_LOW				:	IN STD_LOGIC_VECTOR(31 downto 0);

			-- For Data Memory
			inp_wr_done			:	IN STD_LOGIC;
			inp_rd_ready		:	IN STD_LOGIC;
			inp_data			:	IN STD_LOGIC_VECTOR(31 downto 0);

			inp_rd 				:	IN STD_LOGIC_VECTOR(4 downto 0);

			--Outputs
			-- For WB
			out_RegWrite		:	OUT STD_LOGIC;
			out_MemToReg		:	OUT STD_LOGIC;

			-- For ALU
			out_zero			: 	OUT STD_LOGIC;
			out_result			:	OUT STD_LOGIC_VECTOR(31 downto 0);
			out_HIGH			: 	OUT STD_LOGIC_VECTOR(31 downto 0);
			out_LOW				:	OUT STD_LOGIC_VECTOR(31 downto 0);
			
			--For Data Mem
			out_wr_done			: 	OUT STD_LOGIC;
			out_rd_ready		:	OUT STD_LOGIC;
			out_data			:	OUT STD_LOGIC_VECTOR(31 downto 0);

			out_rd 				: 	OUT STD_LOGIC_VECTOR(4 downto 0);

		);
END MEMWB;

ARCHITECTURE ARCH OF MEMWB IS

-- For WB
signal tmp_RegWrite		:	STD_LOGIC;
signal tmp_MemToReg		: 	STD_LOGIC;

--For Data Memory
signal tmp_wr_done		:	STD_LOGIC;
signal tmp_rd_ready		:	STD_LOGIC;
signal tmp_data			: 	STD_LOGIC_VECTOR(31 downto 0);

--For ALU
signal tmp_zero			:	STD_LOGIC;
signal tmp_result		: 	STD_LOGIC_VECTOR(31 downto 0);
signal tmp_HIGH			:	STD_LOGIC_VECTOR(31 downto 0);
signal tmp_LOW			:	STD_LOGIC_VECTOR(31 downto 0);

signal tmp_rd 			:	STD_LOGIC_VECTOR(4 downto 0);

BEGIN
	-- WB
	tmp_RegWrite <=	inp_RegWrite;
	tmp_MemToReg <=	inp_MemToReg;

	-- ALU
	tmp_zero <=	inp_zero;
	tmp_result <= inp_result;
	tmp_HIGH <= inp_HIGH;
	tmp_LOW <= inp_LOW;

	-- Data Memory
	tmp_wr_done <= inp_wr_done;
	tmp_rd_ready <= inp_rd_ready;

	tmp_rd <= inp_rd;


data_buffer: process(inp_data)
begin
	if(inp_data /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then
		tmp_data <= inp_data;
	end if;
end process;

IDIF: process(clock)
begin 
	if(clock'event AND clock = '1') then
		--WB
		out_RegWrite <= tmp_RegWrite;
		out_MemToReg <= tmp_MemToReg;

		--ALU
		out_zero <= tmp_zero;
		out_result <= tmp_result;
		out_HIGH <= tmp_HIGH;
		out_LOW <= tmp_LOW;

		--Data Memory
		out_wr_done <= tmp_wr_done;
		out_rd_ready <= tmp_rd_ready;
		out_data <= tmp_data;

		out_rd <= tmp_rd;

	end if;
end process;

END ARCH;
