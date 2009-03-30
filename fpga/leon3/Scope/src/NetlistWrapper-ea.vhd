-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : NetlistWrapper-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-27
-- Last update: 2009-03-27
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
-- 2009-03-27  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library DSO;
use DSO.pDSOConfig.all;


entity NetlistWrapper is
  generic (
    fabtech : integer := 0;
    memtech : integer := 0;
    padtech : integer := 0;
    clktech : integer := 0;
    disas   : integer := 0;     -- Enable disassembly to console
    dbguart : integer := 0;     -- Print UART on console
    pclow   : integer := 0;
    freq    : integer := 25000          -- frequency of main clock (used for PLLs)
    );
  port (
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

    -- framebuffer VGA
    oDCLK      : out std_ulogic;
    oHD        : out std_ulogic;
    oVD        : out std_ulogic;
    oDENA      : out std_ulogic;
    oRed       : out std_ulogic_vector(5 downto 3);
    oGreen     : out std_ulogic_vector(5 downto 3);
    oBlue      : out std_ulogic_vector(5 downto 3);
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
    iUx6        : in  std_ulogic;       -- not soldering register channels 1,2 è 3,4
    iUx11       : in  std_ulogic;       -- not soldering register channels 1,2
    iAAQpin5    : in  std_ulogic;
    oCalibrator : out std_ulogic;

    -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
    oPWMout  : out std_ulogic;                     --Level Of External Syncro
    iSinhcro : in  std_ulogic;                     --Comparator external syncro.
    oDesh    : out std_ulogic_vector(2 downto 0);  --demux. write strob for 4094
    oDeshENA : out std_ulogic;
    oRegCLK  : out std_ulogic;
    oRegData : out std_ulogic;

    --ADC
    oADC1CLK : out std_ulogic;
    oADC2CLK : out std_ulogic;
    oADC3CLK : out std_ulogic;
    oADC4CLK : out std_ulogic;
    iCh1ADC1 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh1ADC2 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh1ADC3 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh1ADC4 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh2ADC1 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh2ADC2 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh2ADC3 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);
    iCh2ADC4 : in  std_ulogic_vector (cADCBitWidth-1 downto 0);

-- pragma translate_off
    errorn  : out std_ulogic;
    resoutn : out std_ulogic;
-- pragma translate_on

    --CLK
--    iResetAsync : in  std_ulogic;       -- Where is the async reset input pin ?
    iclk25_2  : in  std_ulogic;
    iclk25_7  : in  std_ulogic;
    iclk25_10 : in  std_ulogic;
    iclk25_15 : in  std_ulogic;
    iclk13inp : in  std_ulogic;         --wire W12-U15
    oclk13out : out std_ulogic;         --W12-U15
    iclk12_5  : in  std_ulogic
    );
end;

architecture RTL of NetlistWrapper is
begin
  DUT : entity work.leon3mini
    port map (
      oUSBTX                      => oUSBTX,
      iAAQpin5                    => iAAQpin5,
      iRXD                        => iRXD,
      oTXD                        => oTXD,
      iUSBRX                      => iUSBRX,
      iSW1                        => iSW1,
      iSW2                        => iSW2,
      std_ulogic_vector(oA_FLASH) => oA_FLASH,
      bD_FLASH                    => bD_FLASH,
      iRB_FLASH                   => iRB_FLASH,
      oOE_FLASH                   => oOE_FLASH,
      oCE_FLASH                   => oCE_FLASH,
      oWE_FLASH                   => oWE_FLASH,
      std_ulogic_vector(oA_SRAM)  => oA_SRAM,
      bD_SRAM                     => bD_SRAM,
      oCE_SRAM                    => oCE_SRAM,
      oWE_SRAM                    => oWE_SRAM,
      oOE_SRAM                    => oOE_SRAM,
      oUB1_SRAM                   => oUB1_SRAM,
      oUB2_SRAM                   => oUB2_SRAM,
      oLB1_SRAM                   => oLB1_SRAM,
      oLB2_SRAM                   => oLB2_SRAM,
      oDCLK                       => oDCLK,
      oHD                         => oHD,
      oVD                         => oVD,
      oDENA                       => oDENA,
      std_ulogic_vector(oRed)     => oRed,
      std_ulogic_vector(oGreen)   => oGreen,
      std_ulogic_vector(oBlue)    => oBlue,
      oFPSW_PE                    => oFPSW_PE,
      iFPSW_DOUT                  => iFPSW_DOUT,
      oFPSW_CLK                   => oFPSW_CLK,
      iFPSW_F2                    => iFPSW_F2,
      iFPSW_F1                    => iFPSW_F1,
      oFPLED_OE                   => oFPLED_OE,
      oFPLED_WR                   => oFPLED_WR,
      oFPLED_DIN                  => oFPLED_DIN,
      oFPLED_CLK                  => oFPLED_CLK,
      iFPGA2_C7                   => iFPGA2_C7,
      iFPGA2_H11                  => iFPGA2_H11,
      iFPGA2_AB10                 => iFPGA2_AB10,
      iFPGA2_U10                  => iFPGA2_U10,
      iFPGA2_W9                   => iFPGA2_W9,
      iFPGA2_T7                   => iFPGA2_T7,
      iUx6                        => iUx6,
      iUx11                       => iUx11,
      oCalibrator                 => oCalibrator,
      oPWMout                     => oPWMout,
      iSinhcro                    => iSinhcro,
      std_ulogic_vector(oDesh)    => oDesh,
      oDeshENA                    => oDeshENA,
      oRegCLK                     => oRegCLK,
      oRegData                    => oRegData,
      oADC1CLK                    => oADC1CLK,
      oADC2CLK                    => oADC2CLK,
      oADC3CLK                    => oADC3CLK,
      oADC4CLK                    => oADC4CLK,
      iCh1ADC1                    => std_logic_vector(iCh1ADC1),
      iCh1ADC2                    => std_logic_vector(iCh1ADC2),
      iCh1ADC3                    => std_logic_vector(iCh1ADC3),
      iCh1ADC4                    => std_logic_vector(iCh1ADC4),
      iCh2ADC1                    => std_logic_vector(iCh2ADC1),
      iCh2ADC2                    => std_logic_vector(iCh2ADC2),
      iCh2ADC3                    => std_logic_vector(iCh2ADC3),
      iCh2ADC4                    => std_logic_vector(iCh2ADC4),
      iclk25_2                    => iclk25_2,
      iclk25_7                    => iclk25_7,
      iclk25_10                   => iclk25_10,
      iclk25_15                   => iclk25_15,
      iclk13inp                   => iclk13inp,
      oclk13out                   => oclk13out,
      iclk12_5                    => iclk12_5
      );
end architecture;
