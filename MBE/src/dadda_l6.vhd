library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l6 is
port( partial_prod : in partial_prod_out_array;
	 partial_prod_l6 : out partial_prod_out_l6_array
);
end entity;


architecture struct of dadda_l6 is

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
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l6_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l6_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod(row)(col);
						end generate;
					end generate;


--untouched bits 
col_gen_0_23 : for k in 0 to 23 generate
adder_gen_even_0_23:	if k mod 2 = 0 generate
adder_gen_inst_even_0_23 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 4) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
adder_gen_odd_0_23:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_23 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 4) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--generating the cols with heigth > l5_height but <l6_height
col_gen_24_31: for k in 24 to 31 generate

adder_gen_even_24_31:	if k mod 2 = 0 generate
adder_gen_inst_even_24_31 : adder_gen generic map(1, (k-24)/2, (14+((k-24)/2)), l5_height-(k-24)/2, 4) port map(col_sig(k)(13+(k-24)/2 downto 0), col_out(k)(l5_height-1 downto (k-24)/2), carry(k) );
							col_out(k+1)( (k-24)/2 downto 0) <= carry(k)((k-24)/2 downto 0);
	end generate;

adder_gen_odd_24_31:	if k mod 2 = 1 generate
adder_gen_inst_odd_24_31 : adder_gen generic map(1, (k-25)/2, (13+((k-25)/2)), l5_height-1-(k-25)/2, 4) port map(col_sig(k)(12+(k-25)/2 downto 0), col_out(k)(l5_height-1 downto 1+(k-25)/2), carry(k) );
							col_out(k+1)( (k-25)/2 downto 0) <= carry(k)((k-25)/2 downto 0);
	end generate;

end generate;

--generating the col with height = l6_heieght
col_gen_32_35 : for k in nbit to nbit+3 generate

adder_gen_inst_32_35 : adder_gen generic map(0, 4, l6_height, l5_height-4, 4) port map(col_sig(k)(l6_height-1 downto 0), col_out(k)(l5_height-1 downto 4), carry(k) );
					col_out(k+1)(3 downto 0) <= carry(k);

end generate;

--generating cols with height < l6_height but >l5_height on the left
col_gen_36_43: for k in 36 to 43 generate

adder_gen_even_36_43:	if k mod 2 = 0 generate
adder_gen_inst_even_36_43 : adder_gen generic map(1, 3-(k-36)/2, l6_height-1-(k-36)/2, 9+(k-36)/2, 4) port map(col_sig(k)(l6_height-1 downto 1+(k-36)/2), col_out(k)(l5_height-1 downto 4-(k-36)/2), carry(k) );
							col_out(k+1)( 3 - (k-36)/2 downto 0) <= carry(k)(3 -(k-36)/2 downto 0);
	end generate;

adder_gen_odd_36_43:	if k mod 2 = 1 generate
adder_gen_inst_odd_36_43 : adder_gen generic map(0, 3 - (k-37)/2, l6_height-2-(k-37)/2 , 9+(k-37)/2, 4) port map(col_sig(k)(l6_height-1 downto 2+(k-37)/2), col_out(k)(l5_height-1 downto 4-(k-37)/2), carry(k) );
carry_gen_36_43:							if k /= 43 generate
							col_out(k+1)( 2 - (k-37)/2 downto 0) <= carry(k)(2 -(k-37)/2 downto 0);
							end generate;
	end generate;

end generate;


--untoched columns on the left
col_gen_44_63: for k in 44 to 63 generate
adder_gen_even_44_63:	if k mod 2 = 0 generate
adder_gen_inst_even_44_63 : adder_gen generic map(0,0, l5_height-1-(k-44)/2, l5_height-1-(k-44)/2, 4) port map(col_sig(k)(l6_height-1 downto 5+(k-44)/2), col_out(k)(l5_height-2 downto (k-44)/2), carry(k) );

	end generate;

adder_gen_odd_44_63:	if k mod 2 = 1 generate
adder_gen_inst_odd_44_63 : adder_gen generic map(0, 0, l5_height-2-(k-45)/2 , l5_height-2-(k-45)/2, 4) port map(col_sig(k)(l6_height-1 downto 6+(k-45)/2), col_out(k)(l5_height-2 downto 1+(k-45)/2), carry(k) );
	end generate;

end generate;

--linking to col_sig the input in order to work with columns and not rows
output_gen_row : for row in 0 to l5_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
							partial_prod_l6(row)(col) <= col_out(col)(row);
						end generate;
					end generate;


end architecture;
