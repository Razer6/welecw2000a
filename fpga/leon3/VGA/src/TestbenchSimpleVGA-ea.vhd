
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pSRamPriorityAccess.all;
use DSO.pVGA.all;


entity TestbenchSimpleVGA is
end entity;

architecture bhv of TestbenchSimpleVGA is
  signal   iClk        : std_ulogic                    := '1';
  signal   iResetAsync : std_ulogic                    := cResetActive;
  signal   oMem        : aSharedRamAccess;
  signal   CPU         : aSharedRamAccess;
  signal   iMem        : aSharedRamReturn;
  signal   VGASignal   : aVGASignal;
  signal   oDCLK       : std_ulogic;
  signal   oHD         : std_ulogic;
  signal   oVD         : std_ulogic;
  signal   oDENA       : std_ulogic;
  signal   oRed        : std_ulogic_vector(5 downto 3);
  signal   oGreen      : std_ulogic_vector(5 downto 3);
  signal   oBlue       : std_ulogic_vector(5 downto 3);
  signal   oExtRam     : aRamAccess;
  signal   Data        : std_logic_vector(31 downto 0);
  constant Mask        : std_ulogic_vector(3 downto 0) := "1111";
begin
  
  iClk        <= not iClk         after 1 sec / (250E6);
  iResetAsync <= not cResetActive after 4 sec / (250E6);
  CPU <= (
    Addr      => (others => '0'),
    Data      => (others => 'Z'),
    Rd        => '0',
    Wr        => '0',
    WriteMask => "1111");

  DUT : entity DSO.SimpleVGA
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      oMem        => oMem,
      iMem        => iMem,
      oVGASignal  => VGASignal);

  A : entity DSO.SRamPriorityAccess
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      bSRAMData   => Data,
      oExtRam     => oExtRam,
      iVGA        => oMem,
      oVGA        => iMem,
      iCPU        => CPU,
      oCPU        => open);

  RAM : entity work.AsyncSRAM
    --   generic map (
    --     gAddrWidth : natural := 19;
    --    gDataWidth : natural := 32)
    port map (
      iAddr  => oExtRam.SRAMAddr,
      bData  => Data,
      inCE   => oExtRam.nSRAM_CE,
      inWE   => oExtRam.nSRAM_WE,
      inOE   => oExtRam.nSRAM_OE,
      inMask => Mask);

end architecture;
