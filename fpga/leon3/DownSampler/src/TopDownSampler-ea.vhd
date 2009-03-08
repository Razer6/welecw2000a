-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopDownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-17
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
-- 2008-08-17  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
--use work.pInputValues.all;
use DSO.pPolyphaseDecimator.all;

entity TopDownSampler is
  generic (
    gUseStage0 : boolean := true);
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iADC        : in  aAllData;         -- fixpoint 1.x range -0.5 to 0.5
    iData       : in  aLongValues(0 to cChannels-1);
    iValid      : in  std_ulogic;
    iCPU        : in  aDownSampler;
    oData       : out aDownSampled;     -- fixpoint 1.x range -1 to <1
    oValid      : out std_ulogic);
end entity;

architecture RTL of TopDownSampler is
  type   aDecimatorBits is array (0 to cDecimationStages-1) of std_ulogic_vector(3 downto 0);
  signal DecimatorBits      : aDecimatorBits;
  signal Decimator          : aM(0 to cDecimationStages-1);
  signal Stage0AvgDecimator : aDecimator;
  signal StageData0         : aAllData;
  signal StageValid0        : std_ulogic_vector(0 to cChannels-1);
  signal StageInput         : aStagesOutCh;
  signal StageOutput        : aStagesInCh;
  signal ValidOut           : std_ulogic_vector(0 to cChannels-1);
  signal FastFirData        : aValues(0 to cChannels-1);
  type   aFirData is array (natural range <>) of aLongValues(0 to cChannels-1);
  signal FirDataIn          : aFirData(1 to cDecimationStages-2);
  signal FirDataOut         : aFirData(0 to cDecimationStages-1);
  signal AVGValid           : std_ulogic_vector(0 to cChannels-1);
  signal FirValid           : std_ulogic_vector(0 to cDecimationStages-1);
  signal DataOut            : aDownSampled;
  
begin
  
  C1In : process (StageInput)
  begin
    for i in 0 to cChannels-1 loop
      FastFirData(i) <= StageInput(i)(0).Data(cBitWidth*2-1 downto cBitWidth);
    end loop;
  end process;

  CIn : process(StageInput)
  begin
    for i in 0 to cChannels-1 loop
      for j in 1 to cDecimationStages-2 loop
        FirDataIn(j)(i) <= StageInput(i)(j).Data;
      end loop;
    end loop;
  end process;

  COut : process(FirDataOut, FirValid)
  begin
    for i in 0 to cChannels-1 loop
      for j in 0 to cDecimationStages-1 loop
        StageOutput(i)(j).Data  <= FirDataOut(j)(i);
        StageOutput(i)(j).Valid <= FirValid(j);
      end loop;
    end loop;
  end process;

  ParallelStage : if gUseStage0 = true generate
    FirValid(0) <= AvgValid(0);
    Stage0 : for i in 0 to cChannels-1 generate
      FastAvg : FastAverage
        port map (
          iClk        => iClk,
          iResetAsync => iResetAsync,
          iDecimator  => Stage0AvgDecimator,
          iData       => iADC(i),        -- fixpoint 1.x range -0.5 to 0.5
          oData       => StageData0(i),  -- fixpoint 1.x range -1 to <1
          oValid      => StageValid0(i),
          oStageData  => FirDataOut(0)(i),
          oStageValid => AvgValid(i));
    end generate;
  end generate;

  NoParallelStage : if gUseStage0 = false generate
    StageData0  <= (others => (others => (others => '0')));
    StageValid0 <= (others => '0');
    process (iData, iValid)
    begin
      for i in 0 to cChannels-1 loop
        FirDataOut(0)(i) <= iData(i);
        FirValid(0)      <= iValid;
      end loop;
    end process;
    --  AvgValid(i)   <= (others => iValid);
  end generate;

  Stage1 : entity DSO.TopFastPolyPhaseDecimator
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Decimator(1),
      iData       => FastFirData,
      iValid      => StageInput(0)(0).Valid,
      oData       => FirDataOut(1),
      oValid      => FirValid(1));

  Slow : for i in 2 to cDecimationStages-1 generate
    Stage : entity DSO.TopPolyPhaseDecimator
      port map (
        iClk        => iClk,
        iResetAsync => iResetAsync,
        iDecimator  => Decimator(i),
        iData       => FirDataIn(i-1),
        iValid      => StageInput(0)(i-1).Valid,
        oData       => FirDataOut(i),
        oValid      => FirValid(i));
  end generate;

  dBits : process (iCPU.Stages)
  begin
    for i in 0 to cDecimationStages-1 loop
      DecimatorBits(i) <= iCPU.Stages((i+1)*4-1 downto i*4);
    end loop;
  end process;

  M : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Decimator          <= (others => M1);
      Stage0AvgDecimator <= M10;
    elsif rising_edge(iClk) then
      Decimator          <= (others => M1);
      Stage0AvgDecimator <= M10;
      for i in 0 to cDecimationStages-1 loop
        case DecimatorBits(i) is
          when X"1"   => Decimator(i) <= M1;
          when X"2"   => Decimator(i) <= M2;
          when X"4"   => Decimator(i) <= M4;
          when X"A"   => Decimator(i) <= M10;
          when others => Decimator(i) <= M1;
        end case;
      end loop;
      if iCPU.EnableFilter(0) = '0' then
        Stage0AvgDecimator <= M1;
      else
        case DecimatorBits(0) is
          when X"1"   => Stage0AvgDecimator <= M1;
          when X"2"   => Stage0AvgDecimator <= M2;
          when X"4"   => Stage0AvgDecimator <= M4;
          when X"A"   => Stage0AvgDecimator <= M10;
          when others => Stage0AvgDecimator <= M1;
        end case;
      end if;
    end if;
  end process;



--  M : process (iClk, iResetAsync)
--  begin
--    if iResetAsync = cResetActive then
--      Decimator          <= (others => M1);
--      Stage0AvgDecimator <= M10;
--    elsif rising_edge(iClk) then
--      Decimator          <= (others => M1);
--      Stage0AvgDecimator <= M10;

--      case iCPU.SampleTime is
--        when 1e9 =>
--          Decimator          <= (others => M1);
--          Stage0AvgDecimator <= M1;
--        when 500e6 =>
--          Decimator(0)       <= M2;
--          Stage0AvgDecimator <= M2;
--        when 250e6 =>
--          Decimator(0)       <= M4;
--          Stage0AvgDecimator <= M4;
--        when 100e6 =>
--          Stage0AvgDecimator <= M10;
--        when 50e6 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M2;
--        when 25e6 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M4;
--        when 10e6 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--        when 5e6 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M2;
--        when 2500e3 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M4;
--        when 1e6 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M10;
--        when 500e3 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M10;
--          Decimator(3) <= M2;
--        when 250e3 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M10;
--          Decimator(3) <= M4;
--        when 100e3 =>
--          Decimator(0) <= M10;
--          Decimator(1) <= M10;
--          Decimator(2) <= M10;
--          Decimator(3) <= M10;
--        when others =>
--          null;
--      end case;
--      if iCPU.EnableFilter(0) = '0' then
--        Stage0AvgDecimator <= M1;
--      end if;
--    end if;
--  end process;

  Control : for i in 0 to cChannels-1 generate
    C : DownSampler
      port map (
        iClk          => iClk,
        iResetAsync   => iResetAsync,
        iEnableFilter => iCPU.EnableFilter,
        iDecimation   => Decimator,
        iStageData0   => StageData0(i),
        iStageValid0  => StageValid0(i),
        iStage        => StageOutput(i)(StageOutput(0)'range),
        oStage        => StageInput(i)(StageInput(0)'range),
        oData         => DataOut(i),
        oValid        => ValidOut(i));
  end generate;
  oData  <= DataOut;
  oValid <= ValidOut(0);
  
end architecture;
