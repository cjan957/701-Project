library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_counter is
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
end entity pixel_counter;

architecture cnt of pixel_counter is

--signal cnt_en_delay, cnt_en_delay_v2 : std_logic := '0';

begin

	process(clk,reset)
		variable pixel_count : integer range 0 to (image_width*image_height) + 1:= 0;		
		begin
			if (reset = '1') then
				pixel_count := 0;
				first_pixels_done <= '0';
				conv_ready <= '0';
				last_pixels <= '0';
			
			elsif (rising_edge(clk)) then
			
				-- Count is from 1 to 25
				if (cnt_en = '1') then					
				
					if (pixel_count < image_width - 1)  then  --(pixel_count <= (image_width+1))
						first_pixels_done <= '0';
						last_pixels <= '0';
					else
						first_pixels_done <= '1';
						last_pixels <= '0';
					end if;
					
					
					-- Once two rows and 3 pixels have been loaded, start the convolutions
					if (pixel_count = ((image_width * 2))) then
						
						conv_ready <= '1';
						last_pixels <= '0';
						
					end if;
		
					if (pixel_count = (image_width * image_height) + 1) then --(pixel_count = (image_width * image_height))
						
						pixel_count := 26;	
						last_pixels <= '1';
						conv_ready <= '0';
					else
						pixel_count := pixel_count + 1;		
					end if;											
				
				end if; --end if cnt_en = 1	
		end if; -- end if reset=1
	end process;
	
	
end architecture cnt;
			