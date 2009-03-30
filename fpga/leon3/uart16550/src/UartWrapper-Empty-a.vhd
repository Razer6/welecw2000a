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
  
  oCPU.ACK <= '0';

  oCPU.Interrupt <= '0';
  -- serial input/output
  oSTX           <= '0';
  oRTS           <= '0';
  oDTR           <= '0';
  
end architecture;
