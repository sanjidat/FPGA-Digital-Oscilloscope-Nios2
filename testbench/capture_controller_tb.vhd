library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity capture_controller_tb is
end entity capture_controller_tb;

architecture sim of capture_controller_tb is 

	signal clk						: std_logic := '0';
	signal rst						: std_logic := '0';
	signal start_capture			: std_logic := '0'; 
	signal trigger_detected		: std_logic := '0';
	signal sample_valid			: std_logic := '0'; 
	
	signal write_enable			: std_logic;
	signal write_address			: std_logic_vector(4 downto 0);		
	signal capture_done			: std_logic;
	signal capture_busy			: std_logic;

begin

	clk <= not clk after 10 ns;
	
	dut: entity work.capture_controller
	
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
		
	stimulus: process
	begin
	
		rst <= '1';
		wait for 40 ns;
		rst <= '0';
		
		wait for 20 ns;
		
		start_capture <= '1';
		wait for 20 ns;
		start_capture <= '0';
		
		wait for 40 ns;
		
		trigger_detected <= '1';
		wait for 20 ns;
		trigger_detected <= '0';
		
		wait for 20 ns;
		
		for i in 0 to 31 loop
			sample_valid <= '1';
			wait for 20 ns;
			
			sample_valid <= '0';
			wait for 20 ns;
		end loop;
		
		wait for 100 ns;
		wait;
	
	
	end process;
end architecture sim;