library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;
use ieee.numeric_std.all;

entity mbe_tb is
end entity;

architecture testbench of mbe_tb is

component MBE is
port (multiplicand : in std_logic_vector(nbit-1 downto 0);
		multiplier : in std_logic_vector(nbit-1 downto 0);
		data_out : out std_logic_vector(2*nbit-1 downto 0)

);
end component;

signal data1, data2 : std_logic_vector(nbit-1 downto 0);
signal output : std_logic_vector(2*nbit-1 downto 0);

begin


--process that generates some input values for the mbe
proc : process
		variable var_data1 : integer := 4;
		variable var_data2 : integer := 4;
		begin
		var_data1 := var_data1 + 9;
		var_data2 := var_data2 + 3;

		data1 <= std_logic_vector(to_unsigned(var_data1, 32));
		data2 <= std_logic_vector(to_unsigned(var_data2, 32));
		wait for 30 ns; 
end process;


mbe_inst: mbe port map(data1, data2, output);


end architecture;
