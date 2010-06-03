-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegister-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-11-15
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
                     iResetEnc		: std_ulogic_vector(11 downto 0);
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
  constant cKeyAddr                : natural := 26;
  constant cEncAddrTimbase    	   : natural := 27;
  constant cEncAddrLeftRight	   : natural := 28;
  constant cEncAddrTriggerLevel    : natural := 29;
  constant cEncAddrF		       : natural := 30;
  constant cEncAddrVoltageCH0  	   : natural := 31;
  constant cEncAddrVoltageCH1  	   : natural := 32;
  constant cEncAddrVoltageCH2  	   : natural := 33;
  constant cEncAddrVoltageCH3 	   : natural := 34;
  constant cEncAddrUpDownCH0 	   : natural := 35;
  constant cEncAddrUpDownCH1  	   : natural := 36;
  constant cEncAddrUpDownCH2  	   : natural := 37;
  constant cEncAddrUpDownCH3  	   : natural := 38;
  constant cAnalogSettingsAddr     : natural := 39;
  constant cLastAddr               : natural := 40;
  
end package;
