-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeysAnalogSettings-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-10-27
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
  
  constant cKeyShiftLength : natural := 54;
  constant cLedShiftLength : natural := 16;

  signal Strobe, SerialClk : std_ulogic;
  signal LedShiftReg       : std_ulogic_vector(cLedShiftLength-1 downto 0);
  signal LedCounter        : natural range 0 to cLedShiftLength;
  signal LedStrobe         : std_ulogic;
  signal KeyShiftReg       : std_ulogic_vector(cKeyShiftLength downto 0);
  signal KeyCounter        : natural range 0 to cKeyShiftLength;
  signal KeyStrobe         : std_ulogic;


  type aAnalogState is record
                         SetCounter : std_ulogic;
                         Counter    : natural range 0 to cAnalogShiftLength+1;
                         Addr       : std_ulogic_vector(cAnalogAddrLength-1 downto 0);
                         ShiftReg   : std_ulogic_vector(cAnalogShiftLength-1 downto 0);
                         Enable     : std_ulogic;
                       end record;
  
  
  signal AnalogSettings : aAnalogState;
  
  
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
    nResetSync    => cHighInActive,
    nOutputEnable => cLowActive,
    Data          => LedShiftReg(LedShiftReg'high),
    ValidStrobe   => LedStrobe);

  pLeds : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      SerialClk   <= '0';
      LedShiftReg <= (others => '0');
      LedCounter  <= 0;
      LedStrobe   <= '0';
--      oLeds <= (
--        nResetSync    => cLowActive,
--        nOutputEnable => cHighInactive,
--        others        => '0');      
    elsif rising_edge(iClk) then
      if Strobe = '1' then
        SerialClk <= not SerialClk;
        if SerialClk = '0' then
          if LedCounter = cLedShiftLength then
            LedCounter <= 0;
          else
            LedCounter <= (LedCounter +1);
          end if;
          LedShiftReg(LedShiftReg'high downto LedShiftReg'low+1) <=
            LedShiftReg(LedShiftReg'high-1 downto LedShiftReg'low);
          --oLeds.Data                    <= LedShiftReg(LedShiftReg'right);
          LedShiftReg(LedShiftReg'low) <= '-';
          LedStrobe                    <= '0';

          if LedCounter = 0 then
            LedShiftReg <= (
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
            LedStrobe <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

--  oKeys <= Keys;
  pKeys : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      KeyShiftReg <= (others => '1');
      KeyCounter  <= 0;
      onFetchKeys <= (
        nFetchStrobe => cHighInactive,
        nChipEnable  => cHighInactive);
--      oKeys <= (
--        EN_TIME_DIV   => "00",
--        EN_F          => "00",
--        EN_LEFT_RIGHT => "00",
--        EN_LEVEL      => "00",
--        EN_CH0_UPDN   => "00",
--        EN_CH1_UPDN   => "00",
--        EN_CH2_UPDN   => "00",
--        EN_CH3_UPDN   => "00",
--        EN_CH0_VDIV   => "00",
--        EN_CH1_VDIV   => "00",
--        EN_CH2_VDIV   => "00",
--        EN_CH3_VDIV   => "00",
--        others        => '0');
      --  KeyStable <= (others => '0');

    elsif rising_edge(iClk) then
      onFetchKeys.nChipEnable <= cLowActive;

      if Strobe = '1' and SerialClk = '1' then
        onFetchKeys.nFetchStrobe <= cHighInactive;
        if KeyCounter = cKeyShiftLength then
          KeyCounter <= 0;
        else
          KeyCounter <= KeyCounter +1;
        end if;
        KeyShiftReg(KeyShiftReg'right)                           <= iKeysData;
        KeyShiftReg(KeyShiftReg'left downto KeyShiftReg'right+1) <=
          KeyShiftReg(KeyShiftReg'left-1 downto KeyShiftReg'right);
        
        if KeyCounter = cKeyShiftLength then
          onFetchKeys.nFetchStrobe <= cLowActive;
        end if;

        if KeyCounter = 0 then

          oKeys.BTN_F1           <= KeyShiftReg(19);
          oKeys.BTN_F2           <= KeyShiftReg(20);
          oKeys.BTN_F3           <= KeyShiftReg(21);
          oKeys.BTN_F4           <= KeyShiftReg(22);
          oKeys.BTN_F5           <= KeyShiftReg(16);
          oKeys.BTN_F6           <= KeyShiftReg(18);
          oKeys.BTN_MATH         <= KeyShiftReg(0);
          oKeys.BTN_CH0          <= KeyShiftReg(17);
          oKeys.BTN_CH1          <= KeyShiftReg(15);
          oKeys.BTN_CH2          <= KeyShiftReg(4);
          oKeys.BTN_CH3          <= KeyShiftReg(6);
          oKeys.BTN_MAINDEL      <= KeyShiftReg(39);
          oKeys.BTN_RUNSTOP      <= KeyShiftReg(44);
          oKeys.BTN_SINGLE       <= KeyShiftReg(43);
          oKeys.BTN_CURSORS      <= KeyShiftReg(32);
          oKeys.BTN_QUICKMEAS    <= KeyShiftReg(37);
          oKeys.BTN_ACQUIRE      <= KeyShiftReg(36);
          oKeys.BTN_DISPLAY      <= KeyShiftReg(34);
          oKeys.BTN_EDGE         <= KeyShiftReg(42);
          oKeys.BTN_MODECOUPLING <= KeyShiftReg(40);
          oKeys.BTN_AUTOSCALE    <= KeyShiftReg(31);
          oKeys.BTN_SAVERECALL   <= KeyShiftReg(38);
          oKeys.BTN_QUICKPRINT   <= KeyShiftReg(35);
          oKeys.BTN_UTILITY      <= KeyShiftReg(33);
          oKeys.BTN_PULSEWIDTH   <= KeyShiftReg(46);
          oKeys.BTN_X1           <= KeyShiftReg(41);
          oKeys.BTN_X2           <= KeyShiftReg(45);
--            ENX_TIME_DIV     => KeyShiftReg(48),   -- dont care start
--            ENY_TIME_DIV     => KeyShiftReg(47),
--            ENX_F            => KeyShiftReg(50),
--            ENY_F            => KeyShiftReg(49),
--            ENX_LEFT_RIGHT   => KeyShiftReg(54),
--            ENY_LEFT_RIGHT   => KeyShiftReg(53),
--            ENX_LEVEL        => KeyShiftReg(52),
--            ENY_LEVEL        => KeyShiftReg(51),
--            ENX_CH0_UPDN     => KeyShiftReg(24),
--            ENY_CH0_UPDN     => KeyShiftReg(23),
--            ENX_CH1_UPDN     => KeyShiftReg(30),
--            ENY_CH1_UPDN     => KeyShiftReg(29),
--            ENX_CH2_UPDN     => KeyShiftReg(8),
--            ENY_CH2_UPDN     => KeyShiftReg(7),
--            ENX_CH3_UPDN     => KeyShiftReg(14),
--            ENY_CH3_UPDN     => KeyShiftReg(13),
--            ENX_CH0_VDIV     => KeyShiftReg(26),
--            ENY_CH0_VDIV     => KeyShiftReg(25),
--            ENX_CH1_VDIV     => KeyShiftReg(28),
--            ENY_CH1_VDIV     => KeyShiftReg(27),
--            ENX_CH2_VDIV     => KeyShiftReg(10),
--            ENY_CH2_VDIV     => KeyShiftReg(9),
--            ENX_CH3_VDIV     => KeyShiftReg(12),
--            ENY_CH3_VDIV     => KeyShiftReg(11));  -- dont care end

        end if;
      end if;
    end if;
  end process;

  KeyStrobe <= '1' when KeyCounter = 0 and Strobe = '1' and SerialClk = '1' else '0';

  CH3_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(12),
      iUnstable   => KeyShiftReg(11),
      oCounter    => oKeys.EN_CH3_VDIV);

  CH2_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(10),
      iUnstable   => KeyShiftReg(9),
      oCounter    => oKeys.EN_CH2_VDIV);

  CH1_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(28),
      iUnstable   => KeyShiftReg(27),
      oCounter    => oKeys.EN_CH1_VDIV);

  CH0_VDIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(26),
      iUnstable   => KeyShiftReg(25),
      oCounter    => oKeys.EN_CH0_VDIV);

  CH3_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(13),
      iUnstable   => KeyShiftReg(14),
      oCounter    => oKeys.EN_CH3_UPDN);

  CH2_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(7),
      iUnstable   => KeyShiftReg(8),
      oCounter    => oKeys.EN_CH2_UPDN);

  CH1_UPDN : entity DSO.NobDecoder
   generic map (gReverseDir => 1) 
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(29),
      iUnstable   => KeyShiftReg(30),
      oCounter    => oKeys.EN_CH1_UPDN);

  CH0_UPDN : entity DSO.NobDecoder
    generic map (gReverseDir => 1)
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(23),
      iUnstable   => KeyShiftReg(24),
      oCounter    => oKeys.EN_CH0_UPDN);

  LEVEL : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(52),
      iUnstable   => KeyShiftReg(51),
      oCounter    => oKeys.EN_LEVEL);

  LEFT_RIGHT : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(54),
      iUnstable   => KeyShiftReg(53),
      oCounter    => oKeys.EN_LEFT_RIGHT);

  F : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(50),
      iUnstable   => KeyShiftReg(49),
      oCounter    => oKeys.EN_F);

  TIME_DIV : entity DSO.NobDecoder
    port map(
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iStrobe     => KeyStrobe,
      iStable     => KeyShiftReg(48),
      iUnstable   => KeyShiftReg(47),
      oCounter    => oKeys.EN_TIME_DIV);

  pAnalogSettings : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      AnalogSettings <= (
        SetCounter => '0',
        Counter    => 0,
        ShiftReg   => (others => '-'),
        Addr       => (others => '0'),
        Enable     => '0');
      oAnalogBusy <= '0';
    elsif rising_edge(iClk) then
      if iCPUtoAnalog.Set = '1' then
        oAnalogBusy               <= '1';
        AnalogSettings.SetCounter <= '1';
--        AnalogSettings.Counter <= cAnalogShiftLength;
        AnalogSettings.Addr       <= iCPUtoAnalog.Addr;
        case iCPUtoAnalog.Addr is
          when O"0" => AnalogSettings.ShiftReg <= (others => '-');
          when O"1" => AnalogSettings.ShiftReg <= (others => '-');
          when O"2" => AnalogSettings.ShiftReg <= (others => '-');
          when O"3" => AnalogSettings.ShiftReg <= (others => '-');
          when O"4" => AnalogSettings.ShiftReg <= (others => '-');
          when O"5" =>
            AnalogSettings.ShiftReg <= (
              0      => not iCPUtoAnalog.CH1_K1_ON,
              1      => not iCPUtoAnalog.CH1_K1_OFF,
              2      => not iCPUtoAnalog.CH1_K2_ON,
              3      => not iCPUtoAnalog.CH1_K2_OFF,
              4      => iCPUtoAnalog.CH1_OPA656,
              5      => iCPUtoAnalog.CH1_BW_Limit,
              6      => iCPUtoAnalog.CH1_U14,
              7      => iCPUtoAnalog.CH1_U13,
              8      => iCPUtoAnalog.CH0_src2_addr(0),
              9      => iCPUtoAnalog.CH0_src2_addr(1),
              10     => iCPUtoAnalog.CH1_src2_addr(0),
              11     => iCPUtoAnalog.CH1_src2_addr(1),
              12     => iCPUtoAnalog.CH2_src2_addr(0),
              13     => iCPUtoAnalog.CH2_src2_addr(1),
              14     => iCPUtoAnalog.CH3_src2_addr(0),
              15     => iCPUtoAnalog.CH3_src2_addr(1),
              others => '-');
          when O"6" =>
            -- DAC LTC2612MS8
            for i in 0 to 15 loop
              AnalogSettings.ShiftReg(i) <= iCPUtoAnalog.DAC_Offset(i);
            end loop;
            -- MODE X2, Addr = Channel1 or Channel2
            AnalogSettings.ShiftReg(16)           <= iCPUtoAnalog.DAC_Ch;
            AnalogSettings.ShiftReg(23 downto 17) <= X"2" & O"0";
          when O"7" =>
            AnalogSettings.ShiftReg <= (
              0      => not iCPUtoAnalog.CH0_K1_ON,
              1      => not iCPUtoAnalog.CH0_K1_OFF,
              2      => not iCPUtoAnalog.CH0_K2_ON,
              3      => not iCPUtoAnalog.CH0_K2_OFF,
              4      => iCPUtoAnalog.CH0_OPA656,
              5      => iCPUtoAnalog.CH0_BW_Limit,
              6      => iCPUtoAnalog.CH0_U14,
              7      => iCPUtoAnalog.CH0_U13,
              8      => iCPUtoAnalog.CH0_DC,
              9      => iCPUtoAnalog.CH1_DC,
              10     => iCPUtoAnalog.CH2_DC,
              11     => iCPUtoAnalog.CH3_DC,
              others => '-');
          when others => AnalogSettings.ShiftReg <= (others => 'X');
        end case;
      end if;

      if Strobe = '1' and SerialClk = '1' then
        if iCPUtoAnalog.Addr = O"6" then
          if AnalogSettings.Counter = 0 then
            oAnalogBusy <= '0';
            --      AnalogSettings.Enable <= '0';
          else
            AnalogSettings.Enable <= '1';
            if AnalogSettings.Counter = 1 then
              AnalogSettings.Enable <= '0';
            end if;
            -- The DAC needs an enable signal! 
            AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high downto 1) <=
              AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high-1 downto 0);
            AnalogSettings.ShiftReg(0) <= '-';
            AnalogSettings.Counter     <= AnalogSettings.Counter -1;
          end if;
          
        else
          -- after all data was shifted into the regs, the strobe must be active
          -- only for one cycle!
          AnalogSettings.Enable <= '0';
          if AnalogSettings.Counter = 0 then
            AnalogSettings.Enable <= '0';
            oAnalogBusy           <= '0';
          elsif AnalogSettings.Counter = 1 then
            AnalogSettings.Enable  <= '1';
            AnalogSettings.Counter <= AnalogSettings.Counter -1;
          else
            AnalogSettings.Counter                                         <= AnalogSettings.Counter -1;
            AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high downto 1) <=
              AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high-1 downto 0);
            AnalogSettings.ShiftReg(0) <= '-';
          end if;
        end if;
        if AnalogSettings.SetCounter = '1' then  -- important to garantee the
          AnalogSettings.Counter    <= cAnalogShiftLength;  -- the fist bit time
          AnalogSettings.SetCounter <= '0';
          oAnalogBusy               <= '1';
          if iCPUtoAnalog.Addr = O"6" then
            AnalogSettings.Enable <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  oAnalogSettings.Addr   <= AnalogSettings.Addr;
  oAnalogSettings.Enable <= AnalogSettings.Enable;
  oAnalogSettings.Data   <= AnalogSettings.ShiftReg(AnalogSettings.ShiftReg'high);

  pPWM : entity DSO.PWM
    generic map (
      gBitWidth => iCPUtoAnalog.PWM_Offset'length)
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iRefON      => iCPUtoAnalog.PWM_Offset,
      iRefOff     => (others => '0'),
      oPWM        => oAnalogSettings.PWM);


end architecture;
