-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PLL2.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-24
-- Last update: 2009-09-11
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
-- 2009-03-24  1.0      
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity PLL2 is
  port
    (
      inclk0 : in  std_logic := '0';
      pllena : in  std_logic := '1';
      c0     : out std_logic;
      c1     : out std_logic;
      locked : out std_logic
      );
end PLL2;

architecture bhv of PLL2 is
  signal   Clk0     : std_ulogic := '0';
  signal   Clk1     : std_ulogic := '0';
  constant cClkTime : time       := 1 sec /(2*250E6);
begin
  
  process
  begin
    locked <= '0';
--    wait until pllena = '1';
    wait until inclk0 = '0';
    wait until inclk0 = '1';
    locked <= '1';
    wait for 2 sec /(4*250E6);
    loop
      Clk0 <= not Clk0;
      Clk1 <= not Clk1;
      wait for cClkTime;
      Clk0 <= not Clk0;
      wait for cClkTime;
    end loop;
  end process;

  output : process (pllena, Clk0, Clk1)
  begin
    if pllena = '1' then
      c0 <= Clk0;
      c1 <= Clk1;
    end if;
  end process;
  
end architecture;
