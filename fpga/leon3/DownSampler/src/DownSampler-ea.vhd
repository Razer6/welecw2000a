-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-16
-- Last update: 2009-07-07
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
  
  signal AliasAvgCounter : integer range 0 to 9;
  signal AliasAvg        : aFastData;
  signal AliasAvgValid   : std_ulogic;

  signal StageData0     : aValues(0 to cCoefficients-1);
  signal StageValid0    : std_ulogic;
  signal Stage          : aStageInputs;
  signal Aliasing       : aStages;
--  signal StageInputCounter : natural range 0 to cCoefficients-1;
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
      --     AliasAvgCounter <= 0;
--      AliasAvg        <= (others => (others => '0'));
--      AliasAvgValid   <= '0';
      --     StageData0      <= (others => (others => '0'));
      --     StageValid0     <= '0';
      Aliasing <= (others => (
        Counter           => cCoefficients-1,
        Data              => (others => '0'),
        Valid             => '0'));
      Stage <= (others => (
        Data           => (others => '0'),
        Valid          => '0'));
--      StageInputCounter <= cCoefficients-1;
      DataOut <= (others => (others => '0'));
      oValid  <= '0';
      
    elsif rising_edge(iClk) then

--      if iEnableFilter(0) = '1' then
--        StageValid0 <= iStageValid0;
--        for i in StageData0'range loop
--          StageData0(i) <= iStageData0(i);
--        end loop;
--      else
--        StageValid0 <= AliasAvgValid;
--        for i in StageData0'range loop
--          StageData0(i) <= signed(AliasAvg(i));
--        end loop;
--      end if;


--      if iEnableFilter(0) = '1' then
--        Stage(0) <= iStage(0);
--      else
--        Stage(0).Data(cBitWidth*2-1 downto cBitWidth) <= AliasAvg(0);
--        Stage(0).Data(cBitWidth-1 downto 0)           <= (others => '0');
--        Stage(0).Valid                                <= AliasAvgValid;
--      end if;
      
      Stage(0) <= iStage(0);
--      Stage(0).Valid <= iStage(0).Valid or iStageValid0;

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
      --   if iDecimation(1 to cDecimationStages-1) = cM1 then
      if iDecimation(0) /= M10 then
        --  for i in DataOut'range loop
        --   DataOut(i)(cBitWidth*2-1 downto cBitWidth) <= iStageData0(i);
        --   DataOut(i)(cBitWidth-1 downto 0)           <= (others => '0');
        -- end loop;
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

--      AliasAvgValid <= '1';
--      AliasAvg      <= (others => (others => '0'));
--      case iDecimation(0) is
--        when M1 =>
--          AliasAvg <= iStageData0;
--        when M2 =>
--          if AliasAvgCounter = 0 then
--            AliasAvgCounter <= 1;
--          else
--            AliasAvgValid   <= '0';
--            AliasAvgCounter <= AliasAvgCounter -1;
--          end if;
--          for i in 0 to cCoefficients/2-1 loop
--            AliasAvg(i+cCoefficients/2) <= iStageData0(2*i);
--            AliasAvg(i)                 <= AliasAvg(i+cCoefficients/2);
--          end loop;
--        when M4 =>
--          if AliasAvgCounter = 0 then
--            AliasAvgCounter <= 4;
--          else
--            AliasAvgValid   <= '0';
--            AliasAvgCounter <= AliasAvgCounter -1;
--          end if;
--          for i in 0 to cCoefficients/4-1 loop
--            AliasAvg(i+cCoefficients*3/4) <= iStageData0(4*i);
--          end loop;
--          AliasAvg(0 to cCoefficients*3/4-1) <=
--            AliasAvg(cCoefficients/4 to cCoefficients-1);
--        when M10 =>
--          if AliasAvgCounter = 0 then
--            AliasAvgCounter <= 9;
--          else
--            AliasAvgCounter <= AliasAvgCounter -1;
--          end if;
--          case AliasAvgCounter is
--            when 0 | 5 => AliasAvgValid <= '0';
--            when 1 | 6 => AliasAvg(7)   <= iStageData0(1);
--            when 2 | 7 => AliasAvg(7)   <= iStageData0(3);
--            when 3 | 8 => AliasAvg(7)   <= iStageData0(5);
--            when 4 | 9 => AliasAvg(7)   <= iStageData0(7);
--          end case;
--          case AliasAvgCounter is
--            when 0 | 5  => AliasAvg         <= AliasAvg;
--            when others => AliasAvg(0 to 6) <= AliasAvg(1 to 7);
--          end case;
--      end case;
    end if;
  end process;

  oData <= DataOut;

end architecture;
