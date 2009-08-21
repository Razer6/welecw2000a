-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : FastAverage-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-09
-- Last update: 2009-03-04
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: out of date! use AdderTreeFilter-ea.vhd
-- This Decimator is designed to sample down from 1 Gs to 500, 250
-- and 100 Ms with only 13 dB.
-- Multipliers are far to less to be avialable for here! A way to improve this
-- is using instead of the boxcar the bartlett window with shift
-- multiplications.
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
-- 2008-08-09  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;

entity FastAverage is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iDecimator  : in  aDecimator;
    iData       : in  aFastData;        -- fixpoint 1.x range -0.5 to <0.5
    oData       : out aFastData;        -- fixpoint 1.x range -1 to <1
    oValid      : out std_ulogic;
    oStageData  : out aLongValue;
    oStageValid : out std_ulogic);
end entity;

architecture RTL of FastAverage is
  
  constant cShiftRegLength : integer := cCoefficients+(cDecAvgMax*2);
  signal   ShiftReg        : aValues(0 to cShiftRegLength-1);
  -- lines of the add tree
  signal   Line1           : aValues(0 to cShiftRegLength/2-1);
  signal   Line2           : aValues(0 to cShiftRegLength/2-2);
  signal   Line3           : aValues(0 to cShiftRegLength/2-4);
  signal   Line4           : aValues(0 to cShiftRegLength/2-12);
  signal   Delayer         : aValues(1 to 2);  -- delay needed between Line1 and Line4
                                               -- for M10
  signal   L10             : aValue;
  signal   L10RegCounter   : natural range 0 to cCoefficients-1;
  signal   M10State        : natural range 0 to 4;
  signal   M10Valid        : std_ulogic;
  signal   M10MuxLine1     : aValues(0 to 1);
  signal   M10Line         : aValues(1 to 3);  -- delay needed between Line1 and Line4 for M10;
  signal   M10MuxLine4     : aValue;
  signal   DataOut         : aFastData;
begin

  
  ShiftReg(iData'range) <= iData;

  Avg : process (iResetAsync, iClk)
 --   variable L10ShiftReg : aValues(0 to cCoefficients-1);
    variable X10         : aValue;
  begin
    
    if iResetAsync = cResetActive then

      --   ShiftReg(cCoefficients to ShiftReg'high) <= (others => (others => '0'));
      Line1         <= (others => (others => '0'));
      Line2         <= (others => (others => '0'));
      Line3         <= (others => (others => '0'));
      Line4         <= (others => (others => '0'));
      L10           <= (others => '0');
    --  L10ShiftReg   := (others => (others => '0'));
      L10RegCounter <= 0;
      M10Valid      <= '0';
      M10State      <= 0;
      M10MuxLine1   <= (others => (others => '0'));
      M10Line       <= (others => (others => '0'));  -- delay needed between Line1 and Line4 for M10;
      M10MuxLine4   <= (others => '0');
      Delayer       <= (others => (others => '0'));
      DataOut       <= (others => (others => '0'));
      oValid        <= '0';
    elsif rising_edge(iClk) then

      -- ShiftReg(cCoefficients to ShiftReg'high) <= ShiftReg(0 to ShiftReg'high-cCoefficients);

      -- add inputs to pairs
      -- for i in 0 to Line1'high loop
      for i in 0 to 3 loop              -- optimised
        Line1(i) <= ShiftReg(2*i) + ShiftReg(2*i+1);
      end loop;

      -- optimisation
      Line1(4 to Line1'high) <= Line1(0 to Line1'high-4);

      -- add pairs to other values in fixed point 1.x
      -- Line2(0) = z-0 + z-1 + z-2 + z-3
      -- Line2(1) = z-2 + z-3 + z-4 + z-5
      -- Line2(2) = z-4 + z-5 + z-7 + z-7
      -- for i in 0 to Line2'high loop
      for i in 0 to 3 loop              -- optimised
        Line2(i) <= Avg9Bit(Line1(i), Line1(i+1));
      end loop;

      Line2(4 to Line2'high) <= Line2(0 to Line2'high-4);

      -- make the M2 output
      -- Line3(0) = z-0 + z-1 + ... z-7
      -- Line3(1) = z-2 + z-3 + ... z-9
      -- for i in 0 to Line3'high loop
      for i in 0 to 3 loop              -- optimised  
        Line3(i) <= Avg9Bit(Line2(i), Line2(i+2));
      end loop;

      Line3(4 to Line3'high) <= Line3(0 to Line3'high-4);

      -- make the M4 output
      -- Line4(0) = z-0  + z-1  + ... z-15
      -- Line4(1) = z-4  + z-5  + ... z-19
      -- Line4(2) = z-8  + z-9  + ... z-23
      -- Line4(3) = z-12 + z-13 + ... z-27
      -- Line4(4) = z-16 + z-17 + ... z-31
      for i in 0 to Line4'high loop
        Line4(i) <= Avg9Bit(Line3(2*i), Line3(2*i+4));
      end loop;


      M10Valid <= '0';
      -- this small hack saves a few luts in the fpga without harming the simulation
      X10      := Avg9Bit(M10MuxLine4, M10Line(3));
      if is_x(std_ulogic_vector(X10)) then
        L10 <= (others => '0');
      else
        L10 <= X10;
      end if;
      M10MuxLine1 <= (others => (others => '-'));
      M10MuxLine4 <= (others => '-');

      M10Line(1) <= Avg9Bit(M10MuxLine1(0), M10MuxLine1(1));
      for i in 2 to M10Line'high loop
        M10Line(i) <= M10Line(i-1)(cBitwidth-1) & M10Line(i-1)(cBitwidth-1 downto 1);  -- delay needed between Line1 and Line4 for M10;
      end loop;

      case M10State is
        when 0 =>
          M10MuxLine1(0) <= Line1(10);  -- 3
          M10MuxLine1(1) <= Line1(1);
          M10State       <= 1;
          M10Valid       <= '1';
        when 1 =>
          M10MuxLine1(0) <= Line1(0);   -- 4
          M10MuxLine1(1) <= Line1(1);
          M10MuxLine4    <= Line4(2);
          M10State       <= 2;
          M10Valid       <= '0';
        when 2 =>
          M10MuxLine4 <= Line4(1);      -- 0
          M10State    <= 3;
          M10Valid    <= '1';
        when 3 =>
          M10MuxLine1(0) <= Line1(12);  -- 1
          M10MuxLine1(1) <= Line1(3);
          M10MuxLine4    <= Line4(1);
          M10State       <= 4;
          M10Valid       <= '1';
        when 4 =>
          M10MuxLine1(0) <= Line1(10);  -- 2
          M10MuxLine1(1) <= Line1(11);
          M10MuxLine4    <= Line4(1);
          M10State       <= 0;
          M10Valid       <= '1';
      end case;

      -- default for all channels: the '-' value can reduce the design size in synthesis
      --    oData  <= (others => (others => '-'));
      oValid <= '1';
      case iDecimator is
        when M1 =>
          for i in iData'range loop
            DataOut(i) <= iData(i)(cBitWidth-2 downto 0) & '0';  -- multiplied by 2
          end loop;
          oValid <= '1';
        when M2 =>
--          for i in 0 to 1 loop
--            for j in 0 to cCoefficients/2-1 loop
--              oData(i*cCoefficients/2 + j) <= Line3(cCoefficients/2-1-j);
--            end loop;
--            if i = 1 then
--              oValid <= '1';
--            end if;
--          end loop;
          if L10RegCounter = 0 then
            L10RegCounter <= 1;
          else
            oValid        <= '0';
            L10RegCounter <= L10RegCounter -1;
          end if;
          for i in 0 to cCoefficients/2-1 loop
            DataOut(i+cCoefficients/2) <= Line3(cCoefficients/2-1-i);
            DataOut(i)                 <= DataOut(i+cCoefficients/2);
          end loop;
        when M4 =>
--          for i in 0 to 3 loop
--            for j in 0 to cCoefficients/4-1 loop
--              oData(i*cCoefficients/4 + j) <= Line4(cCoefficients/4-1-j);
--            end loop;
--            if i = 3 then
--              oValid <= '1';
--            end if;
--          end loop;
          if L10RegCounter = 0 then
            L10RegCounter <= 4;
            oValid <= '1';
          else
            oValid        <= '0';
            L10RegCounter <= L10RegCounter -1;
          end if;
          for i in 0 to cCoefficients/4-1 loop
            DataOut(i+cCoefficients*3/4) <= Line4(cCoefficients/4-1-i);
          end loop;
          DataOut(0 to cCoefficients*3/4-1) <=
            DataOut(cCoefficients/4 to cCoefficients-1);

          --oData(0 to cCoefficients/4-1) <= Line4(0 to cCoefficients/4-1);
          
        when M10 =>
          oValid <= '0';
          if M10Valid = '1' then
            L10RegCounter <= (L10RegCounter + 1) mod cCoefficients;
            if L10RegCounter /= 0 then
              oValid <= '1';
            end if;
            DataOut <= DataOut(1 to DataOut'high) & L10;
          end if;
         -- DataOut <= L10ShiftReg;  -- L10ShiftReg is a variable no extra register (delay)
      end case;
    end if;
  end process;
  oData                                      <= DataOut;
  oStageData(cBitWidth*2-1 downto cBitWidth) <= signed(L10);
  oStageData(cBitWidth-1 downto 0)           <= (others => '0');
  oStageValid                                <= M10Valid;
  
end architecture;
