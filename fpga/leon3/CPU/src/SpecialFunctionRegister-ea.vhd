-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegister-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-06-06
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
-- 2009-02-14  1.0      
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pSpecialFunctionRegister.all;
use DSO.pTrigger.all;
use DSO.pPolyphaseDecimator.all;
use DSO.pLedsKeysAnalogSettings.all;

entity SpecialFunctionRegister is
  port (
    iClk          : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iAddr         : in  aDword;
    iWr           : in  std_ulogic;
    iWrMask       : in  std_ulogic_vector(3 downto 0);
    iRd           : in  std_ulogic;
    iData         : in  aDword;
    oData         : out aDword;
    oCPUInterrupt : out std_ulogic;
    iSFRControl   : in  aSFR_in;
    oSFRControl   : out aSFR_out);
end entity;

architecture RTL of SpecialFunctionRegister is
  signal InterruptMask             : aDword;
  signal InterruptVector           : aDword;
  signal Decimator                 : aDownSampler;
  signal SignalSelector            : aSignalSelector;
  signal ExtTriggerSrc             : aExtTriggerInput;
  signal Trigger                   : aTriggerInput;
  signal Leds                      : aLeds;
  signal nConfigADC                : std_ulogic_vector(cChannels-1 downto 0);
  signal AnalogSettings            : aAnalogSettings;
  signal PrevTriggerBusy           : std_ulogic;
  signal PrevTriggerStartRecording : std_ulogic;
  signal Addr                      : natural;
begin
  
  oSFRControl.Decimator      <= Decimator;
  oSFRControl.SignalSelector <= SignalSelector;
  oSFRControl.ExtTriggerSrc  <= ExtTriggerSrc;
  oSFRControl.Trigger        <= Trigger;
  oSFRControl.nConfigADC     <= nConfigADC;
  oSFRControl.Leds           <= Leds;
  oSFRControl.AnalogSettings <= AnalogSettings;
  Addr                       <= to_integer(unsigned(iAddr(7 downto 2)));


  pInterrupt : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      oCPUInterrupt             <= '0';
      InterruptVector           <= (others => '0');
      PrevTriggerBusy           <= '0';
      PrevTriggerStartRecording <= '0';
    elsif rising_edge(iCLK) then
      PrevTriggerBusy <= iSFRControl.Trigger.Busy;
      if PrevTriggerBusy = '1' and iSFRControl.Trigger.Busy = '0' then
        InterruptVector(0) <= '1';
      end if;
      PrevTriggerStartRecording <= iSFRControl.Trigger.Recording;
      if PrevTriggerStartRecording = '1' and iSFRControl.Trigger.Recording = '0' then
        InterruptVector(1) <= '1';
      end if;
--      InterruptVector(2) <= iSFRControl.KeyInterruptLH;
--      InterruptVector(3) <= iSFRControl.KeyInterruptHL;
      --  InterruptVector(4) <= iSFRControl.Uart.Interrupt;

      if Addr = cInterruptAddr then
        if iWr = '1' then
          InterruptVector <= iData;
        end if;
      end if;

      if (InterruptVector and InterruptMask) = X"00000000" then
        oCPUInterrupt <= '0';
      else
        oCPUInterrupt <= '1';
      end if;
    end if;
  end process;

  pWrite : process (iClk, iResetAsync)
    variable vData : aDword;
  begin
    if iResetAsync = cResetActive then
      InterruptMask <= (others => '0');
      Decimator <= (
        Stages       => (others => '0'),
        EnableFilter => (others => '0'));
      case cCurrentDevice is
        when cWelec2012 | cWelec2022 =>
          SignalSelector <= (
            0 => O"0",
            1 => O"1",
            2 => O"0",
            3 => O"1");
        when cWelec2014 | cWelec2024 =>
          SignalSelector <= (
            0 => O"0",
            1 => O"1",
            2 => O"2",
            3 => O"3");
--        when cSandboxX =>
--          SignalSelector <= (
--            0                => O"0",
--            1                => O"4",
--            2                => O"0",
--            3                => O"4");
        when others =>
          SignalSelector <= (
            others => O"0");
      end case;
      
      ExtTriggerSrc <= (
        Addr   => 0,
        others => (others => (others => '0')));

      Trigger <= (
        TriggerOnce     => '0',
        ForceIdle       => '0',
        PreambleCounter => to_unsigned(32, aTriggerAddr'length),
        Trigger         => 2,
        TriggerChannel  => 0,
        StorageMode     => "00",
        -- Trigger mode specific:
        LowValue        => std_ulogic_vector(to_signed(-16, Trigger.LowValue'length)),
        HighValue       => std_ulogic_vector(to_signed(16, Trigger.HighValue'length)),
        LowTime         => std_ulogic_vector(to_signed(50, Trigger.LowTime'length)),
        HighTime        => std_ulogic_vector(to_signed(50, Trigger.HighTime'length)),
        SetReadOffset   => '0',
        ReadOffset      => (others => '0'));

      nConfigADC <= (others => cLowActive);
      
      Leds <= (
        BTN_CH3        => '0',
        Beam1On        => '0',
        BTN_MATH       => '0',
        Beam2On        => '0',
        BTN_QUICKMEAS  => '0',
        CURSORS        => '0',
        BTN_F1         => '0',
        BTN_CH2        => '0',
        BTN_PULSEWIDTH => '0',
        EDGE           => '0',
        RUNSTOP        => '0',
        BTN_F2         => '0',
        BTN_F3         => '0',
        SINGLE         => '0');

      AnalogSettings <= (
        Addr          => (others => '0'),
        CH0_src2_addr => (others => '0'),
        CH1_src2_addr => (others => '0'),
        CH2_src2_addr => (others => '0'),
        CH3_src2_addr => (others => '0'),
        DAC_Offset    => (others => '0'),
        PWM_Offset    => (others => '0'),
        others        => '0');


    elsif rising_edge(iClk) then
      Trigger.TriggerOnce   <= '0';
      Trigger.ForceIdle     <= '0';
      Trigger.SetReadOffset <= '0';
      AnalogSettings.Set    <= '0';

      if iWr = '1' then
        case Addr is
          when cInterruptMaskAddr =>
            for i in iWrMask'range loop
              if iWrMask(i) = '1' then
                InterruptMask((i+1)*8-1 downto i*8) <= iData((i+1)*8-1 downto i*8);
              end if;
            end loop;
            
          when cSamplingFreqAddr =>
            Decimator.Stages <= iData(Decimator.Stages'range);
          when cFilterEnableAddr =>
            for i in Decimator.EnableFilter'range loop
              Decimator.EnableFilter(i) <= iData(i);
            end loop;
          when cExtTriggerSrcAddr =>
            -- a software bug can here cause a simulation failure! :-)
            ExtTriggerSrc.Addr <= to_integer(unsigned(iData));
          when cExtTriggerPWMAddr =>
            for i in 1 to cExtTriggers loop
              ExtTriggerSrc.PWM(i) <= iData(i*8-1 downto (i-1)*8);
            end loop;
          when cInputCh0Addr =>
            SignalSelector(0) <= iData(SignalSelector(0)'range);
          when cInputCh1Addr =>
            SignalSelector(1) <= iData(SignalSelector(1)'range);
          when cInputCh2Addr =>
            SignalSelector(2) <= iData(SignalSelector(2)'range);
          when cInputCh3Addr =>
            SignalSelector(3) <= iData(SignalSelector(3)'range);
          when cTriggerOnChAddr =>
            Trigger.TriggerChannel <= to_integer(unsigned(iData(1 downto 0)));
          when cTriggerOnceAddr =>
            if iData(0) = '1' then
              Trigger.TriggerOnce <= '1';
            else
              Trigger.ForceIdle <= '1';
            end if;
          when cTriggerPrefetchAddr =>
            Trigger.PreambleCounter <= unsigned(iData(Trigger.PreambleCounter'range));
          when cTriggerStorageModeAddr =>
            Trigger.StorageMode <= iData(Trigger.StorageMode'range);
          when cTriggerReadOffSetAddr =>
            Trigger.SetReadOffset <= '1';
            Trigger.ReadOffset    <= unsigned(iData(Trigger.ReadOffset'high downto 0));
          when cTriggerTypeAddr =>
            Trigger.Trigger <= to_integer(unsigned(iData(cDiffTriggers-1 downto 0)));
            
          when cTriggerLowValueAddr =>
            Trigger.LowValue <= iData(Trigger.LowValue'range);
          when cTriggerLowTimeAddr =>
            Trigger.LowTime <= iData(Trigger.LowTime'range);
          when cTriggerHighValueAddr =>
            Trigger.HighValue <= iData(Trigger.HighValue'range);
          when cTriggerHighTimeAddr =>
            Trigger.HighTime <= iData(Trigger.HighTime'range);
          when cTriggerStatusRegister =>
            null;
          when cTriggerCurrentAddr =>
            null;
          when cConfigADCEnable =>
            nConfigADC <= not iData(nConfigADC'range);
          when cLedAddr =>
            Leds <= (
              BTN_CH3        => iData(0),
              Beam1On        => iData(1),
              BTN_MATH       => iData(2),
              Beam2On        => iData(3),
              BTN_QUICKMEAS  => iData(4),
              CURSORS        => iData(5),
              BTN_F1         => iData(6),
              BTN_CH2        => iData(7),
              BTN_PULSEWIDTH => iData(8),
              EDGE           => iData(9),
              RUNSTOP        => iData(10),
              BTN_F2         => iData(11),
              BTN_F3         => iData(12),
              SINGLE         => iData(13));

          when cAnalogSettingsPWMAddr =>
            AnalogSettings.PWM_Offset <= iData(AnalogSettings.PWM_Offset'range);

            -----------------------------------------------------------------
            -- You must not change any bits between the AnalogSettingsBanks!
            -----------------------------------------------------------------
          when cAnalogSettingsBank7 =>
            AnalogSettings.Addr         <= O"7";
            AnalogSettings.Set          <= '1';
            AnalogSettings.CH0_K1_ON    <= iData(0);
            AnalogSettings.CH0_K1_OFF   <= iData(1);
            AnalogSettings.CH0_K2_ON    <= iData(2);
            AnalogSettings.CH0_K2_OFF   <= iData(3);
            AnalogSettings.CH0_OPA656   <= iData(4);
            AnalogSettings.CH0_BW_Limit <= iData(5);
            AnalogSettings.CH0_U14      <= iData(6);
            AnalogSettings.CH0_U13      <= iData(7);
            AnalogSettings.CH0_DC       <= iData(8);
            AnalogSettings.CH1_DC       <= iData(9);
            AnalogSettings.CH2_DC       <= iData(10);
            AnalogSettings.CH3_DC       <= iData(11);
            
          when cAnalogSettingsBank5 =>
            AnalogSettings.Addr          <= O"5";
            AnalogSettings.Set           <= '1';
            AnalogSettings.CH1_K1_ON     <= iData(0);
            AnalogSettings.CH1_K1_OFF    <= iData(1);
            AnalogSettings.CH1_K2_ON     <= iData(2);
            AnalogSettings.CH1_K2_OFF    <= iData(3);
            AnalogSettings.CH1_OPA656    <= iData(4);
            AnalogSettings.CH1_BW_Limit  <= iData(5);
            AnalogSettings.CH1_U14       <= iData(6);
            AnalogSettings.CH1_U13       <= iData(7);
            AnalogSettings.CH0_src2_addr <= iData(9 downto 8);
            AnalogSettings.CH1_src2_addr <= iData(11 downto 10);
            AnalogSettings.CH2_src2_addr <= iData(13 downto 12);
            AnalogSettings.CH3_src2_addr <= iData(15 downto 14);
            
          when cAnalogSettingsBank6 =>
            AnalogSettings.Addr       <= O"6";
            AnalogSettings.Set        <= '1';
            AnalogSettings.DAC_Offset <= iData(15 downto 0);
            AnalogSettings.DAC_Ch     <= iData(16);
            
          when others         =>
            null;
        end case;
      end if;
    end if;
  end process;

  pRead : process (Addr, iSFRControl, InterruptVector,
                   InterruptMask, Decimator, nConfigADC,
                   SignalSelector, Trigger, Leds, ExtTriggerSrc, AnalogSettings)
  begin
    oData <= (others => '0');
    case Addr is
      when cDeviceAddr =>
        oData <= std_ulogic_vector(to_unsigned(cCurrentDevice, oData'length));
      when cInterruptAddr =>
        oData <= InterruptVector;
      when cInterruptMaskAddr =>
        oData <= InterruptMask;
      when cSamplingFreqAddr =>
        oData(Decimator.Stages'range) <= Decimator.Stages;
      when cFilterEnableAddr =>
        for i in Decimator.EnableFilter'range loop
          oData(i) <= Decimator.EnableFilter(i);
        end loop;
      when cExtTriggerSrcAddr =>
        oData <= std_ulogic_vector(to_unsigned(ExtTriggerSrc.Addr,32));
      when cExtTriggerPWMAddr =>
        for i in 1 to cExtTriggers loop
          oData(i*8-1 downto (i-1)*8) <= ExtTriggerSrc.PWM(i);
        end loop;
      when cInputCh0Addr =>
        oData(SignalSelector(0)'range) <= SignalSelector(0);
      when cInputCh1Addr =>
        oData(SignalSelector(1)'range) <= SignalSelector(1);
      when cInputCh2Addr =>
        oData(SignalSelector(2)'range) <= SignalSelector(2);
      when cInputCh3Addr =>
        oData(SignalSelector(3)'range) <= SignalSelector(3);
      when cTriggerOnChAddr =>
        oData <= std_ulogic_vector(to_unsigned(Trigger.TriggerChannel, oData'length));
      when cTriggerPrefetchAddr =>
        oData(Trigger.PreambleCounter'range) <= std_ulogic_vector(Trigger.PreambleCounter);
      when cTriggerStorageModeAddr =>
        oData(Trigger.StorageMode'range) <= Trigger.StorageMode;
      when cTriggerReadOffSetAddr =>
        oData(iSFRControl.Trigger.ReadOffSet'high downto 0) <= std_ulogic_vector(iSFRControl.Trigger.ReadOffSet);
      when cTriggerTypeAddr =>
        oData <= std_ulogic_vector(to_unsigned(Trigger.Trigger, oData'length));
      when cTriggerLowValueAddr =>
        oData(Trigger.LowValue'range) <= Trigger.LowValue;
        -- sign extension
        oData(oData'high downto Trigger.LowValue'length) <= (
          others => Trigger.LowValue(Trigger.LowValue'high));
      when cTriggerLowTimeAddr =>
        oData(Trigger.LowTime'range) <= Trigger.LowTime;
      when cTriggerHighValueAddr =>
        oData(Trigger.HighValue'range) <= Trigger.HighValue;
        -- sign extension
        oData(oData'high downto Trigger.HighValue'length) <= (
          others => Trigger.LowValue(Trigger.LowValue'high));
      when cTriggerHighTimeAddr =>
        oData(Trigger.HighTime'range) <= Trigger.HighTime;
      when cTriggerStatusRegister =>
        oData(0) <= iSFRControl.Trigger.Busy;
        oData(1) <= iSFRControl.Trigger.Recording;
      when cTriggerCurrentAddr =>
        oData(iSFRControl.Trigger.CurrentTriggerAddr'high downto 0) <=
          std_ulogic_vector(iSFRControl.Trigger.CurrentTriggerAddr);
      when cConfigADCEnable =>
        oData(nConfigADC'range) <= nConfigADC;
      when cLedAddr =>
        oData(0)  <= Leds.BTN_CH3;
        oData(1)  <= Leds.Beam1On;
        oData(2)  <= Leds.BTN_MATH;
        oData(3)  <= Leds.Beam2On;
        oData(4)  <= Leds.BTN_QUICKMEAS;
        oData(5)  <= Leds.CURSORS;
        oData(6)  <= Leds.BTN_F1;
        oData(7)  <= Leds.BTN_CH2;
        oData(8)  <= Leds.BTN_PULSEWIDTH;
        oData(9)  <= Leds.EDGE;
        oData(10) <= Leds.RUNSTOP;
        oData(11) <= Leds.BTN_F2;
        oData(12) <= Leds.BTN_F3;
        oData(13) <= Leds.SINGLE;
      when cKeyAddr0 =>
        oData(0)  <= iSFRControl.Keys.BTN_F1;
        oData(1)  <= iSFRControl.Keys.BTN_F2;
        oData(2)  <= iSFRControl.Keys.BTN_F3;
        oData(3)  <= iSFRControl.Keys.BTN_F4;
        oData(4)  <= iSFRControl.Keys.BTN_F5;
        oData(5)  <= iSFRControl.Keys.BTN_F6;
        oData(6)  <= iSFRControl.Keys.BTN_MATH;
        oData(7)  <= iSFRControl.Keys.BTN_CH0;
        oData(8)  <= iSFRControl.Keys.BTN_CH1;
        oData(9)  <= iSFRControl.Keys.BTN_CH2;
        oData(10) <= iSFRControl.Keys.BTN_CH3;
        oData(11) <= iSFRControl.Keys.BTN_MAINDEL;
        oData(12) <= iSFRControl.Keys.BTN_RUNSTOP;
        oData(13) <= iSFRControl.Keys.BTN_SINGLE;
        oData(14) <= iSFRControl.Keys.BTN_CURSORS;
        oData(15) <= iSFRControl.Keys.BTN_QUICKMEAS;
        oData(16) <= iSFRControl.Keys.BTN_ACQUIRE;
        oData(17) <= iSFRControl.Keys.BTN_DISPLAY;
        oData(18) <= iSFRControl.Keys.BTN_EDGE;
        oData(19) <= iSFRControl.Keys.BTN_MODECOUPLING;
        oData(20) <= iSFRControl.Keys.BTN_AUTOSCALE;
        oData(21) <= iSFRControl.Keys.BTN_SAVERECALL;
        oData(22) <= iSFRControl.Keys.BTN_QUICKPRINT;
        oData(23) <= iSFRControl.Keys.BTN_UTILITY;
        oData(24) <= iSFRControl.Keys.BTN_PULSEWIDTH;
        oData(26) <= iSFRControl.Keys.BTN_X1;
        oData(27) <= iSFRControl.Keys.BTN_X2;
        oData(28) <= iSFRControl.Keys.ENX_TIME_DIV;
        oData(29) <= iSFRControl.Keys.ENY_TIME_DIV;
        oData(30) <= iSFRControl.Keys.ENX_F;
        oData(31) <= iSFRControl.Keys.ENY_F;
      when cKeyAddr1 =>
        oData(0)  <= iSFRControl.Keys.ENX_LEFT_RIGHT;
        oData(1)  <= iSFRControl.Keys.ENY_LEFT_RIGHT;
        oData(2)  <= iSFRControl.Keys.ENX_LEVEL;
        oData(3)  <= iSFRControl.Keys.ENY_LEVEL;
        oData(4)  <= iSFRControl.Keys.ENX_CH0_UPDN;
        oData(5)  <= iSFRControl.Keys.ENY_CH0_UPDN;
        oData(6)  <= iSFRControl.Keys.ENX_CH1_UPDN;
        oData(7)  <= iSFRControl.Keys.ENY_CH1_UPDN;
        oData(8)  <= iSFRControl.Keys.ENX_CH2_UPDN;
        oData(9)  <= iSFRControl.Keys.ENY_CH2_UPDN;
        oData(10) <= iSFRControl.Keys.ENX_CH3_UPDN;
        oData(11) <= iSFRControl.Keys.ENY_CH3_UPDN;
        oData(12) <= iSFRControl.Keys.ENX_CH0_VDIV;
        oData(13) <= iSFRControl.Keys.ENY_CH0_VDIV;
        oData(14) <= iSFRControl.Keys.ENX_CH1_VDIV;
        oData(15) <= iSFRControl.Keys.ENY_CH1_VDIV;
        oData(16) <= iSFRControl.Keys.ENX_CH2_VDIV;
        oData(17) <= iSFRControl.Keys.ENY_CH2_VDIV;
        oData(18) <= iSFRControl.Keys.ENX_CH3_VDIV;
        oData(19) <= iSFRControl.Keys.ENY_CH3_VDIV;

      when cAnalogSettingsPWMAddr =>
        oData(AnalogSettings.PWM_Offset'range) <= AnalogSettings.PWM_Offset;
        
      when cAnalogSettingsBank7 =>
        oData(0)  <= AnalogSettings.CH0_K1_ON;
        oData(1)  <= AnalogSettings.CH0_K1_OFF;
        oData(2)  <= AnalogSettings.CH0_K2_ON;
        oData(3)  <= AnalogSettings.CH0_K2_OFF;
        oData(4)  <= AnalogSettings.CH0_OPA656;
        oData(5)  <= AnalogSettings.CH0_BW_Limit;
        oData(6)  <= AnalogSettings.CH0_U14;
        oData(7)  <= AnalogSettings.CH0_U13;
        oData(8)  <= AnalogSettings.CH0_DC;
        oData(9)  <= AnalogSettings.CH1_DC;
        oData(10) <= AnalogSettings.CH2_DC;
        oData(11) <= AnalogSettings.CH3_DC;
        oData(31) <= iSFRControl.AnalogBusy;
      when cAnalogSettingsBank5 =>
        oData(0)            <= AnalogSettings.CH1_K1_ON;
        oData(1)            <= AnalogSettings.CH1_K1_OFF;
        oData(2)            <= AnalogSettings.CH1_K2_ON;
        oData(3)            <= AnalogSettings.CH1_K2_OFF;
        oData(4)            <= AnalogSettings.CH1_OPA656;
        oData(5)            <= AnalogSettings.CH1_BW_Limit;
        oData(6)            <= AnalogSettings.CH1_U14;
        oData(7)            <= AnalogSettings.CH1_U13;
        oData(9 downto 8)   <= AnalogSettings.CH0_src2_addr;
        oData(11 downto 10) <= AnalogSettings.CH1_src2_addr;
        oData(13 downto 12) <= AnalogSettings.CH2_src2_addr;
        oData(15 downto 14) <= AnalogSettings.CH3_src2_addr;
        oData(31)           <= iSFRControl.AnalogBusy;
      when cAnalogSettingsBank6 =>
        oData(15 downto 0) <= AnalogSettings.DAC_Offset;
        oData(16)          <= AnalogSettings.DAC_Ch;
        oData(31)          <= iSFRControl.AnalogBusy;
      when others =>
        if Addr >= cLastAddr then
          oData <= (others => '-');
        end if;
    end case;
  end process;
  
end architecture;
