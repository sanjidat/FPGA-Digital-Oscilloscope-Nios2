library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trigger_logic is

	port(
		clk              : in std_logic;
		rst              : in std_logic;
		sample_valid     : in std_logic;
		sample_in        : in std_logic_vector(11 downto 0);
		trigger_level    : in std_logic_vector(11 downto 0);
		trigger_detected : out std_logic
	);
	
end entity trigger_logic;

architecture rtl of trigger_logic is

	signal previous_sample  :  unsigned(11 downto 0);

begin

	process(clk)
	begin
	
		if rising_edge(clk) then
		
			if rst = '1' then 
				previous_sample  <= (others => '0');
				trigger_detected <= '0';
				
			else 
				trigger_detected <= '0';
				
				if sample_valid = '1' then
				
					if previous_sample < unsigned(trigger_level) and
						unsigned(sample_in) >= unsigned(trigger_level) then
						
						trigger_detected <= '1';
					
					end if;
					
					previous_sample <= unsigned(sample_in);
					
				end if;
				
			end if;
			
		
		end if;
	
	end process;


end architecture rtl;
