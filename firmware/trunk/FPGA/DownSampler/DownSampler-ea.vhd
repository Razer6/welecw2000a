-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : DownSampler-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-16
-- Last update: 2008-08-23
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2008 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  
-- 2008-08-16  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Global.all;
use work.pFastFirCoeff.all;
use work.pPolyphaseDecimator.all;

entity DownSampler is
  port (
    iClk          : in  std_ulogic;
    iResetAsync   : in  std_ulogic;
    iEnableStage1 : in  std_ulogic;
    iMStage1      : in  aDecimator;
    iStage1Data   : in  aFastData;
    iStage1Valid  : in  std_ulogic;
    iEnableStage2 : in  std_ulogic;
    iMStage2      : in  aDecimator;
    iStage2Data   : in  aValue;
    iStage2Valid  : in  std_ulogic;
    oDataOut      : out aFastData;
    oWrEn         : out std_ulogic
    );
end entity;

architecture RTL of DownSampler is
  
  signal AliasAvgCounter : integer range 0 to 9;
  signal AliasAvg        : aFastData;
  signal AliasAvgValid   : std_ulogic;

  signal AliasFastFirCounter : integer range 0 to 9;
  signal AliasFastFir        : aValue;
  signal AliasFastFirValid   : std_ulogic;

  signal Stage1Valid : std_ulogic;
  signal Stage1Data  : aFastData;
  signal Stage2Valid : std_ulogic;
  signal Stage2Data  : aValue;

  signal DataCounter : integer range 0 to 9;
  signal DataOut     : aFastData;
  signal DataValid   : std_ulogic;
  
begin
  
  process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      AliasAvgCounter <= 0;
      AliasAvg        <= (others => (others => '0'));
      AliasAvgValid   <= '0';

      AliasFastFirCounter <= 0;
      AliasFastFir        <= (others => '0');
      AliasFastFirValid   <= '0';

      Stage1Valid <= '0';
      Stage1Data  <= (others => (others => '0'));
      Stage2Valid <= '0';
      Stage2Data  <= (others => '0');

      DataOut   <= (others => (others => '0'));
      DataValid <= '0';
      
    elsif rising_edge(iClk) then
      
      if iEnableStage1 = '1' then
        Stage1Valid <= iStage1Valid;
        Stage1Data  <= iStage1Data;
      else
        Stage1Valid <= AliasAvgValid;
        Stage1Data  <= AliasAvg;
      end if;

      if iEnableStage2 = '1' and iMStage2 /= M1 then
        Stage2Valid <= iStage2Valid;
        Stage2Data  <= iStage2Data;
      else
        Stage2Valid <= AliasFastFirValid;
        Stage2Data  <= AliasFastFir;
      end if;

      DataValid <= '0';
      case iMStage2 is
        when M2 | M4 | M10 =>
          if Stage2Valid = '1' then
            if DataCounter = 0 then
              DataCounter <= cCoefficients-1;
              DataValid   <= '1';
            else
              DataCounter <= DataCounter - 1;
            end if;
            DataOut <= Stage2Data & DataOut(1 to DataOut'high);
          end if;
          
        when M1 =>
          case iMStage1 is
            when M1 =>
              DataValid <= '1';
              DataOut   <= Stage1Data;
            when M2 =>
              if DataCounter = 0 then
                DataCounter <= 1;
                DataValid   <= '1';
              else
                DataCounter <= DataCounter - 1;
              end if;
              for i in 0 to cCoefficients/2-1 loop
                DataOut(cCoefficients/2+i) <= Stage1Data(i);
                DataOut(i)                 <= DataOut(i+cCoefficients/2);
              end loop;
              --  DataOut <= DataOut(0 to 3) & Stage1Data(0 to 3);
            when M4 =>
              if DataCounter = 0 then
                DataCounter <= 3;
                DataValid   <= '1';
              else
                DataCounter <= DataCounter - 1;
              end if;
              DataOut <= Stage1Data(0 to 1) & DataOut(0 to DataOut'high-2);
            when M10 =>
              if Stage1Valid = '1' then
                if DataCounter = 0 then
                  DataCounter <= cCoefficients-1;
                  DataValid   <= '1';
                else
                  DataCounter <= DataCounter - 1;
                end if;
                DataOut <= Stage1Data(0) & DataOut(1 to DataOut'high);
              end if;
            when others =>
              DataOut <= (others => (others => '-'));
          end case;
        when others =>
          DataOut <= (others => (others => '-'));
      end case;

     
        AliasAvgValid <= '1';
        AliasAvg      <= (others => (others => '-'));
        case iMStage1 is
          when M1 =>
            AliasAvg <= iStage1Data;
          when M2 =>
            for i in 0 to cCoefficients/2-1 loop
              AliasAvg(i) <= iStage1Data(2*i);
            end loop;
          when M4 =>
            for i in 0 to cCoefficients/4-1 loop
              AliasAvg(i) <= iStage1Data(4*i);
            end loop;
          when M10 =>
            if AliasAvgCounter = 0 then
              AliasAvgCounter <= 9;
            else
              AliasAvgCounter <= AliasAvgCounter -1;
            end if;
            case AliasAvgCounter is
              when 0 | 5 => AliasAvgValid <= '0';
              when 1 | 6 => AliasAvg(0)   <= iStage1Data(1);
              when 2 | 7 => AliasAvg(0)   <= iStage1Data(3);
              when 3 | 8 => AliasAvg(0)   <= iStage1Data(5);
              when 4 | 9 => AliasAvg(0)   <= iStage1Data(7);
            end case;
        end case;

      AliasFastFir      <= Stage1Data(0);
      AliasFastFirValid <= '0';
      if Stage1Valid = '1' then
        case iMStage2 is
          when M1 =>
            AliasFastFirValid <= '1';
          when M2 =>
            if AliasFastFirCounter = 0 then
              AliasFastFirCounter <= 1;
              AliasFastFirValid   <= '1';
            else
              AliasFastFirCounter <= AliasFastFirCounter -1;
            end if;
          when M4 =>
            if AliasFastFirCounter = 0 then
              AliasFastFirCounter <= 3;
              AliasFastFirValid   <= '1';
            else
              AliasFastFirCounter <= AliasFastFirCounter -1;
            end if;
          when M10 =>
            if AliasFastFirCounter = 0 then
              AliasFastFirCounter <= 9;
              AliasFastFirValid   <= '1';
            else
              AliasFastFirCounter <= AliasFastFirCounter -1;
            end if;
        end case;
      end if;
    end if;
  end process;

  oDataOut <= DataOut;
  oWrEn    <= DataValid;
  
end architecture;
