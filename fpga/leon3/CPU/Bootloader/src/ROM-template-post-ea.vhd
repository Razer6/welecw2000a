others => (others => '-'));
begin  -- Rtl
  ROM : process (iClk)
  begin  -- process write
    if iClk'event and iClk = '0' then   -- FALLING clock edge
      oData <= mem(to_integer(unsigned(iAddr(gAddrWidth-1 downto 0))));
    end if;
  end process;
end architecture;
