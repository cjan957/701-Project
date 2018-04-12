library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity eightBitMultiplier is
	port(input_a, input_b : in STD_LOGIC_VECTOR(7 downto 0);
		output : out STD_LOGIC_VECTOR(15 downto 0)
	);
end eightBitMultiplier;

architecture beh of eightBitMultiplier is
begin
	output <= input_a * input_b;
end;


	