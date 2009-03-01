-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SRamPriorityAccess-p.vhd
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
library DSO;
use DSO.Global.all;


package pSRamPriorityAccess is
  type aSharedRamAccess is record
                             Addr      : std_ulogic_vector(cSRAMAddrWidth-1 downto 0);
                             Data      : std_logic_vector(31 downto 0);
                             Rd        : std_ulogic;
                             Wr        : std_ulogic;
                             WriteMask : std_ulogic_vector(3 downto 0);
                           end record;
  type aSharedRamReturn is record
                             Data : aDword;
                             Busy : std_ulogic;
                             ACK  : std_ulogic;
                           end record;
  
  type aRamAccess is record
                       SRAMAddr : std_ulogic_vector(cSRAMAddrWidth-1 downto 0);
                       nSRAM_CE : std_ulogic;
                       nSRAM_WE : std_ulogic;
                       nSRAM_OE : std_ulogic;
                       UB2_SRAM : std_ulogic;
                       LB2_SRAM : std_ulogic;
                       LB1_SRAM : std_ulogic;
                       UB1_SRAM : std_ulogic;
                     end record;
end;
