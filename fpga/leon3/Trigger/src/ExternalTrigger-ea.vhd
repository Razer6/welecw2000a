-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : ExternalTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-28
-- Last update: 2009-03-04
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
-- 2008-08-28  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;

entity ExternalTrigger is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iValid      : in  std_ulogic;
    iExtTrigger : in  std_ulogic;
    oLHStrobe   : out std_ulogic;
    oHLStrobe   : out std_ulogic;
    oHigh       : out std_ulogic);
end entity;

architecture RTL of ExternalTrigger is
  signal Prev : std_ulogic;
  
begin
  
  process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      oLHStrobe <= '0';
      oHLStrobe <= '0';
      Prev      <= '0';
    elsif rising_edge(iClk) then
      if iValid = '1' then
        Prev <= iExtTrigger;
      end if;
      oHLStrobe <= (not iExtTrigger) and Prev;
      oLHStrobe <= iExtTrigger and (not Prev);
    end if;
  end process;

  oHigh <= Prev;
  
end architecture;

