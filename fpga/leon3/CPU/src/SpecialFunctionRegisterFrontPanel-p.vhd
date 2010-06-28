-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegisterFrontPanel-p.vhd
-- Author     : Robert Schilling <robert.schilling at gmx.at
-- Created    : 2010-06-28
-- Last update: 2010-06-28
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2010, Robert Schilling
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
-- 2010-06-28    
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pLedsKeysAnalogSettings.all;

package pSpecialFunctionRegister_Frontpanel is
  
  type aSFR_Frontpanel_in is record
                    Keys : aKeys;
                  end record;
                  
  type aSFR_Frontpanel_out is record
                    Leds : aLeds;
										iResetEnc : std_ulogic_vector(2 downto 0);
                  end record;
		   
	constant cLedAddr :	 				natural := 0;
	constant cKeyAddr : 				natural := 1;
	constant cEncAddrMisc : 		natural := 2;
	constant cEncAddrVoltage : 	natural := 3;
	constant cEncAddrUpDown : 	natural := 4;
  
end package;
