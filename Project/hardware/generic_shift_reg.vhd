library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity generic_shift_reg is

	generic(
		image_width : integer range 5 to 640 := 5;
		kernel_width : integer range 3 to 5 := 3
	);
		
	port(
		clk, reset, enable : in std_logic;
		pixel_in : in std_logic_vector(7 downto 0);
		pixel_out : out std_logic_vector(7 downto 0)
	);

end entity generic_shift_reg;

architecture beh of generic_shift_reg is

	type temp is array (image_width - kernel_width - 1 downto 0) of std_logic_vector(7 downto 0);
	signal temp_array : temp;
	signal temp_pixel_out : std_logic_vector(7 downto 0) := (others => '0');

begin

process(clk)

--variable index : integer range 0 to image_width - kernel_width - 1 := 0;

begin		
	if (reset = '1') then
		
		for index in 1 to image_width - kernel_width - 1 loop
				temp_array(index) <= (others => '0');
		end loop; 		
	
		temp_pixel_out <= (others => '0');
	
	elsif (rising_edge(clk)) then
		if (enable = '1') then
			
			--shift register shifts from lower index to higher index
					
			for index in 1 to image_width - kernel_width - 1 loop
				temp_array(index) <= temp_array(index - 1);
			end loop;

			--overwrite the lowest index with inserted pixel
			temp_array(0) <= pixel_in;
					
		end if;
	end if;
end process;


pixel_out <= temp_array(image_width - kernel_width - 1 );


end architecture beh;