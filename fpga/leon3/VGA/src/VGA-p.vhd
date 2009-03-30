-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : VGA-p.vhd
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

use work.global.all;

package pVGA is
  
  
  type acGenVga is record
                     -- Frequency of main clock
                     ClkFreq              : natural;
                     -- Definitions for VGA horizontal and vertical timing are given in pixel
                     -- and line units respectively
                     FrameRate            : natural;  -- Hz
                     FrontPorchPixels     : natural;  -- Pixels with zero offset
                     HsyncPixels          : natural;  -- Pixels
                     BackPorchPixels      : natural;  -- Pixels
                     VisiblePixelsPerLine : natural;  -- Pixels
                     FrontPorchLines      : natural;  -- Lines
                     VsyncLines           : natural;  -- Lines
                     BackPorchLines       : natural;  -- Lines
                     VisibleLines         : natural;  -- Lines
                     -- Color resolution
                     BitsPerColor         : natural;
                   end record;
  
  constant cGenVga : acGenVga := (
    -- Frequency of main clock
    ClkFreq              => 125E6,
    -- Definitions for VGA horizontal and vertical timing are given in pixel
    -- and line units respectively
    FrameRate            => 60,         -- Hz
    FrontPorchPixels     => 0,
    HsyncPixels          => 1,
    BackPorchPixels      => 7,
    VisiblePixelsPerLine => 640,
    FrontPorchLines      => 1,
    VsyncLines           => 1,
    BackPorchLines       => 8,
    VisibleLines         => 480,
    -- Color resolution
    BitsPerColor         => 2);
  constant cVGAMemStart : natural := 2**(21-2)-(cGenVGA.VisiblePixelsPerLine*cGenVGA.VisibleLines*6/(4*8));
  constant cVGAMemEnd   : natural := 2**(21-2)-1;

  type aVGASignal is record
                       DCLK  : std_ulogic;
                       HD    : std_ulogic;
                       VD    : std_ulogic;
                       DENA  : std_ulogic;
                       Red   : std_ulogic_vector(cGenVGA.BitsPerColor-1 downto 0);
                       Green : std_ulogic_vector(cGenVGA.BitsPerColor-1 downto 0);
                       Blue  : std_ulogic_vector(cGENVGA.BitsPerColor-1 downto 0);
                     end record;
end;
