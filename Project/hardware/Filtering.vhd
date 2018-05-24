library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filtering is
port (

	clk, enable,reset : in std_logic;
	ack : in std_logic;
	
	--image_width : in std_logic_vector(10 downto 0);
	--image_height: in std_logic_vector(9 downto 0);
	
	image_chunk : in std_logic_vector(63 downto 0);
	
	final_pixel_out : out std_logic_vector(7 downto 0);
	
	image_complete, ready_for_chunk, px_ready : out std_logic

);
end entity Filtering;


architecture filt_beh of Filtering  is


-------------- Component Declarations --------------
component Distributor is
port (


	clk, enable,reset : in std_logic;
	input_chunk : in std_logic_vector(63 downto 0);
	byte_out : out std_logic_vector(7 downto 0);
	control_shift : out std_logic;
	done : out std_logic

);
end component Distributor;


component conv_sys is 
port (
	clk,enable,reset : in std_logic;
	
	kern_sel : in std_logic_vector(2 downto 0);
	
	-- Remove for later (?)
	--image_width : in std_logic_vector(10 downto 0);
	--image_height: in std_logic_vector(9 downto 0);
	
	pixel_in : in std_logic_vector(7 downto 0);
		
	pixel_out : out std_logic_vector(7 downto 0);
	
	data_ready : out std_logic
);
end component conv_sys;


component Gradient is
generic(
	im_width : integer range 5 to 640 := 5;
	im_height : integer range 5 to 480 := 5
);
port (

	clk, enable, reset : in std_logic;
	conv_X : in std_logic_vector(7 downto 0);
	conv_Y : in std_logic_vector(7 downto 0);
	
	G_out :  out std_logic_vector(7 downto 0);
	pixel_ready : out std_logic;
	image_done  : out std_logic

);
end component Gradient;




-------------- Signals --------------

signal shift_en_dist, start_sobel, start_grad, data_done : std_logic := '0';

signal pix_in, px_in_sob,px_out_gauss,px_out_x, px_out_y ,sobel_out : std_logic_vector(7 downto 0) := (others => '0');


begin

dist : Distributor
port map(

	clk => clk,
	enable => enable,
	reset => ack,
	input_chunk => image_chunk,
	byte_out => pix_in,
	control_shift => shift_en_dist,
	done => ready_for_chunk
);


gaussian : conv_sys 
port map(

	clk => clk,
	enable => shift_en_dist,
	reset => reset,
	pixel_in => pix_in,
	kern_sel => "001",
	pixel_out => px_out_gauss,
	data_ready => start_sobel
	
);

sobel_x : conv_sys 
port map(

	clk => clk,
	enable => start_sobel,
	reset => reset,
	pixel_in => px_out_gauss,
	kern_sel => "010",
	pixel_out => px_out_x,
	data_ready => start_grad
);

sobel_y : conv_sys 
port map(

	clk => clk,
	enable => start_sobel,
	reset => reset,
	pixel_in => px_out_gauss,
	kern_sel => "011",
	pixel_out => px_out_y
);


grad : gradient
port map (


	clk => clk,
	enable => start_grad,
	reset => reset,
	conv_X => px_out_x,
	conv_Y => px_out_y,
	G_out => final_pixel_out,
	image_done => image_complete,
	pixel_ready => px_ready

);


end architecture filt_beh;