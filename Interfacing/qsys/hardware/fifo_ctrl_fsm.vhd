library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_ctrl_fsm is
	port( 
	
	clk, reset, fifo_empty, fifo_read_ack : in std_logic;
	fifo_rdreq, fifo_data_ready : out std_logic
	
	);
end entity fifo_ctrl_fsm;

architecture beh of fifo_ctrl_fsm is

	Type state_type is (Idle, Send_Rdreq, Wait_Rd_Ack);
	Signal state_present, state_next: state_type := Idle;

begin

next_state_logic : process(clk)
	begin
		case state_present is
		
		when Idle =>
			if fifo_empty = '0' and fifo_read_ack = '0' then
				state_next <= Send_Rdreq;
			else
				state_next <= Idle;
			end if;
			
		when Send_Rdreq =>
			state_next <= Wait_Rd_Ack;
		
		when Wait_Rd_Ack =>
			if fifo_read_ack = '1' then 
				state_next <= Idle;
			else
				state_next <= Wait_Rd_Ack;
			end if;
	
		end case;
		
	end process next_state_logic;

	
synch_process : process(clk, reset)
	begin
	
		if reset = '1' then
			state_present <= Idle;
		elsif rising_edge(clk) then 
			state_present <= state_next;
		end if;	
		
	end process synch_process;
	
	
output_logic : process(state_present)
	begin
		case state_present is
		
			when Idle =>
				fifo_rdreq 			<= '0';
				fifo_data_ready 	<= '0';
			
			when Send_Rdreq =>
				fifo_rdreq 			<= '1';
				fifo_data_ready 	<= '0';
				
			when Wait_Rd_Ack =>
				fifo_rdreq			<= '0';
				fifo_data_ready	<= '1';
				
		end case;
		
	end process output_logic;

	
end architecture beh;