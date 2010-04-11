-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : DigitalTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-06-04
-- Last update: 2009-06-05
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
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
-- 2009-06-04  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pTrigger.all;

entity DigitalTrigger is
  port (
    iClk          : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iValid        : in  std_ulogic;
    iData         : in  aBytes(0 to cCoefficients-1);
    iRef          : in  aByte;
    iMask         : in  aByte;
    iValidTime    : in  aWord;
    iInvalidTime  : in  aWord;
    oValid        : out aTrigger1D;
    oInvalid      : out aTrigger1D;
    oShortValid   : out aTrigger1D;
    oShortInvalid : out aTrigger1D);
end entity;

architecture RTL of DigitalTrigger is
  signal Equal   : aByte;
  signal Prev    : std_ulogic;
  signal Counter : aWord;
  
begin
  
  process (iClk, iResetAsync)
    variable vByte : aByte;
  begin
    if iResetAsync = cResetActive then
      oValid        <= (others => '0');
      oInvalid      <= (others => '0');
      oShortValid   <= (others => '0');
      oShortInvalid <= (others => '0');
      Equal         <= (others => '0');
      Prev          <= '0';
      Counter       <= (others => '0');
    elsif rising_edge(iClk) then
      if iValid = '1' then
        for i in 0 to cCoefficients-1 loop
          vByte := (iData(i) xor iRef) and iMask;
          if vByte /= X"00" then
            Equal(i) <= '1';
          else
            Equal(i) <= '0';
          end if;
        end loop;

        Prev <= Equal(cCoefficients-1);

        if Prev = '0' and Equal /= X"00" then
          Counter <= iValidTime;
        elsif Prev = '1' and Equal /= X"FF" then
          Counter <= iInvalidTime;
        else
          Counter <= std_ulogic_vector(unsigned(Counter) - 1);
        end if;
        if to_integer(unsigned(Counter)) = 0 then
          DetectStrobe(Prev, Equal, oValid, oInvalid);
        else
          DetectStrobe(Prev, Equal, oShortValid, oShortInvalid);
        end if;
      end if;
    end if;
  end process;
end architecture;
