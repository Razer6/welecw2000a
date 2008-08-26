-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchFastFirDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-14
-- Last update: 2008-08-18
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-14  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pFastFirCoeff.all;
use work.pInputValues.all;
use work.pPolyphaseDecimator.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  type   aM is array (natural range<>) of aDecimator;
  signal Clk125                  : std_ulogic := '1';
  signal ResetAsync              : std_ulogic := cResetActive;
  signal Input                   : aValues(0 to cChannels-1);
  signal Output                  : aLongValues(0 to cChannels-1);
  signal DrawInput, DrawAliasing : aValue;
  signal DrawOutput              : aLongValue;
  signal Valid                   : std_ulogic;
  signal M                       : aM(0 to 3) := (0 => M1, 1 => M2, 2 => M4, 3 => M10);
  signal Decimator               : aDecimator;
  signal i                       : natural range 0 to cCoefficients-1;
  signal DrawValid, InputValid   : std_ulogic;
  
begin
  
  DUT : entity work.TopFastPolyPhaseDecimator
    port map (
      iClk        => Clk125,
      iResetAsync => ResetAsync,
      iDecimator  => Decimator,
      iData       => Input,
      iValid      => InputValid,
      oData       => Output,
      oValid      => Valid);

  Clk125 <= not Clk125 after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!

  stimuli : process
  begin
    Decimator  <= M1;
    Input      <= (others => (others => '0'));
    wait for 8 us;
    ResetAsync <= not cResetActive;

    for d in M'range loop
      Decimator <= M(d);

      for i in 0 to 10 loop
        for j in 0 to 7 loop
          if j = 0 then
            InputValid <= '1';
          else
            InputValid <= '0';
          end if;
          Input <= (others => (others => '0'));
          wait until Clk125 = '1';
        end loop;
      end loop;
      InputValid <= '1';
      Input(0)               <= to_signed(-1*2**7, cBitWidth);
      Input(1 to Input'high) <= (others => (others => '0'));
      wait until Clk125 = '1';
      for i in 0 to 50 loop
        for j in 0 to 7 loop
          if j = 0 then
            InputValid <= '1';
          else
            InputValid <= '0';
          end if;
          Input <= (others => (others => '0'));
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;

    for d in M'range loop
      Decimator <= M(d);
      for i in 0 to 10 loop
        for j in 0 to 7 loop
          if j = 0 then
            InputValid <= '1';
          else
            InputValid <= '0';
          end if;
          Input <= (others => (others => '0'));
          wait until Clk125 = '1';
        end loop;
      end loop;
      for i in 0 to 6 loop
        for j in 0 to 7 loop
          if j = 0 then
            InputValid <= '1';
          else
            InputValid <= '0';
          end if;
        Input <= (others => to_signed(-1*2**7, cBitWidth));
        wait until Clk125 = '1';
        end loop;
      end loop;
      InputValid <= '1';
      for j in 0 to 50 loop
        Input <= (others => to_signed(0, cBitWidth));
        wait until Clk125 = '1';
      end loop;
    end loop;

    InputValid <= '1';
    for d in M'range loop
      Decimator <= M(d);
      for i in 0 to cInputValues'length-1 loop
        for j in 0 to cChannels-1 loop
          Input(j) <= to_signed(cInputValues(i), cBitWidth);
        end loop;
        wait until Clk125 = '1';
      end loop;
    end loop;
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  Display : process (Clk125)
    variable j : integer range 0 to cCoefficients-1;
  begin
    if ResetAsync = cResetActive then
      i <= 0;
    elsif rising_edge(Clk125) then
      DrawInput <= Input(i);
      DrawValid <= Valid;
      if Valid = '1' then
        DrawOutput   <= Output(0);
        DrawAliasing <= Input(0);
      end if;
    end if;
    
  end process;

end architecture;
