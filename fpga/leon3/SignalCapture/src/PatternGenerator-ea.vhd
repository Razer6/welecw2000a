-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : PatternGenerator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-04-17
-- Last update: 2009-04-17
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: For physical testing only
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
-- 2009-04-17  1.0
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pTrigger.all;
use DSO.pPolyphaseDecimator.all;

entity PatternGenerator is
  port (
    iClk         : in  std_ulogic;
    iResetAsync  : in  std_ulogic;
    iDownSampler : in  aDownSampler;
    iChannels    : in  natural range 0 to 3;
    oData        : out aTriggerData;
    oValid       : out std_ulogic);
end entity;

architecture RTL of PatternGenerator is
  type aR is record
               ValidCounter : unsigned(31 downto 0);
               ValidRef     : unsigned(31 downto 0);
               Strobe       : std_ulogic;
               Counter      : signed(31 downto 0);
             end record;
  signal R : aR;
begin
  
  process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      R <= (
        ValidCounter => (others => '0'),
        ValidRef     => (others => '0'),
        Strobe       => '0',
        Counter      => (others => '0'));
      oData <= (others => (others => (others => '0')));
    elsif rising_edge(iClk) then
      for i in 0 to cDecimationStages-1 loop
        R.ValidRef((i+1)*4-1 downto (i)*4+1) <=
          unsigned(iDownSampler.Stages((i+1)*4-1 downto i*4+1));
      end loop;

      R.ValidCounter <= R.ValidCounter - to_unsigned(1, R.ValidCounter'length);
      R.Strobe       <= '0';
      if to_integer(R.ValidCounter) = 0 then
        R.ValidCounter <= R.ValidRef;
        R.Strobe       <= '1';
      end if;
      oValid    <= R.Strobe;
      R.Counter <= R.Counter + 1;

      for i in 0 to 3 loop
        case iChannels is
          when 0 =>                     -- 1 Ch
            oData(i) <= (others => aByte(R.Counter(7 downto 0)));
          when 1 =>
            case i is
              when 0 | 2 =>
                oData(i) <= (others => aByte(R.Counter(15 downto 8)));
              when 1 | 3 =>
                oData(i) <= (others => aByte(R.Counter(7 downto 0)));
            end case;
          when others =>
            oData(i) <= (others =>
                         aByte(R.Counter((4-i)*8-1 downto (3-i)*8)));
        end case;
      end loop;
    end if;
  end process;
end architecture;

