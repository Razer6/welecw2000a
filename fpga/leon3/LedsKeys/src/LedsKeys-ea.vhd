-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeysAnalogSettings-ea.vhd
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
use DSO.pLedsKeysAnalogSettings.all;

entity LedsKeysAnalogSettings is
  port (
    iClk            : in  std_ulogic;
    iResetAsync     : in  std_ulogic;
    iLeds           : in  aLeds;
    oLeds           : out aShiftOut;
    iKeysData       : in  std_ulogic;
    onFetchKeys     : out aShiftIn;
    oKeys           : out aKeys;
    iCPUtoAnalog    : in  aAnalogSettings;
    oAnalogBusy     : out std_ulogic;
    oAnalogSettings : out aAnalogSettingsOut;
    oSerialClk      : out std_ulogic);
end entity;

architecture RTL of LedsKeysAnalogSettings is
  
  constant cKeyShiftLength : natural := 56;
  constant cLedShiftLength : natural := 16;

  signal Strobe, SerialClk : std_ulogic;

  type aLedState is record
                      ShiftReg : std_ulogic_vector(cLedShiftLength-1 downto 0);
                      Counter  : natural range 0 to cLedShiftLength+1;
                      Strobe   : std_ulogic;
                      Clock    : std_ulogic_vector(1 to 5);
                      Busy     : std_ulogic;
                    end record;
  signal LedState : aLedState;

  type aKeyFSM is (IDLE, Fetchstrobe, Reading);
  type aKeyState is record
                      State    : aKeyFSM;
                      ShiftReg : std_ulogic_vector(cKeyShiftLength-1 downto 0);
                      D0Reg    : std_ulogic_vector(cKeyShiftLength-1 downto 0);
                      D1Reg    : std_ulogic_vector(cKeyShiftLength-1 downto 0);
                      Reg      : std_ulogic_vector(cKeyShiftLength-1 downto 0);
                      Counter  : natural range 0 to cKeyShiftLength;
                      Strobe   : std_ulogic;
                    end record;
  signal KeyState : aKeystate;

  type aAnalogState is record
                         Busy       : std_ulogic;
                         Clock      : std_ulogic;
                         SetCounter : std_ulogic;
                         Counter    : natural range 0 to cAnalogShiftLength+1;
                         Addr       : std_ulogic_vector(cAnalogAddrLength-1 downto 0);
                         ShiftReg   : std_ulogic_vector(cAnalogShiftLength downto 0);
                         Enable     : std_ulogic;
                       end record;
  
  
  signal AnalogSettings : aAnalogState;

  signal PWM_Offset : aByte;
  
  
  
begin

  Strobe2KHz : entity DSO.StrobeGen
    generic map (
      gClkFrequency    => cCPUClkRate,
      gStrobeFrequency => cAnSettStrobeRate)  --cCPUCLKRate/4) 
    --    gStrobeFrequency => 2000)        -- 54 ms for one key reading
    -- avoids unstable key values
    -- 1 KHz probe output
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iResetSync  => '0',
      oStrobe     => Strobe);

  oSerialClk <= SerialClk;
  
  
  oLeds <= (
    SerialClk     => LedState.Clock(LedState.Clock'high),
    nResetSync    => cHighInActive,
    nOutputEnable => cLowActive,
    Data          => LedState.ShiftReg(LedState.ShiftReg'high),
    ValidStrobe   => LedState.Strobe);

  pLeds : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      SerialClk         <= '0';
      LedState.ShiftReg <= (others => '0');
      LedState.Counter  <= 0;
      LedState.Strobe   <= '0';
      LedState.Busy     <= '1';
      LedState.Clock    <= (others => '0');
--      oLeds <= (
--        nResetSync    => cLowActive,
--        nOutputEnable => cHighInactive,
--        others        => '0');      
    elsif rising_edge(iClk) then
      if iLeds.SetLeds = '1' and LedState.Busy = '0' then
        LedState.ShiftReg <= (
          15     => not iLeds.LED_CH3,
          14     => not iLeds.LED_CH0,
          13     => not iLeds.LED_MATH,
          12     => not iLeds.LED_CH1,
          11     => not iLeds.LED_QUICKMEAS,
          10     => not iLeds.LED_CURSORS,
          9      => not iLeds.LED_WHEEL,
          8      => not iLeds.LED_CH2,
          7      => not iLeds.LED_PULSEWIDTH,
          6      => not iLeds.LED_EDGE,
          5      => not iLeds.RUN_GREEN,
          4      => not iLeds.RUN_RED,
          3      => not iLeds.SINGLE_RED,
          2      => not iLeds.SINGLE_GREEN,
          others => '1');
        LedState.Busy     <= '1';
        LedState.Clock(1) <= '0';
      end if;

      if Strobe = '1' then
        SerialClk <= not SerialClk;
        if LedState.Busy = '1' then
          LedState.Clock(1)                        <= not LedState.Clock(1);
          LedState.Clock(2 to LedState.Clock'high) <= LedState.Clock(1 to LedState.Clock'high-1);
          if LedState.Clock(LedState.Clock'high) = '1' then
            if LedState.Counter = cLedShiftLength then
              LedState.Counter <= 0;
              LedState.Busy    <= '0';
            else
              LedState.Counter <= (LedState.Counter +1);
            end if;
            LedState.ShiftReg(LedState.ShiftReg'high downto LedState.ShiftReg'low+1) <=
              LedState.ShiftReg(LedState.ShiftReg'high-1 downto LedState.ShiftReg'low);
            --oLeds.Data                    <= LedShiftReg(LedShiftReg'right);
            LedState.ShiftReg(LedState.ShiftReg'low) <= '-';
            LedState.Strobe                          <= '0';

            if LedState.Counter = cLedShiftLength-1 then
              LedState.Strobe <= '1';
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

--  oKeys <= Keys;
  pKeys : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      KeyState.ShiftReg <= (others => '1');
      KeyState.Counter  <= 3;
      KeyState.State    <= FetchStrobe;
      onFetchKeys <= (
        SerialClk    => '0',
        nFetchStrobe => cHighInactive,
        nChipEnable  => cHighInactive);

    elsif rising_edge(iClk) then
      onFetchKeys.nChipEnable  <= cLowActive;
      onFetchKeys.nFetchStrobe <= cHighInactive;
      KeyState.Strobe          <= '0';
      onFetchKeys.SerialClk <= '0';

      case KeyState.State is
        when Idle =>
          if Strobe = '1' and SerialClk = '1'  then
            if iCPUtoAnalog.EnableKeyClock = '1' then
              KeyState.State   <= Reading;
              KeyState.Counter <= 3;
            end if;
          end if;
        when FetchStrobe =>
          onFetchKeys.SerialClk <= SerialClk;
          onFetchKeys.nFetchStrobe <= cLowActive;
          
--          if KeyState.Counter = 0 then
--            onFetchKeys.nFetchStrobe <= cHighInactive;
--          end if;
          
          if Strobe = '1' and SerialClk = '1' then
            if KeyState.Counter = 0 then
              KeyState.Counter <= cKeyShiftLength-1;
              KeyState.State   <= Reading;
            else
              KeyState.Counter <= KeyState.Counter -1;
              
            end if;
          end if;
          
        when Reading =>
          onFetchKeys.SerialClk <= SerialClk;
          if Strobe = '1' and SerialClk = '1' then
            if KeyState.Counter = 0 then
              
              KeyState.Counter <= 3;
              if iCPUtoAnalog.EnableKeyClock = '1' then
                KeyState.State <= FetchStrobe;
              else
                KeyState.State <= Idle;
              end if;

              KeyState.Strobe <= '1';
              KeyState.D0Reg  <= KeyState.ShiftReg;
              KeyState.D1Reg  <= KeyState.D0Reg;

              for i in KeyState.Reg'range loop
                if KeyState.ShiftReg(i) = KeyState.D0Reg(i) and KeyState.D0Reg(i) = KeyState.D1Reg(i) then
                  KeyState.Reg(i) <= KeyState.D1Reg(i);
                end if;
              end loop;
              
            else
              KeyState.Counter                           <= KeyState.Counter -1;
              KeyState.ShiftReg(KeyState.ShiftReg'right) <= iKeysData;

              KeyState.ShiftReg(KeyState.ShiftReg'left downto KeyState.ShiftReg'right+1) <=
                KeyState.ShiftReg(KeyState.ShiftReg'left-1 downto KeyState.ShiftReg'right);
            end if;
          end if;
      end case;
    end if;
  end process;
--   oKeys.BTN_F1           <= KeyState.Reg(19);
--    oKeys.BTN_F2           <= KeyState.Reg(20);
--    oKeys.BTN_F3           <= KeyState.Reg(21);
--    oKeys.BTN_F4           <= KeyState.Reg(22);
--    oKeys.BTN_F5           <= KeyState.Reg(16);
--    oKeys.BTN_F6           <= KeyState.Reg(18);
--    oKeys.BTN_MATH         <= KeyState.Reg(0);
--    oKeys.BTN_CH0          <= KeyState.Reg(17);
--    oKeys.BTN_CH1          <= KeyState.Reg(15);
--    oKeys.BTN_CH2          <= KeyState.Reg(4);
--    oKeys.BTN_CH3          <= KeyState.Reg(6);
--    oKeys.BTN_MAINDEL      <= KeyState.Reg(39);
--    oKeys.BTN_RUNSTOP      <= KeyState.Reg(44);
--    oKeys.BTN_SINGLE       <= KeyState.Reg(43);
--    oKeys.BTN_CURSORS      <= KeyState.Reg(32);
--    oKeys.BTN_QUICKMEAS    <= KeyState.Reg(37);
--    oKeys.BTN_ACQUIRE      <= KeyState.Reg(36);
--    oKeys.BTN_DISPLAY      <= KeyState.Reg(34);
--    oKeys.BTN_EDGE         <= KeyState.Reg(42);
--    oKeys.BTN_MODECOUPLING <= KeyState.Reg(40);
--    oKeys.BTN_AUTOSCALE    <= KeyState.Reg(31);
--    oKeys.BTN_SAVERECALL   <= KeyState.Reg(38);
--    oKeys.BTN_QUICKPRINT   <= KeyState.Reg(35);
--    oKeys.BTN_UTILITY      <= KeyState.Reg(33);
--    oKeys.BTN_PULSEWIDTH   <= KeyState.Reg(46);
--    oKeys.BTN_X1           <= KeyState.Reg(41);
--    oKeys.BTN_X2           <= KeyState.Reg(45);

  process(KeyState.Reg)
  begin
    oKeys.BTN_F1           <= KeyState.Reg(20);
    oKeys.BTN_F2           <= KeyState.Reg(21);
    oKeys.BTN_F3           <= KeyState.Reg(22);
    oKeys.BTN_F4           <= KeyState.Reg(23);
    oKeys.BTN_F5           <= KeyState.Reg(17);
    oKeys.BTN_F6           <= KeyState.Reg(19);
    oKeys.BTN_MATH         <= KeyState.Reg(1);
    oKeys.BTN_CH0          <= KeyState.Reg(18);
    oKeys.BTN_CH1          <= KeyState.Reg(16);
    oKeys.BTN_CH2          <= KeyState.Reg(3);
    oKeys.BTN_CH3          <= KeyState.Reg(0);
    oKeys.BTN_MAINDEL      <= KeyState.Reg(40);
    oKeys.BTN_RUNSTOP      <= KeyState.Reg(45);
    oKeys.BTN_SINGLE       <= KeyState.Reg(44);
    oKeys.BTN_CURSORS      <= KeyState.Reg(33);
    oKeys.BTN_QUICKMEAS    <= KeyState.Reg(38);
    oKeys.BTN_ACQUIRE      <= KeyState.Reg(37);
    oKeys.BTN_DISPLAY      <= KeyState.Reg(35);
    oKeys.BTN_EDGE         <= KeyState.Reg(43);
    oKeys.BTN_MODECOUPLING <= KeyState.Reg(41);
    oKeys.BTN_AUTOSCALE    <= KeyState.Reg(32);
    oKeys.BTN_SAVERECALL   <= KeyState.Reg(39);
    oKeys.BTN_QUICKPRINT   <= KeyState.Reg(37);
    oKeys.BTN_UTILITY      <= KeyState.Reg(34);
    oKeys.BTN_PULSEWIDTH   <= KeyState.Reg(47);
    oKeys.BTN_X1           <= KeyState.Reg(42);
    oKeys.BTN_X2           <= KeyState.Reg(46);
  end process;
  
--            ENX_TIME_DIV     => KeyState.Reg(48),   -- dont care start
--            ENY_TIME_DIV     => KeyState.Reg(47),
--            ENX_F            => KeyState.Reg(50),
--            ENY_F            => KeyState.Reg(49),
--            ENX_LEFT_RIGHT   => KeyState.Reg(54),
--            ENY_LEFT_RIGHT   => KeyState.Reg(53),
--            ENX_LEVEL        => KeyState.Reg(52),
--            ENY_LEVEL        => KeyState.Reg(51),
--            ENX_CH0_UPDN     => KeyState.Reg(24),
--            ENY_CH0_UPDN     => KeyState.Reg(23),
--            ENX_CH1_UPDN     => KeyState.Reg(30),
--            ENY_CH1_UPDN     => KeyState.Reg(29),
--            ENX_CH2_UPDN     => KeyState.Reg(8),
--            ENY_CH2_UPDN     => KeyState.Reg(7),
--            ENX_CH3_UPDN     => KeyState.Reg(14),
--            ENY_CH3_UPDN     => KeyState.Reg(13),
--            ENX_CH0_VDIV     => KeyState.Reg(26),
--            ENY_CH0_VDIV     => KeyState.Reg(25),
--            ENX_CH1_VDIV     => KeyState.Reg(28),
--            ENY_CH1_VDIV     => KeyState.Reg(27),
--            ENX_CH2_VDIV     => KeyState.Reg(10),
--            ENY_CH2_VDIV     => KeyState.Reg(9),
--            ENX_CH3_VDIV     => KeyState.Reg(12),
--            ENY_CH3_VDIV     => KeyState.Reg(11));  -- dont care end
  CH3_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(13),
      iUnstable   => KeyState.Reg(12),
      oCounter    => oKeys.EN_CH3_VDIV);

  CH2_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(11),
      iUnstable   => KeyState.Reg(10),
      oCounter    => oKeys.EN_CH2_VDIV);

  CH1_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(29),
      iUnstable   => KeyState.Reg(28),
      oCounter    => oKeys.EN_CH1_VDIV);

  CH0_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(27),
      iUnstable   => KeyState.Reg(26),
      oCounter    => oKeys.EN_CH0_VDIV);

  CH3_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(15),
      iUnstable   => KeyState.Reg(14),
      oCounter    => oKeys.EN_CH3_UPDN);

  CH2_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(8),
      iUnstable   => KeyState.Reg(9),
      oCounter    => oKeys.EN_CH2_UPDN);

  CH1_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(30),
      iUnstable   => KeyState.Reg(31),
      oCounter    => oKeys.EN_CH1_UPDN);

  CH0_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(24),
      iUnstable   => KeyState.Reg(25),
      oCounter    => oKeys.EN_CH0_UPDN);

  LEVEL : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(53),
      iUnstable   => KeyState.Reg(52),
      oCounter    => oKeys.EN_LEVEL);

  LEFT_RIGHT : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(55),
      iUnstable   => KeyState.Reg(54),
      oCounter    => oKeys.EN_LEFT_RIGHT);

  F : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(51),
      iUnstable   => KeyState.Reg(50),
      oCounter    => oKeys.EN_F);

  TIME_DIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyState.Strobe,
      iStable     => KeyState.Reg(49),
      iUnstable   => KeyState.Reg(48),
      oCounter    => oKeys.EN_TIME_DIV);

  pAnalogSettings : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      AnalogSettings <= (
        --       SerialClk  => '0',
        SetCounter => '0',
        Counter    => 0,
        ShiftReg   => (others => '-'),
        Addr       => (others => '-'),
        Enable     => '0',
        Clock      => '0',
        Busy       => '0');
      oAnalogBusy <= '0';
      PWM_Offset  <= (others => '0');
    elsif rising_edge(iClk) then
      if iCPUtoAnalog.Set_PWM_Offset = '1' then
        PWM_Offset <= iCPUtoAnalog.Data(PWM_Offset'range);
      end if;
      if iCPUtoAnalog.Set = '1' and AnalogSettings.Busy = '0' then
        oAnalogBusy                          <= '1';
        AnalogSettings.Counter               <= cAnalogShiftLength+1;
        AnalogSettings.Addr                  <= iCPUtoAnalog.Addr;
        AnalogSettings.ShiftReg(23 downto 0) <= iCPUtoAnalog.Data;
        AnalogSettings.Busy                  <= '1';
        if iCPUtoAnalog.Addr = O"6" then
          AnalogSettings.Enable <= '1';
        end if;
      end if;
      if AnalogSettings.Busy = '1' then
        AnalogSettings.Clock <= SerialClk;
      else
        AnalogSettings.Enable <= '0';
      end if;

      if Strobe = '1' and AnalogSettings.Clock = '0' and AnalogSettings.Busy = '1' then
        if (iCPUtoAnalog.Addr = O"6" and AnalogSettings.Counter /= 1 and AnalogSettings.Counter /= 0) or
          (iCPUtoAnalog.Addr /= O"6" and AnalogSettings.Counter = 1) then
          AnalogSettings.Enable <= '1';
        else
          AnalogSettings.Enable <= '0';
        end if;

        if AnalogSettings.Counter = 0 then
          oAnalogBusy         <= '0';
          AnalogSettings.Busy <= '0';
          --      AnalogSettings.Enable <= '0';
        else
          -- The DAC needs an enable signal! 
          AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high downto 1) <=
            AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high-1 downto 0);
          AnalogSettings.ShiftReg(0) <= '-';
          AnalogSettings.Counter     <= AnalogSettings.Counter -1;
        end if;
      end if;
    end if;
  end process;

  oAnalogSettings.Addr      <= not AnalogSettings.Addr;
  oAnalogSettings.Enable    <= not AnalogSettings.Enable;
  oAnalogSettings.Data      <= not AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high);
  oAnalogSettings.SerialClk <= AnalogSettings.Clock;

  pPWM : entity DSO.PWM
    generic map (
      gBitWidth => PWM_Offset'length)
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iRefON      => PWM_Offset,
      iRefOff     => (others => '0'),
      oPWM        => oAnalogSettings.PWM);


end architecture;
