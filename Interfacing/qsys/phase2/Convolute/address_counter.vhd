library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_counter is
generic (image_width : integer range 4 to 640 := 5);
port (

	clk, cnt_en, reset : in std_logic;
	--image_width : in std_logic_vector(10 downto 0);
	address : out std_logic_vector(9 downto 0);
	done : out std_logic

);
end entity address_counter;

architecture cnt of address_counter is

begin

	process(clk,reset)
		
		variable counter : integer range 0 to 636 := 0;
		
		begin
		
			if (reset = '1') then
				counter := 0;
				-- output signal = 0;
			
			elsif (rising_edge(clk)) then
				if (cnt_en = '1') then
					
					address <= std_logic_vector(to_unsigned(counter,10));
					
					counter := counter + 1;
					
					if (counter >= image_width - 4) then
						counter := 0;
						done <= '1';					
					end if;
					
					
				
				end if;
			end if;
	
	end process;
	
end architecture cnt;
			