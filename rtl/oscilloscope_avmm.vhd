library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oscilloscope_avmm is

	port(
	
		-- Avalon-MM side
		clk				: in std_logic;
		rst				: in std_logic;
		
		address			: in std_logic_vector(2 downto 0);
		write_in			: in std_logic;
		read_in			: in std_logic;
		

		write_data		: in  std_logic_vector(31 downto 0);
		read_data		: out std_logic_vector(31 downto 0);
		
		-- Oscilloscope side
		start_capture	: out std_logic;
		trigger_level	: out std_logic_vector(11 downto 0);
		read_address	: out std_logic_vector(4 downto 0);
		
		capture_busy	: in std_logic;
		capture_done	: in std_logic;
		sample_data		: in std_logic_vector(11 downto 0)
		
	);
	
end entity oscilloscope_avmm;
	
architecture rtl of oscilloscope_avmm is


	signal start_capture_reg	: std_logic := '0';
	signal trigger_level_reg	: std_logic_vector(11 downto 0) := (others => '0');
	signal rd_address_reg		: std_logic_vector(4 downto 0)  := (others => '0');
	
	begin
	
	start_capture	<= start_capture_reg;
	trigger_level	<= trigger_level_reg;
	read_address		<= rd_address_reg;
	
	process(clk)
	begin
	
		if rising_edge(clk) then
			
			if rst = '1' then
				start_capture_reg	<= '0';
				trigger_level_reg	<= (others => '0');
				rd_address_reg		<= (others => '0');
				
			else 
				if write_in	= '1' then
				
					case address is 
						when "000"	=> 
							start_capture_reg <= write_data(0);
					
						when "001"	=> 
							trigger_level_reg	<= write_data(11 downto 0);
					 
						when "011"	=> 
							rd_address_reg	<= write_data(4 downto 0);
							
						when others => 
							null;
							
					end case;
					
				end if;
			end if;
			
		end if;
	
	end process;
	
	process(address, read_in, capture_busy, capture_done, sample_data)
	begin
	
		read_data	<= (others => '0');
		
		if read_in	= '1' then
		
			case address is
				
				when "010" =>
					read_data(0)	<=	capture_busy;
					read_data(1)	<= capture_done;
	
				when "100"	=> 
					read_data(11 downto 0)	<= sample_data;
					
				when others =>
					null;
					
			end case;
		end if;
	
	end process;
	
end architecture rtl;
	