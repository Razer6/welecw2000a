-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DelayMemory.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-15
-- Last update: 2009-02-15
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
-- 2009-02-15  1.0      
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DelayMemory is
  port
    (
  --    aclr      : in  std_logic := '0';
      clock     : in  std_logic;
      data      : in  std_logic_vector (17 downto 0);
      rdaddress : in  std_logic_vector (7 downto 0);
      wraddress : in  std_logic_vector (7 downto 0);
      wren      : in  std_logic := '1';
      q         : out std_logic_vector (17 downto 0)
      );
end DelayMemory;

architecture RTL of DelayMemory is
  type   aRam is array (2**8-1 downto 0) of std_ulogic_vector (17 downto 0);
  signal Ram : aRam := (others => (others =>  '0'));
begin
  
  process (clock)
  begin
  --  if aclr = '1' then
   --   q <= (others => '0');
    if rising_edge(clock) then
      if wren = '1' then
        Ram(to_integer(unsigned(wraddress))) <= std_ulogic_vector(Data);
        end if;
      q                          <= std_logic_vector(Ram(to_integer(unsigned(rdaddress))));
    end if;
  end process;
end architecture;
