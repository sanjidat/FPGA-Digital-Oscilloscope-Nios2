library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity capture_controller is
	
	port(
		clk					: in  std_logic;
		rst					: in  std_logic;
		start_capture		: in  std_logic;
		trigger_detected	: in  std_logic; 
		sample_valid		: in  std_logic; 
		
		write_enable		: out std_logic;
		write_address		: out std_logic_vector(4 downto 0);	
		capture_done		: out std_logic;
		capture_busy		: out std_logic
	
	);

end entity capture_controller;

architecture rtl of capture_controller is

type state_type is (

	IDLE,
	WAIT_TRIGGER,
	CAPTURE,
	DONE
	
);

	signal current_state   : state_type;
	signal address_counter : unsigned(4 downto 0);
	
begin

	process(clk)
	
	begin
		if rising_edge(clk) then 
		
			if rst = '1' then
			
				current_state   <= IDLE;
				address_counter <= (others => '0');
				write_enable    <= '0';
				write_address   <= (others => '0');
				capture_busy    <= '0';
				capture_done    <= '0';
				
			else
		
				write_enable  <= '0';
				capture_done  <= '0';
			
				case current_state is
				
					when IDLE => 
					
						capture_busy  <= '0';
					
						if start_capture = '1' then 
							address_counter <= (others => '0');
							current_state <= WAIT_TRIGGER;
						end if;
						
					when WAIT_TRIGGER =>
					
						capture_busy  <= '1';
					
						if trigger_detected = '1' then
							current_state <= CAPTURE;
							
						end if;
						
					when CAPTURE =>
				
						capture_busy  <= '0';
					
						if sample_valid = '1' then 
							write_enable <= '1';
							write_address <= std_logic_vector(address_counter);
							
								if address_counter = to_unsigned(31, 5) then
									current_state <= DONE;
								else 
									address_counter <= address_counter + 1;
								end if;
						end if;
								
					when DONE =>
						
						capture_busy <= '0';
						capture_done <= '1';
							
						if start_capture = '1' then
							address_counter	<= (others => '0');
							current_state <= WAIT_TRIGGER;
						end if;
							
				end case;
				
			end if;
			
		end if;
					
	
	end process;


end architecture rtl;