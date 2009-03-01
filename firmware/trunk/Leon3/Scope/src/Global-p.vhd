-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : Global-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-14
-- Last update: 2009-02-20
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
-- 2008-08-14  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Global is
  constant cADCClkRate     : natural    := 250E6;
  constant cDesignClkRate  : natural    := 125E6;
  constant cCPUClkRate     : natural    := 626E5;
  constant cResetActive    : std_ulogic := '0';
  constant cLowActive      : std_ulogic := '0';
  constant cHighInactive   : std_ulogic := '1';
  constant cChannels       : natural    := 2;
  constant cADCsperChannel : natural    := 4;
  constant cCoefficients   : natural    := 8;   -- ADC input width on 125 MHz
  constant cBitWidth       : natural    := 9;
  constant cDecimatorMax   : natural    := 100;
  constant cSRAMAddrWidth  : natural    := 19;  -- DwordAddr
  constant cFLASHAddrWidth : natural    := 23;  -- byte address

  subtype aByte is std_ulogic_vector(7 downto 0);
  type    aBytes is array (natural range<>) of aByte;
  subtype aWord is std_ulogic_vector(15 downto 0);
  type    aWords is array (natural range<>) of aWord;
  subtype aDword is std_ulogic_vector(31 downto 0);
  type    aDwords is array (natural range<>) of aDword;

  -- typedefs for the ADC inputs
  type aADCInPhase is array (natural range <>) of aBytes(0 to cChannels-1);
  type aADCIn is array (0 to cADCsperChannel-1) of aBytes(0 to cChannels-1);
  type aADCOut is array (0 to cChannels-1) of aBytes(0 to cCoefficients-1);

  -- typedefs for the DownSampler 
  subtype aValue is signed (cBitWidth-1 downto 0);
  type    aValues is array (natural range<>) of aValue;
  subtype aFastData is aValues(0 to cCoefficients-1);
  type    aAllData is array (0 to cChannels-1) of aFastData;
  subtype aLongValue is signed(cBitWidth*2-1 downto 0);
  type    aLongValues is array (natural range<>) of aLongValue;
  type    aInputValues is array (natural range<>) of integer;
  subtype aiValues is aInputValues(0 to 127);

  -- typedefs for the SignalSelector
  subtype aTriggerCH is std_ulogic_vector(2 downto 0);
  -- the trigger has for every plattform 4 channels
  -- 0 to 3 are the ch0 to ch3 MSB, 4 to 7 are ch0 to ch3 LSB (only supported in filtering mode)
  subtype aGain10Exponent is integer range 0 to 6;
  -- 1 micro volt
  -- Resolution 4 to 6 is fully supported
  -- Resolution 0 to 3 results from filters
  -- It is supported only when filtering is on!
  -- 2 for < 10 Ms with 8 bit

  type aSS is record
                TriggerCH      : aTriggerCh;
                Gain10Exponent : aGain10Exponent;
              end record;
  type aSignalSelector is array (0 to 3) of aSS;
  type aAnalogAmplification is array (0 to 3) of aTriggerCH;  -- same bit width



  function LogXY (x, y : natural) return natural;
  
end;

package body Global is
  function LogXY (x, y : natural) return natural is
    variable vIn  : natural := x;
    variable vRet : natural := 0;
  begin
    vIn := vIn -1;
    while vIn > 0 loop
      vIn  := vIn / y;
      vRet := vRet +1;
    end loop;
    return vRet;
  end function;
end;

