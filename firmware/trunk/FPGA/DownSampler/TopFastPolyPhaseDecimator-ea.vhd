-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopFastPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-13
-- Last update: 2008-08-17
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-13  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pPolyphaseDecimator.all;
use work.pFastFirCoeff.all;

entity TopFastPolyPhaseDecimator is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iDecimator  : in  aDecimator;
    iData       : in  aValues(0 to cChannels-1);
    iValid      : in  std_ulogic;
    oData       : out aLongValues(0 to cChannels-1);
    oValid      : out std_ulogic);
end entity;

architecture RTL of TopFastPolyPhaseDecimator is
  
  signal   Coeff         : aFastData;
  signal   FirIdx        : aAddr;
  signal   InternalValid : std_ulogic;
  
begin
  
  Reg : process(iClk, iResetAsync)
    variable vRomOut : signed(71 downto 0);
  begin
    if iResetAsync = cResetActive then
      Coeff <= (others => (others => '0'));
    elsif rising_edge(iClk) then
      for i in Coeff'range loop
        Coeff(i) <= to_signed(cFastFirCoeff(FirIdx*cCoefficients + i), cBitWidth);
      end loop;
    end if;
  end process;

--  FIR : for i in 1 to cChannels-1 generate
--    Slave: entity work.FastPolyPhaseDecimator
--      generic map (gMaster => false)
--      port map (
--        iClk           => iClk,
--        iResetAsync    => iResetAsync,
--        iDecimator     => iDecimator,
--        iData          => iData(i),
--        iValid         => iValid,
--        iCoeff         => Coeff,
--        oData          => oData(i),
--        oValid         => open,
--        oFirIdx        => open,
--        oInternalValid => open,
--        iInternalValid => InternalValid);
--  end generate;

  FIR0 : entity work.FastPolyPhaseDecimator
    generic map (gMaster => true)
    port map (
      iClk           => iClk,
      iResetAsync    => iResetAsync,
      iDecimator     => iDecimator,
      iData          => iData(0),
      iValid         => iValid,
      iCoeff         => Coeff,
      oData          => oData(0),
      oValid         => oValid,
      oFirIdx        => FirIdx,
      oInternalValid => InternalValid,
      iInternalValid => InternalValid);

  FIR1 : entity work.FastPolyPhaseDecimator
    generic map (gMaster => false)
    port map (
      iClk           => iClk,
      iResetAsync    => iResetAsync,
      iDecimator     => iDecimator,
      iData          => iData(1),
      iValid         => iValid,
      iCoeff         => Coeff,
      oData          => oData(1),
      oValid         => open,
      oFirIdx        => open,
      oInternalValid => open,
      iInternalValid => InternalValid);

  FIR2 : entity work.FastPolyPhaseDecimator
    generic map (gMaster => false)
    port map (
      iClk           => iClk,
      iResetAsync    => iResetAsync,
      iDecimator     => iDecimator,
      iData          => iData(2),
      iValid         => iValid,
      iCoeff         => Coeff,
      oData          => oData(2),
      oValid         => open,
      oFirIdx        => open,
      oInternalValid => open,
      iInternalValid => InternalValid);

  FIR3 : entity work.FastPolyPhaseDecimator
    generic map (gMaster => false)
    port map (
      iClk           => iClk,
      iResetAsync    => iResetAsync,
      iDecimator     => iDecimator,
      iData          => iData(3),
      iValid         => iValid,
      iCoeff         => Coeff,
      oData          => oData(3),
      oValid         => open,
      oFirIdx        => open,
      oInternalValid => open,
      iInternalValid => InternalValid);

end architecture;
