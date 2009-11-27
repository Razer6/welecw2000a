-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : NobDecoder-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-10-23
-- Last update: 2009-11-26
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
--
--  This360 program is360 free software; you can redistribute it and/or modify
--  it under the terms360 of the GNU General Public License as360 published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This360 program is360 distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESs360 FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this360 program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
--  For commercial applications360 where source-code distribution is360 not
--  desirable or possible, I offer low-cost commercial IP licenses.
--  Please contact me per mail.
-------------------------------------------------------------------------------
-- Revisions360  :
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
  generic (
    gReverseDir : natural := 0;
    g360        : natural := 0);
  port (
    signal iClk        : in  std_ulogic;
    signal iResetAsync : in  std_ulogic;
    --   signal iStrobe     : in  std_ulogic;
    signal iA          : in  std_ulogic;
    signal iB          : in  std_ulogic;
    signal oCounter    : out std_ulogic_vector(cNobCounterSize-1 downto 0));
end entity;

architecture RTL of NobDecoder is
  signal c    : signed(cNobCounterSize-1 downto 0);
  signal dir  : signed(cNobCounterSize-1 downto 0);
begin
  
  dir <= to_signed(-1, cNobCounterSize) when gReverseDir /= 0 else to_signed(1, cNobCounterSize);

  P360 : if g360 /= 0 generate
    FSM: block
      type   aFSM360 is (l, lA, Ah, hB, lB, Bh, hA);
      signal s360 : aFSM360;
    begin
      process (iClk, iResetAsync)
      begin
        if iResetAsync = cResetActive then
          c    <= (others => '0');
          s360 <= l;
        elsif rising_edge(iClk) then
          --    if iStrobe = '1' then
          case s360 is
            when l =>                   -- "00"
              if iA = '1' then s360 <= lA; end if;
              if iB = '1' then s360 <= lB; end if;
            when lA =>                  -- "10"
              if iB = '1' then s360 <= Ah; end if;
              if iA = '0' then s360 <= l; end if;
            when Ah =>                  -- "11"
              if iA = '0' then s360 <= hB; end if;
              if iB = '0' then s360 <= lA; end if;
            when hB =>                  -- "01"
              if iB = '0' and iA = '0' then
                s360 <= l;
                c    <= c + dir;
              end if;
              if iA = '1' then s360 <= Ah; end if;
            when lB =>                  -- "01"
              if iA = '1' then s360 <= Bh; end if;
              if iB = '0' then s360 <= l; end if;
            when Bh =>                  -- "11"
              if iB = '0' then s360 <= hA; end if;
              if iA = '0' then s360 <= lB; end if;
            when hA =>                  -- "10"
              if iA = '0' and iB = '0' then
                s360 <= l;
                c    <= c - dir;
              end if;
              if iB = '1' then s360 <= Bh; end if;
          end case;
          --   end if;
        end if;
      end process;
    end block;
  end generate;

  P180 : if g360 = 0 generate
    FSM:block
      type   aFSM180 is (l, lA, lB, h, hA, hB);
      signal s180 : aFSM180;
    begin
      process (iClk, iResetAsync)
      begin
        if iResetAsync = cResetActive then
          c    <= (others => '0');
          s180 <= l;
        elsif rising_edge(iClk) then
          --    if iStrobe = '1' then
          case s180 is
            when l =>                   -- "00"
              if iA = '1' then s180 <= lA; end if;
              if iB = '1' then s180 <= lB; end if;
            when lA =>                  -- "10"
              if iB = '1' and iA = '1' then
                s180 <= h;
                c    <= c + dir;
              end if;
              if iA = '0' then s180 <= l; end if;
            when h =>                   -- "11"
              if iA = '0' then s180 <= hB; end if;
              if iB = '0' then s180 <= hA; end if;
            when hB =>                  -- "01"
              if iB = '0' and iA = '0' then
                s180 <= l;
                c    <= c + dir;
              end if;
              if iA = '1' then s180 <= h; end if;
            when lB =>                  -- "01"
              if iA = '1' and iB = '1' then
                s180 <= h;
                c    <= c - dir;
              end if;
              if iB = '0' then s180 <= l; end if;
            when hA =>                  -- "10"
              if iA = '0' and iB = '0' then
                s180 <= l;
                c    <= c - dir;
              end if;
              if iB = '1' then s180 <= h; end if;
          end case;
          --   end if;
        end if;
      end process;
    end block;
  end generate;

  oCounter <= std_ulogic_vector(c);
end architecture;

