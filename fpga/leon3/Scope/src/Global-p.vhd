-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : Global-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-14
-- Last update: 2009-07-06
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

library DSO;
use DSO.pDSOConfig.all;

package Global is

  constant cLowActive    : std_ulogic := '0';
  constant cHighInactive : std_ulogic := '1';
  constant cCoefficients : natural    := 8;  -- ADC input width on 125 MHz
  -- constant cDecimatorMax   : natural    := 100;

  subtype aByte is std_ulogic_vector(7 downto 0);
  type    aBytes is array (natural range<>) of aByte;
  subtype aWord is std_ulogic_vector(15 downto 0);
  type    aWords is array (natural range<>) of aWord;
  subtype aDword is std_ulogic_vector(31 downto 0);
  type    aDwords is array (natural range<>) of aDword;

  -- typedefs for the ADC inputs
  subtype aADCX is std_ulogic_vector(cADCBitWidth-1 downto 0);
  type    aADCData is array (natural range <>) of aADCX;
  type    aADCInPhase is array (natural range <>) of aADCData(0 to cChannels-1);
  type    aADCIn is array (0 to cADCsperChannel-1) of aADCData(0 to cChannels-1);
  type    aADCOut is array (0 to cChannels-1) of aADCData(0 to cCoefficients-1);

  type    aInputValues is array (natural range<>) of integer;
  subtype aiValues is aInputValues(0 to 127);

  -- typedefs for the SignalSelector
  subtype aTriggerCH is std_ulogic_vector(2 downto 0);
  -- the trigger has for every plattform 4 channels
  -- 0 to 3 are the ch0 to ch3 MSB, 4 to 7 are ch0 to ch3 LSB (only supported in filtering mode)
  type    aSignalSelector is array (0 to 3) of aTriggerCH;

  function LogXY (x, y : natural) return natural;
  
  component PWM is
    generic (
      gBitWidth : natural := 7);
    port (
      iClk        : in  std_ulogic;
      iResetAsync : in  std_ulogic;
      iRefON      : in  std_ulogic_vector(gBitWidth-1 downto 0);
      iRefOff     : in  std_ulogic_vector(gBitWidth-1 downto 0);
      oPWM        : out std_ulogic);
  end component;
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

