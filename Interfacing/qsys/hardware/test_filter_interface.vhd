library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_filter_interface is
end entity test_filter_interface;


architecture test_shift of test_filter_interface is


component Filter_interface is
PORT ( 

		clock, resetn : IN STD_LOGIC;

		-- Heavyweight 
		readn_hw, writen_hw 	: IN STD_LOGIC;
		writedata_hw 			: IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		readdata_hw 			: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		
		-- Lightweight
		readn_lw, writen_lw : in std_logic;
		writedata_lw 		  : in std_logic_vector(31 downto 0);
		readdata_lw			  : out std_logic_vector(31 downto 0)
		
		);
end component Filter_interface;


signal t_clk, resetn_s: std_logic := '0';
signal readn_hw_s, writen_hw_s, readn_lw_s, writen_lw_s : std_logic := '0';
signal writedata_hw_s, readdata_hw_s : std_logic_vector(63 downto 0) := (others => '0');
signal writedata_lw_s, readdata_lw_s : std_logic_vector(31 downto 0) := (others => '0');
 

begin

DUT : filter_interface port map(
	clock => t_clk,
	resetn => resetn_s,

	-- Heavyweight 
	readn_hw => readn_hw_s,
	writen_hw => writen_hw_s,
	writedata_hw => writedata_hw_s,
	readdata_hw => readdata_hw_s,
	
	-- Lightweight
	readn_lw => readn_lw_s,
	writen_lw => writen_lw_s,
	writedata_lw => writedata_lw_s,  
	readdata_lw	=> readdata_lw_s
);

	data : process
	begin
	
		resetn_s <= '0';
		
		readn_hw_s <= '0', '1' after 26 ns;
		writen_hw_s <= '0', '1' after 3 ns, '0' after 7 ns;
		writedata_hw_s <= x"0000000000000000", x"FFFFFFFFFFFFFFFF" after 3 ns, x"0000000000000000" after 7 ns;
		
		
		readn_lw_s <= '0';
		writen_lw_s <= '0', '1' after 10 ns, '0' after 13 ns, '1' after 18 ns, '0' after 23 ns;
		writedata_lw_s <= x"00000000", x"00000001" after 10 ns, x"00000000" after 13 ns, x"00000004" after 18 ns, x"00000000" after 23 ns;
		
		
	wait;
	
	end process;


	clk_gen : process
	begin
		wait for 2 ns;
		t_clk <= '0';
		wait for 2 ns;
		t_clk <= '1';
	end process;

end architecture test_shift;