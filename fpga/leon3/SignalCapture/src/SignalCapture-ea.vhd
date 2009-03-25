-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SignalCapture-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-03-21
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

entity SignalCapture is
  port (
    oClkDesign : out std_ulogic;
    oClkCPU    : out std_ulogic;
--    iResetAsync : in  std_ulogic;

    -- ADC
    iClkADC     : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000  25 MHz
    oClkADC     : out std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000 250 MHz
    oResetAsync : out std_ulogic;
    iADC        : in  aADCIn;

    iDownSampler : aDownSampler;

    -- SignalSelector
    iSignalSelector : in aSignalSelector;

    -- Trigger
    iTriggerCPUPort : in  aTriggerInput;
    oTriggerCPUPort : out aTriggerOutput;
    iTriggerMem     : in  aTriggerMemIn;
    oTriggerMem     : out aTriggerMemOut;

    iExtTriggerSrc : in  aExtTriggerInput;
    iExtTrigger    : in  std_ulogic;
    oExtTriggerPWM : out std_ulogic_vector(1 to cExtTriggers)
    );

end entity;


architecture RTL of SignalCapture is
  signal ResetAsync        : std_ulogic;
  signal ClkDesign         : std_ulogic;
  signal ClkCPU            : std_ulogic;
  signal ADCout            : aADCout;
  signal DecimatorIn       : aAllData;
  signal DecimatorOut      : aDownSampled;
  signal DecimatorOutValid : std_ulogic;
  signal SelectorOut       : aTriggerData;
  signal SelectorOutValid  : std_ulogic;
  signal SlowInputData     : aLongValues(0 to cChannels-1);
  signal SlowInputValid    : std_ulogic;
  signal ExtTrigger        : std_ulogic;
begin
  
  oClkCPU     <= ClkCPU;
  oClkDesign  <= ClkDesign;
  oResetAsync <= ResetAsync;

  ADCs : entity DSO.ADC
    port map (
--    iClkDesign  : in std_ulogic;
--      iResetAsync => iResetAsync,
      iClkADC => iClkADC,
--    iLocked : in std_ulogic;
      iADC    => iADC,
      oLocked => ResetAsync,
      oClk125 => ClkDesign,
      oClk625 => ClkCPU,
      oClkADC => oClkADC,
      oData   => ADCout);

  process (ResetAsync, ClkDesign)
  begin
    if ResetAsync = cResetActive then
      DecimatorIn <= (others => (others => (others => '0')));
    elsif rising_edge(ClkDesign) then
      for i in 0 to cChannels-1 loop
        for j in 0 to cCoefficients-1 loop
          DecimatorIn(i)(j) <= signed('0' & ADCout(i)(j));
        end loop;
      end loop;
    end if;
  end process;

  SlowInputData  <= (others => (others => '0'));
  SlowInputValid <= '0';

  Decimator : entity DSO.TopDownSampler
    port map (
      iClk        => ClkDesign,
      iResetAsync => ResetAsync,
      iADC        => DecimatorIn,       -- fixpoint 1.x range -0.5 to 0.5
      iCPU        => iDownSampler,
      iData       => SlowInputData,
      iValid      => SlowInputValid,
      oData       => DecimatorOut,      -- fixpoint 1.x range -1 to <1
      oValid      => DecimatorOutValid);

  Selector : entity DSO.SignalSelector
    port map (
      iClk            => ClkDesign,
      iResetAsync     => ResetAsync,
      iSignalSelector => iSignalSelector,
      iData           => DecimatorOut,  -- 18 bit values
      iValid          => DecimatorOutValid,
      oData           => SelectorOut,   -- 8 bit values
      oValid          => SelectorOutValid);

  ExtTriggerInput : entity DSO.ExtTriggerInput
    port map(
      iClk           => ClkDesign,
      iResetAsync    => ResetAsync,
      iExtTrigger(1) => iExtTrigger,
      iExtTriggerSrc => iExtTriggerSrc,
      oTrigger       => ExtTrigger,
      oPWM           => oExtTriggerPWM);

  Trigger : entity DSO.TopTrigger
    port map (
      iClk        => ClkDesign,
      iClkCPU     => ClkCPU,
      iResetAsync => ResetAsync,
      iCPUPort    => iTriggerCPUPort,
      oCPUPort    => oTriggerCPUPort,
      iTriggerMem => iTriggerMem,
      oTriggerMem => oTriggerMem,
      iData       => SelectorOut,
      iValid      => SelectorOutValid,
      iExtTrigger => ExtTrigger);

end architecture;

