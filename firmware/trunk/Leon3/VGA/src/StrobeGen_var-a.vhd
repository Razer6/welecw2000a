-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : StrobeGen_var-a.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-14
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
-- 2009-02-14  1.0      
-------------------------------------------------------------------------------



architecture Rtl of StrobeGen_var is
  signal Strobe    : std_ulogic;
  signal Count     : unsigned(gBitWidth-1 downto 0);
  signal Reference : unsigned(gBitWidth-1 downto 0);
begin  -- architecture Rtl
  oStrobe  <= Strobe;
  oCounter <= Count;
  SG : process (iClk, iResetAsync) is
  begin
    if (iResetAsync = cResetActive) then
      Count     <= (others => '0');
      Reference <= (others => '1');
      Strobe    <= '0';
    elsif rising_edge(iClk) then
      Reference <= iReference;
      if (Count = Reference and iCountEnable = '1') or iResetSync = '1' then
        Count <= (others => '0');
      elsif iCountEnable = '1' then
        Count <= Count + 1;
      else
        Count <= Count;
      end if;
      if Count = Reference and iCountEnable = '1' then
        Strobe <= '1';
      else
        Strobe <= '0';
      end if;
    end if;
  end process SG;
end architecture Rtl;
