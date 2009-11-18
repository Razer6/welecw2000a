-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : Testbench-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-08-20
-- Last update: 2009-11-18
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
  signal Clk                     : std_ulogic := '1';
  signal ResetAsync              : std_ulogic := cResetActive;
  signal SerialClk               : std_ulogic;
  signal Leds, PHYLeds           : aLeds;
  signal Keys                    : aKeys;
  signal AnalogSettings          : aAnalogSettings;
  signal AnalogBusy              : std_ulogic;
  signal FPtoLeds                : aShiftOut;
  signal FPtoKeys                : aShiftIn;
  signal FPtoAnalog, nFPtoAnalog : aAnalogSettingsOut;

  signal DAC_A, DAC_B   : real;
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

  type   aLedData is array (0 to cLedBanks-1) of std_ulogic_vector(0 to 7);
  signal LedData : aLedData;

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
      inMR : in  std_ulogic;
      inPE : in  std_ulogic;
      iPD  : in  std_ulogic_vector(0 to 7);
      oQ   : out std_ulogic;
      onQ  : out std_ulogic);
  end component;
  
begin
  
  Clk        <= not Clk          after 1 sec /(2*31250E3);
  ResetAsync <= not cResetActive after 4 sec /(2*31250E3);

  StimuliLeds : process
  begin
    Leds                <= (others => '0');
    Leds.SetLeds        <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH0        <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH1        <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CH2        <= '1';
    Leds.SetLeds        <= '0';
    wait until FPtoKeys.nFetchStrobe = '1';
    Leds.LED_CH3        <= '1';
    Leds.SetLeds        <= '1';
    wait until Clk = '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_MATH       <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_QUICKMEAS  <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_CURSORS    <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_WHEEL      <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_PULSEWIDTH <= '1';

    wait until FPtoLeds.ValidStrobe = '1';
    Leds.LED_EDGE     <= '1';
    Leds.SetLeds      <= '0';
    wait until FPtoKeys.nFetchStrobe = '1';
    wait until FPtoKeys.nFetchStrobe = '1';
    Leds.SetLeds      <= '1';
    Leds.RUN_GREEN    <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.RUN_RED      <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.SINGLE_GREEN <= '1';
    wait until FPtoLeds.ValidStrobe = '1';
    Leds.SINGLE_RED   <= '1';
    wait;
  end process;

  StimuliKeys : process
    variable c : unsigned(7 downto 0);
    variable x : integer := 0;
  begin
    KeyData                 <= (others => (others => '0'));
    KeyData(0)(0)           <= '1';
    KeyData(cKeyBanks-1)(7) <= '1';
--    KeyData(2)(4) <= '1';-- BTN_F1
--    KeyData(2)(5) <= '1';-- BTN_F2
--    KeyData(2)(6) <= '1';-- BTN_F3
--    KeyData(2)(7) <= '1';-- BTN_F4
--    KeyData(2)(1) <= '1';-- BTN_F5
--    KeyData(2)(3) <= '1';-- BTN_F6
    KeyData(2)(0)           <= '1';     -- BTN_CH0
    KeyData(2)(2)           <= '1';     -- BTN_CH1
    KeyData(0)(3)           <= '1';     -- BTN_CH2
    KeyData(0)(0)           <= '1';     -- BTN_CH3
    wait until FPtoKeys.nFetchStrobe = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    KeyData(2)(0)           <= '0';     -- BTN_CH0
    KeyData(2)(2)           <= '0';     -- BTN_CH1
    wait until FPtoKeys.nFetchStrobe = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    loop
      wait until FPtoKeys.nFetchStrobe = '0';
      wait until FPtoKeys.nFetchStrobe = '0';
      x := x + 1;
      if x mod 7 > 5 then
        for i in KeyData'range loop
          c                  := unsigned(KeyData(i)(0 to 7)) +5;
          KeyData(i)(0 to 7) <= std_ulogic_vector(c(7 downto 0));
        end loop;
      end if;
    end loop;
  end process;

  StimuliAS : process
  begin
    AnalogSettings <= (
      Addr           => (others => '0'),
      Data           => (others => '0'),
      EnableKeyClock => '1',
--        CH0_src2_addr => (others => '0'),
--        CH1_src2_addr => (others => '0'),
--        CH2_src2_addr => (others => '0'),
--        CH3_src2_addr => (others => '0'),
--        DAC_Offset    => (others => '0'),
--        PWM_Offset    => (others => '0'),
      others         => '0');

    wait until FPtoKeys.nFetchStrobe = cLowActive;
--              0      => not iCPUtoAnalog.CH1_K1_ON,
--              1      => not iCPUtoAnalog.CH1_K1_OFF,
--              2      => not iCPUtoAnalog.CH1_K2_ON,
--              3      => not iCPUtoAnalog.CH1_K2_OFF,
--              4      => iCPUtoAnalog.CH1_OPA656,
--              5      => iCPUtoAnalog.CH1_BW_Limit,
--              6      => iCPUtoAnalog.CH1_U14,
--              7      => iCPUtoAnalog.CH1_U13,
--              8      => iCPUtoAnalog.CH0_src2_addr(0),
--              9      => iCPUtoAnalog.CH0_src2_addr(1),
--              10     => iCPUtoAnalog.CH1_src2_addr(0),
--              11     => iCPUtoAnalog.CH1_src2_addr(1),
--              12     => iCPUtoAnalog.CH2_src2_addr(0),
--              13     => iCPUtoAnalog.CH2_src2_addr(1),
--              14     => iCPUtoAnalog.CH3_src2_addr(0),
--              15     => iCPUtoAnalog.CH3_src2_addr(1),
    AnalogSettings.Addr              <= O"5";
    AnalogSettings.Data(15 downto 0) <= "0110111100001111";
    AnalogSettings.Set               <= '1';
    wait until Clk = '1';
    AnalogSettings.Set               <= '0';
    wait until AnalogBusy = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    AnalogSettings.Addr              <= O"6";
    AnalogSettings.Data(23 downto 0) <= "0010" & O"0" & "0" & "0011001100001111";
    AnalogSettings.Set               <= '1';
    wait until Clk = '1';
    AnalogSettings.Set               <= '0';
    wait until AnalogBusy = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    AnalogSettings.Addr              <= O"6";
    AnalogSettings.Data(23 downto 0) <= "0010" & O"0" & "1" & "1111001100001100";
    AnalogSettings.Set               <= '1';
    wait until Clk = '1';
    AnalogSettings.Set               <= '0';
    wait until AnalogBusy = '0';
    wait until FPtoKeys.nFetchStrobe = '0';
    AnalogSettings.Addr              <= O"7";
    AnalogSettings.Data(15 downto 0) <= "0110111100001111";
    AnalogSettings.Set               <= '1';
    wait until Clk = '1';
    AnalogSettings.Set               <= '0';
    wait until AnalogBusy = '0';
    for i in 0 to 100 loop
      wait until FPtoKeys.nFetchStrobe = '0';
    end loop;

    report "Simulation finished, no failure!" severity failure;
  end process;


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

  
  nFPtoAnalog.SerialClk <= not FPtoAnalog.SerialClk;
  nFPtoAnalog.Addr      <= not FPtoAnalog.Addr;
  nFPtoAnalog.Data      <= not FPtoAnalog.Data;
  nFPtoAnalog.PWM       <= not FPtoAnalog.PWM;
  nFPtoAnalog.Enable    <= not FPtoAnalog.Enable;

  MUX : entity work.DeMux_HCT238
    port map (
      iA   => nFPtoAnalog.Addr,
      inE1 => '0',
      inE2 => '0',
      iE3  => nFPtoAnalog.Enable,
      oQ   => ASEnable);

  DACEn <= not ASEnable(6);
  DAC : entity work.DAC_LTC2612
    generic map (gUnusedDataBits => 2)
    port map (
      inCE => DACEn,
      iSCK => nFPtoAnalog.SerialClk,
      iSD  => nFPtoAnalog.Data,
      iRef => 2.5,
      oA   => DAC_A,
      oB   => DAC_B,
      iGND => -2.5);

  CH0_RegL : entity work.StoP_hc595
    port map (
      iSD    => nFPtoAnalog.Data,
      iSCK   => nFPtoAnalog.SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => ASDCh0,
      oQ     => open);

  CH0_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh0,
      iSCK   => nFPtoAnalog.SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(7),
      iG     => '1',
      oSD    => open,
      oQ     => open);

  CH1_RegL : entity work.StoP_hc595
    port map (
      iSD    => nFPtoAnalog.Data,
      iSCK   => nFPtoAnalog.SerialClk,
      inSCLR => '1',
      iRCK   => ASEnable(5),
      iG     => '1',
      oSD    => ASDCh1,
      oQ     => open);

  CH1_RegH : entity work.StoP_hc595
    port map (
      iSD    => ASDCh1,
      iSCK   => nFPtoAnalog.SerialClk,
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
        iCK  => FPtoKeys.SerialClk,
        inCE => '0',
        inMR => '1',
        inPE => FPtoKeys.nFetchStrobe,
        iPD  => KeyData(i),
        oQ   => KeySD(i+1),
        onQ  => open);
  end generate;

  LedSD(0) <= FPtoLeds.Data;
  pLeds : for i in 0 to cLedBanks-1 generate
    Bank : StoP_hc595
      port map (
        iSD    => LedSD(i),
        iSCK   => FPtoLeds.SerialClk,
        inSCLR => '1',
        iRCK   => FPtoLeds.ValidStrobe,
        iG     => FPtoLeds.nOutputEnable,
        oSD    => LedSD(i+1),
        oQ     => LedData(i));
  end generate;
  
  PHYLeds <= (
    SetLeds        => '0',
    LED_CH3        => LedData(1)(7),
    LED_CH0        => LedData(1)(6),
    LED_MATH       => LedData(1)(5),
    LED_CH1        => LedData(1)(4),
    LED_QUICKMEAS  => LedData(1)(3),
    LED_CURSORS    => LedData(1)(2),
    LED_WHEEL      => LedData(1)(1),
    LED_CH2        => LedData(1)(0),
    LED_PULSEWIDTH => LedData(0)(7),
    LED_EDGE       => LedData(0)(6),
    RUN_GREEN      => LedData(0)(5),
    RUN_RED        => LedData(0)(4),
    SINGLE_RED     => LedData(0)(3),
    SINGLE_GREEN   => LedData(0)(2));     


end architecture;
