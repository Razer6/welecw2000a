-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : TopPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
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
-- 2009-05-19  1.0
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
  constant cValidDelay : integer := 5;
  signal   Coeff       : aLongValue;
  type     aState is (NewConv, Calc, CalcLast, NewPhase);

  type aR is record
               State       : aState;
               PhaseAddr   : unsigned(3 downto 0);  -- 10 polyphases;
               ReadAddr    : unsigned(2 downto 0);  -- 8 coefficients per phase
               WriteAddr   : unsigned(2 downto 0);
               WriteEn     : std_ulogic;
               FirAddr     : aFirAddr;
               Valid       : std_ulogic_vector(1 to cValidDelay);
               ResultValid : std_ulogic_vector(1 to cValidDelay);
               FirCounter  : natural range 0 to 7;
             end record;
  signal R                   : aR;
  signal ReadAddr, WriteAddr : unsigned(cDelayMemWidth-1 downto 0);
  signal WriteEn             : std_ulogic;

  type aDR is record
                ReadData   : aLongValue;
                MultValue  : aLongValue;
                MultResult : aLongValue;
                Sum        : aLongValue;
              end record;
  
  type   aChData is array (0 to cChannels-1) of aDR;
  signal Channel : aChData;
  
begin
  
  Reg : process(iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Coeff <= (others => '0');
    elsif rising_edge(iClk) then
      Coeff <= to_signed(cFirCoeff(R.FirAddr mod cFirCoeff'length), aLongValue'length);
    end if;
  end process;

  Control : process (iClk, iResetAsync)
    constant cPhaseReadAddr : unsigned(3 downto 0) := to_unsigned(2-1, 4);
  begin
    if iResetAsync = cResetActive then
      R <= (
        State       => NewConv,
        PhaseAddr   => (others => '0'),
        ReadAddr    => (others => '0'),
        WriteAddr   => (others => '0'),
        WriteEn     => '0',
        FirAddr     => 0,
        Valid       => (others => '0'),
        ResultValid => (others => '0'),
        FirCounter  => 6);
    elsif rising_edge(iClk) then
      R.Valid(R.Valid'low)                              <= '0';
      R.Valid(R.Valid'low+1 to R.Valid'high)            <= R.Valid(R.Valid'low to R.Valid'high-1);
      R.ResultValid(R.ResultValid'low+1 to cValidDelay) <= R.ResultValid(1 to cValidDelay-1);
      R.ResultValid(R.ResultValid'low)                  <= '0';
      R.WriteEn                                         <= '0';

      if R.Valid(1) = '1' then
        R.ReadAddr <= R.ReadAddr -1;
      end if;
      if R.Valid(3) = '1' then
        R.FirAddr <= (R.FirAddr +1) mod 2 ** cDelayMemWidth;
      end if;

      case R.State is
        when NewConv =>
          R.ReadAddr <= R.ReadAddr;
          if iValid = '1' then
            case iDecimator is
              when M1 | M2 =>
                R.PhaseAddr <= to_unsigned(2-1, 4);
                R.FirAddr   <= (0) mod 2**cDelayMemWidth;
              when M4 =>
                R.PhaseAddr <= to_unsigned(4-1, 4);
                R.FirAddr   <= 16;
              when M10 =>
                R.PhaseAddr <= to_unsigned(10-1, 4);
                R.FirAddr   <= 48;
            end case;
            R.Valid(R.Valid'low) <= '1';
            R.WriteAddr          <= R.WriteAddr +1;
            R.ReadAddr           <= R.ReadAddr +1;
            R.FirCounter         <= 6;
            R.State              <= Calc;
          end if;
          
        when Calc =>
          R.FirCounter         <= (R.FirCounter -1) mod 8;
          R.Valid(R.Valid'low) <= '1';
          if R.FirCounter = 0 then
            R.State <= CalcLast;
          end if;
          
        when CalcLast =>
          if to_integer(R.PhaseAddr) = 0 then
            R.State                          <= NewConv;
            R.ResultValid(R.ResultValid'low) <= '1';
          else
            R.State <= NewPhase;
          end if;
          
        when NewPhase =>
          R.FirCounter <= 6;
          if iValid = '1' then
            R.State              <= Calc;
            R.Valid(R.Valid'low) <= '1';
            R.PhaseAddr          <= R.PhaseAddr -1;
          end if;
      end case;

    end if;
  end process;
  oValid <= R.ResultValid(cValidDelay);

  ReadAddr  <= R.PhaseAddr & R.ReadAddr;
  WriteAddr <= R.PhaseAddr & R.WriteAddr;
  WriteEn   <= R.WriteEn or iValid;

  CH : for i in 0 to cChannels-1 generate
    Data : DelayMemory
      port map(
        --    aclr          => aclr,
        clock         => iClk,
        data          => std_logic_vector(iData(i)),
        rdaddress     => std_logic_vector(ReadAddr),
        wraddress     => std_logic_vector(WriteAddr),
        wren          => WriteEn,
        aLongValue(q) => Channel(i).ReadData);

    Calc : process (iClk, iResetAsync)
      variable vRes : signed(2*aLongValue'length-1 downto 0);
    begin
      if iResetAsync = cResetActive then
        Channel(i).MultValue  <= (others => '0');
        Channel(i).MultResult <= (others => '0');
        Channel(i).Sum        <= (others => '0');
      elsif rising_edge(iClk) then
        Channel(i).MultValue  <= Channel(i).ReadData;  -- Ram Reg + Mul in Reg
        vRes                  := Channel(i).MultValue * Coeff;
        Channel(i).MultResult <= vRes(vRes'high downto vRes'high-Channel(0).MultResult'length+1);

        if R.Valid(R.Valid'high) = '1' then
          Channel(i).Sum <= Channel(i).Sum + Channel(i).MultResult;
        end if;

        if R.ResultValid(R.ResultValid'high) = '1' then
          Channel(i).Sum <= (others => '0');
        end if;
      end if;
    end process;

    oData(i) <= Channel(i).Sum;
  end generate;

end architecture;
