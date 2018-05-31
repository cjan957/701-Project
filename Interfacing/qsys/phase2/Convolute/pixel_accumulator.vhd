library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 
--		Concatenates 8 pixels (of 8 bits each) into one 64 bit value
-- 	To make full use of the 64 bit bus		


entity pixel_accumulator is
port ( 
	clk, reset, enable 	: in std_logic;
	pixel_in 				: in std_logic_vector(7 downto 0);
	chunk_ready 			: out std_logic;
	chunk_out 				: out std_logic_vector(63 downto 0)
);

end entity pixel_accumulator;

architecture beh of pixel_accumulator is
begin
	
	chunking : process(clk, reset)
	
	--variable chunk_temp : std_logic_vector(63 downto 0);
	variable count : integer range 0 to 7 := 0;
	variable chunk_ready_history : std_logic := '0';
		
	begin
		
	if (reset = '1') then
	
		--chunk_temp := (others => '0');
		count := 0;
		chunk_out <= (others => '0');
		chunk_ready <= '0';
		
	elsif (rising_edge(clk)) then
		
		if count = 0 and chunk_ready_history = '1' then		--reset chunk ready one cycle after chunk is ready
			chunk_ready <= '0';
			chunk_ready_history := '0';
		end if;

		if (enable = '1') then
			
			case count is 
				when 0 => chunk_out(63 downto 56) <= pixel_in;
				when 1 => chunk_out(55 downto 48) <= pixel_in;
				when 2 => chunk_out(47 downto 40) <= pixel_in; 
				when 3 => chunk_out(39 downto 32) <= pixel_in; 
				when 4 => chunk_out(31 downto 24) <= pixel_in; 
				when 5 => chunk_out(23 downto 16) <= pixel_in; 
				when 6 => chunk_out(15 downto 8) <= pixel_in; 	
				when 7 => chunk_out(7  downto 0) <= pixel_in; 
			end case;
		
			if count = 7 then
				chunk_ready <= '1';
				chunk_ready_history := '1';
				count := 0;
			else 
				chunk_ready <= '0';
				chunk_ready_history := '0';
				count := count + 1;
			end if;
			
			
		
		end if;
	
	end if;		
	
	end process;
	
end architecture beh;