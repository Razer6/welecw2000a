-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : StoP_hc595-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-23
-- Last update: 2009-11-15
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

entity StoP_hc595 is
  port (
    iSD    : in  std_ulogic;
    iSCK   : in  std_ulogic;
    inSCLR : in  std_ulogic;
    iRCK   : in  std_ulogic;
    iG     : in  std_ulogic;
    oSD    : out std_ulogic;
    oQ     : out std_ulogic_vector (0 to 7));
end entity;

architecture RTL of StoP_hc595 is
  signal Reg   : std_ulogic_vector (0 to 7);
  signal Shift : std_ulogic_vector (0 to 7);
begin
  
  process (iSCK)
  begin
    if rising_edge(iSCK) then
      if inSCLR = '0' then
        Shift <= (others => '0');
      else
        Shift(0)               <= iSD;
        Shift(1 to Shift'high) <= Shift(0 to Shift'high-1);
      end if;
    end if;
  end process;

  process (iRCK)
  begin
    if rising_edge(iRCK) then
      Reg <= Shift;
    end if;
  end process;

  oSD <= Shift(Shift'high);
  oQ  <= Reg when iG = '0' else (others => 'Z');
  
  
end architecture;
