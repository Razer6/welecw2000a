-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PtoS_HCT165-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-23
-- Last update: 2009-03-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2008, Alexander Lindert
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
--  For commercial applications where source-code distribution is not
--  desirable or possible, I offer low-cost commercial IP licenses.
--  Please contact me per mail.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version 
-- 2009-03-23  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity PtoS_hct165 is
  port (
    iSD  : in  std_ulogic;
    iCK  : in  std_ulogic;
    inCE : in  std_ulogic;
    inPL : in  std_ulogic;
    iPD  : in  std_ulogic_vector(0 to 7);
    oQ   : out std_ulogic;
    onQ  : out std_ulogic);
end entity;

architecture RTL of PtoS_hct165 is
  signal Shift : std_ulogic_vector (0 to 7);
  
begin
  
  process (iCK, inPL)
  begin
    if inPL = '0' then
      Shift <= iPD;
    elsif rising_edge(iCK) then
      if inCE = '0' then
        Shift(0)               <= iSD;
        Shift(1 to Shift'high) <= Shift(0 to Shift'high-1);
      end if;
    end if;
  end process;

  oQ  <= Shift(Shift'high);
  onQ <= not Shift(Shift'high);
  
end architecture;
