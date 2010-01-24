-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : AsyncSRAM-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-02-25
-- Last update: 2009-03-10
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: You can initialisize this ram with a raw binary file!
-------------------------------------------------------------------------------
--    GNU Lesser General Public License Version 3
--    =============================================
--
--    This library is free software; you can redistribute it and/or
--    modify it under the terms of the GNU Lesser General Public
--    License version 3, as published by the Free Software Foundation.
--
--    This library is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--    Lesser General Public License for more details.
--
--    You should have received a copy of the GNU Lesser General Public
--    License along with this library; if not, write to the Free Software
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston,
--    MA  02111-1307  USA
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version 
-- 2009-02-25  1.0      
-------------------------------------------------------------------------------


library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AsyncSRAM is
  generic (
    gFileName      : string  := "";
    gReverseEndian : boolean := false;
    gAddrWidth     : natural := 19);
--    gDataWidth : natural := 32);
  port (
    iAddr  : in    std_ulogic_vector(gAddrWidth-1 downto 0);
    bData  : inout std_logic_vector(32-1 downto 0);
    inCE   : in    std_ulogic;
    inWE   : in    std_ulogic;
    inOE   : in    std_ulogic;
    inMask : in    std_ulogic_vector(3 downto 0));
end entity;

architecture RTL of AsyncSRam is
  type aRam is array (0 to 2**gAddrWidth-1) of integer;
  type aFileHandle is file of character;

  impure function ReadDword(file Handle : aFileHandle) return integer is
    variable Ret : integer := 0;
    variable ch  : character;
  begin
    for i in 0 to 3 loop
      if endfile(Handle) = false then
        read(Handle, ch);
        Ret := Ret + character'pos(ch)*2**(8*i);
      end if;
    end loop;
    return Ret;
  end;

  impure function ReadREDword(file Handle : aFileHandle) return integer is
    variable Ret : integer := 0;
    variable ch  : character;
  begin
    for i in 0 to 3 loop
      if endfile(Handle) = false then
        read(Handle, ch);
        Ret := Ret + character'pos(ch)*2**(8*(3-i));
      end if;
    end loop;
    return Ret;
  end;

  impure function Init(constant cFileName : string) return aRam is
    variable Ret    : aRam;
    variable Status : file_open_status;
    variable i      : natural := 0;
    file Handle     : aFileHandle;
  begin
    file_open(Status, Handle, cFileName, read_mode);
    if (Status /= open_ok) then
      report "AsyncRAM File " & cFileName & " not found!" severity warning;
      return Ret;
    end if;
    report "AsyncRAM File " & cFileName & " opened!" severity note;
    if gReverseEndian = true then
      while endfile(Handle) = false and i < aRam'length loop
        Ret(i) := ReadREDword(Handle);
        i      := i+1;
      end loop;
    else
      while endfile(Handle) = false and i < aRam'length loop
        Ret(i) := ReadDword(Handle);
        i      := i+1;
      end loop;
    end if;
    report "AsyncRAM Initializated " & integer'image(i) & " Dwords." severity note;
    file_close(Handle);
    return Ret;
  end;

  signal Ram : aRam := Init(gFileName);
  
begin
  
  R : process (iAddr, inCE, inWE, inOE, inMask)
    variable vStore : signed(32-1 downto 0);
  begin
    bData <= (others => 'Z');
    if inCE = '0' then
      if is_x(iAddr) = true then
        bData <= (others => '0');
      else
        if inWE = '0' then
          vStore := to_signed(Ram(to_integer(unsigned(iAddr))), 32);
          for i in inMask'range loop
            if inMask(i) = '0' then
              vStore((i+1)*8-1 downto i*8) := signed(bData((i+1)*8-1 downto i*8));
            end if;
          end loop;
          Ram(to_integer(unsigned(iAddr))) <= to_integer(vStore);
        end if;
        if inOE = '0' then
          bData <= std_logic_vector(to_signed(Ram(to_integer(unsigned(iAddr))), 32));
        end if;
      end if;
    end if;
  end process;
end architecture;
