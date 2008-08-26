-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopDownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-17
-- Last update: 2008-08-17
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-17  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pInputValues.all;
use work.pPolyphaseDecimator.all;

entity TopDownSampler is
  port (
    iClk             : in  std_ulogic;
    iResetAsync      : in  std_ulogic;
    iADC             : in  aAllData;    -- fixpoint 1.x range -0.5 to 0.5
    iDecimationRange : in  integer range 0 to cDecimatorMax;
    iEnableStage1    : in  std_ulogic;
    iEnableStage2    : in  std_ulogic;
    oData            : out aAllData;    -- fixpoint 1.x range -1 to <1
    oWrEn            : out std_ulogic);
end entity;

architecture RTL of TopDownSampler is
  
  signal Stage1Decimator      : aDecimator;
  signal Stage1AliasDecimator : aDecimator;
  signal Stage2Decimator      : aDecimator;

  signal Stage1Data  : aAllData;
  signal FastFirData : aValues(0 to cChannels-1);
  signal Stage1Valid : std_ulogic;
  signal Stage2Data  : aLongValues(0 to cChannels-1);
  signal Stage2Valid : std_ulogic;
  
begin
  
  FastAvg0 : entity work.FastAverage
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Stage1Decimator,
      iData       => iADC(0),           -- fixpoint 1.x range -0.5 to 0.5
      oData       => Stage1Data(0),     -- fixpoint 1.x range -1 to <1
      oValid      => Stage1Valid);

  FastAvg1 : entity work.FastAverage
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Stage1Decimator,
      iData       => iADC(1),           -- fixpoint 1.x range -0.5 to 0.5
      oData       => Stage1Data(1),     -- fixpoint 1.x range -1 to <1
      oValid      => open);

  FastAvg2 : entity work.FastAverage
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Stage1Decimator,
      iData       => iADC(2),           -- fixpoint 1.x range -0.5 to 0.5
      oData       => Stage1Data(2),     -- fixpoint 1.x range -1 to <1
      oValid      => open);

  FastAvg3 : entity work.FastAverage
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Stage1Decimator,
      iData       => iADC(3),           -- fixpoint 1.x range -0.5 to 0.5
      oData       => Stage1Data(3),     -- fixpoint 1.x range -1 to <1
      oValid      => open);

  FastFirData(0) <= Stage1Data(0)(0);
  FastFirData(1) <= Stage1Data(1)(0);
  FastFirData(2) <= Stage1Data(2)(0);
  FastFirData(3) <= Stage1Data(3)(0);

  FastFir : entity work.TopFastPolyPhaseDecimator
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iDecimator  => Stage2Decimator,
      iData       => FastFirData,
      iValid      => Stage1Valid,
      oData       => Stage2Data,
      oValid      => Stage2Valid);

  M : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Stage1Decimator      <= M1;
      Stage1AliasDecimator <= M1;
      Stage2Decimator      <= M1;
    elsif rising_edge(iClk) then
      Stage1Decimator      <= M1;
      Stage2Decimator      <= M1;
      Stage1AliasDecimator <= M1;
      case iDecimationRange is
        when 2 =>
          if iEnableStage1 = '1' then
            Stage1Decimator <= M2;
          end if;
          Stage1AliasDecimator <= M2;
        when 4 =>
          if iEnableStage1 = '1' then
            Stage1Decimator <= M4;
          end if;
          Stage1AliasDecimator <= M4;
        when 10 =>
          Stage1Decimator      <= M10;
          Stage1AliasDecimator <= M10;
        when 20 =>
          Stage1Decimator      <= M10;
          Stage1AliasDecimator <= M10;
          Stage2Decimator      <= M2;
        when 40 =>
          Stage1Decimator      <= M10;
          Stage1AliasDecimator <= M10;
          Stage2Decimator      <= M4;
        when 100 =>
          Stage1Decimator      <= M10;
          Stage1AliasDecimator <= M10;
          Stage2Decimator      <= M10;
        when others =>
          null;
      end case;
      if iEnableStage1 = '0' then
        Stage1Decimator <= M1;
      end if;
    end if;
  end process;

  DS0 : entity work.DownSampler
    port map (
      iClk          => iClk,
      iResetAsync   => iResetAsync,
      iEnableStage1 => iEnableStage1,
      iMStage1      => Stage1AliasDecimator,
      iStage1Data   => Stage1Data(0),
      iStage1Valid  => Stage1Valid,
      iEnableStage2 => iEnableStage2,
      iMStage2      => Stage2Decimator,
      iStage2Data   => Stage2Data(0)(aLongValue'high downto aLongValue'high-cBitWidth+1),
      iStage2Valid  => Stage2Valid,
      oDataOut      => oData(0),
      oWrEn         => oWrEn);

  DS1 : entity work.DownSampler
    port map (
      iClk          => iClk,
      iResetAsync   => iResetAsync,
      iEnableStage1 => iEnableStage1,
      iMStage1      => Stage1AliasDecimator,
      iStage1Data   => Stage1Data(1),
      iStage1Valid  => Stage1Valid,
      iEnableStage2 => iEnableStage2,
      iMStage2      => Stage2Decimator,
      iStage2Data   => Stage2Data(1)(aLongValue'high downto aLongValue'high-cBitWidth+1),
      iStage2Valid  => Stage2Valid,
      oDataOut      => oData(1),
      oWrEn         => open);

  DS2 : entity work.DownSampler
    port map (
      iClk          => iClk,
      iResetAsync   => iResetAsync,
      iEnableStage1 => iEnableStage1,
      iMStage1      => Stage1AliasDecimator,
      iStage1Data   => Stage1Data(2),
      iStage1Valid  => Stage1Valid,
      iEnableStage2 => iEnableStage2,
      iMStage2      => Stage2Decimator,
      iStage2Data   => Stage2Data(2)(aLongValue'high downto aLongValue'high-cBitWidth+1),
      iStage2Valid  => Stage2Valid,
      oDataOut      => oData(2),
      oWrEn         => open);

  DS3 : entity work.DownSampler
    port map (
      iClk          => iClk,
      iResetAsync   => iResetAsync,
      iEnableStage1 => iEnableStage1,
      iMStage1      => Stage1AliasDecimator,
      iStage1Data   => Stage1Data(3),
      iStage1Valid  => Stage1Valid,
      iEnableStage2 => iEnableStage2,
      iMStage2      => Stage2Decimator,
      iStage2Data   => Stage2Data(3)(aLongValue'high downto aLongValue'high-cBitWidth+1),
      iStage2Valid  => Stage2Valid,
      oDataOut      => oData(3),
      oWrEn         => open);

end architecture;
