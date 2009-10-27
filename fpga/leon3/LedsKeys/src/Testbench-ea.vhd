-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : Testbench-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-08-20
-- Last update: 2009-10-25
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
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
-- 2009-08-20  1.0
-------------------------------------------------------------------------------



entity Testbench is
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pLedsKeysAnalogSettings.all;

architecture bhv of Testbench is
  signal Clk            : std_ulogic := '1';
  signal ResetAsync     : std_ulogic := cResetActive;
  signal SerialClk      : std_ulogic;
  signal Leds           : aLeds;
  signal Keys           : aKeys;
  signal AnalogSettings : aAnalogSettings;
  signal AnalogBusy     : std_ulogic;
  signal FPtoLeds       : aShiftOut;
  signal FPtoKeys       : aShiftIn;
  signal FPtoAnalog     : aAnalogSettingsOut;
    
    signal DAC_A, DAC_B : real;
  signal ASEnable       : std_ulogic_vector(0 to 7);
  signal DACEn          : std_ulogic;
  signal ASDCh0, ASDCh1 : std_ulogic;

  constant cLedBanks : natural := 2;
  constant cKeyBanks : natural := 7;
  signal   LedSD     : std_ulogic_vector(0 to cLedBanks);
  signal   KeySD     : std_ulogic_vector(0 to cKeyBanks);
  type     aKeyData is array (0 to cKeyBanks-1) of std_ulogic_vector(0 to 7);
  signal KeyData : aKeyData := (
    0                => X"F0",
    1                => X"FF",
    2 to cKeyBanks-2 => X"A5",
    cKeyBanks-1      => X"0F");

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
      iSD  : in  std_ulogic;
      iCK  : in  std_ulogic;
      inCE : in  std_ulogic;
      inPL : in  std_ulogic;
      iPD  : in  std_ulogic_vector(0 to 7);
      oQ   : out std_ulogic;
      onQ  : out std_ulogic);
  end component;
  
begin
  
  Clk        <= not Clk         after 1 sec /(2*31250E3);
  ResetAsync <= not cResetActive after 4 sec /(2*31250E3);

  StimuliLeds : process
  begin
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH0        <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH1        <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH2        <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH3        <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_MATH       <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_QUICKMEAS  <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CURSORS    <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_WHEEL      <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_PULSEWIDTH <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_EDGE       <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.RUN_GREEN      <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.RUN_RED        <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.SINGLE_GREEN   <= '0';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.SINGLE_RED     <= '0';
    wait;
  end process;
  
  StimuliKeys: process (FPtoKeys.nFetchStrobe)
    variable c : unsigned(7 downto 0);
  begin
    if FPtoKeys.nFetchStrobe = cHighInactive then
      for i in KeyData'range loop
        c := unsigned(KeyData(i)(0 to 7)) +5;
        KeyData(i)(0 to 7) <= std_ulogic_vector(c(7 downto 0));
      end loop;
    end if;
  end process;
  
  
  AnalogSettings <= (
        Addr          => (others => '0'),
        CH0_src2_addr => (others => '0'),
        CH1_src2_addr => (others => '0'),
        CH2_src2_addr => (others => '0'),
        CH3_src2_addr => (others => '0'),
        DAC_Offset    => (others => '0'),
        PWM_Offset    => (others => '0'),
        others        => '0');
  

  FrontPanel : entity DSO.LedsKeysAnalogSettings
    port map (
      iClk            => Clk,
      iResetAsync     => ResetAsync,
      iLeds           => Leds,
      oLeds           => FPtoLeds,
      iKeysData       => KeySD(cKeyBanks),
      onFetchKeys     => FPtoKeys,
      oKeys           => Keys,
      iCPUtoAnalog    => AnalogSettings,
      oAnalogBusy     => AnalogBusy,
      oAnalogSettings => FPtoAnalog,
      oSerialClk      => SerialClk);

  
  MUX : entity work.DeMux_HCT238
    port map (
      iA   => FPtoAnalog.Addr,
      inE1 => '0',
      inE2 => '0',
      iE3  => FPtoAnalog.Enable,
      oQ   => ASEnable);

  DACEn <= not ASEnable(6);
  DAC : entity work.DAC_LTC2612
    generic map (gUnusedDataBits => 2)
    port map (
      inCE => DACEn,
      iSCK => SerialClk,
      iSD  => FPtoAnalog.Data,
      iRef => 2.5,
      oA   => DAC_A,
      oB   => DAC_B,
      iGND => -2.5);

  CH0_RegL : entity work.StoP_hc595
    port map (
      iSD    => FPtoAnalog.Data,
      iSCK   => SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => ASDCh0,
      oQ     => open);

  CH0_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh0,
      iSCK   => SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => open,
      oQ     => open);

  CH1_RegL : entity work.StoP_hc595
    port map (
      iSD    => FPtoAnalog.Data,
      iSCK   => SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(5),
      iG     => '1',
      oSD    => ASDCh1,
      oQ     => open);

  CH1_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh1,
      iSCK   => SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(5),
      iG     => '1',
      oSD    => open,
      oQ     => open);

  
  KeySD(0) <= '-';
  pKeys : for i in 0 to cKeyBanks-1 generate
    Bank : PtoS_hct165
      port map (
        iSD  => KeySD(i),
        iCK  => SerialClk,
        inCE => '0',
        inPL => FPtoKeys.nFetchStrobe,
        iPD  => KeyData(i),
        oQ   => KeySD(i+1),
        onQ  => open);
  end generate;

  LedSD(0) <= FPtoLeds.Data;
  pLeds : for i in 0 to cLedBanks-1 generate
    Bank : StoP_hc595
      port map (
        iSD    => LedSD(i),
        iSCK   => SerialClk,
        inSCLR => '1',
        iRCK   => FPtoLeds.ValidStrobe,
        iG     => FPtoLeds.nOutputEnable,
        oSD    => LedSD(i+1),
        oQ     => open);
  end generate;
  
end architecture;
