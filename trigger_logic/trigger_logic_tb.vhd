library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity trigger_logic_tb is

end entity trigger_logic_tb;

architecture sim of trigger_logic_tb is

	signal clk              : std_logic  := '0';
	signal rst              : std_logic  := '0';
	signal sample_valid     : std_logic  := '0';
	signal sample_in        : std_logic_vector(11 downto 0)  := (others => '0');
	signal trigger_level    : std_logic_vector(11 downto 0)  := (others => '0');
	signal trigger_detected : std_logic;

begin

	dut : entity work.trigger_logic 
	
		port map (
			clk					=> clk,
			rst					=> rst,
			sample_valid		=> sample_valid,
			sample_in			=> sample_in,
			trigger_level		=> trigger_level,
			trigger_detected	=> trigger_detected	
		);
		
	clk  <= not clk after 10 ns;
	
	
	stumulus: process
	
	begin
		wait for 40 ns;
		
		rst  <= '0';
		wait for 20 ns;
		
		trigger_level <= std_logic_vector(to_unsigned(2000, 12));
		
		sample_valid  <= '1';
		sample_in     <= std_logic_vector(to_unsigned(1800, 12));
		
		wait for 20 ns;
		
		sample_in     <= std_logic_vector(to_unsigned(1900, 12));
		
		wait for 20 ns;
		
		sample_in     <= std_logic_vector(to_unsigned(2200, 12));
		
		wait for 20 ns;
		
		sample_valid  <= '0';
		
		wait;
		
	end process;

end architecture sim;