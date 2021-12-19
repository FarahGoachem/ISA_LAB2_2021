library ieee;
use ieee.std_logic_1164.all;

package packg is
	constant nbit : integer := 32;
	constant radix : integer := 4;
	constant encoding_bits : integer := 3;
	constant l6_height : integer := 17;
	constant l5_height : integer := 13;
	constant l4_height : integer := 9;
	constant l3_height : integer := 6;
	constant l2_height : integer := 4;
	constant l1_height : integer := 3;
	constant l0_height : integer := 2;

	type partial_prod_array is array (0 to nbit/2) of std_logic_vector(nbit downto 0);
	type partial_prod_out_array is array (0 to nbit/2) of std_logic_vector(2*nbit-1 downto 0);
	type partial_prod_out_l6_array is array (0 to l5_height-1) of std_logic_vector (2*nbit-1 downto 0);
	--type partial_prod_out_l6_array is array (2*nbit-1 downto 0) of std_logic_vector (0 to l5_height-1);
	type partial_prod_out_l5_array is array (0 to l4_height-1) of std_logic_vector (2*nbit-1 downto 0);
	type partial_prod_out_l4_array is array (0 to l3_height-1) of std_logic_vector (2*nbit-1 downto 0);
	type partial_prod_out_l3_array is array (0 to l2_height-1) of std_logic_vector (2*nbit-1 downto 0);
	type partial_prod_out_l2_array is array (0 to l1_height-1) of std_logic_vector (2*nbit-1 downto 0);
	type partial_prod_out_l1_array is array (0 to l0_height-1) of std_logic_vector (2*nbit-1 downto 0);

end packg;
