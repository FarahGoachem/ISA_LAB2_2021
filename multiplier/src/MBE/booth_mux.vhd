library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use WORK.packg.all;

entity booth_mux is
port ( enc : in std_logic_vector(encoding_bits-1 downto 0);
		multiplicand : in std_logic_vector(nbit-1 downto 0);
		partial_prod : out std_logic_vector(nbit downto 0)
);
end entity;

architecture struct of booth_mux is

signal sig_out : std_logic_vector(nbit downto 0);
signal sig : std_logic_vector(2 downto 0);

begin

sig_out <= (others => '0') when enc = "000" else			-- '0'
			('0' & multiplicand) when enc = "001" else		-- A
			('0' & multiplicand) when enc = "010" else		-- A
			multiplicand & '0' when enc = "011" else		--2*A

			not(multiplicand & '0') when enc = "100" else		-- -2*A-1  	the term '1' is balanced in the sign extension of the dadda tree 
			not('0' & (multiplicand)) when enc = "101" else		-- -A-1
			not('0' & (multiplicand)) when enc = "110" else		-- -A-1
			(others => '1') when enc = "111";				-- '0' -1
			
			

partial_prod <= sig_out;

end architecture;
