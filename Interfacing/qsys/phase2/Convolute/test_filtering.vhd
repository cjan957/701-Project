library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_filtering is
end entity test_filtering;

architecture testing of test_filtering is

component Convolution is
port (

	clk,enable : in std_logic;
	kernel : in std_logic_vector(2 downto 0);
	input1,input2,input3,input4,input5,input6,input7,input8,input9 : in std_logic_vector(7 downto 0);
	conv_result : out unsigned (15 downto 0)	
);
end component Convolution;

component Gradient is
port (

	clk, enable : in std_logic;
	conv_X : in std_logic_vector(7 downto 0);
	conv_Y : in std_logic_vector(7 downto 0);
	
	G_out :  out std_logic_vector(7 downto 0)

);
end component Gradient;




--signal kernel_x, kernel_y : std_logic_vector(2 downto 0);

--signal in1,in2,in3,in4,in5,in6,in7,in8,in9 : std_logic_vector(7 downto 0) := (others => '0');

signal result_x, result_y : std_logic_vector(7 downto 0) := (others => '0');

signal clk_s, en_s : std_logic;

signal grad_out : std_logic_vector(7 downto 0) := (others => '0'); 

begin

--test_conv_x : Convolution port map (
--
--	
--	clk => clk_s,
--	enable => en_c,
--	kernel => kernel_x,
--	input1 => in1,
--	input2 => in2,
--	input3 => in3,
--	input4 => in4,
--	input5 => in5,
--	input6 => in6,
--	input7 => in7,
--	input8 => in8,
--	input9 => in9,
--	
--	conv_result => result_x
--	
--	);
	
--test_conv_y : Convolution port map (
--
--	
--	clk => clk_s,
--	enable => en_c,
--	kernel => kernel_y,
--	input1 => in1,
--	input2 => in2,
--	input3 => in3,
--	input4 => in4,
--	input5 => in5,
--	input6 => in6,
--	input7 => in7,
--	input8 => in8,
--	input9 => in9,
--	
--	conv_result => result_y
--	
--	);
	
test_grad : Gradient port map (

	clk => clk_s,
	enable => en_s,
	conv_X => result_x,
	conv_Y => result_y,
	G_out =>  grad_out

);


	test : process
	begin
	
		wait for 2 ns;
		clk_s <= '1';
		wait for 2 ns;
		clk_s <= '0';

	end process;
	
	data : process
	begin
	
	
		-- Sobel X Outputs
		result_x <= x"00" after 4 ns, --
					x"00" after 8 ns, --
					x"FF" after 12 ns, --
					x"00" after 16 ns, --
					x"00" after 20 ns, --
					x"00" after 24 ns, --
					x"00" after 28 ns, 
					x"A0" after 32 ns, 
					x"FF" after 36 ns, 
					x"70" after 40 ns, 
					x"00" after 44 ns, 
					x"00" after 48 ns, 
					x"80" after 52 ns, 
					x"FF" after 56 ns, 
					x"00" after 60 ns, 
					x"00" after 64 ns, 
					x"00" after 68 ns, 
					x"20" after 72 ns, 
					x"FF" after 76 ns, 
					x"00" after 80 ns, --
					x"FF" after 84 ns, --
					x"FF" after 88 ns, --
					x"FF" after 92 ns, --
					x"FF" after 96 ns, --
					x"FF" after 100 ns; --
					
		result_y <= x"00" after 4 ns, --
					x"00" after 8 ns, --
					x"FF" after 12 ns, --
					x"00" after 16 ns, --
					x"00" after 20 ns, --
					x"00" after 24 ns, --
					x"00" after 28 ns, 
					x"42" after 32 ns, 
					x"00" after 36 ns, 
					x"00" after 40 ns, 
					x"00" after 44 ns, 
					x"00" after 48 ns, 
					x"00" after 52 ns, 
					x"00" after 56 ns, 
					x"00" after 60 ns, 
					x"00" after 64 ns, 
					x"00" after 68 ns, 
					x"00" after 72 ns, 
					x"00" after 76 ns, 
					x"00" after 80 ns, --
					x"FF" after 84 ns, --
					x"FF" after 88 ns, --
					x"FF" after 92 ns, --
					x"FF" after 96 ns, --
					x"FF" after 100 ns; --
	
		
--		kernel_x <= "010", "000" after 10 ns;
--		kernel_y <= "011", "000" after 10 ns;
		
--		in1 <= x"64", x"00" after 10 ns;
--		in2 <= x"54", x"00" after 10 ns;
--		in3 <= x"60", x"00" after 10 ns;
--		in4 <= x"37", x"00" after 10 ns;
--		in5 <= x"28", x"00" after 10 ns;
--		in6 <= x"23", x"00" after 10 ns;
--		in7 <= x"00", x"00" after 10 ns;
--		in8 <= x"00", x"00" after 10 ns;
--		in9 <= x"00", x"00" after 10 ns;
		
		--en_c <= '1', '0' after 15 ns;
		en_s <= '0', '1' after 2 ns; -- , '0' after 15 ns;
		
		wait;
	
	end process;
	
	
end architecture testing;

