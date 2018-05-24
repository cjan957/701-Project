library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Convolution is 
port (

	clk, enable : in std_logic;
	kernel : in std_logic_vector(2 downto 0);
	input1,input2,input3,input4,input5,input6,input7,input8,input9 : in std_logic_vector(7 downto 0);
	conv_result : out std_logic_vector(7 downto 0);
	conv_done : out std_logic
);
end entity Convolution;

architecture beh of Convolution is

type kernel_type is array (8 downto 0) of integer range -4 to 5;

constant gaussian_blur : kernel_type := (1,2,1,2,4,2,1,2,1);

constant sobel_x : kernel_type := (-1,0,1,-2,0,2,-1,0,1);

constant sobel_y : kernel_type := (-1,-2,-1,0,0,0,1,2,1);

constant scharr : kernel_type := (0,-1,0,-1,5,-1,0,-1,0);

signal temp_result : integer range -32768 to 32767 := 0;



begin
	
	
	
	process(clk)
 
	begin
		if (rising_edge(clk)) then
			if (enable = '1') then
		
				case kernel is 
				
					-- Gaussian blur
					when "001" =>
					
					temp_result <= 
					
					( 
					(gaussian_blur(0) * to_integer(unsigned(input1))) + 
					(gaussian_blur(1) * to_integer(unsigned(input2))) + 
					(gaussian_blur(2) * to_integer(unsigned(input3))) + 
					(gaussian_blur(3) * to_integer(unsigned(input4))) + 
					(gaussian_blur(4) * to_integer(unsigned(input5))) + 
					(gaussian_blur(5) * to_integer(unsigned(input6))) + 
					(gaussian_blur(6) * to_integer(unsigned(input7))) + 
					(gaussian_blur(7) * to_integer(unsigned(input8))) + 
					(gaussian_blur(8) * to_integer(unsigned(input9)))
					) / 16; 
								
					-- Sobel X
					when "010" =>	
			
					temp_result <= 
					
					((sobel_x(0) * to_integer(unsigned(input1))) + 
					(sobel_x(1) *  to_integer(unsigned(input2))) +
					(sobel_x(2) *  to_integer(unsigned(input3))) + 
					(sobel_x(3) *  to_integer(unsigned(input4))) + 
					(sobel_x(4) *  to_integer(unsigned(input5))) + 
					(sobel_x(5) *  to_integer(unsigned(input6))) + 
					(sobel_x(6) *  to_integer(unsigned(input7))) + 
					(sobel_x(7) *  to_integer(unsigned(input8))) +
					(sobel_x(8) *  to_integer(unsigned(input9)))

					); 
					
					-- Sobel Y
					when "011" =>
					
					temp_result <= 
					
					
					((sobel_y(0) * to_integer(unsigned(input1))) + 
					(sobel_y(1) *  to_integer(unsigned(input2))) +
					(sobel_y(2) *  to_integer(unsigned(input3))) + 
					(sobel_y(3) *  to_integer(unsigned(input4))) + 
					(sobel_y(4) *  to_integer(unsigned(input5))) + 
					(sobel_y(5) *  to_integer(unsigned(input6))) + 
					(sobel_y(6) *  to_integer(unsigned(input7))) + 
					(sobel_y(7) *  to_integer(unsigned(input8))) +
					(sobel_y(8) *  to_integer(unsigned(input9))
					)

					);
				
					-- Scharring
					when "100" => 
					
					temp_result <= 
					
					
					((scharr(0) * to_integer(unsigned(input1))) + 
					(scharr(1) *  to_integer(unsigned(input2))) +
					(scharr(2) *  to_integer(unsigned(input3))) + 
					(scharr(3) *  to_integer(unsigned(input4))) + 
					(scharr(4) *  to_integer(unsigned(input5))) + 
					(scharr(5) *  to_integer(unsigned(input6))) + 
					(scharr(6) *  to_integer(unsigned(input7))) + 
					(scharr(7) *  to_integer(unsigned(input8))) +
					(scharr(8) *  to_integer(unsigned(input9))
					)

					);
													
					when others => temp_result <= 0;
				
				end case;

				conv_done <= '1';
			
			else 
			
				conv_done <= '0';
						
			end if;		
		end if;	
	end process;


-- Caps the results to be 0 or 255	
conv_result <= x"FF" when temp_result > 255 
					else x"00" when temp_result < 0 
					else std_logic_vector(to_unsigned(temp_result,8));

end architecture;

