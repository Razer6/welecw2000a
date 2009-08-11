-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : SbXPLL.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-04-17
-- Last update: 2009-07-31
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
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
-- 2009-04-17  1.0
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.all;

entity SbXPLL is
  port
    (
      areset : in  std_logic := '0';
      inclk0 : in  std_logic := '0';
      c0     : out std_logic;
      c1     : out std_logic;
      locked : out std_logic
      );
end SbXPLL;


architecture bhv of sbxpll is
  signal Clk0 : std_ulogic := '1';
begin
  
  process
  begin
    locked <= '0';
    wait for 3 sec /(4*250E6);
    wait until inclk0 = '0';
    wait until inclk0 = '1';
    locked <= '1';
    loop
      Clk0 <= not Clk0;
      wait until inclk0 = '1';
    end loop;
  end process;
  c0 <= Clk0;
  c1 <= inclk0;
  
end bhv;
