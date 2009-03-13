-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PWM-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-11
-- Last update: 2009-03-11
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
-- 2009-03-11  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;

entity PWM is
  generic (
    gBitWidth : natural := 8);
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iRefON      : in  std_ulogic_vector(gBitWidth-1 downto 0);
    iRefOff     : in  std_ulogic_vector(gBitWidth-1 downto 0);
    oPWM        : out std_ulogic);
end entity;


architecture RTL of PWM is
  signal Counter : unsigned(gBitWidth-1 downto 0);
begin
  
  pPWM : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Counter <= (others => '0');
      oPWM    <= '0';
    elsif rising_edge(iClk) then
      Counter <= Counter + to_unsigned(1, gBitWidth);
      if Counter = unsigned(iRefOn) then
        oPWM <= '1';
      end if;
      if Counter = unsigned(iRefOff) then
        oPWM <= '0';
      end if;
    end if;
  end process;
  
end architecture;
