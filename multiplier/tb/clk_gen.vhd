library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port (
    clk     : out std_logic);
end clk_gen;

architecture beh of clk_gen is

  constant Ts : time := 10 ns;
  
  signal clk_i : std_logic := '0';
  
begin  -- beh

  process
  begin  -- process
    if (clk_i = 'U' or clk_i = 'X') then
      clk_i <= '0';
    else
      clk_i <= not(clk_i);
    end if;
    wait for Ts/2;
  end process;

clk <= clk_i;


end beh;
