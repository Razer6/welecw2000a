-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : StrobeGen_var-e.vhd
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

entity StrobeGen_var is
  generic (
    gBitWidth : natural := 16);
  port (
    -- Sequential logic inside this unit
    iClk         : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iResetSync   : in  std_ulogic;
    iCountEnable : in std_ulogic;
    iReference   : in  unsigned(gBitWidth-1 downto 0);  -- not registered inside, it only change
                                                       -- something when iResetSync=cActivated!
    -- Strobe with the above given reference
    oStrobe      : out std_ulogic;  
    oCounter     : out unsigned(gBitWidth-1 downto 0));
end entity;
