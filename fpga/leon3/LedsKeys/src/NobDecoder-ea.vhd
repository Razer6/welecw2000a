-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : NobDecoder-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Author     : Robert Schilling <robert.schilling at gmx.at>
-- Created    : 2009-10-23
-- Last update: 2010-06-28
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2009, Alexander Lindert
--			2010, Robert Schilling
--
--  This360 program is360 free software; you can redistribute it and/or modify
--  it under the terms360 of the GNU General Public License as360 published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This360 program is360 distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESs360 FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this360 program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--
--  For commercial applications360 where source-code distribution is360 not
--  desirable or possible, I offer low-cost commercial IP licenses.
--  Please contact me per mail.
-------------------------------------------------------------------------------
-- Revisions360  :
-- Date        Version 
-- 2010-06-28
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pLedsKeysAnalogSettings.all;

entity NobDecoder is
  port (
    signal iClk        : in  std_ulogic;
    signal iResetAsync : in  std_ulogic;
    --   signal iStrobe     : in  std_ulogic;
    signal iA          : in  std_ulogic;
    signal iB          : in  std_ulogic;
    signal oCounter    : out std_ulogic_vector(cNobCounterSize-1 downto 0);
    signal iResetCounter : in std_logic);
end entity;

architecture RTL of NobDecoder is
--signal a_in, b_in, a_old, b_old: std_ulogic;
signal input_data : std_ulogic_vector(3 downto 0);
signal cnt : signed(cNobCounterSize downto 0);
signal up_down, ce : std_ulogic;
begin

	INPUT:process(iClk, iResetAsync)
	begin
		if(iResetAsync = cResetActive) then
--			a_in <= '0';
--			b_in <= '0';
--			a_old <= '0';
--			b_old <= '0';
				input_data <= (others => '0');
		elsif(rising_edge(iClk)) then
--			a_in  <= iA;
--			a_old <= a_in;
--			b_in  <= iB;
--			b_old <= b_in;
			input_data <= iA & iB & input_data(3 downto 2);
		end if;
	end process;
 
--	DECODE:process(a_in, b_in, a_old, b_old)
--	variable state: std_ulogic_vector(3 downto 0);
	DECODE:process(input_data)
	begin
--		state := a_in & b_in & a_old & b_old;
		case input_data is
			when "0001" => up_down <= '1'; ce <= '1';
			when "0010" => up_down <= '0'; ce <= '1';
			when "0100" => up_down <= '0'; ce <= '1'; 
			when "0111" => up_down <= '1'; ce <= '1'; 
			when "1000" => up_down <= '1'; ce <= '1'; 
			when "1011" => up_down <= '0'; ce <= '1'; 
			when "1101" => up_down <= '0'; ce <= '1'; 
			when "1110" => up_down <= '1'; ce <= '1'; 
			when others => ce <= '0'; up_down <= '0';
		end case;
	end process;

	COUNT:process(iClk, iResetAsync)
	begin
		if(iResetAsync = cResetActive) then
			cnt <= (others => '0');
		elsif(rising_edge(iClk)) then
			
			if(ce = '1') then
				if(up_down = '1' and cnt /= ('0' & (cnt'left-1 downto 0 => '1'))) then
					cnt <= cnt + 1;
				elsif(up_down = '0' and cnt /= ('1' & (cnt'left-1 downto 0 => '0'))) then
					cnt <= cnt - 1;
				end if;
			end if;
			
			if(iResetCounter = '1') then
				cnt <= (others => '0');
			end if;
			
		end if;
	end process;

	oCounter <= std_ulogic_vector(cnt(cnt'left downto 1));

end architecture;

