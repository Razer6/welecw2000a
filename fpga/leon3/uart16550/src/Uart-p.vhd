library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Global.all;

package puart is
  -- constant cUART_BUS_WIDTH_8 : natural := 8;
  constant cUART_ADDR_WIDTH : natural := 5;
  constant cUART_DATA_WIDTH : natural := 32;

  type aCPUtoUart is record
                       Addr    : std_ulogic_vector(cUART_ADDR_WIDTH-1 downto 0);
                       Data    : std_ulogic_vector(cUART_DATA_WIDTH-1 downto 0);
                       WriteEn : std_ulogic;
                     end record;
  
  type aUarttoCPU is record
                       Data      : std_ulogic_vector(cUART_DATA_WIDTH-1 downto 0);
                       ACK       : std_ulogic;
                       Interrupt : std_ulogic;
                     end record;
  
end;

