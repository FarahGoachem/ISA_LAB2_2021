library ieee;
use ieee.std_logic_1164.all;
use WORK.packg.all;

entity half_adder is
port ( in1, in2 : in std_logic;
		sum : out std_logic;
		cout : out std_logic	
);
end entity;

architecture behav of half_adder is
begin

sum <= in1 xor in2;
cout <= in1 and in2;
end architecture;
