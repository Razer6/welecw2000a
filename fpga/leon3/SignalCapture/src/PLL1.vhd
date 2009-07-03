-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PLL1.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-24
-- Last update: 2009-06-11
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

entity PLL1 is
  port
    (
      inclk0 : in  std_logic := '0';
      pllena : in  std_logic := '1';
      c0     : out std_logic;
      c1     : out std_logic;
      c2     : out std_logic;
      locked : out std_logic
      );
end PLL1;

architecture bhv of PLL1 is
  signal   Clk0     : std_ulogic := '0';
  signal   Clk1     : std_ulogic := '0';
  signal   Clk2     : std_ulogic := '0';
  constant cClkTime : time       := 1 sec /(2*250E6);
begin
  
  process
  begin
    locked <= '0';
--    wait until pllena = '1';
    wait until inclk0 = '0';
    wait until inclk0 = '1';
    locked <= '1';
    wait for 1 sec /(4*250E6);
    loop
      Clk0 <= not Clk0;
      wait for cClkTime;
    end loop;
  end process;
  c0 <= Clk0;

  process
  begin
    locked <= '0';
--    wait until pllena = '1';
    wait until inclk0 = '0';
    wait until inclk0 = '1';
    locked <= '1';
    wait for 1 sec /(4*250E6);
    loop
      Clk1 <= not Clk1;
      wait for 2*cClkTime;
    end loop;
  end process;
  c1 <= Clk1;

  process
  begin
    locked <= '0';
--    wait until pllena = '1';
    wait until inclk0 = '0';
    wait until inclk0 = '1';
    locked <= '1';
    wait for 1 sec /(4*250E6);
    loop
      Clk2 <= not Clk2;
      wait for 4*cClkTime;
    end loop;
  end process;
  c2 <= Clk2;
  
end architecture;
