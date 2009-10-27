-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : NobDecoder-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-10-23
-- Last update: 2009-10-27
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
-- 2009-10-23  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pLedsKeysAnalogSettings.all;

entity NobDecoder is
  generic (gReverseDir : natural := 0);
  port (
    signal iClk        : in  std_ulogic;
    signal iResetAsync : in  std_ulogic;
    signal iStrobe     : in  std_ulogic;
    signal iUnstable   : in  std_ulogic;
    signal iStable     : in  std_ulogic;
    signal oCounter    : out std_ulogic_vector(cNobCounterSize-1 downto 0));
end entity;

architecture RTL of NobDecoder is
  signal c      : unsigned(cNobCounterSize-1 downto 0);
  signal Stable : std_ulogic_vector(1 downto 0);
  signal dir    : std_ulogic;
begin
  
  Stable(0) <= iStable;
  dir       <= not iUnstable when gReverseDir /= 0 else iUnstable;

  process (iClk, iResetAsync)

  begin
    if iResetAsync = cResetActive then
      c         <= (others => '0');
      Stable(1) <= '0';
    elsif rising_edge(iClk) then
      
      if iStrobe = '1' then
        Stable(1) <= iStable;

        case Stable is
          when "01" =>
            case dir is
              when '0'    => c <= c + 1;
              when '1'    => c <= c - 1;
              when others =>
                assert false report "error in unstable detected!" severity error;
            end case;
          when "10" =>
            case dir is
              when '1'    => c <= c + 1;
              when '0'    => c <= c - 1;
              when others =>
                assert false report "error in unstable detected!" severity error;
            end case;
          when "00" | "11" =>
            null;
          when others =>
            -- assert false report "error in stable detected!" severity error;
            null;
        end case;
      end if;
    end if;
  end process;
  oCounter <= std_ulogic_vector(c);
end architecture;

