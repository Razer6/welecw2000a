-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : ADC-ea.vhd
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
use DSO.pPolyPhaseDecimator.all;

entity ADC is
  port (
--    iClkDesign  : in std_ulogic;
--    iResetAsync : in  std_ulogic;
    iClkADC : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000  25 MHz
--    iLocked : in std_ulogic;
    iADC    : in  aADCIn;
    oLocked : out std_ulogic;
    oClk125 : out std_ulogic;
    oClk625 : out std_ulogic;
    oClkADC : out std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000 250 MHz
    oData   : out aADCout);
end entity;

architecture RTL of ADC is
  constant cADCAddrWidth : natural := 5;
  type     aLocked is array (0 to cADCsperChannel-1) of std_ulogic_vector(0 to 1);
  type     aADCCounter is array (0 to cADCsperChannel-1) of unsigned(cADCAddrWidth-1 downto 0);
  type     aX is array (0 to cADCsperChannel-1) of std_ulogic_vector(15 downto 0);
  type     aSyncRamOut is array (0 to cADCsperChannel-1) of aX;
  signal   ClkADC250     : std_ulogic_vector (0 to cADCsperChannel-1);
  signal   Clk125        : std_ulogic;
  signal   Locked        : std_ulogic_vector(0 to 4);
  -- signal   areset        : std_ulogic;
  signal   ADC           : aADCIn;
  signal   InvPhase2     : aADCInPhase(0 to 0);
  signal   Phase0        : aADCInPhase(1 downto 0);
  signal   Phase1        : aADCInPhase(1 downto 0);
  signal   Phase2        : aADCInPhase(0 downto 0);
  signal   Phase3        : aADCInPhase(2 downto 0);
begin
  
 -- Locked(Locked'high) <= Locked(0) and Locked(1) and Locked(2) and Locked(3);
  oClk125             <= Clk125;
  oClkADC             <= ClkADC250;
  -- oLocked             <= Locked125(Locked125'high);
  oLocked             <= Locked(3);

  -- areset <= iResetAsync when cResetActive = '1' else
  --           not iResetAsync;

  PLL0 : entity work.PLL0
    port map (
--      areset => areset,
      pllena => '1',
      inclk0 => iClkADC(0),
      c0     => ClkADC250(0),
      locked => Locked(0));

  PLL1 : entity work.PLL1
    port map (
      --    areset => areset,
      inclk0 => iClkADC(1),
      pllena => '1',
      c0     => ClkADC250(1),
      locked => Locked(1));

  PLL2 : entity work.PLL2
    port map (
      --    areset => areset,
      inclk0 => iClkADC(2),
      pllena => '1',
      c0     => ClkADC250(2),
      locked => Locked(2));
  
  -- The pll clk signals are stable for 10000 cycles before Locked(3) is asserted!
  PLL3 : entity work.PLL3
    port map (
      --  areset => areset,
      inclk0 => iClkADC(3),
      pllena => '1',
      c0     => ClkADC250(3),
      c1     => Clk125,
      c2     => oClk625,
      locked => Locked(3));

  pInput : for i in 0 to cADCsperChannel-1 generate
    process(ClkADC250(i), Locked(3))
    begin
      if Locked(3) = '0' then
        ADC(i) <= (others => (others => '0'));
      elsif rising_edge(ClkADC250(i)) then
        ADC(i) <= iADC(i);
      end if;
    end process;
  end generate;

  pInvPhase2 : process (ClkADC250(2), Locked(3))
  begin
    if Locked(3) = '0' then
       InvPhase2(0) <= (others => (others => '0'));
    elsif falling_edge(ClkADC250(2)) then
      InvPhase2(0) <= ADC(2);
    end if;
  end process;

  p250 : process (Locked(3), ClkADC250(3))
  begin
    if Locked(3) = '0' then
      Phase0 <= (others => (others => (others => '0')));
      Phase1 <= (others => (others => (others => '0')));
      Phase2 <= (others => (others => (others => '0')));
      Phase3 <= (others => (others => (others => '0')));
    elsif rising_edge(ClkADC250(3)) then
      Phase0(1)          <= ADC(0);
      Phase1(1)          <= ADC(1);
      Phase2(0)          <= InvPhase2(0);
      Phase3(2)          <= ADC(3);
      Phase0(0)          <= Phase0(1);
      Phase1(0)          <= Phase1(1);
      Phase3(1 downto 0) <= Phase3(2 downto 1);
    end if;
  end process;

  p125 : process (Locked(3), Clk125)
  begin
    if Locked(3) = cResetActive then
      oData <= (others => (others => (others => '0')));
    elsif rising_edge(Clk125) then
      for i in 0 to cChannels-1 loop
        oData(i)(0) <= Phase0(0)(i);
        oData(i)(2) <= Phase1(0)(i);
        oData(i)(4) <= Phase2(0)(i);
        oData(i)(6) <= Phase3(0)(i);
      end loop;
    elsif falling_edge(Clk125) then
      for i in 0 to cChannels-1 loop
        oData(i)(1) <= Phase0(0)(i);
        oData(i)(3) <= Phase1(0)(i);
        oData(i)(5) <= Phase2(0)(i);
        oData(i)(7) <= Phase3(0)(i);
      end loop;
    end if;
  end process;


end architecture;
