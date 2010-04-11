-----------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
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
------------------------------------------------------------------------------
--  modified by Thomas Ameseder, Gleichmann Electronics 2004, 2005 to
--  support the use of an external AHB slave and different HPE board versions
------------------------------------------------------------------------------
--  further adapted from Hpe_compact to Hpe_mini (Feb. 2005)
------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.sim.all;
library techmap;
use techmap.gencomp.all;
library micron;
use micron.components.all;
library gleichmann;
use gleichmann.hpi.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pLedsKeysAnalogSettings.all;

use work.config.all;			-- configuration
use work.debug.all;

entity testbench is
  generic (
    fabtech : integer := CFG_FABTECH;
    memtech : integer := CFG_MEMTECH;
    padtech : integer := CFG_PADTECH;
    clktech : integer := CFG_CLKTECH;
    disas   : integer := CFG_DISAS;	-- Enable disassembly to console
    dbguart : integer := CFG_DUART;	-- Print UART on console
    pclow   : integer := CFG_PCLOW;

    clkperiod : integer := 40;		-- system clock period
    romwidth  : integer := 32;		-- rom data width (8/32)
    romdepth  : integer := 16;		-- rom address depth
    sramwidth : integer := 32;		-- ram data width (8/16/32)
    sramdepth : integer := 18;		-- ram address depth
    srambanks : integer := 2		-- number of ram banks
    );
  port (
    pci_rst    : in    std_ulogic;	-- PCI bus
    pci_clk    : in    std_ulogic;
    pci_gnt    : in    std_ulogic;
    pci_idsel  : in    std_ulogic;
    pci_lock   : inout std_ulogic;
    pci_ad     : inout std_logic_vector(31 downto 0);
    pci_cbe    : inout std_logic_vector(3 downto 0);
    pci_frame  : inout std_ulogic;
    pci_irdy   : inout std_ulogic;
    pci_trdy   : inout std_ulogic;
    pci_devsel : inout std_ulogic;
    pci_stop   : inout std_ulogic;
    pci_perr   : inout std_ulogic;
    pci_par    : inout std_ulogic;
    pci_req    : inout std_ulogic;
    pci_serr   : inout std_ulogic;
    pci_host   : in    std_ulogic;
    pci_66     : in    std_ulogic
    );
end;

architecture behav of testbench is

  signal iRXD : std_ulogic;		--RS232 
  signal oTXD : std_ulogic;

  --USB
  signal iUSBRX : std_ulogic;		-- Receive from USB
  signal oUSBTX : std_ulogic;		-- Tratsmit to USB

  --SWITCH on board
  signal iSW1 : std_ulogic;		--switch 1
  signal iSW2 : std_ulogic;		--switch 2 (reset)

  --FLASH
  signal oA_FLASH  : std_ulogic_vector (cFLASHAddrWidth-1 downto 0);
  signal bD_FLASH  : std_logic_vector (7 downto 0);
  signal iRB_FLASH : std_ulogic;
  signal oOE_FLASH : std_ulogic;
  signal oCE_FLASH : std_ulogic;
  signal oWE_FLASH : std_ulogic;

  --SRAM
  signal A_SRAM	   : std_ulogic_vector (cSRAMAddrWidth+1 downto 0);
  signal bD_SRAM   : std_logic_vector (31 downto 0);  --inout
  signal oCE_SRAM  : std_ulogic;
  signal oWE_SRAM  : std_ulogic;
  signal oOE_SRAM  : std_ulogic;
  signal oUB1_SRAM : std_ulogic;
  signal oUB2_SRAM : std_ulogic;
  signal oLB1_SRAM : std_ulogic;
  signal oLB2_SRAM : std_ulogic;

  -- framebuffer VGA
  signal DCLK  : std_ulogic;
  signal HD    : std_ulogic;
  signal VD    : std_ulogic;
  signal DENA  : std_ulogic;
  signal Red   : std_ulogic_vector(5 downto 3);
  signal Green : std_ulogic_vector(5 downto 3);
  signal Blue  : std_ulogic_vector(5 downto 3);

  --FRONT PANEL
  signal oFPSW_PE   : std_ulogic;
  signal iFPSW_DOUT : std_ulogic;
  signal oFPSW_CLK  : std_ulogic;
  signal iFPSW_F2   : std_ulogic;
  signal iFPSW_F1   : std_ulogic;
  signal oFPLED_OE  : std_ulogic;
  signal oFPLED_WR  : std_ulogic;
  signal oFPLED_DIN : std_ulogic;
  signal oFPLED_CLK : std_ulogic;

  --FPGA2
  signal iFPGA2_C7   : std_ulogic;
  signal iFPGA2_H11  : std_ulogic;
  signal iFPGA2_AB10 : std_ulogic;
  signal iFPGA2_U10  : std_ulogic;
  signal iFPGA2_W9   : std_ulogic;
  signal iFPGA2_T7   : std_ulogic;

  --CONTROL of inputs
  signal iUx6	     : std_ulogic;  -- not soldering register channels 1,2 è 3,4
  signal iUx11	     : std_ulogic;	-- not soldering register channels 1,2
  signal AAQpin5     : std_ulogic;
  signal oCalibrator : std_ulogic;

-- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
  signal oPWMout  : std_ulogic;		--Level Of External Syncro
  signal iSinhcro : std_ulogic;		--Comparator external syncro.
  signal oDesh	  : std_ulogic_vector(2 downto 0);  --demux. write strob for 4094
  signal oDeshENA : std_ulogic;
  signal oRegCLK  : std_ulogic;
  signal oRegData : std_ulogic;

  --CLK
--    iResetAsync :   std_ulogic;	-- Where is the async reset input pin ?
  signal iclk25_2  : std_ulogic;
  signal iclk25_7  : std_ulogic;
  signal iclk25_10 : std_ulogic;
  signal iclk25_15 : std_ulogic;
  signal iclk13inp : std_ulogic;	--wire W12-U15
  signal oclk13out : std_ulogic;	--W12-U15
  signal iclk12_5  : std_ulogic := '0';

  constant promfile : string := "prom.srec";  -- rom contents
  constant sramfile : string := "sram.srec";  -- ram contents

  signal   clk	      : std_logic := '0';
  signal   Rst	      : std_logic := '0';  -- Reset
  signal   ResetAsync : std_ulogic;
  constant ct	      : integer	  := clkperiod/2;

  signal romsn	: std_logic_vector(1 downto 0);
  signal oen	: std_ulogic;
  signal read	: std_ulogic;
  signal writen : std_ulogic;
  signal rben	: std_logic_vector(3 downto 0);
  signal rwen	: std_logic_vector(3 downto 0);

  signal test : std_ulogic;

  signal error : std_logic;

  signal GND  : std_ulogic := '0';
  signal VCC  : std_ulogic := '1';
  signal NC   : std_ulogic := 'Z';
  signal clk2 : std_ulogic := '1';


-- pulled up high, therefore std_logic
  signal txd1, rxd1 : std_logic;

  signal   dstrst, dsutx, dsurx, dsurst : std_ulogic;
  constant lresp			: boolean := false;


  signal resoutn : std_logic;

-----------------------------------------------------------------------------------------
-- Scope input data generation
-----------------------------------------------------------------------------------------  
  type aWaveFileX is array (0 to cADCsperChannel-1) of string(1 to 11);
  type aWaveFileNames is array (0 to cChannels-1) of aWaveFileX;
  function WaveFileNames (constant cChannels, cADCsperChannel : natural)
    return aWaveFileNames is
    variable vRet : aWaveFileNames;
  begin
    for i in 0 to cChannels-1 loop
      for j in 0 to cADCsperChannel-1 loop
	vRet(i)(j) := "Ch" & integer'image(i+1) & "ADC" & integer'image(j+1) & ".wav";
      end loop;
    end loop;
    return vRet;
  end function;

  constant cWaveFileNames : aWaveFileNames := WaveFileNames(cChannels, cADCsperChannel);
  signal   ADCData	  : aADCIn;
  signal   ADCClk	  : std_ulogic_vector(0 to 3);

  component BhvADC is
    generic (
      gFilename	   : string  := "";
      gStartValue  : integer := 0;
      gCountValue  : integer := 1;
      gBitWidth	   : natural;
      -- This generic is for netlist simulations with timing information! 
      gOutputDelay : time);
    port (
      iClk	  : in	std_ulogic;
      iResetAsync : in	std_ulogic;
      oData	  : out std_ulogic_vector(gBitWidth-1 downto 0));
  end component;

  component StoP_hc595 is
    port (
      iSD    : in  std_ulogic;
      iSCK   : in  std_ulogic;
      inSCLR : in  std_ulogic;
      iRCK   : in  std_ulogic;
      iG     : in  std_ulogic;
      oSD    : out std_ulogic;
      oQ     : out std_ulogic_vector (0 to 7));
  end component;

  component PtoS_hct165 is
    port (
      iSD  : in	 std_ulogic;
      iCK  : in	 std_ulogic;
      inCE : in	 std_ulogic;
      inMR : in	 std_ulogic;
      inPE : in	 std_ulogic;
      iPD  : in	 std_ulogic_vector(0 to 7);
      oQ   : out std_ulogic;
      onQ  : out std_ulogic);
  end component;


  -- signal Keys : aKeys;
  -- signal Leds : aLeds;

  type aAnalogSettingsBank5 is record
    CH1_K1_ON	  : std_ulogic;
    CH1_K1_OFF	  : std_ulogic;
    CH1_K2_ON	  : std_ulogic;
    CH1_K2_OFF	  : std_ulogic;
    CH1_OPA656	  : std_ulogic;
    CH1_BW_Limit  : std_ulogic;
    CH1_U14	  : std_ulogic;
    CH1_U13	  : std_ulogic;
    CH0_src2_addr : std_ulogic_vector(1 downto 0);
    CH1_src2_addr : std_ulogic_vector(1 downto 0);
    CH2_src2_addr : std_ulogic_vector(1 downto 0);
    CH3_src2_addr : std_ulogic_vector(1 downto 0);
  end record;

  type aAnalogSettingsBank7 is record
    CH0_K1_ON	 : std_ulogic;
    CH0_K1_OFF	 : std_ulogic;
    CH0_K2_ON	 : std_ulogic;
    CH0_K2_OFF	 : std_ulogic;
    CH0_OPA656	 : std_ulogic;
    CH0_BW_Limit : std_ulogic;
    CH0_U14	 : std_ulogic;
    CH0_U13	 : std_ulogic;
    CH0_DC	 : std_ulogic;
    CH1_DC	 : std_ulogic;
    CH2_DC	 : std_ulogic;
    CH3_DC	 : std_ulogic;
  end record;

  -- leds, leys, analog settings
  signal DAC_A, DAC_B	: real;
  signal ASEnable	: std_ulogic_vector(0 to 7);
  signal DACEn		: std_ulogic;
  signal ASDCh0, ASDCh1 : std_ulogic;

  constant cLedBanks : natural := 2;
  constant cKeyBanks : natural := 7;
  signal   LedSD     : std_ulogic_vector(0 to cLedBanks);
  signal   KeySD     : std_ulogic_vector(0 to cKeyBanks);
  type	   aKeyData is array (0 to cKeyBanks-1) of std_ulogic_vector(0 to 7);
  signal KeyData : aKeyData := (
    0		     => X"F0",
    1		     => X"FF",
    2 to cKeyBanks-2 => X"A5",
    cKeyBanks-1	     => X"0F");

  component leon3mini is
    generic (
      fabtech : integer := CFG_FABTECH;
      memtech : integer := CFG_MEMTECH;
      padtech : integer := CFG_PADTECH;
      clktech : integer := CFG_CLKTECH;
      disas   : integer := CFG_DISAS;	-- Enable disassembly to console
      dbguart : integer := CFG_DUART;	-- Print UART on console
      pclow   : integer := CFG_PCLOW;
      freq    : integer := 25000  -- frequency of main clock (used for PLLs)
      );
    port (
      --RS232
      iRXD : in	 std_ulogic;		--RS232 
      oTXD : out std_ulogic;

      --USB
      iUSBRX : in  std_ulogic;		-- Receive from USB
      oUSBTX : out std_ulogic;		-- Transmit to USB

      --SWITCH on board
      iSW1 : in std_ulogic;		--switch 1
      iSW2 : in std_ulogic;		--switch 2 (reset)

      --FLASH
      oA_FLASH	: out	std_ulogic_vector (cFLASHAddrWidth-1 downto 0);
      bD_FLASH	: inout std_logic_vector (7 downto 0);
      iRB_FLASH : in	std_ulogic;
      oOE_FLASH : out	std_ulogic;
      oCE_FLASH : out	std_ulogic;
      oWE_FLASH : out	std_ulogic;
      --RESET_FLASH :out std_ulogic; connected to SW2
      --ACC_FLASH :out std_ulogic;

      --SRAM
      oA_SRAM	: out	std_ulogic_vector (cSRAMAddrWidth-1 downto 0);
      bD_SRAM	: inout std_logic_vector (31 downto 0);	 --inout
      oCE_SRAM	: out	std_ulogic;
      oWE_SRAM	: out	std_ulogic;
      oOE_SRAM	: out	std_ulogic;
      oUB1_SRAM : out	std_ulogic;
      oUB2_SRAM : out	std_ulogic;
      oLB1_SRAM : out	std_ulogic;
      oLB2_SRAM : out	std_ulogic;

      -- framebuffer VGA
      oDCLK	 : out std_ulogic;
      oHD	 : out std_ulogic;
      oVD	 : out std_ulogic;
      oDENA	 : out std_ulogic;
      oRed	 : out std_ulogic_vector(5 downto 3);
      oGreen	 : out std_ulogic_vector(5 downto 3);
      oBlue	 : out std_ulogic_vector(5 downto 3);
      --FRONT PANEL
      oFPSW_PE	 : out std_ulogic;
      iFPSW_DOUT : in  std_ulogic;
      oFPSW_CLK	 : out std_ulogic;
      iFPSW_F2	 : in  std_ulogic;
      iFPSW_F1	 : in  std_ulogic;
      oFPLED_OE	 : out std_ulogic;
      oFPLED_WR	 : out std_ulogic;
      oFPLED_DIN : out std_ulogic;
      oFPLED_CLK : out std_ulogic;

      --FPGA2
      iFPGA2_C7	  : in std_ulogic;
      iFPGA2_H11  : in std_ulogic;
      iFPGA2_AB10 : in std_ulogic;
      iFPGA2_U10  : in std_ulogic;
      iFPGA2_W9	  : in std_ulogic;
      iFPGA2_T7	  : in std_ulogic;

      --CONTROL of inputs
      iUx6	  : in	std_ulogic;  -- not soldering register channels 1,2 è 3,4
      iUx11	  : in	std_ulogic;	-- not soldering register channels 1,2
      iAAQpin5	  : in	std_ulogic;
      oCalibrator : out std_ulogic;

      -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
      oPWMout  : out std_ulogic;	--Level Of External Syncro
      iSinhcro : in  std_ulogic;	--Comparator external syncro.
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
      errorn	  : out std_ulogic;
      resoutn	  : out std_ulogic;
      oResetAsync : out std_ulogic;
-- pragma translate_on

      --CLK
--    iResetAsync : in	std_ulogic;	  -- Where is the async reset input pin ?
      iclk25_2	: in  std_ulogic;
      iclk25_7	: in  std_ulogic;
      iclk25_10 : in  std_ulogic;
      iclk25_15 : in  std_ulogic;
      iclk13inp : in  std_ulogic;	--wire W12-U15
      oclk13out : out std_ulogic;	--W12-U15
      iclk12_5	: in  std_ulogic
      );
  end component;

  -- start the bhv adcs at the right time
  signal ResetADC : std_ulogic;

--  for all : leon3mini
--    use entity work.NetlistWrapper;
  
begin
  
  ResetADC <= ResetAsync after 1100 ps;
  -- if the wave file was not found these adc act as an ascending counter
  CH : for i in 0 to cChannels-1 generate
    ADC : for j in 0 to cADCsperChannel-1 generate
      BHV : BhvADC
	generic map (
	  gFileName    => cWaveFileNames(i)(j),
	  gStartValue  => j,
	  gCountValue  => cADCsperChannel,
	  gBitWidth    => cADCBitWidth,
	  gOutputDelay => 1900 ps)
	port map (
	  iClk	      => ADCClk(j),
	  iResetAsync => ResetADC,
	  oData	      => ADCData(j)(i));
    end generate;
  end generate;

  iclk25_2  <= clk;
  iclk25_7  <= clk;
  iclk25_10 <= clk;
  iclk25_15 <= clk;
  iclk13inp <= oclk13out;
  iclk12_5  <= not iclk12_5 after ct * 2 ns;

  MUX : entity work.DeMux_HCT238
    port map (
      iA   => oDesh,
      inE1 => '0',
      inE2 => '0',
      iE3  => oDeshENA,
      oQ   => ASEnable);

  DACEn <= not ASEnable(6);
  DAC : entity work.DAC_LTC2612
    generic map (gUnusedDataBits => 2)
    port map (
      inCE => DACEn,
      iSCK => oRegCLK,
      iSD  => oRegData,
      iRef => 2.5,
      oA   => DAC_A,
      oB   => DAC_B,
      iGND => -2.5);

  CH0_RegL : entity work.StoP_hc595
    port map (
      iSD    => oRegData,
      iSCK   => oRegCLK,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => ASDCh0,
      oQ     => open);

  CH0_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh0,
      iSCK   => oRegCLK,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => open,
      oQ     => open);

  CH1_RegL : entity work.StoP_hc595
    port map (
      iSD    => oRegData,
      iSCK   => oRegCLK,
      inSCLR => '1',
      iRCK   => ASEnable(5),
      iG     => '1',
      oSD    => ASDCh1,
      oQ     => open);

  CH1_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh1,
      iSCK   => oRegCLK,
      inSCLR => '1',
      iRCK   => ASEnable(5),
      iG     => '1',
      oSD    => open,
      oQ     => open);

  
  iFPSW_DOUT <= KeySD(cKeyBanks);
  KeySD(0)   <= '-';
  pKeys : for i in 0 to cKeyBanks-1 generate
    Bank : PtoS_hct165
      port map (
	iSD  => KeySD(i),
	iCK  => oFPSW_CLK,
	inCE => '0',
	inMR => '1',
	inPE => oFPSW_PE,
	iPD  => KeyData(i),
	oQ   => KeySD(i+1),
	onQ  => open);
  end generate;

  StimuliKeys : process
    variable c : unsigned(7 downto 0);
    variable x : integer := 0;
  begin
    KeyData		    <= (others => (others => '0'));
    KeyData(0)(0)	    <= '1';
    KeyData(cKeyBanks-1)(7) <= '1';
--    KeyData(2)(4) <= '1';-- BTN_F1
--    KeyData(2)(5) <= '1';-- BTN_F2
--    KeyData(2)(6) <= '1';-- BTN_F3
--    KeyData(2)(7) <= '1';-- BTN_F4
--    KeyData(2)(1) <= '1';-- BTN_F5
--    KeyData(2)(3) <= '1';-- BTN_F6
    KeyData(2)(0)	    <= '1';	-- BTN_CH0
    KeyData(2)(2)	    <= '1';	-- BTN_CH1
    KeyData(0)(3)	    <= '1';	-- BTN_CH2
    KeyData(0)(0)	    <= '1';	-- BTN_CH3
    wait until oFPSW_PE = '0';
    wait until oFPSW_PE = '0';
    wait until oFPSW_PE = '0';
    wait until oFPSW_PE = '0';
    KeyData(2)(0)	    <= '0';	-- BTN_CH0
    KeyData(2)(2)	    <= '0';	-- BTN_CH1
    wait until oFPSW_PE = '0';
    wait until oFPSW_PE = '0';
    wait until oFPSW_PE = '0';
    loop
      wait until oFPSW_PE = '0';
      x := x + 1;
      if x mod 7 > 5 then
	for i in KeyData'range loop
	  c		     := unsigned(KeyData(i)(0 to 7)) +5;
	  KeyData(i)(0 to 7) <= std_ulogic_vector(c(7 downto 0));
	end loop;
      end if;
    end loop;
  end process;

  LedSD(0) <= oFPLED_DIN;
  pLeds : for i in 0 to cLedBanks-1 generate
    Bank : StoP_hc595
      port map (
	iSD    => LedSD(i),
	iSCK   => oFPLED_CLK,
	inSCLR => '1',
	iRCK   => oFPLED_WR,
	iG     => oFPLED_OE,
	oSD    => LedSD(i+1),
	oQ     => open);
  end generate;

-- original hpe mini testbench
-- clock and reset

  clk  <= not clk after ct * 1 ns;
  rst  <= '1'	  after 10 ns;
  rxd1 <= 'H';

  iRXD	   <= '1';
  bD_FLASH <= (others => 'Z');

  d3 : leon3mini
    generic map (
      fabtech => fabtech, memtech => memtech, padtech => padtech,
      clktech => clktech, disas => disas, dbguart => dbguart,
      pclow   => pclow)
    port map (
      --RS232
      iRXD => iRXD,			--RS232 
      oTXD => oTXD,

      --USB
      iUSBRX => iUSBRX,			-- Receive from USB
      oUSBTX => oUSBTX,			-- Tratsmit to USB

      --SWITCH on board
      iSW1 => iSW1,			--switch 1
      iSW2 => iSW2,			--switch 2 (reset)

      --FLASH
      oA_FLASH	=> oA_FLASH,
      bD_FLASH	=> bD_FLASH,
      iRB_FLASH => iRB_FLASH,
      oOE_FLASH => oOE_FLASH,
      oCE_FLASH => oCE_FLASH,
      oWE_FLASH => oWE_FLASH,
      --RESET_FLASH :out std_ulogic; connected to SW2
      --ACC_FLASH :out std_ulogic;

      --SRAM
      oA_SRAM	=> A_SRAM(A_SRAM'high downto 2),
      bD_SRAM	=> bD_SRAM,
      oCE_SRAM	=> oCE_SRAM,
      oWE_SRAM	=> oWE_SRAM,
      oOE_SRAM	=> oOE_SRAM,
      oUB1_SRAM => oUB1_SRAM,
      oUB2_SRAM => oUB2_SRAM,
      oLB1_SRAM => oLB1_SRAM,
      oLB2_SRAM => oLB2_SRAM,

      -- framebuffer VGA
      oDCLK  => DCLK,
      oHD    => HD,
      oVD    => VD,
      oDENA  => DENA,
      oRed   => Red,
      oGreen => Green,
      oBlue  => Blue,

      --FRONT PANEL
      oFPSW_PE	 => oFPSW_PE,
      iFPSW_DOUT => iFPSW_DOUT,
      oFPSW_CLK	 => oFPSW_CLK,
      iFPSW_F2	 => iFPSW_F2,
      iFPSW_F1	 => iFPSW_F1,
      oFPLED_OE	 => oFPLED_OE,
      oFPLED_WR	 => oFPLED_WR,
      oFPLED_DIN => oFPLED_DIN,
      oFPLED_CLK => oFPLED_CLK,

      --FPGA2
      iFPGA2_C7	  => iFPGA2_C7,
      iFPGA2_H11  => iFPGA2_H11,
      iFPGA2_AB10 => iFPGA2_AB10,
      iFPGA2_U10  => iFPGA2_U10,
      iFPGA2_W9	  => iFPGA2_W9,
      iFPGA2_T7	  => iFPGA2_T7,

      --CONTROL of inputs
      iUx6	  => iUx6,   -- not soldering register channels 1,2 è 3,4
      iUx11	  => iUx11,		-- not soldering register channels 1,2
      iAAQpin5	  => AAQpin5,
      oCalibrator => oCalibrator,

      -- NormalTrigger-ea.vhd,... they all can trigger with 1 Gs!
      oPWMout  => oPWMout,		--Level Of External Syncro
      iSinhcro => iSinhcro,		--Comparator external syncro.
      oDesh    => oDesh,		--demux. write strob for 4094
      oDeshENA => oDeshENA,
      oRegCLK  => oRegCLK,
      oRegData => oRegData,

      oADC1CLK => ADCCLK(0),
      oADC2CLK => ADCCLK(1),
      oADC3CLK => ADCCLK(2),
      oADC4CLK => ADCCLK(3),
      iCh1ADC1 => ADCData(0)(0),
      iCh1ADC2 => ADCData(1)(0),
      iCh1ADC3 => ADCData(2)(0),
      iCh1ADC4 => ADCData(3)(0),
      iCh2ADC1 => ADCData(0)(1),
      iCh2ADC2 => ADCData(1)(1),
      iCh2ADC3 => ADCData(2)(1),
      iCh2ADC4 => ADCData(3)(1),

      --CLK
--    iResetAsync : in	std_ulogic;	  -- Where is the async reset input pin ?
      iclk25_2	=> iclk25_2,
      iclk25_7	=> iclk25_7,
      iclk25_10 => iclk25_10,
      iclk25_15 => iclk25_15,
      iclk13inp => iclk13inp,		--wire W12-U15
      oclk13out => oclk13out,		--W12-U15
      iclk12_5	=> iclk12_5,

      oResetAsync => ResetAsync,
      resoutn	  => resoutn,
      errorn	  => error
      );

--  extbprom : if CFG_BOOTOPT = 0 generate
--    prom0 : for i in 0 to (romwidth/8)-1 generate
--	sr0 : sram generic map (index => i, abits => romdepth, fname => promfile)
--	  port map (address(romdepth+1 downto 2), data(31-i*8 downto 24-i*8), romsn(0),
--		    rwen(i), oen);   
--    end generate;
--  end generate extbprom;


--  sram0 : for i in 0 to (sramwidth/8)-1 generate
--    sr0 : sram generic map (index => i, abits => sramdepth, fname => sramfile)
--	port map (address(sramdepth+1 downto 2), data(31-i*8 downto 24-i*8), ramsn(0),
--		  --	     rben(0), ramoen(0));    -- **** tame: changed rwen to rben
--		   rwen(0), ramoen(0));
--  end generate;

  sram0 : entity work.AsyncSRAM
    generic map (
	gFileName  => "sram.bin",
	gReverseEndian => true,
	gAddrWidth => A_SRAM'length-2)
    port map (
	iAddr  => A_SRAM(A_SRAM'high downto 2),
	bData  => bD_SRAM,
	inCE   => oCE_SRAM,
	inWE   => oWE_SRAM,
	inOE   => oOE_SRAM,
	inMask => "0000");

--  sram0 : for i in 0 to (sramwidth/8)-1 generate
--    sr0 : sram generic map (index => i, abits => A_SRAM'length-2, fname => sramfile)
--      port map (
--	a   => std_logic_vector(A_SRAM(A_SRAM'high downto 2)),
--	d   => bD_SRAM(31-i*8 downto 24-i*8),
--	ce1 => oCE_SRAM,
--	we  => oWE_SRAM,
--	oe  => oOE_SRAM);
--  end generate;

  error <= 'H';				-- ERROR pull-up

  iuerr : process(error)
  begin
    assert (error /= '0')
      report "*** IU in error mode, simulation halted ***"
      severity failure;
  end process;

  -- test0 : grtestmod
  --   port map (rst, clk, error, address(21 downto 2), data,
  --		  iosn, oen, writen, brdyn);

  dcomstart : if CFG_BOOTOPT = 0 generate

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
	txc(dsutx, 16#55#, txp);	-- sync uart

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

  end generate dcomstart;


  altstimuli : if CFG_BOOTOPT = 1 generate
    stimuli : process
    begin
      dsurx <= '1';
      -- rxd1 <= 'H'; --already defined above
      txd1  <= 'H';


      wait;
    end process STIMULI;
  end generate altstimuli;

end;


