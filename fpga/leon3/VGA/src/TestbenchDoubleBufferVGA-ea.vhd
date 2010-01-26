-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : TestbenchDoubleBufferVGA-ea.vhd
-- Author     : Alexander  <alexander@alexander-laptop>
-- Created    : 2010-01-26
-- Last update: 2010-01-26
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2010, Alexander Lindert
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
-- 2010-01-26  1.0	
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;


library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library gaisler;
use gaisler.memctrl.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.libdcom.all;

library esa;
use esa.memoryctrl.all;

entity Testbench is
end entity;

architecture bhv of Testbench is

  constant VLEN   : integer := 480;
  constant HLEN   : integer := 640;
  constant VFRONT : integer := 16;
  constant HFRONT : integer := 16;
  constant VSYNC  : integer := 5;
  constant HSYNC  : integer := 10;
  constant HBACK  : integer := 10;
  constant VBACK  : integer := 10;

  constant VGA_ENABLE_BIT           : integer := 0;
  constant VGA_RESET_BIT            : integer := 1;
  constant VGA_VERTICAL_REFRESH_BIT : integer := 2;
  constant VGA_RUN_BIT              : integer := 3;
  constant VGA_PIXELSIZE0_BIT       : integer := 4;
  constant VGA_PIXELSIZE1_BIT       : integer := 5;
  constant VGA_CLOCKSEL0_BIT        : integer := 6;
  constant VGA_CLOCKSEL1_BIT        : integer := 7;
  constant VGA_H_POL_BIT            : integer := 8;
  constant VGA_V_POL_BIT            : integer := 9;


  signal   iClk        : std_ulogic                    := '1';
  signal   iResetAsync : std_ulogic                    := cResetActive;
 -- signal   VGASignal   : aVGASignal;
  signal   oDCLK       : std_ulogic;
  signal   oHD         : std_ulogic;
  signal   oVD         : std_ulogic;
  signal   oDENA       : std_ulogic;
  signal   oRed        : std_ulogic_vector(5 downto 3);
  signal   oGreen      : std_ulogic_vector(5 downto 3);
  signal   oBlue       : std_ulogic_vector(5 downto 3);
  signal   Data        : std_logic_vector(31 downto 0);
  constant Mask        : std_ulogic_vector(3 downto 0) := "0000";

  signal vgao      : apbvga_out_type;
  signal video_clk : std_logic;
  signal clk_sel   : std_logic_vector(1 downto 0);


  signal dmai   : ahb_dma_in_type;
  signal dmao   : ahb_dma_out_type;
  signal duarti : dcom_uart_in_type;
  signal duarto : dcom_uart_out_type;

  signal bD_SRAM : std_logic_vector(31 downto 0);
  signal memi    : memory_in_type;
  signal memo    : memory_out_type;


  signal apbi  : apb_slv_in_type;
  signal apbo  : apb_slv_out_vector := (others => apb_none);
  signal ahbsi : ahb_slv_in_type;
  signal ahbso : ahb_slv_out_vector := (others => ahbs_none);
  signal ahbmi : ahb_mst_in_type;
  signal ahbmo : ahb_mst_out_vector := (others => ahbm_none);


  signal rstn, clkm : std_ulogic;

  procedure WriteConfig(cAddr, cData :     integer;
                        signal iClk  : in  std_ulogic;
                        signal ou    : out dcom_uart_out_type) is
    variable Addr, Data : std_logic_vector(31 downto 0);
  begin
    Addr := std_logic_vector(to_signed(cAddr, 32));
    Data := std_logic_vector(to_signed(cData, 32));


    wait until iClk = '1';
    ou.dready <= '1';
    ou.data   <= (7 => '1', 6 => '1', others => '0');  -- Write 1 DWORD
    wait until iClk = '1';
    ou.data   <= Addr(31 downto 24);
    wait until iClk = '1';
    ou.data   <= Addr(23 downto 16);
    wait until iClk = '1';
    ou.data   <= Addr(15 downto 8);
    wait until iClk = '1';
    ou.data   <= Addr(7 downto 0);

    wait until iClk = '1';
    ou.dready <= '1';
    ou.data   <= Data(31 downto 24);
    wait until iClk = '1';
    ou.data   <= Data(23 downto 16);
    wait until iClk = '1';
    ou.data   <= Data(15 downto 8);
    wait until iClk = '1';
    ou.data   <= Data(7 downto 0);

    wait until iClk = '1';
    ou.dready <= '0';
    wait until iClk = '1';
    wait until iClk = '1';
    wait until iClk = '1';
    wait until iClk = '1';
    wait until iClk = '1';
    return;
    
  end procedure;
  
begin
  
  iClk        <= not iClk         after 1 sec / (100E6);
  iResetAsync <= not cResetActive after 4 sec / (100E6);
  clkm        <= iClk;
  video_clk   <= iClk;
  rstn        <= iResetAsync;

  ahb0 : ahbctrl                        -- AHB arbiter/multiplexer
    generic map (defmast => 0, split => 0,
                 rrobin  => 0, ioaddr => 16#FFF#,
                 nahbm   => 8, nahbs => 8)
    port map (rstn, clkm, ahbmi, ahbmo, ahbsi, ahbso);

  apb0 : apbctrl                        -- AHB/APB bridge
    generic map (hindex => 1, haddr => 16#800#)
    port map (rstn, clkm, ahbsi, ahbso(1), apbi, apbo);


  ahbmst0 : ahbmst
    generic map (hindex => 0, venid => VENDOR_GAISLER, devid => GAISLER_AHBUART)
    port map (rstn, clkm, dmai, dmao, ahbmi, ahbmo(0));
  
  dcom0 : dcom port map (rstn, clkm, dmai, dmao, duarti, duarto, ahbmi);
  -- dmao.ready <= '1';

  svga0 : entity DSO.DoubleBufferVGA
    generic map(memtech => 0, pindex => 0, paddr => 0,
                hindex  => 1,
                clk0    => 40000, clk1 => 1000000000,
                clk2    => 20000, clk3 => 15385, burstlen => 6)
    port map(rstn, clkm, video_clk, apbi, apbo(0), vgao, ahbmi,
             ahbmo(1), clk_sel);

  mg2 : srctrl
    generic map     -- (rmw => 1, prom8en => 0, srbanks => 1, banksz => 9)
    (hindex  => 0,
     romaddr => 0,
     rommask => 16#ff8#,
     ramaddr => 16#400#,
     rammask => 16#ffe#,
     ioaddr  => 16#200#,
     iomask  => 16#ffe#,
     ramws   => 0,
     romws   => 0,
     iows    => 0,
     rmw     => 0,                      -- read-modify-write enable
     prom8en => 0,
     oepol   => 0,
     srbanks => 1,
     banksz  => 9,
     romasel => 0)
    port map (rstn, clkm, ahbsi, ahbso(0), memi, memo, open);

  memi.data <= bD_SRAM after 1 ns;      -- when

  bD_SRAM <= memo.data after 1 ns when
             (memo.writen = '0' and memo.ramsn(0) = '0')
             else (others => 'Z');

  RAM : entity work.AsyncSRAM
    generic map (
      gFileName  => "Testp.ppm",
      gAddrWidth => 19)
    port map (
      iAddr  => std_ulogic_vector(memo.address(18 downto 0)),
      bData  => bD_SRAM,
      inCE   => memo.romn,
      inWE   => memo.writen,
      inOE   => memo.oen,
      inMask => Mask);

  process(memo.address)
  begin
    assert (to_integer(unsigned(memo.address)) /= 0) report "Addr = 0" severity note;
  end process;


  Config : process
  begin
    
    duarto <= (
      dready  => '0',
      tsempty => '0',
      lock    => '1',
      enable  => '1',
      data    => (others => '0'),
      others  => '0');
    wait until iResetAsync /= cResetActive;
    wait for 200 us;
    report "Start testing" severity note;
    WriteConfig(16#8000_0004#, (HLEN-1)*(2**16) + (VLEN-1), iClk, duarto);
    WriteConfig(16#8000_0008#, (HFRONT-1)*(2**16) + (VFRONT-1), iClk, duarto);
    WriteConfig(16#8000_000C#, (HSYNC-1)*(2**16) + (VSYNC-1), iClk, duarto);
    WriteConfig(16#8000_0010#, (HLEN+HFRONT+HSYNC+HBACK-1)*(2**16) + (VLEN+VFRONT+VSYNC+VBACK-1), iClk, duarto);
    WriteConfig(16#8000_0014#, 16#0000_0000#, iClk, duarto);
    WriteConfig(16#8000_0018#, 16#0202_0505#, iClk, duarto);
    WriteConfig(16#8000_001C#, 16#040C_0808#, iClk, duarto);
    WriteConfig(16#8000_0000#, 2**VGA_ENABLE_BIT + 2**VGA_RUN_BIT + 2**VGA_PIXELSIZE1_BIT + 2**VGA_PIXELSIZE0_BIT, iClk, duarto);


    wait;
  end process;
  

end architecture;
