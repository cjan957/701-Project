library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test_system is
end entity test_system;


architecture test_sys of test_system is


component conv_sys is 
port (

	clk,enable,reset: in std_logic;
	pixel_in : in std_logic_vector(7 downto 0);
	
	--sel_output : in std_logic;
	
	shift_en : in std_logic;
			
	image_width : in std_logic_vector(10 downto 0);
	image_height: in std_logic_vector(9 downto 0);
		
	kern_sel : in std_logic_vector(2 downto 0);
	
	pixel_out : out std_logic_vector(7 downto 0);
	
	data_ready : out std_logic
);
end component conv_sys;


component Gradient is
port (

	clk, enable : in std_logic;
	conv_X : in std_logic_vector(7 downto 0);
	conv_Y : in std_logic_vector(7 downto 0);
	
	G_out :  out std_logic_vector(7 downto 0)

);
end component Gradient;






signal clk_s,enable_s, reset_s, shift_en_s, start_sobel, start_grad : std_logic := '0';

signal pix_in, px_in_sob,px_out,px_out_x, px_out_y ,sobel_out, calc_pixel : std_logic_vector(7 downto 0) := (others => '0');

signal im_width : std_logic_vector(10 downto 0) := (others => '0');
signal im_height : std_logic_vector(9 downto 0) := (others => '0');




begin

gaussian : conv_sys 
port map(

	clk => clk_s,
	enable => enable_s,
	shift_en => shift_en_s,
	reset => reset_s,
	pixel_in => pix_in,
	image_width => im_width,
	image_height => im_height,
	kern_sel => "001",
	pixel_out => px_out,
	data_ready => start_sobel
);

sobel_x : conv_sys 
port map(

	clk => clk_s,
	enable => start_sobel,
	shift_en => start_sobel,
	reset => reset_s,
	pixel_in => px_out,
	image_width => im_width,
	image_height => im_height,
	kern_sel => "010",
	pixel_out => px_out_x,
	data_ready => start_grad
);

sobel_y : conv_sys 
port map(

	clk => clk_s,
	enable => start_sobel,
	shift_en => start_sobel,
	reset => reset_s,
	pixel_in => px_out,
	image_width => im_width,
	image_height => im_height,
	kern_sel => "011",
	pixel_out => px_out_y
);

grad : gradient
port map (


	clk => clk_s,
	enable => start_grad,
	conv_X => px_out_x,
	conv_Y => px_out_y,
	G_out => calc_pixel

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
	
	enable_s <= '0', '1' after 4 ns, '0' after 112 ns;
	
	shift_en_s <= '0', '1' after 4 ns, '0' after 112 ns;
		
	pix_in <= x"00" after 4 ns, 
					x"00" after 8 ns, 
					x"FF" after 12 ns, 
					x"00" after 16 ns, 
					x"00" after 20 ns, 
					x"00" after 24 ns, 
					x"FF" after 28 ns, 
					x"FF" after 32 ns, 
					x"00" after 36 ns, 
					x"00" after 40 ns, 
					x"00" after 44 ns, 
					x"00" after 48 ns, 
					x"FF" after 52 ns, 
					x"00" after 56 ns, 
					x"00" after 60 ns, 
					x"00" after 64 ns, 
					x"00" after 68 ns, 
					x"FF" after 72 ns, 
					x"00" after 76 ns, 
					x"00" after 80 ns, 
					x"FF" after 84 ns, 
					x"FF" after 88 ns, 
					x"FF" after 92 ns, 
					x"FF" after 96 ns, 
					x"FF" after 100 ns;	
		
	wait;
	
	end process;
	

end architecture test_sys;