-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SRamPriorityAccess-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-28
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
library DSO;
use DSO.Global.all;
use DSO.pSRamPriorityAccess.all;

entity SRamPriorityAccess is
  port (
    iClk        : in    std_ulogic;
    iResetAsync : in    std_ulogic;
    bSRAMData   : inout std_logic_vector(31 downto 0);
    oExtRam     : out   aRamAccess;
    iVGA        : in    aSharedRamAccess;
    oVGA        : out   aSharedRamReturn;
    iCPU        : in    aSharedRamAccess;
    oCPU        : out   aSharedRamReturn);
end entity;

architecture RTL of SRamPriorityAccess is
  type   aState is (Idle, VGARead, CPUWrite, CPURead);
  signal State, NextState : aState;
  signal nWr, nRd         : std_ulogic;
  
  
begin
  
  oCPU.Data <= aDword(bSRAMData);
  oVGA.Data <= to_x01(aDword(bSRAMData));

  process (bSRAMData, iVGA, iCPU, State)
  begin
    NextState        <= Idle;
    nWr              <= cHighInactive;
    nRd              <= cHighinactive;
    oExtRam.nSRAM_CE <= cLowActive;
    oExtRam.UB2_SRAM <= cLowActive;     --  iCPUWriteMask(3);
    oExtRam.LB2_SRAM <= cLowActive;     --  iCPUWriteMask(2);
    oExtRam.LB1_SRAM <= cLowActive;     --  iCPUWriteMask(1); 
    oExtRam.UB1_SRAM <= cLowActive;     --  iCPUWriteMask(0);
    oVGA.Busy        <= '0';
    oVGA.ACK         <= '0';
    oCPU.Busy        <= '0';
    oCPU.ACK         <= '0';
    oExtRam.SRAMAddr <= iCPU.Addr;
--    bSRAMData        <= (others => 'Z');

    case State is
      when Idle =>
        
        if iVGA.Rd = '1' then
          oExtRam.SRAMAddr <= iVGA.Addr;
          NextState        <= VGARead;
          oVGA.Busy        <= '1';
          nRd              <= cLowActive;
          
        elsif iCPU.Rd = '1' then
          oExtRam.SRAMAddr <= iCPU.Addr;
          NextState        <= CPURead;
          oCPU.Busy        <= '1';
          nRd              <= cLowActive;
          
        elsif iCPU.Wr = '1' then
          oExtRam.SRAMAddr <= iCPU.Addr;
          NextState        <= CPUWrite;
          oCPU.Busy        <= '1';
          oExtRam.UB2_SRAM <= not iCPU.WriteMask(3);
          oExtRam.LB2_SRAM <= not iCPU.WriteMask(2);
          oExtRam.LB1_SRAM <= not iCPU.WriteMask(1);
          oExtRam.UB1_SRAM <= not iCPU.WriteMask(0);
          nWr              <= cLowActive;
          
        else
          oExtRam.nSRAM_CE <= cHighInactive;
        end if;
        
      when VGARead =>
        oExtRam.SRAMAddr <= iVGA.Addr;
        oCPU.Busy        <= iCPU.Rd or iCPU.Wr;
        oVGA.ACK         <= '1';
        nRd              <= cLowActive;
        
      when CPURead =>
        oExtRam.SRAMAddr <= iCPU.Addr;
        oVGA.Busy        <= iVGA.Rd;
        oCPU.ACK         <= '1';
        nRd              <= cLowActive;
        
      when CPUWrite =>
        oExtRam.SRAMAddr <= iCPU.Addr;
        oExtRam.UB2_SRAM <= not iCPU.WriteMask(3);
        oExtRam.LB2_SRAM <= not iCPU.WriteMask(2);
        oExtRam.LB1_SRAM <= not iCPU.WriteMask(1);
        oExtRam.UB1_SRAM <= not iCPU.WriteMask(0);
        --  bSRAMData        <= std_logic_vector(iCPU.Data);
        oVGA.Busy        <= iVGA.Rd;
        oCPU.ACK         <= '1';
    end case;
    
  end process;

  oExtRam.nSRAM_OE <= nRd;

  process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      State            <= Idle;
      oExtRam.nSRAM_WE <= cHighInactive;
      --   oExtRam.nSRAM_OE <= cHighInactive;
    elsif rising_edge(iClk) then
      State            <= NextState;
      oExtRam.nSRAM_WE <= nWr;
      --  oExtRam.nSRAM_OE <= nRd;
    end if;
  end process;

end architecture;
