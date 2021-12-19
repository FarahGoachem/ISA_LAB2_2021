library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l5 is
port( partial_prod_l6 : in partial_prod_out_l6_array;
	 partial_prod_l5 : out partial_prod_out_l5_array
);
end entity;


architecture struct of dadda_l5 is

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

--carry out signal
type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(3 downto 0);
signal carry : carry_vect;

--signal for having the input partial products by column and not by rows
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l5_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l5_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod_l6(row)(col);
						end generate;
					end generate;


--untouched bits
col_gen_0_15 : for k in 0 to 15 generate
adder_gen_even_0_15:	if k mod 2 = 0 generate
adder_gen_inst_even_0_15 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 4) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
adder_gen_odd_0_15:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_15 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 4) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--generating the cols with heigth < l4_height but >l5_height
col_gen_16_23: for k in 16 to 23 generate

adder_gen_even_16_23:	if k mod 2 = 0 generate
adder_gen_inst_even_16_23 : adder_gen generic map(1, (k-16)/2, (10+((k-16)/2)), l4_height-(k-16)/2, 4) port map(col_sig(k)(9+(k-16)/2 downto 0), col_out(k)(l4_height-1 downto (k-16)/2), carry(k) );
							col_out(k+1)( (k-16)/2 downto 0) <= carry(k)((k-16)/2 downto 0);
	end generate;

adder_gen_odd_16_23:	if k mod 2 = 1 generate
adder_gen_inst_odd_16_23 : adder_gen generic map(1, (k-17)/2, (9+((k-17)/2)), l4_height-1-(k-17)/2, 4) port map(col_sig(k)(8+(k-17)/2 downto 0), col_out(k)(l4_height-1 downto 1+(k-17)/2), carry(k) );
							col_out(k+1)( (k-17)/2 downto 0) <= carry(k)((k-17)/2 downto 0);
	end generate;

end generate;

--generating the col with height = l5_height
col_gen_24_43 : for k in 24 to 43 generate

adder_gen_inst_24_43 : adder_gen generic map(0, 4, l5_height, l4_height-4, 4) port map(col_sig(k)(l5_height-1 downto 0), col_out(k)(l4_height-1 downto 4), carry(k) );
					col_out(k+1)(3 downto 0) <= carry(k);

end generate;

--generating cols with height < l5_height but > l4_height on the left
col_gen_44_51: for k in 44 to 51 generate

adder_gen_even_44_51:	if k mod 2 = 0 generate
adder_gen_inst_even_44_51 : adder_gen generic map(1, 3-(k-44)/2, l5_height-1-(k-44)/2, 5+(k-44)/2, 4) port map(col_sig(k)(l5_height-2 downto (k-44)/2), col_out(k)(l4_height-1 downto 4-(k-44)/2), carry(k) );
							col_out(k+1)( 3 - (k-44)/2 downto 0) <= carry(k)(3 -(k-44)/2 downto 0);
	end generate;

adder_gen_odd_44_51:	if k mod 2 = 1 generate
adder_gen_inst_odd_44_51 : adder_gen generic map(0, 3 -(k-45)/2, l5_height-2-(k-45)/2, 5+(k-45)/2, 4) port map(col_sig(k)(l5_height-2 downto 1+(k-45)/2), col_out(k)(l4_height-1 downto 4-(k-45)/2), carry(k) );
carry_gen_44_51:				if k /= 51 generate
									col_out(k+1)( 2 - (k-45)/2 downto 0) <= carry(k)(2 -(k-45)/2 downto 0);
							end generate;
	end generate;

end generate;


--untouched columns on the left
col_gen_52_63: for k in 52 to 63 generate
adder_gen_even_52_63:	if k mod 2 = 0 generate
adder_gen_inst_even_52_63 : adder_gen generic map(0,0, l4_height-1-(k-52)/2, l4_height-1-(k-52)/2, 4) port map(col_sig(k)(l5_height-2 downto 4+(k-52)/2), col_out(k)(l4_height-2 downto (k-52)/2), carry(k) );

	end generate;

adder_gen_odd_52_63:	if k mod 2 = 1 generate
adder_gen_inst_odd_52_63 : adder_gen generic map(0, 0, l4_height-2-(k-53)/2 , l4_height-2-(k-53)/2, 4) port map(col_sig(k)(l5_height-2 downto 5+(k-53)/2), col_out(k)(l4_height-2 downto 1+(k-53)/2), carry(k) );
	end generate;

end generate;

--linkig the signal made by columns-rows to the output made by rows-columns
output_gen_row : for row in 0 to l4_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
							partial_prod_l5(row)(col) <= col_out(col)(row);
						end generate;
					end generate;



end architecture;
