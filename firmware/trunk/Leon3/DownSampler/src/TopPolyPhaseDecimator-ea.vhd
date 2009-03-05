-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-03-04
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
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pFirCoeff.all;

entity TopPolyPhaseDecimator is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iDecimator  : in  aDecimator;
    iData       : in  aLongValues(0 to cChannels-1);
    iValid      : in  std_ulogic;
    oData       : out aLongValues(0 to cChannels-1);
    oValid      : out std_ulogic);
end entity;

architecture RTL of TopPolyPhaseDecimator is
  constant cValidDelay : integer := 3;
  signal   Coeff       : aLongValue;

  type     aR is record
                   ShiftEnable  : std_ulogic;
                   ReadAddr     : unsigned(7 downto 0);
                   WriteAddr    : unsigned(7 downto 0);
                   Delay        : unsigned(7 downto 0);
                   Valid        : std_ulogic_vector(1 to cValidDelay-1);
                   ResultValid  : std_ulogic_vector(1 to cValidDelay);
                   FirIdx       : aFirAddr;
                   PhaseCounter : natural range 0 to 10-1;
                   FirCounter   : natural range 0 to 8-1;
                 end record;
  signal R : aR;
begin
  
  Reg : process(iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Coeff <= (others => '0');
    elsif rising_edge(iClk) then
      Coeff <= to_signed(cFirCoeff(R.FirIdx), aLongValue'length);
    end if;
  end process;

  Control : process (iClk, iResetAsync)
    constant cInit : aR := (
      Delay        => (others => '0'),
      ReadAddr     => (others => '0'),
      WriteAddr    => (others => '0'),
      ShiftEnable  => '0',
      Valid        => (others => '0'),
      PhaseCounter => 0,
      FirCounter   => 0,
      FirIdx       => 0,
      ResultValid  => (others => '0'));
  begin
    if iResetAsync = cResetActive then
      R <= cInit;
    elsif rising_edge(iClk) then
      if iValid = '1' then
        assert(R.FirCounter = 0)
          report "This Polyphase FIR filter requires FirCounter+1 clock cycles between" &
          " each input sample!" severity failure;
      end if;
      R.ShiftEnable <= '0';
      if R.ShiftEnable = '1' then
        R.WriteAddr <= R.ReadAddr + R.Delay;
      end if;
      R.ResultValid(R.ResultValid'low)                         <= '0';
      R.ResultValid(R.ResultValid'low+1 to R.ResultValid'high) <=
        R.ResultValid(R.ResultValid'low to R.ResultValid'high-1);

      R.Valid(R.Valid'low)                   <= iValid;
      R.Valid(R.Valid'low+1 to R.Valid'high) <= R.Valid(R.Valid'low to R.Valid'high-1);

      if iValid = '1' then              -- Valid(0)
        R.ShiftEnable <= '1';
        R.ReadAddr    <= R.ReadAddr + to_unsigned(1, R.ReadAddr'length);
        R.FirCounter  <= 7;
        R.FirIdx      <= (R.FirIdx + 1) mod (cFirCoeff'length);
        if R.PhaseCounter = 0 and R.FirCounter = 0 then
          case iDecimator is
            when M1 =>
              R.PhaseCounter <= 2-1;
              R.FirIdx       <= 0;
              R.Delay        <= to_unsigned(16-1, R.Delay'length);
            when M2 =>
              R.PhaseCounter <= 2-1;
              R.FirIdx       <= 0;
              R.Delay        <= to_unsigned(16-1, R.Delay'length);
            when M4 =>
              R.PhaseCounter <= 4-1;
              R.FirIdx       <= 16;
              R.Delay        <= to_unsigned(32+1, R.Delay'length);
            when M10 =>
              R.PhaseCounter <= 10-1;
              R.FirIdx       <= 48;
              R.Delay        <= to_unsigned(64+23, R.Delay'length);
            when others =>
              null;
          end case;
          R.ResultValid(R.ResultValid'low) <= '1';
        else
          R.Valid(R.Valid'low)             <= '1';
          R.PhaseCounter                   <= R.PhaseCounter - 1;
          R.ResultValid(R.ResultValid'low) <= '0';
        end if;

      elsif R.FirCounter /= 0 then
        R.Valid(R.Valid'low) <= '1';
        R.FirIdx             <= (R.FirIdx + 1);  -- mod (cFirCoeff'length);
        R.FirCounter         <= R.FirCounter - 1;
        R.ShiftEnable        <= '1';
        R.ReadAddr           <= R.ReadAddr + to_unsigned(1, R.ReadAddr'length);
      else
        if R.Valid(R.Valid'low) = '1' then
          R.ShiftEnable <= '1';
          R.ReadAddr    <= R.ReadAddr + to_unsigned(1, R.ReadAddr'length);
        else
          R.ShiftEnable <= '0';
        end if;
      end if;
    end if;
  end process;
  oValid <= R.ResultValid(cValidDelay);

  FIR : for i in 0 to cChannels-1 generate
    Data : PolyPhaseDecimator
      port map (
        iClk          => iClk,
        iResetAsync   => iResetAsync,
        iDecimator    => iDecimator,
        iData         => iData(i),
        iInputValid   => iValid,
        iValidDelayed => R.Valid(R.Valid'low),
        iSumValid     => R.Valid(cValidDelay-1),
        iResultValid  => R.ResultValid(cValidDelay),
        iShiftEnable  => R.ShiftEnable,
        iFirCounter   => R.FirCounter,
        iReadAddr     => R.ReadAddr,
        iWriteAddr    => R.WriteAddr,
        iCoeff        => Coeff,
        oData         => oData(i));
  end generate;

end architecture;

