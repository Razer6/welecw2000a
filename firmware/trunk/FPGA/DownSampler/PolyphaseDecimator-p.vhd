-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PolyphaseDecimator-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-07
-- Last update: 2008-08-16
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-07  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pFastFirCoeff.all;

package pPolyphaseDecimator is
  
  type     aDecimator is ( M1, M2, M4, M10);
  subtype aAddr is natural range 0 to cFastFirCoeff'length/cCoefficients-1;
  constant cDecAvgMax : natural := 10;
  
  function Avg9Bit (A, B : aValue) return aValue;
  function toValues(A    : aInputValues) return aValues;
 
end;

package body pPolyphaseDecimator is
  
  function Avg9Bit (A, B : aValue) return aValue is
    variable vRes : aValue;
  begin
    vRes := (A(cBitWidth-1) & A(cBitWidth-1 downto 1)) + (B(cBitWidth-1) & B(cBitWidth-1 downto 1));
    return vRes;
  end;

  function toValues(A : aInputValues) return aValues is
    variable vRes : aValues(A'range);
  begin
    for i in A'range loop
      vRes(i) := to_signed(A(i), aValue'length);
      return vRes;
    end loop;
  end;

end;

