-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegister-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-04-05
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

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pTrigger.all;
use DSO.pPolyphaseDecimator.all;
--use work.pUart.all;
use DSO.pLedsKeysAnalogSettings.all;

package pSpecialFunctionRegister is
  
  type aSFR_in is record
                    Trigger        : aTriggerOutput;
                    --                  Uart           : aUarttoCPU;
                    Keys           : aKeys;
                    AnalogBusy     : std_ulogic;
                  end record;
  type aSFR_out is record
                     Decimator      : aDownSampler;
                     SignalSelector : aSignalSelector;
                     ExtTriggerSrc  : aExtTriggerInput;
                     Trigger        : aTriggerInput;
                     --                  Uart            : aCPUtoUart;
                     Leds           : aLeds;
                     nConfigADC     : std_ulogic_vector(cChannels-1 downto 0);
                     AnalogSettings : aAnalogSettings;
                   end record;
  -- addresses
  constant cDeviceAddr             : natural := 0;
  constant cInterruptAddr          : natural := 1;
  constant cInterruptMaskAddr      : natural := 2;
  constant cSamplingFreqAddr       : natural := 4;
  constant cFilterEnableAddr       : natural := 5;
  constant cExtTriggerSrcAddr      : natural := 6;
  constant cExtTriggerPWMAddr      : natural := 7;
  constant cInputCh0Addr           : natural := 8;
  constant cInputCh1Addr           : natural := 9;
  constant cInputCh2Addr           : natural := 10;
  constant cInputCh3Addr           : natural := 11;
  constant cTriggerOnChAddr        : natural := 12;
  constant cTriggerOnceAddr        : natural := 13;
  constant cTriggerPrefetchAddr    : natural := 14;
  constant cTriggerStorageModeAddr : natural := 15;
  constant cTriggerReadOffSetAddr  : natural := 16;
  constant cTriggerTypeAddr        : natural := 17;
  constant cTriggerLowValueAddr    : natural := 18;
  constant cTriggerLowTimeAddr     : natural := 19;
  constant cTriggerHighValueAddr   : natural := 20;
  constant cTriggerHighTimeAddr    : natural := 21;
  constant cTriggerStatusRegister  : natural := 22;
  constant cTriggerCurrentAddr     : natural := 23;
  constant cConfigADCEnable        : natural := 24;
  constant cLedAddr                : natural := 25;
  constant cKeyAddr0               : natural := 26;
  constant cKeyAddr1               : natural := 27;
  constant cAnalogSettingsPWMAddr  : natural := 28;
  constant cAnalogSettingsBank7    : natural := 29;
  constant cAnalogSettingsBank6    : natural := 30;
  constant cAnalogSettingsBank5    : natural := 31;
  constant cLastAddr               : natural := 32;
  
end package;
