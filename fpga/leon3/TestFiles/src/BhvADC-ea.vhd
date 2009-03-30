library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use work.Wavefiles.all;

entity BhvADC is
  generic (
    gFilename    : string := "";
    gBitWidth    : natural;
    -- This generic is for netlist simulations with timing information! 
    gOutputDelay : time);
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    oData       : out std_ulogic_vector(gBitWidth-1 downto 0));
end entity;

architecture bhv of BhvADC is
begin
  
  Stimuli : process
    file Handle        : aFileHandle;
    variable vFileInfo : aWaveFileInfo;
    variable vIntVal   : integer;
    variable vShift    : integer;
    variable vData  : std_ulogic_vector(gBitWidth-1 downto 0);
  begin
    
    oData <= (others => '0');
    if gFileName = "" then
        vData := (others => '0');
      loop
        wait until iClk = '1';
        wait for gOutputDelay;
        vData := not vData;
        oData <= vData;
      end loop;
    end if;

    loop
      OpenWaveFileRead(gFileName, Handle, vFileInfo);
      case vFileInfo.DataTyp is
        when PCM8 =>
          vShift := 2**(8-gBitWidth);
        when PCM16LE =>
          vShift := 2**(16-gBitWidth);
        when PCM32LE =>
          vShift := 2**(32-gBitWidth);
      end case;
      if vShift < 1 then
        vShift := 1;
      end if;
      while vFileInfo.DataSize > 0 loop
        wait until iClk = '1';
        wait for gOutputDelay;
        if iResetAsync /= cResetActive then
          ReadSample(Handle, vIntVal, vFileInfo.DataSize, vFileInfo.DataTyp);
          vIntVal := vIntVal/vShift;
          oData   <= std_ulogic_vector(to_signed(vIntVal, gBitWidth));
        end if;
      end loop;
      file_close(Handle);
    end loop;
  end process;
  
end architecture;
