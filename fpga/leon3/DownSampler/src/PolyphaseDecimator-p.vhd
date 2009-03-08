-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : PolyphaseDecimator-p.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-07
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
-- 2008-08-07  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pFastFirCoeff.all;
use DSO.pFirCoeff.all;

package pPolyphaseDecimator is
  
  type     aDecimator is (M1, M2, M4, M10);
  type     aM is array (natural range<>) of aDecimator;
  constant cM1        : aM(1 to cDecimationStages-1) := (others => M1);
  subtype  aFirAddr is natural range 0 to cFirCoeff'length-1;
  subtype  aFastFirAddr is natural range 0 to cFastFirCoeff'length/cCoefficients-1;
  constant cDecAvgMax : natural                      := 10;

  type aDownSampler is record
                         Stages       : aDword;
                         EnableFilter : std_ulogic_vector(0 to cDecimationStages-1);
                       end record;
  type aStage is record
                   Counter : integer range 0 to 9;
                   Data    : aLongValue;
                   Valid   : std_ulogic;
                 end record;
  type aStages is array (1 to cDecimationStages-1) of aStage;

  type aStageInput is record
                        Data  : aLongValue;
                        Valid : std_ulogic;
                      end record;
  type aStageInputs is array (0 to cDecimationStages-1) of aStageInput;
  type aStageOutputs is array (0 to cDecimationStages-2) of aStageInput;
  type aStagesInCh is array (0 to cChannels-1) of aStageInputs;
  type aStagesOutCh is array (0 to cChannels-1) of aStageOutputs;
  type aDownSampled is array (0 to cChannels-1) of aLongValues(0 to cCoefficients-1);
  function Avg9Bit (A, B : aValue) return aValue;
  function toValues(A    : aInputValues) return aValues;



  component FastAverage is
    port (
      iClk        : in  std_ulogic;
      iResetAsync : in  std_ulogic;
      iDecimator  : in  aDecimator;
      iData       : in  aFastData;      -- fixpoint 1.x range -0.5 to <0.5
      oData       : out aFastData;      -- fixpoint 1.x range -1 to <1
      oValid      : out std_ulogic;
      oStageData  : out aLongValue;
      oStageValid : out std_ulogic);
  end component;

  component FastPolyPhaseDecimator is
    port (
      iClk         : in  std_ulogic;
      iResetAsync  : in  std_ulogic;
      iDecimator   : in  aDecimator;
      iData        : in  aValue;
      iInputValid  : in  std_ulogic;
      iSumValid    : in  std_ulogic;
      iResultValid : in  std_ulogic;
      iCoeff       : in  aFastData;
      oData        : out aLongValue);  
  end component;

  component PolyPhaseDecimator is
    port (
      iClk          : in  std_ulogic;
      iResetAsync   : in  std_ulogic;
      iDecimator    : in  aDecimator;
      iData         : in  aLongValue;
      iInputValid   : in  std_ulogic;
      iValidDelayed : in  std_ulogic;
      iSumValid     : in  std_ulogic;
      iResultValid  : in  std_ulogic;
      iShiftEnable  : in  std_ulogic;
      iFirCounter   : in  natural range 0 to 8-1;
      iReadAddr     : in  unsigned(7 downto 0);
      iWriteAddr    : in  unsigned(7 downto 0);
      iCoeff        : in  aLongValue;
      oData         : out aLongValue);  
  end component;

  component DownSampler is
    port (
      iClk          : in  std_ulogic;
      iResetAsync   : in  std_ulogic;
      iEnableFilter : in  std_ulogic_vector(0 to cDecimationStages-1);
      iDecimation   : in  aM(0 to cDecimationStages-1);
      iStageValid0  : in  std_ulogic;
      iStageData0   : in  aFastData;
      iStage        : in  aStageInputs;
      oStage        : out aStageOutputs;
      oData         : out aLongValues(0 to cCoefficients-1);
      oValid        : out std_ulogic);
  end component;

end;

package body pPolyphaseDecimator is
  
  function Avg9Bit (A, B : aValue) return aValue is
    variable vRes : aValue;
  begin
    vRes := (A(cBitWidth-1) & A(cBitWidth-1 downto 1)) + (B(cBitWidth-1) & B(cBitWidth-1 downto 1));
    return vRes;
  end;

  function toValues(A : aInputValues) return aValues is
    variable vRes : aValues(A'range);
  begin
    for i in A'range loop
      vRes(i) := to_signed(A(i), aValue'length);
      return vRes;
    end loop;
  end;

end;

