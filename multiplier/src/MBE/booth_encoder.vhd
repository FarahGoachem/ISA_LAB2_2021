library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity booth_encoder is
port ( multiplicand : in std_logic_vector(nbit -1 downto 0);
		multiplier : in std_logic_vector(nbit -1 downto 0);
		partial_prod_out : out partial_prod_out_array
);
end entity;

architecture struct of booth_encoder is 

component booth_mux is
port ( enc : in std_logic_vector(encoding_bits-1 downto 0);
		multiplicand : in std_logic_vector(nbit-1 downto 0);
		partial_prod : out std_logic_vector(nbit downto 0)
);
end component;

signal muxes_out : partial_prod_array;

type mul_enc_array is array(0 to nbit/2) of std_logic_vector(encoding_bits-1 downto 0);
signal mul_enc : mul_enc_array;

--type partial_prod_array is array (0 to nbit/2) of std_logic_vector(2*nbit-1 downto 0);
signal partial_prod : partial_prod_array;

begin

--first encoding
mul_enc(0)(0) <= '0';
mul_enc(0)(1) <= multiplier(0);
mul_enc(0)(2) <= multiplier(1);

--intermediate encodings
encoding_gen : for i in 1 to nbit/2-1 generate
	mul_enc(i) <= multiplier(2*i+1 downto 2*i-1);
end generate;

--last encoding
mul_enc(nbit/2)(0) <= multiplier(nbit-1);
mul_enc(nbit/2)(1) <= '0';
mul_enc(nbit/2)(2) <= '0';

--generation of muxes for encoding
muxes_gen : for i in 0 to nbit/2 generate
muxes_inst : booth_mux port map (mul_enc(i), multiplicand, muxes_out(i));
end generate;

--first partial product out:
partial_prod_out(0)(nbit+3 downto 0) <= (not multiplier(1)) & multiplier(1) & multiplier(1) & muxes_out(0);

--intermediate partial prod out
prod_out_gen : for i in 1 to nbit/2-2 generate
prod_out_inst : 	partial_prod_out(i)((nbit+3+(2*i-1)) downto 2*(i-1)) <= '1' & (not mul_enc(i)(encoding_bits-1)) & muxes_out(i) & '0' & mul_enc(i-1)(encoding_bits-1);
end generate;

--last 2 partial prod out
partial_prod_out(nbit/2-1)(2*nbit-1 downto (nbit-4)) <=  (not mul_enc(nbit/2-1)(encoding_bits-1)) & muxes_out(nbit/2-1) & '0' & mul_enc(nbit/2-2)(encoding_bits-1);
partial_prod_out(nbit/2)(2*nbit-1 downto (nbit-3)) <= muxes_out(nbit/2) & '0' & mul_enc(nbit/2-1)(encoding_bits-1);
end architecture;
