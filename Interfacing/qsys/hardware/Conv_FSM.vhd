library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Conv_FSM is
port (

	clk,enable,reset 			: in std_logic;
	first_pixels_done			: in std_logic;
	conv_ready 					: in std_logic;
	last_pixels 				: in std_logic;
	image_done 					: in std_logic;
	
	cnt_en						: out std_logic;
	conv_en						: out std_logic;
	edge_en						: out std_logic;
	
	sel_out						: out std_logic
);
end entity Conv_FSM;


architecture logic of Conv_FSM is

type states is (idle, init_pixels, load_pixels, convolutions, final_pixels, image_finished, convolutions_abort);
signal state : states := idle;


begin

	process(clk,reset)
	
		begin
			if (reset = '1') then
				state <= idle;
		
			elsif (rising_edge(clk)) then
			
			
				case state is
				
					when idle =>
						
						if (enable = '1')  AND (first_pixels_done = '0')  AND (conv_ready = '0')  AND (last_pixels = '0') then
											
							state <= init_pixels;
							
						elsif (enable = '1') AND (first_pixels_done = '1')  AND (conv_ready = '0')  AND (last_pixels = '0') then
						
							state <= load_pixels;
							
						elsif (enable = '1') AND (first_pixels_done = '1')  AND (conv_ready = '1')  AND (last_pixels = '0') then
						
							state <= convolutions;
							
						elsif (first_pixels_done = '1')  AND (conv_ready = '0') AND (last_pixels = '1') then
						
							state <= final_pixels;
							
						else 
							
							state <= idle;
						
						end if;
						
					----------------------------------- 		
					when init_pixels =>
					
						if (enable = '1') then
							
							if (first_pixels_done = '1') then
								
								state <= load_pixels;
							
							else
							
								state <= init_pixels;
							
							end if;						
													
						else 
							
							state <= idle;
						
						end if;					
						
					----------------------------------- 
					when load_pixels =>
				
						if (enable = '1') then
							
							if (conv_ready = '1') then
								
								state <= convolutions;
						
							else
							
								state <= load_pixels;
							
							end if;						
													
						else 
							
							state <= idle;
						
						end if;
						
					----------------------------------- 
					when convolutions =>
				
						
						if (last_pixels = '1') then
						
							state <= final_pixels;
						
						else 
						
							if (enable = '1') then
							
								state <= convolutions;
							
							else 
							
								state <= convolutions_abort;
								
							end if;
							
						
						end if;
						
					----------------------------------- 
					when convolutions_abort =>
				
						state <= idle;							
												
					----------------------------------- 	
					when final_pixels =>
				
							
						if (image_done = '1') then
								
							state <= image_finished;
						
						else
							
							state <= final_pixels;
							
						end if;						
																			
					-----------------------------------
					when image_finished =>
						state <= image_finished;						
						
				when others =>
					state <= idle;
				end case;
			
			
		end if;
				
	end process;
		
	cnt_en <= '0' when state = final_pixels OR state = image_finished OR state = idle else '1';
	
	conv_en <= '1' when state = convolutions else '0';
	
	sel_out <= '1' when state = convolutions or state = convolutions_abort else '0';
	
	edge_en <= '1' when state = init_pixels or state = final_pixels else '0';
	
	
end architecture logic;
