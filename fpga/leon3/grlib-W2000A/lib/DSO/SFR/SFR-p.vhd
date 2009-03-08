-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SFR-p.vhd
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
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library DSO;
use DSO.pSpecialFunctionRegister.all;   

package pSFR is
  component SFR is
  generic (
    pindex : integer := 0;               -- Leon3 index
    paddr  : integer := 0;               -- Leon3 address
    pmask  : integer := 16#FFF#;         -- Leon3 mask
    pirq   : integer := 0                -- Leon3 IRQ
    );
  port (
    rst_in      : in  std_ulogic;        -- Global reset, active low
    clk_i       : in  std_ulogic;        -- Global clock
    iResetAsync : in  std_ulogic;        -- Global reset
    apb_i       : in  apb_slv_in_type;   -- APB input
    apb_o       : out apb_slv_out_type;  -- APB output
    iSFRControl : in  aSFR_in;
    oSFRControl : out aSFR_out
    );
end component;
end;
