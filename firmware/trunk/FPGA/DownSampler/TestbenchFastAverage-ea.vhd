-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchSingleDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-10
-- Last update: 2008-08-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-10  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pPolyphaseDecimator.all;
use work.pInputValues.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  type   aM is array (natural range<>) of aDecimator;
  signal Clk125                              : std_ulogic := '1';
  signal Clk1000                             : std_ulogic := '1';
  signal ResetAsync                          : std_ulogic := cResetActive;
  signal Input, Output                       : aFastData;
  signal DrawInput, DrawOutput, DrawAliasing : aValue;
  signal Valid                               : std_ulogic;
  signal M                                   : aM(0 to 3) := (0 => M1, 1 => M2, 2 => M4, 3 => M10);
  signal Decimator                           : aDecimator;
  signal i                                   : natural range 0 to cCoefficients-1;
  signal DrawValid                           : std_ulogic;
  
begin
  
  DUT : entity work.FastAverage
    port map (
      iClk        => Clk125,
      iResetAsync => ResetAsync,
      iDecimator  => Decimator,
      iData       => Input,             -- fixpoint 1.x range -0.5 to 0.5
      oData       => Output,            -- fixpoint 1.x range -1 to <1
      oValid      => Valid);

  Clk125  <= not Clk125  after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!
  Clk1000 <= not Clk1000 after 1 us / 2;

  stimuli : process
  begin
    Decimator  <= M1;
    Input      <= (others => (others => '0'));
    wait for 8 us;
    ResetAsync <= not cResetActive;

    for d in M'range loop
      Decimator              <= M(d);
      Input(0)               <= to_signed(-1*2**7, cBitWidth);
      Input(1 to Input'high) <= (others => (others => '0'));
      wait until Clk125 = '1';
      for i in 0 to 20 loop
        Input <= (others => to_signed(0, cBitWidth));
        wait until Clk125 = '1';
      end loop;
    end loop;

    for d in M'range loop
      Decimator <= M(d);
      for i in 0 to 6 loop
        Input <= (others => to_signed(-1*2**7, cBitWidth));
        wait until Clk125 = '1';
      end loop;
      for j in 0 to 20 loop
        Input <= (others => to_signed(0, cBitWidth));
        wait until Clk125 = '1';
      end loop;
    end loop;

    for d in M'range loop
      Decimator <= M(d);
      for i in 0 to cInputValues'length/cCoefficients-1 loop
        for j in 0 to cCoefficients-1 loop
          Input(j) <= to_signed(cInputValues(i*cCoefficients+j), cBitWidth);
        end loop;
        wait until Clk125 = '1';
      end loop;
    end loop;
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  Display : process (Clk1000, ResetAsync)
    variable j : integer range 0 to cCoefficients-1;
  begin
    if ResetAsync = cResetActive then
      i <= 0;
    elsif rising_edge(Clk1000) then
      i         <= (i+1) mod cCoefficients;
      DrawInput <= Input(i);
      DrawValid <= '0';
      case Decimator is
        when M1 =>
          DrawOutput   <= Output(i);
          DrawValid    <= Valid;
          DrawAliasing <= Input(i);
        when M2 =>
          if i mod 2 = 0 then
            DrawOutput   <= Output(i/2);
            DrawValid    <= Valid;
            DrawAliasing <= Input(i);
          end if;
        when M4 =>
          if i mod 4 = 0 then
            DrawOutput   <= Output(i/4);
            DrawValid    <= Valid;
            DrawAliasing <= Input(i);
          end if;
        when M10 =>
          if Valid = '1' and i = 0 then
            DrawOutput   <= Output(0);
            DrawValid    <= Valid;
            DrawAliasing <= Input(i);
          end if;
        when others =>
          DrawOutput <= (others => 'W');
      end case;
    end if;
    
  end process;
  
end architecture;


