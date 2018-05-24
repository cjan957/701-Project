library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Distributor is
port (


	clk, enable,reset : in std_logic;
	input_chunk : in std_logic_vector(63 downto 0);
	byte_out : out std_logic_vector(7 downto 0);
	control_shift : out std_logic;
	done : out std_logic

);
end entity Distributor;

architecture distribute of Distributor is



begin
	process(clk,enable)
		variable cnt : integer range 0 to 8 := 0;
	
		begin
	
		if (reset = '1') then
			done <= '0';
			cnt := 0;
			control_shift <= '0';
		
		elsif rising_edge(clk) then
			if (enable = '1') then
				case cnt is
				
					when 0 => byte_out <= input_chunk(63 downto 56);
					when 1 => byte_out <= input_chunk(55 downto 48);
					when 2 => byte_out <= input_chunk(47 downto 40); 
					when 3 => byte_out <= input_chunk(39 downto 32); 
					when 4 => byte_out <= input_chunk(31 downto 24); 
					when 5 => byte_out <= input_chunk(23 downto 16); 
					when 6 => byte_out <= input_chunk(15 downto 8); 	
					when 7 => byte_out <= input_chunk(7  downto 0); 
					when 8 => done <= '1';
					--when 9 => control_shift <= '1';
				end case;
							
				if (cnt = 8 ) then
					cnt := 0;
					control_shift <= '0';
				else
					
					-- Must read control shift also to see if the data being read is valid
					control_shift <= '1';
						
					cnt := cnt + 1;					
					
				end if;
			
			end if;
		end if;	
		
	end process;


end architecture distribute;