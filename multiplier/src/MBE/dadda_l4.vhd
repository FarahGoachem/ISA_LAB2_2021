library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l4 is
port( partial_prod_l5 : in partial_prod_out_l5_array;
	 partial_prod_l4 : out partial_prod_out_l4_array
);
end entity;


architecture struct of dadda_l4 is

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

--type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(0 to 2);
type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(2 downto 0);
signal carry : carry_vect;

--signal for having the input partial products by column and not by rows
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l4_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l4_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod_l5(row)(col);
						end generate;
					end generate;


--untouched bits 
col_gen_0_9 : for k in 0 to 9 generate
adder_gen_even_0_9:	if k mod 2 = 0 generate
adder_gen_inst_even_0_9 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 3) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
adder_gen_odd_0_9:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_9 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 3) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--generating the cols with heigth > l3_height but <l4_heght
col_gen_10_15: for k in 10 to 15 generate

adder_gen_even_10_15:	if k mod 2 = 0 generate
adder_gen_inst_even_10_15 : adder_gen generic map(1, (k-10)/2, 7+(k-10)/2, l3_height-(k-10)/2, 3) port map(col_sig(k)(6+(k-10)/2 downto 0), col_out(k)(l3_height-1 downto (k-10)/2), carry(k) );
							col_out(k+1)( (k-10)/2 downto 0) <= carry(k)((k-10)/2 downto 0);
	end generate;

adder_gen_odd_10_15:	if k mod 2 = 1 generate
adder_gen_inst_odd_10_15 : adder_gen generic map(1, (k-11)/2, 6+(k-11)/2, l3_height-1-(k-11)/2, 3) port map(col_sig(k)(5+(k-11)/2 downto 0), col_out(k)(l3_height-1 downto 1+(k-11)/2), carry(k) );
							col_out(k+1)( (k-11)/2 downto 0) <= carry(k)((k-11)/2 downto 0);
	end generate;

end generate;

--generating the col with height = l4_height
col_gen_16_51 : for k in 16 to 51 generate

adder_gen_inst_16_51 : adder_gen generic map(0, 3, l4_height, l3_height-3, 3) port map(col_sig(k)(l4_height-1 downto 0), col_out(k)(l3_height-1 downto 3), carry(k) );
					col_out(k+1)(2 downto 0) <= carry(k);

end generate;

--generating cols with height > l3_height but < l4_height on the left
col_gen_52_57: for k in 52 to 57 generate

adder_gen_even_52_57:	if k mod 2 = 0 generate
adder_gen_inst_even_52_57 : adder_gen generic map(1, 2-(k-52)/2, l4_height-1-(k-52)/2, 3+(k-52)/2, 3) port map(col_sig(k)(l4_height-2 downto (k-52)/2), col_out(k)(l3_height-1 downto 3-(k-52)/2), carry(k) );
							col_out(k+1)( 2 - (k-52)/2 downto 0) <= carry(k)(2 -(k-52)/2 downto 0);
	end generate;

adder_gen_odd_52_57:	if k mod 2 = 1 generate
adder_gen_inst_odd_52_57 : adder_gen generic map(0, 2 -(k-53)/2, l4_height-2-(k-53)/2, 3+(k-53)/2, 3) port map(col_sig(k)(l4_height-2 downto 1+(k-53)/2), col_out(k)(l3_height-1 downto 3-(k-53)/2), carry(k) );
carry_gen_52_57:				if k /= 57 generate
									col_out(k+1)( 1 - (k-53)/2 downto 0) <= carry(k)(1 -(k-53)/2 downto 0);
							end generate;
	end generate;

end generate;

--untoched columns on the left
col_gen_58_63: for k in 58 to 63 generate
adder_gen_even_58_63:	if k mod 2 = 0 generate
adder_gen_inst_even_58_63 : adder_gen generic map(0,0, l3_height-1-(k-58)/2, l3_height-1-(k-58)/2, 3) port map(col_sig(k)(l4_height-2 downto 3+(k-58)/2), col_out(k)(l3_height-2 downto (k-58)/2), carry(k) );

	end generate;

adder_gen_odd_58_63:	if k mod 2 = 1 generate
adder_gen_inst_odd_58_63 : adder_gen generic map(0, 0, l3_height-2-(k-59)/2 , l3_height-2-(k-59)/2, 3) port map(col_sig(k)(l4_height-2 downto 4+(k-59)/2), col_out(k)(l3_height-2 downto 1+(k-59)/2), carry(k) );
	end generate;

end generate;

--linkig the signal made by columns-rows to the output made by rows-columns
output_gen_row : for row in 0 to l3_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
							partial_prod_l4(row)(col) <= col_out(col)(row);
						end generate;
					end generate;


end architecture;
