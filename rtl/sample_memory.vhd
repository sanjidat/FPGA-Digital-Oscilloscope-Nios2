library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_memory is
	port(
		clk					: in std_logic;
		wr_en					: in std_logic;
		rd_en					: in std_logic;
		write_address		: in std_logic_vector(4 downto 0);
		read_address		: in std_logic_vector(4 downto 0);
		data_in				: in std_logic_vector(11 downto 0);
		data_out				: out std_logic_vector(11 downto 0)
	);
	
end entity sample_memory;

architecture rtl of sample_memory is

	type memory_array is array(0 to 31) of std_logic_vector(11 downto 0);
	signal memory : memory_array := (others => (others => '0'));
	
	begin
	
	process(clk)
	begin
		
		if rising_edge(clk) then
		
			if (wr_en = '1') then
				memory(to_integer(unsigned(write_address))) <= data_in;
			end if;
			
			if (rd_en = '1') then 
				data_out <= memory(to_integer(unsigned(read_address)));
			end if;
				
		end if;
	
	end process;

end architecture rtl;