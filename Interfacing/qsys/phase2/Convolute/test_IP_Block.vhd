library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test_IP_Block is
end entity test_IP_Block;


architecture test_IP of test_IP_Block is


component Filtering is
port (

	clk, enable,reset : in std_logic;
	ack : in std_logic;
	
	fifo_read_data_ack	: in std_logic;
	fifo_data_ready 	: out std_logic;
	fifo_out_data 		: out std_logic_vector(63 downto 0);
	
	--image_width : in std_logic_vector(10 downto 0);
	--image_height: in std_logic_vector(9 downto 0);
	
	image_chunk : in std_logic_vector(63 downto 0);
	
	image_complete, ready_for_chunk : out std_logic
	
);
end component Filtering;


signal clk_s, enable_s, reset_s, ready_s, reset_dist_s, fifo_read_data_ack_s, fifo_data_ready_s : std_logic := '0';

signal image_chunk_s, fifo_out_data_s  : std_logic_vector(63 downto 0) := (others => '0');

signal im_width : std_logic_vector(10 downto 0) := (others => '0');
signal im_height : std_logic_vector(9 downto 0) := (others => '0');

signal im_comp_s : std_logic := '0';


begin

	filt : Filtering 
	port map (
	
	clk => clk_s,
	enable => enable_s,
	reset => reset_s,
	ack => reset_dist_s,
	image_chunk => image_chunk_s,
	fifo_read_data_ack => fifo_read_data_ack_s,
	fifo_data_ready => fifo_data_ready_s,
	fifo_out_data => fifo_out_data_s,
	image_complete => im_comp_s,
	ready_for_chunk => ready_s
	
	);


	timing : process
	begin
	
		wait for 2 ns;
		clk_s <= '1';
		wait for 2 ns;
		clk_s <= '0';

	end process;
	
	data : process
	begin
	
	enable_s <= '0', '1' after 4 ns, '0' after 40 ns,
	'1' after 46 ns, '0' after 84 ns,
	'1' after 88 ns, '0' after 124 ns,
	'1' after 130 ns, '0' after 132 ns;
			
	image_chunk_s <= 
					x"0000FF000000FFFF" after 4 ns,
					x"00000000FF000000" after 46 ns,
					x"00FF0000FFFFFFFF" after 88 ns,
					x"FF00000000000000" after 130 ns;
					
	reset_dist_s <= '1', '0' after 2 ns,
	'1' after 42 ns, '0' after 43 ns,
	'1' after 82 ns, '0' after 83 ns,
	'1' after 125 ns, '0' after 126 ns;
	--,'1' after 134 ns, '0' after 135 ns;
		

	reset_s <= '1', '0' after 2 ns;
	
	fifo_read_data_ack_s <= '0', 
	'1' after 302 ns, '0' after 310 ns,
	'1' after 330 ns, '0' after 338 ns,
	'1' after 350 ns, '0' after 366 ns;
	
	wait;
	
	end process;
	

end architecture test_IP;