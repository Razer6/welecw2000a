-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeysAnalogSettings-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-03-29
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
  signal Strobe, SerialClk : std_ulogic;
  signal LedShiftReg       : std_ulogic_vector(cLedShiftLength-1 downto 0);
  signal LedCounter        : natural range 0 to cLedShiftLength-1;
  signal KeyShiftReg       : std_ulogic_vector(cKeyShiftLength downto 1);
  signal KeyCounter        : natural range 0 to cKeyShiftLength-1;

  type aAnalogState is record
                         SetCounter : std_ulogic;
                         Counter    : natural range 0 to cAnalogShiftLength+1;
                         Addr       : std_ulogic_vector(cAnalogAddrLength-1 downto 0);
                         ShiftReg   : std_ulogic_vector(cAnalogShiftLength-1 downto 0);
                         Enable     : std_ulogic;
                       end record;
  
  signal AnalogSettings : aAnalogState;
  
begin

  Strobe2KHz : entity work.StrobeGen
    generic map (
      gClkFrequency    => cCPUClkRate,
      gStrobeFrequency => cAnSettStrobeRate)
    --    gStrobeFrequency => 2000)        -- 54 ms for one key reading
    -- avoids unstable key values
    -- 1 KHz probe output
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iResetSync  => '0',
      oStrobe     => Strobe);

  oSerialClk <= SerialClk;

  pLeds : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      SerialClk   <= '0';
      LedShiftReg <= (others => '0');
      LedCounter  <= 0;
      oLeds <= (
        nResetSync    => cLowActive,
        nOutputEnable => cHighInactive,
        others        => '0');
    elsif rising_edge(iClk) then
      oLeds.nOutputEnable <= cLowActive;
      if Strobe = '1' then
        SerialClk <= not SerialClk;
        if SerialClk = '0' then
          LedCounter                                               <= (LedCounter +1) mod cLedShiftLength;  -- mod 2**n
          LedShiftReg(LedShiftReg'left-1 downto LedShiftReg'right) <=
            LedShiftReg(LedShiftReg'left downto LedShiftReg'right+1);
          oLeds.Data                    <= LedShiftReg(LedShiftReg'right);
          LedShiftReg(LedShiftReg'left) <= '-';
          oLeds.ValidStrobe             <= '0';

          if LedCounter = 0 then
            LedShiftReg <= (
              0      => not iLeds.BTN_CH3,
              1      => not iLeds.Beam1On,
              2      => not iLeds.BTN_MATH,
              3      => not iLeds.Beam2On,
              4      => not iLeds.BTN_QUICKMEAS,
              5      => not iLeds.CURSORS,
              6      => not iLeds.BTN_F1,
              7      => not iLeds.BTN_CH2,
              8      => not iLeds.BTN_PULSEWIDTH,
              9      => not iLeds.EDGE,
              10     => not iLeds.RUNSTOP,
              11     => not iLeds.BTN_F2,
              12     => not iLeds.BTN_F3,
              13     => not iLeds.SINGLE,
              others => '1');
--           LedShiftReg <= (
--            0      => iLeds.BTN_CH3,
--            1      => iLeds.BTN_CH0,
--            2      => iLeds.BTN_MATH,
--            3      => iLeds.BTN_CH1,
--            4      => iLeds.BTN_QUICKMEAS,
--            5      => iLeds.CURSORS,
--            6      => iLeds.BTN_F1,
--            7      => iLeds.BTN_CH2,
--            8      => iLeds.BTN_PULSEWIDTH,
--            9      => iLeds.EDGE,
--            10     => iLeds.RUNSTOP,
--            11     => iLeds.BTN_F2,
--            12     => iLeds.BTN_F3,
--            13     => iLeds.SINGLE,
--            others => '1');
            oLeds.ValidStrobe <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

--  oKeys <= Keys;
  pKeys : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      KeyShiftReg <= (others => '0');
      KeyCounter  <= 0;
      onFetchKeys <= (
        nFetchStrobe => cHighInactive,
        nChipEnable  => cHighInactive);
      oKeys <= (others => '0');
      
    elsif rising_edge(iClk) then
      onFetchKeys.nChipEnable  <= cLowActive;
      onFetchKeys.nFetchStrobe <= cHighInactive;

      if Strobe = '1' and SerialClk = '1' then
        onFetchKeys.nFetchStrobe <= cHighInactive;
        if KeyCounter /= cKeyShiftLength-1 then
          KeyCounter <= KeyCounter +1;
        else
          KeyCounter <= 0;
        end if;
        KeyShiftReg(KeyShiftReg'right)                           <= iKeysData;
        KeyShiftReg(KeyShiftReg'left downto KeyShiftReg'right+1) <=
          KeyShiftReg(KeyShiftReg'left-1 downto KeyShiftReg'right);
        
        if KeyCounter = 0 then
          onFetchKeys.nFetchStrobe <= cLowActive;
          oKeys <= (
            BTN_F1           => KeyShiftReg(19),
            BTN_F2           => KeyShiftReg(20),
            BTN_F3           => KeyShiftReg(21),
            BTN_F4           => KeyShiftReg(22),
            BTN_F5           => KeyShiftReg(16),
            BTN_F6           => KeyShiftReg(18),
            BTN_MATH         => KeyShiftReg(1),
            BTN_CH0          => KeyShiftReg(17),
            BTN_CH1          => KeyShiftReg(15),
            BTN_CH2          => KeyShiftReg(3),
            BTN_CH3          => KeyShiftReg(2),
            BTN_MAINDEL      => KeyShiftReg(39),
            BTN_RUNSTOP      => KeyShiftReg(44),
            BTN_SINGLE       => KeyShiftReg(43),
            BTN_CURSORS      => KeyShiftReg(32),
            BTN_QUICKMEAS    => KeyShiftReg(37),
            BTN_ACQUIRE      => KeyShiftReg(36),
            BTN_DISPLAY      => KeyShiftReg(34),
            BTN_EDGE         => KeyShiftReg(42),
            BTN_MODECOUPLING => KeyShiftReg(40),
            BTN_AUTOSCALE    => KeyShiftReg(31),
            BTN_SAVERECALL   => KeyShiftReg(38),
            BTN_QUICKPRINT   => KeyShiftReg(35),
            BTN_UTILITY      => KeyShiftReg(33),
            BTN_PULSEWIDTH   => KeyShiftReg(46),
            BTN_X1           => KeyShiftReg(41),
            BTN_X2           => KeyShiftReg(45),
            ENX_TIME_DIV     => KeyShiftReg(48),
            ENY_TIME_DIV     => KeyShiftReg(47),
            ENX_F            => KeyShiftReg(50),
            ENY_F            => KeyShiftReg(49),
            ENX_LEFT_RIGHT   => KeyShiftReg(54),
            ENY_LEFT_RIGHT   => KeyShiftReg(53),
            ENX_LEVEL        => KeyShiftReg(52),
            ENY_LEVEL        => KeyShiftReg(51),
            ENX_CH0_UPDN     => KeyShiftReg(24),
            ENY_CH0_UPDN     => KeyShiftReg(23),
            ENX_CH1_UPDN     => KeyShiftReg(30),
            ENY_CH1_UPDN     => KeyShiftReg(29),
            ENX_CH2_UPDN     => KeyShiftReg(8),
            ENY_CH2_UPDN     => KeyShiftReg(7),
            ENX_CH3_UPDN     => KeyShiftReg(14),
            ENY_CH3_UPDN     => KeyShiftReg(13),
            ENX_CH0_VDIV     => KeyShiftReg(26),
            ENY_CH0_VDIV     => KeyShiftReg(25),
            ENX_CH1_VDIV     => KeyShiftReg(28),
            ENY_CH1_VDIV     => KeyShiftReg(27),
            ENX_CH2_VDIV     => KeyShiftReg(10),
            ENY_CH2_VDIV     => KeyShiftReg(9),
            ENX_CH3_VDIV     => KeyShiftReg(12),
            ENY_CH3_VDIV     => KeyShiftReg(11));
        end if;
      end if;
    end if;
  end process;

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
