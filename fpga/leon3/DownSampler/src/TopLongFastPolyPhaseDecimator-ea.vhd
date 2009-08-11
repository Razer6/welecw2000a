-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : LongTopFastPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-07-06
-- Last update: 2009-07-07
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
use DSO.pFirCoeff.all;

entity TopLongFastPolyPhaseDecimator is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iDecimator  : in  aDecimator;
    iData       : in  aLongValues(0 to cChannels-1);
    iValid      : in  std_ulogic;
    oData       : out aLongValues(0 to cChannels-1);
    oValid      : out std_ulogic);
end entity;

architecture RTL of TopLongFastPolyPhaseDecimator is
  constant cValidDelay : integer := 6;
  signal   Coeff       : aLongFastData;

  type aR is record
               Valid         : std_ulogic_vector(1 to cValidDelay-1);
               ResultValid   : std_ulogic_vector(1 to cValidDelay);
               FirIdx        : aFastFirAddr;
               Counter       : natural range 0 to 49;
               PrevDecimator : aDecimator;
             end record;
  signal R : aR;
begin
  
  Reg : process(iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Coeff <= (others => (others => '0'));
    elsif rising_edge(iClk) then
      for i in Coeff'range loop
        Coeff(i) <= to_signed(cFirCoeff(R.FirIdx*cCoefficients + i), 2*cBitWidth);
      end loop;
    end if;
  end process;

  Control : process (iClk, iResetAsync)
    constant cInit : aR := (
      Valid         => (others => '0'),
      Counter       => 0,
      FirIdx        => 0,
      ResultValid   => (others => '0'),
      PrevDecimator => M1);
  begin
    if iResetAsync = cResetActive then
      R <= cInit;
    elsif rising_edge(iClk) then
      
      R.Valid(R.Valid'low)                   <= iValid;
      R.Valid(R.Valid'low+1 to R.Valid'high) <= R.Valid(R.Valid'low to R.Valid'high-1);

      R.ResultValid(R.ResultValid'low)                         <= '0';
      R.ResultValid(R.ResultValid'low+1 to R.ResultValid'high) <= R.ResultValid(R.ResultValid'low to R.ResultValid'high-1);
      R.PrevDecimator                                          <= iDecimator;

      if iValid = '1' then              -- Valid(0)

        R.FirIdx <= (R.FirIdx + 1) mod (cFirCoeff'length/cCoefficients);

        case iDecimator is
          when M1 =>
            R.Counter                        <= 1;
            R.FirIdx                         <= 0;
            R.ResultValid(R.ResultValid'low) <= '1';
          when M2 =>
            if R.Counter = 0 then
              R.Counter                        <= 1;
              R.FirIdx                         <= 0;
              R.ResultValid(R.ResultValid'low) <= '1';
            else
              R.Counter <= R.Counter - 1;
            end if;
          when M4 =>
            if R.Counter = 0 then
              R.Counter                        <= 3;
              R.FirIdx                         <= 2;
              R.ResultValid(R.ResultValid'low) <= '1';
            else
              R.Counter <= R.Counter - 1;
            end if;
          when M10 =>
            if R.Counter = 0 then
              R.Counter                        <= 9;
              R.FirIdx                         <= 6;
              R.ResultValid(R.ResultValid'low) <= '1';
            else
              R.Counter <= R.Counter - 1;
            end if;
          when others =>
            null;
        end case;

        if R.PrevDecimator /= iDecimator then
          case iDecimator is
            when M1  => R.Counter <= 1;
            when M2  => R.Counter <= 2;
            when M4  => R.Counter <= 4;
            when M10 => R.Counter <= 9;
          end case;
        end if;
      end if;
    end if;
  end process;

  oValid <= R.ResultValid(cValidDelay);

  FIR : for i in 0 to cChannels-1 generate
    Slave : entity DSO.LongFastPolyPhaseDecimator
      port map (
        iClk         => iClk,
        iResetAsync  => iResetAsync,
        iDecimator   => iDecimator,
        iData        => iData(i),
        iInputValid  => iValid,
        iSumValid    => R.Valid(cValidDelay-1),
        iResultValid => R.ResultValid(cValidDelay),
        iCoeff       => Coeff,
        oData        => oData(i));
  end generate;

end architecture;
