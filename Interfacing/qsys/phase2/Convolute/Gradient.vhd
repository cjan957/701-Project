library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Gradient is
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
end entity Gradient;

architecture combining of Gradient is

function  sqrt  ( d : UNSIGNED ) return UNSIGNED is
variable a : unsigned(31 downto 0):=d;  --original input.
variable q : unsigned(15 downto 0):=(others => '0');  --result.
variable left,right,r : unsigned(17 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
variable i : integer:=0;

	begin
		for i in 0 to 15 loop
		right(0):='1';
		right(1):=r(17);
		right(17 downto 2):=q;
		left(1 downto 0):=a(31 downto 30);
		left(17 downto 2):=r(15 downto 0);
		a(31 downto 2):=a(29 downto 0);  --shifting by 2 bit.
		if ( r(17) = '1') then
		r := left + right;
		else
		r := left - right;
		end if;
		q(15 downto 1) := q(14 downto 0);
		q(0) := not r(17);
		end loop; 
		return q;

end sqrt;

signal G_temp : unsigned(15 downto 0) := (others => '0');


begin

	process(clk,enable)
		
		variable cnt : integer range 0 to im_width*im_height - 1 := 0;
		
		begin
	
		if (reset = '1') then
		
			cnt := 0;
			image_done <= '0';
			pixel_ready <= '0';
		
		elsif (rising_edge(clk)) then
			
			if (enable = '1') then
				
				if (cnt = im_width*im_height - 1) then
					cnt := im_width*im_height - 1;
					image_done <= '1';
				else
					image_done <= '0';
					cnt := cnt + 1;					
				end if;
				
				
				G_temp <= sqrt( (unsigned(x"00" & conv_X) * unsigned(x"00" & conv_X)) + ( unsigned(x"00" & conv_Y) * unsigned(x"00" & conv_Y)) );
				
				pixel_ready <= '1';		
			
			else 
				
				pixel_ready <= '0';	
		
			end if;
					
		end if;
	end process;
		
	G_out <= x"FF" when G_temp  > x"FF" else (others => '0') when enable = '0' else std_logic_vector(unsigned(G_temp(7 downto 0)));
		
end architecture;