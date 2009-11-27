-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : StoP_MC14094b-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-11-27
-- Last update: 2009-11-27
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
-- 2009-11-27  1.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity StoP_MC14094b is
  port (
    signal clk : in  std_ulogic;
    signal str : in  std_ulogic;
    signal oe  : in  std_ulogic;
    signal d   : in  std_ulogic;
    signal qs  : out std_ulogic;
    signal qs2 : out std_ulogic;
    signal q   : out std_ulogic_vector(0 to 7));
end entity;

architecture BHV of StoP_MC14094b is
  signal Shift : std_ulogic_vector(0 to 7);
  signal Latch : std_ulogic_vector(0 to 7);
begin
  
  R : process (clk)
  begin
    if rising_edge(clk) then
      Shift(0)      <= d;
      Shift(1 to 7) <= Shift(0 to 6);
    end if;
    if falling_edge(clk) then
      qs2 <= Shift(7);
    end if;
  end process;
  qs <= Shift(7);

  L : process(Shift, str)
  begin
    if str = '1' then
      Latch <= Shift;
    end if;
  end process;

  O : q <= Latch when oe = '1' else (others => 'Z');
  
end architecture;
