library ieee;
use ieee.std_logic_1164.all;
use work.Global.all;
use work.pUart.all;

entity UartWrapper is
  port (
    iClk        : in  std_ulogic;
    iResetAsync : in  std_ulogic;
    iSRX        : in  std_ulogic;
    oSTX        : out std_ulogic;
    oRTS        : out std_ulogic;
    iCTS        : in  std_ulogic;
    oDTR        : out std_ulogic;
    iDSR        : in  std_ulogic;
    iRI         : in  std_ulogic;
    idcd        : in  std_ulogic;
    iCPU        : in  aCPUtoUart;
    oCPU        : out aUarttoCPU);
end entity;

