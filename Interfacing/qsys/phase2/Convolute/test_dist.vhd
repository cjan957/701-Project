library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_dist is
end test_dist;

architecture t_dist of test_dist is


component Distributor is
port (

	clk, enable,reset : in std_logic;
	input_chunk : in std_logic_vector(63 downto 0);
	byte_out : out std_logic_vector(7 downto 0);
	control_shift : out std_logic;
	done : out std_logic

);
end component Distributor;

signal clk_s,enable_s,reset_s : std_logic := '0';
signal chunk : std_logic_vector(63 downto 0) := x"AABBCCDDEEFF1122";
signal b_out : std_logic_vector(7 downto 0) := (others => '0');
signal shift_en, done_s : std_logic;

begin

dist_test : Distributor port map (

	clk => clk_s,
	enable => enable_s,
	reset => reset_s,
	input_chunk => chunk,
	byte_out => b_out,
	control_shift => shift_en,
	done => done_s
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
	
	enable_s <= '1' after 4 ns, '0' after 40 ns;
	reset_s <= '1', '0' after 2 ns, '1' after 50 ns;
	
	wait;
	
end process;

end architecture t_dist;