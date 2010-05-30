-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File	      : LedsKeys-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2010-05-16
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
-- Date	       Version 
-- 2009-02-14  1.0	
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.Global.all;

package pLedsKeysAnalogSettings is
  constant cNobCounterSize : natural := 3;

  type aShiftOut is record
    SerialClk	  : std_ulogic;
    nResetSync	  : std_ulogic;
    Data	  : std_ulogic;
    ValidStrobe	  : std_ulogic;
    nOutputEnable : std_ulogic;
  end record;

  type aShiftIn is record
    SerialClk	 : std_ulogic;
    nFetchStrobe : std_ulogic;
    nChipEnable	 : std_ulogic;
  end record;

  type aKeys is record
    BTN_F1	     : std_ulogic;
    BTN_F2	     : std_ulogic;
    BTN_F3	     : std_ulogic;
    BTN_F4	     : std_ulogic;
    BTN_F5	     : std_ulogic;
    BTN_F6	     : std_ulogic;
    BTN_MATH	     : std_ulogic;
    BTN_CH0	     : std_ulogic;
    BTN_CH1	     : std_ulogic;
    BTN_CH2	     : std_ulogic;
    BTN_CH3	     : std_ulogic;
    BTN_MAINDEL	     : std_ulogic;
    BTN_RUNSTOP	     : std_ulogic;
    BTN_SINGLE	     : std_ulogic;
    BTN_CURSORS	     : std_ulogic;
    BTN_QUICKMEAS    : std_ulogic;
    BTN_ACQUIRE	     : std_ulogic;
    BTN_DISPLAY	     : std_ulogic;
    BTN_EDGE	     : std_ulogic;
    BTN_MODECOUPLING : std_ulogic;
    BTN_AUTOSCALE    : std_ulogic;
    BTN_SAVERECALL   : std_ulogic;
    BTN_QUICKPRINT   : std_ulogic;
    BTN_UTILITY	     : std_ulogic;
    BTN_PULSEWIDTH   : std_ulogic;
    BTN_X1	     : std_ulogic;
    BTN_X2	     : std_ulogic;
    EN_TIME_DIV	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_F	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_LEFT_RIGHT    : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_LEVEL	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH0_UPDN	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH1_UPDN	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH2_UPDN	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH3_UPDN	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH0_VDIV	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH1_VDIV	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH2_VDIV	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
    EN_CH3_VDIV	     : std_ulogic_vector(cNobCounterSize-1 downto 0);
  end record;

  type aLeds is record
    EnableKeyClock : std_ulogic;
    SetLeds	   : std_ulogic;
    LED_CH0	   : std_ulogic;	-- Button [Channel 1]
    LED_CH1	   : std_ulogic;	-- Button [Channel 2]
    LED_CH2	   : std_ulogic;	-- Button [Channel 3]
    LED_CH3	   : std_ulogic;	-- Button [Channel 4]
    LED_MATH	   : std_ulogic;	-- Button [Math]       
    LED_QUICKMEAS  : std_ulogic;	-- Button [Quick Meass]
    LED_CURSORS	   : std_ulogic;	-- Button [Cursors]
    LED_WHEEL	   : std_ulogic;	-- Function Knob
    LED_PULSEWIDTH : std_ulogic;	-- Button [Pulse Width]
    LED_EDGE	   : std_ulogic;	-- Button [Edge]
    RUN_GREEN	   : std_ulogic;	-- Button [Run/Stop] Red Led
    RUN_RED	   : std_ulogic;	-- Button [Run/Stop] Green Led
    SINGLE_GREEN   : std_ulogic;	-- Button [Single] Green Led
    SINGLE_RED	   : std_ulogic;	-- Button [Single] Red Led
  end record;

  type aAnalogSettingsOut is record
    PWM_Offset	     : aByte;
    SerialClk	     : std_ulogic;
    EnableProbeClock : std_ulogic;
    Addr	     : std_ulogic_vector(2 downto 0);
    Enable	     : std_ulogic;
    Data	     : std_ulogic;
  end record;
  
end;
