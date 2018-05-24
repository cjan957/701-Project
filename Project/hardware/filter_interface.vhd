library ieee;
use ieee.std_logic_1164.all;

entity filter_interface is
port(	clk,resetn 					: in std_logic;
		
		read_image_chunk			: in std_logic; --unused
		write_image_chunk			: in std_logic;
		readdata_image_chunk		: out std_logic_vector(63 downto 0); --unused
		writedata_image_chunk	: in std_logic_vector(63 downto 0);

		write_control				: in std_logic;
		read_control				: in std_logic;
		writedata_control			: in std_logic_vector(7 downto 0);
		readdata_control			: out std_logic_vector(7 downto 0);
		
		write_status				: in std_logic; --unused
		read_status					: in std_logic;
		writedata_status			: in std_logic_vector(7 downto 0); --unsed
		readdata_status			: out std_logic_vector(7 downto 0);
		
		read_final_pix_out		: in std_logic;
		write_final_pix_out		: in std_logic;	--unused
		writedata_final_pix_out	: in std_logic_vector(7 downto 0); --unused
		readdata_final_pix_out	: out std_logic_vector(7 downto 0)

);

end entity;

architecture structure of filter_interface is

	signal image_chunk_r		: std_logic_vector(63 downto 0) :=  (others => '0');
	
	signal status_r			: std_logic_vector(7 downto 0)  := (others => '0');
	signal control_r 			: std_logic_vector(7 downto 0)  := (others => '0');
	
	signal final_pix_out_r	: std_logic_vector(7 downto 0)  := (others => '0');
	
	component filtering is
	port(
		
		clk, enable,reset : in std_logic;
		ack 					: in std_logic;
		
		image_chunk 		: in std_logic_vector(63 downto 0);
	
		final_pixel_out 	: out std_logic_vector(7 downto 0);
	
		image_complete, ready_for_chunk, px_ready : out std_logic
	);
	end component;
	
	begin
	
		with(write_image_chunk) select
			image_chunk_r	<= writedata_image_chunk when '1', (others => '0') when others;
		with(write_control) select
			image_chunk_r	<= writedata_image_chunk when '1', (others => '0') when others;
			
		filter_inst : filtering
		port map(
			clk => clk,
			enable => control_r(7),
			reset => control_r(0),
			
			ack	=> control_r(5),
			
			image_chunk	=> image_chunk_r,
			final_pixel_out => final_pix_out_r,
			
			image_complete => status_r(7),
			ready_for_chunk => status_r(5),
			px_ready => status_r(3)
		);
		
		
		with(read_control) select
				readdata_control <= control_r when '1', (others => '0') when others;
		with(read_status) select
				readdata_status <= status_r when '1', (others => '0') when others;
		with(read_final_pix_out) select
				readdata_final_pix_out <= final_pix_out_r when '1', (others => '0') when others;
			
		
end structure;
			
			
			
		
		
		