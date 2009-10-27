-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : ADC-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-09-11
-- Platform   : W2000A
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
    iClkADC      : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000  25 MHz
--    iLocked : in std_ulogic;
    iADC         : in  aADCIn;
    iDecimator   : in  std_ulogic_vector(3 downto 0);
    iFilterDepth : in  aFilterDepth;
    oLocked      : out std_ulogic;
    oClk125      : out std_ulogic;
    oClk625      : out std_ulogic;
    oClkADC      : out std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000 250 MHz
    oData        : out aADCout);
end entity;

architecture RTL of ADC is
  constant cADCAddrWidth : natural := 5;
  constant cSetup        : time    := 3 ns;
  constant cHold         : time    := 2 ns;
  type     aLocked is array (0 to cADCsperChannel-1) of std_ulogic_vector(0 to 1);
  type     aADCCounter is array (0 to cADCsperChannel-1) of unsigned(cADCAddrWidth-1 downto 0);
  type     aX is array (0 to cADCsperChannel-1) of std_ulogic_vector(15 downto 0);
  subtype  aADCInPhase is aADCData(0 to cChannels-1);
  signal   ClkADC250     : std_ulogic_vector (0 to cADCsperChannel-1);
  signal   Clk125        : std_ulogic_vector (0 to cADCsperChannel-1);
  signal   Locked        : std_ulogic_vector(0 to 3);
  -- signal   areset        : std_ulogic;
  signal   ADCp          : aADCIn;
  signal   ADCn          : aADCIn;
  signal   Phase0p       : aADCInPhase;
  signal   Phase1p       : aADCInPhase;
  signal   Phase2p       : aADCInPhase;
  signal   Phase3p       : aADCInPhase;
  signal   Phase0n       : aADCInPhase;
  signal   Phase1n       : aADCInPhase;
  signal   Phase2n       : aADCInPhase;
  signal   Phase3n       : aADCInPhase;
  signal   P1ptoP1n      : aADCInPhase;
  signal   P2ptoP0p      : aADCInPhase;
  signal   P2ntoP0n      : aADCInPhase;
  signal   Delay         : aADCout;

  signal pllena : std_ulogic_vector(0 to 2);
begin

  -- Locked(Locked'high) <= Locked(0) and Locked(1) and Locked(2) and Locked(3);
  oClk125 <= Clk125(3);
  oClkADC <= ClkADC250;
  -- oLocked             <= Locked125(Locked125'high);
  oLocked <= Locked(3);

  -- areset <= iResetAsync when cResetActive = '1' else
  --           not iResetAsync;

  -- turns all clock domains off if they are unused!
  -- This does reduce the electromagnetic emmision
  PLLControl : process (Clk125(3), Locked(3))
  begin
    if Locked(3) = '0' then
      pllena <= (others => '0');
    elsif rising_edge(Clk125(3)) then
      if iFilterDepth = 0 then
        case iDecimator is
          when X"1" =>
            pllena <= "111";
          when X"2" =>
            pllena <= "010";
          when others =>
            pllena <= "000";
        end case;
      else
        pllena <= "111";
      end if;
    end if;
  end process;

  PLL0 : entity DSO.PLL0
    port map (
--      areset => areset,
      pllena => pllena(0),
      inclk0 => iClkADC(0),
      c0     => ClkADC250(0),
      c1     => Clk125(0),
      locked => Locked(0));

  PLL1 : entity DSO.PLL1
    port map (
      --    areset => areset,
      inclk0 => iClkADC(1),
      pllena => pllena(1),
      c0     => ClkADC250(1),
      c1     => Clk125(1),
      locked => Locked(1));

  PLL2 : entity DSO.PLL2
    port map (
      --    areset => areset,
      inclk0 => iClkADC(2),
      pllena => pllena(2),
      c0     => ClkADC250(2),
      c1     => Clk125(2),
      locked => Locked(2));

  -- The pll clk signals are stable for 10000 cycles before Locked(3) is asserted!
  PLL3 : entity DSO.PLL3
    port map (
      --  areset => areset,
      inclk0 => iClkADC(3),
      pllena => '1',
      c0     => ClkADC250(3),
      c1     => Clk125(3),
      c2     => oClk625,
      locked => Locked(3));

  pInput : for i in 0 to cADCsperChannel-1 generate
    process(Clk125(i), Locked(i))
    begin
      if Locked(i) = '0' then
        ADCn(i) <= (others => (others => '0'));
        ADCp(i) <= (others => (others => '0'));
      elsif falling_edge(Clk125(i)) then
        --       ADCn(i) <= reject cHold inertial (others => (others => 'X')), iADC(i) after cSetup;
        ADCn(i) <= reject cHold inertial iADC(i) after cSetup;
      elsif rising_edge(Clk125(i)) then
        --       ADCp(i) <= reject cHold inertial (others => (others => 'X')), iADC(i) after cSetup;
        ADCp(i) <= reject cHold inertial iADC(i) after cSetup;
      end if;
    end process;
  end generate;

  -----------------------------------------------------------------------------
  -- untreated jitter by quartus 300 ps per clock
  -- this means 600 ps between two different plls output clocks
  -- setup time goal >= 3 ns
  -- hold  time goal >= 2 ns 
  -----------------------------------------------------------------------------
  -- Timing relation to Clkp(3) (positive egde of Clk125(3))
  -- clock  | setup | hold
  -- Clkp(0)| 3 ns  | 5 ns
  -- Clkp(1)| 2 ns  | 6 ns -- setup time
  -- Clkp(2)| 1 ns  | 7 ns -- setup time
  -- Clkp(3)| 0 ns  | 0 ns
  -- Clkn(0)| 7 ns  | 1 ns -- hold time
  -- Clkn(1)| 6 ns  | 2 ns
  -- Clkn(2)| 5 ns  | 3 ns
  -- Clkn(3)| 4 ns  | 4 ns

  -- Clkp(1) => Clkn(1) setup 4 ns hold 4 ns
  -- Clkp(2) => Clkp(0) setup 6 ns hold 2 ns
  -- Clkn(2) => Clkn(0) setup 6 ns hold 2 ns

  p1n : process (Clk125(1), Locked(1))
  begin
    if Locked(1) = '0' then
      P1ptoP1n <= (others => (others => '0'));
    elsif falling_edge(Clk125(1)) then
      for i in 0 to cChannels -1 loop
        --       P1ptoP1n(i) <= reject cHold inertial (others => 'X'), ADCp(1)(i) after cSetup;
        P1ptoP1n(i) <= reject cHold inertial ADCp(1)(i) after cSetup;
      end loop;
    end if;
  end process;

  p0n : process (Clk125(0), Locked(0))
  begin
    if Locked(0) = '0' then
      P2ntoP0n <= (others => (others => '0'));
    elsif falling_edge(Clk125(0)) then
      for i in 0 to cChannels -1 loop
        --       P2ntoP0n(i) <= reject cHold inertial (others => 'X'), ADCn(2)(i) after cSetup;
        P2ntoP0n(i) <= reject cHold inertial ADCn(2)(i) after cSetup;
      end loop;
    end if;
  end process;

  p0p : process (Clk125(0), Locked(0))
  begin
    if Locked(0) = '0' then
      P2ptoP0p <= (others => (others => '0'));
    elsif rising_edge(Clk125(0)) then
      for i in 0 to cChannels -1 loop
        --       P2ptoP0p(i) <= reject cHold inertial (others => 'X'), ADCp(2)(i) after cSetup;
        P2ptoP0p(i) <= reject cHold inertial ADCp(2)(i) after cSetup;
      end loop;
    end if;
  end process;

  p3p : process (Clk125(3), Locked(3))
  begin
    if Locked(3) = '0' then
      Phase0p <= (others => (others => '0'));
      Phase1p <= (others => (others => '0'));
      Phase2p <= (others => (others => '0'));
      Phase3p <= (others => (others => '0'));
      Phase0n <= (others => (others => '0'));
      Phase1n <= (others => (others => '0'));
      Phase2n <= (others => (others => '0'));
      Phase3n <= (others => (others => '0'));
      Delay   <= (others => (others => (others => '-')));

    elsif rising_edge(Clk125(3)) then
      for i in 0 to cChannels-1 loop
        Phase0p(i)  <= reject cHold inertial ADCn(0)(i)  after cSetup;
        Phase1p(i)  <= reject cHold inertial ADCn(1)(i)  after cSetup;
        Phase2p(i)  <= reject cHold inertial P2ntoP0n(i) after cSetup;
        Phase3p(i)  <= reject cHold inertial ADCn(3)(i)  after cSetup;
        Phase0n(i)  <= reject cHold inertial ADCp(0)(i)  after cSetup;
        Phase1n(i)  <= reject cHold inertial P1ptoP1n(i) after cSetup;
        Phase2n(i)  <= reject cHold inertial P2ptoP0p(i) after cSetup;
        Phase3n(i)  <= reject cHold inertial ADCp(3)(i)  after cSetup;
        Delay(i)(0) <= reject cHold inertial Phase0p(i)  after cSetup;
        Delay(i)(1) <= reject cHold inertial Phase1p(i)  after cSetup;
        --   Delay(i)(2) <= reject cHold inertial Phase2p(i)  after cSetup;
        Delay(i)(3) <= reject cHold inertial Phase3p(i)  after cSetup;
        Delay(i)(4) <= reject cHold inertial Phase0n(i)  after cSetup;
        --  Delay(i)(7) <= reject cHold inertial Phase3n(i)  after cSetup;    
      end loop;
    end if;
  end process;

  process (Phase1n, Phase2n, Phase2p, Phase3n, Delay)
  begin
    for i in 0 to cChannels-1 loop
      oData(i)(0) <= Delay(i)(0);
      oData(i)(1) <= Delay(i)(1);
      oData(i)(2) <= Phase2p(i);
      oData(i)(3) <= Delay(i)(3);
      oData(i)(4) <= Delay(i)(4);
      oData(i)(5) <= Phase1n(i);
      oData(i)(6) <= Phase2n(i);
      oData(i)(7) <= Phase3n(i);
    end loop;
  end process;

end architecture;
