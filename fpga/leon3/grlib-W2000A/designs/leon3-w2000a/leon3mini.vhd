------------------------------------------------------------------------------
--  LEON3 Demonstration design
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
--  Copyright (C) 2009 Alexander Lindert
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
------------------------------------------------------------------------------
--  modified by Thomas Ameseder, Gleichmann Electronics 2004, 2005 to
--  support the use of an external AHB slave and different HPE board versions
------------------------------------------------------------------------------
--  further adapted from Hpe_compact to Hpe_mini (Feb. 2005)
--  further adapted for the Open Source W2000A Scope (Feb. 2009)
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library techmap;
use techmap.gencomp.all;
library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.net.all;
use gaisler.ata.all;
use gaisler.jtag.all;
library esa;
use esa.memoryctrl.all;
--library gleichmann;
--use gleichmann.hpi.all;
--use gleichmann.dac.all;
library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
--use DSO.pshram.all;
use DSO.pVGA.all;
use DSO.pSFR.all;
use DSO.pSpecialFunctionRegister.all;
use DSO.pTrigger.all;
use DSO.pSignalAccess.all;
use DSO.pSRamPriorityAccess.all;
use DSO.pLedsKeysAnalogSettings.all;
use work.config.all;


entity leon3mini is
  generic (
    fabtech : integer := CFG_FABTECH;
    memtech : integer := CFG_MEMTECH;
    padtech : integer := CFG_PADTECH;
    clktech : integer := CFG_CLKTECH;
    disas   : integer := CFG_DISAS;     -- Enable disassembly to console
    dbguart : integer := CFG_DUART;     -- Print UART on console
    pclow   : integer := CFG_PCLOW;
    freq    : integer := 25000       -- frequency of main clock (used for PLLs)
    );
  port (
    --RS232
    iRXD : in  std_ulogic;              --RS232 
    oTXD : out std_ulogic;

    --USB
    iUSBRX : in  std_ulogic;            -- Receive from USB
    oUSBTX : out std_ulogic;            -- Transmit to USB

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
    iUx6        : in  std_ulogic;  -- not soldering register channels 1,2 è 3,4
    iUx11       : in  std_ulogic;  -- not soldering register channels 1,2
    iAAQpin5    : in  std_ulogic;  -- ? does not fit to analog_inputs.png
    oCalibrator : out std_ulogic;

    -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
    oPWMout  : out std_ulogic;          --Level Of External Syncro
    iSinhcro : in  std_ulogic;          --Comparator external syncro.
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

architecture rtl of leon3mini is
  signal ux_valid   : std_ulogic;
  signal ResetAsync : std_ulogic;
  signal ClkDesign  : std_ulogic;
  signal ClkCPU     : std_ulogic;
  signal ClkADC25   : std_ulogic_vector(0 to cADCsperChannel-1);
  signal ClkADC250  : std_ulogic_vector(0 to cADCsperChannel-1);
  signal ClkLocked  : std_ulogic;

  signal ADCIn             : aADCIn;
  signal TriggerMemtoCPU   : aTriggerMemOut;
  signal CPUtoTriggerMem   : aTriggerMemIn;
  signal SFRControltoCPU   : aSFR_in;
  signal SFRControlfromCPU : aSFR_out;

  --signal LedsfromCPU    : aLeds;
  signal LedstoPanel    : aShiftOut;
  -- signal KeystoCPU      : aKeys;
  signal KeysFromPanel  : aShiftIn;
  signal AnalogSettings : aAnalogSettingsOut;
  signal SerialClk      : std_ulogic;
  -- internal ROM
  signal BootRomRd      : std_ulogic;
  signal BootACK        : std_ulogic;
--  signal RamtoVGA       : aSharedRamReturn;
--  signal VGAtoRam       : aSharedRamAccess;
  -- signal CPUIn          : aSharedRamAccess;
  -- signal CPUOut         : aSharedRamReturn;

  signal memi     : memory_in_type;
  signal memo     : memory_out_type;

  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);

  signal clkm, rstn, sdclkl : std_ulogic;
  signal cgi                : clkgen_in_type;
  signal cgo                : clkgen_out_type;
  signal u1i, dui           : uart_in_type;
  signal u1o, duo           : uart_out_type;

  signal irqi : irq_in_vector(0 to CFG_NCPU-1);
  signal irqo : irq_out_vector(0 to CFG_NCPU-1);

  signal dbgi : l3_debug_in_vector(0 to CFG_NCPU-1);
  signal dbgo : l3_debug_out_vector(0 to CFG_NCPU-1);

  signal dsui : dsu_in_type;
  signal dsuo : dsu_out_type;


  signal gpti : gptimer_in_type;

--  signal errorn         : std_ulogic;
  signal dsuact         : std_logic;
  signal dsuen          : std_ulogic;
--  signal oen_ctrl       : std_logic;
--  signal sdram_selected : std_logic;

--  signal shortcut : std_logic;
  signal rx       : std_logic;
  signal tx       : std_logic;

  signal rxd1   : std_logic;
  signal txd1   : std_logic;
  signal dsutx  : std_ulogic;           -- DSU tx data
  signal dsurx  : std_ulogic;           -- DSU rx data
  signal dsubre : std_ulogic;

  signal vgao      : apbvga_out_type;
  signal video_clk : std_logic;
  signal clk_sel   : std_logic_vector(1 downto 0);

  constant BOARD_FREQ : integer := freq;  -- input frequency in KHz
  constant CPU_FREQ   : integer := BOARD_FREQ * CFG_CLKMUL / CFG_CLKDIV;  -- cpu frequency in KHz
  
begin

---------------------------------------------------------------------------------------
-- DSO: Scope Components without direct AHB or APB access
---------------------------------------------------------------------------------------
  oA_FLASH  <= (others => '1');
  bD_FLASH  <= (others => '1');
  --   iRB_FLASH : in    std_ulogic;
  oOE_FLASH <= '1';
  oCE_FLASH <= '1';
  oWE_FLASH <= '1';

  -- oTXD    <= txd1;
  -- rxd1    <= iRXD;
  -- dsurx   <= iUSBRX;                    -- Receive from USB
  -- oUSBTX  <= dsutx;                     -- Transmit to USB

  oTXD  <= dsutx;
  dsurx <= iRXD;
  rxd1  <= iSinhcro;

  dsubre      <= '0';
  -- dsuactn <= not dsuact;
  dsuen       <= '1';
  -- pragma translate_off
  resoutn     <= rstn;
  -- pragma translate_on
  ClkADC25(0) <= iclk25_2;
  ClkADC25(1) <= iclk25_7;
  ClkADC25(2) <= iclk25_10;
  ClkADC25(3) <= iclk25_15;
  oADC1CLK    <= ClkADC250(0);
  oADC2CLK    <= ClkADC250(1);
  oADC3CLK    <= ClkADC250(2);
  oADC4CLK    <= ClkADC250(3);
  
  ADCIn <= (                            -- only for W2012A and W2022A 
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
      oClkDesign        => ClkDesign,
      oClkCPU           => ClkCPU,
      --    iResetAsync          => iResetAsync,
      iClkADC           => ClkADC25,
      oClkADC           => ClkADC250,
      oResetAsync       => ResetAsync,
      iADC              => ADCIn,
      iDownSampler      => SFRControlfromCPU.Decimator,
      iSignalSelector   => SFRControlfromCPU.SignalSelector,
      iTriggerCPUPort   => SFRControlfromCPU.Trigger,
      oTriggerCPUPort   => SFRControltoCPU.Trigger,
      iTriggerMem       => CPUtoTriggerMem,
      oTriggerMem       => TriggerMemtoCPU,
      iExtTriggerSrc    => SFRControlfromCPU.ExtTriggerSrc,
      iExtTrigger       => iSinhcro,
      oExtTriggerPWM(1) => oPWMout);

  FrontPanel : entity DSO.LedsKeysAnalogSettings
    port map (
      iClk            => ClkCPU,
      iResetAsync     => ResetAsync,
      iLeds           => SFRControlfromCPU.Leds,
      oLeds           => LedstoPanel,
      iKeysData       => iFPSW_DOUT,
      onFetchKeys     => KeysfromPanel,
      oKeys           => SFRControltoCPU.Keys,
      iCPUtoAnalog    => SFRControlfromCPU.AnalogSettings,
      oAnalogBusy     => SFRControltoCPU.AnalogBusy,
      oAnalogSettings => AnalogSettings,
      oSerialClk      => SerialClk);

  oFPSW_PE    <= KeysFromPanel.nFetchStrobe;
  oFPSW_CLK   <= SerialClk;
  --  iFPSW_F2   : in  std_ulogic;
  --  iFPSW_F1   : in  std_ulogic;
  oFPLED_OE   <= LedstoPanel.nOutputEnable;
  oFPLED_WR   <= LedstoPanel.ValidStrobe;
  oFPLED_DIN  <= LedstoPanel.Data;
  oFPLED_CLK  <= SerialClk;
  oCalibrator <= SerialClk;             -- 1 KHz Clk

  oDesh    <= AnalogSettings.Addr;      --demux. write strob for 4094
  oDeshENA <= AnalogSettings.Enable;
  oRegCLK  <= SerialClk;
  oRegData <= AnalogSettings.Data;

  -- pragma translate_off
  BootRomRd <= memo.romsn(0) or memo.oen;
  Bootloader : entity work.BootRom
    generic map (
      pipe => 1)
    port map(
      rstn  => rstn,
      clk   => clkm,
      ren   => BootRomRd,
      iaddr => memo.address(31 downto 2),
      -- odata => bD_SRAM,
      odata => memi.data,
      oACK  => BootACK);
  -- pragma translate_on

  -----------------------------------------------------------------------------
  -- These few lines solve an incompability with the mctrl and the
  -- SRamPriorityAccess which both make a conversation from the bidirectional
  -- data to the unidirectional idata and odata
  -----------------------------------------------------------------------------
--  CPUIn.Addr      <= std_ulogic_vector(memo.address(CPUIn.Addr'high+2 downto 2));
--  CPUIn.Data      <= memi.data;
--  CPUIn.Rd        <= ((not memo.iosn) or (not memo.ramsn(0))) and (not memo.ramoen(0));
--  CPUIn.Wr        <= ((not memo.iosn) or (not memo.ramsn(0))) and (not memo.writen);
--  --              ((not memo.wen(0)) or (not memo.wen(1)) or
--  --               (not memo.wen(2)) or (not memo.wen(3)));
--  CPUIn.WriteMask <= not std_ulogic_vector(memo.wrn);
--  memi.bexcn      <= '1';
--  memi.writen     <= '1';
--  memi.wrn        <= "1111";
--  memi.bwidth     <= "10";
--  memi.data       <= bD_SRAM;

--  process (CPUOut.ACK, BootACK, memo.ramsn(0), memo.romsn)
--  begin
--    memi.brdyn <= '1';
--    if (memo.ramsn(0) = cLowActive and CPUOut.ACK = '0') or
--      (BootACK = '0' and memo.romsn(0) = cLowActive) then
--      memi.brdyn <= '0';
--    end if;
--  end process;

--  ExtRam : entity DSO.SRamPriorityAccess
--    port map (
--      iClk             => ClkDesign,
--      iResetAsync      => ResetAsync,
--      bSRAMData   => memi.data,
--     -- bSRAMData        => bD_SRAM,
--      oExtRam.SRAMAddr => oA_SRAM,
--      oExtRam.nSRAM_CE => oCE_SRAM,
--      oExtRam.nSRAM_WE => oWE_SRAM,
--      oExtRam.nSRAM_OE => oOE_SRAM,
--      oExtRam.UB1_SRAM => oUB1_SRAM,
--      oExtRam.UB2_SRAM => oUB2_SRAM,
--      oExtRam.LB1_SRAM => oLB1_SRAM,
--      oExtRam.LB2_SRAM => oLB2_SRAM,
--      iVGA             => VGAtoRAM,
--      oVGA             => RAMtoVGA,
--      iCPU             => CPUIn,
--      oCPU             => CPUOut);

--  Display : entity DSO.SimpleVGA
--    port map (
--      iClk        => ClkDesign,
--      iResetAsync => ResetAsync,
--      oMem        => VGAtoRam,
--      iMem        => RamtoVGA,
--      oDCLK       => oDCLK,
--      oHD         => oHD,
--      oVD         => oVD,
--      oDENA       => oDENA,
--      oRed        => oRed,
--      oGreen      => oGreen,
--      oBlue       => oBlue);

----------------------------------------------------------------------
---  Reset and Clock generation  -------------------------------------
----------------------------------------------------------------------

--  vcc         <= (others => '1'); gnd <= (others => '0');
--  cgi.pllctrl <= "00"; cgi.pllrst <= not resetn; cgi.pllref <= clk;  --'0'; --pllref;
  cgi.pllctrl <= "00"; cgi.pllrst <= not ResetAsync; cgi.pllref <= ClkCPU;  --'0'; --pllref;
--  clkgen0 : clkgen                      -- clock generator using toplevel generic 'freq'
--    generic map (tech    => CFG_CLKTECH, clk_mul => CFG_CLKMUL,
--                 clk_div => CFG_CLKDIV, sdramen => CFG_MCTRL_SDEN,
--                 noclkfb => CFG_CLK_NOFB, freq => freq)
--    port map (clkin => clk, pciclkin => gnd(0), clk => clkm, clkn => open,
--              clk2x => open, sdclk => sdclkl, pciclk => open,
--              cgi   => cgi, cgo => cgo);

  rst0 : rstgen                         -- reset generator
    --  port map (resetn, clkm, cgo.clklock, rstn);
    port map (ResetAsync, clkm, cgo.clklock, rstn);
  clkm <= ClkCPU;
--  sdclkl <= clk;
  -- rstn   <= resetn;
  cgo  <= (others => '1') after 1 ns,
          (others => '1') after 100 ns;
---------------------------------------------------------------------- 
---  AHB CONTROLLER --------------------------------------------------
----------------------------------------------------------------------

  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    generic map (defmast => CFG_DEFMST, split => CFG_SPLIT,
                 rrobin  => CFG_RROBIN, ioaddr => CFG_AHBIO,
                 nahbm   => 8, nahbs => 8)
    port map (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

----------------------------------------------------------------------
---  LEON3 processor and DSU -----------------------------------------
----------------------------------------------------------------------

  l3 : if CFG_LEON3 = 1 generate
    cpu : for i in 0 to CFG_NCPU-1 generate
      u0 : leon3s                       -- LEON3 processor
        generic map (i, fabtech, memtech, CFG_NWIN, CFG_DSU, CFG_FPU, CFG_V8,
                     0, CFG_MAC, pclow, 0, CFG_NWP, CFG_ICEN, CFG_IREPL, CFG_ISETS, CFG_ILINE,
                     CFG_ISETSZ, CFG_ILOCK, CFG_DCEN, CFG_DREPL, CFG_DSETS, CFG_DLINE, CFG_DSETSZ,
                     CFG_DLOCK, CFG_DSNOOP, CFG_ILRAMEN, CFG_ILRAMSZ, CFG_ILRAMADDR, CFG_DLRAMEN,
                     CFG_DLRAMSZ, CFG_DLRAMADDR, CFG_MMUEN, CFG_ITLBNUM, CFG_DTLBNUM, CFG_TLB_TYPE, CFG_TLB_REP,
                     CFG_LDDEL, disas, CFG_ITBSZ, CFG_PWD, CFG_SVT, CFG_RSTADDR,
                     CFG_NCPU-1)
        port map (clkm, rstn, ahbmi, ahbmo(i), ahbsi, ahbso,
                  irqi(i), irqo(i), dbgi(i), dbgo(i));
    end generate;
    -- pragma translate_off
    errorn_pad : odpad generic map (tech => padtech) port map (errorn, dbgo(0).error);
    -- pragma translate_on

    dsugen : if CFG_DSU = 1 generate
      dsu0 : dsu3                       -- LEON3 Debug Support Unit
        generic map (hindex => 2, haddr => 16#900#, hmask => 16#F00#,
                     ncpu   => CFG_NCPU, tbits => 30, tech => memtech, irq => 0, kbytes => CFG_ATBSZ)
        port map (rstn, clkm, ahbmi, ahbsi, ahbso(2), dbgo, dbgi, dsui, dsuo);
      dsuen_pad  : inpad generic map (tech  => padtech) port map (dsuen, dsui.enable);
      --    **** tame: do not use inversion
      dsubre_pad : inpad generic map (tech  => padtech) port map (dsubre, dsui.break);
      dsuact_pad : outpad generic map (tech => padtech) port map (dsuact, dsuo.active);
    end generate;
  end generate;
  nodcom : if CFG_DSU = 0 generate ahbso(2) <= ahbs_none; end generate;

  dcomgen : if CFG_AHB_UART = 1 generate
    dcom0 : ahbuart                     -- Debug UART
      generic map (hindex => CFG_NCPU, pindex => 4, paddr => 7)
      port map (rstn, clkm, dui, duo, apbi, apbo(4), ahbmi, ahbmo(CFG_NCPU));
    dsurx_pad : inpad generic map (tech  => padtech) port map (dsurx, dui.rxd);
    dsutx_pad : outpad generic map (tech => padtech) port map (dsutx, duo.txd);
  end generate;
  nouah : if CFG_AHB_UART = 0 generate apbo(4) <= apb_none; end generate;

--  ahbjtaggen0 : if CFG_AHB_JTAG = 1 generate
--    ahbjtag0 : ahbjtag generic map(tech => fabtech, hindex => CFG_NCPU+CFG_AHB_UART)
--      port map(rstn, clkm, tck, tms, tdi, tdo, ahbmi, ahbmo(CFG_NCPU+CFG_AHB_UART),
--               open, open, open, open, open, open, open, gnd(0));
--  end generate;

----------------------------------------------------------------------
---  Memory controllers ----------------------------------------------
----------------------------------------------------------------------

  mg2 : if CFG_MCTRL_LEON2 = 1 generate  -- LEON2 memory controller
--    sr1 : mctrl
--      generic map (
--        hindex    => 0,
--        pindex    => 0,
--        romaddr   => 16#000#,
--        -- rommask   => 16#E00#,
--        rommask   => 16#FF7#,
--        ioaddr    => 16#200#,
--        -- iomask    => 16#E00#,
--        iomask    => 16#FFE#,
--        ramaddr   => 16#400#,
--        -- rammask   => 16#C00#,
--        rammask   => 16#FFE#,
--        paddr     => 0,
--        pmask     => 16#fff#,
--        wprot     => 0,
--        invclk    => 0,
--        fast      => 0,
--        romasel   => 28,
--        sdrasel   => 29,
--        -- srbanks   => 4,
--        srbanks   => CFG_SRCTRL_SRBANKS,
--        ram8      => 0,
--        ram16     => 0,
--        sden      => CFG_MCTRL_SDEN,
--        sepbus    => 0,
--        sdbits    => 32,
--        sdlsb     => 2,                  -- set to 12 for the GE-HPE board
--        oepol     => 0,
--        syncrst   => 1,
--        pageburst => 0)
--      port map (rstn, clkm, memi, memo, ahbsi, ahbso(0), apbi, apbo(0), wpo, sdo);
    
    
    srctrl0 : srctrl
      generic map -- (rmw => 1, prom8en => 0, srbanks => 1, banksz => 9)
      (hindex  => 0,
       romaddr => 0,
       rommask => 16#ff8#,
       ramaddr => 16#400#,
       rammask => 16#ffe#,
       ioaddr  => 16#200#,
       iomask  => 16#ffe#,
       ramws   => 0,
       romws   => 2,
       iows    => 2,
       rmw     => 0,                    -- read-modify-write enable
       prom8en => 0,
       oepol   => 0,
       srbanks => 1,
       banksz  => 13,
       romasel => 19)
      port map (rstn, clkm, ahbsi, ahbso(0), memi, memo, open);

--    addr_pad : outpadv generic map (width => 14, tech => padtech)
--      port map (address, memo.address(15 downto 2));
--    bdr : for i in 0 to 3 generate
--      data_pad : iopadv generic map (tech => padtech, width => 8)
--        port map (data(31-i*8 downto 24-i*8), memo.data(31-i*8 downto 24-i*8),
--                  memo.bdrive(i), memi.data(31-i*8 downto 24-i*8));
--    end generate;
    
    bD_SRAM <= memo.data after 1 ns when
               (memo.writen = '0' and memo.ramsn(0) = '0')
               else (others => 'Z');    --  when others;
    memi.data <= bD_SRAM after 1 ns when
                 (memo.writen = '1' and memo.ramsn(0) = '0')
                 else (others => 'Z');  -- when others;
    oA_SRAM   <= std_ulogic_vector(memo.address(oA_SRAM'length+1 downto 2));
    oCE_SRAM  <= memo.ramsn(0) and memo.iosn;
    oOE_SRAM  <= memo.ramoen(0);
    oWE_SRAM  <= memo.writen;
    oLB1_SRAM <= memo.wrn(0);
    oUB1_SRAM <= memo.wrn(1);
    oLB2_SRAM <= memo.wrn(2);
    oUB2_SRAM <= memo.wrn(3);
  end generate;

  memi.brdyn  <= '1'; memi.bexcn <= '1';
  memi.writen <= '1'; memi.wrn <= "1111"; memi.bwidth <= "10";


-- pragma translate_off
--  mgpads : if CFG_MCTRL_LEON2 = 1 generate
--    rams_pad : outpadv generic map (width => 5, tech => padtech)
--      port map (ramsn, memo.ramsn(4 downto 0));
--    roms_pad : outpadv generic map (width => 2, tech => padtech)
--      port map (romsn, memo.romsn(1 downto 0));
--    oen_pad : outpad generic map (tech => padtech)
--      port map (oen, memo.oen);
--    rwen_pad : outpadv generic map (width => 4, tech => padtech)
--      port map (rwen, memo.wrn);
--    roen_pad : outpadv generic map (width => 5, tech => padtech)
--      port map (ramoen, memo.ramoen(4 downto 0));
--    wri_pad : outpad generic map (tech => padtech)
--      port map (writen, memo.writen);
--    read_pad : outpad generic map (tech => padtech)
--      port map (read, memo.read);
--    iosn_pad : outpad generic map (tech => padtech)
--      port map (iosn, memo.iosn);
--  end generate;
-- pragma translate_on

  ---------------------------------------------------------------------------------------
  -- DSO: AHB devices
  ---------------------------------------------------------------------------------------

  genDSO : if CFG_DSO_ENABLE /= 0 generate
    TriggerMem : SignalAccess
      generic map (
        hindex => 3,
        haddr  => 16#A00#,
        hmask  => 16#FFF#,
        kbytes => 16
        )
      port map (
        rst_in      => rstn,
        clk_i       => clkm,
        ahbsi       => ahbsi,
        ahbso       => ahbso(3),
        iClkDesign  => ClkDesign,
        iResetAsync => ResetAsync,
        iTriggerMem => TriggerMemtoCPU,
        oTriggerMem => CPUtoTriggerMem
        );
  end generate;

----------------------------------------------------------------------
---  APB Bridge and various periherals -------------------------------
----------------------------------------------------------------------

  apb0 : apbctrl                        -- AHB/APB bridge
    generic map (hindex => 1, haddr => CFG_APBADDR)
    port map (rstn, clkm, ahbsi, ahbso(1), apbi, apbo);

  ua1 : if CFG_UART1_ENABLE /= 0 generate
    uart1 : apbuart                     -- UART 1
      generic map (pindex   => 1, paddr => 1, pirq => 2, console => dbguart,
                   fifosize => CFG_UART1_FIFO)
      port map (rstn, clkm, apbi, apbo(1), u1i, u1o);
    u1i.rxd <= rxd1; u1i.ctsn <= '0'; u1i.extclk <= '0'; txd1 <= u1o.txd;

    process (apbi)
    begin
      if apbi.psel(1) = '1' and apbi.penable = '1' and apbi.pwrite = '1'
        and apbi.paddr(3 downto 2) = "00" then
        ux_valid <= '1';
      else
        ux_valid <= '0';
      end if;
    end process;

    ux : entity work.jtag_uart_0_log_module
      port map (
        -- inputs:
        clk    => clkm,
        data   => apbi.pwdata(7 downto 0),
        strobe => ux_valid,
        valid  => ux_valid);
  end generate;
  noua0 : if CFG_UART1_ENABLE = 0 generate apbo(1) <= apb_none; end generate;

  irqctrl : if CFG_IRQ3_ENABLE /= 0 generate
    irqctrl0 : irqmp                    -- interrupt controller
      generic map (pindex => 2, paddr => 2, ncpu => CFG_NCPU)
      port map (rstn, clkm, apbi, apbo(2), irqo, irqi);
  end generate;
  irq3 : if CFG_IRQ3_ENABLE = 0 generate
    x : for i in 0 to CFG_NCPU-1 generate
      irqi(i).irl <= "0000";
    end generate;
    apbo(2) <= apb_none;
  end generate;

  gpt : if CFG_GPT_ENABLE /= 0 generate
    timer0 : gptimer                    -- timer unit
      generic map (pindex => 3, paddr => 3, pirq => CFG_GPT_IRQ,
                   sepirq => CFG_GPT_SEPIRQ, sbits => CFG_GPT_SW, ntimers => CFG_GPT_NTIM,
                   nbits  => CFG_GPT_TW)
      port map (rstn, clkm, apbi, apbo(3), gpti, open);
    gpti.dhalt <= dsuo.active; gpti.extclk <= '0';
  end generate;
  notim : if CFG_GPT_ENABLE = 0 generate apbo(3) <= apb_none; end generate;

-----------------------------------------------------------------------
--- DSO: SFR ----------------------------------------------------------
-----------------------------------------------------------------------
  genSFRDSO : if CFG_DSO_ENABLE /= 0 generate
    SFR0 : SFR
      generic map(pindex => 5,
                  paddr  => 5,
                  pmask  => 16#FFF#,
                  pirq   => 5)
      port map(rst_in      => rstn,
               iResetAsync => ResetAsync,
               clk_i       => clkm,
               apb_i       => apbi,
               apb_o       => apbo(5),
               iSFRControl => SFRControltoCPU,
               oSFRControl => SFRControlfromCPU);
  end generate;

  vga : if CFG_VGA_ENABLE /= 0 generate
    vga0 : apbvga generic map(memtech => memtech, pindex => 5, paddr => 6)
      --    port map(rstn, clkm, clk, apbi, apbo(5), vgao);
      port map(rstn, clkm, ClkDesign, apbi, apbo(5), vgao);
  end generate;
--  vert_sync_pad : outpad generic map (tech => padtech)
--    port map (vga_vsync, vgao.vsync);
--  horiz_sync_pad : outpad generic map (tech => padtech)
--    port map (vga_hsync, vgao.hsync);
--  video_out_r_pad : outpadv generic map (width => 2, tech => padtech)
--    port map (vga_rd, vgao.video_out_r(7 downto 6));
--  video_out_g_pad : outpadv generic map (width => 2, tech => padtech)
--    port map (vga_gr, vgao.video_out_g(7 downto 6));
--  video_out_b_pad : outpadv generic map (width => 2, tech => padtech)
--    port map (vga_bl, vgao.video_out_b(7 downto 6));


--  oVD    <= vgao.vsync;
--  oHD    <= vgao.hsync;
--  oRed   <= std_ulogic_vector(vgao.video_out_r(7 downto 5));
--  oGreen <= std_ulogic_vector(vgao.video_out_g(7 downto 5));
--  oBlue  <= std_ulogic_vector(vgao.video_out_b(7 downto 5));
--  oDCLK  <= iclk25_2;
  oDENA  <= '0';

  svga : if CFG_SVGA_ENABLE /= 0 generate
    svga0 : svgactrl generic map(memtech => memtech, pindex => 6, paddr => 6,
                                 hindex  => CFG_NCPU+CFG_AHB_UART+CFG_AHB_JTAG,
                                 clk0    => 40000, clk1 => 1000000000/((BOARD_FREQ * CFG_CLKMUL)/CFG_CLKDIV),
                                 clk2    => 20000, clk3 => 15385, burstlen => 6)
      port map(rstn, clkm, video_clk, apbi, apbo(6), vgao, ahbmi,
               ahbmo(CFG_NCPU+CFG_AHB_UART+CFG_AHB_JTAG), clk_sel);
    --   video_clk <= clk when clk_sel = "00"      else clkm;
    video_clk <= iclk25_2;              -- when clk_sel = "00" else ClkCPU;
  end generate;

  novga : if CFG_VGA_ENABLE+CFG_SVGA_ENABLE = 0 generate
    apbo(6) <= apb_none; vgao <= vgao_none;
  end generate;

-----------------------------------------------------------------------
---  Drive unused bus elements  ---------------------------------------
-----------------------------------------------------------------------

  nam1 : for i in (CFG_NCPU+CFG_AHB_UART+CFG_AHB_JTAG+CFG_SVGA_ENABLE+CFG_GRETH) to NAHBMST-1 generate
    ahbmo(i) <= ahbm_none;
  end generate;
  nap0 : for i in 7 to NAPBSLV-1-CFG_GRETH generate apbo(i) <= apb_none; end generate;
  nah0 : for i in 8 to NAHBSLV-1 generate ahbso(i)          <= ahbs_none; end generate;

-----------------------------------------------------------------------
---  Boot message  ----------------------------------------------------
-----------------------------------------------------------------------

-- pragma translate_off
  x : report_version
    generic map (
      msg1 => "LEON3 Demonstration design for HPE_mini board",
      msg2 => "GRLIB Version " & tost(LIBVHDL_VERSION/1000) & "." & tost((LIBVHDL_VERSION mod 1000)/100)
      & "." & tost(LIBVHDL_VERSION mod 100) & ", build " & tost(LIBVHDL_BUILD),
      msg3 => "Target technology: " & tech_table(fabtech) & ",  memory library: " & tech_table(memtech),
      mdel => 1
      );
-- pragma translate_on

end rtl;
