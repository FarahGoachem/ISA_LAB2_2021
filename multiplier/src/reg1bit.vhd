LIBRARY ieee;
use ieee.std_logic_1164.all;

entity reg1bit is
port ( din : std_logic;
	clk, en, rst_n : in std_logic;
	dout : out std_logic
);
end entity;


architecture behav of reg1bit is

begin

proc : process(clk, rst_n)
	begin
		if (rst_n = '0') then
			dout <= ('0');
		else
			if (clk'event and clk = '1') then
					if (en = '1') then
						dout <= din;
					end if;
			end if;
		end if;
end process;



end architecture;
