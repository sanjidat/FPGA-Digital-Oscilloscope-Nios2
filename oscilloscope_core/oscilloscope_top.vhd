library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oscilloscope_top is

	port(
		clk				: in std_logic;
		rst				: in std_logic;
		start_capture	: in std_logic;
		rd_en				: in std_logic;
		rd_address		: in std_logic_vector(4 downto 0);
		trigger_level	: in std_logic_vector(11 downto 0);
		
		capture_busy	: out std_logic;
		capture_done	: out std_logic;
		data_out			: out std_logic_vector(11 downto 0)
);

end entity oscilloscope_top;

architecture rtl of oscilloscope_top is
	
	signal sample_valid		: std_logic;
	signal sample_out			: std_logic_vector(11 downto 0);
	
	signal trigger_detected	: std_logic;
	
	signal write_enable		: std_logic;
	signal write_address		: std_logic_vector(4 downto 0);
	
	begin
	
	u1: entity work.sample_generator 

	port map (
		clk				=>  clk,
		rst				=>  rst,
		sample_valid	=>  sample_valid,
		sample_out		=>  sample_out
	); 
	
	u2: entity work.trigger_logic 

	port map (
		clk               => clk,
		rst               => rst,
		sample_valid      => sample_valid,
		sample_in         => sample_out,
		trigger_level     => trigger_level,
		trigger_detected  => trigger_detected
	);
	
	u3: entity work.capture_controller 
	
	port map (
	
		clk					=> clk,
		rst					=> rst,
		start_capture		=> start_capture,
		trigger_detected	=> trigger_detected, 
		sample_valid		=> sample_valid, 
		write_enable		=> write_enable,
		write_address		=> write_address,	
		capture_done		=> capture_done,
		capture_busy		=> capture_busy
	);
	
	u4: entity work.sample_memory 
	port map (
		clk					=> clk,
		wr_en					=> write_enable,
		rd_en					=> rd_en,
		write_address		=> write_address,
		read_address		=> rd_address,
		data_in				=> sample_out,
		data_out				=> data_out
	);
	
end architecture rtl;

