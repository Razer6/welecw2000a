-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DeMux_HCT238-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-23
-- Last update: 2009-03-23
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
-- 2009-03-23  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DeMux_HCT238 is
  port (
    iA   : in  std_ulogic_vector(2 downto 0);
    inE1 : in  std_ulogic;
    inE2 : in  std_ulogic;
    iE3  : in  std_ulogic;
    oQ   : out std_ulogic_vector(0 to 7));
end entity;

architecture RTL of DeMux_HCT238 is
begin
  
  process (iA , inE1, inE2, iE3)
  begin
    oQ <= (others => '0');
    if inE1 = '0' and inE2 = '0' and iE3 = '1' then
      oQ(to_integer(unsigned(iA))) <= '1';
    end if;
  end process;
end architecture;
