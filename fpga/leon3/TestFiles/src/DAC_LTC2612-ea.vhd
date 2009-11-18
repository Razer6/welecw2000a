-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DAC_LTC2612-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2009-03-23
-- Last update: 2009-11-15
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
-- 2009-03-23  1.0      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DAC_LTC2612 is
  generic (gUnusedDataBits : natural := 2);
  port (
    inCE : in  std_ulogic;
    iSCK : in  std_ulogic;
    iSD  : in  std_ulogic;
    iRef : in  real;
    oA   : out real;
    oB   : out real;
    iGND : in  real);
end entity;

architecture BHV of DAC_LTC2612 is
  signal Shift    : std_ulogic_vector(0 to 23);
  signal A, B     : std_ulogic_vector(15 downto gUnusedDataBits);
  signal Aen, Ben : std_ulogic;
  signal AU , BU  : std_ulogic;
  signal Ao, Bo   : real;
  
  function AnalogOut(constant iD   : std_ulogic_vector(15 downto gUnusedDataBits);
                     constant iOut : real;
                     constant iE   : std_ulogic;
                     constant iU   : std_ulogic;
                     constant iRef : real;
                     constant iGND : real) return real is
    constant cDenum : real := real(2**(16+1 - gUnusedDataBits));
    constant cRange : real := iRef - iGND;
    variable vRet   : real;
  begin
    if iE = '1' then
      if iU = '1' then
        vRet := real(to_integer(signed(iD)))*cRange/cDenum + iGND;
      else
        vRet := iOut;
      end if;
    else
      vRet := iGND;
    end if;
    return vRet;
  end;
  
  
begin
  
  process (iSCK)
    variable command : std_ulogic_vector(3 downto 0);
  begin
    if rising_edge(iSCK) then
      if inCE = '1' then
        for i in 0 to 3 loop
          command(i) := Shift(20 +i);
        end loop;
        case command is
          when X"0" | X"1" | X"2" | X"3" =>
            for i in gUnusedDataBits to 15 loop
              if Shift(16) = '1' then
                B(i) <= Shift(i);
              else
                A(i) <= Shift(i);
              end if;
            end loop;
          when others =>
            null;
        end case;

        Aen <= '1';
        Ben <= '1';
        AU  <= '0';
        BU  <= '0';
        case command is
          when X"4" =>
            if Shift(16) = '0' then
              Aen <= '0';
            else
              Ben <= '0';
            end if;
          when X"1" | X"3" =>
            if Shift(16) = '1' then
              AU <= '1';
            else
              BU <= '1';
            end if;
          when X"2" =>
            AU <= '1';
            BU <= '1';
          when others =>
            null;
        end case;
        
      else
        Shift(0)               <= iSD;
        Shift(1 to Shift'high) <= Shift(0 to Shift'high-1);
      end if;
    end if;
  end process;

  Ao <= AnalogOut(A, Ao, Aen, AU, iRef, iGND);
  Bo <= AnalogOut(B, Bo, Ben, BU, iRef, iGND);

  oA <= Ao;
  oB <= Bo;
  
end architecture;


