-------------------------------------------------------------------------------
-- Project    : VHDL WAVE files
-------------------------------------------------------------------------------
-- File       : Wavefiles-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-19
-- Last update: 2008-08-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: This package can read or write VHDL signals from or to wave files.
-- There are no restriction for the numbers of channels and the sampling
-- frequences because Octave and Matlab can read them in every configuration.
-- Format used from this link:
-- http://www.lightlink.com/tjweber/StripWav/Canon.html
-------------------------------------------------------------------------------
 --    GNU Lesser General Public License Version 3
 --    =============================================
 --    Copyright 2005 by Sun Microsystems, Inc.
 --    901 San Antonio Road, Palo Alto, CA 94303, USA
 --
 --    This library is free software; you can redistribute it and/or
 --    modify it under the terms of the GNU Lesser General Public
 --    License version 3, as published by the Free Software Foundation.
 --
 --    This library is distributed in the hope that it will be useful,
 --    but WITHOUT ANY WARRANTY; without even the implied warranty of
 --    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 --    Lesser General Public License for more details.
 --
 --    You should have received a copy of the GNU Lesser General Public
 --    License along with this library; if not, write to the Free Software
 --    Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 --    MA  02111-1307  USA
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-19  1.0    
-------------------------------------------------------------------------------

package WaveFiles is
  
  type aFileHandle is file of character;
  type aWaveDataTyp is (PCM8, PCM16LE, PCM32LE);
  type aIntArray is array (natural range<>) of integer;

  type aWaveFileInfo is record
                          -- Handle       : aFileHandle;
                          Channels     : natural;
                          Datatyp      : aWaveDataTyp;
                          DataSize     : integer;
                          SamplingRate : natural;
                        end record;
  
  procedure OpenWaveFileRead(constant FileName   :     string;
                             file WaveFileHandle :     aFileHandle;
                             variable FileInfo   : out aWaveFileInfo);


  procedure ReadSample(file WaveFileHandle    :       aFileHandle;
                       variable Sample        : out   integer;
                       variable RemainingData : inout natural;
                       constant DataTyp       :       aWaveDataTyp);

  procedure ReadSamples(file WaveFileHandle    :       aFileHandle;
                        variable Samples       : out   aIntArray;
                        variable RemainingData : inout natural;
                        constant Channels      :       natural;
                        constant DataTyp       :       aWaveDataTyp);

  procedure OpenWaveFileWrite(constant FileName   :       string;
                              file WaveFileHandle :       aFileHandle;
                              variable WaveFile   : inout aWaveFileInfo);

  procedure WriteSample(file WaveFileHandle    :       aFileHandle;
                        constant Sample        :       integer;
                        variable RemainingData : inout natural;
                        constant DataTyp       :       aWaveDataTyp);

  procedure WriteSamples(file WaveFileHandle    :       aFileHandle;
                         constant Samples       :       aIntArray;
                         variable RemainingData : inout natural;
                         constant Channels      :       natural;
                         constant DataTyp       :       aWaveDataTyp);
end;

package body WaveFiles is
  
  function ReadString(file WaveFileHandle : aFileHandle;
                      constant Name       : string) return boolean is
    variable Ret : boolean := true;
    variable ch  : character;
  begin
    for i in Name'range loop
      read(WaveFileHandle, ch);
      if ch /= Name(i) then
        Ret := false;
      end if;
    end loop;
    return Ret;
  end;

  function ReadDword(file WaveFileHandle : aFileHandle) return integer is
    variable Ret  : integer := 0;
    variable temp : natural := 0;
    variable ch   : character;
  begin
    for i in 0 to 3 loop
      read(WaveFileHandle, ch);
      temp := natural(character'pos(ch));
      Ret  := Ret + temp*2**(8*i);
    end loop;
    return Ret;
  end;

  function ReadWord(file WaveFileHandle : aFileHandle) return integer is
    variable Ret : integer := 0;
    variable ch  : character;
  begin
    for i in 0 to 1 loop
      read(WaveFileHandle, ch);
      Ret := Ret + character'pos(ch)*2**(8*i);
    end loop;
    return Ret;
  end;
  
  procedure OpenWaveFileRead(constant FileName   :     string;
                             file WaveFileHandle :     aFileHandle;
                             variable FileInfo   : out aWaveFileInfo) is
    variable ch         : character;
    variable Dummy      : integer;
    variable FileSize   : natural;
    variable FileStatus : file_open_status;
  begin
    file_open(FileStatus, WaveFileHandle, FileName, read_mode);
    assert(FileStatus = open_ok)
      report "Cannot open file " & FileName & "!" severity failure;
    assert(ReadString(WaveFileHandle, "RIFF"))
      report "The file " & FileName & " is not a wave file!" severity failure;
    FileSize := ReadDWord(WaveFileHandle) +8;            -- wrong dummy access!!!
    assert(ReadString(WaveFileHandle, "WAVE"))
      report "The file " & FileName & " is not a wave file!" severity failure;
    assert(ReadString(WaveFileHandle, "fmt "))
      report "The file " & FileName & " is not a wave file!" severity failure;
    assert(ReadDWord(WaveFileHandle) = 16)
      report "Uncommon header length, data will be corrupted!" severity failure;
    assert(ReadWord(WaveFileHandle) = 1)
      report "Cannot Handle any compressed file format" severity warning;
    FileInfo.Channels     := ReadWord(WaveFileHandle);
    FileInfo.SamplingRate := ReadDword(WaveFileHandle);
    Dummy                 := ReadDword(WaveFileHandle);  -- bytes/second
    Dummy                 := ReadWord(WaveFileHandle);   -- block align
    case ReadWord(WaveFileHandle) is
      when 8      => FileInfo.DataTyp := PCM8;
      when 16     => FileInfo.DataTyp := PCM16LE;
      when 32     => FileInfo.DataTyp := PCM32LE;
      when others =>
        report "Not Implemented!" severity failure;
    end case;
    assert(ReadString(WaveFileHandle, "data"))
      report "The file " & FileName & " is not a wave file!" severity failure;
    FileInfo.DataSize := ReadDword(WaveFileHandle);
  end;

  procedure ReadSample(file WaveFileHandle    :       aFileHandle;
                       variable Sample        : out   integer;
                       variable RemainingData : inout natural;
                       constant DataTyp       :       aWaveDataTyp) is
    variable Ret : integer := 0;
    variable ch  : character;
  begin
    if endfile(WaveFileHandle) = true then
      if RemainingData < 0 then
        report "Unexpected end of file!" severity error;
      else
        report "End of file reached!" severity note;
      end if;
    else
      case DataTyp is
        when PCM8 =>
          read(WaveFileHandle, ch);
          Ret           := character'pos(ch);
          RemainingData := RemainingData-1;
        when PCM16LE =>
          Ret           := ReadWord(WaveFileHandle);
          RemainingData := RemainingData-2;
        when PCM32LE =>
          Ret           := ReadDword(WaveFileHandle);
          RemainingData := RemainingData-4;
      end case;
    end if;
    Sample := Ret;
  end;


  procedure ReadSamples(file WaveFileHandle    :       aFileHandle;
                        variable Samples       : out   aIntArray;
                        variable RemainingData : inout natural;
                        constant Channels      :       natural;
                        constant DataTyp       :       aWaveDataTyp) is
    variable Ret : aIntArray(0 to Channels-1);
  begin
    for i in 0 to Channels-1 loop
      ReadSample(WaveFileHandle, Ret(i), RemainingData, DataTyp);
    end loop;
    Samples := Ret;
  end;
  
  procedure WriteString(file WaveFileHandle : aFileHandle;
                        constant Name       : string) is
  begin
    for i in Name'range loop
      write(WaveFileHandle, Name(i));
    end loop;
  end;
  
  procedure WriteChar(file WaveFileHandle : aFileHandle;
                      constant Value      : integer) is
    variable ch    : character;
    variable to_ch : integer;
  begin
    to_ch := Value;
    if to_ch < 0 then
      to_ch := 2**8 + to_ch;
    end if;
    ch := character'val(to_ch);
    write(WaveFileHandle, ch);
  end;
  
  procedure WriteDword(file WaveFileHandle : aFileHandle;
                       constant Value      : integer) is
    variable temp  : integer := 0;
    variable to_ch : integer := 0;
  begin
    temp := Value;
    for i in 0 to 3 loop
      to_ch := temp mod 2**8;
      WriteChar(WaveFileHandle, to_ch);
      temp  := (temp-to_ch)/2**8;
    end loop;
  end;

  procedure WriteWord(file WaveFileHandle : aFileHandle;
                      constant Value      : integer) is
    variable temp  : integer := 0;
    variable to_ch : integer := 0;
  begin
    temp := Value;
    for i in 0 to 1 loop
      to_ch := temp mod 2**8;
      WriteChar(WaveFileHandle, to_ch);
      temp  := (temp-to_ch)/2**8;
    end loop;
  end;
  
  
  procedure OpenWaveFileWrite(constant FileName   :       string;
                              file WaveFileHandle :       aFileHandle;
                              variable WaveFile   : inout aWaveFileInfo) is
    variable ch         : character;
    variable Size       : integer;
    variable FileStatus : file_open_status;
  begin
    file_open(FileStatus, WaveFileHandle, FileName, write_mode);
    assert(FileStatus = open_ok)
      report "Cannot open file " & FileName & "!" severity failure;
    WriteString(WaveFileHandle, "RIFF");                  -- 4
    Size := WaveFile.DataSize + 44 -8;
    WriteDword(WaveFileHandle, Size);   -- 8
    WriteString(WaveFileHandle, "WAVE");                  -- 12
    WriteString(WaveFileHandle, "fmt ");                  -- 16
    Size := 16;
    WriteDWord(WaveFileHandle, Size);   -- 20 size of format tag
    Size := 1;
    WriteWord(WaveFileHandle, Size);    -- 22 PCM stream
    WriteWord(WaveFileHandle, WaveFile.Channels);         -- 24
    WriteDWord(WaveFileHandle, WaveFile.SamplingRate);    -- 28
    case WaveFile.DataTyp is
      when PCM8    => Size := 8;
      when PCM16LE => Size := 16;
      when PCM32LE => Size := 32;
    end case;
    WriteDWord(WaveFileHandle, WaveFile.SamplingRate*WaveFile.Channels*Size/8);  -- bytes/second
    WriteWord(WaveFileHandle, WaveFile.Channels*Size/8);  -- block align
    WriteWord(WaveFileHandle, Size);
    WriteString(WaveFileHandle, "data");
    WriteDWord(WaveFileHandle, WaveFile.DataSize);
  end;
  
  procedure WriteSample(file WaveFileHandle    :       aFileHandle;
                        constant Sample        :       integer;
                        variable RemainingData : inout natural;
                        constant DataTyp       :       aWaveDataTyp) is
    variable ch : character;
  begin
    if RemainingData > 0 then
      case DataTyp is
        when PCM8 =>
          WriteChar(WaveFileHandle, Sample);
          RemainingData := RemainingData -1;
        when PCM16LE =>
          WriteWord(WaveFileHandle, Sample);
          RemainingData := RemainingData -2;
        when PCM32LE =>
          WriteDword(WaveFileHandle, Sample);
          RemainingData := RemainingData -4;
      end case;
    else
      report "Wave file is full, have you forgotten to set the data size for OpenWaveFileWrite!" severity error;
    end if;
  end;

  procedure WriteSamples(file WaveFileHandle    :       aFileHandle;
                         constant Samples       :       aIntArray;
                         variable RemainingData : inout natural;
                         constant Channels      :       natural;
                         constant DataTyp       :       aWaveDataTyp) is
  begin
    for i in 0 to Channels-1 loop
      WriteSample(WaveFileHandle, Samples(i), RemainingData, DataTyp);
    end loop;
  end;
  
end;

