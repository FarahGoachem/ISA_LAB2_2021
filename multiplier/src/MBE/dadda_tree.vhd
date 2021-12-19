library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity dadda_tree is
port (	partial_prod : in partial_prod_out_array;
		data_out1, data_out2 : out std_logic_vector(2*nbit-1 downto 0)
	);
end entity;

architecture struct of dadda_tree is

component dadda_l6 is
port( partial_prod : in partial_prod_out_array;
	 partial_prod_l6 : out partial_prod_out_l6_array
);
end component;

component dadda_l5 is
port( partial_prod_l6 : in partial_prod_out_l6_array;
	 partial_prod_l5 : out partial_prod_out_l5_array
);
end component;

component dadda_l4 is
port( partial_prod_l5 : in partial_prod_out_l5_array;
	 partial_prod_l4 : out partial_prod_out_l4_array
);
end component;

component dadda_l3 is
port( partial_prod_l4 : in partial_prod_out_l4_array;
	 partial_prod_l3 : out partial_prod_out_l3_array
);
end component;

component dadda_l2 is
port( partial_prod_l3 : in partial_prod_out_l3_array;
	 partial_prod_l2 : out partial_prod_out_l2_array
);
end component;

component dadda_l1 is
port( partial_prod_l2 : in partial_prod_out_l2_array;
	 partial_prod_l1 : out partial_prod_out_l1_array
);
end component;

signal partial_prod_l6_out : partial_prod_out_l6_array;
signal partial_prod_l5_out : partial_prod_out_l5_array;
signal partial_prod_l4_out : partial_prod_out_l4_array;
signal partial_prod_l3_out : partial_prod_out_l3_array;
signal partial_prod_l2_out : partial_prod_out_l2_array;
signal partial_prod_l1_out : partial_prod_out_l1_array;

begin
--layer6, 17 to 13
layer6_inst : dadda_l6 port map(partial_prod, partial_prod_l6_out);

--layer5, 13 to 9
layer5_inst : dadda_l5 port map(partial_prod_l6_out, partial_prod_l5_out);

--layer4, 9 to 6
layer4_inst : dadda_l4 port map(partial_prod_l5_out, partial_prod_l4_out);

--layer3, 6 to 4
layer3_inst : dadda_l3 port map(partial_prod_l4_out, partial_prod_l3_out);

--layer2, 4 to 3
layer2_inst : dadda_l2 port map(partial_prod_l3_out, partial_prod_l2_out);

--layer1, 3 to 2
layer1_inst : dadda_l1 port map(partial_prod_l2_out, partial_prod_l1_out);

--layer0 final sum outside this component
data_out1 <= partial_prod_l1_out(0);
data_out2 <= partial_prod_l1_out(1);

end architecture;
