
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
  generic (
    gAddrWidth : integer := 14);
  port (
    iClk  : in  std_ulogic;
    oData : out std_ulogic_vector(31 downto 0);
    iAddr : in  std_ulogic_vector(31 downto 0));
end entity;

architecture Rtl of ROM is
  subtype aDataVec is std_ulogic_vector(31 downto 0);
  type    aMem is array (2**gAddrWidth-1 downto 0) of aDataVec;

  constant mem : aMem := (
