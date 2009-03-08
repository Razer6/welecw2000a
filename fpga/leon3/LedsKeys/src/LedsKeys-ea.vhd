-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeys-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-03-04
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
use DSO.pLedsKeys.all;

entity LedsKeys is
    port (
  iClk              : in  std_ulogic;
  iResetAsync       : in  std_ulogic;
  iLeds             : in  aLeds;
  oLeds             : out aShiftOut;
  iKeysData         : in  std_ulogic;
  onFetchKeys       : out aShiftIn;
  oKeys             : out aKeys;
  oKeyInterruptLH   : out std_ulogic;
  oKeyInterruptHL   : out std_ulogic);
end entity;

architecture RTL of LedsKeys is
  signal Strobe, SerialClk : std_ulogic;
  signal LedShiftReg       : std_ulogic_vector(cLedShiftLength-1 downto 0);
  signal LedCounter        : natural range 0 to cLedShiftLength-1;
  signal KeyShiftReg       : std_ulogic_vector(cKeyShiftLength-1 downto 0);
  signal KeyCounter        : natural range 0 to cKeyShiftLength-1;
  signal Keys, PrevKeys    : aKeys;
  
begin

  Strobe2KHz : entity work.StrobeGen
    generic map (
      gClkFrequency    => cDesignClkRate,
      gStrobeFrequency => 2000)         -- 54 ms for one key reading
                                        -- avoids unstable key values
                                        -- 1 KHz probe output
    port map (
      iClk         => iClk,
      iResetAsync => iResetAsync,
      iResetSync   => '0',
      oStrobe      => Strobe);

  pLeds : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
        SerialClk <= '0';
      LedShiftReg <= (others => '0');
      LedCounter  <= 0;
      oLeds <= (
        nResetSync    => cLowActive,
        nOutputEnable => cHighInactive,
        others        => '0');
    elsif rising_edge(iClk) then
      oLeds.nOutputEnable <= cLowActive;

      if Strobe = '1' then
        SerialClk                                                <= not SerialClk;
        if SerialClk = '0' then 
        LedCounter                                               <= (LedCounter +1) mod cLedShiftLength;  -- mod 2**n
        LedShiftReg(LedShiftReg'left-1 downto LedShiftReg'right) <=
          LedShiftReg(LedShiftReg'left downto LedShiftReg'right+1);
        oLeds.Data                    <= LedShiftReg(LedShiftReg'right);
        LedShiftReg(LedShiftReg'left) <= '-';
        oLeds.ValidStrobe             <= '0';

        if LedCounter = 0 then
          LedShiftReg <= (
            0      => iLeds.BTN_CH4,
            1      => iLeds.Beam1On,
            2      => iLeds.BTN_MATH,
            3      => iLeds.Beam2On,
            4      => iLeds.BTN_QUICKMEAS,
            5      => iLeds.CURSORS,
            6      => iLeds.BTN_F1,
            7      => iLeds.BTN_CH3,
            8      => iLeds.BTN_PULSEWIDTH,
            9      => iLeds.EDGE,
            10     => iLeds.RUNSTOP,
            11     => iLeds.BTN_F2,
            12     => iLeds.BTN_F3,
            13     => iLeds.SINGLE,
            others => '0');
          oLeds.ValidStrobe <= '1';
        end if;
        end if;
      end if;
    end if;
  end process;

  oKeys <= Keys;
  pKeys : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      KeyShiftReg       <= (others => '0');
      KeyCounter        <= 0;
      onFetchKeys <= (
      nFetchStrobe => cHighInactive,
      nChipEnable => cHighInactive);
      Keys              <= (others => '0');
      PrevKeys          <= (others => '0');
      oKeyInterruptLH   <= '0';
      oKeyInterruptHL   <= '0';
      
    elsif rising_edge(iClk) then
    onFetchKeys.nChipEnable <= cLowActive;
    onFetchKeys.nFetchStrobe <= cHighInactive;
      oKeyInterruptLH   <= '0';
      oKeyInterruptHL   <= '0';

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
          PrevKeys          <= Keys;
          if Keys /= PrevKeys then
            oKeyInterruptLH <= '1';
       --   elsif Keys < PrevKeys then
            oKeyInterruptHL <= '1';
          else
            null;
          end if;
          Keys <= (
            BTN_F1           => KeyShiftReg(15),
            BTN_F2           => KeyShiftReg(16),
            BTN_F3           => KeyShiftReg(17),
            BTN_F4           => KeyShiftReg(18),
            BTN_F5           => KeyShiftReg(12),
            BTN_F6           => KeyShiftReg(14),
            BTN_MATH         => KeyShiftReg(0),
            BTN_CH1          => KeyShiftReg(13),
            BTN_CH2          => KeyShiftReg(11),
            BTN_CH3          => KeyShiftReg(2),
            BTN_CH4          => KeyShiftReg(1),
            BTN_MAINDEL      => KeyShiftReg(35),
            BTN_RUNSTOP      => KeyShiftReg(40),
            BTN_SINGLE       => KeyShiftReg(39),
            BTN_CURSORS      => KeyShiftReg(28),
            BTN_QUICKMEAS    => KeyShiftReg(33),
            BTN_ACQUIRE      => KeyShiftReg(32),
            BTN_DISPLAY      => KeyShiftReg(30),
            BTN_EDGE         => KeyShiftReg(38),
            BTN_MODECOUPLING => KeyShiftReg(36),
            BTN_AUTOSCALE    => KeyShiftReg(27),
            BTN_SAVERECALL   => KeyShiftReg(34),
            BTN_QUICKPRINT   => KeyShiftReg(31),
            BTN_UTILITY      => KeyShiftReg(29),
            BTN_PULSEWIDTH   => KeyShiftReg(42),
            BTN_X1           => KeyShiftReg(37),
            BTN_X2           => KeyShiftReg(41),
            ENCI_TIME_DIV    => KeyShiftReg(44),
            ENCD_TIME_DIV    => KeyShiftReg(43),
            ENCI_F           => KeyShiftReg(46),
            ENCD_F           => KeyShiftReg(45),
            ENCI_LEFT_RIGHT  => KeyShiftReg(50),
            ENCD_LEFT_RIGHT  => KeyShiftReg(49),
            ENCI_LEVEL       => KeyShiftReg(48),
            ENCD_LEVEL       => KeyShiftReg(47),
            ENCI_CH1_UPDN    => KeyShiftReg(20),
            ENCD_CH1_UPDN    => KeyShiftReg(19),
            ENCI_CH2_UPDN    => KeyShiftReg(26),
            ENCD_CH2_UPDN    => KeyShiftReg(25),
            ENCI_CH3_UPDN    => KeyShiftReg(4),
            ENCD_CH3_UPDN    => KeyShiftReg(3),
            ENCI_CH4_UPDN    => KeyShiftReg(10),
            ENCD_CH4_UPDN    => KeyShiftReg(9),
            ENCI_CH1_VDIV    => KeyShiftReg(22),
            ENCD_CH1_VDIV    => KeyShiftReg(21),
            ENCI_CH2_VDIV    => KeyShiftReg(24),
            ENCD_CH2_VDIV    => KeyShiftReg(23),
            ENCI_CH3_VDIV    => KeyShiftReg(6),
            ENCD_CH3_VDIV    => KeyShiftReg(5),
            ENCI_CH4_VDIV    => KeyShiftReg(8),
            ENCD_CH4_VDIV    => KeyShiftReg(7));
        end if;
      end if;
    end if;
  end process;


end architecture;
