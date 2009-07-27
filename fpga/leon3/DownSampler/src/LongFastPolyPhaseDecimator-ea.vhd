-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : LongFastPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-07-06
-- Last update: 2009-07-06
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
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
-- 2009-07-06  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pFastFirCoeff.all;

entity LongFastPolyPhaseDecimator is
  port (
    iClk         : in  std_ulogic;
    iResetAsync  : in  std_ulogic;
    iDecimator   : in  aDecimator;
    iData        : in  aLongValue;
    iInputValid  : in  std_ulogic;
    iSumValid    : in  std_ulogic;
    iResultValid : in  std_ulogic;
    iCoeff       : in  aLongFastData;
    oData        : out aLongValue
    );  
end entity;

architecture RTL of LongFastPolyPhaseDecimator is

  type aR is record
               ShiftReg   : aLongValues(0 to 40);
 -- 50 FIR Coefficients shifted only once per cycle for M10 the 0, 10, 20, 30
 -- and 40 are used for the calulation
               MultValues : aLongValues(0 to cCoefficients-1);
               MultResult : aLongValues(0 to cCoefficients-1);
               AddResult0 : aLongValues(0 to cCoefficients/2-1);
               AddResult1 : aLongValues(0 to cCoefficients/4-1);
               AddResult2 : aLongValue;
               Sum        : aLongValue;
             end record;
  signal R : aR;
  
  type aMulRes is array (0 to cCoefficients-1) of signed(4*cBitWidth-1 downto 0);

begin
  
  FIR : process (iClk, iResetAsync)
    constant cInit : aR := (
      ShiftReg   => (others => (others => '0')),
      MultValues => (others => (others => '0')),
      MultResult => (others => (others => '0')),
      AddResult0 => (others => (others => '0')),
      AddResult1 => (others => (others => '0')),
      AddResult2 => (others => '0'),
      Sum        => (others => '0'));
    variable MulRes : aMulRes; 
  begin
    if iResetAsync = cResetActive then
      R <= cInit;
    elsif rising_edge(iClk) then
      if iInputValid = '1' then
        R.ShiftReg <= iData & R.ShiftReg(0 to R.ShiftReg'high-1);
      end if;

      -- Valid(1)
      for i in R.MultValues'range loop
        R.MultValues(i) <= R.ShiftReg(2*i);
      end loop;
      case iDecimator is
        when M4 =>
          for i in R.MultValues'range loop
            R.MultValues(i) <= R.ShiftReg(4*i);
          end loop;
        when M10 =>
          for i in 0 to 4 loop
            R.MultValues(i) <= R.ShiftReg(10*i);
          end loop;
        when others =>
          null;
      end case;

      for i in R.MultResult'range loop                    -- Valid(2)
        MulRes(i) := signed(R.MultValues(i) * iCoeff(i));
        R.MultResult(i) <= MulRes(i)(MulRes(0)'high downto MulRes(0)'length - R.MultResult(0)'length);
      end loop;
      for i in R.AddResult0'range loop                    -- Valid(3)
        R.AddResult0(i) <= R.MultResult(2*i) + R.MultResult(2*i+1);
      end loop;
      for i in R.AddResult1'range loop                    -- Valid(4)
        R.AddResult1(i) <= R.AddResult0(2*i) + R.AddResult0(2*i+1);
      end loop;
      R.AddResult2 <= R.AddResult1(0) + R.AddResult1(1);  -- Valid(5)

      if iResultValid = '1' and iSumValid = '1' then
        R.Sum <= to_signed(0, R.Sum'length) + R.AddResult2;
      elsif iResultValid = '1' then
        R.Sum <= to_signed(0, R.Sum'length);
      elsif iSumValid = '1' then
        R.Sum <= R.Sum + R.AddResult2;
      end if;
    end if;
  end process;

  oData <= R.Sum;
  
end architecture;
