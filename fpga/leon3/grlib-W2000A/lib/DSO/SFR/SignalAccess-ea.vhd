-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SignalAccess-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2010-02-09
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

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library DSO;
use DSO.Global.all;
use DSO.pSFR.all;
use DSO.pTrigger.all;


entity SignalAccess is
  generic (
    hindex : integer := 0;              -- Leon3 index
    haddr  : integer := 0;              -- Leon3 address
    hmask  : integer := 16#FFF#;        -- Leon3 mask
    kbytes : integer := 32
    );
  port (
    rst_in      : in  std_ulogic;       -- Global reset, active low
    clk_i       : in  std_ulogic;       -- Global clock
    ahbsi       : in  ahb_slv_in_type;
    ahbso       : out ahb_slv_out_type;
    iClkDesign  : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iTriggerMem : in  aTriggerMemOut;
    oTriggerMem : out aTriggerMemIn
    );
end entity;


architecture rtl of SignalAccess is
  -- pipelining signals 
  signal   AHBout  : ahb_slv_out_type;
  signal   MemIn   : aTriggerMemIn;
  -- other signals
  signal   DataOut : aDword;
  signal   hready  : std_ulogic;
  constant abits   : integer := logXY(kbytes, 2) + 2;
  constant hconfig : ahb_config_type := (
    0      => ahb_device_reg (VENDOR_LINDERT, LINDERT_DSO_SIGNALACCESS, 0, abits+2, 0),
    4      => ahb_membar(haddr, '1', '1', hmask),
    others => zero32);
  signal hsel   : std_ulogic;
  signal htrans : std_ulogic_vector(1 downto 0);
  signal hsize  : std_ulogic_vector(2 downto 0);
  signal align  : std_ulogic_vector(1 downto 0);
  
begin  -- rtl
  
  process (clk_i, rst_in)
  begin
    if rst_in = '0' then
      hsel   <= '0';
      htrans <= "00";
      hsize  <= "010";
      align  <= "00";
    elsif rising_edge(clk_i) then
--      if ahbsi.hready = '1' then
      if ahbsi.hsel(hindex) = '1' then
        hsel   <= '1';
        htrans <= std_ulogic_vector(ahbsi.htrans);
        hsize  <= std_ulogic_vector(ahbsi.hsize);
        align  <= std_ulogic_vector(ahbsi.haddr(1 downto 0));
      elsif iTriggerMem.ACK = '1' then
        hsel <= '0';
      end if;
--      end if;
    end if;
  end process;


  process (ahbsi, iTriggerMem, hsel, htrans, hsize, align)
  begin
    DataOut <= (others => '-');
--    if hsel = '1' then
    case htrans is
      when "01" | "10" | "11" =>
        DataOut <= (others => '0');
        case hsize is
          when "000" =>
            case to_integer(unsigned(align(1 downto 0))) is
              when 0 =>
                DataOut(7 downto 0) <= iTriggerMem.Data(31 downto 24);
              when 1 =>
                DataOut(7 downto 0) <= iTriggerMem.Data(23 downto 16);
              when 2 =>
                DataOut(7 downto 0) <= iTriggerMem.Data(15 downto 8);
              when 3 =>
                DataOut(7 downto 0) <= iTriggerMem.Data(7 downto 0);
              when others =>
                null;
            end case;
          when "001" =>
            case align(1) is
              when '0' =>
                DataOut(15 downto 0) <= iTriggerMem.Data(31 downto 16);
              when '1' =>
                DataOut(15 downto 0) <= iTriggerMem.Data(15 downto 0);
              when others =>
                assert false report "Metavalue detected" severity error;
            end case;
          when "010" =>
            DataOut <= iTriggerMem.data;
          when others =>
            assert is_x(hsize) report "Wrong transfer size" severity error;
        end case;
      when others =>
        null;
    end case;
--    end if;


    if is_x(ahbsi.haddr) then
      MemIn.Addr <= (others => '0');
    else
      MemIn.Addr <= aTriggerAddr(ahbsi.haddr(aTriggerAddr'length+1 downto 2));
    end if;

    MemIn.Rd <= '0';
    if ahbsi.hsel(hindex) = '1' then
      case ahbsi.htrans is
        when "10" | "11" =>
          MemIn.Rd <= not ahbsi.hwrite;
        when others =>
          null;
      end case;
    end if;
  end process;
  
  AHBout <= (
    --hready  => iTriggerMem.ACK,            -- transfer done
    hready  => hready,
    hresp   => "00",                       -- response type
    hrdata  => std_logic_vector(DataOut),  -- read data bus
    hsplit  => (others => '0'),            -- split completion
    hcache  => '0',                        -- cacheable  
    hirq    => (others => '0'),
    hconfig => hconfig,
    hindex  => hindex);

  hready      <= (iTriggerMem.ACK or (not hsel)) and (not ahbsi.hsel(hindex));
  ahbso       <= AHBout;
  oTriggerMem <= MemIn;

--  Pipelining : process (clk_i, rst_in)
--  begin
--    if rst_in = '0' then
--      ahbso <= (
--        hready  => '1',
--        hresp   => "00",              -- response type
--        hrdata  => (others => '0'),     -- read data bus
--        hsplit  => (others => '0'),     -- split completion
--        hcache  => '0',                 -- cacheable  
--        hirq    => (others => '0'),
--        hconfig => hconfig,
--        hindex  => hindex);
--      oTriggerMem <= (
--        Addr => (others => '0'),
--        Rd   => '0');     
--    elsif rising_edge(clk_i) then
--      ahbso       <= AHBout;
--      oTriggerMem <= MemIn;
--    end if;
--  end process;



-- pragma translate_off
  Simul : block
    signal DrawData0 : aByte;
    signal DrawData1 : aByte;
    signal DrawData2 : aByte;
    signal DrawData3 : aByte;
--    signal prev      : std_ulogic;
  begin
    
    process (clk_i)
    begin
      if rising_edge(clk_i) then
--        prev <= hready;
        if iTriggerMem.ACK = '1' then
          DrawData3 <= Dataout(7 downto 0);
          DrawData2 <= Dataout(15 downto 8);
          DrawData1 <= Dataout(23 downto 16);
          DrawData0 <= Dataout(31 downto 24);
        end if;
      end if;
    end process;

    bootmsg : report_version
      generic map ("SignalAccess" & tost(hindex) &
                   ": AHB DSO triggered data readonly access " & tost(kbytes) & " kbytes");
  end block;
-- pragma translate_on
end rtl;
