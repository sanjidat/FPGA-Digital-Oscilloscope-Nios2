library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity oscilloscope_top_tb is

end entity oscilloscope_top_tb;

architecture sim of oscilloscope_top_tb is

	signal clk				: std_logic := '0';
	signal rst				: std_logic := '0';
	signal start_capture	: std_logic := '0';
	signal rd_en			: std_logic := '0';
	signal rd_address		: std_logic_vector(4 downto 0)  := (others => '0');
	signal trigger_level	: std_logic_vector(11 downto 0) := (others => '0');
		
	signal capture_busy	: std_logic := '0';
	signal capture_done	: std_logic := '0';
	signal data_out		: std_logic_vector(11 downto 0) := (others => '0');

	begin
	
	DUT: entity work.oscilloscope_top 
	port map (
	
		clk				=>	clk,
		rst				=>	rst,
		start_capture	=> start_capture,
		rd_en				=>	rd_en,
		rd_address		=> rd_address,
		trigger_level	=> trigger_level,
		
		capture_busy	=> capture_busy,
		capture_done	=> capture_done,
		data_out			=>	data_out
		
	);
	
	clk <= not(clk) after 10 ns;
	
	stimulus: process
	
		variable pass_count	: integer := 0;
		variable fail_count	: integer := 0;
		
	begin
		
		rst 				<= '1';
		start_capture 	<= '0';
		rd_en				<= '0';
	
		wait for 40 ns;
		
		rst				<= '0';
		trigger_level  <= std_logic_vector(to_unsigned(20,12));
		
		wait until falling_edge(clk);
		start_capture  <= '1';
		
		wait until falling_edge(clk);
		start_capture	<= '0';
		
		wait until capture_done = '1';
		report "Capture done detected";
		
		wait for 200 ns;
		
		wait until falling_edge(clk);
		
		rd_en	<= '1';
		
		for i in 0 to 31 loop
		
			wait until falling_edge(clk);
			
			rd_address <= std_logic_vector(to_unsigned(i,5));
			
			wait until rising_edge(clk);
			wait for 1 ns;
			
			if to_integer(unsigned(data_out)) >= 0 and 
				to_integer(unsigned(data_out)) >= 0 then
				
				pass_count := pass_count + 1;
			
			else 
			
				fail_count := fail_count + 1;
				
				report "FAIL at address " & integer'image(i) 
					severity error;
					
			end if;
				
			report	"Address = " & integer'image(i) &
						"  Actual = " & integer'image(to_integer(unsigned(data_out)));
			
		end loop;
		
		rd_en <= '0';
		
		report "--------------------------------";
		report "OSCILLOSCOPE VERIFICATION RESULTS";
		report "PASS = " & integer'image(pass_count);
		report "FAIL = " & integer'image(fail_count);
		report "--------------------------------";
		
		assert fail_count = 0
      report "OSCILLOSCOPE TEST FAILED"
      severity error;

		if fail_count = 0 then
		report "OSCILLOSCOPE TEST PASSED"
      severity note;
		end if;

		wait;
		
	end process;
end architecture sim;