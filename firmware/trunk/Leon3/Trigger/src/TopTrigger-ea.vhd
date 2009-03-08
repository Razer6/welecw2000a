-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-27
-- Last update: 2009-03-08
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
-- 2008-08-27  1.0    
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library DSO;
use DSO.pDSOConfig.all;
use DSO.Global.all;
use DSO.pTrigger.all;

entity TopTrigger is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iData       : in  aTriggerData;
    iValid      : in  std_ulogic;
    iExtTrigger : in  std_ulogic;
    iTriggerMem : in  aTriggerMemIn;
    oTriggerMem : out aTriggerMemOut;
    iCPUPort    : in  aTriggerInput;
    oCPUPort    : out aTriggerOutput); 
end entity;

architecture RTL of TopTrigger is
  
  signal R              : aTopTriggerFSM;
  signal TriggerStrobes : aTrigger2D(0 to cDiffTriggers-1);
  signal TriggerData    : aBytes(0 to cCoefficients-1);
  signal TriggerInValid : std_ulogic;
--  signal WrEn           : std_ulogic;
  signal aclr           : std_ulogic;

  signal DataInCh0    : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataOutCh0   : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataInCh1    : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataOutCh1   : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataInCh2    : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataOutCh2   : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataInCh3    : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal DataOutCh3   : std_ulogic_vector(8*cCoefficients-1 downto 0);
  signal AlignDataCh0 : aBytes(0 to cCoefficients-1);
  signal AlignDataCh1 : aBytes(0 to cCoefficients-1);
  signal AlignDataCh2 : aBytes(0 to cCoefficients-1);
  signal AlignDataCh3 : aBytes(0 to cCoefficients-1);
  
begin
  
  Convert : process (iData, iCPUPort.TriggerChannel, DataOutCh0, DataOutCh1, DataOutCh2, DataOutCh3)
  begin
    for i in 0 to cCoefficients-1 loop
      DataInCh0(8*(i+1)-1 downto 8*i) <= std_ulogic_vector(iData(0)(i));
      DataInCh1(8*(i+1)-1 downto 8*i) <= std_ulogic_vector(iData(1)(i));
      DataInCh2(8*(i+1)-1 downto 8*i) <= std_ulogic_vector(iData(2)(i));
      DataInCh3(8*(i+1)-1 downto 8*i) <= std_ulogic_vector(iData(3)(i));

      AlignDataCh0(i) <= DataOutCh0(8*(i+1)-1 downto 8*i);
      AlignDataCh1(i) <= DataOutCh1(8*(i+1)-1 downto 8*i);
      AlignDataCh2(i) <= DataOutCh2(8*(i+1)-1 downto 8*i);
      AlignDataCh3(i) <= DataOutCh3(8*(i+1)-1 downto 8*i);
    end loop;
  end process;

  TriggerOnCh : process (iClk, iResetAsync)
  begin
    if iResetAsync = cResetActive then
      TriggerData    <= (others => (others => '0'));
      TriggerInValid <= '0';
    elsif rising_edge(iClk) then
      TriggerInValid <= iValid;
      TriggerData    <= iData(iCPUPort.TriggerChannel);
    end if;
  end process;



  Top : process (iClk, iResetAsync)
    variable i    : natural;
    constant cInit : aTopTriggerFSM := (
      State       => Idle,
      PrevTrigger => '0',
      Counter     => (others => '0'),
      Busy        => '0',
      WrEn        => (others => '0'),
      Addr        => (others => '0'),
      StartAddr   => (others => '0'),
      ReadAlign   => (others => '0'),
      DataValid   => "00");
  begin
    
    if iResetAsync = cResetActive then
      R                       <= cInit;
      oTriggerMem.Data        <= (others => '0');
      oCPUPort.Recording <= '0';
    elsif rising_edge(iClk) then
      
      R.ReadAlign                    <= iTriggerMem.Addr(cTriggerAlign-1 downto 0);
      i                              := to_integer(unsigned(R.ReadAlign));
      oTriggerMem.Data(7 downto 0)   <= std_ulogic_vector(AlignDataCh0(i));
      oTriggerMem.Data(15 downto 8)  <= std_ulogic_vector(AlignDataCh1(i));
      oTriggerMem.Data(23 downto 16) <= std_ulogic_vector(AlignDataCh2(i));
      oTriggerMem.Data(31 downto 24) <= std_ulogic_vector(AlignDataCh3(i));
      oCPUPort.Recording        <= '0';
      R.PrevTrigger                  <= iCPUPort.TriggerOnce;
      --    R.WrEn         <= '1';
      R.Busy                         <= '1';
      R.DataValid(1)                 <= iTriggerMem.Rd;
      R.DataValid(2)                 <= R.DataValid(1);

      if iValid = '1' then
        R.Addr <= R.Addr + to_unsigned(1, R.Addr'length);
      end if;
      -- if R.State /= Recording then
      --   R.Addr(R.Addr'high downto R.Addr'high - cStorageMode) <= "00";
      -- end if;
      if R.Addr = (unsigned(iCPUPort.StorageMode) & to_unsigned((2**cTriggerAddrLength)-1, (cTriggerAddrLength))) then
        R.Addr(R.Addr'high downto R.Addr'high+1 - cStorageModeLength) <= "00";
      end if;

      case iCPUPort.StorageMode is
        -- when cStorageMode4CH =>
        when "00" =>
          R.WrEn                                                        <= "1111";
          R.Addr(R.Addr'high downto R.Addr'high+1 - cStorageModeLength) <= (others => '0');
          -- when cStorageMode2CH =>
        when "01" =>
          R.Addr(R.Addr'high downto R.Addr'high+2 - cStorageModeLength) <= (others => '0');
          if R.Addr(R.Addr'high downto R.Addr'high+1 - cStorageModeLength) = "01" then
            R.WrEn <= "0101";
          else
            R.WrEn <= "1010";
          end if;
          -- when cStorageMode1CH =>
        when "11" =>
          case R.Addr(R.Addr'high downto R.Addr'high+1 - cStorageModeLength) is
            when "00"   => R.WrEn <= "1000";
            when "01"   => R.WrEn <= "0100";
            when "10"   => R.WrEn <= "0010";
            when "11"   => R.WrEn <= "0001";
            when others => R.WrEn <= (others => 'X');
          end case;
        when others =>
          assert false
            report "Illegal storage mode selected!" severity error;
          R.WrEn <= (others => 'X');
      end case;

      case R.State is
        when Idle =>
          R.WrEn    <= (others => '0');
          R.Busy    <= '0';
          R.Counter <= iCPUPort.PreambleCounter
                       (iCPUPort.PreambleCounter'high downto cTriggerAlign);
          if iCPUPort.TriggerOnce = '1' and R.PrevTrigger = '0' then
            R.State <= Preamble;
          end if;
          
        when Preamble =>
          if iValid = '1' then
            R.Counter <= R.Counter - to_unsigned(1, R.Counter'length);
          end if;
          if to_integer(R.Counter) = 0 then
            R.State <= Triggering;
          end if;
          
        when Triggering =>
          R.StartAddr(R.StartAddr'high downto cTriggerAlign) <= R.Addr - R.Counter;
          case iCPUPort.StorageMode is
            -- when cStorageMode4CH =>
            when "00" =>
              R.StartAddr(R.StartAddr'high downto R.StartAddr'high+1 - cStorageModeLength)
 <= (others => '0');
              -- when cStorageMode2CH =>
            when "01" =>
              R.StartAddr(R.StartAddr'high downto R.StartAddr'high+2 - cStorageModeLength)
 <= (others => '0');
            when others =>
              null;
          end case;
          if iValid = '1' then
            if TriggerStrobes(iCPUPort.Trigger) /= X"00" then
              R.State <= PreRecording;
            end if;
          end if;

          for i in cCoefficients-1 downto 0 loop
            if TriggerStrobes(iCPUPort.Trigger)(i) = '1' then
              R.StartAddr(cTriggerAlign-1 downto 0) <= to_unsigned(i, cTriggerAlign);
            end if;
          end loop;

        when PreRecording =>
          if iValid = '1' then
            R.State                 <= Recording;
            oCPUPort.Recording <= '1';
          end if;
          --     R.StartAddr(R.StartAddr'high downto cTriggerAlign) <=
          --       std_ulogic_vector(unsigned(R.Addr) - unsigned(R.Counter));
        when Recording =>
          oCPUPort.Recording <= '1';
          if iValid = '1' then
            case iCPUPort.StorageMode is
              -- when cStorageMode4CH =>
              when "00" =>
                if R.Addr(R.Addr'high-cStorageModeLength downto 0) =
                  R.StartAddr(R.StartAddr'high-cStorageModeLength downto cTriggerAlign) then
                  R.State <= Idle;
                end if;
                -- when cStorageMode2CH =>
              when "01" =>
                if R.Addr(R.Addr'high+1-cStorageModeLength downto 0) =
                  R.StartAddr(R.StartAddr'high+1-cStorageModeLength downto cTriggerAlign) then
                  R.State <= Idle;
                end if;
                -- when cStorageMode1CH =>
              when "11" =>
                if R.Addr = R.StartAddr(R.StartAddr'high downto cTriggerAlign) then
                  R.State <= Idle;
                end if;
              when others =>
                null;
            end case;
          end if;
      end case;
      -- with this signal force it is possible to mark the read data from the software as
      -- free storage space while the trigger data capture is running.
      -- it is also possible to stop the trigger earlier
      if iCPUPort.SetReadOffset = '1' then
        R.StartAddr <= iCPUPort.ReadOffset;
      end if;
      if iCPUPort.ForceIdle = '1' then
        R.State <= Idle;
      end if;
    end if;
  end process;

  oCPUPort.ReadOffset         <= R.StartAddr;
  oCPUPort.CurrentTriggerAddr <= R.Addr(oCPUPort.CurrentTriggerAddr'range);
  oCPUPort.Busy               <= R.Busy;
  oTriggerMem.ACK             <= R.DataValid(2);

  -- WrEn <= R.WrEn and iValid;
  aclr <= iResetAsync when cResetActive = '1' else
          not iResetAsync;
  MemoryCH0 : entity work.TriggerMemory
    port map(
      aclr                 => aclr,
      clock                => iClk,
      data                 => std_logic_vector(DataInCh0),
      rdaddress            => std_logic_vector(iTriggerMem.Addr(iTriggerMem.Addr'high downto cTriggerAlign)),
      wraddress            => std_logic_vector(R.Addr(R.Addr'high-cStorageModeLength downto 0)),
      wren                 => R.WrEn(0),
      std_ulogic_vector(q) => DataOutCh0);

  MemoryCH1 : entity work.TriggerMemory
    port map(
      aclr                 => aclr,
      clock                => iClk,
      data                 => std_logic_vector(DataInCh1),
      rdaddress            => std_logic_vector(iTriggerMem.Addr(iTriggerMem.Addr'high downto cTriggerAlign)),
      wraddress            => std_logic_vector(R.Addr(R.Addr'high-cStorageModeLength downto 0)),
      wren                 => R.WrEn(1),
      std_ulogic_vector(q) => DataOutCh1);

  MemoryCH2 : entity work.TriggerMemory
    port map(
      aclr                 => aclr,
      clock                => iClk,
      data                 => std_logic_vector(DataInCh2),
      rdaddress            => std_logic_vector(iTriggerMem.Addr(iTriggerMem.Addr'high downto cTriggerAlign)),
      wraddress            => std_logic_vector(R.Addr(R.Addr'high-cStorageModeLength downto 0)),
      wren                 => R.WrEn(2),
      std_ulogic_vector(q) => DataOutCh2);

  MemoryCH3 : entity work.TriggerMemory
    port map(
      aclr                 => aclr,
      clock                => iClk,
      data                 => std_logic_vector(DataInCh3),
      rdaddress            => std_logic_vector(iTriggerMem.Addr(iTriggerMem.Addr'high downto cTriggerAlign)),
      wraddress            => std_logic_vector(R.Addr(R.Addr'high-cStorageModeLength downto 0)),
      wren                 => R.WrEn(3),
      std_ulogic_vector(q) => DataOutCh3);


  -----------------------------------------------------------------------------
  -- Trigger mode instances
  -----------------------------------------------------------------------------

  -- Trigger0 ExtTrigger L => H
  -- Trigger1 ExtTrigger H => L

  Ext : entity work.ExternalTrigger
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iValid      => TriggerInValid,
      iExtTrigger => iExtTrigger,
      oLHStrobe   => TriggerStrobes(0)(0),
      oHLStrobe   => TriggerStrobes(1)(0),
      oHigh       => open);

  TriggerStrobes(0)(1 to cCoefficients-1) <= (others => '0');
  TriggerStrobes(1)(1 to cCoefficients-1) <= (others => '0');

  -- Trigger2 NormalTrigger L => H
  -- Trigger3 NormalTrigger H => L

  Normal : entity work.NormalTrigger
    port map (
      iClk        => iClk,
      iResetAsync => iResetAsync,
      iValid      => TriggerInValid,
      iData       => TriggerData,
      iLowValue   => iCPUPort.LowValue,
      iLowTime    => iCPUPort.LowTime,
      iHighValue  => iCPUPort.HighValue,
      iHighTime   => iCPUPort.HighTime,
      oLHStrobe   => TriggerStrobes(2),
      oHLStrobe   => TriggerStrobes(3),
      oHigh       => open);

end architecture;
