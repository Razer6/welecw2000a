-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchTopDownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-17
-- Last update: 2009-07-06
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
-- 2008-08-17  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use work.pShortInputValues.all;
use work.WaveFiles.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  signal   Clk125                  : std_ulogic            := '1';
  signal PrevValid : std_ulogic;
  signal   Clk1000                 : std_ulogic            := '1';
  signal   ResetAsync              : std_ulogic            := cResetActive;
  signal   Input                   : aAllData;
  signal   Output                  : aLongAllData;
  signal   DrawInput, DrawAliasing : aValue;
  signal   DrawOutput              : aLongValue;
  signal   Valid                   : std_ulogic;
  signal k : natural;
  signal OutputData : aLongAllData;
  constant M                       : aInputValues(0 to 10) :=
    (0 => 1e9, 1 => 500e6, 2 => 250e6, 3 => 100e6, 4 => 50e6,
     5 => 25e6, 6 => 10e6, 7 => 5e6, 8 => 2500e3, 9 => 1e6, 10 => 500e3);
  constant cSimClks : aInputValues(0 to 10) :=
    (0 => 30, 1 => 60, 2 => 150, 3 => 300, 4 => 600,
     5 => 1500, 6 => 3e3, 7 => 6e3, 8 => 15e3, 9 => 30e3, 10 => 300e3);
  signal Control           : aDownSampler;
  signal i                 : natural range 0 to cCoefficients-1;
  signal j                 : natural;
  signal DrawCounter       : natural range 0 to cCoefficients-1;
  signal DrawValid         : std_ulogic;
  signal Drawed            : natural := 0;
  signal LowSpeedData      : aLongValues(0 to cChannels-1);
  signal LowSpeedDataValid : std_ulogic;
  

  function to_Stages(fs : natural) return std_ulogic_vector is
    variable vRet       : std_ulogic_vector((cDecimationStages*4)-1 downto 0);
    variable Ret : std_ulogic_vector((cDecimationStages*4)-1 downto 0) := X"111111";
    variable Stage      : natural := 0;
    variable M          : std_ulogic_vector(3 downto 0);
    variable Decimation : natural := 1e9/fs;
  begin
    loop
      if (Decimation >= 10) then
        Ret((Stage+1)*4-1 downto Stage*4) := X"A";
      else
        case Decimation is
          when 2 => Ret((Stage+1)*4-1 downto Stage*4) := X"2";
          when 4 => Ret((Stage+1)*4-1 downto Stage*4) := X"4";
          when 8 =>
            if Stage = 0 then
              Ret((Stage+1)*4-1 downto Stage*4) := X"8";
            else
              Ret((Stage+1)*4-1 downto Stage*4) := X"A";
            end if;
          when others => Ret((Stage+1)*4-1 downto Stage*4) := X"A";
        end case;
        vRet := Ret;
        return vRet;
      end if;
      Decimation := Decimation/10;
      Stage     := Stage +1;
    end loop;
  end;


begin
  
  LowSpeedData      <= (others => (others => '0'));
  LowSpeedDataValid <= '0';

  DUT : entity DSO.TopDownSampler
    port map (
      iClk        => Clk125,
      iResetAsync => ResetAsync,
      iADC        => Input,             -- fixpoint 1.x range -0.5 to 0.5
      iData       => LowSpeedData,
      iValid      => LowSpeedDataValid,
      iCPU        => Control,
      oData       => Output,            -- fixpoint 1.x range -1 to <1
      oValid      => Valid);

  Clk125  <= not Clk125  after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!
  Clk1000 <= not Clk1000 after 1 us / 2;

  stimuli : process
  begin
    Control.Stages   <= to_stages(1e9);
    Input                <= (others => (others => (others => '0')));
    Control.EnableFilter <= (others => '0');
    wait for 8 us;
    ResetAsync           <= not cResetActive;

    for e in 0 to 4 loop
      Control.EnableFilter <= std_ulogic_vector(to_signed(-e, Control.EnableFilter'length));
      for d in M'range loop
        Control.Stages <= to_stages(M(d));
        for i in 0 to cSimClks(d) loop
          Input(0) <= (others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
        end loop;
--        Input(0)(0)               <= to_signed(-1*2**7, cBitWidth);
--        Input(0)(1 to Input'high) <= (others => (others => '0'));
--        wait until Clk125 = '1';
        for i in 0 to cSimClks(d) loop
          Input(0) <= (others => to_signed(-1*2**7, cBitWidth));
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;

--    for e in 0 to 3 loop
--       Control.EnableFilter <= std_ulogic_vector(to_signed(-e, Control.EnableFilter'length));
--      for d in M'range loop
--        Control.SampleTime <= M(d);
--        for i in 0 to cShortInputValues'length/cCoefficients-1 loop
--          for j in 0 to cCoefficients-1 loop
--            Input(0)(j) <= to_signed(cShortInputValues(i*cCoefficients+j), cBitWidth);
--          end loop;
--          wait until Clk125 = '1';
--        end loop;
--      end loop;
--    end loop;
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  Display : process (Clk1000, ResetAsync)
    variable vValid : std_ulogic := '0';
  begin
    if ResetAsync = cResetActive then
      i           <= 0;
      j           <= 0;
      DrawCounter <= 0;
      vValid      := '0';
    elsif rising_edge(Clk1000) then
      i         <= (i+1) mod cCoefficients;
      DrawInput <= Input(0)(i);
  --    case Control.Stages(3 downto 0) is
  --      when X"8" | X"A" =>
  --        DrawValid <= StageValid;
  --        if StageValid = '1' then
  --          DrawOutput <= StageData(15 downto 0);
  --        end if;
  --        DrawValid <= '0';
  --      when others =>

          if k /= 0 then
            k <= k -1;
          end if;
          if k = 0 then
            if j = 7 then
              DrawValid <= '0';
            end if;
            case Control.Stages(3 downto 0) is
              when X"1"     => k <= 0;
              when X"2"     => k <= 1;
              when others => k <= 3;
            end case;
            j <= (j + 1) mod 8;
          end if;

          PrevValid <= Clk125;
          if Valid = '1' and Clk125 = '1' and PrevValid = '0' then
            OutputData <= Output;
            i          <= 0;
            j          <= 0;
            case Control.Stages(3 downto 0) is
              when X"1"  => k <= 0;
              when X"2"  => k <= 1;
              when X"4"  => k <= 3;
              when X"8"  => k <= 7;
              when others => k <= 9;
            end case;
            DrawValid <= '1';
          end if;

          if DrawValid = '1' then
            DrawOutput <= OutputData(0)(j);
          end if;
 --     end case;
    end if;
    
  end process;

end architecture;
