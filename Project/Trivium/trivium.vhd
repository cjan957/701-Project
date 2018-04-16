library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity trivium is
	port( 
		clk 		   : in std_logic;
		key2,iv2 	   : in std_logic_vector(31 downto 0);
		key1,iv1 	   : in std_logic_vector(31 downto 0);
		key0,iv0 	   : in std_logic_vector(15 downto 0);
		--reset 	   : in std_logic;
		start		   : in std_logic;
		N1, N0 		   : in std_logic_vector(31 downto 0);
		keystream          : out std_logic		
	);
end trivium;

architecture beh of trivium is
	--signal state : std_logic_vector(287 downto 0) := (others => '0');
	--signal t1, t2, t3 : std_logic := '0';
	--signal setup_done : std_logic := '0';
	--signal setup_loop_done : std_logic := '0';
	--signal keystream_loop_done : std_logic := '0';
	
begin

	process(clk)
	
	variable setup_counter : integer range 0 to 1153 := 0;	
	
	-- Generate N number of keystream bits
	variable keystream_count : std_logic_vector(63 downto 0) := (others => '0');
	variable t1, t2, t3 : std_logic := '0';
	variable state : std_logic_vector(287 downto 0) := (others => '0');
	variable setup_done : std_logic := '0';
	variable setup_loop_done : std_logic := '0';
	variable keystream_loop_done : std_logic := '0';
	variable key, iv : std_logic_vector(79 downto 0) := (others => '0');
	variable N: std_logic_vector(63 downto 0) := (others => '0');
	
	begin
		if (rising_edge(clk)) then
			if (start = '1') then
			
				key := key2 & key1 & key0;
				iv := iv2 & iv1 & iv0;
				N := N1 & N0;
			
				-- initialize the state register
				state(79 downto 0) := key(79 downto 0);
				state(92 downto 80) := (others => '0');
				state(172 downto 93) := iv(79 downto 0);
				state(284 downto 173) := (others => '0');
				state(287 downto 285) := "111";
			
				setup_done := '1';
		
			--end if;

			elsif (setup_done = '1' AND setup_loop_done = '0') then

				--start of for loop (i = 1 to 4 x 288)
				
				for I in 0 to 63 loop
					t1 := (state(65) XOR state(92)) XOR ((state(90) AND state(91)) XOR state(170));
					t2 := (state(161) XOR state(176)) XOR ((state(174) AND state(175)) XOR state(263));
					t3 := (state(242) XOR state(287)) XOR ((state(285) AND state(286)) XOR state(68));
	
				
					state(92 downto 0) := state(91 downto 0) & t3;
					state(176 downto 93) := state(175 downto 93) & t1;
					state(287 downto 177) := state(286 downto 177) & t2;

				end loop;
	
				setup_counter := setup_counter + 1;
						
				if (setup_counter = 18) then
					--setup_counter := 0;		
					setup_loop_done := '1';		
				end if;

			--end if;

			elsif (start = '0' AND setup_loop_done = '1' AND keystream_loop_done = '0') then 
	
				t1 := state(65) XOR state(92);
				t2 := state(161) XOR state(176);
				t3 := state(242) XOR state(287);
					
				keystream <= t1 XOR t2 XOR t3;
				
				t1 := t1 XOR ((state(90) AND state(91)) XOR state(170));
				t2 := t2 XOR ((state(174) AND state(175)) XOR state(263));
				t3 := t3 XOR ((state(285) AND state(286)) XOR state(68));
				
				state(92 downto 0) := state(91 downto 0) & t3;
				state(176 downto 93) := state(175 downto 93) & t1;
				state(287 downto 177) := state(286 downto 177) & t2;
				
				keystream_count := keystream_count + 1;
			
				if (keystream_count = N) then
					keystream_count := (others => '0');		
					keystream_loop_done := '1';		
				end if;		
			end if;


		end if;


		
	end process;
	
end architecture beh;