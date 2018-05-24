library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_out_counter is
generic(
	image_width : integer range 5 to 640 := 5;
	image_height : integer range 5 to 480 := 5
);
port (
clk, reset, enable : in std_logic;
count_done : out std_logic
);
end entity pixel_out_counter;

architecture beh of pixel_out_counter is

begin

	counter : process(clk, reset)
		
		variable count : integer range 0 to image_width*image_height := 0;
		
		begin
		if reset = '1' then
			
			count := 0;
			count_done <= '0';
			
		elsif rising_edge(clk) then

			if (enable = '1') then
					
				if (count = (image_width * image_height) - 1 - 1) then
					count_done <= '1';
					count := image_width*image_height - 1 - 1;
				else 
					count_done <= '0';
					count := count + 1;
				end if;				

			end if;
		
		end if;
		
	end process;

end architecture beh;