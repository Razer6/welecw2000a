-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : Arbiter-ea.vhd
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
library work;
use work.Global.all;
use work.pDevices.all;

entity Arbiter is
  port (
    --  iClk         : in  std_ulogic;
    --  inResetAsync : in  std_ulogic;
    iAddr    : in  aDword;
    iData    : in  aBus(0 to cSlaves-1);
    oData    : out aDword;
    iWe      : in  std_ulogic;
    oWe      : out std_ulogic_vector(0 to cSlaves-1);
    iRd      : in  std_ulogic;
    oRd      : out std_ulogic_vector(0 to cSlaves-1);
    iMemBusy : in  std_ulogic_vector(0 to cSlaves-1);
    oMemBusy : out std_ulogic);
end entity;

architecture RTL of Arbiter is
  signal Slave : natural range 0 to 2**cSelectBits-1;
begin
  process (iAddr, Slave)
    variable temp : unsigned(cSelectBits-1 downto 0);
  begin
    if is_x(iAddr) = true then
      Slave <= 0;
    else
      temp  := unsigned(iAddr(iAddr'high downto iAddr'high+1-cSelectBits));
      Slave <= to_integer(temp);
      -- Note: a softwave bug can produce a (out of range) simulation failure here!
      Slave <= to_integer(unsigned(iAddr(iAddr'high downto iAddr'high+1-cSelectBits)));
      if Slave = cMemAddrRange and
        to_integer(unsigned(iAddr(iAddr'high-cSelectBits downto cBootDataSize))) = 0 then
        Slave <= cBootAddrRange;
      end if;
    end if;
  end process;

  oData <= iData(Slave) when Slave < cSlaves
           else (others => '-');

  oMemBusy <= iMemBusy(Slave);

  WriteEnable : process (Slave, iWe, iRd)
  begin
    oWe        <= (others => '0');
    oRd        <= (others => '0');
    --  if Slave < cSlaves then
    oWe(Slave) <= iWe;
    oRd(Slave) <= iRd;
    --  end if;
  end process;
  
end architecture;

