-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DSOConfig-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-04
-- Last update: 2009-08-27
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
-- 2009-03-04  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pDSOConfig is

  -- DeviceAddr:
  constant cWelec2012 : natural := 2012;
  constant cWelec2014 : natural := 2014;
  constant cWelec2022 : natural := 2022;
  constant cWelec2024 : natural := 2024;
  -- common for all minimal solutions with 1 Ch 14 Bit
  -- and no VGA
  constant cSandboxX  : natural := 1011;

  constant cCurrentDevice : natural := cWelec2022;  -- can be read in the SFR(0)

  -- downsampler settings
  constant cDecimationStages : natural    := 5;
  constant cChannels         : natural    := 2;
  constant cADCsperChannel   : natural    := 4;
  constant cADCClkRate       : natural    := 250E6;
  constant cDesignClkRate    : natural    := 125E6;
  constant cCPUClkRate       : natural    := 62500E3;
  constant cAnSettStrobeRate : natural    := 2E3;  -- 1 kHz calibrator freq.
  constant cResetActive      : std_ulogic := '0';
  constant cADCBitWidth      : natural    := 8;
  constant cBitWidth         : natural    := 8;
  constant cDelayMemWidth    : natural    := 7;  -- address bits of the slow FIR memory
  constant cExtTriggers      : natural    := 1;
  constant cSRAMAddrWidth    : natural    := 19;   -- DwordAddr
  constant cFLASHAddrWidth   : natural    := 23;   -- byte address
  
end;
