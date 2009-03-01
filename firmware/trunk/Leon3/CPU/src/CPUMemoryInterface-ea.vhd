-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : CPUMemoryInterface-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-14
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Out of date!
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

use work.Global.all;
use work.pTrigger.all;
use work.pDevices.all;
use work.pUart.all;
use work.pLedsKeys.all;

entity CPUMemoryInterface is
  port (
    iClkCPU           : in    std_ulogic;
    iClkDesign        : in    std_ulogic;
    iResetAsync       : in    std_ulogic;
    -- external memory shared with vga framebuffer 
    oExtMemAddr       : out   aDword;
    oExtMemDataWr     : out   aDword;
    iExtMemDataRd     : in    aDword;
    oExtMemReadReq    : out   std_ulogic;
    oExtMemWriteReq   : out   std_ulogic;
    oExtMemWriteMask  : out   std_ulogic_vector(3 downto 0);
    iMemBusy          : in    std_ulogic;
    -- FLASH
    oFlashAddr        : out   std_ulogic_vector(cFLASHAddrWidth-1 downto 0);
    bFlashData        : inout std_logic_vector(7 downto 0);
    iFlashBusy        : in    std_ulogic;
    oFlashOE          : out   std_ulogic;
    oFlashCE          : out   std_ulogic;
    oFlashWE          : out   std_ulogic;
    -- DownSampler
    oDecimationRange  : out   integer range 0 to cDecimatorMax;
    oEnableStage1     : out   std_ulogic;
    oEnableStage2     : out   std_ulogic;
    -- SignalSelector
    oSignalSelector   : out   aSignalSelector;
    -- Trigger
    oTriggerCPUPort   : out   aTriggerInput;
    iTriggerCPUPort   : in    aTriggerOutput;
    oTriggerReadEn    : out   std_ulogic;
    oTriggerReadAddr  : out   aTriggerReadAddr;
    iTriggerData      : in    aBytes(0 to cChannels-1);
    iTriggerDataValid : in    std_ulogic;
    -- Uart
    iUart             : in    aUarttoCPU;
    oUart             : out   aCPUtoUart;
    -- FrontPanel
    oLeds             : out   aLeds;
    iKeys             : in    aKeys;
    iKeyInterruptLH   : in    std_ulogic;
    iKeyInterruptHL   : in    std_ulogic);
end entity;

architecture RTL of CPUMemoryInterface is

  signal DataRd       : aBus(0 to cSlaves-1);
  signal Wr           : std_ulogic_vector(0 to cSlaves-1);
  signal CPUrd        : std_ulogic;
  signal Rd           : std_ulogic_vector(0 to cSlaves-1);
  signal MemBusy      : std_ulogic_vector(0 to cSlaves-1);
  signal CPUAddr      : aDword;
  signal CPUwr        : std_ulogic;
  signal DatatoCPU    : aDword;
  signal DatafromCPU  : aDword;
  signal CPUwrMask    : std_ulogic_vector(aDword'length/8-1 downto 0);
  signal CPUInterrupt : std_ulogic;
  signal CPUBreak     : std_ulogic;
  signal CPUMemBusy   : std_ulogic;
  signal TriggerData  : aDword;
  
begin
  
  oFlashOE <= cHighInactive;
  oFlashCE <= cHighInactive;
  oFlashWE <= cHighInactive;

  CPU : entity work.zpu_core
    port map (
      clk                              => iClkCPU,
      areset                           => iResetAsync,
      enable                           => '1',
      in_mem_busy                      => CPUMemBusy,
      mem_read                         => std_logic_vector(DatatoCPU),
      std_ulogic_vector(mem_write)     => DatafromCPU,
      std_ulogic_vector(out_mem_addr)  => CPUAddr,
      out_mem_writeEnable              => CPUwr,
      out_mem_readEnable               => CPUrd,
      std_ulogic_vector(mem_writeMask) => CPUwrMask,
      interrupt                        => CPUInterrupt,
      break                            => CPUBreak);

  BusMaster : entity work.Arbiter
    port map (
      --   iClk         => iClkCPU,
      --   inResetAsync => iResetAsync,
      iAddr    => CPUAddr,
      iData    => DataRd,
      oData    => DatatoCPU,
      iWe      => CPUwr,
      oWe      => Wr,
      iRd      => CPURd,
      oRd      => Rd,
      iMemBusy => MemBusy,
      oMemBusy => CPUMemBusy);

  oExtMemAddr           <= CPUAddr;
  oExtMemDataWr         <= DataFromCPU;
  DataRd(cMemAddrRange) <= iExtMemDataRd;

  oExtMemReadReq         <= Rd(cMemAddrRange);
  oExtMemWriteReq        <= Wr(cMemAddrRange);
  oExtMemWriteMask       <= CPUwrMask;
  MemBusy(cMemAddrRange) <= iMemBusy;


  TriggerData(7 downto 0)   <= iTriggerData(0);
  TriggerData(15 downto 8)  <= iTriggerData(1);
  TriggerData(23 downto 16) <= iTriggerData(2);
  TriggerData(31 downto 24) <= iTriggerData(3);

  oTriggerReadEn             <= Rd(cTriggerAddrRange);
  oTriggerReadAddr           <= CPUAddr(oTriggerReadAddr'range);
  DataRd(cTriggerAddrRange)  <= TriggerData;
  MemBusy(cTriggerAddrRange) <= not iTriggerDataValid;

  MemBusy(cSFRAddrRange) <= '0';
  SFR : entity work.SpecialFunctionRegister
    port map (
      iClk             => iClkCPU,
      iResetAsync      => iResetAsync,
      oCPUInterrupt    => CPUInterrupt,
      iAddr            => CPUAddr,
      iWr              => Wr(cSFRAddrRange),
      iWrMask          => CPUwrMask,
      iRd              => Rd(cSFRAddrRange),
      iData            => DataFromCPU,
      oData            => DataRd(cSFRAddrRange),
      oDecimationRange => oDecimationRange,
      oEnableStage1    => oEnableStage1,
      oEnableStage2    => oEnableStage2,
      oSignalSelector  => oSignalSelector,
      oTriggerCPUPort  => oTriggerCPUPort,
      iTriggerCPUPort  => iTriggerCPUPort,
      iUart            => iUart,
      oUart            => oUart,
      oLeds            => oLeds,
      iKeys            => iKeys,
      iKeyInterruptLH  => iKeyInterruptLH,
      iKeyInterruptHL  => iKeyInterruptHL);

  MemBusy(cBootAddrRange) <= '0';
  BootLoader : entity work.ROM
    generic map (
      gAddrWidth => cBootDataSize)
    port map (
      iClk  => iClkCPU,
      --    iResetAsync => iResetAsync,
      iAddr => CPUAddr,
      oData => DataRd(cBootAddrRange));


end architecture;
