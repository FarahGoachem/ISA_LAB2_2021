library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use STD.textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    clk   : in std_logic;
    Din   : in std_logic_vector(31 downto 0));
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (clk)
    file res_fp : text open WRITE_MODE is "./fp_prod.hex";
    variable line_out : line;    
  begin  -- process
                -- asynchronous reset (active low)
 if clk'event and clk = '1' then  -- rising clock edge
        hwrite(line_out, std_logic_vector(signed(Din)));
        writeline(res_fp, line_out);
    end if;
  end process;

end beh;
