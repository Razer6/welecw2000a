-------------------------------------------------------------------------------
-- Project    : Welec W2000A 
-------------------------------------------------------------------------------
-- File       : TopTrigger-ea.vhd
-- Author     : Alexander Lindert <alexander_lindert at gmx.at>
-- Created    : 2008-08-27
-- Last update: 2009-08-29
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
    iClkCPU     : in  std_ulogic;
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
  type aTopTriggerState is (Idle, Preamble, Triggering, PreRecording, Recording);
  type aTopTriggerFSM is record
                           State           : aTopTriggerState;
                           PrevTrigger     : std_ulogic;
                           Counter         : unsigned(cTriggerAddrLength-cTriggerAlign-1 downto 0);
                           Busy            : std_ulogic;
                           WrEn            : std_ulogic_vector(0 to 3);
                           --          TriggerData : aWords(0 to cCoefficients-1);
                           Addr            : unsigned(cTriggerAddrLength-cTriggerAlign-1 downto 0);
                           StorageModeAddr : unsigned(cStorageModeLength-1 downto 0);
                           StopAddr        : aTriggerAddr;
                         end record;
  
  signal R              : aTopTriggerFSM;
  signal TriggerStrobes : aTrigger2D(0 to cDiffTriggers-1);
  signal TriggerData    : aBytes(0 to cCoefficients-1);
  signal TriggerInValid : std_ulogic;
--  signal WrEn           : std_ulogic;
  signal aclr           : std_ulogic;

  type    aDataIn is array (0 to 3) of std_ulogic_vector(8*cCoefficients-1 downto 0);
  type    aAlignData is array (0 to 3) of aBytes(0 to cCoefficients-1);
  --type   aTriggerAlign is array (0 to 1) of unsigned(cTriggerAlign-1 downto 0);
  subtype aTriggerAlign is unsigned(cTriggerAlign-1 downto 0);
  signal  DataIn, DataOut : aDataIn;
  signal  AlignData       : aAlignData;
  signal  ReadValid       : std_ulogic_vector(0 to 2);
  signal  ReadAlign       : aTriggerAlign;

  component TriggerMemory is
    port
      (
        data      : in  std_logic_vector (63 downto 0);
        rd_aclr   : in  std_logic := '0';
        rdaddress : in  std_logic_vector (9 downto 0);
        rdclock   : in  std_logic;
        wraddress : in  std_logic_vector (9 downto 0);
        wrclock   : in  std_logic;
        wren      : in  std_logic := '1';
        q         : out std_logic_vector (63 downto 0)
        );
  end component;
begin

  -- pragma translate_off
  Simul : block
    signal DrawData0 : aByte;
    signal DrawData1 : aByte;
    signal DrawData2 : aByte;
    signal DrawData3 : aByte;
  begin
    
    process (iClk)
    begin
      if rising_edge(iClk) then
        if iValid = '1' then
          DrawData0 <= iData(0)(0);
          DrawData1 <= iData(1)(0);
          DrawData2 <= iData(2)(0);
          DrawData3 <= iData(3)(0);
        end if;
      end if;
    end process;
  end block;
-- pragma translate_on

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
    constant cInit : aTopTriggerFSM := (
      State           => Idle,
      PrevTrigger     => '0',
      Counter         => (others => '0'),
      Busy            => '0',
      WrEn            => (others => '0'),
      Addr            => (others => '0'),
      StopAddr        => (others => '0'),
      StorageModeAddr => (others => '0'));
    variable vStorageModeAddr : unsigned(cStorageModeLength-1 downto 0);
  begin
    
    if iResetAsync = cResetActive then
      R                  <= cInit;
      oCPUPort.Recording <= '0';
    elsif rising_edge(iClk) then
      
      oCPUPort.Recording <= '0';
      R.PrevTrigger      <= iCPUPort.TriggerOnce;
      R.Busy             <= '1';

      if iValid = '1' then
        R.Addr <= R.Addr + 1;
      end if;
      -- Storage Mode address length extension only allowed in State Recording!
      if R.State /= Recording then
        R.Addr(R.Addr'high downto R.Addr'high+1 - cStorageModeLength) <= "00";
      end if;

      --  R.WrEn <= "1111";

      case R.State is
        when Idle =>
          R.Addr            <= to_unsigned(0, R.Addr'length);
          R.StorageModeAddr <= "00";
          R.WrEn            <= "0000";
          R.Busy            <= '0';
          R.Counter         <= iCPUPort.PreambleCounter(iCPUPort.PreambleCounter'high downto cTriggerAlign);
          if iCPUPort.TriggerOnce = '1' and R.PrevTrigger = '0' then
            R.State <= Preamble;
          end if;
          
        when Preamble =>
          R.WrEn <= "1111";
          if iValid = '1' then
            R.Counter <= R.Counter - to_unsigned(1, R.Counter'length);
          end if;
          if to_integer(R.Counter) = 0 then
            R.State <= Triggering;
          end if;
          
        when Triggering =>
          R.WrEn                                           <= "1111";
          R.StopAddr(R.StopAddr'high downto cTriggerAlign) <= R.Addr(R.Addr'high downto 0) -
                                                              iCPUPort.PreambleCounter(iCPUPort.PreambleCounter'high downto cTriggerAlign);
          R.StopAddr(R.StopAddr'high downto R.StopAddr'high-1) <= unsigned(iCPUPort.StorageMode);

          if iValid = '1' then
            if TriggerStrobes(iCPUPort.Trigger) /= X"00" then
              R.State <= Recording;
            end if;
          end if;

          for i in cCoefficients-1 downto 0 loop
            if TriggerStrobes(iCPUPort.Trigger)(i) = '1' then
              R.StopAddr(cTriggerAlign-1 downto 0) <= to_unsigned(i, cTriggerAlign);
            end if;
          end loop;

        when PreRecording =>
          R.WrEn <= "1111";
          if iValid = '1' then
            R.State            <= Recording;
            oCPUPort.Recording <= '1';
          end if;
          
        when Recording =>
          oCPUPort.Recording <= '1';

          if iValid = '1' then
            if R.Addr = R.StopAddr(R.StopAddr'high downto cTriggerAlign) then
              if iCPUPort.StorageMode = std_ulogic_vector(R.StorageModeAddr) then
                R.State <= Idle;
                R.WrEn  <= "0000";
              else
                -- The StorageMode enables up to four loops to use the full memory if the width of all
                -- samples together is lower than 32 bit
                vStorageModeAddr  := R.StorageModeAddr +1;
                R.StorageModeAddr <= vStorageModeAddr;
                case vStorageModeAddr is
                  when "00" =>
                    R.WrEn <= "1111";
                  when "01" =>
                    R.WrEn <= "0101";
                  when "10" =>
                    R.WrEn <= "0010";
                  when "11" =>
                    R.WrEn <= "0001";
                  when others =>
                    R.WrEn <= "XXXX";
                end case;
              end if;
            end if;
          end if;
          
      end case;
      -- with this signal force it is possible to mark the read data from the software as
      -- free storage space while the trigger data capture is running.
      -- it is also possible to stop the trigger earlier
      if iCPUPort.SetReadOffset = '1' then
        R.StopAddr <= iCPUPort.ReadOffset(iCPUPort.ReadOffset'high downto 0);
      end if;
      if iCPUPort.ForceIdle = '1' then
        R.State <= Idle;
      end if;
    end if;
  end process;

  -- oCPUPort.ReadOffset(oCPUPort.ReadOffset'high downto  cTriggerAlign)  <= R.StopAddr(cTriggerAddrLength-1 downto 0);
  -- oCPUPort.ReadOffset(cTriggerAlign-1 downto 0) <= (others => '0');
  oCPUPort.ReadOffset <= R.StopAddr(cTriggerAddrLength-1 downto 0);

  oCPUPort.CurrentTriggerAddr(oCPUPort.CurrentTriggerAddr'high downto cTriggerAlign) <= R.Addr;
  oCPUPort.CurrentTriggerAddr(cTriggerAlign-1 downto 0)                              <= (others => '0');
  oCPUPort.Busy                                                                      <= R.Busy;
  oTriggerMem.ACK                                                                    <= ReadValid(ReadValid'high);

  aclr <= iResetAsync when cResetActive = '1' else
          not iResetAsync;
  
  Memory : for i in 0 to 3 generate
    Ch : TriggerMemory
      port map (
        data                 => std_logic_vector(DataIn(i)),
        rd_aclr              => aclr,
        rdaddress            => std_logic_vector(iTriggerMem.Addr(iTriggerMem.Addr'high downto cTriggerAlign)),
        rdclock              => iClkCPU,
        wraddress            => std_logic_vector(R.Addr),
        wrclock              => iClk,
        wren                 => R.WrEn(i),
        std_ulogic_vector(q) => DataOut(i));
  end generate;

  Convert : process (iData, iCPUPort.TriggerChannel, DataOut)
  begin
    for i in 0 to 3 loop
      for j in 0 to cCoefficients-1 loop
        DataIn(i)(8*(j+1)-1 downto 8*j) <= std_ulogic_vector(iData(i)(j));
        AlignData(i)(j)                 <= DataOut(i)(8*(j+1)-1 downto 8*j);
      end loop;
    end loop;
  end process;

  process (iClkCPU, iResetAsync)
    variable i : natural range 0 to cCoefficients-1;
  begin
    if iResetAsync = cResetActive then
      oTriggerMem.Data <= (others => '0');
      ReadValid        <= (others => '0');
      -- ReadAlign        <= (others => (others => '0'));
      ReadAlign        <= (others => '0');
    elsif rising_edge(iClkCPU) then
      ReadValid(ReadValid'low)                     <= iTriggerMem.Rd;
      ReadValid(ReadValid'low+1 to ReadValid'high) <= ReadValid(ReadValid'low to ReadValid'high-1);
      ReadAlign                                    <= iTriggerMem.Addr(cTriggerAlign-1 downto 0);
      
      for j in 0 to 3 loop
        oTriggerMem.Data((8*(j+1))-1 downto 8*j) <= std_ulogic_vector(AlignData(3-j)(i));
      end loop;
      i                                            := to_integer(ReadAlign);
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Trigger mode instances
  -----------------------------------------------------------------------------

  -- Trigger0 ExtTrigger L => H
  -- Trigger1 ExtTrigger H => L

  Ext : entity DSO.ExternalTrigger
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

  -- Trigger2 AnalogTrigger L => H
  -- Trigger3 AnalogTrigger H => L
  -- Trigger4 GlitchTrigger L => H
  -- Trigger5 GlitchTrigger H => L

  Normal : entity DSO.NormalTrigger
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
      oLHGlitch   => TriggerStrobes(4),
      oHLGlitch   => TriggerStrobes(5));

  -- Trigger6 Equal No  => Yes, for at minimum HighTime 
  -- Trigger7 Equal No, => Yes, for less than HighTime 

  Digital : entity DSO.DigitalTrigger
    port map (
      iClk          => iClk,
      iResetAsync   => iResetAsync,
      iValid        => TriggerInValid,
      iData         => TriggerData,
      iRef          => iCPUPort.LowValue,
      iMask         => iCPUPort.HighValue,
      iValidTime    => iCPUPort.HighTime,
      iInvalidTime  => iCPUPort.LowTime,
      oValid        => TriggerStrobes(6),
      oInvalid      => open,
      oShortValid   => TriggerStrobes(7),
      oShortInvalid => open);

end architecture;
