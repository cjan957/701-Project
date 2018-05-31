library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Filtering is
port (

	clk, enable,reset : in std_logic;
	ack : in std_logic;
	
	fifo_read_data_ack: in std_logic;
	fifo_data_ready 	: out std_logic;
	fifo_out_data 		: out std_logic_vector(63 downto 0);
	
	--image_width : in std_logic_vector(10 downto 0);
	--image_height: in std_logic_vector(9 downto 0);
	
	image_chunk : in std_logic_vector(63 downto 0);
	
	image_complete, ready_for_chunk : out std_logic

);
end entity Filtering;


architecture filt_beh of Filtering is


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
	im_width : integer range 5 to 640 := 640;
	im_height : integer range 5 to 480 := 480
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


component pixel_accumulator is
port ( 
	clk, reset, enable 	: in std_logic;
	pixel_in 				: in std_logic_vector(7 downto 0);
	chunk_ready 			: out std_logic;
	chunk_out 				: out std_logic_vector(63 downto 0)
);
end component pixel_accumulator;


component PixelChunkOutFIFO IS
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (63 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (63 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
end component PixelChunkOutFIFO;


component fifo_ctrl_fsm is
	port( 
	
	clk, reset, fifo_empty, fifo_read_ack : in std_logic;
	fifo_rdreq, fifo_data_ready : out std_logic
	
	);
end component fifo_ctrl_fsm;


-------------- Signals --------------

signal shift_en_dist, start_sobel, start_grad, data_done, px_out_grad_rdy, chunk_out_rdy, fifo_empty, fifo_rdreq: std_logic := '0';

signal pix_in, px_in_sob,px_out_gauss,px_out_x, px_out_y ,sobel_out, px_out_grad : std_logic_vector(7 downto 0) := (others => '0');

signal accum_chunk_out : std_logic_vector(63 downto 0) := (others => '0');


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
	G_out => px_out_grad,
	image_done => image_complete,
	pixel_ready => px_out_grad_rdy

);


pix_accum : pixel_accumulator
port map (
	clk => clk,
	reset => reset,
	enable => px_out_grad_rdy,
	pixel_in => px_out_grad,
	chunk_ready => chunk_out_rdy, 
	chunk_out => accum_chunk_out
	
);


fifo : PixelChunkOutFIFO
port map (

	aclr	=> reset,
	clock	=> clk,
	data	=> accum_chunk_out,
	rdreq	=> fifo_rdreq,
	wrreq	=> chunk_out_rdy,
	empty	=> fifo_empty,
	--full	=> ,
	q		=> fifo_out_data
	--usedw	=> 

);

fifo_controller : fifo_ctrl_fsm
port map (
	clk => clk,
	reset => reset,	
	fifo_empty => fifo_empty,
	fifo_read_ack => fifo_read_data_ack,
	fifo_rdreq => fifo_rdreq,
	fifo_data_ready => fifo_data_ready
	
);


end architecture filt_beh;