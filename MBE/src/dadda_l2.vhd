library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l2 is
port( partial_prod_l3 : in partial_prod_out_l3_array;
	 partial_prod_l2 : out partial_prod_out_l2_array
);
end entity;

architecture struct of dadda_l2 is

component adder_gen is
generic (n_ha : integer := 0;
		n_fa : integer := 0;
		nbit_in : integer := 1;
		nbit_out : integer := 1;
		carry_max :integer := 4);

port ( input : in std_logic_vector(nbit_in-1 downto 0);
		output : out std_logic_vector(nbit_out-1 downto 0);
		--carry_out : out std_logic_vector(0 to carry_max-1)
		carry_out : out std_logic_vector(carry_max-1 downto 0) 
);
end component;

--signal for carry
type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(0 downto 0);
signal carry : carry_vect;

--signal for having the input partial products by column and not by rows
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l2_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l2_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod_l3(row)(col);
						end generate;
					end generate;

--untoched columns (height < than l1_height)
col_gen_0_3 : for k in 0 to 3 generate
adder_gen_even_0_3:	if k mod 2 = 0 generate
adder_gen_inst_even_0_3 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 1) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
adder_gen_odd_0_3:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_3 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 1) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--only col 4 and 5 have HA but none FA and since are only 2 columns they've bee instantiaded by singularly
adder_gen_inst_4 : adder_gen generic map(1,0, l2_height, l1_height, 1) port map(col_sig(4)(l2_height-1 downto 0), col_out(4)(l1_height-1 downto 0), carry(4) );
					col_out(5)(0 downto 0) <= carry(4);
adder_gen_inst_5 : adder_gen generic map(1,0, l2_height-1, l1_height-1, 1) port map(col_sig(5)(l2_height-2 downto 0), col_out(5)(l1_height-1 downto 1), carry(5) );
					col_out(6)(0 downto 0) <= carry(5);

--instances of the columns which are equal one to each other (i.e no HA and 1 FA)
col_gen_6_61 : for k in 6 to 61 generate

adder_gen_inst_6_61 : adder_gen generic map(0, 1, l2_height, l1_height-1, 1) port map(col_sig(k)(l2_height-1 downto 0), col_out(k)(l1_height-1 downto 1), carry(k) );
					col_out(k+1)(0 downto 0) <= carry(k);
end generate;

--last 2 columns are different from previous and therefore they are instantiaded separately
adder_gen_inst_62 : adder_gen generic map(1,0, l2_height-1, l1_height-1, 1) port map(col_sig(62)(l2_height-1 downto 1), col_out(62)(l1_height-1 downto 1), carry(62) );
					col_out(63)(0 downto 0) <= carry(62);
adder_gen_inst_63 : adder_gen generic map(0,0, l2_height-2, l1_height-1, 1) port map(col_sig(63)(l2_height-1 downto 2), col_out(63)(l1_height-1 downto 1), carry(63) );

--linkig the signal made by columns-rows to the output made by rows-columns
output_gen_row : for row in 0 to l1_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
							partial_prod_l2(row)(col) <= col_out(col)(row);
						end generate;
					end generate;


end architecture;
