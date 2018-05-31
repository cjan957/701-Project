LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FIlter_interface IS
PORT ( 

		clock, resetn : IN STD_LOGIC;

		-- Heavyweight 
		readn_hw, writen_hw : IN STD_LOGIC;
		writedata_hw : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		readdata_hw : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		
		
		-- Lightweight
		readn_lw, writen_lw : in std_logic;
		writedata_lw 		  : in std_logic_vector(31 downto 0);
		readdata_lw			  : out std_logic_vector(31 downto 0)
		
		);
		
END FIlter_interface;

ARCHITECTURE Structure OF FIlter_interface IS

SIGNAL reg_hw : STD_LOGIC_VECTOR(63 DOWNTO 0) := (others => '0');
SIGNAL reg_lw : std_logic_vector(31 downto 0) := (others => '0');

signal reg_out_hw	: std_logic_vector(63 downto 0) := (others => '0');
signal reg_out_lw : std_logic_vector(31 downto 0) := (others => '0');

signal control_reg : std_logic_vector(7 downto 0) := (others => '0');
signal status_reg : std_logic_vector(7 downto 0) := (others => '0');

signal image_out_reg	: std_logic_vector(63 downto 0) := (others => '0');
signal image_in_reg 	: std_logic_vector(63 downto 0) := (others => '0');


component Filtering is
port (

	clk, enable,reset : in std_logic;
	
	-- Inputs to the filtering block
	ack : in std_logic;
	image_chunk : in std_logic_vector(63 downto 0);
	ready_for_chunk : out std_logic;
	
	
	-- Processed image
	fifo_read_data_ack: in std_logic;
	fifo_data_ready 	: out std_logic;
	fifo_out_data 		: out std_logic_vector(63 downto 0)	
		
);
end component Filtering;



BEGIN

filt : filtering port map (

	clk => clock,
	
	enable => control_reg(7),
	
	reset => control_reg(0),
	
	ack =>  control_reg(1),
	
	image_chunk => image_in_reg,
	
	ready_for_chunk => status_reg(1),
	
	fifo_read_data_ack => control_reg(6),
	
	fifo_data_ready => status_reg(7),
	
	fifo_out_data => image_out_reg

);


hw: process(clock)
BEGIN
	if (rising_edge(clock)) then

		if (writen_hw = '1') then
				
			reg_hw <= writedata_hw;
			reg_lw <= (others => '0');
	
		elsif (readn_hw = '1') then
		
			readdata_hw <= reg_out_hw; 
			
		end if;
		
		
		if (writen_lw = '1') then
		
			reg_lw <= writedata_lw;
			
		elsif (readn_lw = '1') then
		
			readdata_lw <= reg_out_lw;
			
		end if;
		
	end if;
end process hw;


--lw : process(clock)
--BEGIN
--	if (rising_edge(clock)) then
--		if (writen_lw = '1') then
--		
--			reg_lw <= writedata_lw;
--			
--		elsif (readn_lw = '1') then
--		
--			readdata_lw <= reg_out_lw;
--			
--		end if;
--	end if;
--end process lw;




--if you put the data on the bus, it will get written on to a m

--writing-- from the bus (register) to another register based on what's on the LW!
control_reg 	<= reg_hw(7 downto 0) when reg_lw(2 downto 0) = "001" else x"00" when resetn = '1';
image_in_reg 	<= reg_hw when reg_lw(2 downto 0) = "010" else x"0000000000000000" when resetn = '1';


reg_out_hw <= 	x"00000000000000" & status_reg when reg_lw(2 downto 0) = "011" else -- status
					x"00000000000000" & control_reg when reg_lw(2 downto 0) = "100" else -- control
					image_out_reg when reg_lw(2 downto 0) = "101"  -- data
					else x"0000000000000000" when resetn = '1';

reg_out_lw <= 	x"00000000" when resetn = '1' else reg_lw; 

	

END Structure;
