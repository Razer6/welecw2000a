-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchTopDownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-17
-- Last update: 2008-08-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-17  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pPolyphaseDecimator.all;
use work.pInputValues.all;
use work.WaveFiles.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  signal Clk125                              : std_ulogic           := '1';
  signal Clk1000                             : std_ulogic           := '1';
  signal ResetAsync                          : std_ulogic           := cResetActive;
  signal Input, Output                       : aAllData;
  signal DrawInput, DrawOutput, DrawAliasing : aValue;
  signal Valid                               : std_ulogic;
  signal M                                   : aInputValues(0 to 6) :=
    (0 => 1, 1 => 2, 2 => 4, 3 => 10, 4 => 20, 5 => 40, 6 => 100);
  signal EnableStage : unsigned(1 downto 0);
  signal Decimator   : natural;
  signal i           : natural range 0 to cCoefficients-1;
  signal j           : natural range 0 to cCoefficients-1;
  signal DrawCounter : natural;
  signal DrawValid   : std_ulogic;
  signal Drawed : natural := 0;
  
begin

  DUT : entity work.TopDownSampler
    port map (
      iClk             => Clk125,
      iResetAsync      => ResetAsync,
      iADC             => Input,        -- fixpoint 1.x range -0.5 to 0.5
      iDecimationRange => Decimator,
      iEnableStage1    => EnableStage(0),
      iEnableStage2    => EnableStage(1),
      oData            => Output,       -- fixpoint 1.x range -1 to <1
      oWrEn            => Valid);

  Clk125  <= not Clk125  after 1 ms / 250;  -- simulation time 1 ms is in real 1 us!
  Clk1000 <= not Clk1000 after 1 us / 2;

  stimuli : process
  begin
    Decimator   <= 1;
    Input       <= (others => (others => (others => '0')));
    EnableStage <= (others => '0');
    wait for 8 us;
    ResetAsync  <= not cResetActive;

    for e in 0 to 3 loop
      EnableStage <= to_unsigned(e, 2);
      for d in M'range loop
        Decimator <= M(d);
        for i in 0 to Decimator*10+10 loop
          Input(0) <= (others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
        end loop;
        Input(0)(0)               <= to_signed(-1*2**7, cBitWidth);
        Input(0)(1 to Input'high) <= (others => (others => '0'));
        wait until Clk125 = '1';
        for i in 0 to Decimator*10+10 loop
          Input(0) <= (others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;

    for e in 0 to 3 loop
      EnableStage <= to_unsigned(e, 2);
      for d in M'range loop
        Decimator <= M(d);
        for i in 0 to Decimator*10+10 loop
          Input(0) <= (others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
        end loop;
        for i in 0 to Decimator*10+10 loop
          Input(0) <= (others => to_signed(-1*2**7, cBitWidth));
          wait until Clk125 = '1';
        end loop;
        for j in 0 to Decimator*10+10 loop
          Input(0) <= (others => to_signed(0, cBitWidth));
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;
    --   report "Simulation finished, no failiure!" severity failure;

    for e in 0 to 3 loop
      EnableStage <= to_unsigned(e, 2);
      for d in M'range loop
        Decimator <= M(d);
        for i in 0 to cInputValues'length/cCoefficients-1 loop
          for j in 0 to cCoefficients-1 loop
            Input(0)(j) <= to_signed(cInputValues(i*cCoefficients+j), cBitWidth);
          end loop;
          wait until Clk125 = '1';
        end loop;
      end loop;
    end loop;
    report "Simulation finished, no failiure!" severity failure;
    
  end process;


  Display : process (Clk1000, ResetAsync)
    variable vValid : std_ulogic := '0';
  begin
    if ResetAsync = cResetActive then
      i           <= 0;
      j           <= 0;
      DrawCounter <= 0;
    elsif rising_edge(Clk1000) then
      i         <= (i+1) mod cCoefficients;
      DrawInput <= Input(0)(i);
      DrawValid <= Valid or vValid;
      case Decimator is
        when 1 =>
          j            <= 0;
          DrawOutput   <= Output(0)(i);
          DrawAliasing <= Input(0)(i);
        when 2 =>
          j <= 0;
          if i mod 2 = 0 then
            DrawOutput   <= Output(0)(i/2);
            DrawAliasing <= Input(0)(i);
          end if;
        when 4 =>
          j <= 0;
          if i mod 4 = 0 then
            DrawOutput   <= Output(0)(i/4);
            DrawAliasing <= Input(0)(i);
          end if;
        when others =>
          
          if (Valid = '1' and j = 0) or vValid = '1' then
            vValid := '1';
            if j = 7 then
              vValid := '0';
            end if;
            if DrawCounter = 0 then
              DrawOutput   <= Output(0)(0);
              DrawAliasing <= Input(0)(j);
              DrawCounter  <= (Decimator)-1;
              j            <= (j+1) mod cCoefficients;
            else
              DrawCounter <= DrawCounter -1;
            end if;
          else
            DrawCounter <= 0;
            j           <= 0;
          end if;
      end case;
    end if;
    
  end process;
  
  process
  begin
    wait until Clk1000 = '1';
    Drawed <= Drawed+1;
  end process;
  
  WaveFiles : process
    file Handle       : aFileHandle;
    variable FileInfo : aWaveFileInfo :=
      (Channels     => 1,
       DataTyp      => PCM16LE,
       --DataSize     => 7*4*(cInputValues'length + 100),
       DataSize => 455830*2,              --DrawedOutput!!! 
       SamplingRate => 1E9);
    variable Sample : integer := 0;
  begin
    OpenWaveFileWrite("DownSampled.wav", Handle, FileInfo);
    while FileInfo.DataSize > 0 loop
      wait until Clk1000 = '1';
     -- if DrawValid = '1' then
        -- x values are comming out only shortly after other sampling options are set!
        -- These aren't bugs, everey filter needs it's setup time,
        -- but they can make serious troubles for further processing!
        -- Use the is_x function like here, it is always false in synthesis (-; to solve
        -- this problems!
        if is_x(std_ulogic_vector(DrawOutput)) = false then
          Sample := to_integer(DrawOutput);
        end if;
        WriteSample(Handle, Sample, FileInfo.DataSize, FileInfo.DataTyp);
  --    end if;
    end loop;
    file_close(Handle);
    wait;
  end process;



end architecture;
