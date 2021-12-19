library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l3 is
port( partial_prod_l4 : in partial_prod_out_l4_array;
	 partial_prod_l3 : out partial_prod_out_l3_array
);
end entity;


architecture struct of dadda_l3 is

component adder_gen is
generic (n_ha : integer := 0;
		n_fa : integer := 0;
		nbit_in : integer := 1;
		nbit_out : integer := 1;
		carry_max :integer := 4);

port ( input : in std_logic_vector(nbit_in-1 downto 0);
		output : out std_logic_vector(nbit_out-1 downto 0);
		carry_out : out std_logic_vector(carry_max-1 downto 0) 
);
end component;

-- signal for carry out
type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(1 downto 0);
signal carry : carry_vect;

--signal for having the input partial products by column and not by rows
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l3_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l3_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod_l4(row)(col);
						end generate;
					end generate;


--untouched columns (height < l2_height) 
col_gen_0_5 : for k in 0 to 5 generate
adder_gen_even_0_5:	if k mod 2 = 0 generate
adder_gen_inst_even_0_5 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 2) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
adder_gen_odd_0_5:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_5 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 2) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--generating the cols with heigth > l2_height but not max FAs
col_gen_6_9: for k in 6 to 9 generate

adder_gen_even_6_9:	if k mod 2 = 0 generate
adder_gen_inst_even_6_9 : adder_gen generic map(1, (k-6)/2, 5+(k-6)/2, l2_height-(k-6)/2, 2) port map(col_sig(k)(4+(k-6)/2 downto 0), col_out(k)(l2_height-1 downto (k-6)/2), carry(k) );
						col_out(k+1)( (k-6)/2 downto 0) <= carry(k)((k-6)/2 downto 0);
	end generate;

adder_gen_odd_6_9 : if k mod 2 = 1 generate
adder_gen_inst_odd_6_9 : adder_gen generic map(1, (k-7)/2, 4+(k-7)/2, l2_height-1-(k-7)/2, 2) port map(col_sig(k)(3+(k-7)/2 downto 0), col_out(k)(l2_height-1 downto 1+(k-7)/2), carry(k) );
						col_out(k+1)( (k-7)/2 downto 0) <= carry(k)((k-7)/2 downto 0);
	end generate;

end generate;


--generating the col with height = l2_height
col_gen_10_57 : for k in 10 to 57 generate

adder_gen_inst_10_57 : adder_gen generic map(0, 2, l3_height, l2_height-2, 2) port map(col_sig(k)(l3_height-1 downto 0), col_out(k)(l2_height-1 downto 2), carry(k) );
					col_out(k+1)(1 downto 0) <= carry(k);

end generate;

--generating cols with height < l2_height on the left
col_gen_58_61: for k in 58 to 61 generate

adder_gen_even_58_61:	if k mod 2 = 0 generate
adder_gen_inst_even_58_61 : adder_gen generic map(1, 1-(k-58)/2, l3_height-1-(k-58)/2, 2+(k-58)/2, 2) port map(col_sig(k)(l3_height-2 downto (k-58)/2), col_out(k)(l2_height-1 downto 2-(k-58)/2), carry(k) );
							col_out(k+1)( 1 - (k-58)/2 downto 0) <= carry(k)(1 -(k-58)/2 downto 0);
	end generate;

adder_gen_odd_58_61:	if k mod 2 = 1 generate
adder_gen_inst_odd_58_61 : adder_gen generic map(0, 1 -(k-59)/2, l3_height-2-(k-59)/2, 2+(k-59)/2, 2) port map(col_sig(k)(l3_height-2 downto 1+(k-59)/2), col_out(k)(l2_height-1 downto 2-(k-59)/2), carry(k) );
carry_gen_58_61:				if k /= 61 generate
									col_out(k+1)( 0 - (k-59)/2 downto 0) <= carry(k)(0 -(k-59)/2 downto 0);
							end generate;
	end generate;

end generate;


--generating cols untouched on the left
col_gen_62_63: for k in 62 to 63 generate
adder_gen_even_62_63:	if k mod 2 = 0 generate
adder_gen_inst_even_62_63 : adder_gen generic map(0,0, l2_height-1-(k-62)/2, l2_height-1-(k-62)/2, 2) port map(col_sig(k)(l3_height-2 downto 2+(k-63)/2), col_out(k)(l2_height-1 downto 1), carry(k) );

	end generate;

adder_gen_odd_62_63:	if k mod 2 = 1 generate
adder_gen_inst_odd_62_63 : adder_gen generic map(0, 0, l2_height-2-(k-63)/2 , l2_height-2-(k-63)/2, 2) port map(col_sig(k)(l3_height-2 downto 3), col_out(k)(l2_height-1 downto 2), carry(k) );
	end generate;

end generate;

--linkig the signal made by columns-rows to the output made by rows-columns
output_gen_row : for row in 0 to l2_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
							partial_prod_l3(row)(col) <= col_out(col)(row);
						end generate;
					end generate;



end architecture;
