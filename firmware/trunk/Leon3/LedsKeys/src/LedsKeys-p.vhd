-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : LedsKeys-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-14
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

package pLedsKeys is
  
  constant cKeyShiftLength : natural := 54;
  constant cLedShiftLength : natural := 16;

  type aShiftOut is record
                      SerialClk     : std_ulogic;
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
                  BTN_CH1          : std_ulogic;
                  BTN_CH2          : std_ulogic;
                  BTN_CH3          : std_ulogic;
                  BTN_CH4          : std_ulogic;
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
                  ENCI_TIME_DIV    : std_ulogic;
                  ENCD_TIME_DIV    : std_ulogic;
                  ENCI_F           : std_ulogic;
                  ENCD_F           : std_ulogic;
                  ENCI_LEFT_RIGHT  : std_ulogic;
                  ENCD_LEFT_RIGHT  : std_ulogic;
                  ENCI_LEVEL       : std_ulogic;
                  ENCD_LEVEL       : std_ulogic;
                  ENCI_CH1_UPDN    : std_ulogic;
                  ENCD_CH1_UPDN    : std_ulogic;
                  ENCI_CH2_UPDN    : std_ulogic;
                  ENCD_CH2_UPDN    : std_ulogic;
                  ENCI_CH3_UPDN    : std_ulogic;
                  ENCD_CH3_UPDN    : std_ulogic;
                  ENCI_CH4_UPDN    : std_ulogic;
                  ENCD_CH4_UPDN    : std_ulogic;
                  ENCI_CH1_VDIV    : std_ulogic;
                  ENCD_CH1_VDIV    : std_ulogic;
                  ENCI_CH2_VDIV    : std_ulogic;
                  ENCD_CH2_VDIV    : std_ulogic;
                  ENCI_CH3_VDIV    : std_ulogic;
                  ENCD_CH3_VDIV    : std_ulogic;
                  ENCI_CH4_VDIV    : std_ulogic;
                  ENCD_CH4_VDIV    : std_ulogic;
                end record;
  
  type aLeds is record
                  BTN_CH4        : std_ulogic;  -- Button [Channel 4]
                  Beam1On        : std_ulogic;  -- Button [Channel 1]
                  BTN_MATH       : std_ulogic;  -- Button [Math]         (not work?)
                  Beam2On        : std_ulogic;  -- Button [Channel 2]
                  BTN_QUICKMEAS  : std_ulogic;  -- Button [Quick Meass]
                  CURSORS        : std_ulogic;  -- Button [Cursors]
                  BTN_F1         : std_ulogic;  -- Function Knob
                  BTN_CH3        : std_ulogic;  -- Button [Channel 3]
                  BTN_PULSEWIDTH : std_ulogic;  -- Button [Pulse Width]
                  EDGE           : std_ulogic;  -- Button [Edge]
                  RUNSTOP        : std_ulogic;  -- Button [Run/Stop] Red Led
                  BTN_F2         : std_ulogic;  -- Button [Run/Stop] Green Led
                  BTN_F3         : std_ulogic;  -- Button [Single] Red Led
                  SINGLE         : std_ulogic;  -- Button [Single] Green Led
                end record;
end;
