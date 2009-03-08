-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : StrobeGen-Rtl-a.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-14
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Strobe Generator with a synchronous Reset 
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
-- 2009-02-14  1.0      
-------------------------------------------------------------------------------


architecture Rtl of StrobeGen is
  constant BitWidth : natural                       := LogXY((gClkFrequency/gStrobeFrequency),2);
  signal   Strobe   : std_ulogic;
  signal   Count    : unsigned(BitWidth-1 downto 0);
  constant MaxCount : unsigned(BitWidth-1 downto 0) := TO_UNSIGNED((gClkFrequency/gStrobeFrequency)-1, BitWidth);
begin  -- architecture Rtl
  oStrobe <= Strobe;
  SG : process (iClk, iResetAsync) is
  begin
    if (iResetAsync = cResetActive) then
      Count  <= MaxCount;
      Strobe <= '0';
    elsif (iClk'event and iClk = '1') then
      if (Count = 0) or iResetSync = '1' then
        Count <= MaxCount;
      else
        Count <= Count - 1;
      end if;
      if Count = 0 then
        Strobe <= '1';
      else
        Strobe <= '0';
      end if;
    end if;
  end process SG;
end architecture Rtl;
