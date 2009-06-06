-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchTopTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-28
-- Last update: 2009-06-05
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

--library C;
--use C.stdio_h.all;
library modelsim_lib;
use modelsim_lib.util.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pTrigger.all;
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
  signal DataOut      : aBytes(0 to 3);
  signal DataOutValid : std_ulogic;
  signal DataIn       : aTriggerData;
  signal Valid        : std_ulogic;
  signal ExtTrigger   : std_ulogic;
  signal MemIn        : aTriggerMemIn;
  signal Memout       : aTriggerMemOut;
  signal FileInfo     : aWaveFileInfo;
  signal FileName     : string(1 to 20);
  -- signal FrameName    : string(1 to 10);

  signal DrawOutput      : integer;
  signal IntVal          : integer := 0;
  signal LHGlitchCounter : natural := 0;
  signal HLGlitchCounter : natural := 0;

  function StrSize (value : integer) return natural is
    variable v   : integer := value;
    variable ret : natural := 1;
  begin
    if v < 0 then
      v   := -v;
      ret := ret +1;
    end if;
    while v > 9 loop
      v   := v/10;
      ret := ret +1;
    end loop;
    return ret;
  end function;
  
begin
  
  Clk        <= not Clk          after 1 sec / 250E6;
  ResetAsync <= not cResetActive after 10 ns;

  MemIn <= (
    Addr => ReadAddr,
    Rd   => Valid);

  DataOut <= (
    0 => MemOut.Data(31 downto 24),
    1 => MemOut.Data(23 downto 16),
    2 => MemOut.Data(15 downto 8),
    3 => MemOut.Data(7 downto 0));

  DataOutValid <= MemOut.ACK;

  DUT : entity DSO.TopTrigger
    port map (
      iClk        => Clk,
      iClkCPU     => Clk,
      iResetAsync => ResetAsync,
      iData       => DataIn,
      iValid      => Valid,
      iExtTrigger => ExtTrigger,
      iTriggerMem => MemIn,
      oTriggerMem => MemOut,
      iCPUPort    => Tin,
      oCPUPort    => Tout); 

  Stimuli : process
    file Handle        : aFileHandle;
    variable vFileInfo : aWaveFileInfo;
    variable vFileName : string(1 to 20);
    variable vIntVal   : integer;
    variable vValue    : aByte;
  begin

    for iFile in 0 to 6 loop
      
      case iFile is
        when 0 =>
          vFileName           := "../Octave/LowF.wav  ";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 0;
          TIn.StorageMode     <= "00";
          TIn.PreambleCounter <= to_unsigned(8*3, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(50, TIn.HighTime'length));
        when 1 =>
          vFileName           := "../Octave/LowF.wav  ";
          TIn.Trigger         <= 3;     -- rising edge
          TIn.TriggerChannel  <= 3;
          TIn.PreambleCounter <= to_unsigned(8*3, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(30, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(30, TIn.HighTime'length));
        when 2 =>
          vFileName           := "../Octave/HighF.wav ";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 0;
          TIn.PreambleCounter <= to_unsigned(8*20, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-40, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(40, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(0, TIn.HighTime'length));
        when 3 =>
          vFileName           := "../Octave/Wobble.wav";
          TIn.Trigger         <= 2;     -- rising edge
          TIn.TriggerChannel  <= 1;
          TIn.PreambleCounter <= to_unsigned(8*20, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(0, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(0, TIn.HighTime'length));
        when 4 =>
          vFileName           := "../Octave/data.wav  ";
          TIn.Trigger         <= 3;     -- falling egde
          TIn.TriggerChannel  <= 2;
          TIn.PreambleCounter <= to_unsigned(8*20, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(4, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(4, TIn.HighTime'length));
        when 5 =>
          vFileName           := "../Octave/data.wav  ";
          TIn.Trigger         <= 4;     -- rising egde glitch
          TIn.TriggerChannel  <= 3;
          TIn.PreambleCounter <= to_unsigned(8*20, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-16, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(16, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(1, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(1, TIn.HighTime'length));
        when 6 =>
          vFileName           := "../Octave/data.wav  ";
          TIn.Trigger         <= 5;     -- rising egde glitch
          TIn.TriggerChannel  <= 3;
          TIn.PreambleCounter <= to_unsigned(8*20, TIn.PreambleCounter'length);
          TIn.LowValue        <= std_ulogic_vector(to_signed(-50, TIn.LowValue'length));
          TIn.HighValue       <= std_ulogic_vector(to_signed(50, TIn.HighValue'length));
          TIn.LowTime         <= std_ulogic_vector(to_unsigned(1, TIn.LowTime'length));
          TIn.HighTime        <= std_ulogic_vector(to_unsigned(1, TIn.HighTime'length));
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
        if vFileInfo.DataSize mod 1024 = 0 then
          Valid <= '0';
          wait until clk = '1';
        end if;
      end loop;
      file_close(Handle);
    end loop;
    if Tout.Recording = '1' then
      wait until TIn.TriggerOnce = '1';
    end if;
    report "Rising  edge glitches found: " & integer'image(LHGlitchCounter) & LF &
           "Falling edge glitches found: " & integer'image(LHGlitchCounter) severity note;
    report "Simulation finished, no failure!" severity failure;
    
  end process;

  DrawOutput <= to_integer(signed(DataOut(0))) * 2**7;

  Reader : process
    file Handle : aFileHandle;
    variable vFileInfo : aWaveFileInfo := (
      Channels     => 4,
      DataTyp      => PCM16LE,
      DataSize     => 2*4*(2**ReadAddr'length),
      SamplingRate => 100000);
    variable vFileName : string (1 to 13);
    variable vFrame    : natural := 0;
    variable vtemp     : natural;
    variable vIntVal   : integer;
    variable i         : integer;
  begin
    TIn.TriggerOnce <= '0';
    ExtTrigger      <= '0';
    ReadAddr        <= (others => '0');
    wait for 50 ns;
    TIn.TriggerOnce <= '1';
    wait for 50 ns;
    TIn.TriggerOnce <= '0';
    loop
      wait on TOut.Busy;
      if TOut.Busy = '0' then
        --  sprintf(vFileName,"out%n.wav",integer'image(vFrame));
        vFileName                     := "out          ";
        vFrame                        := vFrame +1;
        vtemp                         := StrSize(vFrame)-1;
        vFileName(4 to 4 +vtemp)      := integer'image(vFrame);
        vFileName(5+vtemp to 8+vtemp) := ".wav";
        vFileInfo.DataSize            := 8*(2**ReadAddr'length);

        OpenWaveFileWrite(vFileName, Handle, vFileInfo);
        ReadAddr <= TOut.ReadOffset+1;
        wait for 0 ns;                  -- dirty ReadAddr driver hack
        i        := 0;
        while i < (2**ReadAddr'length) loop
          if Valid = '1' then
            ReadAddr <= ReadAddr +1;
          end if;
          if DataOutValid = '1' then
            i := i +1;
            for j in 0 to 3 loop
              vIntVal := to_integer(signed(DataOut(j))) * 2**8;
              WriteSample(Handle, vIntVal, vFileInfo.DataSize, vFileInfo.DataTyp);
            end loop;
          end if;
          wait until Clk = '1';
        end loop;

        assert(vFileInfo.Datasize = 0)
          report "Remaining Data " & integer'image(vFileInfo.Datasize) & LF & "ReadOffsetdiff " & integer'image(to_integer(Tout.ReadOffset-ReadAddr))
          severity note;
        file_close(Handle);
        TIn.TriggerOnce <= '1';
        wait for 50 ns;
        TIn.TriggerOnce <= '0';
      end if;
    end loop;
  end process;


  Verification : block
    signal Cwr1111, Cwr0101, Cwr0010, Cwr0001 : natural;
    signal MemWr, MemWrPrev                   : std_ulogic_vector(3 downto 0);
    signal LH, HL, GLH, GHL                   : aTrigger1D;
    
  begin
    init_signal_spy("/dut/R.WrEn", "MemWR");
    init_signal_spy("/dut/normal/oLHStrobe", "LH");
    init_signal_spy("/dut/normal/oHLStrobe", "HL");
    init_signal_spy("/dut/normal/oLHGlitch", "GLH");
    init_signal_spy("/dut/normal/oHLGlitch", "GHL");

    process (Clk)
      variable vCLH, vCHL : natural;
    begin
      if ResetAsync = cResetActive then
        Cwr1111   <= 0;
        Cwr0101   <= 0;
        Cwr0010   <= 0;
        Cwr0001   <= 0;
        MemWrPrev <= (others => '0');
      elsif rising_edge(Clk) then
        
        if Valid = '1' then

          -- captured memory 
          MemWrPrev <= MemWr;
          if MemWr = "1111" then
            Cwr1111 <= Cwr1111 +8;
          end if;
          if MemWr = "0101" then
            Cwr0101 <= Cwr0101 +8;
          end if;
          if MemWr = "0010" then
            Cwr0010 <= Cwr0010 +8;
          end if;
          if MemWr = "0001" then
            Cwr0001 <= Cwr0001 +8;
          end if;

          if MemWr = "0000" and MemWrPrev /= "0000" then
            case MemWrPrev is
              when "1111" =>
                assert (Cwr1111 > 1023)
                  report "Trigger captured " & integer'image(Cwr1111) & " Samples!" severity error;
              when "0101" =>
                assert (Cwr1111 > 1023 and Cwr0101 = 1024)
                  report "Trigger captured " & integer'image(Cwr1111 + Cwr0101) & " Samples!" severity error;
              when "0010" =>
                assert (Cwr1111 > 1023 and Cwr0101 = 1024 and Cwr0010 = 1024)
                  report "Trigger captured " & integer'image(Cwr1111 + Cwr0101 + Cwr0010) & " Samples!" severity error;
              when "0001" =>
                assert (Cwr1111 > 1023 and Cwr0101 = 1024 and Cwr0010 = 1024 and Cwr0001 = 1024)
                  report "Trigger captured " & integer'image(Cwr1111 + Cwr0101 + Cwr0010 + Cwr0001) & " Samples!" severity error;
              when "0000" =>
                null;
              when others =>
                report "Trigger memory write signals corrupted!" severity error;
            end case;

            Cwr1111 <= 0;
            Cwr0101 <= 0;
            Cwr0010 <= 0;
            Cwr0001 <= 0;
          end if;

          -- Normal Trigger Strobes
          vCLH := 0;
          vCHL := 0;
          for i in LH'range loop
            if LH(i) = '1' then
              assert(GLH(i) = '0') report "Rising Glitch and Triggerstobe on same edge" severity error;
              vCLH := vCLH +1;
            end if;
            if HL(i) = '1' then
              assert(GHL(i) = '0') report "Falling Glitch and Triggerstrobe on same edge" severity error;
              vCHL := vCHL +1;
            end if;
          end loop;
          assert(vCLH < 2) report "More than one rising Triggerstrobe!" severity error;
          assert(vCHL < 2) report "More than one falling Triggerstrobe!" severity error;

          if Tin.Trigger = 4 and GLH /= X"00" then
            LHGlitchCounter <= LHGlitchCounter +1;
          --  report "LH Glitch found!" severity note;
          end if;

          if Tin.Trigger = 5 and GHL /= X"00" then
            HLGlitchCounter <= HLGlitchCounter +1;
         --   report "HL Glitch found!" severity note;
          end if;
        end if;
      end if;
      
    end process;
  end block;

end architecture;
