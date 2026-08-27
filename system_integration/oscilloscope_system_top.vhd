library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library nio_oscilloscope;

entity oscilloscope_system_top is

	port(
		clk	: in std_logic;
		rst	: in std_logic
	);
	

end entity oscilloscope_system_top;

architecture rtl of oscilloscope_system_top is

	signal start_capture	: std_logic;
	signal trigger_level	: std_logic_vector(11 downto 0);
	signal read_address	: std_logic_vector(4 downto 0);
	
	signal capture_busy	: std_logic;
	signal capture_done	: std_logic;
	signal sample_data	: std_logic_vector(11 downto 0);
	
	begin
	
	-- Nios System
	u_nios: entity nio_oscilloscope.nio_oscilloscope
	port map (
		clk_clk                            	=> clk,             
		oscilloscope_conduit_start_capture	=> start_capture,                                       
		oscilloscope_conduit_trigger_level	=> trigger_level,                    
		oscilloscope_conduit_read_address	=> read_address,                    
		oscilloscope_conduit_capture_busy	=> capture_busy,             
		oscilloscope_conduit_capture_done	=> capture_done,             
		oscilloscope_conduit_sample_data		=> sample_data,
		reset_reset_n                    	=> not rst             -- reset_reset_n is active-low,
	);
	
	-- Oscilloscope core
   u_oscilloscope : entity work.oscilloscope_top
	port map(
		clk				=> clk,
		rst				=> rst,
		start_capture	=> start_capture,
		rd_en				=> '1',
		rd_address		=> read_address,
		trigger_level	=> trigger_level,
		
		capture_busy	=> capture_busy,
		capture_done	=> capture_done,
		data_out			=> sample_data
	);
	
end architecture rtl;

	
