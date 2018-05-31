LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg32_avalon_interface IS
PORT ( clock, resetn : IN STD_LOGIC;

		readn_hw, writen_hw : IN STD_LOGIC;
		writedata_hw : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		readdata_hw : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		
		
		readn_lw, writen_lw : in std_logic;
		writedata_lw 		  : in std_logic_vector(31 downto 0);
		readdata_lw			  : out std_logic_vector(31 downto 0)
		
		);
END reg32_avalon_interface;

ARCHITECTURE Structure OF reg32_avalon_interface IS

SIGNAL reg_hw : STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL reg_lw : std_logic_vector(31 downto 0);

signal reg_out_hw	: std_logic_vector(63 downto 0);
signal reg_out_lw : std_logic_vector(31 downto 0);

signal control_sig : std_logic_vector(7 downto 0);
signal status_sig : std_logic_vector(7 downto 0);


BEGIN
hw: process(clock)
BEGIN
	if (rising_edge(clock)) then
		if (writen_hw = '1') then
			reg_hw <= writedata_hw;
		elsif (readn_hw = '1') then
			readdata_hw <= reg_out_hw; 
		end if;
	end if;
end process hw;


lw : process(clock)
BEGIN
	if (rising_edge(clock)) then
		if (writen_lw = '1') then
			reg_lw <= writedata_lw;
		elsif (readn_lw = '1') then
			readdata_lw <= reg_out_lw;
		end if;
	end if;
end process lw;


status_sig <= reg_hw(7 downto 0) when reg_lw(2 downto 0) = "000";
control_sig 	<= reg_hw(7 downto 0) when reg_lw(2 downto 0) = "001";


reg_out_hw <= x"0000000000000000" & status_sig when reg_lw(2 downto 0) = "000" else
				x"0000000000000000" & control_sig when reg_lw(2 downto 0) = "001";
		

END Structure;
