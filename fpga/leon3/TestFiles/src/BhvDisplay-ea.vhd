
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.Global.all;
use DSO.pVGA.all;

entity BhvDisplay is
  generic  (
    gGenVGA : acGenVGA);
    port  (
      iDCLK : in std_ulogic;
      iHD  : in std_ulogic;
      iVD  : in std_ulogic;
      iDENHD : in std_ulogic;
      iDENVD : in std_ulogic;
      iRed  : in std_ulogic_vector(cGenVga.BitsPerColor-1 downto 0);
      iGreen : in std_ulogic_vector(cGenVga.BitsPerColor-1 downto 0);
      iBlue  : in std_ulogic_vector(cGenVga.BitsPerColor-1 downto 0));
end entity;

architecture bhv of BhvDisplay is
begin
end architecture;
