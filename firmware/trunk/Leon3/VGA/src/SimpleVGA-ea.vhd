-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SimpleVGA-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-14
-- Last update: 2009-03-04
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
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pSRamPriorityAccess.all;
use DSO.pVGA.all;

entity SimpleVGA is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    oMem        : out aSharedRamAccess;
    iMem        : in  aSharedRamReturn;
    oVGASignal  : out aVGASignal);
end entity;

architecture RTL of SimpleVGA is
  constant cRowBitWidth  : natural := LogXY(cGenVga.VisiblePixelsPerLine, 2);
  constant cLineBitWidth : natural := LogXY(cGenVga.VisibleLines, 2);
  type     aState is (FrontPorch, SyncPulse, BackPorch, Visible);
  type     aRowGenVga is record
                           State     : aState;
                           Reference : unsigned(cRowBitWidth-1 downto 0);
                           Counter   : unsigned(cRowBitWidth-1 downto 0);
                           Strobe    : std_ulogic;
                           HSync     : std_ulogic;
                         end record;
  
  type aLineGenVga is record
                        State       : aState;
                        Reference   : unsigned(cLineBitWidth-1 downto 0);
                        Counter     : unsigned(cLineBitWidth-1 downto 0);
                        CountEnable : std_ulogic;
                        Strobe      : std_ulogic;
                        VSync       : std_ulogic;
                      end record;
  
  signal VGARow, NextVGARow   : aRowGenVga;
  signal VGALine, NextVGALine : aLineGenVga;
  signal nGenVGASignals       : std_ulogic;
  -- signal PixelRowCounter      : std_ulogic;
  signal PixelStrobe          : std_ulogic;
  signal PixelClockCounter    : unsigned(2 downto 0);
  signal PrevMemBusy          : std_ulogic;

  subtype aPixel is std_ulogic_vector(5 downto 0);
  type    aPixels is array(natural range<>) of aPixel;
  subtype aFetchState is natural range 0 to 3;

  type aBuffer is record
                    ReadReq     : std_ulogic;
                    FetchPixels : aPixels(0 to 15);
                    FetchState  : aFetchState;
                    --             AllFetched  : std_ulogic;
                    Pixels      : aPixels(0 to 15);
                    OutputPixel : aPixel;
                    MemAddr     : unsigned(31 downto 0);
                    PixelAddr   : natural range 0 to 15;
                  end record;
  signal Cache : aBuffer;
begin
  ---------------------------------------------------------------------------------------
  -- This VGA shares here the external RAM with the CPU 
  ---------------------------------------------------------------------------------------
  
  oVGASignal.Red   <= Cache.OutputPixel(5 downto 4);
  oVGASignal.Green <= Cache.OutputPixel(3 downto 2);
  oVGASignal.Blue  <= Cache.OutputPixel(1 downto 0);

  oMem.Data      <= (others => '-');
  oMem.WriteMask <= (others => '-');
  oMem.Wr        <= '0';
  oMem.Addr      <= std_ulogic_vector(Cache.MemAddr(oMem.Addr'range));
  oMem.Rd        <= Cache.ReadReq;
  oVGASignal.DENA          <= '1';

  pOutput : process (iClk, iResetAsync) is
    constant cInitCache : aBuffer := (
      ReadReq     => '0',
      FetchPixels => (others => (others => '0')),
      FetchState  => 3,
      --  AllFetched  => '0',
      Pixels      => (others => (others => '0')),
      OutputPixel => (others => '0'),
      MemAddr     => to_unsigned(cVGAMemStart+6, Cache.MemAddr'length),
      PixelAddr   => 0);

  begin
    if iResetAsync = cResetActive then
      PrevMemBusy    <= '0';
      oVGASignal.HD            <= '0';
      oVGASignal.VD            <= '0';
      oVGASignal.DCLK          <= '0';
      Cache          <= cInitCache;
      nGenVGASignals <= cHighInactive;
    elsif rising_edge(iClk) then
      Cache.ReadReq  <= '0';
      PrevMemBusy    <= iMem.Busy;
      nGenVGASignals <= cLowActive;

      if PixelStrobe = '1' and VGARow.State = Visible and VGALine.State = Visible then
        Cache.PixelAddr   <= (Cache.PixelAddr + 1) mod 16;
        Cache.OutputPixel <= Cache.Pixels(Cache.PixelAddr);
      end if;

      case Cache.FetchState is
        when 0 =>
          if iMem.Busy = '0' and PrevMemBusy = '1' then
            Cache.FetchState                 <= 1;
            Cache.ReadReq                    <= '1';
            Cache.FetchPixels(0)             <= iMem.Data(5 downto 0);
            Cache.FetchPixels(1)             <= iMem.Data(11 downto 6);
            Cache.FetchPixels(2)             <= iMem.Data(17 downto 12);
            Cache.FetchPixels(3)             <= iMem.Data(23 downto 18);
            Cache.FetchPixels(4)             <= iMem.Data(29 downto 24);
            Cache.FetchPixels(5)(1 downto 0) <= iMem.Data(31 downto 30);
            if to_integer(Cache.MemAddr) = cVGAMemEnd then
              Cache.MemAddr <= to_unsigned(cVGAMemStart, Cache.MemAddr'length);
            else
              Cache.MemAddr <= Cache.MemAddr + to_unsigned(1, Cache.MemAddr'length);
            end if;
          end if;
        when 1 =>
          if iMem.Busy = '0' and PrevMemBusy = '1' then
            Cache.FetchState                  <= 2;
            Cache.ReadReq                     <= '1';
            Cache.FetchPixels(5)(5 downto 2)  <= iMem.Data(3 downto 0);
            Cache.FetchPixels(6)              <= iMem.Data(9 downto 4);
            Cache.FetchPixels(7)              <= iMem.Data(15 downto 10);
            Cache.FetchPixels(8)              <= iMem.Data(21 downto 16);
            Cache.FetchPixels(9)              <= iMem.Data(27 downto 22);
            Cache.FetchPixels(10)(3 downto 0) <= iMem.Data(31 downto 28);
            if to_integer(Cache.MemAddr) = cVGAMemEnd then
              Cache.MemAddr <= to_unsigned(cVGAMemStart, Cache.MemAddr'length);
            else
              Cache.MemAddr <= Cache.MemAddr + to_unsigned(1, Cache.MemAddr'length);
            end if;
          end if;
        when 2 =>
          if iMem.Busy = '0' and PrevMemBusy = '1' then
            Cache.FetchState                  <= 3;
            Cache.FetchPixels(10)(5 downto 4) <= iMem.Data(1 downto 0);
            Cache.FetchPixels(11)             <= iMem.Data(7 downto 2);
            Cache.FetchPixels(12)             <= iMem.Data(13 downto 8);
            Cache.FetchPixels(13)             <= iMem.Data(19 downto 14);
            Cache.FetchPixels(14)             <= iMem.Data(25 downto 20);
            Cache.FetchPixels(15)             <= iMem.Data(31 downto 26);
            if to_integer(Cache.MemAddr) = cVGAMemEnd then
              Cache.MemAddr <= to_unsigned(cVGAMemStart, Cache.MemAddr'length);
            else
              Cache.MemAddr <= Cache.MemAddr + to_unsigned(1, Cache.MemAddr'length);
            end if;
            --        Cache.AllFetched                  <= '1';
          end if;
        when 3 =>
          if Cache.PixelAddr = 15 then
            Cache.FetchState <= 0;
            Cache.Pixels     <= Cache.FetchPixels;
            Cache.ReadReq    <= '1';
          end if;
      end case;

      oVGASignal.HD <= VGARow.HSync;
      oVGASignal.VD <= VGALine.VSync;
      if PixelClockCounter > 2 then
        oVGASignal.DCLK <= '1';
      else
        oVGASignal.DCLK <= '0';
      end if;
      
    end if;
  end process;

  ---------------------------------------------------------------------------------------
  -- upcounting StrobeGens 
  ---------------------------------------------------------------------------------------
  pPixelStrobe : entity work.Strobegen_var
    generic map (gBitWidth => 3)
    port map (
      iClk         => iClk,
      iResetAsync  => iResetAsync,
      iResetSync   => nGenVGASignals,   -- CounterReset is always made perfectly itself
      iCountEnable => '1',
      iReference   => O"4",             -- here everytime must be the correct Reference
      oCounter     => PixelClockCounter,
      oStrobe      => PixelStrobe);


  pRowStrobe : entity work.Strobegen_var
    generic map (gBitWidth => cRowBitWidth)
    port map (
      iClk         => iClk,
      iResetAsync  => iResetAsync,
      iResetSync   => nGenVGASignals,    -- CounterReset is always made perfectly itself
      iCountEnable => PixelStrobe,
      iReference   => VGARow.Reference,  -- here everytime must be the correct Reference
      oCounter     => VGARow.Counter,
      oStrobe      => VGARow.Strobe);

  pLineStrobe : entity work.Strobegen_var
    generic map (gBitWidth => cLineBitWidth)
    port map (
      iClk         => iClk,
      iResetAsync  => iResetAsync,
      iResetSync   => nGenVGASignals,   -- CounterReset is always made perfectly itself
      iCountEnable => VGALine.CountEnable,  -- the Strobe is only active if iCountEnable is
                                            -- active, too!
      iReference   => VGALine.Reference,  -- here everytime must be the correct Reference
      oCounter     => VGALine.Counter,
      oStrobe      => VGALine.Strobe);

-----------------------------------------------------------------------------------------
-- The horizontal move
-----------------------------------------------------------------------------------------
  pRow : process (VGARow) is
  begin
    NextVGARow.State     <= VGARow.State;
    NextVGARow.Reference <= VGARow.Reference;
    NextVGARow.HSync     <= '0';

    case VGARow.State is
      when FrontPorch =>
        NextVGARow.State <= SyncPulse;
      when SyncPulse =>
        NextVGARow.HSync <= '1';
        NextVGARow.State <= BackPorch;
      when BackPorch =>
        NextVGARow.Reference <= unsigned(to_signed(cGenVga.BackPorchPixels-1, cRowBitWidth));
        if VGARow.Strobe = '1' then
          NextVGARow.State <= Visible;
        end if;
      when Visible =>
        NextVGARow.Reference <= unsigned(to_signed(cGenVga.VisiblePixelsPerLine-1, cRowBitWidth));
        if VGARow.Strobe = '1' then
          NextVGARow.State <= FrontPorch;
        end if;
    end case;
  end process;

  pRowReg : process (iClk, iResetAsync) is
  begin
    if iResetAsync = cResetActive then
      VGARow.State     <= FrontPorch;
--      VGARow.Reference <= to_unsigned(cGenVga.FrontPorchPixels-1, cRowBitWidth);
      VGARow.Reference <= (others => '0');
      VGARow.HSync     <= '0';
    elsif rising_edge(iClk) then
      VGARow.State     <= NextVGARow.State;
      VGARow.Reference <= NextVGARow.Reference;
      VGARow.HSync     <= NextVGARow.HSync;
    end if;
  end process;
  ---------------------------------------------------------------------------------------
  -- The vertical move
  ---------------------------------------------------------------------------------------
  pNextLine : process (VGARow) is
  begin
    if VGARow.State = Visible and VGARow.Strobe = '1' then
      VGALine.CountEnable <= '1';
    else
      VGALine.CountEnable <= '0';
    end if;
  end process;

  pLine : process (VGALine) is
  begin
    NextVGALine.State     <= VGALine.State;
    NextVGALine.Reference <= VGALine.Reference;
    NextVGALine.VSync     <= '0';

    case VGALine.State is
      when FrontPorch =>
        NextVGALine.State <= SyncPulse;
      when SyncPulse =>
        NextVGALine.State <= BackPorch;
        NextVGALine.VSync <= '1';
      when BackPorch =>
        NextVGALine.Reference <= unsigned(to_signed(cGenVga.BackPorchLines-1, cLineBitWidth));
        if VGALine.Strobe = '1' then
          NextVGALine.State <= Visible;
        end if;
      when Visible =>
        NextVGALine.Reference <= unsigned(to_signed(cGenVga.VisibleLines-1, cLineBitWidth));
        if VGALine.Strobe = '1' then
          NextVGALine.State <= SyncPulse;
        end if;
    end case;

  end process;

  pLineReg : process (iClk, iResetAsync) is
  begin
    if iResetAsync = cResetActive then
      VGALine.State     <= FrontPorch;
      VGALine.Reference <= to_unsigned(cGenVga.FrontPorchLines-1, cLineBitWidth);
      VGALine.VSync     <= '0';
    elsif rising_edge(iClk) then
      VGALine.State     <= NextVGALine.State;
      VGALine.Reference <= NextVGALine.Reference;
      VGALine.VSync     <= NextVGALine.VSync;
    end if;
  end process;
  
end architecture;
