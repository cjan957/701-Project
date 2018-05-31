library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_pixel_accumulator is
end test_pixel_accumulator;

architecture beh of test_pixel_accumulator is


component pixel_accumulator is
port ( 
	clk, reset, enable 	: in std_logic;
	pixel_in 				: in std_logic_vector(7 downto 0);
	chunk_ready 			: out std_logic;
	chunk_out 				: out std_logic_vector(63 downto 0)
);
end component pixel_accumulator;

signal clk_s, enable_s, reset_s : std_logic := '0';
signal chunk_out_s : std_logic_vector(63 downto 0) := (others => '0');
signal pixel_in_s : std_logic_vector(7 downto 0) := (others => '0');
signal chunk_ready_s : std_logic;

begin

DUT : pixel_accumulator port map (
	clk => clk_s,
	reset => reset_s,
	enable => enable_s,
	pixel_in => pixel_in_s,
	chunk_ready => chunk_ready_s,
	chunk_out => chunk_out_s
);



clk_gen : process
begin
	
		wait for 2 ns;
		clk_s <= '1';
		wait for 2 ns;
		clk_s <= '0';

end process clk_gen;

data : process
begin
	
	enable_s <= '1' after 6 ns, '0' after 38 ns;
	reset_s <= '1', '0' after 2 ns, '1' after 50 ns;
	pixel_in_s <= 
		x"01" after 6 ns, 
		x"02" after 10 ns,
		x"03" after 14 ns,
		x"04" after 18 ns,
		x"05" after 22 ns,
		x"06" after 26 ns,
		x"07" after 30 ns,
		x"08" after 34 ns;	
	
	wait;
	
end process;

end architecture beh;