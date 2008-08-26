-------------------------------------------------------------------------------
-- Project    : Welec W2000A
-------------------------------------------------------------------------------
-- File       : FastPolyPhaseDecimator-ea.vhd
-- Author     : Alexander Lindert <alexander.lindert ... fh-hagenberg.at>
-- Created    : 2008-08-07
-- Last update: 2008-08-18
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-07  1.0    
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pPolyphaseDecimator.all;
use work.pFastFirCoeff.all;

entity FastPolyPhaseDecimator is
  -- generic only to reduce a few LUTs
  generic (gMaster : boolean := true);
  port (
    iClk           : in  std_ulogic;
    iResetAsync    : in  std_ulogic;
    iDecimator     : in  aDecimator;
    iData          : in  aValue;
    iValid         : in  std_ulogic;
    iCoeff         : in  aFastData;
    oData          : out aLongValue;
    oValid         : out std_ulogic;
    ---------------------------------------------------------------------------
    -- The folowing ports are only to reduce a few LUTs when using this Decimator
    -- in a synchron parallel mode
    ---------------------------------------------------------------------------
    oFirIdx        : out aAddr;
    oInternalValid : out std_ulogic;
    iInternalValid : in  std_ulogic
    );  
end entity;

architecture RTL of FastPolyPhaseDecimator is
  constant cValidDelay   : integer := 8;
  signal   ShiftReg      : aValues(0 to 40);  -- 50 FIR Coefficients shifted only once per
                                        -- cycle for M10 the 0, 10, 20, 30 and 40 are
                                        -- used for the calulation
  signal   MultValues    : aValues(0 to cCoefficients-1);
  signal   MultResult    : aLongValues(0 to cCoefficients-1);
  signal   AddResult0    : aLongValues(0 to cCoefficients/2-1);
  signal   AddResult1    : aLongValues(0 to cCoefficients/4-1);
  signal   AddResult2    : aLongValue;
  signal   Sum           : aLongValue;
  signal   Valid         : std_ulogic_vector(1 to cValidDelay);
  signal   ResultValid   : std_ulogic_vector(1 to cValidDelay);
  signal   FirIdx        : aAddr;
  signal   Counter       : natural range 0 to 49;
  signal   PrevDecimator : aDecimator;
begin
  
  FIR : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      ShiftReg   <= (others => (others => '0'));
      MultValues <= (others => (others => '0'));
      MultResult <= (others => (others => '0'));
      AddResult0 <= (others => (others => '0'));
      AddResult1 <= (others => (others => '0'));
      AddResult2 <= (others => '0');
      Sum        <= (others => '0');
      Valid      <= (others => '0');

      if gMaster = true then
        Counter       <= 0;
        --FirIdx  <= (others => '1');
        FirIdx        <= 0;
        ResultValid   <= (others => '0');
        PrevDecimator <= M1;
      end if;
      
    elsif rising_edge(iClk) then
      
      Valid(Valid'low)                 <= iValid;
      Valid(Valid'low+1 to Valid'high) <= Valid(Valid'low to Valid'high-1);
      if gMaster = true then
        ResultValid(ResultValid'low)                       <= '0';
        ResultValid(ResultValid'low+1 to ResultValid'high) <= ResultValid(ResultValid'low to ResultValid'high-1);
        PrevDecimator                                      <= iDecimator;
      end if;

      if iValid = '1' then              -- Valid(0)
        ShiftReg <= iData & ShiftReg(0 to ShiftReg'high-1);

        if gMaster = true then
          FirIdx <= (FirIdx + 1) mod (cFastFirCoeff'length/cCoefficients);

          case iDecimator is
            when M1 =>
              Counter                      <= 1;
              --    FirIdx  <= to_signed(0, FirIdx'length);
              FirIdx                       <= 0;
              ResultValid(ResultValid'low) <= '1';
            when M2 =>
              if Counter = 0 then
                Counter                      <= 1;
                --     FirIdx  <= to_signed(0, FirIdx'length);
                FirIdx                       <= 0;
                ResultValid(ResultValid'low) <= '1';
              else
                Counter <= Counter - 1;
              end if;
            when M4 =>
              if Counter = 0 then
                Counter                      <= 3;
                --      FirIdx  <= to_signed(2, FirIdx'length);
                FirIdx                       <= 2;
                ResultValid(ResultValid'low) <= '1';
              else
                Counter <= Counter - 1;
              end if;
            when M10 =>
              if Counter = 0 then
                Counter                      <= 9;
                --     FirIdx  <= to_signed(6, FirIdx'length);
                FirIdx                       <= 6;
                ResultValid(ResultValid'low) <= '1';
              else
                Counter <= Counter - 1;
              end if;
            when others =>
              null;
          end case;

          if PrevDecimator /= iDecimator then
            case iDecimator is
              when M1  => Counter <= 1;
              when M2  => Counter <= 2;
              when M4  => Counter <= 4;
              when M10 => Counter <= 9;
            end case;
          end if;
        end if;
      end if;

      -- Valid(1)
      for i in MultValues'range loop
        MultValues(i) <= ShiftReg(2*i);
      end loop;
      case iDecimator is
        when M4 =>
          for i in MultValues'range loop
            MultValues(i) <= ShiftReg(4*i);
          end loop;
        when M10 =>
          for i in 0 to 4 loop
            MultValues(i) <= ShiftReg(10*i);
          end loop;
        when others =>
          null;
      end case;

      for i in MultResult'range loop                -- Valid(2)
        MultResult(i) <= MultValues(i) * iCoeff(i);
      end loop;
      for i in AddResult0'range loop                -- Valid(3)
        AddResult0(i) <= MultResult(2*i) + MultResult(2*i+1);
      end loop;
      for i in AddResult1'range loop                -- Valid(4)
        AddResult1(i) <= AddResult0(2*i) + AddResult0(2*i+1);
      end loop;
      AddResult2 <= AddResult1(0) + AddResult1(1);  -- Valid(5)

      if Valid(cValidDelay) = '1' then
        if iInternalValid = '1' then
          Sum <= to_signed(0, Sum'length) + AddResult2;
        else
          Sum <= Sum + AddResult2;
        end if;
      end if;
    end if;
  end process;

  Output : if gMaster = true generate
    oInternalValid <= ResultValid(cValidDelay);
    oFirIdx        <= FirIdx;
    oValid         <= ResultValid(cValidDelay);
  end generate;

  oData <= Sum;
  
end architecture;
