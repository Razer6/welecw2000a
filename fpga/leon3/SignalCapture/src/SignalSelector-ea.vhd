-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SignalSelector-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
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
-- 2009-02-14  1.0      
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pTrigger.all;

entity SignalSelector is
  port (
    iClk                 : in  std_ulogic;
    iResetAsync          : in  std_ulogic;
    iSignalSelector      : in  aSignalSelector;
    iData                : in  aLongAllData;  
    iValid               : in  std_ulogic;
    oData                : out aTriggerData;  -- 8 bit values
    oValid               : out std_ulogic);
end entity;

architecture RTL of SignalSelector is
  signal Data  : aTriggerData;
  signal Valid : std_ulogic_vector(8 to 9);
begin
  
  oValid <= Valid(Valid'high);
  oData  <= Data;

  process (iClk, iResetAsync)
    variable vTriggerCh : natural;
  begin
    if iResetAsync = cResetActive then
      Data                 <= (others => (others => (others => '0')));
      Valid                <= (others => '0');
    elsif rising_edge(iClk) then

      Valid <= iValid & Valid(Valid'low to Valid'high-1);

      for i in 0 to cChannels-1 loop
        for j in 0 to cCoefficients-1 loop
          vTriggerCh := to_integer(unsigned(iSignalSelector(i)(1 downto 0)));
          if is_x(std_ulogic_vector(iData(vTriggerCh)(j))) = true then
            Data(i)(j) <= (others => '0');
          else
            if iSignalSelector(i)(2) = '0' then
              Data(i)(j) <= std_ulogic_vector(iData(vTriggerCh)(j)(cBitwidth*2-1 downto cBitwidth*2-aByte'length));
            else
              --         if is_x(std_ulogic_vector(iDataL(vTriggerCh)(j))) = true then
              --           Data(i)(j) <= (others => '0');
              --         else
              Data(i)(j) <= std_ulogic_vector(iData(vTriggerCh)(j)(cBitwidth*2-aByte'length-1 downto (cBitwidth-aByte'length)*2));
              --         end if;
            end if;
          end if;
        end loop;
      end loop;
    end if;
  end process;
end architecture;
