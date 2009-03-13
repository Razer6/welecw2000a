-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : Trigger-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-27
-- Last update: 2009-03-11
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
-- 2008-08-27  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;

package pTrigger is
  
  constant cStorageModeLength : natural                                          := 2;
  constant cStorageMode4CH    : std_ulogic_vector(cStorageModeLength-1 downto 0) :=
    std_ulogic_vector(to_unsigned(0, cStorageModeLength));
  constant cStorageMode2CH : std_ulogic_vector(cStorageModeLength-1 downto 0) :=
    std_ulogic_vector(to_unsigned(1, cStorageModeLength));
  constant cStorageMode1CH : std_ulogic_vector(cStorageModeLength-1 downto 0) :=
    std_ulogic_vector(to_unsigned(3, cStorageModeLength));
  constant cTriggerAddrLength : natural := 13;
  constant cTriggerAlign      : natural := 3;
  subtype  aTriggerAddr is unsigned(cStorageModeLength+cTriggerAddrLength-1 downto 0);
  subtype  aTriggerReadAddr is std_ulogic_vector(cTriggerAddrLength-1 downto 0);
  constant cDiffTriggers      : natural := 4;

  subtype aTrigger1D is std_ulogic_vector(0 to cCoefficients-1);
  type    aTrigger2D is array (natural range<>) of aTrigger1D;

  -- the trigger always has 4 channels with each 8 bit width, generated in the SignalSelector  
  type aTriggerData is array (0 to 3) of aBytes(0 to cCoefficients-1);
  type aTopTriggerState is (Idle, Preamble, Triggering, PreRecording, Recording);
  type aTopTriggerFSM is record
                           State       : aTopTriggerState;
                           PrevTrigger : std_ulogic;
                           Counter     : unsigned(cStorageModeLength+cTriggerAddrLength-cTriggerAlign-1 downto 0);
                           Busy        : std_ulogic;
                           WrEn        : std_ulogic_vector(0 to 3);
                           --          TriggerData : aWords(0 to cCoefficients-1);
                           Addr        : unsigned(cStorageModeLength+cTriggerAddrLength-cTriggerAlign-1 downto 0);
                           StartAddr   : aTriggerAddr;
                           ReadAlign   : std_ulogic_vector(cTriggerAlign-1 downto 0);
                           DataValid   : std_ulogic_vector(1 to 2);
                         end record;
  
  type aTriggerInput is record
                          TriggerOnce     : std_ulogic;
                          ForceIdle       : std_ulogic;
                          PreambleCounter : aTriggerAddr;
                          Trigger         : natural range 0 to cDiffTriggers-1;
                          TriggerChannel  : natural range 0 to 3;
                          StorageMode     : std_ulogic_vector(cStorageModeLength-1 downto 0);

-- "00" :     4 CH each  8 KB
-- oData(0)(0) = ch0(0), oData(1)(0) = ch1(0), oData(2)(0) = ch2(0), oData(3)(0) = ch3(0)
-- "01" :     2 CH each 16 KB
-- oData(0)(0) = ch0(0), oData(1)(0) = ch1(0), oData(2)(0) = ch0(8192), oData(3)(0) = ch1(8192)
-- "11" :     1 CH with 32 KB
-- oData(0)(0) = ch0(0), oData(1)(0) = ch0(8192), oData(2)(0) = ch0(16384), oData(3)(0) = ch0(24576)

                          -- Trigger mode specific
                          LowValue      : aByte;
                          LowTime       : aWord;
                          HighValue     : aByte;
                          HighTime      : aWord;
                          SetReadOffset : std_ulogic;
                          ReadOffset    : aTriggerAddr;
                        end record;
  
  type aTriggerOutput is record
                           ReadOffSet         : aTriggerAddr;
                           Busy               : std_ulogic;
                           Recording          : std_ulogic;  -- for on the fly recording with e.g. PCI (SandboxX)
                           CurrentTriggerAddr : unsigned(cStorageModeLength+cTriggerAddrLength-cTriggerAlign-1 downto 0);
                         end record;
  
  type aExtTriggerInput is record
                             Addr : natural range 0 to cExtTriggers;
                             PWM  : aBytes(1 to cExtTriggers);
                           end record;
  
  type aTriggerMemOut is record
                           Data : aDword;
                           ACK  : std_ulogic;
                         end record;
  
  type aTriggerMemIn is record
                          Addr : aTriggerReadAddr;
                          Rd   : std_ulogic;
                        end record;
  
  
  
end;
