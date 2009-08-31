-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : ADC-SyncRam-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-08-26
-- Last update: 2009-08-29
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
-- 2009-08-26  1.0
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
    iClkADC : in  std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000  25 MHz
    iADC    : in  aADCIn;
    oLocked : out std_ulogic;
    oClk125 : out std_ulogic;
    oClk625 : out std_ulogic;
    oClkADC : out std_ulogic_vector (0 to cADCsperChannel-1);  -- for W2000 250 MHz
    oData   : out aADCout);
end entity;

architecture RTL of ADC is
  constant cSetup        : time    := 3 ns;
  constant cHold         : time    := 2 ns;
  constant cADCAddrWidth : natural := 5;
  signal   ClkADC250     : std_ulogic_vector (0 to cADCsperChannel-1);
  signal   Clk125        : std_ulogic;
  signal   Locked        : std_ulogic_vector(0 to 3);

  type aSyncData is array (0 to cChannels-1) of aLongValues(0 to cADCsperChannel-1);
--  type aSyncResp is array (0 to cADCsperChannel-1) of std_ulogic_vector(0 to 2);
  type aState is (Start, Delay, Sync, Run);
  type aReader is record
                    State   : aState;
                    Counter : unsigned(10 downto 0);
                    Addr    : unsigned(3 downto 0);
                    Data    : aSyncData;
                    SetRun  : std_ulogic_vector(0 to cADCsperChannel-1);
                    SetSync : std_ulogic_vector(0 to cADCsperChannel-1);
                    Rd      : std_ulogic;
                  end record;
  
  type aWriter is record
                    State   : aState;
                    Addr    : unsigned(3 downto 0);
                    Data    : aLongValues(0 to cChannels-1);
                    SetSync : std_ulogic_vector(0 to 2);
                    SetRun  : std_ulogic_vector(0 to 2);
                    Wr      : std_ulogic;
                    Toggle  : std_ulogic;
                  end record;
  
  type aWriters is array (0 to cADCsperChannel-1) of aWriter;

  signal R       : aReader;
  signal W       : aWriters;
  signal ADCData : aADCin;
  
  
begin
  oClk125 <= Clk125;
  oClkADC <= ClkADC250;
  oLocked <= Locked(3);



  pReader : process (Clk125, Locked(3))
  begin
    if Locked(3) = '0' then
      R <= (
        State   => Start,
        Counter => (others => '1'),
        Addr    => (others => '0'),
        Data    => (others => (others => (others => 'Z'))),
        SetSync => (others => '0'),
        SetRun  => (others => '0'),
        Rd      => '0');
      oData <= (others => (others => (others => '0')));
      
    elsif rising_edge(Clk125) then
      
      for i in 0 to cChannels-1 loop
        for j in 0 to cADCsperChannel-1 loop
          oData(i)(j)   <= aByte(R.Data(i)(j)(7 downto 0));
          oData(i)(j+4) <= aByte(R.Data(i)(j)(15 downto 8));
        end loop;
      end loop;
      
--    simple test patterns
--      if to_integer(R.Addr) = 0 then
--            R.Counter <= R.Counter -1;
--      end if; 
--      for i in 0 to cChannels-1 loop
--        for j in 0 to cCoefficients-1 loop
--          oData(i)(j)   <= aByte(R.Counter(7 downto 3) & to_unsigned(j,3));
--        end loop;
--      end loop;

      R.Rd      <= '0';
      R.Addr    <= R.Addr +1;
      R.SetSync <= (others => '0');

      case R.State is
        when Start =>
          if to_integer(R.Addr) = 0 then
            R.Counter <= R.Counter -1;
          end if;

          if R.Counter = 0 then
            R.State      <= Sync;
            R.SetSync(0) <= '1';
            R.SetRun(0)  <= '1';
          end if;
          
        when Delay =>
          null;
          
        when Sync =>
          
          for i in 1 to cADCsperChannel-1 loop
            if R.SetRun(i-1) = '1' and R.SetRun(i) = '0' then
              if R.Data(0)(i-1) /= R.Data(0)(i) then
                R.SetSync(i) <= '1';
              elsif to_integer(R.Data(0)(i)) = -1 then
                R.SetRun(i) <= '1';
              end if;
            end if;
          end loop;

          if R.SetRun(R.SetRun'high) = '1' then
            R.State <= Run;
          end if;
        when Run =>
          R.Rd <= '1';
      end case;
    end if;
  end process;

  pWriter : for i in 0 to cADCsperChannel-1 generate
    ADC : process (ClkADC250(i), Locked(i))
      variable vData : aADCX;
    begin
      if Locked(i) = '0' then
        W(i) <= (
          State   => Delay,
          Addr    => to_unsigned(3*i,W(0).Addr'length),
          Data    => (others => (others => '0')),
          SetSync => (others => '0'),
          SetRun  => (others => '0'),
          Wr      => '0',
          Toggle  => '0');
      elsif rising_edge(ClkADC250(i)) then
        W(i).Toggle <= not W(i).Toggle;

        W(i).SetRun(0)       <= R.SetRun(R.SetRun'high);
        W(i).SetRun(1 to 2)  <= W(i).SetRun(0 to 1);
        W(i).SetSync(0)      <= R.SetSync(i);
        W(i).SetSync(1 to 2) <= W(i).SetSync(0 to 1);

        if W(i).Toggle = '0' then
          W(i).Addr <= W(i).Addr +1;
        end if;
        W(i).Wr <= W(i).Toggle;

        case W(i).State is
          
          when Start =>
            
            if W(i).Toggle = '0' then
              W(i).Data <= (others => (others => '0'));
              if W(i).SetSync(2) = '1' then
                if i = 0 then
                  W(i).Addr <= to_unsigned(6, W(i).Addr'length);
                end if;
                W(i).State <= Delay;
              end if;
            end if;
            
          when Delay =>
            
            if W(i).Toggle = '0' then
              if to_integer(W(i).Addr) = 6 then
                W(i).Data  <= (others => (others => '1'));
                W(i).State <= Sync;
              else
                W(i).Data <= (others => (others => '0'));
              end if;
            end if;

          when Sync =>
            
            if W(i).Toggle = '0' then
              if W(i).SetSync(2) = '1' then
                if i /= 0 then
                  W(i).Addr <= W(i).Addr +0;
                end if;
              end if;
              if to_integer(W(i).Addr) = 0 then
                W(i).Data <= (others => (others => '1'));
              else
                W(i).Data <= (others => (others => '0'));
              end if;

              if W(i).SetRun(2) = '1' then
                W(i).State <= Run;
              end if;
            end if;

          when Run =>

            for j in 0 to cChannels-1 loop
              if W(i).Toggle = '1' then
                vData                                              := ADCData(i)(j);
                W(i).Data(j)(2*cADCBitwidth-1 downto cADCBitWidth) <= signed(std_logic_vector(vData));
              else
                vData                                 := ADCData(i)(j);
                W(i).Data(j)(cADCBitwidth-1 downto 0) <= signed(std_logic_vector(vData));
              end if;
            end loop;
        end case;
      end if;
    end process;

    CH : for j in 0 to cChannels-1 generate
      RAM : entity DSO.SyncRam1Gs
        port map
        (
          wraddress => std_logic_vector(W(i).Addr),
          rdaddress => std_logic_vector(R.Addr),
          wrclock   => ClkADC250(i),
          rdclock   => Clk125,
          data      => std_logic_vector(W(i).Data(j)),
          wren      => W(i).Wr,
          signed(q) => R.Data(j)(i)
          );
    end generate;

    pADCin : process(ClkADC250(i), Locked(i))
    begin
      if Locked(i) = '0' then
        ADCData(i) <= (others => (others => '0'));
      elsif rising_edge(ClkADC250(i)) then
        --       ADCData(i) <= reject cHold inertial (others => (others => 'X')), iADC(i) after cSetup;
        --ADCData(i) <= reject cHold inertial iADC(i) after cSetup;
        ADCData(i) <= iADC(i);
      end if;
    end process;

  end generate;



  PLL0 : entity DSO.PLL0
    port map (
      pllena => '1',
      inclk0 => iClkADC(0),
      c0     => ClkADC250(0),
--      c1     => Clk125(0),
      locked => Locked(0));

  PLL1 : entity DSO.PLL1
    port map (
      inclk0 => iClkADC(1),
      pllena => '1',
      c0     => ClkADC250(1),
--      c1     => Clk125(1),
      locked => Locked(1));

  PLL2 : entity DSO.PLL2
    port map (
      inclk0 => iClkADC(2),
      pllena => '1',
      c0     => ClkADC250(2),
--      c1     => Clk125(2),
      locked => Locked(2));

  -- The pll clk signals are stable for 10000 cycles before Locked(3) is asserted!
  PLL3 : entity DSO.PLL3
    port map (
      inclk0 => iClkADC(3),
      pllena => '1',
      c0     => ClkADC250(3),
      c1     => Clk125,
      c2     => oClk625,
      locked => Locked(3));


end architecture;
