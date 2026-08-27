library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_generator_tb is

end entity sample_generator_tb;


architecture sim of sample_generator_tb is

	signal clk				: std_logic := '0';
	signal rst				: std_logic := '0';
	signal sample_valid	: std_logic := '0';
	signal sample_out		: std_logic_vector(11 downto 0) := (others => '0');
	
	begin
	
	DUT: entity work.sample_generator 
	port map(
		clk				=> clk,
		rst				=> rst,
		sample_valid	=> sample_valid,
		sample_out		=> sample_out
	);
	
	clk <= not(clk) after 10 ns;
	
	stimulus: process
	begin
	
	-- Keep generator in reset
    rst <= '1';

    wait for 40 ns;

    -- Release reset
    rst <= '0';

    -- Allow samples to be generated
    wait for 800 ns;

    -- Test reset again
    --rst <= '1';

    --wait for 40 ns;

    --rst <= '0';

    --wait for 100 ns;

    wait;

	
	end process;

end architecture sim;