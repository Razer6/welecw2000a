-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : AdderTreeFilter-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-07-05
-- Last update: 2009-11-14
-- Platform   : 
-------------------------------------------------------------------------------
-- Description:
-- Bartlett-Filter which can handle multiple input coefficients per clock
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
-- 2009-07-05  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pPolyphaseDecimator.all;

entity AdderTreeFilter is
  port (
    iClk         : in  std_ulogic;
    iResetAsync  : in  std_ulogic;
    iDecimator   : in  std_ulogic_vector(3 downto 0);
    iFilterDepth : in  aFilterDepth;
    iData        : in  aFastData;
    oData        : out aLongFastData;
    oValid       : out std_ulogic;
    oStageData   : out aLongValue;
    oStageValid  : out std_ulogic);
end entity;

architecture RTL of AdderTreeFilter is
  
  signal Filtered      : aLongFastData;
  signal DataOut       : aLongFastData;
  signal Counter       : integer range 0 to 7;
  signal PrevDecimator : std_ulogic_vector(3 downto 0);

  constant cL0 : natural := 1;
  constant cL1 : natural := 1;
  constant cL2 : natural := 2;
  constant cL3 : natural := 2;
  constant cL4 : natural := 4;
  constant cL5 : natural := 4;
  constant cL6 : natural := 0;

  type aL0 is array (0 to cCoefficients-1+cL0) of signed(cBitWidth-1 downto 0);
  type aL1 is array (0 to cCoefficients-1+cL1) of signed(cBitWidth+0 downto 0);
  type aL2 is array (0 to cCoefficients-1+cL2) of signed(cBitWidth+1 downto 0);
  type aL3 is array (0 to cCoefficients-1+cL3) of signed(cBitWidth+2 downto 0);
  type aL4 is array (0 to cCoefficients-1+cL4) of signed(cBitWidth+3 downto 0);
  type aL5 is array (0 to cCoefficients-1+cL5) of signed(cBitWidth+4 downto 0);
  type aL6 is array (0 to cCoefficients-1+cL6) of signed(cBitWidth+5 downto 0);
--  type aL7 is array (0 to cCoefficients-1) of signed(cBitWidth+6 downto 0);
  type aTreeStages is record
                        L0 : aL0;
                        L1 : aL1;
                        L2 : aL2;
                        L3 : aL3;
                        L4 : aL4;
                        L5 : aL5;
                        L6 : aL6;
                      end record;
  signal Tree : aTreeStages;
begin

--  pInput : process (iData)
--  begin
  gIn : for i in 0 to cCoefficients-1 generate
    Tree.L0(i+1) <= iData(i);
  end generate;
--  end process;

  pTree : process (iResetAsync, iClk)
  begin
    if iResetAsync = cResetActive then
--      Tree.L0(0)    <= (others => '0');
--      Tree.L1       <= (others => (others => '0'));
--      Tree.L2       <= (others => (others => '0'));
--      Tree.L3       <= (others => (others => '0'));
--      Tree.L4       <= (others => (others => '0'));
--      Tree.L5       <= (others => (others => '0'));
--      Tree.L6       <= (others => (others => '0'));
--      Filtered      <= (others => (others => '0'));
--      DataOut       <= (others => (others => '0'));
      oValid        <= '0';
--      oStageData    <= (others => '0');
      oStageValid   <= '0';
      Counter       <= 0;
      PrevDecimator <= (others => '0');
    elsif rising_edge(iClk) then
      
      Tree.L0(0) <= Tree.L0(cCoefficients);

      Tree.L1(0) <= Tree.L1(cCoefficients);
      for i in 0 to cCoefficients-1 loop
        Tree.L1(i+1) <= AddAndExtend(Tree.L0(i), Tree.L0(i+1), Tree.L0(0)'length);
      end loop;

      Tree.L2(0 to 1) <= Tree.L2(cCoefficients to cCoefficients+1);
      for i in 0 to cCoefficients-1 loop
        Tree.L2(i+2) <= AddAndExtend(Tree.L1(i), Tree.L1(i+1), Tree.L1(0)'length);
      end loop;

      Tree.L3(0 to 1) <= Tree.L3(cCoefficients to cCoefficients+1);
      for i in 0 to cCoefficients-1 loop
        Tree.L3(i+2) <= AddAndExtend(Tree.L2(i), Tree.L2(i+2), Tree.L2(0)'length);
      end loop;

      Tree.L4(0 to 3) <= Tree.L4(cCoefficients to cCoefficients+3);
      for i in 0 to cCoefficients-1 loop
        Tree.L4(i+4) <= AddAndExtend(Tree.L3(i), Tree.L3(i+2), Tree.L3(0)'length);
      end loop;

      Tree.L5(0 to 3) <= Tree.L5(cCoefficients to cCoefficients+3);
      for i in 0 to cCoefficients-1 loop
        Tree.L5(i+4) <= AddAndExtend(Tree.L4(i), Tree.L4(i+4), Tree.L4(0)'length);
      end loop;

      -- Tree.L6(0 to 7) <= Tree.L6(cCoefficients to cCoefficients+7);
      for i in 0 to cCoefficients-1 loop
        Tree.L6(i) <= AddAndExtend(Tree.L5(i), Tree.L5(i+4), Tree.L5(0)'length);
      end loop;

      Filtered <= (others => (others => '0'));
      for i in 0 to cCoefficients-1 loop
        case iFilterDepth is
          when 0 =>
            Filtered(i)(aLongValue'high downto aLongValue'length-Tree.L0(0)'length) <= Tree.L0(i+1);
          when 1 =>
            Filtered(i)(aLongValue'high downto aLongValue'length-Tree.L2(0)'length) <= Tree.L2(i+2);
          when 2 =>
            Filtered(i)(aLongValue'high downto aLongValue'length-Tree.L4(0)'length) <= Tree.L4(i+4);
          when 3 =>
            Filtered(i)(aLongValue'high downto aLongValue'length-Tree.L6(0)'length) <= Tree.L6(i);
        end case;
      end loop;
      oValid      <= '0';
      oStageValid <= '0';
      Counter     <= (Counter -1) mod 8;
  --    DataOut     <= Filtered;
      oStageData  <= Filtered(7);

      case iDecimator is
        when X"1" =>
          DataOut <= Filtered;
          oValid  <= '1';
          Counter <= 0;
        when X"2" =>
          for i in 0 to cCoefficients/2-1 loop
            DataOut(i+cCoefficients/2) <= Filtered(2*i+1);  -- +1 CLK250(0,2) are off, when Filterdepth = 0
            DataOut(i)                 <= DataOut(i+cCoefficients/2);
          end loop;
          if Counter = 0 then
            Counter <= 1;
            oValid  <= '1';
          end if;
        when X"4" =>                    -- non interleaved mode for W2000A :-)
          for i in 0 to cCoefficients/4-1 loop
            DataOut(i+6) <= Filtered(4*i+3);-- +3 CLK250(0,1,2) are off, when Filterdepth = 0
          end loop;
          DataOut(0 to 5) <= DataOut(2 to 7);
          if Counter = 0 then
            Counter <= 3;
            oValid  <= '1';
          end if;
        when X"8" =>                    -- non interleaved mode for W2000A :-)
          Counter     <= 0;
          oStageData  <= Filtered(7);   -- +7 CLK250(0,1,2) are off, when Filterdepth = 0
          oStageValid <= '1';
        when X"A" =>                    --10
          oStageValid <= '1';
          case Counter is
            when 0 => oStageValid <= '0';
                      Counter <= 4;
            when 1      => oStageData <= Filtered(1);
            when 2      => oStageData <= Filtered(3);
            when 3      => oStageData <= Filtered(5);
            when 4      => oStageData <= Filtered(7);
            when others =>
              oStageData <= (others => 'X');
          end case;
        when others =>
          DataOut <= Filtered;
          oValid  <= '1';
          Counter <= 0;
      end case;
      PrevDecimator <= iDecimator;
      if PrevDecimator /= iDecimator then
        Counter <= 0;
      end if;
      
    end if;
  end process;

  oData <= DataOut;
  
end architecture;
