-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeys-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-08-28
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
use DSO.Global.all;

package pLedsKeysAnalogSettings is
  
  constant cAnalogAddrLength  : natural := 3;
  constant cAnalogShiftLength : natural := 24;

  type aShiftOut is record
                      nResetSync    : std_ulogic;
                      Data          : std_ulogic;
                      ValidStrobe   : std_ulogic;
                      nOutputEnable : std_ulogic;
                    end record;
  
  type aShiftIn is record
                     nFetchStrobe : std_ulogic;
                     nChipEnable  : std_ulogic;
                   end record;
  
  type aKeys is record
                  BTN_F1           : std_ulogic;
                  BTN_F2           : std_ulogic;
                  BTN_F3           : std_ulogic;
                  BTN_F4           : std_ulogic;
                  BTN_F5           : std_ulogic;
                  BTN_F6           : std_ulogic;
                  BTN_MATH         : std_ulogic;
                  BTN_CH0          : std_ulogic;
                  BTN_CH1          : std_ulogic;
                  BTN_CH2          : std_ulogic;
                  BTN_CH3          : std_ulogic;
                  BTN_MAINDEL      : std_ulogic;
                  BTN_RUNSTOP      : std_ulogic;
                  BTN_SINGLE       : std_ulogic;
                  BTN_CURSORS      : std_ulogic;
                  BTN_QUICKMEAS    : std_ulogic;
                  BTN_ACQUIRE      : std_ulogic;
                  BTN_DISPLAY      : std_ulogic;
                  BTN_EDGE         : std_ulogic;
                  BTN_MODECOUPLING : std_ulogic;
                  BTN_AUTOSCALE    : std_ulogic;
                  BTN_SAVERECALL   : std_ulogic;
                  BTN_QUICKPRINT   : std_ulogic;
                  BTN_UTILITY      : std_ulogic;
                  BTN_PULSEWIDTH   : std_ulogic;
                  BTN_X1           : std_ulogic;
                  BTN_X2           : std_ulogic;
                  ENX_TIME_DIV     : std_ulogic;
                  ENY_TIME_DIV     : std_ulogic;
                  ENX_F            : std_ulogic;
                  ENY_F            : std_ulogic;
                  ENX_LEFT_RIGHT   : std_ulogic;
                  ENY_LEFT_RIGHT   : std_ulogic;
                  ENX_LEVEL        : std_ulogic;
                  ENY_LEVEL        : std_ulogic;
                  ENX_CH0_UPDN     : std_ulogic;
                  ENY_CH0_UPDN     : std_ulogic;
                  ENX_CH1_UPDN     : std_ulogic;
                  ENY_CH1_UPDN     : std_ulogic;
                  ENX_CH2_UPDN     : std_ulogic;
                  ENY_CH2_UPDN     : std_ulogic;
                  ENX_CH3_UPDN     : std_ulogic;
                  ENY_CH3_UPDN     : std_ulogic;
                  ENX_CH0_VDIV     : std_ulogic;
                  ENY_CH0_VDIV     : std_ulogic;
                  ENX_CH1_VDIV     : std_ulogic;
                  ENY_CH1_VDIV     : std_ulogic;
                  ENX_CH2_VDIV     : std_ulogic;
                  ENY_CH2_VDIV     : std_ulogic;
                  ENX_CH3_VDIV     : std_ulogic;
                  ENY_CH3_VDIV     : std_ulogic;
                end record;
  
  type aLeds is record
                  LED_CH0        : std_ulogic;  -- Button [Channel 1]
                  LED_CH1        : std_ulogic;  -- Button [Channel 2]
                  LED_CH2        : std_ulogic;  -- Button [Channel 3]
                  LED_CH3        : std_ulogic;  -- Button [Channel 4]
                  LED_MATH       : std_ulogic;  -- Button [Math]       
                  LED_QUICKMEAS  : std_ulogic;  -- Button [Quick Meass]
                  LED_CURSORS    : std_ulogic;  -- Button [Cursors]
                  LED_WHEEL      : std_ulogic;  -- Function Knob
                  LED_PULSEWIDTH : std_ulogic;  -- Button [Pulse Width]
                  LED_EDGE       : std_ulogic;  -- Button [Edge]
                  RUN_GREEN      : std_ulogic;  -- Button [Run/Stop] Red Led
                  RUN_RED        : std_ulogic;  -- Button [Run/Stop] Green Led
                  SINGLE_GREEN   : std_ulogic;  -- Button [Single] Green Led
                  SINGLE_RED     : std_ulogic;  -- Button [Single] Red Led
                end record;
  
  type aAnalogSettings is record
                            Set           : std_ulogic;
                            Addr          : std_ulogic_vector(cAnalogAddrLength-1 downto 0);
                            CH0_K1_ON     : std_ulogic;
                            CH0_K1_OFF    : std_ulogic;
                            CH0_K2_ON     : std_ulogic;
                            CH0_K2_OFF    : std_ulogic;
                            CH0_OPA656    : std_ulogic;
                            CH0_BW_Limit  : std_ulogic;
                            CH0_U14       : std_ulogic;
                            CH0_U13       : std_ulogic;
                            CH0_DC        : std_ulogic;
                            CH1_DC        : std_ulogic;
                            CH2_DC        : std_ulogic;
                            CH3_DC        : std_ulogic;
                            CH1_K1_ON     : std_ulogic;
                            CH1_K1_OFF    : std_ulogic;
                            CH1_K2_ON     : std_ulogic;
                            CH1_K2_OFF    : std_ulogic;
                            CH1_OPA656    : std_ulogic;
                            CH1_BW_Limit  : std_ulogic;
                            CH1_U14       : std_ulogic;
                            CH1_U13       : std_ulogic;
                            CH0_src2_addr : std_ulogic_vector(1 downto 0);
                            CH1_src2_addr : std_ulogic_vector(1 downto 0);
                            CH2_src2_addr : std_ulogic_vector(1 downto 0);
                            CH3_src2_addr : std_ulogic_vector(1 downto 0);
                            DAC_Offset    : aWord;
                            DAC_Ch        : std_ulogic;
                            PWM_Offset    : aByte;
                          end record;
  
  type aAnalogSettingsOut is record
                               Addr   : std_ulogic_vector(cAnalogAddrLength-1 downto 0);
                               Enable : std_ulogic;
                               Data   : std_ulogic;
                               PWM    : std_ulogic;
                             end record;
  
end;
