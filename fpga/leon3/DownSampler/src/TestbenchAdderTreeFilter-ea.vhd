-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : TestbenchAdderTreeFilter-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-07-05
-- Last update: 2009-07-06
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
-- 2009-07-05  1.0
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pShortInputValues.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  type   aM is array (natural range<>) of aDecimator;
  signal Clk125                  : std_ulogic  := '1';
  signal Clk1000                 : std_ulogic  := '1';
  signal ResetAsync              : std_ulogic  := cResetActive;
  signal Input                   : aFastData;
  signal StageData               : aLongValue;
  signal StageValid              : std_ulogic;
  signal DrawInput, DrawAliasing : aValue;
  signal DrawOutput              : aLongValue;
  signal Valid                   : std_ulogic;
  type   aDecimator8 is (M1, M2, M4, M8, M10);
  type   aM8 is array (natural range <>) of aDecimator8;
  signal M                       : aM8(0 to 4) := (0 => M1, 1 => M2, 2 => M4, 3 => M8, 4 => M10);
  signal Decimator               : aDecimator8;
  signal usDecimator             : std_ulogic_vector(3 downto 0);
  signal FilterDepth             : aFilterDepth;
  signal i, DrawCounter          : natural range 0 to cCoefficients-1;
  signal DrawValid               : std_ulogic;
  signal j, k                    : natural;
  signal prevValid               : std_ulogic_vector(0 to 2);
  signal OutputData, Output      : aLongFastData;
begin
  
  DUT : entity DSO.AdderTreeFilter
    port map (
      iClk         => Clk125,
      iResetAsync  => ResetAsync,
      iDecimator   => usDecimator,
      iFilterDepth => FilterDepth,
      iData        => Input,
      oData        => Output,
      oValid       => Valid,
      oStageData   => StageData,
      oStageValid  => StageValid);

  Clk125  <= not Clk125  after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!
  Clk1000 <= not Clk1000 after 1 us / 2;

  process (Decimator)
  begin
    case Decimator is
      when M1  => usDecimator <= X"1";
      when M2  => usDecimator <= X"2";
      when M4  => usDecimator <= X"4";
      when M8  => usDecimator <= X"8";
      when M10 => usDecimator <= X"A";
    end case;
  end process;


  stimuli : process
  begin
    Decimator  <= M1;
    Input      <= (others => (others => '0'));
    wait for 4 us;
    ResetAsync <= not cResetActive;

    for f in 0 to 3 loop
      FilterDepth <= f;

      for d in M'range loop
        Decimator <= M(d);
        for i in 0 to cCoefficients-1 loop
          for j in 0 to 21 loop
            Input <= (others => to_signed(0, cBitWidth));
            wait until Clk125 = '1';
          end loop;
--        for i in 0 to 6 loop
          Input <= (i => to_signed(-1*2**7, cBitWidth), others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
--      end loop;
          for j in 0 to 20 loop
            Input <= (others => to_signed(0, cBitWidth));
            wait until Clk125 = '1';
          end loop;
        end loop;
      end loop;

      for d in M'range loop
        Decimator              <= M(d);
--        Input(0)               <= to_signed(-1*2**7, cBitWidth);
--        Input(1 to Input'high) <= (others => (others => '0'));
--        wait until Clk125 = '1';
        for i in -128/cCoefficients to 127/cCoefficients loop
          for j in 0 to cCoefficients-1 loop
            Input(j) <= to_signed(i*cCoefficients +j, cBitWidth);
          end loop;
          wait until Clk125 = '1';
        end loop;
      end loop;

      for d in M'range loop
        Decimator <= M(d);
        for i in 0 to cShortInputValues'length/cCoefficients-1 loop
          for j in 0 to cCoefficients-1 loop
            Input(j) <= to_signed(cShortInputValues(i*cCoefficients+j), cBitWidth);
          end loop;
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  -- with Decimator select k <=
  -- 1 when M1,
  -- 2 when M2,
  -- 4 when others;

  Display : process (Clk1000, ResetAsync)
    -- variable vValid : std_ulogic_vector(0 to 1) := "00";
  begin
    if ResetAsync = cResetActive then
      i           <= 0;
      j           <= 1;
      --   k           <= 1;
      DrawCounter <= 0;
      PrevValid   <= "000";
    elsif rising_edge(Clk1000) then
      i         <= (i+1) mod cCoefficients;
      DrawInput <= Input(i);
      case Decimator is
        when M8 | M10 =>
          DrawValid <= StageValid;
          if StageValid = '1' then
            DrawOutput <= StageData(15 downto 0);
          end if;
          DrawValid <= '0';
        when others =>

          if k /= 0 then
            k <= k -1;
          end if;
          if k = 0 then
            if j = 7 then
              DrawValid <= '0';
            end if;
            case Decimator is
              when M1     => k <= 0;
              when M2     => k <= 1;
              when others => k <= 3;
            end case;
            j <= (j + 1) mod 8;
          end if;

          PrevValid(0) <= Clk125;
          PrevValid(1) <= PrevValid(0);
          if Valid = '1' and Clk125 = '1' and PrevValid(0) = '0' then
            OutputData <= Output;
            i          <= 0;
            j          <= 0;
            case Decimator is
              when M1     => k <= 0;
              when M2     => k <= 1;
              when others => k <= 3;
            end case;
            DrawValid  <= '1';
          end if;

          if DrawValid = '1' then
            DrawOutput <= OutputData(j);
          end if;
      end case;
    end if;
    
  end process;
end architecture;


