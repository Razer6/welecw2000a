-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : Global-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-14
-- Last update: 2008-08-17
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-14  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Global is
  constant cResetActive  : std_ulogic := '1';
  constant cChannels     : natural    := 4;
  constant cCoefficients : natural    := 8;  -- ADC input width on 125 MHz
  constant cBitWidth     : natural    := 9;
  constant cDecimatorMax : natural := 100;

  subtype aValue is signed (cBitWidth-1 downto 0);
  type    aValues is array (natural range<>) of aValue;
  subtype aFastData is aValues(0 to cCoefficients-1);
  type aAllData is array (0 to cChannels-1) of aFastData;

  subtype aLongValue is signed(cBitWidth*2-1 downto 0);
  type    aLongValues is array (natural range<>) of aLongValue;

  type    aInputValues is array (natural range<>) of integer;
  subtype aiValues is aInputValues(0 to 127);
  
end;
