library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sample_generator is

	port (
		clk				:	in std_logic;
		rst				:  in std_logic;
		
		sample_valid   :  out std_logic;
		sample_out		:  out std_logic_vector(11 downto 0)
);

end entity sample_generator;

architecture rtl of sample_generator is

	--signal sample_counter : unsigned(11 downto 0);
	
	type sine_table_type is array (0 to 31) of unsigned(11 downto 0);
	constant sine_table : sine_table_type := (
	
		to_unsigned(2048, 12),
		to_unsigned(2447, 12),
		to_unsigned(2831, 12),
		to_unsigned(3185, 12),
		to_unsigned(3495, 12),
		to_unsigned(3740, 12),
		to_unsigned(3939, 12),
		to_unsigned(4056, 12),
		to_unsigned(4095, 12),
		to_unsigned(4056, 12),
		to_unsigned(3939, 12),
		to_unsigned(3740, 12),
		to_unsigned(3495, 12),
		to_unsigned(3185, 12),
		to_unsigned(2831, 12),
		to_unsigned(2447, 12),
		to_unsigned(2048, 12),
		to_unsigned(1649, 12),
		to_unsigned(1265, 12),
		to_unsigned(911, 12),
		to_unsigned(601, 12),
		to_unsigned(356, 12),
		to_unsigned(157, 12),
		to_unsigned(40, 12),
		to_unsigned(1, 12),
		to_unsigned(40, 12),
		to_unsigned(157, 12),
		to_unsigned(356, 12),
		to_unsigned(601, 12),
		to_unsigned(911, 12),
		to_unsigned(1265, 12),
		to_unsigned(1649, 12)
);
	
	signal sine_index : integer range 0 to 31 := 0;
	
	begin
	process(clk)
	
	begin
	
		if rising_edge(clk) then
		
			if rst = '1' then
				sample_valid   <= '0';
				sample_out     <= (others => '0');
				sine_index	<= 0;
				--sample_counter <= (others => '0');
				
			else 
				--sample_counter	<= sample_counter + 1;
				sample_valid	<= '1';
				sample_out		<= std_logic_vector(sine_table(sine_index));
				
				if sine_index = 31 then 
					sine_index	<= 0;
					
				else 
					sine_index	<= sine_index + 1;
				end if;
				
			end if;
			
		end if;
	
	end process;
end architecture rtl;

