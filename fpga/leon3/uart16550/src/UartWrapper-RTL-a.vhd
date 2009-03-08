
architecture RTL of UartWrapper is

  component uart_top is
    port (
      wb_clk_i  : in  std_logic;
      -- Wishbone signals
      wb_rst_i  : in  std_logic;
      wb_adr_i  : in  std_logic_vector(cUART_ADDR_WIDTH-1 downto 0);
      wb_dat_i  : in  std_logic_vector(cUART_DATA_WIDTH-1 downto 0);
      wb_dat_o  : out std_logic_vector(cUART_DATA_WIDTH-1 downto 0);
      wb_we_i   : in  std_logic;
      wb_stb_i  : in  std_logic;
      wb_cyc_i  : in  std_logic;
      wb_ack_o  : out std_logic;
      wb_sel_i  : in  std_logic_vector(3 downto 0);
      int_o     : out std_logic;
      -- serial input/output
      stx_pad_o : out std_logic;
      srx_pad_i : in  std_logic;
      -- modem signals
      rts_pad_o : out std_logic;
      cts_pad_i : in  std_logic;
      dtr_pad_o : out std_logic;
      dsr_pad_i : in  std_logic;
      ri_pad_i  : in  std_logic;
      dcd_pad_i : in  std_logic);
  end component;

begin
  W : uart_top
    port map (
      wb_clk_i         => iClk,
      -- Wishbone signals
      wb_rst_i         => iResetAsync,
      wb_adr_i         => std_logic_vector(iCPU.Addr),
      wb_dat_i         => std_logic_vector(iCPU.Data),
      aDword(wb_dat_o)         => oCPU.Data,
      wb_we_i          => iCPU.WriteEn,
      wb_stb_i         => '1',
      wb_cyc_i         => '1',
      wb_ack_o         => oCPU.ACK,
      wb_sel_i         => (others => '1'),
      int_o            => oCPU.Interrupt,
      -- serial input/output
      stx_pad_o        => oSTX,
      srx_pad_i        => iSRX,
      -- modem signals
      rts_pad_o        => oRTS,
      cts_pad_i        => iCTS,
      dtr_pad_o        => oDTR,
      dsr_pad_i        => iDSR,
      ri_pad_i         => iRI,
      dcd_pad_i        => iDCD);

end architecture;
