library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity full_adder is
port ( in1, in2, cin : in std_logic;
	 sum : out std_logic;
	cout : out std_logic
);
end entity;

architecture behav of full_adder is
begin
sum <= cin xor (in1 xor in2);
cout <= (in1 and in2) or (in1 and cin) or (in2 and cin);
end architecture;
