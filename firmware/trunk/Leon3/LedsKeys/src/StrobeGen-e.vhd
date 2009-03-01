-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : StrobeGen-e.vhd
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

use work.Global.all;

entity StrobeGen is
  
  generic (
    gClkFrequency    : natural := 48E6;
    gStrobeFrequency : natural := 12E6);  -- 12 MHz

  port (
    -- Sequential logic inside this unit
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iResetSync  : in  std_ulogic;
    -- Strobe with the above given cycle time
    oStrobe     : out std_ulogic);

-- pragma translate_off
begin

  assert (gClkFrequency >= gStrobeFrequency)
    report "Mp: The Clk frequency is to low to generate such a short strobe cycle."
    severity error;
-- pragma translate_on
  
end StrobeGen;

