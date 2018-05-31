library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Buffer_Module is
port (

	clk, reset: in std_logic;
	shift_enable : in std_logic;
	data_in : in std_logic_vector(7 downto 0);
	
	px1, px2, px3, px4, px5, px6, px7, px8, px9 : out std_logic_vector(7 downto 0)
		
);
end entity Buffer_Module;

architecture buff of Buffer_Module is


component shift_register is
port (

	clk, enable, reset : in std_logic;
	data_in : in std_logic_vector(7 downto 0);
	tap2, tap1, tap0 : out std_logic_vector(7 downto 0);
	data_out : out std_logic_vector(7 downto 0)

);
end component shift_register;


component generic_shift_reg is

	generic(
		image_width : integer range 5 to 640 := 5;
		kernel_width : integer range 3 to 5 := 3
	);
		
	port(
		clk, reset, enable : in std_logic;
		pixel_in : in std_logic_vector(7 downto 0);
		pixel_out : out std_logic_vector(7 downto 0)
	);

end component generic_shift_reg;


signal bot_to_buff_data, 
		buff_to_mid_data, 
		mid_to_buff_data, 
		buff_to_top_data : std_logic_vector (7 downto 0) := (others => '0');


begin



-- BUFFERS
BOT_TO_MID_BUFF : generic_shift_reg
port map(

	clk => clk,
	reset => reset, 
	enable => shift_enable,
	pixel_in => bot_to_buff_data,
	pixel_out => buff_to_mid_data
);

MID_TO_TOP_BUFF : generic_shift_reg
port map(

	clk => clk,
	reset => reset, 
	enable => shift_enable,
	pixel_in => mid_to_buff_data,
	pixel_out => buff_to_top_data
);



--- SHIFT REGISTERS

bot_register : shift_register 
port map (

	clk => clk, 
	enable => shift_enable,
	reset => reset,
	data_in => data_in,
	tap2 => px7,
	tap1 => px8,
	tap0 => px9,
	data_out => bot_to_buff_data
);

middle_register : shift_register 
port map (

	clk => clk, 
	enable => shift_enable,
	reset => reset,
	data_in => buff_to_mid_data,
	tap2 => px4,
	tap1 => px5,
	tap0 => px6,
	data_out => mid_to_buff_data
);

top_register : shift_register 
port map (

	clk => clk, 
	enable => shift_enable,
	reset => reset,
	data_in => buff_to_top_data,
	tap2 => px1,
	tap1 => px2,
	tap0 => px3
);

end architecture buff;




