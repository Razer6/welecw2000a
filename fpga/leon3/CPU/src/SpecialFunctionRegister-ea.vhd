-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegister-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-11-18
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
    iClkCPU       : in  std_ulogic;
    iClkDesign    : in  std_ulogic;
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
  signal SFRIn                     : aSFR_in;
  signal InterruptMask             : std_ulogic_vector(4-1 downto 0);
  signal InterruptVector           : std_ulogic_vector(4-1 downto 0);
  signal PrevInt                   : std_ulogic_vector(4-1 downto 0);
  signal Decimator                 : aDownSampler;
  signal SignalSelector            : aSignalSelector;
  signal ExtTriggerSrc             : aExtTriggerInput;
  signal Trigger                   : aTriggerInput;
  signal Leds                      : aLeds;
  signal nConfigADC                : std_ulogic_vector(cChannels-1 downto 0);
  signal AnalogSettings            : aAnalogSettings;
  signal PrevTriggerBusy           : std_ulogic;
  signal PrevTriggerStartRecording : std_ulogic;
  signal PrevAnalogBusy            : std_ulogic;
  signal Addr                      : natural;
begin
  

  pInterrupt : process (iClkCPU, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      oCPUInterrupt             <= '0';
      InterruptVector           <= (others => '0');
      PrevTriggerBusy           <= '0';
      PrevTriggerStartRecording <= '0';
      PrevAnalogBusy            <= '0';
      PrevInt <= (others => '0');
    elsif rising_edge(iCLKCPU) then
   --   InterruptVector <= (others => '0');
      PrevInt <= InterruptVector;
      
      PrevTriggerBusy <= SFRIn.Trigger.Busy;
      if PrevTriggerBusy = '1' and SFRIn.Trigger.Busy = '0' then
        InterruptVector(0) <= '1';
      end if;
      
      PrevTriggerStartRecording <= SFRIn.Trigger.Recording;
      if PrevTriggerStartRecording = '0' and SFRIn.Trigger.Recording = '1' then
        InterruptVector(1) <= '1';
      end if;
      
      PrevAnalogBusy <= SFRIn.AnalogBusy;
      if SFRIn.AnalogBusy = '0' and PrevAnalogBusy = '1' then
        InterruptVector(2) <= '1';
      end if;
      
--      InterruptVector(2) <= SFRIn.KeyInterruptLH;
--      InterruptVector(3) <= SFRIn.KeyInterruptHL;
      --  InterruptVector(4) <= SFRIn.Uart.Interrupt;

      if Addr = cInterruptAddr then
        if iWr = '1' then
          InterruptVector <= iData(InterruptVector'range);
        end if;
      end if;

      if (InterruptVector and InterruptMask) /= X"0"
        and InterruptVector /= PrevInt then
        oCPUInterrupt <= '1';
      else
        oCPUInterrupt <= '0';
      end if;
    end if;
  end process;

--  pPipelineRegsOut : process (iClkDesign, iResetAsync)
--  begin
--    if rising_edge(iCLKDesign) then
  oSFRControl.Decimator      <= Decimator;
  oSFRControl.SignalSelector <= SignalSelector;
  oSFRControl.ExtTriggerSrc  <= ExtTriggerSrc;
  oSFRControl.Trigger        <= Trigger;
  oSFRControl.nConfigADC     <= nConfigADC;
  oSFRControl.AnalogSettings <= AnalogSettings;
--    end if;
--  end process;
  Addr                       <= to_integer(unsigned(iAddr(6 downto 2)));

  pWrite : process (iClkCPU, iResetAsync)
    variable vData : aDword;
  begin
    if iResetAsync = cResetActive then
      InterruptMask     <= (others => '0');
      Trigger.ForceIdle <= '1';
      Decimator <= (
        Stages       => (others => '0'),
        EnableFilter => (others => '0'),
        FilterDepth  => 0);
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
        when cSandboxX =>
          SignalSelector <= (
            0 => O"0",
            1 => O"4",
            2 => O"0",
            3 => O"4");
        when others =>
          SignalSelector <= (
            others => O"0");
      end case;

     ExtTriggerSrc <= (
        Addr   => 0,
        others => (others => (others => '0')));

--      Trigger <= (
--        TriggerOnce     => '0',
--        ForceIdle       => '0',
--        PreambleCounter => to_unsigned(32, aTriggerAddr'length),
--        Trigger         => 2,
--        TriggerChannel  => 0,
--        StorageMode     => "00",
--        -- Trigger mode specific:
--        LowValue        => std_ulogic_vector(to_signed(-16, Trigger.LowValue'length)),
--        HighValue       => std_ulogic_vector(to_signed(16, Trigger.HighValue'length)),
--        LowTime         => std_ulogic_vector(to_signed(50, Trigger.LowTime'length)),
--        HighTime        => std_ulogic_vector(to_signed(50, Trigger.HighTime'length)),
--        SetReadOffset   => '0',
--        ReadOffset      => (others => '0'));

      nConfigADC <= (others => cLowActive);

      AnalogSettings <= (
        Addr   => (others => '-'),
        Data   => (others => '-'),
        EnableKeyClock   => '1',  -- not implemented
        EnableProbeClock => '1',
        others => '0');

    elsif rising_edge(iClkCPU) then
      Trigger.TriggerOnce           <= '0';
      Trigger.ForceIdle             <= '0';
      Trigger.SetReadOffset         <= '0';
      AnalogSettings.Set            <= '0';
      AnalogSettings.Set_PWM_Offset <= '0';

      if iWr = '1' then
        case Addr is
  --        when cInterruptAddr =>
 --           InterruptForce <= iData(InterruptForce'range);
          when cInterruptMaskAddr =>
            InterruptMask <= iData(InterruptMask'range);
          when cSamplingFreqAddr =>
            Decimator.Stages <= iData(Decimator.Stages'range);
          when cFilterEnableAddr =>
            for i in Decimator.EnableFilter'range loop
              Decimator.EnableFilter(i) <= iData(i);
            end loop;
            Decimator.FilterDepth <= to_integer(unsigned(iData(31 downto 30)));
            
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
            Trigger.PreambleCounter <= unsigned(iData(Trigger.PreambleCounter'high+cTriggerAlign downto cTriggerAlign));
          when cTriggerStorageModeAddr =>
            Trigger.StorageMode <= iData(Trigger.StorageMode'range);
          when cTriggerReadOffSetAddr =>
            Trigger.SetReadOffset <= '1';
            Trigger.ReadOffset    <= unsigned(iData(Trigger.ReadOffset'high+2 downto 2));
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
            -- manual switch to the debug uart (if software fails)
            -- if SFRIn.Keys.BTN_F1 = '1' and SFRIn.Keys.BTN_F2 = '1' then
            --   nConfigADC(0) <= cLowActive;
            -- end if;

          when cAnalogSettingsAddr =>
            AnalogSettings.Set_PWM_Offset    <= iData(31);
            AnalogSettings.EnableKeyClock    <= iData(30);  -- not implemented
            AnalogSettings.EnableProbeClock  <= iData(29);  -- not implemented
            AnalogSettings.EnableProbeStrobe <= iData(28);  -- not implemented

            AnalogSettings.Set  <= iData(27);
            AnalogSettings.Addr <= iData(26 downto 24);
            AnalogSettings.Data <= iData(AnalogSettings.Data'range);

            -----------------------------------------------------------------
            -- addr = 7 , Set = 1
            -----------------------------------------------------------------
--            AnalogSettings.CH0_K1_ON    <= iData(0);
--            AnalogSettings.CH0_K1_OFF   <= iData(1);
--            AnalogSettings.CH0_K2_ON    <= iData(2);
--            AnalogSettings.CH0_K2_OFF   <= iData(3);
--            AnalogSettings.CH0_OPA656   <= iData(4);
--            AnalogSettings.CH0_BW_Limit <= iData(5);
--            AnalogSettings.CH0_U14      <= iData(6);
--            AnalogSettings.CH0_U13      <= iData(7);
--            AnalogSettings.CH0_DC       <= iData(8);
--            AnalogSettings.CH1_DC       <= iData(9);
--            AnalogSettings.CH2_DC       <= iData(10);
--            AnalogSettings.CH3_DC       <= iData(11);

            -----------------------------------------------------------------
            -- addr = 5 , Set = 1
            -----------------------------------------------------------------
--            AnalogSettings.CH1_K1_ON     <= iData(0);
--            AnalogSettings.CH1_K1_OFF    <= iData(1);
--            AnalogSettings.CH1_K2_ON     <= iData(2);
--            AnalogSettings.CH1_K2_OFF    <= iData(3);
--            AnalogSettings.CH1_OPA656    <= iData(4);
--            AnalogSettings.CH1_BW_Limit  <= iData(5);
--            AnalogSettings.CH1_U14       <= iData(6);
--            AnalogSettings.CH1_U13       <= iData(7);
--            AnalogSettings.CH0_src2_addr <= iData(9 downto 8);
--            AnalogSettings.CH1_src2_addr <= iData(11 downto 10);
--            AnalogSettings.CH2_src2_addr <= iData(13 downto 12);
--            AnalogSettings.CH3_src2_addr <= iData(15 downto 14);

            -----------------------------------------------------------------
            -- addr = 6 , Set = 1
            -----------------------------------------------------------------
            -- DAC LTC2612MS8
--            AnalogSettings.DAC_Offset <= iData(15 downto 0);
--            AnalogSettings.DAC_Ch     <= iData(16);
            -- MODE X2, Addr = Channel1 or Channel2
--            AnalogSettings.DAC_Control(23 downto 17) <= X"2" & O"0";
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;


  pPipelineRegsIn : process (iClkCPU, iResetAsync)
  begin
    if rising_edge(iCLKCPU) then
      SFRIn <= iSFRControl;
    end if;
  end process;
  
  pRead : process (Addr, SFRIn, InterruptVector,
                   InterruptMask, Decimator, nConfigADC,
                   SignalSelector, Trigger, Leds, ExtTriggerSrc, AnalogSettings)
  begin
    oData <= (others => '0');
    case Addr is
      when cDeviceAddr =>
        oData <= std_ulogic_vector(to_unsigned(cCurrentDevice, oData'length));
      when cInterruptAddr =>
        oData(InterruptVector'range) <= InterruptVector;
      when cInterruptMaskAddr =>
        oData(InterruptMask'range) <= InterruptMask;
      when cSamplingFreqAddr =>
        oData(Decimator.Stages'range) <= Decimator.Stages;
      when cFilterEnableAddr =>
        for i in Decimator.EnableFilter'range loop
          oData(i) <= Decimator.EnableFilter(i);
        end loop;
        oData(31 downto 30) <= std_ulogic_vector(to_unsigned(Decimator.FilterDepth, 2));
      when cExtTriggerSrcAddr =>
        oData <= std_ulogic_vector(to_unsigned(ExtTriggerSrc.Addr, 32));
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
        oData(Trigger.PreambleCounter'high+cTriggerAlign downto cTriggerAlign) <= std_ulogic_vector(Trigger.PreambleCounter);
      when cTriggerStorageModeAddr =>
        oData(Trigger.StorageMode'range) <= Trigger.StorageMode;
      when cTriggerReadOffSetAddr =>
        oData(SFRIn.Trigger.ReadOffSet'high+2 downto 2) <= std_ulogic_vector(SFRIn.Trigger.ReadOffSet);
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
        oData(0) <= SFRIn.Trigger.Busy;
        oData(1) <= SFRIn.Trigger.Recording;
      when cTriggerCurrentAddr =>
        oData(SFRIn.Trigger.CurrentTriggerAddr'high+2 downto 2) <=
          std_ulogic_vector(SFRIn.Trigger.CurrentTriggerAddr);
      when cConfigADCEnable =>
        oData(nConfigADC'range) <= nConfigADC;

      when cAnalogSettingsAddr =>
        oData(30)                        <= AnalogSettings.EnableKeyClock;  -- not implemented
        oData(28)                        <= AnalogSettings.EnableProbeClock;  -- not implemented
        oData(28)                        <= AnalogSettings.EnableProbeStrobe;  -- not implemented
        oData(27)                        <= SFRIn.AnalogBusy;
        oData(26 downto 24)              <= AnalogSettings.Addr;
        oData(AnalogSettings.Data'range) <= AnalogSettings.Data;
      when others =>
        --      if Addr >= cLastAddr then
        oData <= (others => '-');
        --      end if;
    end case;
  end process;
  
end architecture;
