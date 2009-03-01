-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-17
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
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pFirCoeff.all;


entity PolyPhaseDecimator is
  port (
    iClk          : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iDecimator    : in  aDecimator;
    iData         : in  aLongValue;
    iInputValid   : in  std_ulogic;
    iValidDelayed : in  std_ulogic;
    iSumValid     : in  std_ulogic;
    iResultValid  : in  std_ulogic;
    iShiftEnable  : in  std_ulogic;
    iFirCounter   : in  natural range 0 to 8-1;
    iReadAddr     : unsigned(7 downto 0);
    iWriteAddr    : unsigned(7 downto 0);
    iCoeff        : in  aLongValue;
    oData         : out aLongValue);  
end entity;

architecture RTL of PolyPhaseDecimator is

  signal RamData : aLongValue;
  signal aclr    : std_ulogic;

  type aR is record
               ShiftIn    : aLongValue;
               ShiftOut   : aLongValue;
               MultValue1 : aLongValue;
               MultResult : aLongValue;
               Sum        : aLongValue;
             end record;
  signal R : aR;
  
begin
  
  FIR : process (iClk, iResetAsync)
    variable vRes : signed(2*aLongValue'length-1 downto 0);
    constant cInit : aR := (
      ShiftIn           => (others => '0'),
      ShiftOut          => (others => '0'),
      MultValue1        => (others => '0'),
      MultResult        => (others => '0'),
      Sum               => (others => '0'));
  begin
    if iResetAsync = cResetActive then
      R <= cInit;
    elsif rising_edge(iClk) then
      if iShiftEnable = '1' then
        R.ShiftOut <= RamData;
      end if;
      if iInputValid = '1' then         -- Valid(0)
        R.ShiftIn <= iData;    
      elsif iFirCounter /= 0 then
        R.ShiftIn <= R.ShiftOut;
      else
        if iValidDelayed = '1' then
          R.ShiftIn <= R.ShiftOut;
        end if;
      end if;

      -- Valid(1)
      R.MultValue1 <= R.ShiftOut;
      -- Valid(2)
      vRes         := R.MultValue1 * iCoeff;
      R.MultResult <= vRes(vRes'high downto vRes'high-R.MultResult'length+1);
      if iSumValid = '1' then
        if iResultValid = '1' then      -- Valid(3)
          R.Sum <= to_signed(0, R.Sum'length) + R.MultResult;
        else
          R.Sum <= R.Sum + R.MultResult;
        end if;
      end if;
    end if;
  end process;

  oData <= R.Sum;

  aclr <= iResetAsync when cResetActive <= '1' else
          not iResetAsync;
  
  ShiftReg : entity DSO.DelayMemory
    port map(
  --    aclr          => aclr,
      clock         => iClk,
      data          => std_logic_vector(R.ShiftIn),
      rdaddress     => std_logic_vector(iReadAddr),
      wraddress     => std_logic_vector(iWriteAddr),
      wren          => '1',
      aLongValue(q) => RamData);

end architecture;
