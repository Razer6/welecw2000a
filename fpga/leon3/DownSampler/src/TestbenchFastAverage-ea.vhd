-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchSingleDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-10
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
-- 2008-08-10  1.0    
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
  signal Clk125                              : std_ulogic                := '1';
  signal Clk1000                             : std_ulogic                := '1';
  signal ResetAsync                          : std_ulogic                := cResetActive;
  signal Input, Output                       : aFastData;
  signal StageData                           : aLongValue;
  signal StageValid                          : std_ulogic;
  signal DrawInput, DrawOutput, DrawAliasing : aValue;
  signal Valid                               : std_ulogic;
  signal M                                   : aM(0 to 3)                := (0 => M1, 1 => M2, 2 => M4, 3 => M10);
  signal Decimator                           : aDecimator;
  signal i, DrawCounter                      : natural range 0 to cCoefficients-1;
  signal DrawValid                           : std_ulogic;
  signal j, k                                : natural;
  signal prevValid                           : std_ulogic_vector(0 to 2);
  signal OutputData : aFastData;
begin
  
  DUT : entity DSO.FastAverage
    port map (
      iClk        => Clk125,
      iResetAsync => ResetAsync,
      iDecimator  => Decimator,
      iData       => Input,             -- fixpoint 1.x range -0.5 to 0.5
      oData       => Output,            -- fixpoint 1.x range -1 to <1
      oValid      => Valid,
      oStageData  => StageData,
      oStageValid => StageValid);

  Clk125  <= not Clk125  after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!
  Clk1000 <= not Clk1000 after 1 us / 2;

  stimuli : process
  begin
    Decimator  <= M1;
    Input      <= (others => (others => '0'));
    wait for 4 us;
    ResetAsync <= not cResetActive;

    for d in M'range loop
      Decimator              <= M(d);
      Input(0)               <= to_signed(-1*2**7, cBitWidth);
      Input(1 to Input'high) <= (others => (others => '0'));
      wait until Clk125 = '1';
      for i in 0 to 200 loop
        Input <= (others => to_signed(i, cBitWidth));
        wait until Clk125 = '1';
      end loop;
    end loop;

    for d in M'range loop
      Decimator <= M(d);
      for i in 0 to 6 loop
        Input <= (others => to_signed(-1*2**7, cBitWidth));
        wait until Clk125 = '1';
      end loop;
      for j in 0 to 20 loop
        Input <= (others => to_signed(0, cBitWidth));
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
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  with Decimator select k <=
    1 when M1,
    2 when M2,
    4 when others;
  
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
        when M10 =>
          DrawValid <= StageValid;
          if StageValid = '1' then
            DrawOutput <= StageData(17 downto 9);
          end if;
        when others =>
          if Valid = '1' then
            OutputData <= Output;
          end if;
          DrawValid <= '0';
          j         <= (j + 1);
           if j >= k then
            DrawCounter <= (DrawCounter +1) mod cCoefficients;
            j           <= 1;
            DrawValid   <= '1';
            --     DrawOutput  <= Output(DrawCounter);
           end if;
          if PrevValid(0 to 1) = "10" then
            DrawCounter <= 1;
            end if;
          if PrevValid(1 to 2) = "10" then
          --  DrawCounter <= 1;
            j           <= 1;
          end if;
          PrevValid(0) <= Valid;
          PrevValid(1 to 2) <= PrevValid(0 to 1);

          if DrawValid = '1' then
            DrawOutput <= OutputData(DrawCounter);
          end if;
      end case;
    end if;
    
  end process;
end architecture;


