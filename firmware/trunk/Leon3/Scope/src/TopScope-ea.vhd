-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopScope-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Out of Date
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


-- where is the asyncronous reset?
-- where is A_FLASH(18)?
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.Global.all;
use DSO.pTrigger.all;
use DSO.pPolyphaseDecimator.all;
--use DSO.pUart.all;
use DSO.pLedsKeys.all;
use DSO.pSpecialFunctionRegister.all;

entity TopScope is
  port (
    --ADC
    oADC1CLK : out std_ulogic;
    oADC2CLK : out std_ulogic;
    oADC3CLK : out std_ulogic;
    oADC4CLK : out std_ulogic;
    iCh1ADC1 : in  std_ulogic_vector (7 downto 0);
    iCh1ADC2 : in  std_ulogic_vector (7 downto 0);
    iCh1ADC3 : in  std_ulogic_vector (7 downto 0);
    iCh1ADC4 : in  std_ulogic_vector (7 downto 0);
    iCh2ADC1 : in  std_ulogic_vector (7 downto 0);
    iCh2ADC2 : in  std_ulogic_vector (7 downto 0);
    iCh2ADC3 : in  std_ulogic_vector (7 downto 0);
    iCh2ADC4 : in  std_ulogic_vector (7 downto 0);

    --CLK
--    iResetAsync : in  std_ulogic;       -- Where is the async reset input pin ?
    iclk25_2  : in  std_ulogic;
    iclk25_7  : in  std_ulogic;
    iclk25_10 : in  std_ulogic;
    iclk25_15 : in  std_ulogic;
    iclk13inp : in  std_ulogic;         --wire W12-U15
    oclk13out : out std_ulogic;         --W12-U15
    iclk12_5  : in  std_ulogic;

    -- pragma translate_off
    ramsn  : out std_logic_vector (4 downto 0);
    ramoen : out std_logic_vector (4 downto 0);
    rben   : out std_logic_vector(3 downto 0);
    rwen   : out std_logic_vector(3 downto 0);

    romsn  : out std_logic_vector (1 downto 0);
    iosn   : out std_ulogic;
    oen    : out std_ulogic;
    read   : out std_ulogic;
    writen : out std_ulogic;
    -- pragma translate_on

    --RS232
    iRXD : in  std_ulogic;              --RS232 
    oTXD : out std_ulogic;

    --USB
    iUSBRX : in  std_ulogic;            -- Receive from USB
    oUSBTX : out std_ulogic;            -- Tratsmit to USB

    --SWITCH on board
    iSW1 : in std_ulogic;               --switch 1
    iSW2 : in std_ulogic;               --switch 2 (reset)

    --FLASH
    oA_FLASH  : out   std_ulogic_vector (cFLASHAddrWidth-1 downto 0);
    bD_FLASH  : inout std_logic_vector (7 downto 0);
    iRB_FLASH : in    std_ulogic;
    oOE_FLASH : out   std_ulogic;
    oCE_FLASH : out   std_ulogic;
    oWE_FLASH : out   std_ulogic;
    --RESET_FLASH :out std_ulogic; connected to SW2
    --ACC_FLASH :out std_ulogic;

    --SRAM
    oA_SRAM   : out   std_ulogic_vector (cSRAMAddrWidth-1 downto 0);
    bD_SRAM   : inout std_logic_vector (31 downto 0);  --inout
    oCE_SRAM  : out   std_ulogic;
    oWE_SRAM  : out   std_ulogic;
    oOE_SRAM  : out   std_ulogic;
    oUB1_SRAM : out   std_ulogic;
    oUB2_SRAM : out   std_ulogic;
    oLB1_SRAM : out   std_ulogic;
    oLB2_SRAM : out   std_ulogic;

    --TFT
    oDCLK  : out std_ulogic;
    oHD    : out std_ulogic;
    oVD    : out std_ulogic;
    oDENA  : out std_ulogic;
    oRed   : out std_ulogic_vector (5 downto 3);
    oGreen : out std_ulogic_vector (5 downto 3);
    oBlue  : out std_ulogic_vector (5 downto 3);

    --FRONT PANEL
    oFPSW_PE   : out std_ulogic;
    iFPSW_DOUT : in  std_ulogic;
    oFPSW_CLK  : out std_ulogic;
    iFPSW_F2   : in  std_ulogic;
    iFPSW_F1   : in  std_ulogic;
    oFPLED_OE  : out std_ulogic;
    oFPLED_WR  : out std_ulogic;
    oFPLED_DIN : out std_ulogic;
    oFPLED_CLK : out std_ulogic;

    --FPGA2
    iFPGA2_C7   : in std_ulogic;
    iFPGA2_H11  : in std_ulogic;
    iFPGA2_AB10 : in std_ulogic;
    iFPGA2_U10  : in std_ulogic;
    iFPGA2_W9   : in std_ulogic;
    iFPGA2_T7   : in std_ulogic;

    --CONTROL of inputs
    iUx6        : in  std_ulogic;  -- not soldering register channels 1,2 è 3,4
    iUx11       : in  std_ulogic;       -- not soldering register channels 1,2
    iAAQpin5    : in  std_ulogic;
    oCalibrator : out std_ulogic;

    -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
    oPWMout  : out std_ulogic;          --Level Of External Syncro
    iSinhcro : in  std_ulogic;          --Comparator external syncro.
    oDesh    : out std_ulogic_vector(2 downto 0);  --demux. write strob for 4094
    oDeshENA : out std_ulogic;
    oRegCLK  : out std_ulogic;
    oRegData : out std_ulogic

    --   iXinp : in std_ulogic_vector (7 downto 0)  --unknown pins
    );
end entity;

architecture RTL of TopScope is

  -- signal iResetAsync : std_ulogic;      -- Where is the async reset input pin ?
  signal ResetAsync : std_ulogic;
  signal ClkDesign  : std_ulogic;
  signal ClkCPU     : std_ulogic;
  signal ClkADC25   : std_ulogic_vector(0 to cADCsperChannel-1);
  signal ClkADC250  : std_ulogic_vector(0 to cADCsperChannel-1);
  signal ClkLocked  : std_ulogic;

  signal ADCIn               : aADCIn;
  signal AnalogAmplification : aAnalogAmplification;

  signal ExtTrigger        : std_ulogic;
  signal TriggerMemtoCPU   : aTriggerMemOut;
  signal CPUtoTriggerMem   : aTriggerMemIn;
  signal SFRControltoCPU   : aSFR_in;
  signal SFRControlfromCPU : aSFR_out;

  --signal LedsfromCPU    : aLeds;
  signal LedstoPanel    : aShiftOut;
  -- signal KeystoCPU      : aKeys;
  signal KeysFromPanel  : aShiftIn;
  signal KeyInterruptLH : std_ulogic;
  signal KeyInterruptHL : std_ulogic;
  
begin

  -- ResetAsync <= not ClkLocked when cResetActive = '1' else
  --               ClkLocked;
--  nResetAsync <= not ResetAsync;
  --ExtTrigger    <= iSinhcro;

  ClkADC25(0) <= iclk25_2;
  ClkADC25(1) <= iclk25_7;
  ClkADC25(2) <= iclk25_10;
  ClkADC25(3) <= iclk25_15;
  oADC1CLK    <= ClkADC250(0);
  oADC2CLK    <= ClkADC250(1);
  oADC3CLK    <= ClkADC250(2);
  oADC4CLK    <= ClkADC250(3);

--  ADCIn <= (
--    0      => (
--      0    => iCh1ADC1,
--      1    => iCh1ADC2,
--      2    => iCh1ADC3,
--      3    => iCh1ADC4),
--    1      => (
--      0    => iCh2ADC1,
--      1    => iCh2ADC2,
--      2    => iCh2ADC3,
--      3    => iCh2ADC4),
--    others => (others => (others => '0')));
  
  ADCIn <= (
    0   => (
      0 => iCh1ADC1,
      1 => iCh2ADC1),
    1   => (
      0 => iCh1ADC2,
      1 => iCh2ADC2),
    2   => (
      0 => iCh1ADC3,
      1 => iCh2ADC3),
    3   => (
      0 => iCh1ADC4,
      1 => iCh2ADC4));

  CaptureSignals : entity DSO.SignalCapture
    port map (
      oClkDesign      => ClkDesign,
      oClkCPU         => ClkCPU,
      --    iResetAsync          => iResetAsync,
      iClkADC         => ClkADC25,
      oClkADC         => ClkADC250,
      oResetAsync     => ResetAsync,
      iADC            => ADCIn,
      iDownSampler    => SFRControlfromCPU.Decimator,
      iSignalSelector => SFRControlfromCPU.SignalSelector,
      iTriggerCPUPort => SFRControlfromCPU.Trigger,
      oTriggerCPUPort => SFRControltoCPU.Trigger,
      iTriggerMem     => CPUtoTriggerMem,
      oTriggerMem     => TriggerMemtoCPU,
      iExtTrigger     => ExtTrigger);

  CPU : entity work.leon3mini
    port map (
      --    iClkDesign  => iClk25_2,
      iClkCPU     => iClk25_2,
      iClkDesign  => ClkDesign,
      --  iClkCPU     => ClkCPU,
      iResetAsync => ResetAsync,

      -- pragma translate_off
      ramsn  => ramsn,
      ramoen => ramoen,
      rben   => rben,
      rwen   => rwen,

      romsn  => romsn,
      iosn   => iosn,
      oen    => oen,
      read   => read,
      writen => writen,
      -- pragma translate_on

      -- external ram
      oExtRam.SRAMAddr => oA_SRAM,
      oExtRam.nSRAM_CE => oCE_SRAM,
      oExtRam.nSRAM_WE => oWE_SRAM,
      oExtRam.nSRAM_OE => oOE_SRAM,
      oExtRam.UB1_SRAM => oUB1_SRAM,
      oExtRam.UB2_SRAM => oUB2_SRAM,
      oExtRam.LB1_SRAM => oLB1_SRAM,
      oExtRam.LB2_SRAM => oLB2_SRAM,
      bSRAMData        => bD_SRAM,
      -- framebuffer VGA
      oDCLK            => oDCLK,
      oHD              => oHD,
      oVD              => oVD,
      oDENA            => oDENA,
      oRed             => oRed,
      oGreen           => oGreen,
      oBlue            => oBlue,
      -- uart
      rxd1             => iRXD,
      txd1             => oTXD,
      dsubre           => '1',
      dsurx            => iUSBRX,
      dsutx            => oUSBTX,
      -- SFR
      iTriggerMem      => TriggerMemtoCPU,
      oTriggerMem      => CPUtoTriggerMem,
      iSFRControl      => SFRControltoCPU,
      oSFRControl      => SFRControlfromCPU
      );

--  CPU : entity DSO.CPUMemoryInterface
--    port map (
--      iClkCPU           => ClkDesign,
--      iClkDesign        => ClkDesign,
--      iResetAsync       => ResetAsync,
--      -- external memory shared with vga framebuffer 
--      oExtMemAddr       => CPUMemAddr,
--      oExtMemDataWr     => CPUMemDataWr,
--      iExtMemDataRd     => CPUMemDataRd,
--      oExtMemReadReq    => CPUMemReadReq,
--      oExtMemWriteReq   => CPUMemWriteReq,
--      oExtMemWriteMask  => CPUMemWriteMask,
--      iMemBusy          => CPUMemBusy,
--      --FLASH
--      oFlashAddr        => oA_FLASH,
--      bFlashData        => bD_FLASH,
--      iFlashBusy        => iRB_FLASH,
--      oFlashOE          => oOE_FLASH,
--      oFlashCE          => oCE_FLASH,
--      oFlashWE          => oWE_FLASH,
--      --SFR
--      oDecimationRange  => DecimationRange,
--      oEnableStage1     => EnableStage1,
--      oEnableStage2     => EnableStage2,
--      oSignalSelector   => SignalSelector,
--      oTriggerCPUPort   => TriggerCPUPortIn,
--      iTriggerCPUPort   => TriggerCPUPortOut,
--      oTriggerReadEn    => TriggerReadEn,
--      oTriggerReadAddr  => TriggerReadAddr,
--      iTriggerData      => TriggerData,
--      iTriggerDataValid => TriggerDataValid,

--      iUart => UartOut,
--      oUart => UartIn,

--      oLeds           => LedsFromCPU,
--      iKeys           => KeystoCPU,
--      iKeyInterruptLH => KeyInterruptLH,
--      iKeyInterruptHL => KeyInterruptHL);

  -- The VGA has always the priority!
--  ExtMemoryAccess : entity DSO.SRamPriorityAccess
--    port map (
--      iClk          => ClkDesign,
--      iResetAsync   => ResetAsync,
--      oSRAMAddr     => oA_SRAM,
--      bSRAMData     => bD_SRAM,
--      onSRAM_CE     => oCE_SRAM,
--      onSRAM_WE     => oWE_SRAM,
--      onSRAM_OE     => oOE_SRAM,
--      oUB2_SRAM     => oUB2_SRAM,
--      oLB2_SRAM     => oLB2_SRAM,
--      oLB1_SRAM     => oLB1_SRAM,
--      oUB1_SRAM     => oUB1_SRAM,
--      iVGAAddr      => VGAMemAddr,
--      oVGAData      => VGAMemData,
--      iVGAReadReq   => VGAMemReadReq,
--      oVGAMemBusy   => VGAMemBusy,
--      iCPUAddr      => CPUMemAddr(cSRAMAddrWidth-1 downto 0),
--      iCPUData      => CPUMemDataWr,
--      oCPUData      => CPUMemDataRd,
--      iCPURd        => CPUMemReadReq,
--      iCPUWr        => CPUMemWriteReq,
--      iCPUWriteMask => CPUMemWriteMask,
--      oCPUMemBusy   => CPUMemBusy);


--  Uart : entity DSO.UartWrapper
--    port map (
--      iClk        => ClkDesign,
--      iResetAsync => ResetAsync,
--      iSRX        => iRXD,
--      oSTX        => oTXD,
--      oRTS        => open,
--      iCTS        => cLowActive,
--      oDTR        => open,
--      iDSR        => cLowActive,
--      iRI         => cLowActive,
--      idcd        => cLowActive,
--      iCPU        => SFRControlfromCPU.Uart,
--      oCPU        => SFRControltoCPU.Uart);

--  VGA : entity DSO.SimpleVGA
--    port map (
--      iClk        => ClkDesign,
--      iResetAsync => ResetAsync,
--      oMemAddr    => VGAMemAddr,
--      iMemData    => VGAMemData,
--      iMemBusy    => VGAMemBusy,
--      oDCLK       => oDCLK,
--      oHD         => oHD,
--      oVD         => oVD,
--      oDENA       => oDENA,
--      oRed        => oRed,
--      oGreen      => oGreen,
--      oBlue       => oBlue);

  FrontPanel : entity DSO.LedsKeys
    port map (
      iClk            => ClkCPU,
      iResetAsync     => ResetAsync,
      iLeds           => SFRControlfromCPU.Leds,
      oLeds           => LedstoPanel,
      iKeysData       => iFPSW_DOUT,
      onFetchKeys     => KeysfromPanel,
      oKeys           => SFRControltoCPU.Keys,
      oKeyInterruptLH => SFRControltoCPU.KeyInterruptLH,
      oKeyInterruptHL => SFRControltoCPU.KeyInterruptHL);

  oFPSW_PE    <= KeysFromPanel.nFetchStrobe;
  oFPSW_CLK   <= LedstoPanel.SerialClk;
  --  iFPSW_F2   : in  std_ulogic;
  --  iFPSW_F1   : in  std_ulogic;
  oFPLED_OE   <= LedstoPanel.nOutputEnable;
  oFPLED_WR   <= LedstoPanel.ValidStrobe;
  oFPLED_DIN  <= LedstoPanel.Data;
  oFPLED_CLK  <= LedstoPanel.SerialClk;
  oCalibrator <= LedstoPanel.SerialClk;  -- 1 KHz Clk
  
end architecture;
