library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.packg.all;

entity MBE is
port (multiplicand : in std_logic_vector(nbit-1 downto 0);
		multiplier : in std_logic_vector(nbit-1 downto 0);
		data_out : out std_logic_vector(2*nbit-1 downto 0)

);
end entity;

architecture struct of MBE is

--component reg; --to insert

component booth_encoder is
port ( multiplicand : in std_logic_vector(nbit -1 downto 0);
		multiplier : in std_logic_vector(nbit -1 downto 0);
		partial_prod_out : out partial_prod_out_array
);
end component;

component dadda_tree is
port (	partial_prod : in partial_prod_out_array;
		data_out1, data_out2 : out std_logic_vector(2*nbit-1 downto 0)
	);
end component;

signal partial_prod : partial_prod_out_array;
signal last_sum1, last_sum2 : std_logic_vector(2*nbit-1 downto 0);

begin

-- input reg?
booth_encoder_inst : booth_encoder port map (multiplicand, multiplier, partial_prod); --booth encoder that generates the partial products on 2*nbits (but only nbits are actually carring data)

--reg ??
dadda_tree_inst : dadda_tree port map(partial_prod, last_sum1, last_sum2); --dadda tree that reduces the height of the partial prod to 2

--reg ??
data_out <= std_logic_vector(signed(last_sum1) + signed(last_sum2)); --last sum usign the output of the dadda tree
--output reg??

end architecture;
