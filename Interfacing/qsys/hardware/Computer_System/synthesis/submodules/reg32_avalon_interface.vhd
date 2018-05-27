LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg32_avalon_interface IS
PORT ( clock, resetn : IN STD_LOGIC;
		readn, writen : IN STD_LOGIC;
		writedata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		readdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
		);
END reg32_avalon_interface;

ARCHITECTURE Structure OF reg32_avalon_interface IS

SIGNAL to_reg, from_reg : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN
process(clock)
BEGIN
	if (rising_edge(clock)) then
		if (writen = '1') then
			to_reg <= writedata;
		elsif (readn = '1') then
			readdata <= to_reg;
		else
			to_reg <= x"0000000000000001";
			readdata <= x"0000000000000001";
		end if;
	end if;
end process;
--reg_instance: reg32 PORT MAP (
--clock,
--resetn,
--to_reg,
--local_byteenable,
--from_reg);
END Structure;
