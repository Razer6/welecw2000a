-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SBxXSignalCapture-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-04
-- Last update: 2009-08-02
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
    oClkDesign  : out std_ulogic;
    iResetAsync : in  std_ulogic;
    -- ADC
    iClkADC     : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for SbxX 100 MHz
    oResetAsync : out std_ulogic;       -- pll locked as asyncronous reset
    iADC        : in  aADCIn;

    iDownSampler    : in  aDownSampler;
    iSignalSelector : in  aSignalSelector;
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


architecture RTL of SbxXSignalCapture is
  signal ResetAsync        : std_ulogic;
  signal ClkDesign         : std_ulogic;
  signal ClkCPU            : std_ulogic;
  signal DecimatorIn       : aAllData;
  signal DecimatorOut      : aLongAllData;
  signal DecimatorOutValid : std_ulogic;
  signal SelectorOut       : aTriggerData;
  signal SelectorOutValid  : std_ulogic;
  signal SlowInputData     : aLongValues(0 to cChannels-1);
  signal FromLVDSData      : aLongValues(0 to cChannels-1);
  signal SlowInputValid    : std_ulogic;
  signal DownSampler       : aDownSampler;
  signal ExtTrigger        : std_ulogic;
  signal Channels          : integer range 0 to 3;
begin

  -- oResetAsync <= ResetAsync;
  ResetAsync <= not iResetAsync;
--  ClkDesign  <= iCLKADC(0);
  oClkCPU    <= ClkCPU;

  DesignClk : entity DSO.SbXPLL
    port map (
      areset => ResetAsync,
      inclk0 => iCLKADC(0),
      c0     => ClkCPU,
      c1     => ClkDesign,
      locked => oResetAsync);

  pCMOS : if cLVDSADCs = 0 generate
    process (iResetAsync, ClkDesign)
    begin
      if iResetAsync = cResetActive then
        SlowInputData <= (others => (others => '0'));
      elsif rising_edge(ClkDesign) then
        SlowInputData(0)(SlowInputData(0)'high downto SlowInputData(0)'high-iADC(0)(0)'length+1) <=
          signed(iADC(0)(0));
      end if;
    end process;
  end generate;

  pLVDS : if cLVDSADCs /= 0 generate
    process (iResetAsync, ClkDesign)
      constant cOffset : natural := cBitWidth-(2*cADCBitWidth);
    begin
      if iResetAsync = cResetActive then
        SlowInputData <= (others => (others => '0'));
        FromLVDSData  <= (others => (others => '0'));
      elsif rising_edge(ClkDesign) then
        SlowInputData <= FromLVDSData;
        for i in 0 to cADCBitWidth-1 loop
          FromLVDSData(0)((i*2)+cOffset) <= iADC(0)(0)(i);
        end loop;
      elsif falling_edge(ClkDesign) then
        for i in 0 to cADCBitWidth-1 loop
          FromLVDSData(0)((i*2)+cOffset+1) <= iADC(0)(0)(i);
        end loop;
      end if;
    end process;
  end generate;



  DecimatorIn    <= (others => (others => (others => '0')));
  SlowInputValid <= '1';

  process (iDownSampler)
  begin
    DownSampler                    <= iDownSampler;
    DownSampler.EnableFilter(0)    <= '1';
    DownSampler.Stages(3 downto 0) <= X"A";
  end process;

  Decimator : entity work.TopDownSampler
    generic map (gUseStage0 => false)
    port map (
      iClk        => ClkDesign,
      iResetAsync => iResetAsync,
      iADC        => DecimatorIn,       -- fixpoint 1.x range -0.5 to 0.5
      iCPU        => DownSampler,
      iData       => SlowInputData,
      iValid      => SlowInputValid,
      oData       => DecimatorOut,      -- fixpoint 1.x range -1 to <1
      oValid      => DecimatorOutValid);

  pSignalSelector : process (ClkDesign, iResetAsync)
    variable vTriggerCh : natural;
  begin
    if iResetAsync = cResetActive then
      SelectorOut     <= (others => (others => (others => '0')));
      SelectorOutValid <= '0';
    elsif rising_edge(ClkDesign) then
      SelectorOutValid <= DecimatorOutValid;
      for i in 0 to 3 loop
        vTriggerCh := to_integer(unsigned(iSignalSelector(i)(2 downto 0)));
        for j in 0 to cCoefficients-1 loop
          if is_x(std_ulogic_vector(DecimatorOut(0)(0))) = true then
            SelectorOut(i)(j) <= (others => '0');
          else
            case i is
              when 0 =>
                SelectorOut(0)(j) <= std_ulogic_vector(
                  DecimatorOut(0)(j)(DecimatorOut(0)(j)'high downto DecimatorOut(0)(j)'high-aByte'length+1));
              when 1 =>
                if vTriggerCh = 0 then
                  SelectorOut(1)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high downto DecimatorOut(0)(j)'high-aByte'length+1));
                else
                  SelectorOut(1)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high-aByte'length downto DecimatorOut(0)(j)'high-(2*aByte'length)+1));
                end if;
              when 2 =>
                if vTriggerCh = 0 then
                  SelectorOut(2)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high downto DecimatorOut(0)(j)'high-aByte'length+1));
                else
                  SelectorOut(2)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j) (DecimatorOut(0)(j)'high-(2*aByte'length) downto DecimatorOut(0)(j)'high-(3*aByte'length)+1));
                end if;
              when 3 =>
                if vTriggerCh = 0 then
                  SelectorOut(3)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high downto DecimatorOut(0)(j)'high-aByte'length+1));
                elsif vTriggerCh = 4 then
                  SelectorOut(3)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high-aByte'length downto DecimatorOut(0)(j)'high-(2*aByte'length)+1));
                else
                  SelectorOut(3)(j) <= std_ulogic_vector(
                    DecimatorOut(0)(j)(DecimatorOut(0)(j)'high-(3*aByte'length) downto DecimatorOut(0)(j)'high-(4*aByte'length)+1));
                end if;
            end case;
          end if;
        end loop;
      end loop;
    end if;
  end process;

--  SignalSelector : process (DecimatorOut)
--  begin
--    for j in 0 to 3 loop
--      for i in 0 to cCoefficients-1 loop
--        SelectorOut(j)(i) <= std_ulogic_vector(DecimatorOut(0)(i)((8*(j+1))-1 downto 8*j));
--      end loop;
--    end loop;
--  end process;

--  SelectorOutValid <= DecimatorOutValid;

-----------------------------------------------------------------------------------------
-- The pattern generator can be used instead of the DownSampler and the
-- SignalSelector, it only for debugging on the real hardware!
----------------------------------------------------------------------------------------- 
--  Channels <= to_integer(unsigned(iExtTriggerSrc.PWM(1)(1 downto 0)));
--  PG : entity DSO.PatternGenerator
--    port map (
--      iClk         => ClkDesign,
--      iResetAsync  => iResetAsync,
--      iDownSampler => iDownSampler,
--      iChannels    => Channels,
--      oData        => SelectorOut,
--      oValid       => SelectorOutValid);

  ExtTriggerInput : entity DSO.ExtTriggerInput
    port map(
      iClk           => ClkDesign,
      iResetAsync    => iResetAsync,
      iExtTrigger(1) => iExtTrigger,
      iExtTriggerSrc => iExtTriggerSrc,
      oTrigger       => ExtTrigger,
      oPWM           => oExtTriggerPWM);

  Trigger : entity work.TopTrigger
    port map (
      iClk        => ClkDesign,
      iClkCPU     => ClkCPU,
      iResetAsync => iResetAsync,
      iCPUPort    => iTriggerCPUPort,
      oCPUPort    => oTriggerCPUPort,
      iTriggerMem => iTriggerMem,
      oTriggerMem => oTriggerMem,
      iData       => SelectorOut,
      iValid      => SelectorOutValid,
      iExtTrigger => ExtTrigger);

end architecture;

