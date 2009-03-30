-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : NormalTrigger-ea.vhd
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
use DSO.pTrigger.all;

entity NormalTrigger is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iValid      : in  std_ulogic;
    iData       : in  aBytes(0 to cCoefficients-1);
    iLowValue   : in  aByte;
    iLowTime    : in  aWord;
    iHighValue  : in  aByte;
    iHighTime   : in  aWord;
    oLHStrobe   : out aTrigger1D;
    oHLStrobe   : out aTrigger1D;
    oHigh       : out aTrigger1D);
end entity;


architecture RTL of NormalTrigger is
  signal High    : std_ulogic_vector(0 to cCoefficients-1);
  signal Prev    : std_ulogic_vector(0 to cCoefficients-1);
  signal Counter : aWord;
begin
  
  process (iClk, iResetAsync)

  begin
    if iResetAsync = cResetActive then
      oLHStrobe <= (others => '0');
      oHLStrobe <= (others => '0');
      High      <= (others => '0');
      Prev      <= (others => '0');
      Counter   <= (others => '0');
    elsif rising_edge(iClk) then
      if iValid = '1' then
        Prev <= High;
        for i in 0 to cCoefficients-1 loop
          if High(i) = '1' then
            if signed(iData(i)) < signed(iLowValue) then
              High(i) <= '0';
            end if;
          else
            if signed(iData(i)) > signed(iHighValue) then
              High(i) <= '1';
            end if;
          end if;
        end loop;
      end if;
      if (Prev = X"00" or Prev = X"FF") and to_integer(unsigned(Counter)) /= 0 then
        Counter <= std_ulogic_vector(unsigned(Counter) - to_unsigned(1, Counter'length));
      end if;
      if to_integer(unsigned(Counter)) = 0 then
        oLHStrobe(0) <= (not Prev(cCoefficients-1)) and High(0);
        oHLStrobe(0) <= Prev(cCoefficients-1) and (not High(0));
        for i in 1 to cCoefficients-1 loop
          -- oHLStrobe(i) <= (not High(i)) and Prev(i);
          -- oLHStrobe(i) <= High(i) and (not Prev(i));
          oLHStrobe(i) <= (not High(i-1)) and High(i);
          oHLStrobe(i) <= High(i-1) and (not High(i));
        end loop;
        if Prev = X"00" and High /= X"00" then
          Counter <= iHighTime;
        elsif Prev = X"FF" and High /= X"FF" then
          Counter <= iLowTime;
        end if;
      end if;
    end if;
  end process;

  oHigh <= High;
  
end architecture;
