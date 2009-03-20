/* Author: Alexander Lindert <alexander_lindert at gmx.at>*/
/* File Generator License: GPL*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

main (argc, argv)
  int argc; char **argv;
{
  struct stat sbuf;
  char x[128];
  int i, res, fsize, abits, tmp;
  FILE *fp, *wfp;

  if (argc < 2) exit(1);
  res = stat(argv[1], &sbuf);
  if (res < 0) exit(2);
  fsize = sbuf.st_size;
  fp = fopen(argv[1], "rb");
  wfp = fopen(argv[2], "w+");
  if (fp == NULL) exit(2);
  if (wfp == NULL) exit(2);

  tmp = fsize; abits = 0;
  while (tmp) {tmp >>= 1; abits++;}
  printf("Creating %s : file size: %d bytes, address bits %d\n", argv[2], fsize, abits);
  fprintf(wfp, "\n\
-------------------------------------------------------------------------------\n\
-- File Generator Author: Alexander Lindert <alexander_lindert at gmx.at>\n\
-------------------------------------------------------------------------------\n\
-- Description: This boot rom is made in the same way like the ahbrom from\n\
--              Leon3 grlib\n\
-------------------------------------------------------------------------------\n\
-- File Generator License: GPL\n\
-------------------------------------------------------------------------------\n\
-- Revisions  :\n\
-- Date        Version\n\
-- 2009-02-12  1.0\n\
-------------------------------------------------------------------------------\n\
\n\
library ieee;\n\
use ieee.std_logic_1164.all;\n\
library grlib;\n\
use grlib.amba.all;\n\
use grlib.stdlib.all;\n\
use grlib.devices.all;\n\
\n\
entity BootRom is\n\
  generic (\n\
    pipe  : integer := 0);\n\
  port (\n\
    rstn  : in  std_ulogic;\n\
    clk   : in  std_ulogic;\n\
    ren   : in  std_ulogic;\n\
    iaddr : in  std_logic_vector(31 downto 2);\n\
    odata : out std_logic_vector(31 downto 0);\n\
    oACK  : out std_ulogic\n\
  );\n\
end;\n\
\n\
architecture rtl of BootRom is\n\
constant abits   : integer := %d;\n\
constant bytes   : integer := %d;\n\
signal   romdata, data : std_logic_vector(31 downto 0);\n\
signal   addr    : std_logic_vector(abits-1 downto 2);\n\
signal   ACK     : std_ulogic;\n\
\n\
begin\n\
\n\
  odata <= data when ACK = '1' else (others => 'Z');\n\
  oACK <= ACK;\n\
  reg : process (clk)\n\
  begin\n\
    if rising_edge(clk) then \n\
      addr <= iaddr(abits-1 downto 2);\n\
    end if;\n\
  end process;\n\
\n\
  p0 : if pipe = 0 generate\n\
         data  <= romdata;\n\
         ACK  <= not ren;\n\
  end generate;\n\
\n\
  p1 : if pipe = 1 generate\n\
    reg2 : process (clk, rstn)\n\
    begin\n\
      if rstn = '0' then\n\
         ACK <= '0';\n\
      elsif rising_edge(clk) then\n\
         ACK <= not ren;\n\
         data  <= romdata;\n\
      end if;\n\
    end process;\n\
  end generate;\n\
\n\
  comb : process (addr)\n\
  begin\n\
    case conv_integer(addr) is\n\
", abits, fsize, abits-1);

  i = 0;
  while (!feof(fp)) {
    fread(&tmp, 1, 4, fp);
    fprintf(wfp, "    when 16#%05X# => romdata <= X\"%08X\";\n", i++, htonl(tmp));
  }
  fprintf(wfp, "\
    when others => romdata <= (others => '-');\n\
    end case;\n\
  end process;\n\
  end;\n\
");

 fclose (wfp);
 fclose (fp);
 return(0);
 exit(0);
}
