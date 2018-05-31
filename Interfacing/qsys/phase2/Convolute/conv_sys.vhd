library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity conv_sys is 
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
end entity conv_sys;

architecture beh_conv of conv_sys is


component Conv_FSM is
port (

	clk,enable,reset 			: in std_logic;
	first_pixels_done			: in std_logic;
	conv_ready 					: in std_logic;
	last_pixels 				: in std_logic;
	image_done 					: in std_logic;
	
	cnt_en						: out std_logic;
	conv_en						: out std_logic;
	edge_en						: out std_logic;
	
	sel_out						: out std_logic
);
end component Conv_FSM;


component Buffer_Module is
port (

	clk, reset: in std_logic;
	shift_enable : in std_logic;
	data_in : in std_logic_vector(7 downto 0);
	
	px1, px2, px3, px4, px5, px6, px7, px8, px9 : out std_logic_vector(7 downto 0)
	
);
end component Buffer_Module;


component Convolution is 
port (

	clk, enable : in std_logic;
	kernel : in std_logic_vector(2 downto 0);
	input1,input2,input3,input4,input5,input6,input7,input8,input9 : in std_logic_vector(7 downto 0);
	conv_result : out std_logic_vector(7 downto 0);
	conv_done : out std_logic	
);
end component Convolution;


component pixel_counter is
generic (

	image_width : integer range 5 to 640 := 640;
	image_height : integer range 5 to 480 := 480

);
port (

	clk, cnt_en, reset : in std_logic;
	first_pixels_done : out std_logic;
	conv_ready : out std_logic;
	last_pixels : out std_logic

);
end component pixel_counter;

component pixel_out_counter is
generic(
	image_width : integer range 5 to 640 := 640;
	image_height : integer range 5 to 480 := 480
);
port (
clk, reset, enable : in std_logic;
count_done : out std_logic
);
end component pixel_out_counter;


-- Pixel Signals
signal p1, p2, p3, p4, p5, p6, p7, p8, p9, pixel_out_temp : std_logic_vector(7 downto 0) := (others => '0');

-- FSM signals
signal cnt_en_s, conv_en_s, edge_en_s, image_done_s, conv_done_s, data_ready_s, select_output, first_pixels: std_logic := '0';

signal conv_ready_s, last_pixels_s : std_logic := '0';

begin


FSM : Conv_FSM
port map (

	clk => clk,
	enable => enable,
	reset => reset,
	
	first_pixels_done	=>	first_pixels,	
	conv_ready => conv_ready_s,					
	last_pixels => last_pixels_s,			
	image_done 	=> image_done_s,				
	
	cnt_en => cnt_en_s,						
	conv_en => conv_en_s,	
	edge_en => edge_en_s,					
	
	sel_out	=> select_output					

);


buff : Buffer_Module
port map (

	clk => clk,
	shift_enable => enable,
	reset => reset,
	data_in => pixel_in,
	
	px1 => p1,
	px2 => p2,
	px3 => p3,
	px4 => p4,
	px5 => p5,
	px6 => p6,
	px7 => p7,
	px8 => p8,
	px9 => p9	

);

conv : Convolution
port map (

	clk => clk,
	enable => conv_en_s,	
	kernel => kern_sel,	
	input1 => p1,
	input2 => p2,
	input3 => p3,
	input4 => p4,
	input5 => p5,
	input6 => p6,
	input7 => p7,
	input8 => p8,
	input9 => p9,
	
	conv_result => pixel_out_temp,
	
	conv_done => conv_done_s

);

px_count : pixel_counter
port map (


	clk => clk,
	cnt_en => cnt_en_s, 
	reset => reset,
	
	first_pixels_done => first_pixels,
	conv_ready => conv_ready_s,
	last_pixels => last_pixels_s

);

px_count_out : pixel_out_counter
port map (

	clk => clk,
	reset => reset,
	enable => data_ready_s,
	count_done => image_done_s
	
);


-- The pixel output will either be the calculated value or 0 depending on the FSM 
pixel_out <= pixel_out_temp  when select_output = '1' else (others => '0');
data_ready_s <= conv_done_s when select_output = '1' else edge_en_s;

--conv_done_s when conv_done_s = '1' else edge_en_s when select_output = '0';

data_ready <= data_ready_s;

end architecture beh_conv;