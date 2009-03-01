-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TestbenchTopScope-ea.vhd
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.sim.all;
library gaisler;
use gaisler.memctrl.all;
library techmap;
use techmap.gencomp.all;
library micron;
use micron.components.all;
use work.debug.all;
library DSO;
use DSO.config.all;
use DSO.Global.all;
use DSO.pTrigger.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pUart.all;
use DSO.pLedsKeys.all;
use DSO.pVGA.all;

entity TestbenchTopScope is
  generic (
    fabtech   : integer := CFG_FABTECH;
    memtech   : integer := CFG_MEMTECH;
    padtech   : integer := CFG_PADTECH;
    clktech   : integer := CFG_CLKTECH;
    disas     : integer := CFG_DISAS;   -- Enable disassembly to console
    dbguart   : integer := CFG_DUART;   -- Print UART on console
    pclow     : integer := CFG_PCLOW;
    clkperiod : integer := 40;          -- system clock period
    romwidth  : integer := 32;          -- rom data width (8/32)
    romdepth  : integer := 16;          -- rom address depth
    sramwidth : integer := 32;          -- ram data width (8/16/32)
    sramdepth : integer := 18;          -- ram address depth
    srambanks : integer := 2            -- number of ram banks
    );
end entity;

architecture bhv of TestbenchTopScope is
  signal ADC1CLK : std_ulogic;
  signal ADC2CLK : std_ulogic;
  signal ADC3CLK : std_ulogic;
  signal ADC4CLK : std_ulogic;
  signal Ch1ADC1 : std_ulogic_vector (7 downto 0);
  signal Ch1ADC2 : std_ulogic_vector (7 downto 0);
  signal Ch1ADC3 : std_ulogic_vector (7 downto 0);
  signal Ch1ADC4 : std_ulogic_vector (7 downto 0);
  signal Ch2ADC1 : std_ulogic_vector (7 downto 0);
  signal Ch2ADC2 : std_ulogic_vector (7 downto 0);
  signal Ch2ADC3 : std_ulogic_vector (7 downto 0);
  signal Ch2ADC4 : std_ulogic_vector (7 downto 0);

  --CLK
  signal ResetAsync : std_ulogic := cResetActive;  -- Where is the async reset input pin ?
  signal clk25_2    : std_ulogic := '1';
  signal clk25_7    : std_ulogic;
  signal clk25_10   : std_ulogic;
  signal clk25_15   : std_ulogic;
  signal clk13inp   : std_ulogic;       --wire W12-U15
  signal clk13out   : std_ulogic;       --W12-U15
  signal clk12_5    : std_ulogic;

  --RS232
  signal RXD : std_logic;              --RS232 
  signal TXD : std_ulogic;

  --USB
  signal USBRX : std_ulogic;            -- Receive from USB
  signal USBTX : std_ulogic;            -- Tratsmit to USB

  --SWITCH on board
  signal SW1 : std_ulogic;              --switch 1
  signal SW2 : std_ulogic;              --switch 2 (reset)

  --FLASH
  signal A_FLASH  : std_ulogic_vector (cFLASHAddrWidth-1 downto 0);
  signal D_FLASH  : std_logic_vector (7 downto 0);
  signal RB_FLASH : std_ulogic;
  signal OE_FLASH : std_ulogic;
  signal CE_FLASH : std_ulogic;
  signal WE_FLASH : std_ulogic;
  --RESET_FLASH :out std_ulogic; connected to SW2
  --ACC_FLASH :out std_ulogic;

  --SRAM
  signal A_SRAM   : std_ulogic_vector (cSRAMAddrWidth-1 downto 0);
  signal D_SRAM   : std_logic_vector (31 downto 0);  --inout
  signal CE_SRAM  : std_ulogic;
  signal WE_SRAM  : std_ulogic;
  signal OE_SRAM  : std_ulogic;
  signal UB1_SRAM : std_ulogic;
  signal UB2_SRAM : std_ulogic;
  signal LB1_SRAM : std_ulogic;
  signal LB2_SRAM : std_ulogic;

  --TFT
  signal DCLK  : std_ulogic;
  signal HD    : std_ulogic;
  signal VD    : std_ulogic;
  signal DENA  : std_ulogic;
  signal Red   : std_ulogic_vector (5 downto 3);
  signal Green : std_ulogic_vector (5 downto 3);
  signal Blue  : std_ulogic_vector (5 downto 3);

  --FRONT PANEL
  signal FPSW_PE   : std_ulogic;
  signal FPSW_DOUT : std_ulogic;
  signal FPSW_CLK  : std_ulogic;
  signal FPSW_F2   : std_ulogic;
  signal FPSW_F1   : std_ulogic;
  signal FPLED_OE  : std_ulogic;
  signal FPLED_WR  : std_ulogic;
  signal FPLED_DIN : std_ulogic;
  signal FPLED_CLK : std_ulogic;

  --FPGA2
  signal FPGA2_C7   : std_ulogic;
  signal FPGA2_H11  : std_ulogic;
  signal FPGA2_AB10 : std_ulogic;
  signal FPGA2_U10  : std_ulogic;
  signal FPGA2_W9   : std_ulogic;
  signal FPGA2_T7   : std_ulogic;

  --CONTROL of inputs
  signal Ux6        : std_ulogic;       -- not soldering register channels 1,2 è 3,4
  signal Ux11       : std_ulogic;       -- not soldering register channels 1,2
  signal AAQpin5    : std_ulogic;
  signal Calibrator : std_ulogic;

  -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
  signal PWMout  : std_ulogic;                     --Level Of External Syncro
  signal Sinhcro : std_ulogic;                     --Comparator external syncro.
  signal Desh    : std_ulogic_vector(2 downto 0);  --demux. write strob for 4094
  signal DeshENA : std_ulogic;
  signal RegCLK  : std_ulogic;
  signal RegData : std_ulogic;

  -- LEON3 Debug RAM signals
  constant promfile  : string  := "prom.srec";   -- rom contents
  constant sramfile  : string  := "sram.srec";   -- ram contents
  constant sdramfile : string  := "sdram.srec";  -- sdram contents
  constant ct        : integer := clkperiod/2;
  constant lresp : boolean := false;
  signal   address   : std_logic_vector(27 downto 0);
  signal   data      : std_logic_vector(31 downto 0);

  signal ramsn  : std_logic_vector(4 downto 0);
  signal ramoen : std_logic_vector(4 downto 0);
  signal romsn  : std_logic_vector(1 downto 0);
  signal iosn   : std_ulogic;
  signal oen    : std_ulogic;
  signal read   : std_ulogic;
  signal writen : std_ulogic;
  signal rben   : std_logic_vector(3 downto 0);
  signal rwen   : std_logic_vector(3 downto 0);

  signal brdyn                               : std_ulogic;
  signal bexcn                               : std_ulogic;
  signal wdog                                : std_ulogic;
  signal dsuen, dsutx, dsurx, dsubre, dsuact : std_ulogic;
  signal dsurst                              : std_ulogic;
  signal test                                : std_ulogic;
  signal dsubren                             : std_ulogic;
  signal disrams                             :std_logic;
  signal error : std_ulogic;
  signal memi :  memory_in_type;
begin
  
  clk25_2    <= not clk25_2      after (1 sec)/50e6;
  clk25_7    <= clk25_2;
  clk25_10   <= clk25_2;
  clk25_15   <= clk25_2;
 -- ResetAsync <= not cResetActive after (4 sec)/50e6;
ResetAsync <= not cResetActive after 520 ns;
  --LEON 3 debug specific
  dsubren               <= not dsubre;
  disrams               <= '0';
  address(27 downto 16) <= (others => '0');
  address(1 downto 0)   <= (others => '0');
  address(15 downto 14) <= (others => '0');  -- mroland: init unused bits
  dsuen   <= '0';
  dsubre <= '0';
  rxd <= 'H';
  
  TXD   <= '1';
  USBTX <= '1';
  
  D_SRAM <= (others => 'L');
  memi.data <= (others => 'L');
  DUT : entity DSO.TopScope
    port map (
      oADC1CLK    => ADC1CLK,
      oADC2CLK    => ADC2CLK,
      oADC3CLK    => ADC3CLK,
      oADC4CLK    => ADC4CLK,
      iCh1ADC1    => Ch1ADC1,
      iCh1ADC2    => Ch1ADC2,
      iCh1ADC3    => Ch1ADC3,
      iCh1ADC4    => Ch1ADC4,
      iCh2ADC1    => Ch2ADC1,
      iCh2ADC2    => Ch2ADC2,
      iCh2ADC3    => Ch2ADC3,
      iCh2ADC4    => Ch2ADC4,
     -- iResetAsync => ResetAsync,        -- Where is the async reset input pin ?
      iclk25_2    => clk25_2,
      iclk25_7    => clk25_7 ,
      iclk25_10   => clk25_10,
      iclk25_15   => clk25_15,
      iclk13inp   => clk13inp,          --wire W12-U15
      oclk13out   => clk13out,          --W12-U15
      iclk12_5    => clk12_5,

      ramsn  => ramsn,
      ramoen => ramoen,
      oen    => oen,
      rben   => rben,
      rwen   => rwen,
      writen => writen,
      read   => read,
      iosn   => iosn,
      romsn  => romsn,

      iRXD        => TXD,               --RS232 
      oTXD        => RXD,
      iUSBRX      => dsurx,             -- Receive from USB
      oUSBTX      => dsutx,             -- Tratsmit to USB
      iSW1        => SW1,               --switch 1
      iSW2        => SW2,               --switch 2 (reset)
      oA_FLASH    => A_FLASH,
      bD_FLASH    => D_FLASH,
      iRB_FLASH   => RB_FLASH,
      oOE_FLASH   => OE_FLASH,
      oCE_FLASH   => CE_FLASH,
      oWE_FLASH   => WE_FLASH,
      --RESET_FLASH :out std_ulogic; connected to SW2
      --ACC_FLASH :out std_ulogic;
      oA_SRAM     => A_SRAM,
      --bD_SRAM     => D_SRAM,
   --   memi => memi,
      bD_SRAM     => D_SRAM,
      oCE_SRAM    => CE_SRAM,
      oWE_SRAM    => WE_SRAM,
      oOE_SRAM    => OE_SRAM,
      oUB1_SRAM   => UB1_SRAM,
      oUB2_SRAM   => UB2_SRAM,
      oLB1_SRAM   => LB1_SRAM,
      oLB2_SRAM   => LB2_SRAM,
      oDCLK       => DCLK,
      oHD         => HD,
      oVD         => VD,
      oDENA       => DENA,
      oRed        => Red,
      oGreen      => Green,
      oBlue       => Blue,
      oFPSW_PE    => FPSW_PE,
      iFPSW_DOUT  => FPSW_DOUT,
      oFPSW_CLK   => FPSW_CLK,
      iFPSW_F2    => FPSW_F2,
      iFPSW_F1    => FPSW_F1,
      oFPLED_OE   => FPLED_OE,
      oFPLED_WR   => FPLED_WR,
      oFPLED_DIN  => FPLED_DIN,
      oFPLED_CLK  => FPLED_CLK,
      iFPGA2_C7   => FPGA2_C7,
      iFPGA2_H11  => FPGA2_H11,
      iFPGA2_AB10 => FPGA2_AB10,
      iFPGA2_U10  => FPGA2_U10,
      iFPGA2_W9   => FPGA2_W9,
      iFPGA2_T7   => FPGA2_T7,
      iUx6        => Ux6,
      iUx11       => Ux11,
      iAAQpin5    => AAQpin5,
      oCalibrator => Calibrator,
      oPWMout     => PWMout,
      iSinhcro    => Sinhcro,
      oDesh       => Desh,
      oDeshENA    => DeshENA ,
      oRegCLK     => RegCLK,
      oRegData    => RegData
      --   iXinp : std_ulogic_vector (7 downto 0)  --unknown pins
      );

  ADC11 : entity work.BhvADC
    generic map (
      gFileName => "Ch1ADC1.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC1Clk,
      iResetAsync => ResetAsync,
      oData       => Ch1ADC1);

  ADC12 : entity work.BhvADC
    generic map (
      gFileName => "Ch1ADC2.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC2Clk,
      iResetAsync => ResetAsync,
      oData       => Ch1ADC2);

  ADC13 : entity work.BhvADC
    generic map (
      gFileName => "Ch1ADC3.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC3Clk,
      iResetAsync => ResetAsync,
      oData       => Ch1ADC3);

  ADC14 : entity work.BhvADC
    generic map (
      gFileName => "Ch1ADC4.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC4Clk,
      iResetAsync => ResetAsync,
      oData       => Ch1ADC4);

  ADC21 : entity work.BhvADC
    generic map (
      gFileName => "Ch2ADC1.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC1Clk,
      iResetAsync => ResetAsync,
      oData       => Ch2ADC1);

  ADC22 : entity work.BhvADC
    generic map (
      gFileName => "Ch2ADC2.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC2Clk,
      iResetAsync => ResetAsync,
      oData       => Ch2ADC2);

  ADC23 : entity work.BhvADC
    generic map (
      gFileName => "Ch2ADC3.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC3Clk,
      iResetAsync => ResetAsync,
      oData       => Ch2ADC3);

  ADC24 : entity work.BhvADC
    generic map (
      gFileName => "Ch2ADC4.wav",
      gBitWidth => 8)
    port map (
      iClk        => ADC4Clk,
      iResetAsync => ResetAsync,
      oData       => Ch2ADC4);

  ExtSRAM : entity work.AsyncSRAM
    generic map (
      gAddrWidth => 19,
      gDataWidth => 32)
    port map (
      iAddr     => A_SRAM,
      --  bData  => memi.data,
      bData     => D_SRAM,
      inCE      => CE_SRAM,
      inWE      => WE_SRAM,
      inOE      => OE_SRAM,
      inMask(0) => LB1_SRAM,
      inMask(1) => UB1_SRAM,
      inMask(2) => LB2_SRAM,
      inMask(3) => UB2_SRAM);

  Display : entity work.BhvDisplay
    generic map (gGenVGA => cGenVGA)
    port map (
      iDCLK  => DCLK,
      iHD    => HD,
      iVD    => VD,
      iDENVD => DENA,
      iDENHD => DENA,
      iRed   => Red(5 downto 4),
      iGreen => Green(5 downto 4),
      iBlue  => Blue(5 downto 4));


  extbprom : if CFG_BOOTOPT = 0 generate
    prom0 : for i in 0 to (romwidth/8)-1 generate
      sr0 : sram generic map (index => i, abits => romdepth, fname => promfile)
        port map (address(romdepth+1 downto 2), data(31-i*8 downto 24-i*8), romsn(0),
                  rwen(i), oen);   
    end generate;
  end generate extbprom;


  sram0 : for i in 0 to (sramwidth/8)-1 generate
    sr0 : sram generic map (index => i, abits => sramdepth, fname => sramfile)
      port map (address(sramdepth+1 downto 2), data(31-i*8 downto 24-i*8), ramsn(0),
                rben(0), ramoen(0));    -- **** tame: changed rwen to rben
  end generate;
  
  test0 : grtestmod
    port map (ResetAsync, clk25_2, error, address(21 downto 2), data,
              iosn, oen, writen, brdyn);

 -- dcomstart : if CFG_BOOTOPT = 0 generate

    dsucom : process
      procedure dsucfg(signal dsurx : in std_ulogic; signal dsutx : out std_ulogic) is
        variable w32 : std_logic_vector(31 downto 0);
        variable c8  : std_logic_vector(7 downto 0);
        constant txp : time := 160 * 1 ns;
      begin
        dsutx  <= '1';
        dsurst <= '1';
        wait;
        wait for 5000 ns;
        txc(dsutx, 16#55#, txp);        -- sync uart

        txc(dsutx, 16#c0#, txp);
        txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
        txa(dsutx, 16#00#, 16#00#, 16#00#, 16#ef#, txp);

        txc(dsutx, 16#c0#, txp);
        txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
        txa(dsutx, 16#00#, 16#00#, 16#ff#, 16#ff#, txp);

        txc(dsutx, 16#c0#, txp);
        txa(dsutx, 16#90#, 16#40#, 16#00#, 16#48#, txp);
        txa(dsutx, 16#00#, 16#00#, 16#00#, 16#12#, txp);

        txc(dsutx, 16#c0#, txp);
        txa(dsutx, 16#90#, 16#40#, 16#00#, 16#60#, txp);
        txa(dsutx, 16#00#, 16#00#, 16#12#, 16#10#, txp);

        txc(dsutx, 16#80#, txp);
        txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
        rxi(dsurx, w32, txp, lresp);

        txc(dsutx, 16#a0#, txp);
        txa(dsutx, 16#40#, 16#00#, 16#00#, 16#00#, txp);
        rxi(dsurx, w32, txp, lresp);

      end;

    begin

      dsucfg(dsutx, dsurx);

      wait;
    end process;

--  end generate dcomstart;


  altstimuli : if CFG_BOOTOPT = 1 generate
    stimuli : process
    begin
      dsurx <= '1';
      -- rxd1 <= 'H'; --already defined above
  --    txd1  <= 'H';


      wait;
    end process STIMULI;
  end generate altstimuli;

end architecture;
