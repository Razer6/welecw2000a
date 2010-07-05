-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : SpecialFunctionRegisterFrontPanel-ea.vhd
-- Author     : Robert Schilling <robert.schilling at gmx.at>
-- Created    : 2010-06-28
-- Last update: 2009-06-28
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
--  Copyright (c) 2010, Robert Schilling
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
-- 2009-06-28  1.0      
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pSpecialFunctionRegister_Frontpanel.all;
use DSO.pLedsKeysAnalogSettings.all;



entity SpecialFunctionRegister_Frontpanel is
  port (
    iClkCPU       : in  std_ulogic;
    iClkDesign    : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iAddr         : in  aDword;
    iWr           : in  std_ulogic;
    iWrMask       : in  std_ulogic_vector(3 downto 0);
    iRd           : in  std_ulogic;
    iData         : in  aDword;
    oData         : out aDword;
    oCPUInterrupt : out std_ulogic;
    iSFRControl   : in  aSFR_Frontpanel_in;
    oSFRControl   : out aSFR_Frontpanel_out);
end entity;

architecture RTL of SpecialFunctionRegister_Frontpanel is
  signal SFRFrontpanelIn           : aSFR_Frontpanel_in;
  signal Leds                      : aLeds;
  signal PrevKeys 								 : aKeys;
  signal Addr                      : natural;
begin
  

  pInterrupt : process (iClkCPU, iResetAsync)
 
  begin
    if iResetAsync = cResetActive then
      oCPUInterrupt             <= '0';
    elsif rising_edge(iCLKCPU) then
      PrevKeys <= SFRFrontpanelIn.Keys;

      if SFRFrontpanelIn.Keys /= PrevKeys then
        oCPUInterrupt <= '1';
      else
        oCPUInterrupt <= '0';
      end if;
    end if;
  end process;


  Addr <= to_integer(unsigned(iAddr(6 downto 2)));
  oSFRControl.Leds           <= Leds;

  pWrite : process (iClkDesign, iResetAsync)
  begin
    if rising_edge(iClkDesign) then
      Leds.SetLeds <= '0';
      if iWr = '1' then
        case Addr is
          when cLedAddr =>
            Leds <= (
              SetLeds        => '1',
              LED_CH0        => iData(0),
              LED_CH1        => iData(1),
              LED_CH2        => iData(2),
              LED_CH3        => iData(3),
              LED_MATH       => iData(4),
              LED_QUICKMEAS  => iData(5),
              LED_CURSORS    => iData(6),
              LED_WHEEL      => iData(7),
              LED_PULSEWIDTH => iData(8),
              LED_EDGE       => iData(9),
              RUN_GREEN      => iData(10),
              RUN_RED        => iData(11),
              SINGLE_GREEN   => iData(12),
              SINGLE_RED     => iData(13));
         when others => null;
        end case;
      end if;
    end if;
  end process;
  
  pResetEnc : process(iClkCPU, iResetAsync)
  begin
		if(rising_edge(iClkCPU)) then
			oSFRControl.iResetEnc <= (others => '0');
			if(iRd = '1') then
				case Addr is
					when cEncAddrMisc =>
						oSFRControl.iResetEnc(0) <= '1';
					when cEncAddrVoltage =>
						oSFRControl.iResetEnc(1) <= '1';
					when cEncAddrUpDown =>
						oSFRControl.iResetEnc(2) <= '1';
					when others => null;
				end case;
			end if;
		end if;
  end process;


  pPipelineRegsIn : process (iClkCPU, iResetAsync)
  begin
    if rising_edge(iCLKCPU) then
      SFRFrontpanelIn <= iSFRControl;
    end if;
  end process;
  
  pRead  : process (Addr, Leds, SFRFrontpanelIn, iRd)
  --pRead : process(iClkCPU, iResetAsync)
  begin
--		if(rising_edge(iClkCPU)) then
--		if(iRd = '1') then
			oData <= (others => '0');
			case Addr is
				when cLedAddr =>
					oData(0)  <= Leds.LED_CH0;
					oData(1)  <= Leds.LED_CH1;
					oData(2)  <= Leds.LED_CH2;
					oData(3)  <= Leds.LED_CH3;
					oData(4)  <= Leds.LED_MATH;
					oData(5)  <= Leds.LED_QUICKMEAS;
					oData(6)  <= Leds.LED_CURSORS;
					oData(7)  <= Leds.LED_WHEEL;
					oData(8)  <= Leds.LED_PULSEWIDTH;
					oData(9)  <= Leds.LED_EDGE;
					oData(10) <= Leds.RUN_GREEN;
					oData(11) <= Leds.RUN_RED;
					oData(12) <= Leds.SINGLE_GREEN;
					oData(13) <= Leds.SINGLE_RED;
							
				when cKeyAddr =>
					oData(0)  <= SFRFrontpanelIn.Keys.BTN_F1;
					oData(1)  <= SFRFrontpanelIn.Keys.BTN_F2;
					oData(2)  <= SFRFrontpanelIn.Keys.BTN_F3;
					oData(3)  <= SFRFrontpanelIn.Keys.BTN_F4;
					oData(4)  <= SFRFrontpanelIn.Keys.BTN_F5;
					oData(5)  <= SFRFrontpanelIn.Keys.BTN_F6;
					oData(6)  <= SFRFrontpanelIn.Keys.BTN_MATH;
					oData(7)  <= SFRFrontpanelIn.Keys.BTN_CH0;
					oData(8)  <= SFRFrontpanelIn.Keys.BTN_CH1;
					oData(9)  <= SFRFrontpanelIn.Keys.BTN_CH2;
					oData(10) <= SFRFrontpanelIn.Keys.BTN_CH3;
					oData(11) <= SFRFrontpanelIn.Keys.BTN_MAINDEL;
					oData(12) <= SFRFrontpanelIn.Keys.BTN_RUNSTOP;
					oData(13) <= SFRFrontpanelIn.Keys.BTN_SINGLE;
					oData(14) <= SFRFrontpanelIn.Keys.BTN_CURSORS;
					oData(15) <= SFRFrontpanelIn.Keys.BTN_QUICKMEAS;
					oData(16) <= SFRFrontpanelIn.Keys.BTN_ACQUIRE;
					oData(17) <= SFRFrontpanelIn.Keys.BTN_DISPLAY;
					oData(18) <= SFRFrontpanelIn.Keys.BTN_EDGE;
					oData(19) <= SFRFrontpanelIn.Keys.BTN_MODECOUPLING;
					oData(20) <= SFRFrontpanelIn.Keys.BTN_AUTOSCALE;
					oData(21) <= SFRFrontpanelIn.Keys.BTN_SAVERECALL;
					oData(22) <= SFRFrontpanelIn.Keys.BTN_QUICKPRINT;
					oData(23) <= SFRFrontpanelIn.Keys.BTN_UTILITY;
					oData(24) <= SFRFrontpanelIn.Keys.BTN_PULSEWIDTH;
					oData(25) <= SFRFrontpanelIn.Keys.BTN_X1;
					oData(26) <= SFRFrontpanelIn.Keys.BTN_X2;
					
				when cEncAddrMisc =>
					oData(7 downto 0) <= SFRFrontpanelIn.Keys.EN_TIME_DIV;
					oData(15 downto 8) <= SFRFrontpanelIn.Keys.EN_F;
					oData(23 downto 16) <= SFRFrontpanelIn.Keys.EN_LEVEL;
					oData(31 downto 24) <= SFRFrontpanelIn.Keys.EN_LEFT_RIGHT;
							
				when cEncAddrVoltage =>
					oData(7 downto 0) <= SFRFrontpanelIn.Keys.EN_CH0_VDIV;
					oData(15 downto 8) <= SFRFrontpanelIn.Keys.EN_CH1_VDIV;
					oData(23 downto 16) <= SFRFrontpanelIn.Keys.EN_CH2_VDIV;
					oData(31 downto 24) <= SFRFrontpanelIn.Keys.EN_CH3_VDIV;
					
				when cEncAddrUpDown =>
					oData(7 downto 0) <= SFRFrontpanelIn.Keys.EN_CH0_UPDN;
					oData(15 downto 8) <= SFRFrontpanelIn.Keys.EN_CH1_UPDN;
					oData(23 downto 16) <= SFRFrontpanelIn.Keys.EN_CH2_UPDN;
					oData(31 downto 24) <= SFRFrontpanelIn.Keys.EN_CH3_UPDN;
							
				when others => oData <= (others => '-');
			end case;
--			end if;
--		end if;
  end process;
    
end architecture;
