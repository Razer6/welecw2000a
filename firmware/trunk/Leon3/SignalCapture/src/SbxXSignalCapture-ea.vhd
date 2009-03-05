-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SBxXSignalCapture-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-04
-- Last update: 2009-03-05
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

entity SbxXSignalCapture is
  port (
    oClkCPU     : out std_ulogic;
    iResetAsync : in  std_ulogic;
    -- ADC
    iClkADC     : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for SbxX 100 MHz
    oResetAsync : out std_ulogic;  -- pll locked as asyncronous reset
    iADC        : in  aADCIn;

    iDownSampler : aDownSampler;
    -- Trigger
    iTriggerCPUPort : in  aTriggerInput;
    oTriggerCPUPort : out aTriggerOutput;
    iTriggerMem     : in  aTriggerMemIn;
    oTriggerMem     : out aTriggerMemOut;
    iExtTrigger     : in  std_ulogic
    );

end entity;


architecture RTL of SbxXSignalCapture is
  signal ResetAsync        : std_ulogic;
  signal ClkDesign         : std_ulogic;
  signal DecimatorIn       : aAllData;
  signal DecimatorOut      : aDownSampled;
  signal DecimatorOutValid : std_ulogic;
  signal SelectorOut       : aTriggerData;
  signal SelectorOutValid  : std_ulogic;
  signal SlowInputData     : aLongValues(0 to cChannels-1);
  signal SlowInputValid    : std_ulogic;
begin

  -- oResetAsync <= ResetAsync;
  ResetAsync <= not iResetAsync;

  DesignClk : entity DSO.SbXPLL
    port map (
      areset => ResetAsync,
      inclk0 => iCLKADC(0),
      c0     => oClkCPU,
      locked => oResetAsync);


  process (ResetAsync, ClkDesign)
  begin
    if iResetAsync = cResetActive then
      SlowInputData  <= (others => (others => '0'));
      SlowInputValid <= '0';
    elsif rising_edge(ClkDesign) then
      SlowInputData(0)(SlowInputData(0)'high downto SlowInputData(0)'high-iADC(0)(0)'length+1) <= 
      signed(iADC(0)(0));
    end if;
  end process;

  DecimatorIn <= (others => (others => (others => '0')));

  Decimator : entity work.TopDownSampler
    generic map (gUseStage0 => false)
    port map (
      iClk        => ClkDesign,
      iResetAsync => iResetAsync,
      iADC        => DecimatorIn,       -- fixpoint 1.x range -0.5 to 0.5
      iCPU        => iDownSampler,
      iData       => SlowInputData,
      iValid      => SlowInputValid,
      oData       => DecimatorOut,      -- fixpoint 1.x range -1 to <1
      oValid      => DecimatorOutValid);

SignalSelector: process (DecimatorOut)
begin
    for i in 0 to cCoefficients-1 loop
   SelectorOut(0)(i) <= std_ulogic_vector(DecimatorOut(0)(i)(27 downto 20));
   SelectorOut(1)(i) <= std_ulogic_vector(DecimatorOut(0)(i)(19 downto 12));
   SelectorOut(2)(i) <= std_ulogic_vector(DecimatorOut(0)(i)(11 downto 4));
   SelectorOut(3)(i)(7 downto 4) <= std_ulogic_vector(DecimatorOut(0)(i)(3 downto 0));
   SelectorOut(0)(i)(3 downto 0) <= (others => '0');
  end loop; 
end process;  
      
   SelectorOutValid <= '1';
      

  Trigger : entity work.TopTrigger
    port map (
      iClk        => ClkDesign,
      iResetAsync => iResetAsync,
      iCPUPort    => iTriggerCPUPort,
      oCPUPort    => oTriggerCPUPort,
      iTriggerMem => iTriggerMem,
      oTriggerMem => oTriggerMem,
      iData       => SelectorOut,
      iValid      => SelectorOutValid,
      iExtTrigger => iExtTrigger);

end architecture;

