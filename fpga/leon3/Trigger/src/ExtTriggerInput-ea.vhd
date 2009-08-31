-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : ExtTriggerInput-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-11
-- Last update: 2009-08-02
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
use DSO.pPolyphaseDecimator.all;
use DSO.pLedsKeysAnalogSettings.all;
use DSO.pTrigger.all;

entity ExtTriggerInput is
  port (
    iClk           : in  std_ulogic;
    iResetAsync    : in  std_ulogic;
    iExtTrigger    : in  std_ulogic_vector(1 to cExtTriggers);
    iExtTriggerSrc : in  aExtTriggerInput;
    oTrigger       : out std_ulogic;
    oPWM           : out std_ulogic_vector(1 to cExtTriggers));
end entity;

architecture RTL of ExtTriggerInput is
  signal Toggle  : std_ulogic;
  signal Sources : std_ulogic_vector(0 to cExtTriggers);
  type   aSync is array(0 to 1) of std_ulogic_vector(1 to cExtTriggers);
  signal Sync    : aSync;
begin
  
  Trigger : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      oTrigger <= '0';
      Toggle   <= '0';
      Sync     <= (others => (others => '0'));
    elsif rising_edge(iClk) then
      Sync(1)  <= Sync(0);
      Sync(0)  <= iExtTrigger;
      Toggle   <= not Toggle;
      oTrigger <= Sources(iExtTriggerSrc.Addr);
    end if;
  end process;

  process (Sync, Toggle)
  begin
    Sources(0) <= Toggle;
    for i in 1 to cExtTriggers loop
      Sources(i) <= Sync(1)(i);
    end loop;
  end process;

  pLevel : for i in 1 to cExtTriggers generate
    L : PWM
      generic map (
        gBitWidth => iExtTriggerSrc.PWM(1)'length)
      port map (
        iClk        => iClk,
        iResetAsync => iResetAsync,
        iRefON      => iExtTriggerSrc.PWM(i),
        iRefOff     => (others => '0'),
        oPWM        => oPWM(i));
  end generate;
  
end architecture;

