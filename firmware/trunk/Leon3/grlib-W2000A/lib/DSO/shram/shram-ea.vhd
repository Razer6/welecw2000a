-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : shram-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-02-14
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: Out of date
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

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library DSO;
use DSO.Global.all;
use DSO.pshram.all;
use DSO.pVGA.all;
use DSO.pSRamPriorityAccess.all;

entity shram is
  generic (
    hindex : integer := 0;              -- Leon3 index
    haddr  : integer := 0;              -- Leon3 address
    hmask  : integer := 16#FFE#;        -- Leon3 mask
    --  tech   : integer := DEFMEMTECH;
    kbytes : integer := 2048
    );
  port (
    rst_in      : in    std_ulogic;     -- Global reset, active low
    clk_i       : in    std_ulogic;     -- Global clock
    ahbsi       : in    ahb_slv_in_type;
    ahbso       : out   ahb_slv_out_type;
    iClkDesign  : in    std_ulogic;
    iResetAsync : in    std_ulogic;
    iVGA        : in    aSharedRamAccess;
    oVGA        : out   aSharedRamReturn;
    oExtRam     : out   aRamAccess;
    bSRAMData   : inout std_logic_vector(31 downto 0)
    );
end entity;


architecture rtl of shram is
  
  signal   CPUIn   : aSharedRamAccess;
  signal   CPUOut  : aSharedRamReturn;
  signal   DataOut : aDword;
  signal   wrmask  : std_ulogic_vector(3 downto 0);
  signal   hready  : std_ulogic;
  constant abits   : integer := logXY(kbytes, 2) + 2;
  constant hconfig : ahb_config_type := (
    0      => ahb_device_reg (VENDOR_FHH, FHH_SHRAM, 0, abits+2, 0),
    4      => ahb_membar(haddr, '1', '1', hmask),
    others => zero32);
begin  -- rtl

  process (ahbsi, CPUOut)
  begin
    wrmask  <= "0000";
    DataOut <= (others => '-');
  --  if hindex = to_integer(unsigned(ahbsi.hsel)) then
      case ahbsi.htrans is
        when "01" | "10" | "11" =>
          DataOut <= (others => '0');
          case ahbsi.hsize is
            when "000" =>
              case to_integer(unsigned(ahbsi.haddr(1 downto 0))) is
                when 0 =>
                  DataOut(7 downto 0) <= CPUOut.Data(31 downto 24);
                  wrmask              <= "1000";
                when 1 =>
                  DataOut(7 downto 0) <= CPUOut.Data(23 downto 16);
                  wrmask              <= "0100";
                when 2 =>
                  DataOut(7 downto 0) <= CPUOut.Data(15 downto 8);
                  wrmask              <= "0010";
                when 3 =>
                  DataOut(7 downto 0) <= CPUOut.Data(7 downto 0);
                  wrmask              <= "0001";
                when others =>
                  null;
              end case;
            when "001" =>
              case ahbsi.haddr(1) is
                when '0' =>
                  DataOut(15 downto 0) <= CPUOut.Data(31 downto 16);
                  wrmask               <= "1100";
                when '1' =>
                  DataOut(15 downto 0) <= CPUOut.Data(15 downto 0);
                  wrmask               <= "0011";
                when others =>
                  assert false report "Metavalue detected" severity error;
              end case;
            when "010" =>
              DataOut <= CPUOut.data;
              wrmask  <= "1111";
            when others =>
              
              assert is_x(ahbsi.hsize) report "Wrong transfer size" severity error;
          end case;
        when others =>
          null;
      end case;
  --  end if;
    CPUIn <= (
      Addr      => std_ulogic_vector(ahbsi.haddr(cSRAMAddrWidth+1 downto 2)),
      Data      => aDword(ahbsi.hwdata),
      Rd        => '0',
      Wr        => '0',
      WriteMask => (others => '1'));

    -- if hindex = to_integer(unsigned(ahbsi.hsel)) then
    if ahbsi.hsel(hindex) = '1' then
      case ahbsi.htrans is
        when "10" | "11" =>
          CPUIn.Rd <= not ahbsi.hwrite;
          CPUIn.Wr <= ahbsi.hwrite;
        when others =>
          null;
      end case;
    end if;

    ahbso <= (
      hready  => CPUOut.ACK,                 -- transfer done
      hresp   => "00",                       -- response type
      hrdata  => std_logic_vector(DataOut),  -- read data bus
      hsplit  => (others => '0'),            -- split completion
      hcache  => '0',                        -- cacheable  
      hirq    => (others => '0'),
      hconfig => hconfig,
      hindex  => hindex);

  end process;

  Arbiter : entity DSO.SRamPriorityAccess
    port map (
      iClk        => iClkDesign,
      iResetAsync => iResetAsync,
      bSRAMData   => bSRAMData,
      oExtRam     => oExtRam,
      iVGA        => iVGA,
      oVGA        => oVGA,
      iCPU        => CPUIn,
      oCPU        => CPUOut);

  -- the external ram is clocked at minimum twice faster then the cpu
  hready <= not CPUOut.Busy when hindex = to_integer(unsigned(ahbsi.hsel)) else
            '0';
-- pragma translate_off
  bootmsg : report_version
    generic map ("shram" & tost(hindex) &
                 ": AHB shared SRAM Module for a framebuffer VGA " & tost(kbytes) & " kbytes");
-- pragma translate_on
end rtl;
