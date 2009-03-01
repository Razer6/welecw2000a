-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchTopTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-28
-- Last update: 2009-02-14
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
-- 2008-08-28  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pTrigger.all;
use work.WaveFiles.all;

entity Testbench is
end entity;

architecture bhv of Testbench is
  signal Clk          : std_ulogic := '0';
  signal ResetAsync   : std_ulogic := cResetActive;
  signal TIn          : aTriggerInput;
  signal TOut         : aTriggerOutput;
  signal ReadEn       : std_ulogic;
  signal ReadAddr     : aTriggerReadAddr;
  signal DataOut      : aBytes(0 to cChannels-1);
  signal DataOutValid : std_ulogic;
  signal DataIn       : aTriggerData;
  signal Valid        : std_ulogic;
  signal ExtTrigger   : std_ulogic;

  signal FileInfo : aWaveFileInfo;
  signal FileName : string(1 to 10);

  signal DrawOutput : integer;
  signal IntVal     : integer := 0;
begin
  
  Clk        <= not Clk          after 1 sec / 250E6;
  ResetAsync <= not cResetActive after 10 ns;

  DUT : entity work.TopTrigger
    port map (
      iClk        => Clk,
      iResetAsync => ResetAsync,
      iCPUPort    => TIn,
      oCPUPort    => TOut,
      iReadEn     => ReadEn,
      iReadAddr   => ReadAddr,
      oData       => DataOut,
      oDataValid  => DataOutValid,
      iData       => DataIn,
      iValid      => Valid,
      iExtTrigger => ExtTrigger);

  Stimuli : process
    file Handle        : aFileHandle;
    variable vFileInfo : aWaveFileInfo;
    variable vFileName : string(1 to 10);
    variable vIntVal   : integer;
    variable vValue    : aByte;
  begin

    for iFile in 0 to 4 loop
      
      case iFile is
        when 0 =>
          vFileName           := "LowF.wav  ";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 0;
          TIn.StorageMode     <= "00";
          TIn.PreambleCounter <= to_unsigned(2, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(50, TIn.HighTime'length));
        when 1 =>
          vFileName           := "LowF.wav  ";
          TIn.Trigger         <= 3;     -- rising edge
          TIn.TriggerChannel  <= 3;
          TIn.PreambleCounter <= to_unsigned(2, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(30, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(30, TIn.HighTime'length));
        when 2 =>
          vFileName           := "HighF.wav ";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 0;
          TIn.PreambleCounter <= to_unsigned(2, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-40, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(40, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(0, TIn.HighTime'length));
        when 3 =>
          vFileName           := "Wobble.wav";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 1;
          TIn.PreambleCounter <= to_unsigned(2, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(0, TIn.HighTime'length));
        when 4 =>
          vFileName           := "data.wav  ";
          TIn.Trigger         <= 3;     -- falling egde
          TIn.TriggerChannel  <= 2;
          TIn.PreambleCounter <= to_unsigned(2, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(4, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(4, TIn.HighTime'length));
      end case;
      OpenWaveFileRead(vFileName, Handle, vFileInfo);
      FileInfo <= vFileInfo;
      FileName <= vFileName;
      -- wait until ResetAsync = not cResetActive;
      -- wait on ResetAsync;
      wait for 10 ns;
      while vFileInfo.DataSize > 0 loop
        --for i in 0 to FileInfo.Channels-1 loop
        for j in 0 to cCoefficients-1 loop
          for i in 0 to FileInfo.Channels-1 loop
            ReadSample(Handle, vIntVal, vFileInfo.DataSize, vFileInfo.DataTyp);
            if i = 0 then
              IntVal <= vIntVal;
            end if;
            vIntVal      := (vIntVal) / (2**8);
            vValue       := aByte(to_signed(vIntVal, vValue'length));  --- to_signed(2**7, vValue'length);
            DataIn(i)(j) <= vValue;
          end loop;
        end loop;
        Valid <= '1';
        wait until clk = '1';
        if vFileInfo.DataSize mod 256 = 0 then
          Valid <= '0';
          wait until clk = '1';
        end if;
      end loop;
      file_close(Handle);
    end loop;
    wait until TIn.TriggerOnce = '1';
    report "Simulation finished, no failure!" severity failure;
    
  end process;

  DrawOutput <= to_integer(signed(DataOut(0))) * 2**7;

  Reader : process
    file Handle : aFileHandle;
    variable vFileInfo : aWaveFileInfo := (
      Channels     => 4,
      DataTyp      => PCM16LE,
      DataSize     => 4*2**ReadAddr'length,
      SamplingRate => 100000);
    variable vFileName : string (1 to 13);
    variable vFrame    : natural := 0;
    variable vtemp     : natural;
    variable vIntVal   : integer;
  begin
    TIn.TriggerOnce <= '0';
    ExtTrigger      <= '0';
    ReadEn          <= '0';
    ReadAddr        <= (others => '0');
    wait for 50 ns;
    TIn.TriggerOnce <= '1';
    wait for 50 ns;
    TIn.TriggerOnce <= '0';
    loop
      wait on TOut.Busy;
      if TOut.Busy = '0' then
        vFileName                     := "out          ";
        vFrame                        := vFrame +1;
        vtemp                         := LogXY(vFrame, 10);
        vFileName(4 to 4 +vtemp)      := integer'image(vFrame);
        vFileName(5+vtemp to 8+vtemp) := ".wav";
        vFileInfo.DataSize            := 2*4*2**ReadAddr'length;
        OpenWaveFileWrite(vFileName, Handle, vFileInfo);
        ReadAddr                      <= std_ulogic_vector(TOut.ReadOffset(ReadAddr'range));
        wait for 0 ns;                  -- dirty ReadAddr driver hack
        ReadEn                        <= '1';
        for i in 1 to 2**ReadAddr'length loop
          ReadAddr <= std_ulogic_vector(unsigned(
            ReadAddr) + to_unsigned(1, ReadAddr'length));
          for j in 0 to cChannels-1 loop
            --     wait until clk = '1';
            if DataOutValid = '1' then
              vIntVal := to_integer(signed(DataOut(j))) * 2**8;
              WriteSample(Handle, vIntVal, vFileInfo.DataSize, vFileInfo.DataTyp);
            end if;
          end loop;
          wait until Clk = '1';
        end loop;
        file_close(Handle);
        ReadEn          <= '0';
        TIn.TriggerOnce <= '1';
        wait for 50 ns;
        TIn.TriggerOnce <= '0';
      end if;
    end loop;
  end process;

end architecture;
