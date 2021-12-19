library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_l1 is
port( partial_prod_l2 : in partial_prod_out_l2_array;
	 partial_prod_l1 : out partial_prod_out_l1_array
);
end entity;

architecture struct of dadda_l1 is

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

--signal for the carries out
type carry_vect is array (0 to 2*nbit-1) of std_logic_vector(0 downto 0);
signal carry : carry_vect;

--signal for having the input partial products by column and not by rows
type column_bits is array (0 to 2*nbit-1) of std_logic_vector(l1_height-1 downto 0);
signal col_sig : column_bits;
signal col_out : column_bits;

begin

--linking to col_sig the input in order to work with columns and not rows
column_sig_gen_row : for row in 0 to l1_height-1 generate
column_sig_gen_col :	for col in 0 to 2*nbit-1 generate
							col_sig(col)(row) <= partial_prod_l2(row)(col);
						end generate;
					end generate;


--untoched columns (height < than l0_height)
col_gen_0_1 : for k in 0 to 1 generate
--even column case
adder_gen_even_0_1:	if k mod 2 = 0 generate
adder_gen_inst_even_0_1 : adder_gen generic map(0,0, (2+k/2), (2+k/2), 1) port map(col_sig(k)(1+k/2 downto 0), col_out(k)(1+k/2 downto 0), carry(k) );
	end generate;
--odd column case
adder_gen_odd_0_1:	if k mod 2 = 1 generate
adder_gen_inst_odd_0_1 : adder_gen generic map(0,0, (1+(k-1)/2), (1+(k-1)/2), 1) port map(col_sig(k)((k-1)/2 downto 0), col_out(k)((k-1)/2 downto 0), carry(k) );
	end generate;
end generate;

--only col 2 and 3 have HA but none FA and since are only 2 columns they've bee instantiaded by singularly
adder_gen_inst_2 : adder_gen generic map(1,0, l1_height, l0_height, 1) port map(col_sig(2)(l1_height-1 downto 0), col_out(2)(l0_height-1 downto 0), carry(2) );
					col_out(3)(0 downto 0) <= carry(2);
adder_gen_inst_3 : adder_gen generic map(1,0, l1_height-1, l0_height-1, 1) port map(col_sig(3)(l1_height-2 downto 0), col_out(3)(l0_height-1 downto 1), carry(3) );
					col_out(4)(0 downto 0) <= carry(3);

--instances of the columns which are equal one to each other (i.e no HA and 1 FA)
col_gen_4_62 : for k in 4 to 62 generate

adder_gen_inst_4_62 : adder_gen generic map(0, 1, l1_height, l0_height-1, 1) port map(col_sig(k)(l1_height-1 downto 0), col_out(k)(l0_height-1 downto 1), carry(k) );
					col_out(k+1)(0 downto 0) <= carry(k);
end generate;

--last column has only 1 FA but its dimesion is different wrt the previous columns and therefore is instantiated differently
col_inst_63 : adder_gen generic map(0, 1, l1_height, l0_height-1, 1) port map(col_sig(63)(l1_height-1 downto 0), col_out(63)(l0_height-1 downto 1), carry(63) );

--linkig the signal made by columns-rows to the output made by rows-columns
output_gen_row : for row in 0 to l0_height-1 generate
output_gen_col :	for col in 0 to 2*nbit-1 generate
label1:						if col /= 1 or row /= 1 generate
							partial_prod_l1(row)(col) <= col_out(col)(row);
							end generate;
						end generate;
					end generate;
--this is needed for padding with a '0' this specific column
partial_prod_l1(1)(1) <= '0';


end architecture;
