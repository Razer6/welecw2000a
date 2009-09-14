-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-16
-- Last update: 2009-09-11
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
-- 2008-08-16  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pFastFirCoeff.all;
use DSO.pPolyphaseDecimator.all;

entity DownSampler is
  port (
    iClk          : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iEnableFilter : in  std_ulogic_vector(0 to cDecimationStages-1);
    iDecimation   : in  aM(0 to cDecimationStages-1);
    iStageValid0  : in  std_ulogic;
    iStageData0   : in  aLongFastData;
    iStage        : in  aStageInputs;
    oStage        : out aStageOutputs;
    oData         : out aLongValues(0 to cCoefficients-1);
    oValid        : out std_ulogic);
end entity;

architecture RTL of DownSampler is
  
  signal StageData0     : aValues(0 to cCoefficients-1);
  signal StageValid0    : std_ulogic;
  signal Stage          : aStageInputs;
  signal Aliasing       : aStages;
  signal DataOutCounter : natural range 0 to cCoefficients-1;
  signal DataOut        : aLongValues(0 to cCoefficients-1);
begin
  
  process (Stage, iDecimation)
  begin
    for i in 0 to cDecimationStages-2 loop
      oStage(i).Data <= Stage(i).Data;
      if iDecimation(i+1) = M1 then
        oStage(i).Valid <= '0';
      else
        oStage(i).Valid <= Stage(i).Valid;
      end if;
    end loop;
  end process;


  process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      Aliasing <= (others => (
        Counter           => cCoefficients-1,
        Data              => (others => '0'),
        Valid             => '0'));
      Stage <= (others => (
        Data           => (others => '0'),
        Valid          => '0'));
      DataOut <= (others => (others => '0'));
      oValid  <= '0';
      
    elsif rising_edge(iClk) then
     
      Stage(0) <= iStage(0);

      for m in 1 to cDecimationStages-1 loop
        -- Stage output
        if iEnableFilter(m) = '1' and iDecimation(m) /= M1 then
          Stage(m) <= iStage(m);
        else
          Stage(m).Valid <= Aliasing(m).Valid;
          Stage(m).Data  <= Aliasing(m).Data;
        end if;

        -- Decimation without filtering
        Aliasing(m).Valid <= '0';
        if Stage(m-1).Valid = '1' then
          if Aliasing(m).Counter /= 0 then
            Aliasing(m).Counter <= (Aliasing(m).Counter -1);
            Aliasing(m).Valid   <= '0';
          else
            case iDecimation(m) is
              when M1  => Aliasing(m).Counter <= 0;
              when M2  => Aliasing(m).Counter <= 2-1;
              when M4  => Aliasing(m).Counter <= 4-1;
              when M10 => Aliasing(m).Counter <= 10-1;
            end case;
            Aliasing(m).Valid <= '1';
            Aliasing(m).Data  <= Stage(m-1).Data;
          end if;
        end if;
        
      end loop;

      -- downsampler output
      if iDecimation(0) = M1 or iDecimation(0) = M2 or iDecimation(0) = M4 then
        DataOut <= iStageData0;
        oValid  <= iStageValid0;
      else
        oValid <= '0';
        if Stage(Stage'high).Valid = '1' then
          DataOut        <= DataOut(1 to cCoefficients-1) & Stage(Stage'high).Data;
          DataOutCounter <= (DataOutCounter +1) mod cCoefficients;
          if DataOutCounter = 0 then
            oValid <= '1';
          end if;
        end if;
      end if;
      
    end if;
  end process;

  oData <= DataOut;

end architecture;
