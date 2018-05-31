library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register is
port (

	clk, enable, reset : in std_logic;
	data_in : in std_logic_vector(7 downto 0);
	tap2, tap1, tap0 : out std_logic_vector(7 downto 0);
	data_out : out std_logic_vector(7 downto 0)

);
end entity shift_register;

architecture shift of shift_register is

type temp is array (2 downto 0) of std_logic_vector(7 downto 0);
signal temp_array : temp;
signal data_out_temp : std_logic_vector(7 downto 0) := (others => '0');


begin

	process(clk,enable,reset)
		
		begin
		
			if (reset = '1') then
										
					temp_array(0) <= (others => '0');
					temp_array(1) <= (others => '0');
					temp_array(2) <= (others => '0');
				
		
			elsif (rising_edge(clk)) then
				if (enable = '1') then			
					
					temp_array(2) <= temp_array(1);
					temp_array(1) <= temp_array(0);				
										
					-- Data will be at the lowest index
					temp_array(0) <= data_in;			
					
				end if;
			end if;
			
	end process;
	
	tap2 <= temp_array(2);
	tap1 <= temp_array(1);
	tap0 <= temp_array(0);
	
	data_out <= temp_array(2);
	
	
end architecture shift;
				
			
