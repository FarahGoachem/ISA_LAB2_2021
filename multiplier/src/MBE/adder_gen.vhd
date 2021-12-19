library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity adder_gen is
generic (n_ha : integer := 0;
		n_fa : integer := 0;
		nbit_in : integer := 1;
		nbit_out : integer := 1;
		carry_max : integer := 4);

port ( input : in std_logic_vector(nbit_in-1 downto 0);
		output : out std_logic_vector(nbit_out-1 downto 0);
		carry_out : out std_logic_vector(carry_max-1 downto 0)
);
end entity;

architecture struct of adder_gen is

component full_adder is
port ( in1, in2, cin : in std_logic;
	 sum : out std_logic;
	cout : out std_logic
);
end component;

component half_adder is
port ( in1, in2 : in std_logic;
		sum : out std_logic;
		cout : out std_logic	
);
end component;

begin

--generation of the full adders (if needed)
fa_gen : for k in 0 to n_fa-1 generate
fa_inst : full_adder port map( input(3*k), input(3*k+1), input(3*k+2), output(k), carry_out(k) );
end generate;

--generation of the half adder (if needed) with outputs after the fa's outputs
ha_gen : if n_ha = 1 generate
ha_inst : half_adder port map( input(3*n_fa), input(3*n_fa+1), output(n_fa), carry_out(n_fa) );
end generate;

--if there are some ha or fa generate the untouched bits here
gen_fa_ha_untouched: if n_fa /= 0 or n_ha /= 0 generate
	untouched_bits_gen : for n in (n_ha + n_fa) to nbit_out-1 generate
							output(n) <= input(3*n_fa + 2*n_ha + n - n_ha - n_fa);
						end generate;
end generate;

--if no adders have been generated then all the bits go out untouched
gen_untouched : if n_fa = 0 and n_ha = 0 generate
				untouched_bits_gen1 : for n in 0 to nbit_out-1 generate
							output(n) <= input(n);
						end generate;
end generate;


end architecture;
