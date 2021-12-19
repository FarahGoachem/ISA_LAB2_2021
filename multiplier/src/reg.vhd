LIBRARY ieee;
use ieee.std_logic_1164.all;

entity reg is
generic (nbit : integer := 32);
port ( din : std_logic_vector(nbit-1 downto 0);
	clk, en, rst_n : in std_logic;
	dout : out std_logic_vector(nbit-1 downto 0)
);
end entity;


architecture behav of reg is

signal dout_sig : std_logic_vector(nbit-1 downto 0);

begin

proc : process(clk, rst_n)
	begin
		if (rst_n = '0') then
			dout <= (others => '0');
		else
			if (clk'event and clk = '1') then
					if (en = '1') then
						dout <= din;
					end if;
			end if;
		end if;
end process;



end architecture;
