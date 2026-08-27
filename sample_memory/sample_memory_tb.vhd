library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_memory_tb is

end entity sample_memory_tb;

architecture sim of sample_memory_tb is

	signal clk					: std_logic := '0';
	signal wr_en				: std_logic := '0';
	signal rd_en				: std_logic := '0';
	signal write_address		: std_logic_vector(4 downto 0)	:= (others => '0');
	signal read_address		: std_logic_vector(4 downto 0)	:= (others => '0');
	signal data_in				: std_logic_vector(11 downto 0)	:= (others => '0');
	signal data_out			: std_logic_vector(11 downto 0);	
	
	
begin
	
	dut: entity work.sample_memory 
	
		port map(
			
			clk					=> clk,
			wr_en					=> wr_en,
			rd_en					=> rd_en,
			write_address		=> write_address,
			read_address		=> read_address,
			data_in				=> data_in,
			data_out				=> data_out
		);
	
	clk <= not(clk) after 10 ns;
	
	stimulus: process
	
	begin
	
	----------------------------------------------------
    -- Initial idle period
    ----------------------------------------------------
		wr_en        <= '0';
		rd_en        <= '0';
		data_in      <= (others => '0');
		write_address <= (others => '0');
		read_address  <= (others => '0');

		wait until falling_edge(clk);

	
	----------------------------------------------------
	-- Write 100 to Address 0
	----------------------------------------------------
		wr_en         <= '1';
		write_address <= std_logic_vector(to_unsigned(0,5));
		data_in       <= std_logic_vector(to_unsigned(100,12));

		wait until rising_edge(clk);
		wait until falling_edge(clk);

		wr_en <= '0';

    ----------------------------------------------------
    -- Write 250 to Address 1
    ----------------------------------------------------
		wait until rising_edge(clk);
		wait until falling_edge(clk);
		
		wr_en         <= '1';
		write_address <= std_logic_vector(to_unsigned(1,5));
		data_in       <= std_logic_vector(to_unsigned(250,12));

		wait until rising_edge(clk);
		wait until falling_edge(clk);

		wr_en <= '0';

    ----------------------------------------------------
    -- Read Address 0
    ----------------------------------------------------
		wait until rising_edge(clk);
		wait until falling_edge(clk);
		
		rd_en         <= '1';
		read_address  <= std_logic_vector(to_unsigned(0,5));

		wait until rising_edge(clk);
		wait until falling_edge(clk);
		
		rd_en <= '0';

    ----------------------------------------------------
    -- Read Address 1
    ----------------------------------------------------
		wait until rising_edge(clk);
		wait until falling_edge(clk);
		
		rd_en         <= '1';
		read_address  <= std_logic_vector(to_unsigned(1,5));

		wait until rising_edge(clk);
		wait until falling_edge(clk);

		rd_en <= '0';

		wait;
		
	
	end process;
end architecture sim;